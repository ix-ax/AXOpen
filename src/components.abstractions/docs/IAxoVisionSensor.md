# IAxoVisionSensor

_Contract for vision-sensor components._

## Description

`IAxoVisionSensor` (namespace `AXOpen.Components.Abstractions`) is the common surface for machine-vision sensors. All methods return `AXOpen.Core.IAxoTaskState`.

| Method | Purpose |
|--------|---------|
| `Trigger()` | Trigger a single inspection cycle. |
| `ChangeJob(Job : UINT)` | Switch to a job/program by numeric identifier. |
| `ChangeJob(Job : STRING)` | Switch to a job/program by name. |
| `ClearInspectionResults()` | Clear the cached inspection results. |

`ChangeJob` is overloaded so that application code can select jobs either by index (preferred for fast, table-driven reconfiguration) or by name (preferred for legibility on vendors that expose named jobs).

Concrete implementations include `components.cognex.vision`, `components.keyence.vision`, and `components.zebra.vision`.

## Source reference

`axopen/src/components.abstractions/ctrl/src/IAxoVisionSensor.st`.
