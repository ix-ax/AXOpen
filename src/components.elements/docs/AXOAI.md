# AxoAi

AxoAi is used for checking values of analogue inputs. AxoAi scales input signal based on values in `AxoAiConfig` class.

AxoAiConfig contains:

[!code-smalltalk[](../ctrl/src//AxoAi/AxoAiConfig.st?name=AxoAiConfigDeclaration)]

# How to

# [CONTROLLER](#tab/controller)

# How to use component in controller

## Declare component

[!code-smalltalk[](../../showcase/app/src/components.elements/Documentation/Elements.st?name=AxoAiDeclaration)]

## Declare initialization variables

*Most of the initialization variable will come from the I/O system. This example is only for demostrational puproses.*

[!code-smalltalk[](../../showcase/app/src/components.elements/Documentation/Elements.st?name=AxoAiInitializationArgumentsDeclaration)]

## Manual Control

[!code-smalltalk[](../../showcase/app/src/components.elements/Documentation/Elements.st?name=AxoAiManualControl)]

## Initialize & Run

[!code-smalltalk[](../../showcase/app/src/components.elements/Documentation/Elements.st?name=AxoAiInitialization)]

[!INCLUDE [IntializeAndRun](../../../docfx/articles/notes/CYCLIC_UPDATE_NOTICE.md)]
# [.NET TWIN](#tab/twin)


## Source

View the .NET twin source at [`components.elements`](https://github.com/Inxton/AXOpen/tree/3-unify-showcase/src/components.elements/src/).

# [BLAZOR](#tab/blazor)

`AxoAi` ships a dedicated Blazor view (`AxoAiView`) supporting multiple presentations.

## Status display

[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/components-elements/Documentation/ElementsShowcase.razor?name=AxoAiStatusView)]

## Command control

[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/components-elements/Documentation/ElementsShowcase.razor?name=AxoAiCommandView)]

## Generic rendering via `RenderableContentControl`

Alternatively, render via `RenderableContentControl` which inspects the component at runtime and selects the matching view based on the `Presentation` attribute:

[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/components-elements/Documentation/ElementsShowcase.razor?name=RccComponentStatusView)]

[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/components-elements/Documentation/ElementsShowcase.razor?name=RccComponentCommandView)]

## Source

View the dedicated view at [`AxoAiView.razor`](https://github.com/Inxton/AXOpen/tree/3-unify-showcase/src/components.elements/src/AXOpen.Components.Elements.blazor/AxoAiView.razor).

---
