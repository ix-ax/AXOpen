# AxoBoolArray

`AxoBoolArray` provides a base class for declaring arrays of `BOOL` values with HMI integration. Each element renders as an individual bit indicator on the Blazor UI, with automatic change-detection for efficient polling.

## Usage

### Declare a custom type

Extend `AxoBoolArray` and add a `Data` array of the desired size:

[!code-smalltalk[](../../showcase/app/src/core/AXOpen.AxoBoolArray/AxoBoolArrayExample.st?name=AxoBoolArrayTypeDeclaration)]

### Declare instances

[!code-smalltalk[](../../showcase/app/src/core/AXOpen.AxoBoolArray/AxoBoolArrayExample.st?name=AxoBoolArrayInstanceDeclaration)]

### Write data and signal changes

Call `ToggleDataChangedFlag()` after writing new values to notify the HMI that the display should update:

[!code-smalltalk[](../../showcase/app/src/core/AXOpen.AxoBoolArray/AxoBoolArrayExample.st?name=AxoBoolArrayUsage)]

## Key API

| Method | Description |
|--------|-------------|
| `ToggleDataChangedFlag()` | Signals the HMI that array data was updated and should be re-read |
| `DataHasChanged() : BOOL` | Returns `TRUE` when the HMI has written new values into the array |

## Notes

- The array size is determined at compile time by the `Data` VAR declaration
- Arrays are 0-based per AXOpen convention
- The HMI renders each element individually — large arrays may impact rendering performance
