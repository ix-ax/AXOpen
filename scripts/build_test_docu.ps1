dotnet ixd `
-x .\src\abstractions\ctrl `
.\src\core\ctrl `
.\src\data\ctrl\ `
.\src\inspectors\ctrl `
.\src\components.abstractions\ctrl `
.\src\components.cognex.vision\ctrl `
.\src\components.pneumatics\ctrl `
.\src\components.elements\ctrl `
.\src\components.rexroth.drives\ctrl `
.\src\components.festo.drives\ctrl `
.\src\components.kuka.robotics\ctrl `
.\src\components.mitsubishi.robotics\ctrl `
.\src\template.axolibrary\ctrl `
-o .\docfx\apictrl\

if ((Test-Path .\docs-test\)) {
    del .\docs-test\
}

dotnet docfx build .\docfx\docfx.json --output .\docs-test\
dotnet docfx serve .\docs-test\ --open-browser
