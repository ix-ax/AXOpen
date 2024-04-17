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
-o .\docfx\apictrl\

dotnet docfx build .\docfx\docfx.json --output .\docs\
dotnet docfx serve .\docs\ --open-browser
