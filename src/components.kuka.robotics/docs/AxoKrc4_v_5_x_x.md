# AxoKrc4_v_5_x_x

_KUKA KRC4 industrial robot controller_

`AxoKrc4` (namespace `AXOpen.Components.Kuka.Robotics.v_5_x_x`) is the
controller proxy for robots driven by a KUKA KRC4. It extends
`AXOpen.Core.AxoComponent` and implements
`AXOpen.Components.Abstractions.Robotics.IAxoRobotics`, exposing all programme
and motion commands as `AxoTask` instances that advance their state machine
inside the component's `Run()` call.

## Capabilities

- Programme control — `StartAtMain`, `StartProgram`, `StopProgram`, `StartMotorsAndProgram`, `StopMovementsAndProgram`.
- Motor control — `StartMotors`, `StopMotors`.
- Motion commands — `StartMovements(movementParams)`, `StopMovements`,
  and a combined `StartMotorsProgramAndMovements(movementParams)`.
- Safety-interlocked task execution — every task checks `Inputs.Manual`,
  `Inputs.Automatic`, `Inputs.AlarmStopActive`, `Inputs.UserSafetySwitchClosed`,
  and `Inputs.Error` while busy (error IDs 20001–20005).
- Hardware wiring — consumes a PROFINET device identifier; the `Run()`
  method auto-resolves the child slot layout (slot 1 safety-module = empty,
  slot 2 = 512 DI / 512 DO) via `ReadSlotFromHardwareID` and
  `ReadHardwareIOAddress` during first cycle.
- Cyclic I/O transfer — `Siemens.Simatic.DistributedIO.ReadData`/`WriteData`
  on slot 2 each cycle (error IDs 1201 / 1231 on transport failure).
- Tool / area / position / coordinate outputs driven from `MovementParameters`.
- Hardware diagnostics task (`HardwareDiagnosticsTask`) and two on-delay
  info/error timers (`Config.InfoTime`, `Config.ErrorTime`,
  `Config.TaskTimeout`).

## Configuration

The component is configured via the nested `Config : AxoKukaRobotics_Config`
member. Adjust these before invoking `Run()`; they can also be set from the
commissioning UI.

| Parameter | Type | Default | Purpose |
|-----------|------|---------|---------|
| `Config.InfoTime` | `LTIME` | `LT#2S` | Delay before a task publishes a *potential* (waiting-for-signal) message. Controls how long the component waits silently on an expected input before surfacing progress via `TaskMessenger`. |
| `Config.ErrorTime` | `LTIME` | `LT#5S` | Delay before `_errorTimer.output` throws the currently-executing task. Acts as a per-step watchdog on KRC4 responses. |
| `Config.TaskTimeout` | `LTIME` | `LT#50S` | Hard upper bound for a task's total duration. `0s` disables the timeout (used in the showcase so commissioning demos never self-abort). |
| `Config.HWIDs` | `AxoKukaRobotics_HWIDs` | — | Device hardware identifiers, auto-populated on first `Run()` from the `hwID` argument and the slot layout. |

[!code-smalltalk[](../ctrl/src/AxoKukaRobotics_Datatypes_v_5_x_x/AxoKukaRobotics_Config.st?name=AxoKukaRoboticsConfigDeclaration)]

[!code-smalltalk[](../ctrl/src/AxoKukaRobotics_Datatypes_v_5_x_x/AxoKukaRobotics_HWIDs.st?name=AxoKukaRoboticsHWIDsDeclaration)]

# [CONTROLLER](#tab/controller)

## Declare component

[!code-pascal[](../../showcase/app/src/components.kuka.robotics/Documentation/AxoKrc4_v_5_x_x_Showcase.st?name=ComponentDeclaration)]

## Declare initialization variables

*Most of the initialization variables come from the I/O system. The example below is for demonstration purposes.*

[!code-pascal[](../../showcase/app/src/components.kuka.robotics/Documentation/AxoKrc4_v_5_x_x_Showcase.st?name=InitializationArgumentsDeclaration)]

## Initialize & Run

[!code-pascal[](../../showcase/app/src/components.kuka.robotics/Documentation/AxoKrc4_v_5_x_x_Showcase.st?name=Initialization)]

[!INCLUDE [IntializeAndRun](../../../docfx/articles/notes/CYCLIC_UPDATE_NOTICE.md)]

## Use

[!code-pascal[](../../showcase/app/src/components.kuka.robotics/Documentation/AxoKrc4_v_5_x_x_Showcase.st?name=Usage)]

## Alternative example

