# IAxoCodeReader

_Contract for 1D/2D code-reader components._

## Description

`IAxoCodeReader` (namespace `AXOpen.Components.Abstractions`) is the common surface for barcode / 2D-matrix readers. Both methods return `AXOpen.Core.IAxoTaskState`.

| Method | Output | Purpose |
|--------|--------|---------|
| `Read()` | `result : ARRAY[0..245] OF BYTE` | Trigger a read and return the decoded payload (up to 246 bytes). |
| `ClearResultData()` | — | Clear the last read result. |

The 246-byte result buffer is fixed by the contract — implementations truncate or validate vendor-specific payloads to fit.

Concrete implementations include `components.balluff.identification`, `components.siem.identification`, `components.cognex.vision`, `components.zebra.vision`, and `components.keyence.vision` (for devices that expose reader functionality).

## Source reference

`axopen/src/components.abstractions/ctrl/src/IAxoCodeReader.st`.
