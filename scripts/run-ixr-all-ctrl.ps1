# Run dotnet ixr in all ctrl directories under src folder
# This script compiles PLC localized strings resources to resx

$srcPath = Join-Path $PSScriptRoot "..\src"

Get-ChildItem -Path $srcPath -Recurse -Directory -Filter "ctrl" | ForEach-Object {
    Write-Host "Running dotnet ixr in: $($_.FullName)" -ForegroundColor Cyan
    Push-Location $_.FullName
    dotnet ixr
    Pop-Location
    Write-Host ""
}
