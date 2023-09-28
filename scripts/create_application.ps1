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
