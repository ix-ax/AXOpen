<#
.SYNOPSIS
Scaffolds a new AXOpen library from the 'template.axolibrary' .NET template.

.DESCRIPTION
Generates a new library into <OutputRoot>/<LibraryFolder>, then builds the controller
library (apax) and the .NET twins (dotnet).

Designed to be CI-safe:
 - restores the caller's working directory on exit,
 - propagates failures via a non-zero exit code (every external command is checked),
 - does NOT mutate the committed 'template.axolibrary' (the template's
   .template.config/template.json already excludes .apax/bin/obj/sln),
 - uninstalls the template registration on exit.

.PARAMETER LibraryFolder
Library folder / namespace seed, e.g. 'components.foo' -> AXOpen.Components.Foo.

.PARAMETER OutputRoot
Directory the library is generated into. Defaults to the repository 'src' folder.
CI passes a throwaway temp directory.

.PARAMETER Cleanup
Remove the generated library folder before exiting (validation-only runs). Off by
default so developers keep the scaffolded library.

.EXAMPLE
.\create_library_from_template.ps1 -LibraryFolder components.foo
#>

param
(
    [Parameter(Mandatory = $true)]
    [string]$LibraryFolder,

    [string]$OutputRoot,

    [switch]$Cleanup
)

$ErrorActionPreference = 'Stop'

# Run a native command and fail the whole script if it returns a non-zero exit code.
# This is the key CI-safety fix: previously every step swallowed its errors.
function Invoke-Checked {
    param(
        [Parameter(Mandatory = $true)][scriptblock]$Action,
        [Parameter(Mandatory = $true)][string]$What
    )
    Write-Host ">> $What"
    & $Action
    if ($LASTEXITCODE -ne 0) {
        throw "FAILED ($LASTEXITCODE): $What"
    }
}

# Remember the caller's directory and resolve template paths from the script location
# (not the ambient working directory, which the original script relied on).
$callerLocation = Get-Location
$srcDir = (Resolve-Path (Join-Path $PSScriptRoot '..\src')).Path
$templateDir = Join-Path $srcDir 'template.axolibrary'

if (-not $OutputRoot) { $OutputRoot = $srcDir }
$OutputRoot = (Resolve-Path $OutputRoot).Path

$_outputDirectory = $LibraryFolder.ToLower()

# AXOpen.Components.Foo  from  components.foo
$_namespaceParts = $_outputDirectory -split '\.'
$_formattedParts = $_namespaceParts | ForEach-Object {
    if ($_.Length -gt 0) {
        $_.Substring(0, 1).ToUpper() + $_.Substring(1).ToLower()
    }
}
$_projectNamespace = 'AXOpen.' + ($_formattedParts -join '.')
$_inxton_apaxlibname_csproj = 'inxton_axopen_' + ($_outputDirectory -replace '\.', '_') + '.csproj'
$_app_apaxappname_csproj    = 'app_axopen_'    + ($_outputDirectory -replace '\.', '_') + '.csproj'

$libraryPath = Join-Path $OutputRoot $_outputDirectory

Write-Host '-----------------------------------------------------------'
Write-Host "Creating library '$_projectNamespace' in '$libraryPath'"
Write-Host "  inxton twin csproj : $_inxton_apaxlibname_csproj"
Write-Host "  app twin csproj    : $_app_apaxappname_csproj"
Write-Host '-----------------------------------------------------------'

$templateInstalled = $false
try {
    if (Test-Path $libraryPath) {
        throw "Target folder already exists: $libraryPath"
    }

    # Register the template (machine-global; uninstalled in the finally block).
    Invoke-Checked { dotnet new install $templateDir --force } "dotnet new install $templateDir"
    $templateInstalled = $true

    Invoke-Checked {
        dotnet new axolibrary -o $libraryPath `
            --projname $_projectNamespace `
            --inxton_apaxlibname_csproj $_inxton_apaxlibname_csproj `
            --app_apaxappname_csproj $_app_apaxappname_csproj
    } 'dotnet new axolibrary'

    Set-Location $libraryPath

    # The *_csproj symbols are 'replaces' only (no fileRename in template.json), so the
    # physical files keep their template names while references were already rewritten.
    # Rename the files to match.
    $appCsproj = Join-Path '.' 'app\ix\app_apaxappname.csproj'
    if (Test-Path $appCsproj) {
        Rename-Item -Path $appCsproj -NewName $_app_apaxappname_csproj -Force
    }
    $libCsproj = Join-Path '.' "src\$_projectNamespace\inxton_apaxlibname.csproj"
    if (Test-Path $libCsproj) {
        Rename-Item -Path $libCsproj -NewName $_inxton_apaxlibname_csproj -Force
    }
    Remove-Item (Join-Path '.' "src\$_projectNamespace\inxton_apaxlibname.csproj.Backup.tmp") `
        -Force -ErrorAction Ignore

    # Build the controller library. apax.yml lives in 'ctrl' (matches the CI build in
    # cake/Program.cs TestsTask -> GetLibraryAxFolders, and src/<lib>/tmp_build_.ps1).
    Set-Location (Join-Path $libraryPath 'ctrl')
    Invoke-Checked { apax clean }   'apax clean (ctrl)'
    Invoke-Checked { apax install } 'apax install (ctrl)'
    Invoke-Checked { apax build }   'apax build (ctrl)'
    Invoke-Checked { dotnet ixc }   'dotnet ixc (ctrl)'

    # Build the .NET twins / app / tests via the per-library traversal project.
    Set-Location $libraryPath
    Invoke-Checked { dotnet build this.proj } 'dotnet build this.proj'

    # slngen / workspace files are developer convenience only - never fail on them.
    try {
        dotnet slngen this.proj -o this.sln --folders true --launch false
        if (Test-Path 'this.sln') {
            Copy-Item -Path 'this.sln' -Destination "$_outputDirectory.sln" -Force
        }
        $ws = Join-Path $templateDir 'template.axolibrary.code-workspace'
        if (Test-Path $ws) {
            Copy-Item -Path $ws -Destination "$_outputDirectory.code-workspace" -Force
        }
    }
    catch {
        Write-Warning "slngen / workspace generation skipped: $($_.Exception.Message)"
    }

    Write-Host '-----------------------------------------------------------'
    Write-Host "Done. Library created at '$libraryPath'."
    Write-Host '-----------------------------------------------------------'
}
finally {
    Set-Location $callerLocation

    # Leave the machine's template store clean.
    if ($templateInstalled) {
        dotnet new uninstall $templateDir 2>$null
    }

    if ($Cleanup -and (Test-Path $libraryPath)) {
        Write-Host "Cleanup: removing '$libraryPath'"
        Remove-Item $libraryPath -Recurse -Force -ErrorAction Ignore
    }
}
