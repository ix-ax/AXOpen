## Description

The **components.kuka.robotics** is a set of libraries covering the product portfolio of the robotics systems from the vendor [Kuka](https://www.kuka.com/en-gb) for the target PLC platform [Siemens AX](https://www.siemens.com/global/en/products/automation/industry-software/automation-software/simatic-ax.html) and [AxOpen](https://github.com/inxton/AXOpen?tab=readme-ov-file) framework.

The package consists of a PLC library providing control logic and its .NET twin counterpart aimed at the visualization part. This package currently covers the robots driven by KRC4 controller.

### Components

| Component | Description |
|-----------|-------------|
| [`AxoKrc4`](AxoKrc4_v_5_x_x.md) | KUKA KRC4 controller proxy (namespace `AXOpen.Components.Kuka.Robotics.v_5_x_x`) exposing programme/motion commands, safety state, tool/zone outputs, and hardware diagnostics. Derives from `AxoComponent` and implements `IAxoRobotics`. |

### Configuration & state types

| Type | Role |
|------|------|
| `AxoKukaRobotics_Config` | Configuration: `InfoTime`, `ErrorTime`, `TaskTimeout`, `HWIDs`. |
| `AxoKukaRobotics_HWIDs` | Hardware identifiers: `HwID_Device`, `HwID_None`, `HwID_512_DI_DO`. |
| `AxoKukaRobotics_State` | Input image (RC_RDY1, ALARM_STOP, USER_SAF, PERI_RDY, ROB_CAL, I_O_ACTCONF, STOPMESS, ROB_STOPPED, mode, position/zone, tool feedback, coordinates). |
| `AxoKukaRobotics_Control` | Output image (EXT_START, MOVE_ENABLE, CONF_MESS, DRIVES_OFF, DRIVES_ON, I_O_ACT, START_AT_MAIN, master mode, tool commands, action/speed/tool/point numbers, coordinates). |
| `AxoKukaRobotics_Component_Status` | Runtime status (extends `AxoRobot_Status`). |

### Packages

| Package | Purpose |
|---------|---------|
| `@inxton/axopen.components.kuka.robotics` | PLC library (apax) |
| `AXOpen.Components.Kuka.Robotics` | .NET twin |
| `AXOpen.Components.Kuka.Robotics.blazor` | Blazor rendering assets |

### Hardware assets

The library ships the KRC4 GSDML and a ready-to-apply PROFINET device
template so the robot can be dropped into a `plc_line.hwl.yml` without
vendor-side configuration:

| Asset | Path | Purpose |
|-------|------|---------|
| GSDML | [`ctrl/assets/kuka_krc4/GSDML-V2.33-KUKA-KRC4-ProfiNet_5.0-20181102.xml`](../ctrl/assets/kuka_krc4/GSDML-V2.33-KUKA-KRC4-ProfiNet_5.0-20181102.xml) | Vendor GSDML (KUKA KRC4 ProfiNet 5.0, 2018-11-02) for Siemens hardware catalog import. |
| HW template | [`ctrl/assets/kuka_krc4/kuka_krc4_dio512.hwl.yml`](../ctrl/assets/kuka_krc4/kuka_krc4_dio512.hwl.yml) | PROFINET device template with slot 1 empty (safety) and slot 2 = `512_DI_DO` (64-byte in / 64-byte out). Expected by `AxoKrc4.Run()`. |

The showcase application uses the same template via
`showcase/app/hwc/library_templates/kuka_krc4/kuka_krc4_dio512.hwl.yml`
and wires it into `plc_line.hwl.yml` under the `<KukaKrc4Device>` region.

### Dependencies

| Package | Purpose |
|---------|---------|
| `@inxton/axopen.components.robotics` | Shared robotics abstractions (`AxoRobot_Status`, task/messenger base types). |

### Links to documentation

[Siemens AX-documentation](https://developer.siemens.com/simatic-ax/developer.html)

[AxOpen-documentation](https://inxton.github.io/AXOpen/)

[KUKA documentation](https://www.kuka.com/en-gb)
