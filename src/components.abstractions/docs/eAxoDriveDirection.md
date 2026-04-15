# eAxoDriveDirection

_Direction selector for drive motion commands._

## Description

`eAxoDriveDirection` (namespace `AXOpen.Components.Abstractions.Drives`) selects the direction of travel for `IAxoDrive` motion commands such as `AxoMoveAbsolute`, `AxoMoveVelocity`, and `AxoTorqueControl`.

| Value | Meaning |
|-------|---------|
| `PositiveDirection` | Force travel in the positive axis direction. |
| `ShortestWay` | Choose the shortest travel path (only applicable to rotary / modulo axes for absolute moves). |
| `NegativeDirection` | Force travel in the negative axis direction. |
| `CurrentDirection` | Continue in whichever direction the axis is currently moving. |

`ShortestWay` is not applicable to `AxoMoveVelocity` and `AxoTorqueControl` — those commands use only the three directional values.

## Showcase — selecting a direction

[!code-pascal[](../../showcase/app/src/components.abstractions/ComponentsAbstractionsShowcase.st?name=DriveEnums)]

## Source reference

`axopen/src/components.abstractions/ctrl/src/AxoDrives/eAxoDriveDirection.st`.
