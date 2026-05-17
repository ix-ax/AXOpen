# Axo_IdentDevice

_SIMATIC ident device (generic profile)_

Generated documentation for the `Axo_IdentDevice` component.

# [CONTROLLER](#tab/controller)

## Declare component

[!code-pascal[](../../showcase/app/src/components.siem.identification/Documentation/Axo_IdentDevice_Showcase.st?name=ComponentDeclaration)]

## Declare initialization variables

*Most of the initialization variables come from the I/O system. The example below is for demonstration purposes.*

[!code-pascal[](../../showcase/app/src/components.siem.identification/Documentation/Axo_IdentDevice_Showcase.st?name=InitializationArgumentsDeclaration)]

## Initialize & Run

[!code-pascal[](../../showcase/app/src/components.siem.identification/Documentation/Axo_IdentDevice_Showcase.st?name=Initialization)]

[!INCLUDE [IntializeAndRun](../../../docfx/articles/notes/CYCLIC_UPDATE_NOTICE.md)]

## Use

[!code-pascal[](../../showcase/app/src/components.siem.identification/Documentation/Axo_IdentDevice_Showcase.st?name=Usage)]

## Source

View the library source at [`Axo_IdentDevice.st`](https://github.com/Inxton/AXOpen/tree/3-unify-showcase/src/components.siem.identification/ctrl/src/Axo_IdentDevice/Axo_IdentDevice.st).

# [.NET TWIN](#tab/twin)


## Source

View the .NET twin source at [`AXOpen.Components.Siem.Identification`](https://github.com/Inxton/AXOpen/tree/3-unify-showcase/src/components.siem.identification/src/AXOpen.Components.Siem.Identification/).

# [BLAZOR](#tab/blazor)

`Axo_IdentDevice` does not ship a dedicated Blazor view. It renders via the generic `AxoComponent` pattern using `RenderableContentControl`, which inspects the component type at runtime and selects the matching rendering based on the `Presentation` attribute.

## Status display

[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/components-siem-identification/Documentation/SiemIdentification.razor?name=GenericComponentStatusView)]

## Command control

[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/components-siem-identification/Documentation/SiemIdentification.razor?name=GenericComponentCommandView)]

## Type-agnostic status view

[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/components-siem-identification/Documentation/SiemIdentification.razor?name=RccComponentStatusView)]

## Type-agnostic command view

[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/components-siem-identification/Documentation/SiemIdentification.razor?name=RccComponentCommandView)]

Available `Presentation` values: `Status-Display`, `Command-Control`, `Service-Control`, `Spot`, `Compact`.

## Source

View the Blazor package at [`AXOpen.Components.Siem.Identification.blazor`](https://github.com/Inxton/AXOpen/tree/3-unify-showcase/src/components.siem.identification/src/AXOpen.Components.Siem.Identification.blazor/).

# [HARDWARE](#tab/hardware)

## Device template

PROFINET hardware template at `showcase/app/hwc/library_templates/siemens_identification/`.


## IO system wiring

[!code-yaml[](../../showcase/app/hwc/plc_line.hwl.yml?name=SiemIdentificationIoSystem)]

---
