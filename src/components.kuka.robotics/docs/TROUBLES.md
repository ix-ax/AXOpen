# Troubleshooting

This page catalogues the error states surfaced by `AxoKrc4` and `AxoKrc5`
(both in `AXOpen.Components.Kuka.Robotics.v_5_x_x`), each tied back to its
raising site in the PLC source. The two classes share an identical error
catalogue and bring-up logic, so every entry below applies to both. Error
identifiers are published through `Status.Error.Id` and the component's
`Messenger` / `TaskMessenger`, so the ID seen in a log or on the HMI always
maps to one of the entries below.

## Common issues

### The component never completes its first-cycle hardware check

**Symptom.** `_initHwCheckDone` never goes `TRUE`; `Status.Error.Id` sits at
one of 700, 701, 702, 710, 720–726, or 1130–1133; no `Inputs` are populated
from the field.

**Why.** `Run()` stays inside its one-shot bring-up block until every slot
probe succeeds. If any probe fails, it activates the matching message and
`RETURN`s, so the cyclic I/O read at the bottom of `Run()` never executes.

**What to check.**

- `inParent` was passed to `Run()` (missing parent → error 700 / 1130).
- A non-zero hardware identifier was passed (`hwID = 0` → error 701 / 1131).
  Prefer `AXOpen.Showcase.HwIdentifiers#{device}_HwID` constants.
- Slot 1 in the PROFINET template is empty (no safety module added by the
  application). A non-zero ID here raises error 710 / 1132.
- Slot 2 is the `512_DI_DO` submodule from the shipped template and is
  reachable on the PROFINET subnet (errors 720–725, 1133).
- The KRC4 template at
  `showcase/app/hwc/library_templates/kuka_krc4/kuka_krc4_dio512.hwl.yml`
  is the one applied in `plc_line.hwl.yml` (`- Apply: kuka_krc4_dio512`).
  A different template likely breaks the 64-in / 64-out I/O size assertion
  (error 726).

### `Run()` runs but tasks never start

**Symptom.** Calls like `ExampleRobot.StartMotorsAndProgram()` stay in a
`IsBusy()` state; `Status.Error.Id` reports 500-range *potential* IDs.

**Why.** Every task advances its state machine inside
`AxoKrc4.Run()` / `AxoKrc5.Run()`. The 500-range IDs are informational —
they report which controller input the task is waiting on (e.g.
`UserSafetySwitchClosed`, `DrivesReady`, `Automatic`, `AlarmStopActive`).
They are not errors.

**What to check.**

- The KRC4 is in external-automatic mode (`Inputs.ExternalAutomatic = TRUE`)
  and not in `Inputs.Manual`. Any active task immediately raises error
  20001 in manual mode.
- `Inputs.UserSafetySwitchClosed`, `Inputs.AlarmStopActive`, and
  `Inputs.DrivesReady` track the KRC4 safety circuit. Tasks block on
  these; if they never assert, inspect the E-stop chain on the robot cell.
- `Inputs.Error = TRUE` raises error 20005 while a task is busy; clear
  the KRC4-side fault, then call `ExampleRobot.ErrorConfirmation` via
  `Outputs.ErrorConfirmation` or run the `Restore` sequencer step.
- `Config.TaskTimeout` has not elapsed (default `LT#50S`). Set to `0s`
  during commissioning to disable the watchdog.

### Movement parameters never take effect

**Symptom.** `StartMovements(params)` stays busy; `Status.Error.Id`
cycles through 554–559 (or 528–533 for the combined task).

**Why.** The task writes movement parameters to `Outputs` and then waits
for the KRC4 to mirror each parameter back on `Inputs` before advancing.
If the mirror never happens the task is stuck at `_movement_progress = 354`.

**What to check.**

- The KRC4 programme on the controller side is running and processing the
  AXOpen interface (the `I_O_ACT` output must be accepted; `I_O_ACTCONF`
  should come back on `Inputs.InterfaceActivated`).
