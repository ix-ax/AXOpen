# IAxoDrive

_PLCopen-style single-axis motion contract._

## Description

`IAxoDrive` (namespace `AXOpen.Components.Abstractions.Drives`) is the interface every single-axis drive component implements. It defines the complete PLCopen-inspired motion surface: motion commands (`AxoMoveAbsolute`, `AxoMoveRelative`, `AxoMoveAdditive`, `AxoMoveVelocity`, `AxoTorqueControl`), reference and lifecycle commands (`AxoHome`, `AxoSetPosition`, `AxoStop`, `AxoHalt`, `AxoReset`), parameter access (`AxoReadParameter`, `AxoReadRealParameter`, `AxoReadBoolParameter`, `AxoWriteParameter`, `AxoWriteRealParameter`, `AxoWriteBoolParameter`), digital I/O (`AxoReadDigitalInput`, `AxoReadDigitalOutput`, `AxoWriteDigitalOutput`), override (`AxoSetOverride`), and diagnostics (`AxoReadActualPosition`, `AxoReadActualVelocity`, `AxoReadActualTorque`, `AxoReadStatus`, `AxoReadMotionState`, `AxoReadAxisInfo`, `AxoReadAxisError`).

All methods return `AXOpen.Core.IAxoTaskState` or `AXOpen.Core.IAxoToggleTask`, so they integrate with the AXOpen task lifecycle (`Restore()` / execution / completion).

This is an abstract contract — it is not instantiable. Vendor packages such as `components.drives`, `components.festo.drives`, and `components.rexroth.drives` provide concrete implementations.

## Related enums

- [`eAxoDriveDirection`](eAxoDriveDirection.md) — direction selector for movement commands.
- [`eAxoExecutionMode`](eAxoExecutionMode.md) — `Immediately` vs. `Queued` execution.
- [`eAxoSource`](eAxoSource.md) — data source for motion-state reads.

## Source reference

See the full method signatures in the library source: `axopen/src/components.abstractions/ctrl/src/AxoDrives/IAxoDrive.st`.
