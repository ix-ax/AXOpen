dotnet ixd `
-x .\src\abstractions\ctrl `
.\src\core\ctrl `
.\src\data\ctrl\ `
.\src\inspectors\ctrl `
.\src\components.abstractions\ctrl `
.\src\components.cognex.vision\ctrl `
.\src\components.pneumatics\ctrl `
.\src\components.elements\ctrl `
-o .\docfx\apictrl\

if ((Test-Path .\docs\)) {
    del .\docs\
}

if ((Test-Path .\docfx\src\)) {
    del .\docfx\src\
}

# dotnet run --project .\src\tools\src\axo.docopy\axo.docopy.csproj -s .\src -d .\docfx\src\
# dotnet DocFxTocGenerator --docfolder .\docfx\ --outputfolder .\docfx\gtoc\
dotnet docfx build .\docfx\docfx.json
dotnet docfx serve .\docs\
