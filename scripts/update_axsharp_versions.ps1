<#
.SYNOPSIS
  Updates all AXSharp.* and Inxton.Operon.* package and tool versions to the latest (or specified) versions.

.DESCRIPTION
  1. Fetches the latest versions of AXSharp.ixc and Inxton.Operon from the NuGet feed (they have independent version numbers).
  2. Optionally allows overriding versions via -AxSharpVersion and -OperonVersion parameters.
  3. Updates versions for:
       - .config/dotnet-tools.json (all tools whose name starts with AXSharp. or Inxton.Operon.)
       - src/Directory.Packages.props (all <PackageVersion Include="AXSharp.*" ... /> and Include="Inxton.Operon.*" ... /> entries)
  4. Supports -DryRun to preview changes and -Verbose for detailed logging.

.PARAMETER AxSharpVersion
  Explicit version to set for AXSharp.* packages instead of auto-detecting the latest from NuGet.

.PARAMETER OperonVersion
  Explicit version to set for Inxton.Operon.* packages instead of auto-detecting the latest from NuGet.

.PARAMETER DryRun
  If set, no files are modified; proposed changes are displayed.

.EXAMPLE
  pwsh -File scripts/update_axsharp_versions.ps1

.EXAMPLE
  pwsh -File scripts/update_axsharp_versions.ps1 -AxSharpVersion 0.40.1-alpha.300 -OperonVersion 1.2.3 -DryRun

.NOTES
  The script uses simple regex-based replacements to preserve original formatting and comments.
  Requires PowerShell 5+ (ships with Windows) and internet access to reach api.nuget.org when auto-detecting versions.
