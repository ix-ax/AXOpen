# AxoCmmtAs

_Festo CMMT-AS servo drive via PROFINET_

Generated documentation for the `AxoCmmtAs` component.

# [CONTROLLER](#tab/controller)

## Declare component

[!code-pascal[](../../showcase/app/src/components.festo.drives/Documentation/AxoCmmtAs_Showcase.st?name=ComponentDeclaration)]

## Declare initialization variables

*Most of the initialization variables come from the I/O system. The example below is for demonstration purposes.*

[!code-pascal[](../../showcase/app/src/components.festo.drives/Documentation/AxoCmmtAs_Showcase.st?name=InitializationArgumentsDeclaration)]

## Initialize & Run

[!code-pascal[](../../showcase/app/src/components.festo.drives/Documentation/AxoCmmtAs_Showcase.st?name=Initialization)]

[!INCLUDE [IntializeAndRun](../../../docfx/articles/notes/CYCLIC_UPDATE_NOTICE.md)]

## Use

[!code-pascal[](../../showcase/app/src/components.festo.drives/Documentation/AxoCmmtAs_Showcase.st?name=Usage)]

## Source

View the library source at [`AxoCmmtAs.st`](https://github.com/Inxton/AXOpen/tree/3-unify-showcase/src/components.festo.drives/ctrl/src/AxoCmmtAs/AxoCmmtAs.st).

# [.NET TWIN](#tab/twin)


## Source

View the .NET twin source at [`AXOpen.Components.Festo.Drives`](https://github.com/Inxton/AXOpen/tree/3-unify-showcase/src/components.festo.drives/src/AXOpen.Components.Festo.Drives/).

# [BLAZOR](#tab/blazor)

`AxoCmmtAs` ships a dedicated Blazor view (`AxoCmmtAsView`) supporting multiple presentations.

## Status display

[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/components-festo-drives/Documentation/FestoDrives.razor?name=AxoCmmtAsStatusView)]

## Command control

[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/components-festo-drives/Documentation/FestoDrives.razor?name=AxoCmmtAsCommandView)]

## Generic rendering

Alternatively, render via `RenderableContentControl` which inspects the component at runtime:

[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/components-festo-drives/Documentation/FestoDrives.razor?name=RccComponentStatusView)]

[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/components-festo-drives/Documentation/FestoDrives.razor?name=RccComponentCommandView)]

## Source

View the dedicated view at [`AxoCmmtAsView.razor`](https://github.com/Inxton/AXOpen/tree/3-unify-showcase/src/components.festo.drives/src/AXOpen.Components.Festo.Drives.blazor/AxoCmmtAs/AxoCmmtAsView.razor).

# [HARDWARE](#tab/hardware)

## Device template

PROFINET hardware template at `showcase/app/hwc/library_templates/festo_drives_cmmt_as/`.

## Device instantiation

[!code-yaml[](../../showcase/app/hwc/plc_line.hwl.yml?name=FestoCmmtAsDevice)]

## IO system wiring

[!code-yaml[](../../showcase/app/hwc/plc_line.hwl.yml?name=FestoCmmtAsIoSystem)]

---
