# Axo_SR_750

_Keyence SR-750 fixed barcode reader_

Generated documentation for the `Axo_SR_750` component.

# [CONTROLLER](#tab/controller)

## Declare component

[!code-pascal[](../../showcase/app/src/components.keyence.vision/Documentation/Axo_SR_750_Showcase.st?name=ComponentDeclaration)]

## Declare initialization variables

*Most of the initialization variables come from the I/O system. The example below is for demonstration purposes.*

[!code-pascal[](../../showcase/app/src/components.keyence.vision/Documentation/Axo_SR_750_Showcase.st?name=InitializationArgumentsDeclaration)]

## Initialize & Run

[!code-pascal[](../../showcase/app/src/components.keyence.vision/Documentation/Axo_SR_750_Showcase.st?name=Initialization)]

[!INCLUDE [IntializeAndRun](../../../docfx/articles/notes/CYCLIC_UPDATE_NOTICE.md)]

## Use

[!code-pascal[](../../showcase/app/src/components.keyence.vision/Documentation/Axo_SR_750_Showcase.st?name=Usage)]

## Source

View the library source at [`Axo_SR_750.st`](https://github.com/Inxton/AXOpen/tree/3-unify-showcase/src/components.keyence.vision/ctrl/src/Axo_SR_750/Axo_SR_750.st).

# [.NET TWIN](#tab/twin)


## Source

View the .NET twin source at [`AXOpen.Components.Keyence.Vision`](https://github.com/Inxton/AXOpen/tree/3-unify-showcase/src/components.keyence.vision/src/AXOpen.Components.Keyence.Vision/).

# [BLAZOR](#tab/blazor)

`Axo_SR_750` does not ship a dedicated Blazor view. It renders via the generic `AxoComponent` pattern using `RenderableContentControl`, which inspects the component type at runtime and selects the matching rendering based on the `Presentation` attribute.

## Status display

[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/components-keyence-vision/Documentation/KeyenceVision.razor?name=GenericComponentStatusView)]

## Command control

[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/components-keyence-vision/Documentation/KeyenceVision.razor?name=GenericComponentCommandView)]

## Type-agnostic status view

[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/components-keyence-vision/Documentation/KeyenceVision.razor?name=RccComponentStatusView)]

## Type-agnostic command view

[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/components-keyence-vision/Documentation/KeyenceVision.razor?name=RccComponentCommandView)]

Available `Presentation` values: `Status-Display`, `Command-Control`, `Service-Control`, `Spot`, `Compact`.

## Source

View the Blazor package at [`AXOpen.Components.Keyence.Vision.blazor`](https://github.com/Inxton/AXOpen/tree/3-unify-showcase/src/components.keyence.vision/src/AXOpen.Components.Keyence.Vision.blazor/).

# [HARDWARE](#tab/hardware)

## Device template

PROFINET hardware template at `showcase/app/hwc/library_templates/Keyence_SR_750/`.

## Device instantiation

[!code-yaml[](../../showcase/app/hwc/plc_line.hwl.yml?name=KeyenceSr750Device)]

## IO system wiring

[!code-yaml[](../../showcase/app/hwc/plc_line.hwl.yml?name=KeyenceSr750IoSystem)]

---