#>
[CmdletBinding()]
param(
    [string]$AxSharpVersion,
    [string]$OperonVersion,
    [switch]$DryRun,
    [switch]$Detailed,
    [string]$Source = 'https://nuget.pkg.github.com/inxton', # Can be base or full index.json URL
    [string]$Username,  # Optional for private feed auth (GitHub Packages). If omitted and Token supplied, 'USERNAME' placeholder is used.
    [string]$Token,     # Personal Access Token or NuGet API key for private feed (PAT needs packaging:read scope)
    [switch]$NormalizeJson, # When set, rewrites dotnet-tools.json with standard compact formatting instead of preserving existing indentation
    [switch]$ListAvailable  # If set, lists available versions (after auth) and exits (unless versions also supplied)
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Write-Info($msg){ Write-Host "[INFO ] $msg" -ForegroundColor Cyan }
function Write-Warn($msg){ Write-Host "[WARN ] $msg" -ForegroundColor Yellow }
function Write-Err ($msg){ Write-Host "[ERROR] $msg" -ForegroundColor Red }

$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$repoRoot = Split-Path -Parent $scriptRoot
$toolsJsonPath = Join-Path $repoRoot '.config/dotnet-tools.json'
$propsPath = Join-Path $repoRoot 'Directory.Packages.props'

if(-not (Test-Path $toolsJsonPath)){ Write-Err ".config/dotnet-tools.json not found at $toolsJsonPath"; exit 1 }
if(-not (Test-Path $propsPath)){ Write-Err "Directory.Packages.props not found at $propsPath"; exit 1 }

function Write-Utf8NoBom-LF {
    param([string]$Path, [string]$Content)
    $lf = ($Content -replace "`r`n", "`n") -replace "`r", "`n"
    [System.IO.File]::WriteAllText($Path, $lf, [System.Text.UTF8Encoding]::new($false))
}

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

function Compare-VersionRecord { 
    param($a,$b)
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

function Get-LatestVersion {
    param([string]$Feed,[string]$PackageId,[string]$User,[string]$Tok,[switch]$List)
    try {
        $allVersions = Get-PackageVersionsFromFeed -Feed $Feed -PackageId $PackageId -User $User -Tok $Tok
        $records = $allVersions | ForEach-Object { ConvertTo-VersionRecord $_ }
        # Sort descending using Compare-VersionRecord
        $latest = $records[0]
        foreach($r in $records){ if( (Compare-VersionRecord $r $latest) -gt 0){ $latest = $r } }
        
        if($List){
            Write-Host ("Available versions for {0}:" -f $PackageId) -ForegroundColor Cyan
            # Simple bubble to display descending semver order
            $ordered = @()
            $work = @($records)
            while($work.Count -gt 0){
                $max = $work[0]; for($i=1;$i -lt $work.Count;$i++){ if( (Compare-VersionRecord $work[$i] $max) -gt 0){ $max = $work[$i] } }
                $ordered += $max; $work = $work | Where-Object { $_ -ne $max }
            }
            foreach($o in $ordered){ Write-Host "  $($o.Original)" }
        }
        
        return $latest.Original
    }
    catch {
        throw "Failed to fetch versions for ${PackageId}: $_"
    }
}

# Query for AXSharp version
if(-not $AxSharpVersion){
    Write-Info "Discovering latest AXSharp.ixc version from source: $Source ..."
    try {
        $AxSharpVersion = Get-LatestVersion -Feed $Source -PackageId 'AXSharp.ixc' -User $Username -Tok $Token -List:$ListAvailable
        Write-Info "Latest AXSharp version detected: $AxSharpVersion"
    }
    catch {
        Write-Err "Failed to fetch AXSharp versions from feed: $_"
        Write-Warn 'Provide a PAT via -Token or environment (AXSHARP_FEED_TOKEN / GITHUB_TOKEN) with read:packages scope, or pass -AxSharpVersion manually.'
        if($Detailed){ Write-Warn 'For GitHub Packages: create a classic PAT with read:packages scope or fine-grained token granting read to the package.' }
        exit 2
    }
} else {
    Write-Info "Using provided AXSharp version: $AxSharpVersion"
}

# Query for Inxton.Operon version
if(-not $OperonVersion){
    Write-Info "Discovering latest Inxton.Operon version from source: $Source ..."
    try {
        $OperonVersion = Get-LatestVersion -Feed $Source -PackageId 'Inxton.Operon' -User $Username -Tok $Token -List:$ListAvailable
        Write-Info "Latest Inxton.Operon version detected: $OperonVersion"
    }
    catch {
        Write-Err "Failed to fetch Inxton.Operon versions from feed: $_"
        Write-Warn 'Provide a PAT via -Token or environment (AXSHARP_FEED_TOKEN / GITHUB_TOKEN) with read:packages scope, or pass -OperonVersion manually.'
        if($Detailed){ Write-Warn 'For GitHub Packages: create a classic PAT with read:packages scope or fine-grained token granting read to the package.' }
        exit 2
    }
} else {
    Write-Info "Using provided Inxton.Operon version: $OperonVersion"
}

# Exit if listing was requested and no explicit versions provided
if($ListAvailable -and -not ($AxSharpVersion -and $OperonVersion)){
    Write-Info 'Exiting after listing versions (no explicit versions specified).'
    exit 0
}

# Basic sanity checks
if($AxSharpVersion -notmatch '^[0-9]+\.[0-9]+\.[0-9]+' ){ Write-Warn "AXSharp version '$AxSharpVersion' does not look like a typical semver (may still be fine)." }
if($OperonVersion -notmatch '^[0-9]+\.[0-9]+\.[0-9]+' ){ Write-Warn "Operon version '$OperonVersion' does not look like a typical semver (may still be fine)." }

$changes = @()

### Update .config/dotnet-tools.json
Write-Info 'Processing dotnet-tools.json...'
$toolsRaw = Get-Content -Raw -Path $toolsJsonPath
try { $toolsObj = $toolsRaw | ConvertFrom-Json -ErrorAction Stop }
catch { Write-Err "Failed to parse tools JSON: $_"; exit 3 }

if(-not $toolsObj.tools){ Write-Err "Unexpected JSON structure: missing 'tools' property."; exit 3 }

$axToolKeys = $toolsObj.tools.PSObject.Properties.Name | Where-Object { $_ -like 'AXSharp.*' }
$operonToolKeys = $toolsObj.tools.PSObject.Properties.Name | Where-Object { $_ -like 'Inxton.Operon.*' }

foreach($k in $axToolKeys){
    $current = $toolsObj.tools.$k.version
    if($current -ne $AxSharpVersion){
        $changes += "dotnet-tools.json: $k $current -> $AxSharpVersion"
        if(-not $DryRun){ $toolsObj.tools.$k.version = $AxSharpVersion }
    } else {
        if($Detailed){ Write-Info "Tool $k already at $AxSharpVersion" }
    }
}

foreach($k in $operonToolKeys){
    $current = $toolsObj.tools.$k.version
    if($current -ne $OperonVersion){
        $changes += "dotnet-tools.json: $k $current -> $OperonVersion"
        if(-not $DryRun){ $toolsObj.tools.$k.version = $OperonVersion }
    } else {
        if($Detailed){ Write-Info "Tool $k already at $OperonVersion" }
    }
}

if(-not $DryRun){
    if($NormalizeJson){
        #$newJson = $toolsObj | ConvertTo-Json -Depth 10
        # Normalize spacing after colons to a single space
        #$newJson = ($newJson -split "`r?`n") | ForEach-Object { $_ -replace '":\s+','": ' } | Out-String
        #Set-Content -Path $toolsJsonPath -Value ($newJson.TrimEnd() + [Environment]::NewLine) -Encoding UTF8
        $newJson = $toolsObj | ConvertTo-Json -Depth 10
        $newJson = (($newJson -split "`r?`n") | ForEach-Object { $_ -replace '":\s+','": ' }) -join "`n"
        $newJson = $newJson.TrimEnd() + "`n"
        Write-Utf8NoBom-LF -Path $toolsJsonPath -Content $newJson
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
                { param($m) if($m.Groups[2].Value -ne $AxSharpVersion){ $m.Groups[1].Value + $AxSharpVersion + $m.Groups[3].Value } else { $m.Value } },
                [System.Text.RegularExpressions.RegexOptions]::Singleline
            )
        }
        foreach($k in $operonToolKeys){
            $escaped = [regex]::Escape($k)
            $pattern = @"
(\"$escaped\"\s*:\s*\{[^{}]*?\"version\"\s*:\s*\")([^\"]+)(\")
"@
            $updatedRaw = [System.Text.RegularExpressions.Regex]::Replace(
                $updatedRaw,
                $pattern,
                { param($m) if($m.Groups[2].Value -ne $OperonVersion){ $m.Groups[1].Value + $OperonVersion + $m.Groups[3].Value } else { $m.Value } },
                [System.Text.RegularExpressions.RegexOptions]::Singleline
            )
        }
        if($updatedRaw -ne $toolsRaw){
            #Set-Content -Path $toolsJsonPath -Value $updatedRaw -Encoding UTF8
            Write-Utf8NoBom-LF -Path $toolsJsonPath -Content $updatedRaw
        }
    }
}

### Update src/Directory.Packages.props
Write-Info 'Processing Directory.Packages.props...'
$propsRaw = Get-Content -Raw -Path $propsPath

# Process AXSharp.* packages
$axPattern = @'
(?im)^(\s*<PackageVersion\s+Include="AXSharp\.[^"]+"\s+Version=")([^"]+)("\s*/>)
'@
$propsUpdated = [System.Text.RegularExpressions.Regex]::Replace($propsRaw, $axPattern, { 
    param($m)
    $old = $m.Groups[2].Value
    if($old -ne $AxSharpVersion){
        $pkgLine = $m.Groups[0].Value
        $pkgName = [regex]::Match($pkgLine,'Include="(AXSharp\.[^"]+)"').Groups[1].Value
        $script:changes += "Directory.Packages.props: $pkgName $old -> $AxSharpVersion"
        return $m.Groups[1].Value + $AxSharpVersion + $m.Groups[3].Value
    } else {
        return $m.Value
    }
})

# Process Inxton.Operon.* packages
$operonPattern = @'
(?im)^(\s*<PackageVersion\s+Include="Inxton\.Operon\.[^"]+"\s+Version=")([^"]+)("\s*/>)
'@
$propsUpdated = [System.Text.RegularExpressions.Regex]::Replace($propsUpdated, $operonPattern, { 
    param($m)
    $old = $m.Groups[2].Value
    if($old -ne $OperonVersion){
        $pkgLine = $m.Groups[0].Value
        $pkgName = [regex]::Match($pkgLine,'Include="(Inxton\.Operon\.[^"]+)"').Groups[1].Value
        $script:changes += "Directory.Packages.props: $pkgName $old -> $OperonVersion"
        return $m.Groups[1].Value + $OperonVersion + $m.Groups[3].Value
    } else {
        return $m.Value
    }
})

if(-not $DryRun){
    if($propsUpdated -ne $propsRaw){
        #Set-Content -Path $propsPath -Value $propsUpdated -Encoding UTF8
        Write-Utf8NoBom-LF -Path $propsPath     -Content $propsUpdated
    } elseif($Detailed){
        Write-Info 'No AXSharp.* or Inxton.Operon.* entries needed updating in Directory.Packages.props.'
    }
}

Write-Host ''
if($changes.Count -eq 0){
    Write-Info "All AXSharp.* and Inxton.Operon.* entries already at specified versions"
    Write-Info "  AXSharp: $AxSharpVersion"
    Write-Info "  Inxton.Operon: $OperonVersion"
} else {
    Write-Info 'Summary of changes:'
    $changes | ForEach-Object { Write-Host "  $_" }
    Write-Info "Target versions:"
    Write-Info "  AXSharp.*: $AxSharpVersion"
    Write-Info "  Inxton.Operon.*: $OperonVersion"
    if($DryRun){ Write-Warn 'DryRun set: no files were modified.' }
    else { Write-Info 'Updates applied.' }
}

Write-Host ''
Write-Info 'Done.'
exit 0
