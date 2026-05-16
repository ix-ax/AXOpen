# IAxo_Power

_Power-enable contract for drive components._

## Description

`IAxo_Power` (namespace `AXOpen.Components.Abstractions.Drives`) represents the power-enable surface of a drive. It extends `AXOpen.Core.IAxoToggleTask` — so the power stage is controlled via the standard toggle-task lifecycle (`Enable` / `Disable`) — and additionally exposes direction-specific status queries:

| Method | Returns |
|--------|---------|
| `EnabledPositive()` | `TRUE` when motion in the positive direction is enabled. |
| `DisabledPositive()` | `TRUE` when motion in the positive direction is disabled. |
| `EnabledNegative()` | `TRUE` when motion in the negative direction is enabled. |
| `DisabledNegative()` | `TRUE` when motion in the negative direction is disabled. |

This split allows drives that support asymmetric power enabling (e.g., a drive whose positive travel is enabled while negative travel is held by a limit or interlock) to report each side independently.

## Source reference

`axopen/src/components.abstractions/ctrl/src/AxoDrives/IAxo_Power.st`.
