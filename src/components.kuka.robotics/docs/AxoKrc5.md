# AxoKrc5

_KUKA KRC5 industrial robot controller proxy_

`AxoKrc5` (namespace `AXOpen.Components.Kuka.Robotics.v_5_x_x`) is the
controller proxy for robots driven by a KUKA **KRC5** controller. It extends
`AXOpen.Core.AxoComponent` and implements
`AXOpen.Components.Abstractions.Robotics.IAxoRobotics`, exposing all programme
and motion commands as `AxoTask` instances that advance their state machine
inside the component's `Run()` call.

## Relationship to `AxoKrc4`

`AxoKrc5` exposes the **same public API** as [`AxoKrc4`](AxoKrc4.md) — the
tasks, configuration members, status type, error catalogue, and `Run(inParent,
hwID)` signature are identical, and so is the AXOpen slot layout (slot 1
reserved/empty, slot 2 = `DIO512` with 64-byte cyclic I/O). Refer to the
[`AxoKrc4`](AxoKrc4.md) page for:

- The full capabilities list, configuration parameter table, and Config /
  HWIDs declarations.
- The .NET twin and Blazor wiring patterns (the patterns transfer 1:1 — only
  the type name changes).
- The error-state semantics (programming errors 700/701, hardware bring-up
  errors 702/710/720–726/1130–1133, transport errors 1201/1231, runtime
  safety errors 20001–20005, task-`potential` IDs in the 500-range).

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
(structurally identical to `AxoKrc4_Config`). The defaults (`InfoTime =
LT#2S`, `ErrorTime = LT#5S`, `TaskTimeout = LT#50S`) match KRC4 — see the
[`AxoKrc4` configuration table](AxoKrc4.md#configuration) for the meaning of
each field.

[!code-smalltalk[](../ctrl/src/AxoKrc5/v_5_x_x/TypesStructuresAndEnums/AxoKrc5_Config.st?name=AxoKrc5ConfigDeclaration)]

[!code-smalltalk[](../ctrl/src/AxoKrc5/v_5_x_x/TypesStructuresAndEnums/AxoKrc5_HWIDs.st?name=AxoKrc5HWIDsDeclaration)]

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

`AxoKrc5` does not ship a dedicated Blazor view at this time; it renders via
the generic `AxoComponent` pattern using `RenderableContentControl`, which
inspects the component type at runtime and selects the matching rendering
based on the `Presentation` attribute.

## Status display

[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/components-kuka-robotics/Documentation/KukaRobotics.razor?name=GenericComponentStatusView)]

## Command control

[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/components-kuka-robotics/Documentation/KukaRobotics.razor?name=GenericComponentCommandView)]

Available `Presentation` values: `Status-Display`, `Command-Control`, `Service-Control`, `Spot`, `Compact`.

## Source

View the Blazor package at [`AXOpen.Components.Kuka.Robotics.blazor`](https://github.com/Inxton/AXOpen/tree/dev/src/components.kuka.robotics/src/AXOpen.Components.Kuka.Robotics.blazor/).

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
