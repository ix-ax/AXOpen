# IOLinkET200SP & Balluff I/O

# [CONTROLLER](#tab/controller)

## How to use component in controller

## Declare component
[!code-pascal[](../../showcase/app/docs-snippets/io-src/Documentation/Component_4.st?name=ComponentDeclaration)]

## Declare initialization variables

*Most of the initialization variables will come from the I/O system. This example is only for demonstrational purposes.*

[!code-pascal[](../../showcase/app/docs-snippets/io-src/Documentation/Component_4.st?name=InitializationArgumentsDeclaration)]

## Initialize & Run

[!code-pascal[](../../showcase/app/docs-snippets/io-src/Documentation/Component_4.st?name=Initialization)]

[!INCLUDE [IntializeAndRun](../../../docfx/articles/notes/CYCLIC_UPDATE_NOTICE.md)]

## Use
[!code-pascal[](../../showcase/app/docs-snippets/io-src/Documentation/Component_4.st?name=Usage)]

# [.NET TWIN](#tab/twin)


[!code-csharp[](../../showcase/app/ix-blazor/showcase.blazor/Pages/Io/Component_4.razor?name=WriteTaskDurationToConsole)]


# [BLAZOR](#tab/blazor)

## Generic Read-Only view 

[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/Io/Component_4.razor?name=GenericComponentStatusView)]

## Generic control view 

[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/Io/Component_4.razor?name=GenericComponentCommandView)]

## Type agnostic using RenderableContentControl status (Read-Only) view

[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/Io/Component_4.razor?name=RccComponentStatusView)]


## Type agnostic using RenderableContentControl control view

[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/Io/Component_4.razor?name=RccComponentCommandView)]

---
