<#
.SYNOPSIS
  Updates all AXSharp.* package and tool versions to the latest (or specified) AXSharp.ixc version.

.DESCRIPTION
  1. Fetches the latest version of the NuGet package AXSharp.ixc (dotnet tool) from NuGet (flat container API).
  2. Optionally allows overriding the version via -Version parameter.
  3. Updates versions for:
       - .config/dotnet-tools.json (all tools whose name starts with AXSharp.)
       - src/Directory.Packages.props (all <PackageVersion Include="AXSharp.*" ... /> entries)
  4. Supports -DryRun to preview changes and -Verbose for detailed logging.

.PARAMETER Version
  Explicit version to set instead of auto-detecting the latest from NuGet.

.PARAMETER DryRun
  If set, no files are modified; proposed changes are displayed.

.EXAMPLE
  pwsh -File scripts/update_axsharp_versions.ps1

.EXAMPLE
  pwsh -File scripts/update_axsharp_versions.ps1 -Version 0.40.1-alpha.300 -DryRun

.NOTES
  The script uses simple regex-based replacements to preserve original formatting and comments.
  Requires PowerShell 5+ (ships with Windows) and internet access to reach api.nuget.org when auto-detecting the version.
#>
[CmdletBinding()]
param(
    [string]$Version,
    [switch]$DryRun,
    [switch]$Detailed,
    [string]$Source = 'https://nuget.pkg.github.com/inxton', # Can be base or full index.json URL
    [string]$Username,  # Optional for private feed auth (GitHub Packages). If omitted and Token supplied, 'USERNAME' placeholder is used.
    [string]$Token,     # Personal Access Token or NuGet API key for private feed (PAT needs packaging:read scope)
    [switch]$NormalizeJson, # When set, rewrites dotnet-tools.json with standard compact formatting instead of preserving existing indentation
    [switch]$ListAvailable, # If set, lists available versions (after auth) and exits (unless -Version also supplied)
    [string]$PackageId = 'AXSharp.ixc' # Package ID to inspect for version discovery
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Write-Info($msg){ Write-Host "[INFO ] $msg" -ForegroundColor Cyan }
function Write-Warn($msg){ Write-Host "[WARN ] $msg" -ForegroundColor Yellow }
function Write-Err ($msg){ Write-Host "[ERROR] $msg" -ForegroundColor Red }

$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$repoRoot = Split-Path -Parent $scriptRoot
$toolsJsonPath = Join-Path $repoRoot '.config/dotnet-tools.json'
$propsPath = Join-Path $repoRoot 'src/Directory.Packages.props'

if(-not (Test-Path $toolsJsonPath)){ Write-Err ".config/dotnet-tools.json not found at $toolsJsonPath"; exit 1 }
if(-not (Test-Path $propsPath)){ Write-Err "Directory.Packages.props not found at $propsPath"; exit 1 }

if(-not $Version){
    # Discover token from environment if not explicitly provided
    if(-not $Token){
        $envTokenCandidates = @('AXSHARP_FEED_TOKEN','GITHUB_PACKAGES_TOKEN','GITHUB_TOKEN','GH_TOKEN','NUGET_TOKEN')
        foreach($c in $envTokenCandidates){
            if(-not $Token){
                $candidate = [Environment]::GetEnvironmentVariable($c)
                if($candidate){
                    $Token = $candidate
                    if($Detailed){ Write-Info "Using token from environment variable $c" }
                }
            }
        }
    }
    Write-Info "Discovering latest $PackageId version from source: $Source ..."
    function Get-PackageVersionsFromFeed {
        param([string]$Feed,[string]$PackageId,[string]$User,[string]$Tok)
        $serviceIndexUrl = if($Feed.ToLower().EndsWith('index.json')) { $Feed } else { ($Feed.TrimEnd('/')) + '/index.json' }
        $headers = @{}
        if($Tok){
            $u = if($User){$User}else{'USERNAME'}
            $basic = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $u,$Tok)))
            $headers['Authorization'] = "Basic $basic"
        }
        try {
            $si = Invoke-RestMethod -Uri $serviceIndexUrl -Headers $headers -TimeoutSec 30
        } catch {
            throw "Failed to access service index ($serviceIndexUrl): $($_.Exception.Message)"
        }
        if(-not $si.resources){ throw "Service index missing resources at $serviceIndexUrl" }
        $pkgBase = ($si.resources | Where-Object { $_.'@type' -eq 'PackageBaseAddress/3.0.0' } | Select-Object -First 1).'@id'
        if(-not $pkgBase){ throw 'PackageBaseAddress/3.0.0 resource not found in service index.' }
        if($pkgBase[-1] -ne '/') { $pkgBase += '/' }
        $lowerId = $PackageId.ToLower()
        $indexUrl = "$pkgBase$lowerId/index.json"
        try {
            $idx = Invoke-RestMethod -Uri $indexUrl -Headers $headers -TimeoutSec 30
        } catch {
            if($_.Exception.Response.StatusCode.Value__ -eq 401){ throw '401 Unauthorized (missing or invalid token). Provide -Token (PAT with read:packages) and -Username (GitHub user / org if required).' }
            throw "Failed to fetch version index ($indexUrl): $($_.Exception.Message)"
        }
        if(-not $idx.versions){ throw "No versions list at $indexUrl" }
        return $idx.versions
    }
    try {
        $allVersions = Get-PackageVersionsFromFeed -Feed $Source -PackageId $PackageId -User $Username -Tok $Token
        function ConvertTo-VersionRecord {
            param([string]$v)
            # Split core & prerelease (ignore +build metadata for ordering)
            $core = $v
            $pre = ''
            $buildSplit = $core.Split('+',2)
            if($buildSplit.Count -gt 1){ $core = $buildSplit[0] }
            $dashIdx = $core.IndexOf('-')
            if($dashIdx -ge 0){
                $pre = $core.Substring($dashIdx + 1)
                $core = $core.Substring(0,$dashIdx)
            }
            $parts = $core.Split('.')
            [int]$maj = if($parts.Count -gt 0){ $parts[0] } else { 0 }
            [int]$min = if($parts.Count -gt 1){ $parts[1] } else { 0 }
            [int]$pat = if($parts.Count -gt 2){ $parts[2] } else { 0 }
            $preSegs = @()
            if($pre){ $preSegs = $pre.Split('.') }
            [PSCustomObject]@{ Original=$v; Major=$maj; Minor=$min; Patch=$pat; Pre=$pre; PreSegs=$preSegs }
        }
        function Compare-VersionRecord { param($a,$b)
            if($a.Major -ne $b.Major){ return [Math]::Sign($a.Major - $b.Major) }
            if($a.Minor -ne $b.Minor){ return [Math]::Sign($a.Minor - $b.Minor) }
            if($a.Patch -ne $b.Patch){ return [Math]::Sign($a.Patch - $b.Patch) }
            $aHasPre = [string]::IsNullOrEmpty($a.Pre) -ne $true
            $bHasPre = [string]::IsNullOrEmpty($b.Pre) -ne $true
            if($aHasPre -and -not $bHasPre){ return -1 }
            if($bHasPre -and -not $aHasPre){ return 1 }
            if(-not $aHasPre -and -not $bHasPre){ return 0 }
            $len = [Math]::Max($a.PreSegs.Count,$b.PreSegs.Count)
            for($i=0;$i -lt $len;$i++){
                if($i -ge $a.PreSegs.Count){ return -1 }
                if($i -ge $b.PreSegs.Count){ return 1 }
                $as = $a.PreSegs[$i]; $bs = $b.PreSegs[$i]
                $aNum = $as -as [int]; $bNum = $bs -as [int]
                $aIsNum = $aNum -ne $null; $bIsNum = $bNum -ne $null
                if($aIsNum -and $bIsNum){ if($aNum -ne $bNum){ return [Math]::Sign($aNum - $bNum) } }
                elseif($aIsNum -and -not $bIsNum){ return -1 }
                elseif($bIsNum -and -not $aIsNum){ return 1 }
                else { $cmp = [string]::Compare($as,$bs,$true); if($cmp -ne 0){ return [Math]::Sign($cmp) } }
            }
            return 0
        }
        $records = $allVersions | ForEach-Object { ConvertTo-VersionRecord $_ }
        # Sort descending using Compare-VersionRecord (custom) by leveraging Sort-Object with script block producing composite sort keys is tricky; perform manual selection.
        $latest = $records[0]
        foreach($r in $records){ if( (Compare-VersionRecord $r $latest) -gt 0){ $latest = $r } }
        if($ListAvailable){
            Write-Host ("Available versions for {0}:" -f $PackageId) -ForegroundColor Cyan
            $sorted = @($records)
            # Simple bubble to display descending semver order by repeatedly selecting max (for small list acceptable).
            $ordered = @()
            $work = @($records)
            while($work.Count -gt 0){
                $max = $work[0]; for($i=1;$i -lt $work.Count;$i++){ if( (Compare-VersionRecord $work[$i] $max) -gt 0){ $max = $work[$i] } }
                $ordered += $max; $work = $work | Where-Object { $_ -ne $max }
            }
            foreach($o in $ordered){ Write-Host "  $($o.Original)" }
            if(-not $Version){ Write-Info 'Exiting after listing versions (no -Version specified).'; exit 0 }
        }
        $Version = $latest.Original
        Write-Info "Latest version detected: $Version"
    }
    catch {
        Write-Err "Failed to fetch versions from feed: $_"
        Write-Warn 'Provide a PAT via -Token or environment (AXSHARP_FEED_TOKEN / GITHUB_TOKEN) with read:packages scope, or pass -Version manually.'
        if($Detailed){ Write-Warn 'For GitHub Packages: create a classic PAT with read:packages scope or fine-grained token granting read to the package.' }
        exit 2
    }
} else {
    Write-Info "Using provided version: $Version"
}

