# Component_1

# [CONTROLLER](#tab/controller)

# How to use component in controller

## Declare component
[!code-pascal[](../../showcase/app/src/components.drives/Documentation/AxoDriveExample_Showcase.st?name=ComponentDeclaration)]

## Declare initialization variables

*Most of the initialization variable will come from the I/O system. This example is only for demostrational puproses.*

[!code-pascal[](../../showcase/app/src/components.drives/Documentation/AxoDriveExample_Showcase.st?name=InitializationArgumentsDeclaration)]

## Initialize & Run

[!code-pascal[](../../showcase/app/src/components.drives/Documentation/AxoDriveExample_Showcase.st?name=Initialization)]

[!INCLUDE [IntializeAndRun](../../../docfx/articles/notes/CYCLIC_UPDATE_NOTICE.md)]

## Use
[!code-pascal[](../../showcase/app/src/components.drives/Documentation/AxoDriveExample_Showcase.st?name=Usage)]

# [.NET TWIN](#tab/twin)


[!code-csharp[](../../showcase/app/ix-blazor/showcase.blazor/Pages/components-drives/Documentation/Component_1.razor?name=WriteTaskDurationToConsole)]


# [BLAZOR](#tab/blazor)

## Generic Read-Only view 

[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/components-drives/Documentation/Documentation.razor?name=GenericComponentStatusView)]

## Generic control view 

[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/components-drives/Documentation/Documentation.razor?name=GenericComponentCommandView)]

## Type agnostic using RenderableContentControl status (Read-Only) view

[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/components-drives/Documentation/Documentation.razor?name=RccComponentStatusView)]


## Type agnostic using RenderableContentControl control view

[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/components-drives/Documentation/Documentation.razor?name=RccComponentCommandView)]

---
