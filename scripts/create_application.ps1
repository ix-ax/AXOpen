<#
.SYNOPSIS
This script installs a .NET template, deletes specific files, and then creates a new project with the provided name.

.DESCRIPTION
Installs the template from '..\src\templates.simple\', deletes files starting with 'tmp_sol_', and then creates a new project using the 'axosimple' template.

.PARAMETER ProjectName
The name of the project to be created.

.EXAMPLE
.\CreateSimpleApplication.ps1 -ProjectName "MyNewProject"
#>

param (
    [Parameter(Mandatory=$true)]
    [string]$ProjectName
)

## Check pre-requisites

# Check for dotnet 7.0
$dotnetVersion = (dotnet --version 2>$null)
if (-not $dotnetVersion -or ($dotnetVersion -lt 7.0)) {
    Write-Error "dotnet 7.0 is not installed or an older version is detected."
} else {
    Write-Output "dotnet 7.0 detected."
}

# Check for Visual Studio 2022
$vsWhere = "${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe"
if (Test-Path $vsWhere) {
    $vsVersion = & $vsWhere -version "[17.0,18.0)" -products * -property catalog_productDisplayVersion
    if (-not $vsVersion) {
        Write-Error "Visual Studio 2022 is not detected."
    } else {
        Write-Output "Visual Studio 2022 detected: $vsVersion"
    }
} else {
    Write-Error "vswhere tool not found. Unable to determine if Visual Studio 2022 is installed."
}

# Check for apax
try {
    apax --version | Out-Null
    Write-Output "Apax detected."
} catch {
    Write-Error "Apax is not installed or not found in PATH."
}

# Store the current directory
$lf = Get-Location

# Change directory to the script's location
Set-Location $PSScriptRoot

# Ensure the ..\src\.application folder exists
$applicationFolder = "..\src\.application"
if (-not (Test-Path -Path $applicationFolder -PathType Container)) {
    New-Item -Path $applicationFolder -ItemType Directory
    Write-Output "Created folder $applicationFolder"
}

# Delete any .apax folders
Get-ChildItem -Path "..\src\templates.simple\" -Recurse -Directory -Filter ".apax" | ForEach-Object {
    Remove-Item $_.FullName -Recurse -Force
    Write-Output "Deleted $($_.FullName)"
}

# Installing the .NET template
dotnet new install ..\src\templates.simple\ --force

# Creating a new project with the provided name
dotnet new axosimple -n $ProjectName -o ..\src\.application

# Delete files starting with 'tmp_*_' in the root output folder
Get-ChildItem -Path "..\src\.application\" -File -Filter "tmp_*_.*" | ForEach-Object {
    Remove-Item $_.FullName -Force
    Write-Output "Deleted $($_.FullName)"
}

Write-Output "Project $ProjectName created successfully."

# Return to the initial directory
Set-Location $lf
