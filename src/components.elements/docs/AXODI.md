# AxoDi

AxoDi is used for checking values of digital inputs.

# How to

# [CONTROLLER](#tab/controller)

# How to use component in controller

## Declare component

[!code-pascal[](../../showcase/app/src/components.elements/Documentation/Elements.st?name=AxoDiDeclaration)]

## Declare initialization variables

*Most of the initialization variable will come from the I/O system. This example is only for demostrational puproses.*

[!code-pascal[](../../showcase/app/src/components.elements/Documentation/Elements.st?name=AxoDiInitializationArgumentsDeclaration)]

## Manual Control

[!code-pascal[](../../showcase/app/src/components.elements/Documentation/Elements.st?name=AxoDiManualControl)]

## Initialize & Run

[!code-pascal[](../../showcase/app/src/components.elements/Documentation/Elements.st?name=AxoDiInitialization)]

[!INCLUDE [IntializeAndRun](../../../docfx/articles/notes/CYCLIC_UPDATE_NOTICE.md)]

## Use

[!code-pascal[](../../showcase/app/src/components.elements/Documentation/Elements.st?name=AxoDiUsage)]
# [.NET TWIN](#tab/twin)


## Source

View the .NET twin source at [`components.elements`](https://github.com/Inxton/AXOpen/tree/3-unify-showcase/src/components.elements/src/).

# [BLAZOR](#tab/blazor)

`AxoDi` ships a dedicated Blazor view (`AxoDiView`) supporting multiple presentations.

## Status display

[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/components-elements/Documentation/ElementsShowcase.razor?name=AxoDiStatusView)]

## Command control

[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/components-elements/Documentation/ElementsShowcase.razor?name=AxoDiCommandView)]

## Generic rendering via `RenderableContentControl`

Alternatively, render via `RenderableContentControl` which inspects the component at runtime and selects the matching view based on the `Presentation` attribute:

[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/components-elements/Documentation/ElementsShowcase.razor?name=RccComponentStatusView)]

[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/components-elements/Documentation/ElementsShowcase.razor?name=RccComponentCommandView)]

![AxoDi](assets/axodi.gif)

## Source

View the dedicated view at [`AxoDiView.razor`](https://github.com/Inxton/AXOpen/tree/3-unify-showcase/src/components.elements/src/AXOpen.Components.Elements.blazor/AxoDiView.razor).

---
