# Axo_BIS_M_4XX_045

_Balluff BIS M-4XX-045 IO-Link RFID reader_

Generated documentation for the `Axo_BIS_M_4XX_045` component.

# [CONTROLLER](#tab/controller)

## Declare component

[!code-pascal[](../../showcase/app/src/components.balluff.identification/Documentation/Axo_BIS_M_4XX_045_Showcase.st?name=ComponentDeclaration)]

## Declare initialization variables

*Most of the initialization variables come from the I/O system. The example below is for demonstration purposes.*

[!code-pascal[](../../showcase/app/src/components.balluff.identification/Documentation/Axo_BIS_M_4XX_045_Showcase.st?name=InitializationArgumentsDeclaration)]

## Initialize & Run

[!code-pascal[](../../showcase/app/src/components.balluff.identification/Documentation/Axo_BIS_M_4XX_045_Showcase.st?name=Initialization)]

[!INCLUDE [IntializeAndRun](../../../docfx/articles/notes/CYCLIC_UPDATE_NOTICE.md)]

## Use

[!code-pascal[](../../showcase/app/src/components.balluff.identification/Documentation/Axo_BIS_M_4XX_045_Showcase.st?name=Usage)]


## Additional scenario

A second instance is provided in `Axo_BIS_M_4XX_045_Showcase2.st`:

[!code-pascal[](../../showcase/app/src/components.balluff.identification/Documentation/Axo_BIS_M_4XX_045_Showcase2.st?name=Initialization)]

## Source

View the library source at [`Axo_BIS_M_4XX_045.st`](https://github.com/Inxton/AXOpen/tree/3-unify-showcase/src/components.balluff.identification/ctrl/src/Axo_BIS_M_4XX_045/Axo_BIS_M_4XX_045.st).

# [.NET TWIN](#tab/twin)


## Source

View the .NET twin source at [`AXOpen.ComponentsBalluffIdentification`](https://github.com/Inxton/AXOpen/tree/3-unify-showcase/src/components.balluff.identification/src/AXOpen.ComponentsBalluffIdentification/).

# [BLAZOR](#tab/blazor)

`Axo_BIS_M_4XX_045` does not ship a dedicated Blazor view. It renders via the generic `AxoComponent` pattern using `RenderableContentControl`, which inspects the component type at runtime and selects the matching rendering based on the `Presentation` attribute.

## Status display

[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/components-balluff-identification/Documentation/BalluffIdentification.razor?name=GenericComponentStatusView)]

## Command control

[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/components-balluff-identification/Documentation/BalluffIdentification.razor?name=GenericComponentCommandView)]

## Type-agnostic status view

[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/components-balluff-identification/Documentation/BalluffIdentification.razor?name=RccComponentStatusView)]

## Type-agnostic command view

[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/components-balluff-identification/Documentation/BalluffIdentification.razor?name=RccComponentCommandView)]

Available `Presentation` values: `Status-Display`, `Command-Control`, `Service-Control`, `Spot`, `Compact`.

## Source

View the Blazor package at [`AXOpen.ComponentsBalluffIdentification.blazor`](https://github.com/Inxton/AXOpen/tree/3-unify-showcase/src/components.balluff.identification/src/AXOpen.ComponentsBalluffIdentification.blazor/).

---
