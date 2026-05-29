## Description

The **components.rexroth.drives** is a set of libraries covering the product portfolio of motion systems from the vendor [Rexroth](https://www.boschrexroth.com/en/dc/) for the target PLC platform [Siemens AX](https://www.siemens.com/global/en/products/automation/industry-software/automation-software/simatic-ax.html) and [AxOpen](https://github.com/inxton/AXOpen?tab=readme-ov-file) framework.

The package consists of a PLC library providing control logic and its .NET twin counterpart aimed at the visualization part. This package currently covers the IndraDrive and ctrlX DRIVE families.

### Components

| Component | Description |
|-----------|-------------|
| `AxoCtrlxDriveXsc` | Rexroth ctrlX DRIVE XSC servo drive. Extends `AxoDrive` with ctrlX-specific axis reference (`AxisRefExt`) and scaling constants. |
| `AxoIndraDrive` | Rexroth IndraDrive servo drive. Extends `AxoDrive` with IndraDrive fieldbus/parameter axis reference (`AxisRef`). |

Both components derive from `AXOpen.Components.Drives.AxoDrive` and follow the PLCopen-style motion state machine (`eAxoDriveState`).

### Dependencies

| Package | Purpose |
|---------|---------|
| `@inxton/axopen.components.drives` | Provides the `AxoDrive` base component and the shared `eAxoDriveState` motion state machine. |
| `@ax/simatic-1500-distributedio` | SIMATIC S7-1500 distributed I/O support for PROFINET device communication. |

### Links to documentation
[Siemens AX-documentation](https://developer.siemens.com/simatic-ax/developer.html) 

[AxOpen-documentation](https://inxton.github.io/AXOpen/)

[Bosch Rexroth documentation](https://www.boschrexroth.com/en/dc/)
