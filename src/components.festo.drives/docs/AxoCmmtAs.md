# AxoCmmtAs

_Festo CMMT-AS servo drive via PROFINET_

Generated documentation for the `AxoCmmtAs` component.

# [CONTROLLER](#tab/controller)

## Declare component

[!code-pascal[](../../showcase/app/src/components.festo.drives/Documentation/AxoCmmtAs_Showcase.st?name=ComponentDeclaration)]

## Declare initialization variables

*Most of the initialization variables come from the I/O system. The example below is for demonstration purposes.*

[!code-pascal[](../../showcase/app/src/components.festo.drives/Documentation/AxoCmmtAs_Showcase.st?name=InitializationArgumentsDeclaration)]

## Initialize & Run

[!code-pascal[](../../showcase/app/src/components.festo.drives/Documentation/AxoCmmtAs_Showcase.st?name=Initialization)]

[!INCLUDE [IntializeAndRun](../../../docfx/articles/notes/CYCLIC_UPDATE_NOTICE.md)]

## Use

[!code-pascal[](../../showcase/app/src/components.festo.drives/Documentation/AxoCmmtAs_Showcase.st?name=Usage)]

## Positioning tolerance

A positioning move only completes when the drive asserts `Telegram111_In.ZSW1.targetPosReached` (bit X10) **and** the actual position is within the configured in-position window — `ABS(Position - ActualPosition) <= Config.InPositionWindow`. This prevents the move from advancing while the axis is still off target (for example after a torque-control phase).

The window is configured on the drive's `AxoDrive_Config` (provided by the `components.drives` base library):

| Parameter | Type | Default | Purpose |
|---|---|---|---|
| `InPositionWindow` | `LREAL` | `0.05` | Maximum allowed deviation between commanded `Position` and `ActualPosition` (in axis position units) for a move to count as complete. |

See [`TROUBLES.md`](TROUBLES.md#a-positioning-move-reports-complete-while-the-axis-is-not-at-the-commanded-target) for tuning guidance.

## Source

View the library source at [`AxoCmmtAs.st`](https://github.com/Inxton/AXOpen/tree/3-unify-showcase/src/components.festo.drives/ctrl/src/AxoCmmtAs/AxoCmmtAs.st).

# [.NET TWIN](#tab/twin)


## Source

View the .NET twin source at [`AXOpen.Components.Festo.Drives`](https://github.com/Inxton/AXOpen/tree/3-unify-showcase/src/components.festo.drives/src/AXOpen.Components.Festo.Drives/).

# [BLAZOR](#tab/blazor)

`AxoCmmtAs` ships a dedicated Blazor view (`AxoCmmtAsView`) supporting multiple presentations.

## Status display

[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/components-festo-drives/Documentation/FestoDrives.razor?name=AxoCmmtAsStatusView)]

## Command control

[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/components-festo-drives/Documentation/FestoDrives.razor?name=AxoCmmtAsCommandView)]

## Generic rendering

Alternatively, render via `RenderableContentControl` which inspects the component at runtime:

[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/components-festo-drives/Documentation/FestoDrives.razor?name=RccComponentStatusView)]

[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/components-festo-drives/Documentation/FestoDrives.razor?name=RccComponentCommandView)]

## Source

View the dedicated view at [`AxoCmmtAsView.razor`](https://github.com/Inxton/AXOpen/tree/3-unify-showcase/src/components.festo.drives/src/AXOpen.Components.Festo.Drives.blazor/AxoCmmtAs/AxoCmmtAsView.razor).

# [HARDWARE](#tab/hardware)

## Device template

PROFINET hardware template at `showcase/app/hwc/library_templates/festo_drives_cmmt_as/`.

## Device instantiation

[!code-yaml[](../../showcase/app/hwc/plc_line.hwl.yml?name=FestoCmmtAsDevice)]

## IO system wiring

[!code-yaml[](../../showcase/app/hwc/plc_line.hwl.yml?name=FestoCmmtAsIoSystem)]

---
