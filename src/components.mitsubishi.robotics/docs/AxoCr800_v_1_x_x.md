# AxoCr800_v_1_x_x

_Mitsubishi CR800 industrial robot controller_

Generated documentation for the `AxoCr800_v_1_x_x` component.

# [CONTROLLER](#tab/controller)

## Declare component

[!code-pascal[](../../showcase/app/src/components.mitsubishi.robotics/Documentation/AxoCr800_v_1_x_x_Showcase.st?name=ComponentDeclaration)]

## Declare initialization variables

*Most of the initialization variables come from the I/O system. The example below is for demonstration purposes.*

[!code-pascal[](../../showcase/app/src/components.mitsubishi.robotics/Documentation/AxoCr800_v_1_x_x_Showcase.st?name=InitializationArgumentsDeclaration)]

## Initialize & Run

[!code-pascal[](../../showcase/app/src/components.mitsubishi.robotics/Documentation/AxoCr800_v_1_x_x_Showcase.st?name=Initialization)]

[!INCLUDE [IntializeAndRun](../../../docfx/articles/notes/CYCLIC_UPDATE_NOTICE.md)]

## Use

[!code-pascal[](../../showcase/app/src/components.mitsubishi.robotics/Documentation/AxoCr800_v_1_x_x_Showcase.st?name=Usage)]

## Source

View the library source at [`AxoCr800_v_1_x_x.st`](https://github.com/Inxton/AXOpen/tree/3-unify-showcase/src/components.mitsubishi.robotics/ctrl/src/AxoCr800_v_1_x_x/AxoCr800_v_1_x_x.st).

# [.NET TWIN](#tab/twin)


## Source

View the .NET twin source at [`AXOpen.Components.Mitsubishi.Robotics`](https://github.com/Inxton/AXOpen/tree/3-unify-showcase/src/components.mitsubishi.robotics/src/AXOpen.Components.Mitsubishi.Robotics/).

# [BLAZOR](#tab/blazor)

`AxoCr800_v_1_x_x` does not ship a dedicated Blazor view. It renders via the generic `AxoComponent` pattern using `RenderableContentControl`, which inspects the component type at runtime and selects the matching rendering based on the `Presentation` attribute.

## Status display

[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/components-mitsubishi-robotics/Documentation/MitsubishiRobotics.razor?name=GenericComponentStatusView)]

## Command control

[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/components-mitsubishi-robotics/Documentation/MitsubishiRobotics.razor?name=GenericComponentCommandView)]

## Type-agnostic status view

[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/components-mitsubishi-robotics/Documentation/MitsubishiRobotics.razor?name=RccComponentStatusView)]

## Type-agnostic command view

[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/components-mitsubishi-robotics/Documentation/MitsubishiRobotics.razor?name=RccComponentCommandView)]

Available `Presentation` values: `Status-Display`, `Command-Control`, `Service-Control`, `Spot`, `Compact`.

## Source

View the Blazor package at [`AXOpen.Components.Mitsubishi.Robotics.blazor`](https://github.com/Inxton/AXOpen/tree/3-unify-showcase/src/components.mitsubishi.robotics/src/AXOpen.Components.Mitsubishi.Robotics.blazor/).

# [HARDWARE](#tab/hardware)

## Device template

PROFINET hardware template at `showcase/app/hwc/library_templates/mitsubishi_tz535/`.

## Device instantiation

[!code-yaml[](../../showcase/app/hwc/plc_line.hwl.yml?name=MitsubishiTz535Device)]

## IO system wiring

[!code-yaml[](../../showcase/app/hwc/plc_line.hwl.yml?name=MitsubishiTz535IoSystem)]

---
