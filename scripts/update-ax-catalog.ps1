#!/usr/bin/env pwsh
<#
.SYNOPSIS
Updates the @ax/* dependencies of the local apax catalog (@inxton/ax.catalog) to the latest versions,
bumps the catalog version, syncs every catalog consumer, and publishes the catalog (Phase 1); then
verifies the build (Phase 2, -AfterPublish).

.DESCRIPTION
The repo pins all Simatic AX (@ax/*) package versions centrally in the apax catalog at
src/ax.catalog/apax.yml (package @inxton/ax.catalog). The catalog CONSUMERS are the per-library
manifests src/<lib>/ctrl/apax.yml that declare a `catalogs:` block referencing @inxton/ax.catalog and
re-pin a subset of @ax/* packages in their own `dependencies:`. Consumers are discovered dynamically.

NOTE on ctrl/ and build noise: the consumer manifest lives at src/<lib>/ctrl/apax.yml (git-tracked) and
is the file apax install reads, so this script edits it directly. During `apax pack`, cake stamps the
GitVersion SemVer into each manifest's `version` and @inxton/* deps (it leaves @ax/* and the .catalog
reference alone - see cake BuildContext.UpdateApaxVersion/UpdateApaxDependencies). Those stamps are
unwanted build noise, so Phase 2 commits our edits, runs the build, then restores every build-touched
tracked file back to that commit and un-commits - leaving ONLY our @ax/catalog edits staged.

Editing files needs no published catalog - only the cake VERIFY build (which runs apax install) does.
So all editing + publishing happens in Phase 1, and verification is the separate Phase 2 (because a
published catalog version cannot be cleanly un-published, the build verification is deliberately AFTER
the publish - run it and inspect before relying on the new catalog):

  PHASE 1 (default) - refresh catalog + sync consumers + publish:
     1. Capture the current @ax/* versions.
     2. Resolve each @ax/* dep's highest non-deprecated version from the AX registry via
        `apax list -p <pkg>` (stable; -Prerelease widens to prereleases) and rewrite the catalog's
        catalogDependencies. (`apax update` is NOT used - it ignores a catalog's catalogDependencies.)
     3. If (and only if) at least one @ax/* dep changed: auto-bump the catalog `version` (patch, or
        -CatalogVersion), and sync every discovered consumer (src/<lib>/ctrl/apax.yml) - their explicit
        @ax/* pins to the new catalog versions and their `catalogs: "@inxton/ax.catalog"` reference.
     4. Write a report under scripts/reports/.
     5. Publish the catalog by invoking scripts/_pack_and_publish_catalog.ps1 (unless -NoPublish, or a
        -DryRun, or nothing changed). Then STOP - run -AfterPublish to verify.

  PHASE 2 (-AfterPublish) - verify:
     1. Re-assert consumer sync as an idempotent guard (normally a no-op).
     2. Pre-build commit ONLY our edited manifests (catalog + consumers).
     3. Verify with cake TESTS at level 2: `dotnet run --project cake/Build.csproj --do-test
        --test-level 2 -n` (cake runs apax install --catalog --strict + build per consumer, then the L2
        .NET test suite). Not pack - so cake does not stamp SemVer into the manifests.
     4. Discard build-produced changes WITHOUT touching your other uncommitted work: restore build-changed
        tracked files (excluding files that were already dirty before this run) back to the commit, then
        `git reset --soft HEAD~1` so our edits remain STAGED. No `git clean` (protects untracked files).

Phase 1 publishes automatically when there are changes; pass -NoPublish to keep the old manual gate.

.PARAMETER AfterPublish
Run Phase 2 (cake verify, with an idempotent consumer-sync guard). Use after Phase 1 has published.

.PARAMETER Prerelease
Include prerelease versions when resolving "latest" (otherwise the highest non-deprecated stable version
is used). Default: stable only.

.PARAMETER CatalogVersion
Explicit new catalog version (overrides the automatic patch bump). Phase 1 only.

.PARAMETER NoPublish
Phase 1 only: update + sync but do NOT auto-publish; print the manual publish/verify steps instead.

.PARAMETER DryRun
Preview everything; write no files, make no git changes, publish nothing, run no cake build.

.PARAMETER Detailed
Verbose logging.

.EXAMPLE
./update-ax-catalog.ps1 -DryRun -Detailed        # Phase 1 preview: @ax old->new, version, consumer edits

.EXAMPLE
./update-ax-catalog.ps1                           # Phase 1: refresh + bump + sync + auto-publish

.EXAMPLE
./update-ax-catalog.ps1 -NoPublish                # Phase 1: refresh + bump + sync, but DON'T publish

.EXAMPLE
./update-ax-catalog.ps1 -AfterPublish             # Phase 2: cake-verify, discard build noise
#>

[CmdletBinding()]
param(
    [switch]$AfterPublish,
    [switch]$Prerelease,
    [string]$CatalogVersion,
    [switch]$NoPublish,
    [switch]$DryRun,
    [switch]$Detailed
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$scriptRoot/_deps-common.ps1"

$repoRoot    = Split-Path -Parent $scriptRoot
$catalogDir  = Join-Path $repoRoot 'src/ax.catalog'
$catalogYml  = Join-Path $catalogDir 'apax.yml'
$cakeProj    = Join-Path $repoRoot 'cake/Build.csproj'
$catalogPkg  = '@inxton/ax.catalog'
$publishScript = Join-Path $scriptRoot '_pack_and_publish_catalog.ps1'

# Catalog consumers are DISCOVERED dynamically (see Get-CatalogConsumers): any apax.yml whose
# `catalogs:` block references @inxton/ax.catalog. This is the same marker cake's ApaxCatalogInstall
# keys on, so new libraries that adopt the catalog are picked up automatically.

# ---------------------------------------------------------------------------
# Small helpers
# ---------------------------------------------------------------------------
function Test-CommandAvailable { param([string]$Name) $null -ne (Get-Command $Name -ErrorAction SilentlyContinue) }

# Repo-root-relative, forward-slash path (matches `git status --porcelain` output).
function ConvertTo-RepoRelative {
    param([string]$Path)
    $full = [System.IO.Path]::GetFullPath($Path)
    $root = [System.IO.Path]::GetFullPath($repoRoot)
    if($full.StartsWith($root, [StringComparison]::OrdinalIgnoreCase)){
        $full = $full.Substring($root.Length).TrimStart('\','/')
    }
    return ($full -replace '\\','/')
}

# Dependency-line regexes. Tolerant of single/double quoting, any indentation, and an optional
# trailing comment (the catalog pins carry `# ...` provenance notes). Group layout for the dep
# regexes: 1=indent+openquote 2=key 3=closequote+colon+space 4=value-openquote 5=version
# 6=value-closequote 7=trailing (whitespace + optional #comment), preserved on rewrite.
$AxDepRx      = '^(\s+[''"]?)(@ax/[^''":\s]+)([''"]?\s*:\s*)([''"]?)([^''"\s#]+)([''"]?)(\s*(?:#.*)?)$'
$CatalogRefRx = '^(\s+[''"]?)(@inxton/ax\.catalog)([''"]?\s*:\s*)([''"]?)([^''"\s#]+)([''"]?)(\s*(?:#.*)?)$'
$VersionRx    = '^(version\s*:\s*)([''"]?)([^''"\s#]+)([''"]?)(\s*(?:#.*)?)$'

# Parse a top-level section of `key: value` deps and return @ax/* entries as an ordered map.
function Get-AxDepsInSection {
    param([string[]]$Lines, [string]$Section)
    $map = [ordered]@{}
    $cur = $null
    foreach($ln in $Lines){
        if($ln -match '^[A-Za-z]'){                          # zero-indent => a top-level key
            if($ln -match '^([A-Za-z][\w\.]*)\s*:'){ $cur = $Matches[1] }
            continue
        }
        if($cur -ne $Section){ continue }
        if($ln -match $AxDepRx){ $map[$Matches[2]] = $Matches[5] }
    }
    return $map
}

# True when these apax.yml lines declare a `catalogs:` block that references the catalog package.
function Test-IsCatalogConsumer {
    param([string[]]$Lines)
    $cur = $null
    foreach($ln in $Lines){
        if($ln -match '^[A-Za-z]'){
            if($ln -match '^([A-Za-z][\w\.]*)\s*:'){ $cur = $Matches[1] }
            continue
        }
        if($cur -eq 'catalogs' -and $ln -match $CatalogRefRx){ return $true }
    }
    return $false
}

# Discover every catalog consumer under src/: an apax.yml whose `catalogs:` block references
# @inxton/ax.catalog. In this repo the per-library manifest lives at src/<lib>/ctrl/apax.yml (tracked
# in git) - that IS the file we edit and that apax install reads. We exclude only the dependency-copy
# / build-output dirs (.apax cache, bin, obj, node_modules), NOT ctrl. Sorted, absolute.
function Get-CatalogConsumers {
    $srcRoot = Join-Path $repoRoot 'src'
    if(-not (Test-Path -LiteralPath $srcRoot)){ return @() }
    $excludeRx = '[\\/](bin|obj|\.apax|node_modules|wwwroot|dist|\.git|\.vs)[\\/]'
    $catalogFull = [System.IO.Path]::GetFullPath($catalogYml)
    Get-ChildItem -LiteralPath $srcRoot -Recurse -File -Filter 'apax.yml' -ErrorAction SilentlyContinue |
        Where-Object { $_.FullName -notmatch $excludeRx } |
        Where-Object { [System.IO.Path]::GetFullPath($_.FullName) -ne $catalogFull } |
        Where-Object { Test-IsCatalogConsumer -Lines (Get-Content -LiteralPath $_.FullName) } |
        Select-Object -ExpandProperty FullName |
        Sort-Object
}

# Read the top-level `version:` value from catalog content.
function Get-CatalogVersion {
    param([string[]]$Lines)
    foreach($ln in $Lines){ if($ln -match $VersionRx){ return $Matches[3] } }
    return $null
}

# Patch-bump a semver string (x.y.z -> x.y.(z+1)).
function Get-NextPatchVersion {
    param([string]$Version)
    $rec = ConvertTo-VersionRecord $Version
    return ('{0}.{1}.{2}' -f $rec.Major, $rec.Minor, ($rec.Patch + 1))
}

# Strip ANSI/VT escape sequences from apax's coloured output so it can be parsed.
function Remove-Ansi { param([string]$Text) return ([regex]::Replace($Text, "\x1B\[[0-9;]*[A-Za-z]", '')) }

# Query the AX registry for one package via `apax list -p <pkg>` and return its latest dist-tag plus the
# full version list (each flagged deprecated/prerelease). apax has no JSON mode and writes to stderr, so
# we merge streams, strip ANSI, and parse the "Versions" / "Tags(latest:)" sections. $LASTEXITCODE is
# unreliable here (apax emits info banners on stderr), so success is judged by whether we parsed a tag
# or any versions. Returns $null when the package can't be read.
function Get-AxPackageInfo {
    param([string]$Package, [int]$Retries = 2)
    # apax list can occasionally return an empty/partial response (registry warmup). Retry a couple of
    # times until we get output that contains a Versions/Tags section before giving up.
    $prevEap = $ErrorActionPreference
    $ErrorActionPreference = 'Continue'
    $clean = ''
    try {
        for($attempt = 0; $attempt -le $Retries; $attempt++){
            $raw = ''
            try { $raw = (& apax list -p $Package 2>&1 | Out-String) } catch { $raw = '' }
            $clean = Remove-Ansi $raw
            if($clean -match '(?m)^\s*(Versions|Tags)\s*$'){ break }
        }
    } finally { $ErrorActionPreference = $prevEap }
    $latest = $null
    $versions = New-Object System.Collections.ArrayList
    $inVersions = $false; $inTags = $false
    foreach($ln in ($clean -split "`r?`n")){
        $t = $ln.Trim()
        if($t -eq 'Versions'){ $inVersions = $true; $inTags = $false; continue }
        if($t -eq 'Tags'){ $inTags = $true; $inVersions = $false; continue }
        # A non-list, non-section header line ends the current section.
        if($t -match '^[A-Za-z]' -and $t -notmatch '^-\s'){ $inVersions = $false; $inTags = $false }
        if($inVersions -and $t -match '^-\s*([0-9][^\s]*)'){
            $v = $Matches[1]
            [void]$versions.Add([PSCustomObject]@{ Version=$v; Deprecated=($t -match 'deprecated'); Prerelease=(Test-IsPrerelease $v) })
        }
        if($inTags -and $t -match 'latest:\s*([^\s]+)'){ $latest = $Matches[1] }
    }
    if(-not $latest -and $versions.Count -eq 0){ return $null }
    return [PSCustomObject]@{ Package=$Package; Latest=$latest; Versions=@($versions) }
}

# Pick the version to move a package to: the HIGHEST non-deprecated published version. We deliberately
# do NOT use the registry 'latest' dist-tag, because on the AX registry it can point below the highest
# published version (e.g. @ax/ax2tia latest=11.1.25 while 12.2.8 is published) - taking it would
# downgrade a pin. Stable mode excludes prereleases; -Prerelease includes them. Returns $null if none.
function Select-TargetVersion {
    param($Info)
    if(-not $Info){ return $null }
    # Wrap the whole if-expression in @() - assigning a one-element array via `if` would unwrap it to a
    # scalar, breaking the .Count check under StrictMode.
    $cand = @(if($Prerelease){ $Info.Versions | Where-Object { -not $_.Deprecated } }
              else            { $Info.Versions | Where-Object { -not $_.Deprecated -and -not $_.Prerelease } })
    if($cand.Count -eq 0){ return $null }
    $best = $cand[0].Version
    foreach($c in $cand){ if(Test-VersionGreater $c.Version $best){ $best = $c.Version } }
    return $best
}

# True when moving From -> To crosses a major-version boundary (used to flag, not block).
function Test-IsMajorBump {
    param([string]$From,[string]$To)
    if([string]::IsNullOrWhiteSpace($From) -or [string]::IsNullOrWhiteSpace($To)){ return $false }
    return ((ConvertTo-VersionRecord $To).Major -gt (ConvertTo-VersionRecord $From).Major)
}

# Resolve the latest target version for every @ax/* key in $OldMap by querying the registry. Returns an
# ordered map (same key order as $OldMap). NEVER downgrades: if the resolved highest version is not
# strictly greater than the current pin, the current pin is kept (covers a lagging 'latest', a yanked
# higher version, or an already-current pin). Unresolvable keys keep their current version with a
# warning. Pure read - touches no file.
function Resolve-LatestAxVersions {
    param($OldMap)
    $newMap = [ordered]@{}
    $i = 0; $total = $OldMap.Count
    $updated = 0; $kept = 0; $failed = 0
    foreach($pkg in $OldMap.Keys){
        $i++
        $cur = $OldMap[$pkg]
        # Live progress: a progress bar plus a single rewriting status line, so 77 sequential registry
        # queries don't look frozen. (Write-Progress is suppressed in non-interactive hosts; the inline
        # counter still shows. -Detailed additionally logs the per-package outcome below.)
        $pct = [int](($i-1) * 100 / [Math]::Max($total,1))
        Write-Progress -Activity 'Resolving @ax/* latest versions' -Status ("[{0}/{1}] {2}" -f $i,$total,$pkg) -PercentComplete $pct
        Write-Host ("`r  [{0,2}/{1}] querying {2,-45}" -f $i,$total,$pkg) -NoNewline -ForegroundColor DarkGray

        $info = Get-AxPackageInfo -Package $pkg
        $target = Select-TargetVersion -Info $info
        if(-not $target){
            $failed++; $newMap[$pkg] = $cur
            Write-Host "`r" -NoNewline
            Write-Warn ("  [{0}/{1}] {2}: could not resolve latest - keeping {3}" -f $i,$total,$pkg,$cur)
            continue
        }
        if(Test-VersionGreater $target $cur){
            $updated++; $newMap[$pkg] = $target
            if($Detailed){ Write-Host "`r" -NoNewline; Write-Info ("  [{0}/{1}] {2}: {3} -> {4}" -f $i,$total,$pkg,$cur,$target) }
        } else {
            # Resolved version is <= current pin: keep current (no downgrade). Note when the registry's
            # highest is actually lower than what we have pinned.
            $kept++; $newMap[$pkg] = $cur
            if($Detailed){
                Write-Host "`r" -NoNewline
                if(Test-VersionGreater $cur $target){ Write-Info ("  [{0}/{1}] {2}: {3} (registry highest {4} is lower - kept)" -f $i,$total,$pkg,$cur,$target) }
                else { Write-Info ("  [{0}/{1}] {2}: {3} (already latest)" -f $i,$total,$pkg,$cur) }
            }
        }
    }
    Write-Host ("`r{0,-72}" -f '') -NoNewline; Write-Host "`r" -NoNewline   # clear the status line
    Write-Progress -Activity 'Resolving @ax/* latest versions' -Completed
    Write-Info ("Resolved {0} package(s): {1} to update, {2} already current, {3} unresolved." -f $total,$updated,$kept,$failed)
    return $newMap
}

# Rewrite the catalogDependencies section of the catalog file in place from $NewMap, preserving line
# formatting and trailing comments. Only @ax/* lines whose version changed are touched.
function Update-CatalogDepsFile {
    param([string]$Path, $NewMap)
    $lines = Get-Content -LiteralPath $Path
    $cur = $null
    $out = foreach($ln in $lines){
        if($ln -match '^[A-Za-z]'){
            if($ln -match '^([A-Za-z][\w\.]*)\s*:'){ $cur = $Matches[1] }
            $ln; continue
        }
        if($cur -eq 'catalogDependencies' -and $ln -match $AxDepRx){
            $pkg = $Matches[2]; $oldv = $Matches[5]
            if($NewMap.Contains($pkg) -and $NewMap[$pkg] -ne $oldv){
                "$($Matches[1])$pkg$($Matches[3])$($Matches[4])$($NewMap[$pkg])$($Matches[6])$($Matches[7])".TrimEnd(); continue
            }
            $ln; continue
        }
        $ln
    }
    Write-Utf8NoBom-LF -Path $Path -Content (($out -join "`n") + "`n")
}

# Pack + publish the catalog to the @inxton registry by invoking the existing pack/publish script.
# Returns $true on success. Requires APAX_KEY (and GH_USER/GH_TOKEN if the registry login isn't cached).
function Invoke-CatalogPublish {
    if(-not (Test-Path -LiteralPath $publishScript)){ Write-Err "Publish script not found: $publishScript"; return $false }
    if(-not $env:APAX_KEY){ Write-Err 'APAX_KEY is not set - cannot pack/publish the catalog. Set APAX_KEY (and GH_USER/GH_TOKEN) and re-run, or pass -NoPublish.'; return $false }
    Write-Info "Publishing catalog: $publishScript"
    $prevEap = $ErrorActionPreference
    $ErrorActionPreference = 'Continue'
    try { & $publishScript } finally { $ErrorActionPreference = $prevEap }
    if($LASTEXITCODE -and $LASTEXITCODE -ne 0){ Write-Err "Publish script exited with code $LASTEXITCODE."; return $false }
    return $true
}

# ---------------------------------------------------------------------------
# Report
# ---------------------------------------------------------------------------
function Write-Report {
    param([string]$Stamp, [string]$Phase, $Payload, [string]$MarkdownBody)
    $reportsDir = Join-Path $scriptRoot 'reports'
    if(-not (Test-Path $reportsDir)){ New-Item -ItemType Directory -Path $reportsDir -Force | Out-Null }
    $base     = "ax-catalog-$Phase-$Stamp"
    $mdPath   = Join-Path $reportsDir "$base.md"
    $jsonPath = Join-Path $reportsDir "$base.json"
    Write-Utf8NoBom-LF -Path $jsonPath -Content ($Payload | ConvertTo-Json -Depth 8)
    Write-Utf8NoBom-LF -Path $mdPath   -Content $MarkdownBody
    Write-Info "Report: $mdPath"
    return $mdPath
}

function Format-DiffTable {
    # Builds a markdown table of @ax old->new from two ordered maps.
    param($OldMap, $NewMap)
    $sb = New-Object System.Text.StringBuilder
    [void]$sb.AppendLine('| Package | From | To |')
    [void]$sb.AppendLine('|---|---|---|')
    $keys = @($OldMap.Keys) + @($NewMap.Keys) | Select-Object -Unique | Sort-Object
    foreach($k in $keys){
        $from = if($OldMap.Contains($k)){ $OldMap[$k] } else { '(new)' }
        $to   = if($NewMap.Contains($k)){ $NewMap[$k] } else { '(removed)' }
        if($from -ne $to){ [void]$sb.AppendLine("| $k | $from | $to |") }
    }
    return $sb.ToString()
}

# ===========================================================================
# PHASE 1 - refresh catalog
# ===========================================================================
function Invoke-Phase1 {
    param([string]$Stamp)
    Write-Info '== PHASE 1: refresh @inxton/ax.catalog =='
    if(-not (Test-CommandAvailable 'apax')){ Write-Err 'apax CLI not found on PATH.'; exit 2 }
    if(-not (Test-Path -LiteralPath $catalogYml)){ Write-Err "Catalog not found: $catalogYml"; exit 2 }

    $origLines   = Get-Content -LiteralPath $catalogYml
    $oldMap      = Get-AxDepsInSection -Lines $origLines -Section 'catalogDependencies'
    $oldVersion  = Get-CatalogVersion -Lines $origLines
    if(-not $oldVersion){ Write-Err 'Could not read catalog version field.'; exit 2 }
    Write-Info "Catalog at $oldVersion ($($oldMap.Count) @ax/* deps). Resolving latest versions..."

    # Resolve the latest version of every @ax/* dep by querying the AX registry directly with
    # `apax list -p <pkg>`. NOTE: `apax update` only touches dependencies/devDependencies "from the
    # apax.yml" - it does NOT update a catalog's catalogDependencies (verified: it reports "No updates
    # available" on this catalog), which is why we resolve each pin ourselves. This is a pure read; the
    # file is rewritten below only when something actually changed.
    $newMap = Resolve-LatestAxVersions -OldMap $oldMap

    # Diff summary (version-changed @ax/* deps; the set of keys is fixed by the catalog). Major bumps are
    # flagged for review but still applied.
    $changed = @()
    foreach($k in $newMap.Keys){
        if($oldMap[$k] -ne $newMap[$k]){ $changed += [PSCustomObject]@{ Package=$k; From=$oldMap[$k]; To=$newMap[$k]; IsMajor=(Test-IsMajorBump $oldMap[$k] $newMap[$k]) } }
    }
    $majors = @($changed | Where-Object { $_.IsMajor })

    # Bump the catalog version ONLY when something changed - no dependency change means no new version
    # to publish. On a real run we rewrite the catalogDependencies and the version in place; dry run
    # reports what WOULD change and writes nothing.
    $hasChanges = ($changed.Count -gt 0)
    $newVersion = if($hasChanges){ if($CatalogVersion){ $CatalogVersion } else { Get-NextPatchVersion $oldVersion } } else { $oldVersion }
    if($hasChanges -and -not $DryRun){
        Update-CatalogDepsFile -Path $catalogYml -NewMap $newMap
        $afterLines = Get-Content -LiteralPath $catalogYml
        $bumped = $afterLines | ForEach-Object {
            if($_ -match $VersionRx){ "$($Matches[1])$($Matches[2])$newVersion$($Matches[4])$($Matches[5])".TrimEnd() } else { $_ }
        }
        Write-Utf8NoBom-LF -Path $catalogYml -Content (($bumped -join "`n") + "`n")
        Write-Info "Updated $($changed.Count) @ax/* dep(s); bumped catalog version $oldVersion -> $newVersion."
    } elseif(-not $hasChanges){
        Write-Info 'No @ax/* dependency changes - catalog left unchanged (version NOT bumped).'
    }

    Write-Host ''
    Write-Host '================ CATALOG PLAN ================' -ForegroundColor Cyan
    Write-Host ("  @ax deps changed : {0} / {1}" -f $changed.Count, $newMap.Count)
    Write-Host ("  Major bumps      : {0}" -f $majors.Count)
    if($hasChanges){ Write-Host ("  Catalog version  : {0} -> {1}" -f $oldVersion, $newVersion) }
    else           { Write-Host ("  Catalog version  : {0} (unchanged - no dep updates)" -f $oldVersion) }
    Write-Host '=============================================' -ForegroundColor Cyan
    foreach($c in $changed){ Write-Info ("  {0}: {1} -> {2}{3}" -f $c.Package, $c.From, $c.To, $(if($c.IsMajor){' [MAJOR]'}else{''})) }
    if($majors.Count -gt 0){ Write-Warn "$($majors.Count) MAJOR-version bump(s) included - review before publishing." }

    # Sync consumers in the SAME phase - editing files needs no published catalog (only the cake verify
    # build in Phase 2 does), so the catalog + all consumer edits land as one reviewable diff before
    # publish. We pass the freshly-resolved map/version so dry-run preview is accurate even though the
    # catalog file isn't written yet. Skipped entirely when nothing changed.
    $sync = $null
    if($hasChanges){
        Write-Host ''
        $sync = Invoke-ConsumerSync -CatMap $newMap -CatVersion $newVersion
    }

    # Report.
    $md = New-Object System.Text.StringBuilder
    [void]$md.AppendLine('# @ax catalog update - Phase 1 (refresh + sync)')
    [void]$md.AppendLine('')
    [void]$md.AppendLine("- Generated: $Stamp")
    [void]$md.AppendLine("- Dry run: $([bool]$DryRun)")
    [void]$md.AppendLine("- Prerelease: $([bool]$Prerelease)")
    [void]$md.AppendLine("- Catalog version: $oldVersion -> $newVersion")
    [void]$md.AppendLine("- @ax deps changed: $($changed.Count) of $($newMap.Count)")
    [void]$md.AppendLine("- Major-version bumps: $($majors.Count)")
    [void]$md.AppendLine("- Consumer edits: $(if($sync){$sync.TotalEdits}else{0})")
    [void]$md.AppendLine('')
    if($majors.Count -gt 0){
        [void]$md.AppendLine("## [!] Major-version bumps ($($majors.Count)) - review carefully")
        [void]$md.AppendLine('| Package | From | To |')
        [void]$md.AppendLine('|---|---|---|')
        foreach($c in $majors){ [void]$md.AppendLine("| $($c.Package) | $($c.From) | $($c.To) |") }
        [void]$md.AppendLine('')
    }
    [void]$md.AppendLine('## Changed @ax dependencies')
    [void]$md.Append((Format-DiffTable -OldMap $oldMap -NewMap $newMap))
    if($sync -and $sync.TotalEdits -gt 0){
        [void]$md.AppendLine('')
        [void]$md.AppendLine('## Consumer edits')
        Add-ConsumerDiffMarkdown -Sb $md -Results $sync.Results
    }
    $payload = [PSCustomObject]@{
        phase='1-refresh-sync'; timestamp=$Stamp; dryRun=[bool]$DryRun; prerelease=[bool]$Prerelease
        catalogVersionFrom=$oldVersion; catalogVersionTo=$newVersion; changed=$changed
        consumerEdits=$(if($sync){$sync.TotalEdits}else{0})
        consumers=@(if($sync){ $sync.Results | ForEach-Object { [PSCustomObject]@{ file=(ConvertTo-RepoRelative $_.File); edits=$_.Edits } } })
    }
    Write-Report -Stamp $Stamp -Phase 'phase1' -Payload $payload -MarkdownBody $md.ToString() | Out-Null

    Write-Host ''
    if(-not $hasChanges){
        Write-Info 'All @ax/* dependencies already at their latest. Nothing to publish; no Phase 2 needed.'
        return
    }
    if($DryRun){
        Write-Warn "[DRY RUN] $($changed.Count) @ax/* dep(s) would change; catalog would bump $oldVersion -> $newVersion; $($sync.TotalEdits) consumer edit(s)."
        Write-Warn "[DRY RUN] Would then publish the catalog$(if($NoPublish){' (SKIPPED: -NoPublish)'}else{''}) and stop for build verification. Re-run without -DryRun to apply."
        return
    }

    # Real run with changes: publish the catalog automatically (per user request), unless -NoPublish.
    if($NoPublish){
        Write-Info 'Catalog + consumers updated. Publish skipped (-NoPublish). NEXT STEPS:'
        Write-Info "  1. Review the diff:   git diff -- src/ax.catalog/apax.yml 'src/**/ctrl/apax.yml'"
        Write-Info "  2. Publish the catalog:  pwsh scripts/_pack_and_publish_catalog.ps1   (needs APAX_KEY, GH_USER, GH_TOKEN)"
        Write-Info "  3. Verify the build:  pwsh scripts/update-ax-catalog.ps1 -AfterPublish"
        return
    }

    Write-Host ''
    if(Invoke-CatalogPublish){
        Write-Info "Catalog @inxton/ax.catalog $newVersion published."
        Write-Info 'NEXT STEP - verify the build:  pwsh scripts/update-ax-catalog.ps1 -AfterPublish'
    } else {
        Write-Err 'Automatic publish FAILED. The catalog + consumer edits are on disk but NOT published.'
        Write-Err "Fix the cause (e.g. set APAX_KEY/GH_USER/GH_TOKEN), then run: pwsh scripts/_pack_and_publish_catalog.ps1"
        Write-Err 'After a successful publish, run: pwsh scripts/update-ax-catalog.ps1 -AfterPublish'
        exit 4
    }
}

