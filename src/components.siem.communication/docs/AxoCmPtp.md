# AxoCmPtp

_Siemens Point-to-point communication (CM PtP)_

Generated documentation for the `AxoCmPtp` component.

# [CONTROLLER](#tab/controller)

## Declare component

[!code-pascal[](../../showcase/app/src/components.siem.communication/Documentation/AxoCmPtp_Showcase.st?name=ComponentDeclaration)]

## Declare initialization variables

*Most of the initialization variables come from the I/O system. The example below is for demonstration purposes.*

[!code-pascal[](../../showcase/app/src/components.siem.communication/Documentation/AxoCmPtp_Showcase.st?name=InitializationArgumentsDeclaration)]

## Initialize & Run

[!code-pascal[](../../showcase/app/src/components.siem.communication/Documentation/AxoCmPtp_Showcase.st?name=Initialization)]

[!INCLUDE [IntializeAndRun](../../../docfx/articles/notes/CYCLIC_UPDATE_NOTICE.md)]

## Use

[!code-pascal[](../../showcase/app/src/components.siem.communication/Documentation/AxoCmPtp_Showcase.st?name=Usage)]

## Source

View the library source at [`AxoCmPtp.st`](https://github.com/Inxton/AXOpen/tree/3-unify-showcase/src/components.siem.communication/ctrl/src/AxoCmPtp/AxoCmPtp.st).

# [.NET TWIN](#tab/twin)


## Source

View the .NET twin source at [`AXOpen.Components.Siem.Communication`](https://github.com/Inxton/AXOpen/tree/3-unify-showcase/src/components.siem.communication/src/AXOpen.Components.Siem.Communication/).

# [BLAZOR](#tab/blazor)

`AxoCmPtp` does not ship a dedicated Blazor view. It renders via the generic `AxoComponent` pattern using `RenderableContentControl`, which inspects the component type at runtime and selects the matching rendering based on the `Presentation` attribute.

## Status display

[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/components-siem-communication/Documentation/SiemCommunication.razor?name=GenericComponentStatusView)]

## Command control

[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/components-siem-communication/Documentation/SiemCommunication.razor?name=GenericComponentCommandView)]

## Type-agnostic status view

[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/components-siem-communication/Documentation/SiemCommunication.razor?name=RccComponentStatusView)]

## Type-agnostic command view

[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/components-siem-communication/Documentation/SiemCommunication.razor?name=RccComponentCommandView)]

Available `Presentation` values: `Status-Display`, `Command-Control`, `Service-Control`, `Spot`, `Compact`.

## Source

View the Blazor package at [`AXOpen.Components.Siem.Communication.blazor`](https://github.com/Inxton/AXOpen/tree/3-unify-showcase/src/components.siem.communication/src/AXOpen.Components.Siem.Communication.blazor/).

# [HARDWARE](#tab/hardware)

## Device template

PROFINET hardware template at `showcase/app/hwc/library_templates/siemens_communication/`.

## IO system wiring

[!code-yaml[](../../showcase/app/hwc/plc_line.hwl.yml?name=SiemCommunicationIoSystem)]

---
