# AxoKrc5

_KUKA KRC5 industrial robot controller proxy_

`AxoKrc5` (namespace `AXOpen.Components.Kuka.Robotics.v_5_x_x`) is the
controller proxy for robots driven by a KUKA **KRC5** controller. It extends
`AXOpen.Core.AxoComponent` and implements
`AXOpen.Components.Abstractions.Robotics.IAxoRobotics`, exposing all programme
and motion commands as `AxoTask` instances that advance their state machine
inside the component's `Run()` call.

## Relationship to `AxoKrc4`

`AxoKrc5` shares **almost all** of its public API with
[`AxoKrc4`](AxoKrc4.md) — the tasks, configuration members, status type,
`Run(inParent, hwID)` signature, and the AXOpen slot layout (slot 1
reserved/empty, slot 2 = `DIO512` with 64-byte cyclic I/O) are the same.
Refer to the [`AxoKrc4`](AxoKrc4.md) page for:

- The full capabilities list, configuration parameter table, and Config /
  HWIDs declarations.
- The .NET twin and Blazor wiring patterns (the patterns transfer 1:1 — only
  the type name changes).
- The shared error-state semantics (programming errors 700/701, hardware
  bring-up errors 702/710/720–726/1130–1133, transport errors 1201/1231,
  runtime safety errors 20001–20005, task-`potential` IDs in the 500-range).

