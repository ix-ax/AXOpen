# Component_1

# [CONTROLLER](#tab/controller)

# How to use component in controller

## Declare component
[!code-pascal[](../../showcase/app/src/ComponentsDrives/Documentation/Component_1.st?name=ComponentDeclaration)]

## Declare initialization variables

*Most of the initialization variable will come from the I/O system. This example is only for demostrational puproses.*

[!code-pascal[](../../showcase/app/src/ComponentsDrives/Documentation/Component_1.st?name=InitializationArgumentsDeclaration)]

## Initialize & Run

[!code-pascal[](../../showcase/app/src/ComponentsDrives/Documentation/Component_1.st?name=Initialization)]

[!INCLUDE [IntializeAndRun](../../../docfx/articles/notes/CYCLIC_UPDATE_NOTICE.md)]

## Use
[!code-pascal[](../../showcase/app/src/ComponentsDrives/Documentation/Component_1.st?name=Usage)]

# [.NET TWIN](#tab/twin)


[!code-csharp[](../../showcase/app/ix-blazor/showcase.blazor/Pages/Drives/Component_1.razor?name=WriteTaskDurationToConsole)]


# [BLAZOR](#tab/blazor)

## Generic Read-Only view 

[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/Drives/Documentation.razor?name=GenericComponentStatusView)]

## Generic control view 

[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/Drives/Documentation.razor?name=GenericComponentCommandView)]

## Type agnostic using RenderableContentControl status (Read-Only) view

[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/Drives/Documentation.razor?name=RccComponentStatusView)]


## Type agnostic using RenderableContentControl control view

[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/Drives/Documentation.razor?name=RccComponentCommandView)]

---
