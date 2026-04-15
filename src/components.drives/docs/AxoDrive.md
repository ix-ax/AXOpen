# AxoDrive

_Abstract base class for vendor drive implementations_

Generated documentation for the `AxoDrive` component.

# [CONTROLLER](#tab/controller)

## Declare component

[!code-pascal[](../../showcase/app/src/components.drives/Documentation/AxoDriveExample_Showcase.st?name=ComponentDeclaration)]

## Declare initialization variables

*Most of the initialization variables come from the I/O system. The example below is for demonstration purposes.*

[!code-pascal[](../../showcase/app/src/components.drives/Documentation/AxoDriveExample_Showcase.st?name=InitializationArgumentsDeclaration)]

## Initialize & Run

[!code-pascal[](../../showcase/app/src/components.drives/Documentation/AxoDriveExample_Showcase.st?name=Initialization)]

[!INCLUDE [IntializeAndRun](../../../docfx/articles/notes/CYCLIC_UPDATE_NOTICE.md)]

## Use

[!code-pascal[](../../showcase/app/src/components.drives/Documentation/AxoDriveExample_Showcase.st?name=Usage)]


## Additional scenario

A second instance is provided in `AxoDriveExample_Showcase2.st`:

[!code-pascal[](../../showcase/app/src/components.drives/Documentation/AxoDriveExample_Showcase2.st?name=Initialization)]

## Source

View the library source at [`AxoDrive.st`](https://github.com/Inxton/AXOpen/tree/3-unify-showcase/src/components.drives/ctrl/src/AxoDrives/AxoDrive.st).

# [.NET TWIN](#tab/twin)


## Source

View the .NET twin source at [`AXOpen.ComponentsDrives`](https://github.com/Inxton/AXOpen/tree/3-unify-showcase/src/components.drives/src/AXOpen.ComponentsDrives/).

# [BLAZOR](#tab/blazor)

`AxoDrive` does not ship a dedicated Blazor view. It renders via the generic `AxoComponent` pattern using `RenderableContentControl`, which inspects the component type at runtime and selects the matching rendering based on the `Presentation` attribute.

## Status display

[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/components-drives/Documentation/DrivesShowcase.razor?name=GenericComponentStatusView)]

## Command control

[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/components-drives/Documentation/DrivesShowcase.razor?name=GenericComponentCommandView)]

## Type-agnostic status view

[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/components-drives/Documentation/DrivesShowcase.razor?name=RccComponentStatusView)]

## Type-agnostic command view

[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/components-drives/Documentation/DrivesShowcase.razor?name=RccComponentCommandView)]

Available `Presentation` values: `Status-Display`, `Command-Control`, `Service-Control`, `Spot`, `Compact`.

## Source

View the Blazor package at [`AXOpen.ComponentsDrives.blazor`](https://github.com/Inxton/AXOpen/tree/3-unify-showcase/src/components.drives/src/AXOpen.ComponentsDrives.blazor/).

---