# ===========================================================================
# PHASE 2 - sync consumers + verify
# ===========================================================================

# Rewrite one consumer file in place (or preview): sync @ax/* pins + catalog ref to $CatVersion/$CatMap.
# Returns a PSCustomObject with the file's applied edits.
function Update-ConsumerFile {
    param([string]$Path, $CatMap, [string]$CatVersion)
    $lines = Get-Content -LiteralPath $Path
    $edits = New-Object System.Collections.ArrayList
    $cur = $null
    $out = for($i=0; $i -lt $lines.Count; $i++){
        $ln = $lines[$i]
        if($ln -match '^[A-Za-z]'){
            if($ln -match '^([A-Za-z][\w\.]*)\s*:'){ $cur = $Matches[1] }
            $ln; continue
        }
        if($cur -eq 'dependencies' -and $ln -match $AxDepRx){
            $pkg = $Matches[2]; $oldv = $Matches[5]
            if($CatMap.Contains($pkg) -and $CatMap[$pkg] -ne $oldv){
                [void]$edits.Add([PSCustomObject]@{ Package=$pkg; From=$oldv; To=$CatMap[$pkg] })
                "$($Matches[1])$pkg$($Matches[3])$($Matches[4])$($CatMap[$pkg])$($Matches[6])$($Matches[7])".TrimEnd(); continue
            }
            $ln; continue
        }
        if($cur -eq 'catalogs' -and $ln -match $CatalogRefRx){
            $oldv = $Matches[5]
            if($oldv -ne $CatVersion){
                [void]$edits.Add([PSCustomObject]@{ Package=$catalogPkg; From=$oldv; To=$CatVersion })
                "$($Matches[1])$($Matches[2])$($Matches[3])$($Matches[4])$CatVersion$($Matches[6])$($Matches[7])".TrimEnd(); continue
            }
            $ln; continue
        }
        $ln
    }
    if($edits.Count -gt 0 -and -not $DryRun){
        Write-Utf8NoBom-LF -Path $Path -Content (($out -join "`n") + "`n")
    }
    return [PSCustomObject]@{ File=$Path; Edits=@($edits) }
}

