# eAxoSource

_Data-source selector for drive motion-state reads._

## Description

`eAxoSource` (namespace `AXOpen.Components.Abstractions.Drives`) selects which internal motion signal `IAxoDrive.AxoReadMotionState` should observe.

| Value | Meaning |
|-------|---------|
| `CommandedValue` | The value requested by the application (setpoint before the profile generator). |
| `SetValue` | The value produced by the profile generator after interpolation. |
| `ActualValue` | The measured value from the encoder / feedback path. |

## Source reference

`axopen/src/components.abstractions/ctrl/src/AxoDrives/eAxoSource.st`.
