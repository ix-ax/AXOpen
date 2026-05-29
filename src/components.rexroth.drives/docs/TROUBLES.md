# Troubleshooting

This guide covers the most common issues encountered when integrating the
`AxoCtrlxDriveXsc` and `AxoIndraDrive` components, the drive state machine,
and the diagnostics surface exposed by both components.

---

## Common Issues

### The drive values never update / the view stays blank

**What you observe**: `DriveState`, `ActualPosition`, `ActualVelocity` and
`ActualTorque` never change, motion tasks never complete.

**Why it happens**: the component advances its internal logic and its task
state machines only while its `Run(...)` method is being called cyclically.
If `Run(...)` stops being called, every value and task freezes in place.

**What to check**: ensure the component's `Run(...)` method is called on every
cycle from within the call tree of your `AxoContext.Main()` method. It does
**not** have to be called directly in `Main()` — calling it from any object,
station, or method reachable through the `Main()` call chain is sufficient, as
long as the call executes on every scan.

### A motion task only works once, then does nothing

**What you observe**: the first invocation of a motion/parameter task succeeds,
but invoking it again has no effect or immediately reports the previous result.

**Why it happens**: tasks (`AxoTask`) latch their result. A completed task must
be restored before it can run again.

**What to check**: call `Restore()` on the task (the Blazor task views expose a
Restore button for this) before re-invoking it, and keep calling `Run(...)`
while the task executes. Only one motion task is serviced at a time — do not
expect two motion commands to run concurrently.

### The drive will not leave `Disabled` / will not enable

**What you observe**: `DriveState` stays at `Disabled` and motion commands are
ignored.

**Why it happens**: the drive must be powered/enabled before it transitions to
`Standstill` and accepts motion. A pending error also blocks enabling.

**What to check**: use the Power/enable task in the Operate panel, confirm the
drive is not in `Errorstop` (see Error States below), and verify the I/O
mapping so the component actually exchanges process data with the physical
drive.

### Manual control panel is missing in the UI

**What you observe**: the Blazor view shows the read-only Monitor/STATE panel
instead of the interactive Operate/CONFIGURATION panel.

**Why it happens**: the container view branches on
`_isManuallyControllable.Cyclic`. When it is `false`, only the monitor and
state views are shown.

**What to check**: activate manual control on the component so
`_isManuallyControllable` becomes `true`; the Operate commands and
CONFIGURATION panel then render.

---

## Hardware vs. Configuration vs. Application

Both `AxoCtrlxDriveXsc` and `AxoIndraDrive` control physical PROFINET devices.
When data exchange fails, isolate the layer before changing code:

- **Communication issues** — device unreachable, link down, watchdog timeout.
  Check the physical connection, the device IP address, and the PROFINET device
  name. The drive will not reach `Standstill` if process data is not exchanged.
- **Configuration issues** — GSDML/template mismatch, wrong slot or module
  assignment, parameter error. Check the device entry in
  `showcase/app/hwc/plc_line.hwl.yml` and the device template under
  `ctrl/assets/` (`rexroth_ctrlx_drive` / `rexroth_indradrive`).
- **Application issues** — wrong `hwID`, missing or swapped I/O references,
  incorrect `Run(...)` arguments. Check the ST wiring that passes the hardware
  identifier and the axis reference (`AxisRefExt` for ctrlX,
  `AxisRef` for IndraDrive) into the component.

---

## Error States

Both components expose their motion state through `DriveState`, typed as
`eAxoDriveState` (defined in `AXOpen.Components.Drives`). The states follow the
PLCopen motion state model:

| State | Meaning |
|-------|---------|
| `Disabled` | Drive is not powered/enabled. No motion is possible. |
| `Standstill` | Drive is enabled and holding position, ready to accept a motion command. |
| `Homing` | A homing/reference task is in progress. |
| `Stopping` | A stop has been commanded; the drive is decelerating to standstill. |
| `DiscreteMotion` | A point-to-point move (absolute/relative/additive) is active. |
| `ContinuousMotion` | A velocity move is active. |
| `SynchronizedMotion` | A synchronized/coordinated move is active. |
| `Errorstop` | The drive has faulted and stopped. **This is the error state.** |

### Recovering from `Errorstop`

**Possible causes**: drive-side fault (over-current, following error, limit
switch, communication loss), an invalid motion target, or a hardware/safety
condition reported by the physical drive.

**Resolution**:
1. Read `DriveState` to confirm `Errorstop`, and inspect the component's alarm
   messenger (`_Messenger`, surfaced as the alarm badge/panel in the Blazor
   view) for the specific fault text.
2. Clear the originating condition (acknowledge the drive fault, remove the
   limit/safety condition, correct an out-of-range target).
3. Invoke the reset task to clear the error, then re-enable the drive. On
   success the drive returns to `Standstill`.
4. If the drive immediately re-enters `Errorstop`, the underlying hardware fault
   is still present — diagnose at the physical drive before retrying.

---

## Diagnostics

Read these members to understand the component's runtime state (all are exposed
read-only in the STATE / Monitor panel of the Blazor view):

| Member | Meaning |
|--------|---------|
| `DriveState` | Current `eAxoDriveState` motion state (see table above). |
| `ActualPosition` | Live position feedback. |
| `ActualVelocity` | Live velocity feedback. |
| `ActualTorque` | Live torque feedback. |
| `DriveStatus` | Aggregated status readout of the drive. |
| `DriveConfig` | Active configuration parameters (writable in the CONFIGURATION panel). |
| `_Messenger` | Alarm/message source; populated faults appear in the header alarm badge. |

For `AxoCtrlxDriveXsc`, additionally inspect the `AxisRefExt`
(Inputs/Outputs/Status) and the scaling constants. For `AxoIndraDrive`, inspect
`AxisRef` (FieldBus_In/FieldBus_Out, Parameter_In/Parameter_Out, Status, Data).

---

## Known Limitations

- A component services a single active motion task at a time; motion commands
  are not executed concurrently.
- The component reflects the capabilities reported by the physical drive over
  PROFINET — features not supported by the connected drive firmware cannot be
  exercised from the component.

---

## Support

If you encounter an issue not covered here, please
[file a report on our GitHub](https://github.com/inxton/AXOpen/issues/new/choose).
We appreciate your feedback and patience.

---
