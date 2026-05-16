# IAxoRobotics

_Robot controller contract._

## Description

`IAxoRobotics` (namespace `AXOpen.Components.Abstractions.Robotics`) is the common surface implemented by every robot controller component (ABB, KUKA, Mitsubishi, Universal Robots, ...). All methods return `AXOpen.Core.IAxoTaskState` so they integrate with the standard AXOpen task lifecycle.

| Method | Purpose |
|--------|---------|
| `StartAtMain()` | Set the robot program pointer to `Main` and prepare for execution. |
| `StartMotorsAndProgram()` | Enable motors and start the loaded program. |
| `StartMovements(inData : AxoRoboticsMovementsParams)` | Dispatch a movement using the parameters supplied via the `VAR_IN_OUT` reference. |
| `StopMovements(inStopType : eAxoRoboticsStopType)` | Stop movements using the requested stop type (`Soft` or `Quick`). |
| `StopMovementsAndProgram(inStopType : eAxoRoboticsStopType)` | Stop movements and the robot program. |

## Related data types

- [`AxoRoboticsMovementsParams`](AxoRoboticsMovementsParams.md) — movement parameter block.
- [`AxoRoboticsCoordinates`](AxoRoboticsCoordinates.md) — 6-axis pose carried in the parameter block.
- [`eAxoRoboticsStopType`](eAxoRoboticsStopType.md) — `Soft` / `Quick` stop selector.

## Showcase — shared data-type usage

The showcase populates the shared robotics data types to demonstrate their shape (field names, units, typical values):

[!code-pascal[](../../showcase/app/src/components.abstractions/ComponentsAbstractionsShowcase.st?name=RoboticsDataTypes)]

## Source reference

`axopen/src/components.abstractions/ctrl/src/AxoRobotics/IAxoRobotics.st`.