# Basic sanity check
if($Version -notmatch '^[0-9]+\.[0-9]+\.[0-9]+' ){ Write-Warn "Version '$Version' does not look like a typical semver (may still be fine)." }

$changes = @()

### Update .config/dotnet-tools.json
Write-Info 'Processing dotnet-tools.json...'
$toolsRaw = Get-Content -Raw -Path $toolsJsonPath
try { $toolsObj = $toolsRaw | ConvertFrom-Json -ErrorAction Stop }
catch { Write-Err "Failed to parse tools JSON: $_"; exit 3 }

if(-not $toolsObj.tools){ Write-Err "Unexpected JSON structure: missing 'tools' property."; exit 3 }

$axToolKeys = $toolsObj.tools.PSObject.Properties.Name | Where-Object { $_ -like 'AXSharp.*' }
foreach($k in $axToolKeys){
    $current = $toolsObj.tools.$k.version
    if($current -ne $Version){
        $changes += "dotnet-tools.json: $k $current -> $Version"
        if(-not $DryRun){ $toolsObj.tools.$k.version = $Version }
    } else {
        if($Detailed){ Write-Info "Tool $k already at $Version" }
    }
}

if(-not $DryRun){
    if($NormalizeJson){
        $newJson = $toolsObj | ConvertTo-Json -Depth 10
        # Normalize spacing after colons to a single space
        $newJson = ($newJson -split "`r?`n") | ForEach-Object { $_ -replace '":\s+','": ' } | Out-String
        Set-Content -Path $toolsJsonPath -Value ($newJson.TrimEnd() + [Environment]::NewLine) -Encoding UTF8
    } else {
        # In-place substitution to preserve existing formatting (indentation, alignment, comments if any)
        $updatedRaw = $toolsRaw
        foreach($k in $axToolKeys){
            $escaped = [regex]::Escape($k)
            $pattern = @"
(\"$escaped\"\s*:\s*\{[^{}]*?\"version\"\s*:\s*\")([^\"]+)(\")
"@
            $updatedRaw = [System.Text.RegularExpressions.Regex]::Replace(
                $updatedRaw,
                $pattern,
                { param($m) if($m.Groups[2].Value -ne $Version){ $m.Groups[1].Value + $Version + $m.Groups[3].Value } else { $m.Value } },
                [System.Text.RegularExpressions.RegexOptions]::Singleline
            )
        }
        if($updatedRaw -ne $toolsRaw){
            Set-Content -Path $toolsJsonPath -Value $updatedRaw -Encoding UTF8
        }
    }
}

### Update src/Directory.Packages.props
Write-Info 'Processing Directory.Packages.props...'
$propsRaw = Get-Content -Raw -Path $propsPath

# Regex: capture prefix + version attribute to replace only AXSharp.* package lines
# Using a single-quoted here-string to avoid PowerShell escaping issues with quotes inside the pattern
$pattern = @'
(?im)^(\s*<PackageVersion\s+Include="AXSharp\.[^"]+"\s+Version=")([^"]+)("\s*/>)
'@
$propsUpdated = [System.Text.RegularExpressions.Regex]::Replace($propsRaw, $pattern, { 
    param($m)
    $old = $m.Groups[2].Value
    if($old -ne $Version){
        $pkgLine = $m.Groups[0].Value
        # Extract the package name between Include=" and " Version
        $pkgName = [regex]::Match($pkgLine,'Include="(AXSharp\.[^"]+)"').Groups[1].Value
        $script:changes += "Directory.Packages.props: $pkgName $old -> $Version"
        return $m.Groups[1].Value + $Version + $m.Groups[3].Value
    } else {
        return $m.Value
    }
})

if(-not $DryRun){
    if($propsUpdated -ne $propsRaw){
        Set-Content -Path $propsPath -Value $propsUpdated -Encoding UTF8
    } elseif($Detailed){
        Write-Info 'No AXSharp.* entries needed updating in Directory.Packages.props.'
    }
}

Write-Host ''
if($changes.Count -eq 0){
    Write-Info "All AXSharp.* entries already at version $Version"
} else {
    Write-Info 'Summary of changes:'
    $changes | ForEach-Object { Write-Host "  $_" }
    if($DryRun){ Write-Warn 'DryRun set: no files were modified.' }
    else { Write-Info 'Updates applied.' }
}

Write-Host ''
Write-Info 'Done.'
exit 0
