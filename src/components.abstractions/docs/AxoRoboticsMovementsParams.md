# AxoRoboticsMovementsParams

_Movement command parameters for `IAxoRobotics.StartMovements`._

## Description

`AxoRoboticsMovementsParams` (namespace `AXOpen.Components.Abstractions.Robotics`) bundles the fields that `IAxoRobotics.StartMovements` consumes via `VAR_IN_OUT`.

| Field | Type | Meaning |
|-------|------|---------|
| `ActionNo` | `BYTE` | Action identifier recognized by the robot program. |
| `GlobalSpeed` | `BYTE` | Global speed override (0-100 %). |
| `ToolNo` | `BYTE` | Active tool index. |
| `WorkobjectNo` | `BYTE` | Active workobject / frame index. |
| `PointNo` | `BYTE` | Target point index (when the robot program selects points by index). |
| `UserSpecSpeed1` | `INT` | User-defined speed 1 (vendor-specific meaning). |
| `UserSpecSpeed2` | `INT` | User-defined speed 2. |
| `Coordinates` | [`AxoRoboticsCoordinates`](AxoRoboticsCoordinates.md) | Target pose. |

## Showcase — populating the parameter block

[!code-pascal[](../../showcase/app/src/components.abstractions/ComponentsAbstractionsShowcase.st?name=RoboticsDataTypes)]

## Source reference

`axopen/src/components.abstractions/ctrl/src/AxoRobotics/AxoRoboticsMovementsParams.st`.
