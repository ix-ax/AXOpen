# AxoByteArray

`AxoByteArray` provides a base class for declaring arrays of `BYTE` values with HMI integration. The display format can be configured per instance using the `DisplayFormat` attribute — either `"hexadecimal"` (shows `0xAB`) or `"string"` (interprets bytes as ASCII characters).

## Usage

### Declare custom types

Extend `AxoByteArray` and add a `Data` array. Set `DisplayFormat` to control rendering:

[!code-smalltalk[](../../showcase/app/src/core/AXOpen.AxoByteArray/AxoByteArrayExample.st?name=AxoByteArrayTypeDeclaration)]

### Declare instances

Use `{#ix-attr:[ReadOnly()]}` to make arrays read-only on the HMI, or omit it to allow HMI writes:

[!code-smalltalk[](../../showcase/app/src/core/AXOpen.AxoByteArray/AxoByteArrayExample.st?name=AxoByteArrayInstanceDeclaration)]

### Write data and detect changes

Call `ToggleDataChangedFlag()` after PLC writes. Use `DataHasChanged()` to detect HMI writes:

[!code-smalltalk[](../../showcase/app/src/core/AXOpen.AxoByteArray/AxoByteArrayExample.st?name=AxoByteArrayUsage)]

## Key API

| Method | Description |
|--------|-------------|
| `ToggleDataChangedFlag()` | Signals the HMI that array data was updated by the PLC |
| `DataHasChanged() : BOOL` | Returns `TRUE` when the HMI has written new values into the array |

## Display Formats

| Format | Attribute | Rendering |
|--------|-----------|-----------|
| Hexadecimal | `{#ix-set:DisplayFormat = "hexadecimal"}` | Each byte shown as `0x00`..`0xFF` |
| String | `{#ix-set:DisplayFormat = "string"}` | Bytes interpreted as ASCII characters |

## Notes

- Arrays are 0-based per AXOpen convention
- `ReadOnly()` attribute prevents HMI from modifying values — useful for status/diagnostic arrays
- Writable arrays (without `ReadOnly`) support bidirectional data exchange between PLC and HMI
