# AxoInsight_v_6_0_0_0

_Cognex In-Sight v6.0.0 vision system_

Generated documentation for the `AxoInsight_v_6_0_0_0` component.

# [CONTROLLER](#tab/controller)

## Declare component

[!code-pascal[](../../showcase/app/src/components.cognex.vision/Documentation/AxoInsight_v_6_0_0_0_Showcase.st?name=ComponentDeclaration)]

## Declare initialization variables

*Most of the initialization variables come from the I/O system. The example below is for demonstration purposes.*

[!code-pascal[](../../showcase/app/src/components.cognex.vision/Documentation/AxoInsight_v_6_0_0_0_Showcase.st?name=InitializationArgumentsDeclaration)]

## Initialize & Run

[!code-pascal[](../../showcase/app/src/components.cognex.vision/Documentation/AxoInsight_v_6_0_0_0_Showcase.st?name=Initialization)]

[!INCLUDE [IntializeAndRun](../../../docfx/articles/notes/CYCLIC_UPDATE_NOTICE.md)]

## Use

[!code-pascal[](../../showcase/app/src/components.cognex.vision/Documentation/AxoInsight_v_6_0_0_0_Showcase.st?name=Usage)]

## Source

View the library source at [`AxoInsight_v_6_0_0_0.st`](https://github.com/Inxton/AXOpen/tree/3-unify-showcase/src/components.cognex.vision/ctrl/src/AxoInsight_v_6_0_0_0/AxoInsight_v_6_0_0_0.st).

# [.NET TWIN](#tab/twin)


## Source

View the .NET twin source at [`AXOpen.ComponentsCognexVision`](https://github.com/Inxton/AXOpen/tree/3-unify-showcase/src/components.cognex.vision/src/AXOpen.ComponentsCognexVision/).

# [BLAZOR](#tab/blazor)

`AxoInsight_v_6_0_0_0` does not ship a dedicated Blazor view. It renders via the generic `AxoComponent` pattern using `RenderableContentControl`, which inspects the component type at runtime and selects the matching rendering based on the `Presentation` attribute.

## Status display

[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/components-cognex-vision/Documentation/CognexVision.razor?name=GenericComponentStatusView)]

## Command control

[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/components-cognex-vision/Documentation/CognexVision.razor?name=GenericComponentCommandView)]

## Type-agnostic status view

[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/components-cognex-vision/Documentation/CognexVision.razor?name=RccComponentStatusView)]

## Type-agnostic command view

[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/components-cognex-vision/Documentation/CognexVision.razor?name=RccComponentCommandView)]

Available `Presentation` values: `Status-Display`, `Command-Control`, `Service-Control`, `Spot`, `Compact`.

## Source

View the Blazor package at [`AXOpen.ComponentsCognexVision.blazor`](https://github.com/Inxton/AXOpen/tree/3-unify-showcase/src/components.cognex.vision/src/AXOpen.ComponentsCognexVision.blazor/).

# [HARDWARE](#tab/hardware)

## Device template

PROFINET hardware template at `showcase/app/hwc/library_templates/cognex_insight/`.

## Device instantiation

[!code-yaml[](../../showcase/app/hwc/plc_line.hwl.yml?name=CognexInsight7600Device)]

## IO system wiring

[!code-yaml[](../../showcase/app/hwc/plc_line.hwl.yml?name=CognexInsight7600IoSystem)]

---
