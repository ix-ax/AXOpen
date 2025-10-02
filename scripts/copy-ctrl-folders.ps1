<#!
.SYNOPSIS
    Copies every directory named 'ctrl' from the source tree into a destination while keeping the original structure.

.DESCRIPTION
    Recursively searches the source directory (defaults to the repository's src folder) for directories named 'ctrl'.
    Each matching directory is copied to the destination path, preserving the folder hierarchy relative to the source root.

.PARAMETER Destination
    The target root directory where the ctrl folders will be copied.

.PARAMETER Source
    Optional. The source root directory to scan. Defaults to the repository src folder.

.EXAMPLE
    ./copy-ctrl-folders.ps1 -Destination 'C:\temp\axopen-ctrl'

.EXAMPLE
    ./copy-ctrl-folders.ps1 -Source 'D:\projects\AXOpen\src' -Destination 'E:\exports\ctrl'
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]$Destination,

    [Parameter(Mandatory = $false)]
    [string]$Source
)

function Resolve-DirectoryPath {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path,

        [switch]$Create
    )

    $resolvedBase = if ([IO.Path]::IsPathRooted($Path)) {
        [IO.Path]::GetFullPath($Path)
    } else {
        $base = if ($PSScriptRoot) { $PSScriptRoot } else { (Get-Location).ProviderPath }
        [IO.Path]::GetFullPath([IO.Path]::Combine($base, $Path))
    }

    if (Test-Path -LiteralPath $resolvedBase) {
        return (Resolve-Path -Path $resolvedBase).ProviderPath
    }

    if ($Create) {
        if ($PSCmdlet.ShouldProcess($resolvedBase, 'Create directory')) {
            New-Item -ItemType Directory -Path $resolvedBase -Force | Out-Null
        }

        if (Test-Path -LiteralPath $resolvedBase) {
            return (Resolve-Path -Path $resolvedBase).ProviderPath
        }

        return $resolvedBase
    }

    throw "Path '$resolvedBase' does not exist."
}

if (-not $Source) {
    $scriptRoot = if ($PSScriptRoot) { $PSScriptRoot } else { [IO.Path]::GetDirectoryName($PSCommandPath) }
    $Source = [IO.Path]::Combine($scriptRoot, '..', 'src')
}

$Source = Resolve-DirectoryPath -Path $Source
$Destination = Resolve-DirectoryPath -Path $Destination -Create

function Get-DirectoryUri {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    $resolvedPath = (Resolve-Path -Path $Path).ProviderPath

    if (-not $resolvedPath.EndsWith([IO.Path]::DirectorySeparatorChar)) {
        $resolvedPath += [IO.Path]::DirectorySeparatorChar
    }

    return [Uri]::new($resolvedPath, [UriKind]::Absolute)
}

$sourceUri = Get-DirectoryUri -Path $Source

$ctrlDirs = Get-ChildItem -Path $Source -Directory -Recurse | Where-Object { $_.Name -ieq 'ctrl' }

if (-not $ctrlDirs) {
    Write-Warning "No directories named 'ctrl' were found under '$Source'."
    return
}

foreach ($dir in $ctrlDirs) {
    $dirUri = Get-DirectoryUri -Path $dir.FullName
    $relativeUri = $sourceUri.MakeRelativeUri($dirUri)
    $relativePath = [Uri]::UnescapeDataString($relativeUri.ToString()).Replace('/', [IO.Path]::DirectorySeparatorChar)

    $relativeParent = Split-Path -Path $relativePath -Parent
    if ([string]::IsNullOrEmpty($relativeParent)) {
        $targetParent = $Destination
    } else {
        $targetParent = Join-Path $Destination $relativeParent
        if (-not (Test-Path -LiteralPath $targetParent)) {
            New-Item -ItemType Directory -Path $targetParent -Force | Out-Null
        }
    }

    $targetDir = Join-Path $targetParent (Split-Path -Path $relativePath -Leaf)

    if ($PSCmdlet.ShouldProcess($dir.FullName, "Copy to $targetDir")) {
        Write-Verbose "Copying '$($dir.FullName)' to '$targetDir'"
        Copy-Item -Path $dir.FullName -Destination $targetParent -Recurse -Container -Force -ErrorAction Stop
    }
}

Write-Host "Copied $($ctrlDirs.Count) 'ctrl' directories to '$Destination'."
