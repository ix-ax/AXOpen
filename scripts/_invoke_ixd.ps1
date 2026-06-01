param(
    [string]$Output = ".\docfx\apictrl\"
)

dotnet ixd `
    -x .\src\abstractions\ctrl `
       .\src\core\ctrl `
       .\src\data\ctrl `
       .\src\inspectors\ctrl `
       .\src\io\ctrl `
       .\src\probers\ctrl `
       .\src\simatic1500\ctrl `
       .\src\timers\ctrl `
       .\src\utils\ctrl `
       .\src\components.abstractions\ctrl `
       .\src\components.abb.robotics\ctrl `
       .\src\components.balluff.identification\ctrl `
       .\src\components.cognex.vision\ctrl `
       .\src\components.desoutter.tightening\ctrl `
       .\src\components.drives\ctrl `
       .\src\components.dukane.welders\ctrl `
       .\src\components.elements\ctrl `
       .\src\components.festo.drives\ctrl `
       .\src\components.keyence.vision\ctrl `
       .\src\components.kuka.robotics\ctrl `
       .\src\components.mitsubishi.robotics\ctrl `
       .\src\components.pneumatics\ctrl `
       .\src\components.rexroth.drives\ctrl `
       .\src\components.rexroth.press\ctrl `
       .\src\components.rexroth.tightening\ctrl `
       .\src\components.robotics\ctrl `
       .\src\components.siem.communication\ctrl `
       .\src\components.siem.identification\ctrl `
       .\src\components.ur.robotics\ctrl `
       .\src\components.zebra.vision\ctrl `
    -o $Output
