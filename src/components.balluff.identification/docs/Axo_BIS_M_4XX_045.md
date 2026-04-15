# Axo_BIS_M_4XX_045

_Balluff BIS M-4XX-045 IO-Link RFID reader_

Generated documentation for the `Axo_BIS_M_4XX_045` component.

# [CONTROLLER](#tab/controller)

## Declare component

[!code-pascal[](../../showcase/app/src/components.balluff.identification/Documentation/Axo_BIS_M_4XX_045.st?name=ComponentDeclaration)]

## Declare initialization variables

*Most of the initialization variables come from the I/O system. The example below is for demonstration purposes.*

[!code-pascal[](../../showcase/app/src/components.balluff.identification/Documentation/Axo_BIS_M_4XX_045.st?name=InitializationArgumentsDeclaration)]

## Initialize & Run

[!code-pascal[](../../showcase/app/src/components.balluff.identification/Documentation/Axo_BIS_M_4XX_045.st?name=Initialization)]

[!INCLUDE [IntializeAndRun](../../../docfx/articles/notes/CYCLIC_UPDATE_NOTICE.md)]

## Use

[!code-pascal[](../../showcase/app/src/components.balluff.identification/Documentation/Axo_BIS_M_4XX_045.st?name=Usage)]


## Additional scenario — manual control

A second scenario demonstrates operating the reader from the HMI without a
sequencer (all tasks are triggered from the `RenderableContentControl`
command view). See `Axo_BIS_M_4XX_045_ManualControl.st`:

[!code-pascal[](../../showcase/app/src/components.balluff.identification/Documentation/Axo_BIS_M_4XX_045_ManualControl.st?name=ComponentDeclaration)]

[!code-pascal[](../../showcase/app/src/components.balluff.identification/Documentation/Axo_BIS_M_4XX_045_ManualControl.st?name=Initialization)]

[!code-pascal[](../../showcase/app/src/components.balluff.identification/Documentation/Axo_BIS_M_4XX_045_ManualControl.st?name=Usage)]

## Source

View the library source at [`Axo_BIS_M_4XX_045.st`](https://github.com/Inxton/AXOpen/tree/troublesense-integration/src/components.balluff.identification/ctrl/src/Axo_BIS_M_4XX_045.st).

# [.NET TWIN](#tab/twin)


## Source

View the .NET twin source at [`AXOpen.Components.Balluff.Identification`](https://github.com/Inxton/AXOpen/tree/troublesense-integration/src/components.balluff.identification/src/AXOpen.Components.Balluff.Identification/).

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

View the Blazor package at [`AXOpen.Components.Balluff.Identification.blazor`](https://github.com/Inxton/AXOpen/tree/troublesense-integration/src/components.balluff.identification/src/AXOpen.Components.Balluff.Identification.blazor/).

---
