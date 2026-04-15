# AxoCVIC_II

_Desoutter CVIC II tightening controller_

Generated documentation for the `AxoCVIC_II` component.

# [CONTROLLER](#tab/controller)

## Declare component

[!code-pascal[](../../showcase/app/src/components.desoutter.tightening/Documentation/AxoCVIC_II.st?name=ComponentDeclaration)]

## Declare initialization variables

*Most of the initialization variables come from the I/O system. The example below is for demonstration purposes.*

[!code-pascal[](../../showcase/app/src/components.desoutter.tightening/Documentation/AxoCVIC_II.st?name=InitializationArgumentsDeclaration)]

## Initialize & Run

[!code-pascal[](../../showcase/app/src/components.desoutter.tightening/Documentation/AxoCVIC_II.st?name=Initialization)]

[!INCLUDE [IntializeAndRun](../../../docfx/articles/notes/CYCLIC_UPDATE_NOTICE.md)]

## Use

[!code-pascal[](../../showcase/app/src/components.desoutter.tightening/Documentation/AxoCVIC_II.st?name=Usage)]

## Source

View the library source at [`AxoCVIC_II.st`](https://github.com/Inxton/axopen.templates/tree/troublesense-integration/axopen/src/components.desoutter.tightening/ctrl/src/CVIC_II/AxoCVIC_II.st).

# [.NET TWIN](#tab/twin)


## Source

View the .NET twin source at [`AXOpen.Components.Desoutter.Tightening`](https://github.com/Inxton/axopen.templates/tree/troublesense-integration/axopen/src/components.desoutter.tightening/src/AXOpen.Components.Desoutter.Tightening/).

# [BLAZOR](#tab/blazor)

`AxoCVIC_II` does not ship a dedicated Blazor view. It renders via the generic `AxoComponent` pattern using `RenderableContentControl`, which inspects the component type at runtime and selects the matching rendering based on the `Presentation` attribute.

## Status display

[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/components-desoutter-tightening/Documentation/DesoutterTightening.razor?name=GenericComponentStatusView)]

## Command control

[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/components-desoutter-tightening/Documentation/DesoutterTightening.razor?name=GenericComponentCommandView)]

## Type-agnostic status view

[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/components-desoutter-tightening/Documentation/DesoutterTightening.razor?name=RccComponentStatusView)]

## Type-agnostic command view

[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/components-desoutter-tightening/Documentation/DesoutterTightening.razor?name=RccComponentCommandView)]

Available `Presentation` values: `Status-Display`, `Command-Control`, `Service-Control`, `Spot`, `Compact`.

## Source

View the Blazor package at [`AXOpen.Components.Desoutter.Tightening.blazor`](https://github.com/Inxton/axopen.templates/tree/troublesense-integration/axopen/src/components.desoutter.tightening/src/AXOpen.Components.Desoutter.Tightening.blazor/).

# [HARDWARE](#tab/hardware)

## Device template

PROFINET hardware template at `showcase/app/hwc/library_templates/desoutter_tightenning_CVIC_II/`.

## Device instantiation

[!code-yaml[](../../showcase/app/hwc/plc_line.hwl.yml?name=DesoutterCvicIiDevice)]

## IO system wiring

[!code-yaml[](../../showcase/app/hwc/plc_line.hwl.yml?name=DesoutterCvicIiIoSystem)]

---
