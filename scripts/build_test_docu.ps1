& "$PSScriptRoot\_invoke_ixd.ps1"

if ((Test-Path .\docs-test\)) {
    del .\docs-test\
}

# Generate metadata (.NET API documentation) from C# projects
dotnet docfx metadata .\docfx\docfx.json

# Build the documentation site
dotnet docfx build .\docfx\docfx.json --output .\docs-test\
dotnet docfx serve .\docs-test\ --open-browser
