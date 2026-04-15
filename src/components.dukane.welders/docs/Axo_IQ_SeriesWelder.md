# Axo_IQ_SeriesWelder

_Dukane iQ Series ultrasonic welder controller_

Generated documentation for the `Axo_IQ_SeriesWelder` component.

# [CONTROLLER](#tab/controller)

## Declare component

[!code-pascal[](../../showcase/app/src/components.dukane.welders/Documentation/Axo_IQ_SeriesWelder_Showcase.st?name=ComponentDeclaration)]

## Declare initialization variables

*Most of the initialization variables come from the I/O system. The example below is for demonstration purposes.*

[!code-pascal[](../../showcase/app/src/components.dukane.welders/Documentation/Axo_IQ_SeriesWelder_Showcase.st?name=InitializationArgumentsDeclaration)]

## Initialize & Run

[!code-pascal[](../../showcase/app/src/components.dukane.welders/Documentation/Axo_IQ_SeriesWelder_Showcase.st?name=Initialization)]

[!INCLUDE [IntializeAndRun](../../../docfx/articles/notes/CYCLIC_UPDATE_NOTICE.md)]

## Use

[!code-pascal[](../../showcase/app/src/components.dukane.welders/Documentation/Axo_IQ_SeriesWelder_Showcase.st?name=Usage)]


## Additional scenario

A second instance is provided in `Axo_IQ_SeriesWelder_Showcase2.st`:

[!code-pascal[](../../showcase/app/src/components.dukane.welders/Documentation/Axo_IQ_SeriesWelder_Showcase2.st?name=Initialization)]

## Source

View the library source at [`Axo_IQ_SeriesWelder.st`](https://github.com/Inxton/AXOpen/tree/3-unify-showcase/src/components.dukane.welders/ctrl/src/AxoIQSeriesWelder/Axo_IQ_SeriesWelder.st).

# [.NET TWIN](#tab/twin)


## Source

View the .NET twin source at [`AXOpen.Components.Dukane.Welders`](https://github.com/Inxton/AXOpen/tree/3-unify-showcase/src/components.dukane.welders/src/AXOpen.Components.Dukane.Welders/).

# [BLAZOR](#tab/blazor)

`Axo_IQ_SeriesWelder` does not ship a dedicated Blazor view. It renders via the generic `AxoComponent` pattern using `RenderableContentControl`, which inspects the component type at runtime and selects the matching rendering based on the `Presentation` attribute.

## Status display

[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/components-dukane-welders/Documentation/DukaneWelders.razor?name=GenericComponentStatusView)]

## Command control

[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/components-dukane-welders/Documentation/DukaneWelders.razor?name=GenericComponentCommandView)]

## Type-agnostic status view

[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/components-dukane-welders/Documentation/DukaneWelders.razor?name=RccComponentStatusView)]

## Type-agnostic command view

[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/components-dukane-welders/Documentation/DukaneWelders.razor?name=RccComponentCommandView)]

Available `Presentation` values: `Status-Display`, `Command-Control`, `Service-Control`, `Spot`, `Compact`.

## Source

View the Blazor package at [`AXOpen.Components.Dukane.Welders.blazor`](https://github.com/Inxton/AXOpen/tree/3-unify-showcase/src/components.dukane.welders/src/AXOpen.Components.Dukane.Welders.blazor/).

# [HARDWARE](#tab/hardware)

## Device template

PROFINET hardware template at `showcase/app/hwc/library_templates/dukane_welders_iq_series/DukaneIqSeriesWelder.hwl.yml`.

[!code-yaml[](../../showcase/app/hwc/library_templates/dukane_welders_iq_series/DukaneIqSeriesWelder.hwl.yml?name=DukaneIqWelderTemplate)]

## Device instantiation

[!code-yaml[](../../showcase/app/hwc/plc_line.hwl.yml?name=DukaneIqWelderDevice)]

## IO system wiring

[!code-yaml[](../../showcase/app/hwc/plc_line.hwl.yml?name=DukaneIqWelderIoSystem)]

---