- The `ActionNo` written by the PLC (`Outputs.ActionNo`) matches the value
  echoed back on `Inputs.ActionNo`. The component handshakes action numbers
  `253`, `254`, `255` during the movement step machine; a mismatch means
  the KRC4 programme is not advancing.
- `AXOpen.Components.Robotics.CoordinatesAreNearlyEqual` returns `TRUE` for
  the commanded vs. echoed coordinates within `0.01` tolerance. Values
  outside that tolerance keep the task in the acknowledge state.

### PROFINET read / write transport failures

**Symptom.** `Status.Error.Id` reports 1201 or 1231 and the component
`RETURN`s early each cycle, freezing all tasks.

**Why.**

- 1201 — `Siemens.Simatic.DistributedIO.ReadData` returned a non-zero
  status. The 64-byte input block could not be fetched from slot 2.
- 1231 — `Siemens.Simatic.DistributedIO.WriteData` returned a non-zero
  status. The 64-byte output block could not be pushed to slot 2.

**What to check.**

- The PROFINET device is online (link up, device name applied, IP reachable).
  These are transport failures, not configuration faults.
- No other controller owns the same PROFINET device name
  (`PROFINET_DEVICE_NAME_X1: kuka_rb1` in the shipped template).
- Slot 2 still contains the `512_DI_DO` submodule — replacing or removing
  it after commissioning invalidates `HwID_512_DI_DO`.

### Safety-interlock errors while a task is busy

`AxoKrc4` / `AxoKrc5` arm a safety gate around every programme/motion task. While
`StartAtMainTask`, `StartMotorsAndProgramTask`, `StartMovementsTask`,
`StopMovementsTask`, `StopMovementsAndProgramTask`, or `StopProgramTask`
is busy, the component raises one of 20001–20005 as soon as the
corresponding input asserts/deasserts:

| Id | Condition | Meaning |
|----|-----------|---------|
| 20001 | `Inputs.Manual = TRUE` | KRC4 went to T1 while a task is executing — automation path invalid. |
| 20002 | `Inputs.Automatic = FALSE` | KRC4 dropped out of auto — task is now illegal. |
| 20003 | `Inputs.AlarmStopActive = FALSE` | Alarm-stop dropped, likely external E-stop. |
| 20004 | `Inputs.UserSafetySwitchClosed = FALSE` | User safety gate opened during motion. |
| 20005 | `Inputs.Error = TRUE` | KRC4 itself raised an error while the task was running. |

Resolution: bring the cell back into the safe automatic state, call the
task's `Restore()` method so its state machine rewinds, then re-invoke the
task.

## Error ID reference

### Hardware bring-up errors (first cycle)

| Id | Category | Raised when |
|----|----------|-------------|
| 700 | ProgrammingError | `Run()` called with `inParent = NULL`. |
| 701 | ProgrammingError | `Run()` called with `hwID = 0`. |
| 702 | Error | `ReadSlotFromHardwareID` returned `WORD#8090` — unknown hardware ID. |
| 710 | Error | Slot 1 (reserved for a safety module) reports a non-zero hardware ID — unexpected module occupies slot 1. |
| 720 | Error | Slot 2 hardware ID is `0` — `512_DI_DO` submodule missing. |
| 721 | Error | Slot 2 probe returned `WORD#8091`. |
| 722 | Error | Slot 2 probe returned `WORD#8094`. |
| 723 | Error | Slot 2 probe returned `WORD#8095`. |
| 724 | Error | Slot 2 probe returned `WORD#8096`. |
| 725 | Error | Slot 2 probe returned `WORD#8097`. |
| 726 | Error | Slot 2 I/O address range is not 64 in / 64 out. Wrong module template applied. |
| 1130 | Error | Post-probe re-check — `inParent = NULL`. |
| 1131 | Error | Post-probe re-check — `HwID_Device = 0`. |
| 1132 | Error | Post-probe re-check — `HwID_None <> 0`. |
| 1133 | Error | Post-probe re-check — `HwID_512_DI_DO = 0`. |

