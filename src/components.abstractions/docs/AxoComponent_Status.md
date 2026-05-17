# AxoComponent_Status

_Common status block shared by component implementations._

## Description

`AxoComponent_Status` (namespace `AXOpen.Components.Abstractions`) is the standard status container that component libraries embed in their status surface. It exposes two `AXOpen.Core.AxoTextList` fields so localized, levelled messages can be surfaced on HMIs:

| Field | Type | Purpose |
|-------|------|---------|
| `Action` | `AXOpen.Core.AxoTextList` | The current action the component is performing (informational / warning / error levels configured via `WarningLevel(500)` / `ErrorLevel(700)` attributes). |
| `Error` | `AXOpen.Core.AxoTextList` | The active error description with the same level mapping. |

Both fields are decorated with `ix-set` / `ix-attr` attributes so that the generated Blazor twin renders them directly in status views.

## Showcase — declaration

[!code-pascal[](../../showcase/app/src/components.abstractions/ComponentsAbstractionsShowcase.st?name=ComponentAbstractionsDeclarations)]

## Source reference

`axopen/src/components.abstractions/ctrl/src/AxoComponent_Status.st`.
