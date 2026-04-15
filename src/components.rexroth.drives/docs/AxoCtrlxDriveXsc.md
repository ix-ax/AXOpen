# AxoCtrlxDriveXsc

_Rexroth ctrlX DRIVE XSC servo drive_

Generated documentation for the `AxoCtrlxDriveXsc` component.

# [CONTROLLER](#tab/controller)

## Declare component

[!code-pascal[](../../showcase/app/src/components.rexroth.drives/Documentation/AxoCtrlxDriveXsc_Showcase.st?name=ComponentDeclaration)]

## Declare initialization variables

*Most of the initialization variables come from the I/O system. The example below is for demonstration purposes.*

[!code-pascal[](../../showcase/app/src/components.rexroth.drives/Documentation/AxoCtrlxDriveXsc_Showcase.st?name=InitializationArgumentsDeclaration)]

## Initialize & Run

[!code-pascal[](../../showcase/app/src/components.rexroth.drives/Documentation/AxoCtrlxDriveXsc_Showcase.st?name=Initialization)]

[!INCLUDE [IntializeAndRun](../../../docfx/articles/notes/CYCLIC_UPDATE_NOTICE.md)]

## Use

[!code-pascal[](../../showcase/app/src/components.rexroth.drives/Documentation/AxoCtrlxDriveXsc_Showcase.st?name=Usage)]

## Source

View the library source at [`AxoCtrlxDriveXsc.st`](https://github.com/Inxton/AXOpen/tree/3-unify-showcase/src/components.rexroth.drives/ctrl/src/AxoCtrlxDriveXsc/AxoCtrlxDriveXsc.st).

# [.NET TWIN](#tab/twin)


## Source

View the .NET twin source at [`AXOpen.Components.Rexroth.Drives`](https://github.com/Inxton/AXOpen/tree/3-unify-showcase/src/components.rexroth.drives/src/AXOpen.Components.Rexroth.Drives/).

# [BLAZOR](#tab/blazor)

`AxoCtrlxDriveXsc` does not ship a dedicated Blazor view. It renders via the generic `AxoComponent` pattern using `RenderableContentControl`, which inspects the component type at runtime and selects the matching rendering based on the `Presentation` attribute.

## Status display

[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/components-rexroth-drives/Documentation/RexrothDrives.razor?name=GenericComponentStatusView)]

## Command control

[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/components-rexroth-drives/Documentation/RexrothDrives.razor?name=GenericComponentCommandView)]

## Type-agnostic status view

[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/components-rexroth-drives/Documentation/RexrothDrives.razor?name=RccComponentStatusView)]

## Type-agnostic command view

[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/components-rexroth-drives/Documentation/RexrothDrives.razor?name=RccComponentCommandView)]

Available `Presentation` values: `Status-Display`, `Command-Control`, `Service-Control`, `Spot`, `Compact`.

## Source

View the Blazor package at [`AXOpen.Components.Rexroth.Drives.blazor`](https://github.com/Inxton/AXOpen/tree/3-unify-showcase/src/components.rexroth.drives/src/AXOpen.Components.Rexroth.Drives.blazor/).

# [HARDWARE](#tab/hardware)

## Device template

PROFINET hardware template at `showcase/app/hwc/library_templates/rexroth_ctrlx_drive/`.

## Device instantiation

[!code-yaml[](../../showcase/app/hwc/plc_line.hwl.yml?name=RexrothCtrlxDriveDevice)]

## IO system wiring

[!code-yaml[](../../showcase/app/hwc/plc_line.hwl.yml?name=RexrothCtrlxDriveIoSystem)]

---
