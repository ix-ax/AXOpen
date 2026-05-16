## Description

The **components.kuka.robotics** is a set of libraries covering the product portfolio of the robotics systems from the vendor [Kuka](https://www.kuka.com/en-gb) for the target PLC platform [Siemens AX](https://www.siemens.com/global/en/products/automation/industry-software/automation-software/simatic-ax.html) and [AxOpen](https://github.com/inxton/AXOpen?tab=readme-ov-file) framework.

The package consists of a PLC library providing control logic and its .NET twin counterpart aimed at the visualization part. This package currently covers robots driven by the **KRC4** and **KRC5** controllers. Both controller families expose the same AXOpen-compatible slot layout (slot 1 reserved, slot 2 = 512 DI / 512 DO, 64-byte cyclic I/O) and are exposed as two sibling proxy classes — `AxoKrc4` and `AxoKrc5` — sharing an identical public API. Only the GSDML and PROFINET device template differ between them.

### Components

| Component | Description |
|-----------|-------------|
| [`AxoKrc4`](AxoKrc4.md) | KUKA **KRC4** controller proxy (namespace `AXOpen.Components.Kuka.Robotics.v_5_x_x`) exposing programme/motion commands, safety state, tool/zone outputs, and hardware diagnostics. Derives from `AxoComponent` and implements `IAxoRobotics`. |
| [`AxoKrc5`](AxoKrc5.md) | KUKA **KRC5** controller proxy (namespace `AXOpen.Components.Kuka.Robotics.v_5_x_x`). Public API is identical to `AxoKrc4`; only the GSDML and PROFINET device template differ. |

### Configuration & state types

Each controller class ships its own set of supporting types in the same
namespace. They are structurally identical between KRC4 and KRC5 — only the
type-name prefix differs.

| Type (per class) | Role |
|------------------|------|
| `AxoKrc{4,5}_Config` | Configuration: `InfoTime`, `ErrorTime`, `TaskTimeout`, `HWIDs`. |
| `AxoKrc{4,5}_HWIDs` | Hardware identifiers: `HwID_Device`, `HwID_None`, `HwID_512_DI_DO`. |
| `AxoKrc{4,5}_State` | Input image (RC_RDY1, ALARM_STOP, USER_SAF, PERI_RDY, ROB_CAL, I_O_ACTCONF, STOPMESS, ROB_STOPPED, mode, position/zone, tool feedback, coordinates). |
| `AxoKrc{4,5}_Control` | Output image (EXT_START, MOVE_ENABLE, CONF_MESS, DRIVES_OFF, DRIVES_ON, I_O_ACT, START_AT_MAIN, master mode, tool commands, action/speed/tool/point numbers, coordinates). |
| `AxoKrc{4,5}_Component_Status` | Runtime status (extends `AxoRobot_Status`). |

### Packages

| Package | Purpose |
|---------|---------|
| `@inxton/axopen.components.kuka.robotics` | PLC library (apax) |
| `AXOpen.Components.Kuka.Robotics` | .NET twin |
| `AXOpen.Components.Kuka.Robotics.blazor` | Blazor rendering assets |

### Hardware assets

The library ships GSDMLs and ready-to-apply PROFINET device templates for
both KRC4 and KRC5, so either controller can be dropped into a
`plc_line.hwl.yml` without vendor-side configuration:

| Controller | Asset | Path | Purpose |
|------------|-------|------|---------|
| KRC4 | GSDML | [`ctrl/assets/kuka_krc4/GSDML-V2.33-KUKA-KRC4-ProfiNet_5.0-20181102.xml`](../ctrl/assets/kuka_krc4/GSDML-V2.33-KUKA-KRC4-ProfiNet_5.0-20181102.xml) | Vendor GSDML (KUKA KRC4 ProfiNet 5.0, 2018-11-02) for Siemens hardware catalog import. |
| KRC4 | HW template | [`ctrl/assets/kuka_krc4/kuka_krc4_dio512.hwl.yml`](../ctrl/assets/kuka_krc4/kuka_krc4_dio512.hwl.yml) | PROFINET device template with slot 1 empty (safety) and slot 2 = `512_DI_DO` (64-byte in / 64-byte out). Expected by `AxoKrc4.Run()`. |
| KRC5 | GSDML | [`ctrl/assets/kuka_krc5/GSDML-V2.4-KUKA-KR C5-20220704.xml`](<../ctrl/assets/kuka_krc5/GSDML-V2.4-KUKA-KR C5-20220704.xml>) | Vendor GSDML (KUKA KR C5, 2022-07-04) — note the space in the filename. |
| KRC5 | HW template | [`ctrl/assets/kuka_krc5/kuka_krc5_dio512.hwl.yml`](../ctrl/assets/kuka_krc5/kuka_krc5_dio512.hwl.yml) | PROFINET device template with the same slot 1 / slot 2 = `512_DI_DO` layout as KRC4, using the newer hwc address schema (`Type: IPv4/Profinet`) and a 4-port switch interface. |

The showcase application copies both templates into
`showcase/app/hwc/library_templates/kuka_krc4/` and `.../kuka_krc5/` and
wires them into `plc_line.hwl.yml` under the `<KukaKrc4Device>` and
`<KukaKrc5Device>` regions respectively.

### Dependencies

| Package | Purpose |
|---------|---------|
| `@inxton/axopen.components.robotics` | Shared robotics abstractions (`AxoRobot_Status`, task/messenger base types). |

### Links to documentation

[Siemens AX-documentation](https://developer.siemens.com/simatic-ax/developer.html)

[AxOpen-documentation](https://inxton.github.io/AXOpen/)

[KUKA documentation](https://www.kuka.com/en-gb)

[KUKA KRC4 controller family](https://www.kuka.com/en-gb/products/robotics-systems/industrial-robots/controllers/kr-c4)

[KUKA KRC5 controller family](https://www.kuka.com/en-gb/products/robotics-systems/industrial-robots/controllers/kr-c5)
