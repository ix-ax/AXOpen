# AxoRoboticsCoordinates

_6-axis Cartesian pose (X, Y, Z, Rx, Ry, Rz)._

## Description

`AxoRoboticsCoordinates` (namespace `AXOpen.Components.Abstractions.Robotics`) is the shared pose structure used by every robot controller implementation. It carries both translational (`X`, `Y`, `Z`) and rotational (`Rx`, `Ry`, `Rz`) components as `REAL`.

| Field | Type | Meaning |
|-------|------|---------|
| `X` | `REAL` | X coordinate. |
| `Y` | `REAL` | Y coordinate. |
| `Z` | `REAL` | Z coordinate. |
| `Rx` | `REAL` | Rotation about X. |
| `Ry` | `REAL` | Rotation about Y. |
| `Rz` | `REAL` | Rotation about Z. |

Units (mm / degrees vs. m / radians) are defined by the concrete robot implementation and the configured tool/workobject frames — the abstractions library itself does not pin a unit system.

## Showcase — populating a coordinate and movement parameters

[!code-pascal[](../../showcase/app/src/components.abstractions/ComponentsAbstractionsShowcase.st?name=RoboticsDataTypes)]

## Source reference

`axopen/src/components.abstractions/ctrl/src/AxoRobotics/AxoRoboticsCoordinates.st`.
