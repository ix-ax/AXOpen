# Component_1

# [CONTROLLER](#tab/controller)

## Declare component
[!code-pascal[](../app/src/Documentation/Component_1.st?name=ComponentDeclaration)]

## Declare initialization variables

*Most of the initialization variable will come from the I/O system. This example is only for demostrational puproses.*

[!code-pascal[](../app/src/Documentation/Component_1.st?name=InitializationArgumentsDeclaration)]

## Initialize & Run

[!code-pascal[](../app/src/Documentation/Component_1.st?name=Initialization)]

[!INCLUDE [IntializeAndRun](../../../docfx/articles/notes/CYCLIC_UPDATE_NOTICE.md)]

## Use
[!code-pascal[](../app/src/Documentation/Component_1.st?name=Usage)]

# [.NET TWIN](#tab/twin)


[!code-csharp[](../app/ix-blazor/Pages/Component_1.razor?name=WriteTaskDurationToConsole)]


# [BLAZOR](#tab/blazor)

## Generic Read-Only view 

[!code-html[](../app/ix-blazor/Pages/Component_1.razor?name=GenericComponentStatusView)]

## Generic control view 

[!code-html[](../app/ix-blazor/Pages/Component_1.razor?name=GenericComponentCommandView)]

## Type agnostic using RenderableContentControl status (Read-Only) view

[!code-html[](../app/ix-blazor/Pages/Component_1.razor?name=RccComponentStatusView)]


## Type agnostic using RenderableContentControl control view

[!code-html[](../app/ix-blazor/Pages/Component_1.razor?name=RccComponentCommandView)]

---
