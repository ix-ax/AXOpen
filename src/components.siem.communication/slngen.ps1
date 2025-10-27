dotnet slngen this.proj -o this.sln --folders true --launch false

$currentDirectory = Split-Path -Leaf (Get-Location).Path
$sourceFile = Join-Path (Get-Location).Path "this.sln"
$destinationFile = Join-Path (Get-Location).Path ("$currentDirectory.sln")
if (Test-Path $sourceFile) {
    Copy-Item -Path $sourceFile -Destination $destinationFile -Force
} 