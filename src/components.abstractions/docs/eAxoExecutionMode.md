# eAxoExecutionMode

_Execution-sequencing mode for drive commands._

## Description

`eAxoExecutionMode` (namespace `AXOpen.Components.Abstractions.Drives`) chooses how a newly issued drive command sequences against an already-running one.

| Value | Meaning |
|-------|---------|
| `Immediately` | The new command takes effect at once; it may influence the ongoing motion but not the motion state. This is the default behaviour. |
| `Queued` | The new command is buffered and executes after the current command completes (equivalent to PLCopen's `Buffered` buffer mode). |

Used by `AxoSetPosition`, `AxoWriteParameter`, `AxoWriteRealParameter`, `AxoWriteBoolParameter`, and `AxoWriteDigitalOutput` on `IAxoDrive`.

## Showcase — selecting a mode

[!code-pascal[](../../showcase/app/src/components.abstractions/ComponentsAbstractionsShowcase.st?name=DriveEnums)]

## Source reference

`axopen/src/components.abstractions/ctrl/src/AxoDrives/eAxoExecutionMode.st`.
