# AxoEA3600

_Zebra EA3600 fixed industrial barcode scanner with PROFINET interface_

`AxoEA3600` is the AXOpen control component for the Zebra EA3600 fixed
industrial scanner family. It encapsulates PROFINET cyclic I/O exchange,
read/clear command sequencing, fragmented payload reassembly (>64 bytes),
and ACK handshake protocol against the scanner.

## Configuration

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `InfoTime` | `LTIME` | `LT#5S` | Delay before posting info-level diagnostic messages. |
| `ErrorTime` | `LTIME` | `LT#10S` | Delay before posting error-level messages and timing out tasks. |
| `TaskTimeout` | `LTIME` | `LT#50S` | Hard timeout for invoked tasks. |
| `HWIDs` | `AxoEA3600_HWIDs` | — | Hardware identifiers populated from the I/O system. |
| `HandshakeEnable` | `BOOL` | `TRUE` | Use ACK handshake with the scanner per the PROFINET data exchange spec. |
| `FragmentEnable` | `BOOL` | `TRUE` | Reassemble fragmented payloads larger than 64 bytes. |
| `ContinuousReading` | `BOOL` | `FALSE` | If `TRUE`, the scanner reads continuously without per-trigger commands. |

## Public methods

| Method | Returns | Purpose |
|--------|---------|---------|
| `Run(inParent, hwID, ...)` | `void` | Cyclic update — must be called every PLC cycle. |
| `Read()` | `IAxoTaskState` | Trigger a read; populates `ReadData` on success. |
| `ClearData()` | `IAxoTaskState` | Clear the last read result buffer. |
| `ClearError()` | `IAxoTaskState` | Acknowledge and clear the scanner error condition. |
| `TemplateMethod_10steps_4..6` | `IAxoTaskState` | Vendor-defined slot template tasks (configurable per device profile). |
| `TemplateMethod_20steps_1..6` | `IAxoTaskState` | Additional vendor template tasks. |
| `Restore()` (override) | `void` | Reset internal state machine and pending tasks. |

## Supported barcode types

The `eAxoEA3600BarcodeType` enum exposes the full set of symbologies
recognized by the EA3600 firmware (Code 39/93/128, Codabar, EAN-8/13,
UPC-A/E, PDF-417, MicroPDF417, Data Matrix, QR Code, Aztec, Maxicode,
GS1 DataBar variants, postal codes, and composite codes). See the
library source for the complete enum definition.

# [CONTROLLER](#tab/controller)

## Declare component

[!code-pascal[](../../showcase/app/src/components.zebra.vision/Documentation/AxoEA3600_Showcase.st?name=ComponentDeclaration)]

## Declare initialization variables

*Most of the initialization variables come from the I/O system. The example below is for demonstration purposes.*

[!code-pascal[](../../showcase/app/src/components.zebra.vision/Documentation/AxoEA3600_Showcase.st?name=InitializationArgumentsDeclaration)]

## Initialize & Run

[!code-pascal[](../../showcase/app/src/components.zebra.vision/Documentation/AxoEA3600_Showcase.st?name=Initialization)]

[!INCLUDE [IntializeAndRun](../../../docfx/articles/notes/CYCLIC_UPDATE_NOTICE.md)]

## Use

[!code-pascal[](../../showcase/app/src/components.zebra.vision/Documentation/AxoEA3600_Showcase.st?name=Usage)]

## Additional scenario

A second instance demonstrating an alternative wiring is provided as
`AxoEA3600_Showcase2.st` in the showcase application:

[!code-pascal[](../../showcase/app/src/components.zebra.vision/Documentation/AxoEA3600_Showcase2.st?name=Initialization)]

## Source

View the library source at [`AxoEA3600.st`](https://github.com/Inxton/AXOpen/tree/3-unify-showcase/src/components.zebra.vision/ctrl/src/AxoEA3600/AxoEA3600.st).

# [.NET TWIN](#tab/twin)


## Source

View the .NET twin source at [`AXOpen.Components.Zebra.Vision`](https://github.com/Inxton/AXOpen/tree/3-unify-showcase/src/components.zebra.vision/src/AXOpen.Components.Zebra.Vision/).

# [BLAZOR](#tab/blazor)

`AxoEA3600` does not ship a dedicated Blazor view. It renders via the generic `AxoComponent` pattern using `RenderableContentControl`, which inspects the component type at runtime and selects the matching rendering based on the `Presentation` attribute.

## Status display

[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/components-zebra-vision/Documentation/ZebraVision.razor?name=GenericComponentStatusView)]

## Command control

[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/components-zebra-vision/Documentation/ZebraVision.razor?name=GenericComponentCommandView)]

## Type-agnostic status view

[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/components-zebra-vision/Documentation/ZebraVision.razor?name=RccComponentStatusView)]

## Type-agnostic command view

[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/components-zebra-vision/Documentation/ZebraVision.razor?name=RccComponentCommandView)]

Available `Presentation` values: `Status-Display`, `Command-Control`, `Service-Control`, `Spot`, `Compact`.

## Source

The component's status structure and Blazor package are at:
- [`AxoEA3600_Component_Status.st`](https://github.com/Inxton/AXOpen/tree/3-unify-showcase/src/components.zebra.vision/ctrl/src/AxoEA3600/TypesStructuresAndEnums/AxoEA3600_Component_Status.st)
- [`AXOpen.Components.Zebra.Vision.blazor`](https://github.com/Inxton/AXOpen/tree/3-unify-showcase/src/components.zebra.vision/src/AXOpen.Components.Zebra.Vision.blazor/)

# [HARDWARE](#tab/hardware)

## Device template

The PROFINET hardware template for the Zebra EA3600 lives at
`showcase/app/hwc/library_templates/zebra_ea3600/`. It defines the device
identification, modules, and submodules required for cyclic data exchange.

## Device instantiation

[!code-yaml[](../../showcase/app/hwc/plc_line.hwl.yml?name=ZebraEa3600Device)]

## IO system wiring

[!code-yaml[](../../showcase/app/hwc/plc_line.hwl.yml?name=ZebraEa3600IoSystem)]

## I/O mapping

The component's `Run()` method consumes:
- `hwID` — the PROFINET hardware identifier (auto-populated from `Config.HWIDs`)
- Status/data inputs from the scanner via the `AxoEA3600_In` structure
- Control outputs back to the scanner via `AxoEA3600_Out`

All structures are populated automatically by the `AxoEA3600.Run()` cycle —
application code only sees the high-level methods (`Read()`, `ClearData()`,
`ClearError()`).

---
