# AxoDo

AxoDo is used for setting values of digital inputs.

# How to

# [CONTROLLER](#tab/controller)

# How to use component in controller

## Declare component

[!code-smalltalk[](../../showcase/app/src/components.elements/Documentation/Elements.st?name=AxoDoDeclaration)]

## Declare initialization variables

*Most of the initialization variable will come from the I/O system. This example is only for demostrational puproses.*

[!code-smalltalk[](../../showcase/app/src/components.elements/Documentation/Elements.st?name=AxoDoInitializationArgumentsDeclaration)]

## Manual Control

[!code-smalltalk[](../../showcase/app/src/components.elements/Documentation/Elements.st?name=AxoDoManualControl)]

## Initialize & Run

[!code-smalltalk[](../../showcase/app/src/components.elements/Documentation/Elements.st?name=AxoDoInitialization)]

[!INCLUDE [IntializeAndRun](../../../docfx/articles/notes/CYCLIC_UPDATE_NOTICE.md)]
# [.NET TWIN](#tab/twin)


## Source

View the .NET twin source at [`components.elements`](https://github.com/Inxton/AXOpen/tree/3-unify-showcase/src/components.elements/src/).

# [BLAZOR](#tab/blazor)

`AxoDo` ships a dedicated Blazor view (`AxoDoView`) supporting multiple presentations.

## Status display

[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/components-elements/Documentation/ElementsShowcase.razor?name=AxoDoStatusView)]

## Command control

[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/components-elements/Documentation/ElementsShowcase.razor?name=AxoDoCommandView)]

## Generic rendering via `RenderableContentControl`

Alternatively, render via `RenderableContentControl` which inspects the component at runtime and selects the matching view based on the `Presentation` attribute:

[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/components-elements/Documentation/ElementsShowcase.razor?name=RccComponentStatusView)]

[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/components-elements/Documentation/ElementsShowcase.razor?name=RccComponentCommandView)]

## Source

View the dedicated view at [`AxoDoView.razor`](https://github.com/Inxton/AXOpen/tree/3-unify-showcase/src/components.elements/src/AXOpen.Components.Elements.blazor/AxoDoView.razor).

---
