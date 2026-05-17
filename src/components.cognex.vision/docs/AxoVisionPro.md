# AxoVisionPro

_Cognex VisionPro multi-camera vision system_

Generated documentation for the `AxoVisionPro` component.

# [CONTROLLER](#tab/controller)

## Declare component

[!code-pascal[](../../showcase/app/src/components.cognex.vision/Documentation/AxoVisionPro.st?name=ComponentDeclaration)]

## Declare initialization variables

*Most of the initialization variables come from the I/O system. The example below is for demonstration purposes.*

[!code-pascal[](../../showcase/app/src/components.cognex.vision/Documentation/AxoVisionPro.st?name=InitializationArgumentsDeclaration)]

## Initialize & Run

[!code-pascal[](../../showcase/app/src/components.cognex.vision/Documentation/AxoVisionPro.st?name=Initialization)]

[!INCLUDE [IntializeAndRun](../../../docfx/articles/notes/CYCLIC_UPDATE_NOTICE.md)]

## Use

[!code-pascal[](../../showcase/app/src/components.cognex.vision/Documentation/AxoVisionPro.st?name=Usage)]

## Source

View the library source at [`AxoVisionPro`](https://github.com/Inxton/AXOpen/tree/troublesense-integration/src/components.cognex.vision/ctrl/src/AxoVisionPro/).

# [.NET TWIN](#tab/twin)


## Source

View the .NET twin source at [`AXOpen.Components.Cognex.Vision`](https://github.com/Inxton/AXOpen/tree/troublesense-integration/src/components.cognex.vision/src/AXOpen.Components.Cognex.Vision/).

# [BLAZOR](#tab/blazor)

`AxoVisionPro` does not ship a dedicated Blazor view. It renders via the generic `AxoComponent` pattern using `RenderableContentControl`, which inspects the component type at runtime and selects the matching rendering based on the `Presentation` attribute.

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

View the Blazor package at [`AXOpen.Components.Cognex.Vision.blazor`](https://github.com/Inxton/AXOpen/tree/troublesense-integration/src/components.cognex.vision/src/AXOpen.Components.Cognex.Vision.blazor/).

# [HARDWARE](#tab/hardware)

## Device template

PROFINET hardware template at `showcase/app/hwc/library_templates/cognex_visionpro/`.

## Device instantiation

[!code-yaml[](../../showcase/app/hwc/plc_line.hwl.yml?name=CognexVisionProDevice)]

## IO system wiring

[!code-yaml[](../../showcase/app/hwc/plc_line.hwl.yml?name=CognexVisionProIoSystem)]

---
