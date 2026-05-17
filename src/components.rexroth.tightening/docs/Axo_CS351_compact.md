# Axo_CS351_compact

_Rexroth CS351 compact tightening controller_

Generated documentation for the `Axo_CS351_compact` component.

# [CONTROLLER](#tab/controller)

## Declare component

[!code-pascal[](../../showcase/app/src/components.rexroth.tightening/Documentation/Axo_CS351_compact_Showcase.st?name=ComponentDeclaration)]

## Declare initialization variables

*Most of the initialization variables come from the I/O system. The example below is for demonstration purposes.*

[!code-pascal[](../../showcase/app/src/components.rexroth.tightening/Documentation/Axo_CS351_compact_Showcase.st?name=InitializationArgumentsDeclaration)]

## Initialize & Run

[!code-pascal[](../../showcase/app/src/components.rexroth.tightening/Documentation/Axo_CS351_compact_Showcase.st?name=Initialization)]

[!INCLUDE [IntializeAndRun](../../../docfx/articles/notes/CYCLIC_UPDATE_NOTICE.md)]

## Use

[!code-pascal[](../../showcase/app/src/components.rexroth.tightening/Documentation/Axo_CS351_compact_Showcase.st?name=Usage)]

## Source

View the library source at [`Axo_CS351_compact.st`](https://github.com/Inxton/AXOpen/tree/3-unify-showcase/src/components.rexroth.tightening/ctrl/src/Axo_CS351_compact/Axo_CS351_compact.st).

# [.NET TWIN](#tab/twin)


## Source

View the .NET twin source at [`AXOpen.Components.Rexroth.Tightening`](https://github.com/Inxton/AXOpen/tree/3-unify-showcase/src/components.rexroth.tightening/src/AXOpen.Components.Rexroth.Tightening/).

# [BLAZOR](#tab/blazor)

`Axo_CS351_compact` does not ship a dedicated Blazor view. It renders via the generic `AxoComponent` pattern using `RenderableContentControl`, which inspects the component type at runtime and selects the matching rendering based on the `Presentation` attribute.

## Status display

[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/components-rexroth-tightening/Documentation/RexrothTightening.razor?name=GenericComponentStatusView)]

## Command control

[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/components-rexroth-tightening/Documentation/RexrothTightening.razor?name=GenericComponentCommandView)]

## Type-agnostic status view

[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/components-rexroth-tightening/Documentation/RexrothTightening.razor?name=RccComponentStatusView)]

## Type-agnostic command view

[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/components-rexroth-tightening/Documentation/RexrothTightening.razor?name=RccComponentCommandView)]

Available `Presentation` values: `Status-Display`, `Command-Control`, `Service-Control`, `Spot`, `Compact`.

## Source

View the Blazor package at [`AXOpen.Components.Rexroth.Tightening.blazor`](https://github.com/Inxton/AXOpen/tree/3-unify-showcase/src/components.rexroth.tightening/src/AXOpen.Components.Rexroth.Tightening.blazor/).

# [HARDWARE](#tab/hardware)

## Device template

PROFINET hardware template at `showcase/app/hwc/library_templates/rexroth_tightening_cs351/`.

## Device instantiation

[!code-yaml[](../../showcase/app/hwc/plc_line.hwl.yml?name=RexrothCs351Device)]

## IO system wiring

[!code-yaml[](../../showcase/app/hwc/plc_line.hwl.yml?name=RexrothCs351IoSystem)]

---
