# eAxoRoboticsStopType

_Stop category for `IAxoRobotics` stop commands._

## Description

`eAxoRoboticsStopType` (namespace `AXOpen.Components.Abstractions.Robotics`) selects the stop category used by `IAxoRobotics.StopMovements` and `IAxoRobotics.StopMovementsAndProgram`.

| Value | Meaning |
|-------|---------|
| `Soft` | Controlled stop along the programmed path, respecting deceleration limits. |
| `Quick` | Fast stop with maximum allowed deceleration; may leave the programmed path. |

## Source reference

`axopen/src/components.abstractions/ctrl/src/AxoRobotics/eAxoRoboticsStopType.st`.
