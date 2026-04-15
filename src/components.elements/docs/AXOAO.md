# AxoAo

AxoAo is used for setting analogue values. AxoAo un-scales input signal based on `SetPoint` and values in `AxoAoConfig` class.

AxoAoConfig contains:

[!code-pascal[](../ctrl/src/AxoAo/AxoAoConfig.st?name=AxoAoConfigDeclaration)]

# How to

# [CONTROLLER](#tab/controller)

# How to use component in controller

## Declare component

[!code-pascal[](../../showcase/app/src/components.elements/Documentation/Elements.st?name=AxoAoDeclaration)]

## Declare initialization variables

*Most of the initialization variable will come from the I/O system. This example is only for demostrational puproses.*

[!code-pascal[](../../showcase/app/src/components.elements/Documentation/Elements.st?name=AxoAoInitializationArgumentsDeclaration)]

## Manual Control

[!code-pascal[](../../showcase/app/src/components.elements/Documentation/Elements.st?name=AxoAoManualControl)]

## Apply configuration

[!code-pascal[](../../showcase/app/src/components.elements/Documentation/Elements.st?name=AxoAoConfig)]

## Initialize & Run

[!code-pascal[](../../showcase/app/src/components.elements/Documentation/Elements.st?name=AxoAoInitialization)]

[!INCLUDE [IntializeAndRun](../../../docfx/articles/notes/CYCLIC_UPDATE_NOTICE.md)]

## Use

[!code-pascal[](../../showcase/app/src/components.elements/Documentation/Elements.st?name=AxoAoUsage)]

# [.NET TWIN](#tab/twin)


## Source

View the .NET twin source at [`components.elements`](https://github.com/Inxton/AXOpen/tree/3-unify-showcase/src/components.elements/src/).

# [BLAZOR](#tab/blazor)

`AxoAo` ships a dedicated Blazor view (`AxoAoView`) supporting multiple presentations.

## Status display

[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/components-elements/Documentation/ElementsShowcase.razor?name=AxoAoStatusView)]

## Command control

[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/components-elements/Documentation/ElementsShowcase.razor?name=AxoAoCommandView)]

## Generic rendering via `RenderableContentControl`

Alternatively, render via `RenderableContentControl` which inspects the component at runtime and selects the matching view based on the `Presentation` attribute:

[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/components-elements/Documentation/ElementsShowcase.razor?name=RccComponentStatusView)]

[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/components-elements/Documentation/ElementsShowcase.razor?name=RccComponentCommandView)]

![AxoAo](assets/axoao.gif)

## Source

View the dedicated view at [`AxoAoView.razor`](https://github.com/Inxton/AXOpen/tree/3-unify-showcase/src/components.elements/src/AXOpen.Components.Elements.blazor/AxoAoView.razor).

---