> [!NOTE]
> Since the KRC5 fixes in **#1148** and **#1168**, `AxoKrc5` has diverged
> from `AxoKrc4` in the following KRC5-only respects (none of these are
> present on `AxoKrc4`):
>
> - It exposes the raw byte-array data-exchange members
>   `DataFromPlcToRobot` / `DataFromRobotToPlc` (see [Data exchange](#data-exchange)).
> - It raises additional coordinate-mirror task-`potential` identifiers
>   **1501–1506** and **1511–1516** (see the
>   [TROUBLES error reference](TROUBLES.md#task-potential-waiting-on-input-identifiers)).
> - Input bit `%X2` is **`Inputs.LocalEstopOk`** ("Local Emergency Stop OK",
>   #1168) — on `AxoKrc4` the same bit is still `Inputs.Automatic`. Whenever
>   `LocalEstopOk` is `FALSE`, `AxoKrc5` raises error **20006**
>   unconditionally — every cycle, not only while a task is busy (unlike
>   20001–20005).
> - Safety message **20002** is keyed on `Inputs.ExternalAutomatic = FALSE`
>   while a task is busy (#1168 — previously `Inputs.Automatic`, which no
>   longer exists on KRC5) and is raised as `Info`, where `AxoKrc4` raises
>   its `Inputs.Automatic`-keyed 20002 as `Error`.
> - The task-duration watchdog is **opt-in** (#1168): every task except
>   `StartMotors` calls
>   `ThrowWhen(Duration >= Config.TaskTimeout AND Config.TaskTimeout > T#0s, '{TaskName} timeout.')`,
>   and the default `Config.TaskTimeout = LT#0S` keeps it disabled. The
>   `Config.ErrorTime` (`_errorTimer.output`) watchdog remains removed
>   (#1167). `AxoKrc4` still applies both watchdogs with non-zero defaults.
> - While a busy task is waiting and the robot reports `Inputs.StopMess`,
>   `AxoKrc5` automatically pulses `Outputs.ErrorConfirmation` (gated by the
>   component blinker) to try to acknowledge the robot-side error (#1168).
> - The component blinker is ticked once per `Run()` cycle with a fixed
>   `BLINKER_TIME = T#1S` on/off period (#1168 — previously each task ran
>   its own 500 ms blink while executing).

The differences between KRC4 and KRC5 are confined to:

- **GSDML / vendor firmware version** — KRC5 uses `GSDML-V2.4-KUKA-KR C5-20220704.xml`
  (KR C5, 2022-07-04, note the space in the filename) versus KRC4's
  `GSDML-V2.33-KUKA-KRC4-ProfiNet_5.0-20181102.xml`.
- **PROFINET device template** — `kuka_krc5_dio512.hwl.yml` uses the newer
  hwc address schema (`Type: IPv4/Profinet`) and a 4-port switch interface;
  slot layout is otherwise identical to KRC4.
- **Showcase wiring** — KRC5 is provisioned with `kuka_rb2` (vs. `kuka_rb1`
  for KRC4) and the application uses `AXOpen.Showcase.HwIdentifiers#kuka_rb2_HwID`.

## Configuration

`AxoKrc5` is configured via the nested `Config : AxoKrc5_Config` member
(structurally identical to `AxoKrc4_Config`). See the
[`AxoKrc4` configuration table](AxoKrc4.md#configuration) for the meaning of
each field, but note the KRC5 defaults differ since #1168: `InfoTime = LT#2S`
matches KRC4, while `ErrorTime = LT#0S` and `TaskTimeout = LT#0S` (KRC4
defaults to `LT#5S` / `LT#50S`).

> [!NOTE]
> On `AxoKrc5` the task-duration watchdog is **opt-in** (#1168): with the
> default `TaskTimeout = LT#0S` it is disabled and a stalled task is reported
> through the component's status message only. Setting `TaskTimeout > T#0s`
> arms a per-task `ThrowWhen` that aborts the task with a
> `'{TaskName} timeout.'` error once `Duration` exceeds the configured value
> (every task except `StartMotors`). The `ErrorTime` watchdog remains removed
> on KRC5 (#1167) — the field only feeds the step timers — while `AxoKrc4`
> still applies both watchdogs.

[!code-smalltalk[](../ctrl/src/AxoKrc5/v_5_x_x/TypesStructuresAndEnums/AxoKrc5_Config.st?name=AxoKrc5ConfigDeclaration)]

[!code-smalltalk[](../ctrl/src/AxoKrc5/v_5_x_x/TypesStructuresAndEnums/AxoKrc5_HWIDs.st?name=AxoKrc5HWIDsDeclaration)]

## Data exchange

`AxoKrc5` reserves part of the 64-byte cyclic I/O block for raw,
application-defined payloads that pass through the component untouched
(both members carry `RenderIgnore`, so they are excluded from the proxy
view). This is a KRC5-only addition — `AxoKrc4` does not expose these
members.

| Member | Direction | Mapped onto |
|--------|-----------|-------------|
| `DataFromPlcToRobot : ARRAY[0..19] OF BYTE` | PLC → robot | Output bytes `_data[44..63]`, written each cycle in the output-pack phase of `Run()`. |
| `DataFromRobotToPlc : ARRAY[0..15] OF BYTE` | robot → PLC | Input bytes `_data[48..63]`, copied each cycle after the input-unpack phase of `Run()`. |

Write to `DataFromPlcToRobot` and read from `DataFromRobotToPlc` from
application code; the component transports the bytes verbatim and does not
interpret them. The two ranges overlap on the wire because the PLC→robot
window (`44..63`) is wider than the robot→PLC window (`48..63`) — they occupy
the same physical I/O block in opposite directions.

[!code-smalltalk[](../ctrl/src/AxoKrc5/v_5_x_x/AxoKrc5.st?name=AxoKrc5DataExchangeDeclaration)]

The showcase demonstrates the round-trip — writing an application payload to
`DataFromPlcToRobot` and reading the robot's published bytes from
`DataFromRobotToPlc`:

[!code-pascal[](../../showcase/app/src/components.kuka.robotics/Documentation/AxoKrc5_v_5_x_x_Showcase.st?name=DataExchange)]

# [CONTROLLER](#tab/controller)

## Declare component

[!code-pascal[](../../showcase/app/src/components.kuka.robotics/Documentation/AxoKrc5_v_5_x_x_Showcase.st?name=ComponentDeclaration)]

## Declare initialization variables

*Most of the initialization variables come from the I/O system. The example below is for demonstration purposes.*

[!code-pascal[](../../showcase/app/src/components.kuka.robotics/Documentation/AxoKrc5_v_5_x_x_Showcase.st?name=InitializationArgumentsDeclaration)]

## Initialize & Run

[!code-pascal[](../../showcase/app/src/components.kuka.robotics/Documentation/AxoKrc5_v_5_x_x_Showcase.st?name=Initialization)]

[!INCLUDE [IntializeAndRun](../../../docfx/articles/notes/CYCLIC_UPDATE_NOTICE.md)]

## Use

[!code-pascal[](../../showcase/app/src/components.kuka.robotics/Documentation/AxoKrc5_v_5_x_x_Showcase.st?name=Usage)]

## Source

View the library source at [`AxoKrc5.st`](https://github.com/Inxton/AXOpen/tree/dev/src/components.kuka.robotics/ctrl/src/AxoKrc5/v_5_x_x/AxoKrc5.st).

# [.NET TWIN](#tab/twin)

The .NET twin for `AxoKrc5` mirrors the `AxoKrc4` layout — `AxoKrc5.cs`
(partial class) under `src/AXOpen.Components.Kuka.Robotics/AxoKrc5/v_5_x_x/`
wires `InitializeMessenger` and `InitializeTaskMessenger`, and exposes
`ErrorDescription` / `ActionDescription` on `AxoKrc5_Component_Status`.

## Source

View the .NET twin source at [`AXOpen.Components.Kuka.Robotics/AxoKrc5`](https://github.com/Inxton/AXOpen/tree/dev/src/components.kuka.robotics/src/AXOpen.Components.Kuka.Robotics/AxoKrc5/v_5_x_x/).

# [BLAZOR](#tab/blazor)

`AxoKrc5` ships a dedicated Blazor view (`AxoKrc5View.razor`) inside
`AXOpen.Components.Kuka.Robotics.blazor`, mirroring `AxoKrc4View` 1:1. When
`RenderableContentControl` inspects an `AxoKrc5` context, it picks this view
automatically based on the `Presentation` attribute. Operator commands are
grouped into two tabs — `Movements` (Start/Stop Movements, Restore, Reset
All Outputs, with movement parameters inline) and `Power & Program` (motor
and programme tasks) — laid out as a uniform 2-column grid. If you prefer
the generic `AxoComponent` rendering, use `RenderableContentControl`
directly.

## Status display

[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/components-kuka-robotics/Documentation/KukaRobotics.razor?name=GenericComponentStatusView)]

## Command control

[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/components-kuka-robotics/Documentation/KukaRobotics.razor?name=GenericComponentCommandView)]

## Type-agnostic status view

[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/components-kuka-robotics/Documentation/KukaRobotics.razor?name=RccComponentStatusView)]

## Type-agnostic command view

[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/components-kuka-robotics/Documentation/KukaRobotics.razor?name=RccComponentCommandView)]

Available `Presentation` values: `Status-Display`, `Command-Control`, `Service-Control`, `Spot`, `Compact`.

## Source

View the Blazor view at [`AxoKrc5View.razor`](https://github.com/Inxton/AXOpen/tree/dev/src/components.kuka.robotics/src/AXOpen.Components.Kuka.Robotics.blazor/AxoKrc5/v_5_x_x/AxoKrc5View.razor).

# [HARDWARE](#tab/hardware)

## Library-shipped assets

The raw GSDML and matching PROFINET device template for KRC5 live inside the
library package so `AxoKrc5` can be wired up without fetching files from the
vendor:

- GSDML — [`ctrl/assets/kuka_krc5/GSDML-V2.4-KUKA-KR C5-20220704.xml`](<https://github.com/Inxton/AXOpen/tree/dev/src/components.kuka.robotics/ctrl/assets/kuka_krc5/GSDML-V2.4-KUKA-KR C5-20220704.xml>)
  — vendor GSDML for KR C5 (2022-07-04). The filename contains a space.
- HW template — [`ctrl/assets/kuka_krc5/kuka_krc5_dio512.hwl.yml`](https://github.com/Inxton/AXOpen/tree/dev/src/components.kuka.robotics/ctrl/assets/kuka_krc5/kuka_krc5_dio512.hwl.yml)
  — same slot 1 / slot 2 = `DIO512` layout as KRC4, using the newer hwc
  address schema (`Type: IPv4/Profinet`) and a 4-port switch interface.

The showcase copies the template into `showcase/app/hwc/library_templates/kuka_krc5/`
so application builds do not need a catalog round-trip.

## Device template

PROFINET hardware template at `showcase/app/hwc/library_templates/kuka_krc5/kuka_krc5_dio512.hwl.yml`.

The template provisions a KRC5 as a PROFINET device with two slots:

| Slot | Module | Purpose |
|------|--------|---------|
| 1 | *(safety module, left empty by the template)* | Reserved — `AxoKrc5.Run()` verifies this slot resolves to `HwID_None = 0`. |
| 2 | `512_DI_DO` | 64-byte in / 64-byte out PROFINET I/O cyclically transferred by the component. |

## I/O mapping

`Run()` takes a single `hwID : UINT` that identifies the KRC5 device in the
configured hardware layout. The slot-resolution flow and per-cycle I/O
transfer are identical to KRC4 — see
[`AxoKrc4` I/O mapping](AxoKrc4.md#io-mapping) for the step-by-step
breakdown. Use `AXOpen.Showcase.HwIdentifiers#kuka_rb2_HwID` to supply
`hwID` from application code.

## KRC5 device instantiation

[!code-yaml[](../../showcase/app/hwc/plc_line.hwl.yml?name=KukaKrc5Device)]

## KRC5 IO system wiring

[!code-yaml[](../../showcase/app/hwc/plc_line.hwl.yml?name=KukaKrc5IoSystem)]

---