# Discover catalog consumers and sync each one's @ax/* pins + `catalogs:` ref to the catalog. Applies
# edits in place (preview only when -DryRun). $CatMap/$CatVersion may be supplied explicitly (Phase 1
# passes the freshly-resolved values so dry-run preview is accurate even though the catalog file is not
# written yet); when omitted they are read from the catalog file (Phase 2, post-publish). Returns the
# discovered consumers, per-file edit results, and the totals.
function Invoke-ConsumerSync {
    param($CatMap, [string]$CatVersion)
    if(-not $CatMap -or -not $CatVersion){
        $catLines = Get-Content -LiteralPath $catalogYml
        if(-not $CatMap){ $CatMap = Get-AxDepsInSection -Lines $catLines -Section 'catalogDependencies' }
        if(-not $CatVersion){ $CatVersion = Get-CatalogVersion -Lines $catLines }
    }
    if(-not $CatVersion){ Write-Err 'Could not determine catalog version for consumer sync.'; exit 2 }

    $consumerYmls = @(Get-CatalogConsumers)
    if($consumerYmls.Count -eq 0){ Write-Err 'No catalog consumers discovered (no apax.yml references @inxton/ax.catalog).'; exit 2 }
    Write-Info "Syncing $($consumerYmls.Count) consumer(s) to catalog @ $CatVersion ($($CatMap.Count) @ax/* deps):"
    $results = foreach($c in $consumerYmls){
        $r = Update-ConsumerFile -Path $c -CatMap $CatMap -CatVersion $CatVersion
        $rel = ConvertTo-RepoRelative $c
        if($r.Edits.Count -gt 0){
            Write-Info "  $rel : $($r.Edits.Count) edit(s)"
            foreach($e in $r.Edits){ if($Detailed){ Write-Info ("      {0}: {1} -> {2}" -f $e.Package,$e.From,$e.To) } }
        } elseif($Detailed){ Write-Info "  $rel : already in sync" }
        $r
    }
    $totalEdits = (@($results) | ForEach-Object { $_.Edits.Count } | Measure-Object -Sum).Sum
    return [PSCustomObject]@{ Consumers=$consumerYmls; Results=@($results); CatVersion=$CatVersion; TotalEdits=$totalEdits }
}