A second wired-up instance (`AxoKrc4_v_5_x_x_Showcase2`) is available and is
rendered side-by-side on the showcase Blazor page. It reuses the same
hardware identifier `kuka_rb1_HwID` and differs only in that it keeps
`Config.ErrorTime` at the library default (live error watchdog) instead of
zeroing it out for commissioning.

[!code-pascal[](../../showcase/app/src/components.kuka.robotics/Documentation/AxoKrc4_v_5_x_x_Showcase2.st?name=ComponentDeclaration)]
[!code-pascal[](../../showcase/app/src/components.kuka.robotics/Documentation/AxoKrc4_v_5_x_x_Showcase2.st?name=Initialization)]

## Source

View the library source at [`AxoKrc4_v_5_x_x.st`](https://github.com/Inxton/AXOpen/tree/dev/src/components.kuka.robotics/ctrl/src/AxoKrc4_v_5_x_x.st).

# [.NET TWIN](#tab/twin)


## Source

View the .NET twin source at [`AXOpen.Components.Kuka.Robotics`](https://github.com/Inxton/AXOpen/tree/dev/src/components.kuka.robotics/src/AXOpen.Components.Kuka.Robotics/).

# [BLAZOR](#tab/blazor)

`AxoKrc4` does not ship a dedicated Blazor view. It renders via the generic `AxoComponent` pattern using `RenderableContentControl`, which inspects the component type at runtime and selects the matching rendering based on the `Presentation` attribute.

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

View the Blazor package at [`AXOpen.Components.Kuka.Robotics.blazor`](https://github.com/Inxton/AXOpen/tree/dev/src/components.kuka.robotics/src/AXOpen.Components.Kuka.Robotics.blazor/).

# [HARDWARE](#tab/hardware)

## Library-shipped assets

The raw KRC4 GSDML and the matching PROFINET device template live inside
the library package so `AxoKrc4` can be wired up without fetching files
from the vendor:

- GSDML — [`ctrl/assets/kuka_krc4/GSDML-V2.33-KUKA-KRC4-ProfiNet_5.0-20181102.xml`](https://github.com/Inxton/AXOpen/tree/dev/src/components.kuka.robotics/ctrl/assets/kuka_krc4/GSDML-V2.33-KUKA-KRC4-ProfiNet_5.0-20181102.xml)
  — vendor GSDML for Siemens hardware-catalog import.
- HW template — [`ctrl/assets/kuka_krc4/kuka_krc4_dio512.hwl.yml`](https://github.com/Inxton/AXOpen/tree/dev/src/components.kuka.robotics/ctrl/assets/kuka_krc4/kuka_krc4_dio512.hwl.yml)
  — PROFINET device template expected by `Run()` (slot 1 empty, slot 2 = `512_DI_DO`, 64-byte cyclic I/O).

The showcase copies the template into `showcase/app/hwc/library_templates/kuka_krc4/`
so application builds do not need a catalog round-trip.

## Device template

PROFINET hardware template at `showcase/app/hwc/library_templates/kuka_krc4/kuka_krc4_dio512.hwl.yml`.

The template provisions a KRC4 as a PROFINET device with two slots:

| Slot | Module | Purpose |
|------|--------|---------|
| 1 | *(safety module, left empty by the template)* | Reserved — `AxoKrc4.Run()` verifies this slot resolves to `HwID_None = 0`. |
| 2 | `512_DI_DO` | 64-byte in / 64-byte out PROFINET I/O cyclically transferred by the component. |

## I/O mapping

`Run()` takes a single `hwID : UINT` that identifies the KRC4 device in the
configured hardware layout. The component then:

1. Calls `ReadSlotFromHardwareID(hwID)` to obtain the device's geographic
   address.
2. Reads the hardware ID of slot 1 and asserts it is `0` (no safety module
   wired — error 710 otherwise).
3. Reads the hardware ID of slot 2 (the 512 DI / 512 DO module) and caches
   it in `Config.HWIDs.HwID_512_DI_DO`.
4. Calls `ReadHardwareIOAddress` on slot 2 and asserts it exposes exactly
   64 input and 64 output bytes (error 726 otherwise).
5. Each cycle thereafter: `Siemens.Simatic.DistributedIO.ReadData` /
   `WriteData` transfer the 64-byte blocks bound to `Inputs` / `Outputs`.

Use the `AXOpen.Showcase.HwIdentifiers#{device}_HwID` constants to supply
`hwID` from application code (as the showcase does with
`kuka_rb1_HwID`).

## Device instantiation

[!code-yaml[](../../showcase/app/hwc/plc_line.hwl.yml?name=KukaKrc4Device)]

## IO system wiring

[!code-yaml[](../../showcase/app/hwc/plc_line.hwl.yml?name=KukaKrc4IoSystem)]

---
