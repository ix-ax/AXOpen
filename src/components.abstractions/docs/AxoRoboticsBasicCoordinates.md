# AxoRoboticsBasicCoordinates

_3-axis position (X, Y, Z)._

## Description

`AxoRoboticsBasicCoordinates` (namespace `AXOpen.Components.Abstractions.Robotics`) is the reduced pose used when only translational position matters (e.g., a gantry or a pick-and-place without orientation control).

| Field | Type | Meaning |
|-------|------|---------|
| `X` | `REAL` | X coordinate. |
| `Y` | `REAL` | Y coordinate. |
| `Z` | `REAL` | Z coordinate. |

For a full 6-axis pose with rotations, see [`AxoRoboticsCoordinates`](AxoRoboticsCoordinates.md).

## Source reference

`axopen/src/components.abstractions/ctrl/src/AxoRobotics/AxoRoboticsBasicCoordinates.st`.