# Append a per-consumer edit table section to a markdown StringBuilder.
function Add-ConsumerDiffMarkdown {
    param([System.Text.StringBuilder]$Sb, $Results)
    foreach($r in @($Results)){
        if($r.Edits.Count -eq 0){ continue }
        [void]$Sb.AppendLine("### $(ConvertTo-RepoRelative $r.File) ($($r.Edits.Count))")
        [void]$Sb.AppendLine('| Package | From | To |')
        [void]$Sb.AppendLine('|---|---|---|')
        foreach($e in $r.Edits){ [void]$Sb.AppendLine("| $($e.Package) | $($e.From) | $($e.To) |") }
        [void]$Sb.AppendLine('')
    }
}

function Invoke-Phase2 {
    param([string]$Stamp)
    Write-Info '== PHASE 2: verify (consumers synced in Phase 1) =='
    if(-not (Test-Path -LiteralPath $catalogYml)){ Write-Err "Catalog not found: $catalogYml"; exit 2 }

    # Re-assert consumer sync as an idempotent guard: Phase 1 already synced them, but the catalog may
    # have moved (e.g. a re-publish) or a new consumer may have appeared. Reads map/version from the
    # (now-published) catalog file. Normally a no-op.
    $sync = Invoke-ConsumerSync
    if($sync.TotalEdits -gt 0){ Write-Warn "$($sync.TotalEdits) consumer edit(s) applied in Phase 2 (Phase 1 sync was incomplete or stale)." }
    else { Write-Info 'Consumers already in sync with the catalog.' }

    $buildResult = if($DryRun){ 'not-run (dry run)' } else { Invoke-VerifyAndDiscardBuildNoise -Consumers $sync.Consumers }

    # Report.
    $md = New-Object System.Text.StringBuilder
    [void]$md.AppendLine('# @ax catalog update - Phase 2 (verify)')
    [void]$md.AppendLine('')
    [void]$md.AppendLine("- Generated: $Stamp")
    [void]$md.AppendLine("- Dry run: $([bool]$DryRun)")
    [void]$md.AppendLine("- Catalog version: $($sync.CatVersion)")
    [void]$md.AppendLine("- Consumer edits (this phase): $($sync.TotalEdits)")
    [void]$md.AppendLine("- Build result: **$buildResult**")
    [void]$md.AppendLine('')
    if($sync.TotalEdits -gt 0){
        [void]$md.AppendLine('## Consumer edits (Phase 2 guard)')
        Add-ConsumerDiffMarkdown -Sb $md -Results $sync.Results
    }
    $payload = [PSCustomObject]@{
        phase='2-verify'; timestamp=$Stamp; dryRun=[bool]$DryRun; catalogVersion=$sync.CatVersion
        build=$buildResult; consumerEditsThisPhase=$sync.TotalEdits
        consumers=@($sync.Results | ForEach-Object { [PSCustomObject]@{ file=(ConvertTo-RepoRelative $_.File); edits=$_.Edits } })
    }
    Write-Report -Stamp $Stamp -Phase 'phase2' -Payload $payload -MarkdownBody $md.ToString() | Out-Null

    Write-Host ''
    Write-Host '================ PHASE 2 SUMMARY ================' -ForegroundColor Cyan
    Write-Host ("  Consumer edits : {0}" -f $sync.TotalEdits)
    Write-Host ("  Build          : {0}" -f $buildResult)
    Write-Host '=================================================' -ForegroundColor Cyan

    if($DryRun){ Write-Warn '[DRY RUN] Nothing written, no build run.'; return }
    if($buildResult -like 'FAIL*'){ Write-Err 'Build verification FAILED - edits left staged for inspection.'; exit 1 }
}