### Cyclic I/O errors

| Id | Category | Raised when |
|----|----------|-------------|
| 1201 | Error | `DistributedIO.ReadData` returned non-zero status — PROFINET read failed. |
| 1231 | Error | `DistributedIO.WriteData` returned non-zero status — PROFINET write failed. |

### Runtime safety errors (during a busy task)

| Id | Category | Raised when |
|----|----------|-------------|
| 20001 | Error | `Inputs.Manual = TRUE`. |
| 20002 | Error | `Inputs.Automatic = FALSE`. |
| 20003 | Error | `Inputs.AlarmStopActive = FALSE`. |
| 20004 | Error | `Inputs.UserSafetySwitchClosed = FALSE`. |
| 20005 | Error | `Inputs.Error = TRUE`. |

### Task "potential" (waiting-on-input) identifiers

The 500-range identifiers are informational — the component uses them to
show which KRC4 input the currently-executing task is waiting on. They
are surfaced via `TaskMessenger` (category `Potential`) only after
`Config.InfoTime` has elapsed, so a brief wait never raises them. Typical
ranges:

| Range | Task | What the task is waiting for |
|-------|------|------------------------------|
| 500 | `StartAtMain` | `StartAtMain` input acknowledgement. |
| 510–516 | `StartAtMain` handshake progression | Interface activate, drives ready, programme start confirmation. |
| 520–536 | `StartMotorsProgramAndMovements` | Combined motor/programme/movement bring-up. |
| 540–542 | `StartMotors` | `UserSafetySwitchClosed`, `AlarmStopActive`, `DrivesReady`. |
| 550–562 | `StartMovements` | `ProActive`, `DrivesReady`, `StopMess` clear, parameter acknowledge. |
| 570–576 | `StopMovements` / `StartMotorsAndProgram` | Drive-off handshake, mirrored parameters. |
| 580 | `StartProgram` | Programme start acknowledgement. |
| 590, 591 | `StopProgram`, `StopMovementsAndProgram` | Programme stop acknowledgement. |
| 600, 610, 620 | `StopMovements`, `StopMotors`, `ResetAllOutputs` | Final shutdown handshakes. |

A *potential* entry is not a fault — inspect the KRC4 inputs named in the
task's current step comment. A task only converts to an error (`10020`,
`10040`, `10041`, …) after `Config.ErrorTime` elapses without the
expected input.

## Diagnostics

Read these properties when triaging:

- `Status.Error.Id` — last raised error (most recent `Messenger.Activate`
  call wins).
- `Status.Action.Id` — current macro state of the task layer
  (120s / 140s / 150s / 160s ranges mirror `_power_progress` and
  `_movement_progress`).
- `_power_progress`, `_movement_progress` — internal step indices. Exposed
  read-only on the component so the HMI shows where a task is paused.
- `HardwareDiagnosticsTask` — the embedded `AxoHardwareDiagnostics` task
  returns detailed PROFINET slot health; run it whenever transport errors
  (1201 / 1231) appear.
- `Messenger` and `TaskMessenger` — the component's two messenger
  channels. The first carries errors/programming faults; the second
  carries task-level *potential* / info messages.

## Known limitations

- Only the `kuka_krc4_dio512` / `kuka_krc5_dio512` slot layout (64-byte I/O)
  is recognised. Swapping slot 2 for a different submodule invalidates
  `HwID_512_DI_DO` and raises error 720/726.
- Slot 1 must be left empty. Adding a safety module there is currently
  unsupported — error 710 is raised pre-emptively (the commented-out error
  IDs 711–716 in the source show this branch was intentionally disabled).
- A single `hwID` device is supported per `AxoKrc4` / `AxoKrc5` instance;
  multi-arm coordination happens at the application level, not inside the
  component.

## Support

Unfortunately, we don't have a direct solution to every problem. If you
encounter an issue not covered here, please
[file a report on our GitHub](https://github.com/inxton/AXOpen/issues/new/choose).
We appreciate your feedback and patience.

---
