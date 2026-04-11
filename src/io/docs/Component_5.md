# Hardware Diagnostics

# [CONTROLLER](#tab/controller)

## How to use component in controller

## Declare component
[!code-pascal[](../../showcase/app/docs-snippets/io-src/Documentation/Component_5.st?name=ComponentDeclaration)]

## Declare initialization variables

*Most of the initialization variables will come from the I/O system. This example is only for demonstrational purposes.*

[!code-pascal[](../../showcase/app/docs-snippets/io-src/Documentation/Component_5.st?name=InitializationArgumentsDeclaration)]

## Initialize & Run

[!code-pascal[](../../showcase/app/docs-snippets/io-src/Documentation/Component_5.st?name=Initialization)]

[!INCLUDE [IntializeAndRun](../../../docfx/articles/notes/CYCLIC_UPDATE_NOTICE.md)]

## Use
[!code-pascal[](../../showcase/app/docs-snippets/io-src/Documentation/Component_5.st?name=Usage)]

# [.NET TWIN](#tab/twin)

> [!NOTE]
> In order to interpret numeric values of hardware ids as meaningful names we need to provide mapping of name-value pairs. 

[!code-csharp[](../../showcase/app/ix-blazor/showcase.blazor/Pages/io/Documentation/Component_5.razor?name=SpecifyNameValues)]


# [BLAZOR](#tab/blazor)

## Generic Read-Only view 

[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/io/Documentation/Component_5.razor?name=GenericComponentStatusView)]

## Generic control view 

[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/io/Documentation/Component_5.razor?name=GenericComponentCommandView)]

## Type agnostic using RenderableContentControl status (Read-Only) view

[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/io/Documentation/Component_5.razor?name=RccComponentStatusView)]


## Type agnostic using RenderableContentControl control view

[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/io/Documentation/Component_5.razor?name=RccComponentCommandView)]

---