# Pre-build commit our files, run cake, then surgically discard build-produced changes and un-commit
# so our edits remain staged. Returns a build-result string. Never touches files that were already
# dirty before this run, and never runs `git clean`.
function Invoke-VerifyAndDiscardBuildNoise {
    param([string[]]$Consumers)
    if(-not (Test-CommandAvailable 'git')){ Write-Err 'git not found; cannot safely verify.'; return 'FAIL (git unavailable)' }
    if(-not (Test-CommandAvailable 'dotnet')){ Write-Err 'dotnet not found; cannot build.'; return 'FAIL (dotnet unavailable)' }

    # Refuse to run mid-merge / detached HEAD.
    $headRef = (& git -C $repoRoot symbolic-ref --quiet HEAD 2>$null)
    if($LASTEXITCODE -ne 0){ Write-Err 'Detached HEAD or no branch; aborting Phase 2 git steps.'; return 'FAIL (detached HEAD)' }
    if(Test-Path (Join-Path $repoRoot '.git/MERGE_HEAD')){ Write-Err 'Merge in progress; aborting.'; return 'FAIL (merge in progress)' }

    # Files that were already dirty BEFORE this run (excluding our own allowlist) must never be restored.
    # Our edits are the source manifests only; ctrl/apax.yml and apax-lock.json are gitignored generated
    # output and never appear in git status, so they need no special handling.
    $allowlist = New-Object System.Collections.Generic.HashSet[string] ([StringComparer]::OrdinalIgnoreCase)
    foreach($f in (@($catalogYml) + $Consumers)){ [void]$allowlist.Add((ConvertTo-RepoRelative $f)) }

    $preExistingDirty = New-Object System.Collections.Generic.HashSet[string] ([StringComparer]::OrdinalIgnoreCase)
    foreach($line in (& git -C $repoRoot status --porcelain)){
        if($line.Length -lt 4){ continue }
        $p = $line.Substring(3).Trim('"')
        if($p -match ' -> '){ $p = ($p -split ' -> ')[-1].Trim('"') }   # rename: keep destination
        if(-not $allowlist.Contains($p)){ [void]$preExistingDirty.Add($p) }
    }
    if($Detailed -and $preExistingDirty.Count -gt 0){
        Write-Info "Protecting $($preExistingDirty.Count) pre-existing dirty path(s) from discard:"
        foreach($p in $preExistingDirty){ Write-Info "    $p" }
    }

    # Pre-build commit of ONLY our files.
    $addPaths = @($catalogYml) + $Consumers | ForEach-Object { ConvertTo-RepoRelative $_ }
    & git -C $repoRoot add -- $addPaths
    & git -C $repoRoot diff --cached --quiet
    $committed = ($LASTEXITCODE -ne 0)   # non-zero => there ARE staged changes
    if($committed){
        & git -C $repoRoot commit -q -m @"
chore(catalog): update @ax deps + bump ax.catalog

Automated by scripts/update-ax-catalog.ps1.

Co-Authored-By: Claude Opus 4.8 (1M context) <noreply@anthropic.com>
"@
        if($LASTEXITCODE -ne 0){ Write-Err 'Pre-build commit failed.'; return 'FAIL (pre-build commit)' }
        Write-Info 'Committed catalog + consumer edits (temporary; un-committed after verification).'
    } else {
        Write-Warn 'No catalog/consumer changes to commit; running build verification anyway.'
    }

    # Verify with cake TESTS at level 2 (NOT pack). Level-2 runs apax install --catalog --strict +
    # build per consumer and the L2 .NET test suite, which is what we want to prove the new catalog
    # resolves and builds. We deliberately do NOT pack (--do-pack), so cake also won't stamp GitVersion
    # SemVer into the manifests - the only remaining noise is apax install churn, handled below.
    Write-Info 'Verifying: dotnet run --project cake/Build.csproj --do-test --test-level 2 -n'
    & dotnet run --project $cakeProj -- --do-test --test-level 2 -n
    $buildOk = ($LASTEXITCODE -eq 0)

    # Discard build/test-produced changes to TRACKED files (everything dirty vs HEAD that we did not
    # already flag as pre-existing) - e.g. apax install churn during the test run. We never `git clean`
    # (untracked files - incl. yours - are left alone).
    $toRestore = New-Object System.Collections.ArrayList
    foreach($p in (& git -C $repoRoot diff --name-only HEAD)){
        $pp = $p.Trim('"')
        if(-not $preExistingDirty.Contains($pp)){ [void]$toRestore.Add($pp) }
    }
    if($toRestore.Count -gt 0){
        Write-Info "Discarding $($toRestore.Count) build-produced change(s) to tracked files."
        & git -C $repoRoot checkout -- $toRestore
    }
    $newUntracked = @(& git -C $repoRoot ls-files --others --exclude-standard) | Where-Object { -not $preExistingDirty.Contains($_.Trim('"')) }
    if($newUntracked.Count -gt 0){
        Write-Warn "$($newUntracked.Count) new untracked file(s) left by the build (NOT removed - clean manually if unwanted):"
        foreach($u in ($newUntracked | Select-Object -First 20)){ Write-Warn "    $u" }
    }

    # Un-commit so our edits remain STAGED (build noise already discarded).
    if($committed){
        & git -C $repoRoot reset --soft HEAD~1
        if($LASTEXITCODE -ne 0){ Write-Warn 'Could not soft-reset; the pre-build commit remains in history.' }
        else { Write-Info 'Un-committed: catalog + consumer edits are now staged.' }
    }

    if($buildOk){ return 'pass (test-level 2)' } else { return 'FAIL (cake test-level 2 - edits left staged)' }
}

# ===========================================================================
# Main
# ===========================================================================
$stamp = (Get-Date).ToString('yyyy-MM-dd-HHmmss')
Write-Info "update-ax-catalog  (afterPublish=$AfterPublish, dryRun=$DryRun, prerelease=$Prerelease)"
if($DryRun){ Write-Warn 'DRY RUN - no files, no git, no build.' }

if($AfterPublish){ Invoke-Phase2 -Stamp $stamp } else { Invoke-Phase1 -Stamp $stamp }
exit 0
