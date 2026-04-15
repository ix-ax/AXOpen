& "$PSScriptRoot\_invoke_ixd.ps1"

# Generate metadata (.NET API documentation) from C# projects
dotnet docfx metadata .\docfx\docfx.json

dotnet docfx build .\docfx\docfx.json --output .\docs\
dotnet docfx serve .\docs\ --open-browser
