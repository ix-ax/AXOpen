# AxoDataman v6.0.0

# [CONTROLLER](#tab/controller)


## Declare component
[!code-pascal[](../../showcase/app/src/ComponentsCognexVision/Documentation/Component_3.st?name=ComponentDeclaration)]

## Declare initialization variables

*Most of the initialization variable will come from the I/O system. This example is only for demostrational puproses.*

[!code-pascal[](../../showcase/app/src/ComponentsCognexVision/Documentation/Component_3.st?name=InitializationArgumentsDeclaration)]

## Initialize & Run

[!code-pascal[](../../showcase/app/src/ComponentsCognexVision/Documentation/Component_3.st?name=Initialization)]

[!INCLUDE [IntializeAndRun](../../../docfx/articles/notes/CYCLIC_UPDATE_NOTICE.md)]

## Use
[!code-pascal[](../../showcase/app/src/ComponentsCognexVision/Documentation/Component_3.st?name=Usage)]

# [.NET TWIN](#tab/twin)


[!code-csharp[](../../showcase/app/ix-blazor/showcase.blazor/Pages/CognexVision/Component_3.razor?name=WriteTaskDurationToConsole)]


# [BLAZOR](#tab/blazor)

## Generic Read-Only view 

[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/CognexVision/Component_3.razor?name=GenericComponentStatusView)]

## Generic control view 

[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/CognexVision/Component_3.razor?name=GenericComponentCommandView)]

## Type agnostic using RenderableContentControl status (Read-Only) view

[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/CognexVision/Component_3.razor?name=RccComponentStatusView)]


## Type agnostic using RenderableContentControl control view

[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/CognexVision/Component_3.razor?name=RccComponentCommandView)]

---
