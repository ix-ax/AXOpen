# Troubleshooting

## Common issues

### A positioning move reports complete while the axis is not at the commanded target

**What you observe** — After a torque-control phase, a subsequent absolute positioning move advances as "in position", but `ActualPosition` differs noticeably from the commanded `Position` (the axis appears to have "lost" its position).

**Why it happens** — The Festo CMMT-AS drive can assert the `Telegram111_In.ZSW1.targetPosReached` (bit X10) status signal while the mechanical position is still outside an acceptable band — for example when the preceding torque-control phase disturbed the axis. Acting on that bit alone lets the move sequence advance prematurely.

**What to check** — `AxoCmmtAs` gates the target-reached transition on both the `targetPosReached` bit *and* `ABS(Position - ActualPosition) <= _AxisReference^.Config.InPositionWindow`. Tune `InPositionWindow` (see [Diagnostics](#diagnostics)):
- Too **small** → the move never satisfies the window and the sequence stalls just before completing.
- Too **large** → the move completes while the axis is still off target (the original symptom).

### Programming error `1542` raised during torque control

**What you observe** — Message `1542` (`eAxoMessageCategory#ProgrammingError`) is activated and `MC_TorqueControlErrorID` is set to `1542` while the axis is in a torque-control state.

**Why it happens** — A guard previously flagged `targetPosReached` becoming true during torque-control states (`126`/`127`) as a programming error. That guard proved unreliable and is disabled in this release.

**What to check** — If you still hit `1542` during torque control, you are running an older build; update to a build that includes this fix. The guard is intentionally removed pending further investigation, so it should no longer fire.

## Diagnostics

Read the drive's status from the cyclic PROFIdrive telegram 111 input word `Telegram111_In.ZSW1`. As of this release each signal carries its hardware bit position in the attribute label:

| Signal (`ZSW1.…`) | Bit | Meaning |
|---|---|---|
| `targetPosReached` | X10 | Drive reports the commanded target position has been reached |
| `operationEnabled` | X2 | Power stage enabled, drive following commands |
| `readyForSwitchOn` | X0 | Drive ready to be switched on |
| `ready` | X1 | Drive ready |
| `faultPresent` | X3 | A drive fault is active |
| `warningActive` | X7 | A drive warning is active |
| `switchingOnInhibitedActive` | X6 | Switch-on inhibit active |
| `noQuickStopActive` | X5 | Quick-stop *not* active (TRUE = normal operation) |
| `noCoastingActive` | X4 | Coast-stop *not* active (TRUE = normal operation) |
| `followingErrorInTolerance` | X8 | Following error within tolerance |
| `driveStopped` | X13 | Drive is stopped |

For positioning precision, the relevant tuning parameter lives in the drive's `AxoDrive_Config` (from the `components.drives` base library):

| Parameter | Type | Default | Purpose |
|---|---|---|---|
| `InPositionWindow` | `LREAL` | `0.05` | Maximum allowed `ABS(Position - ActualPosition)` (in axis position units) for a positioning move to count as complete, in addition to the drive's `targetPosReached` bit. |

## Known limitations

- The dynamic torque-boost parameter write (PNU `13073`, "Selection of dynamic torque boost") is not implemented — the code path is present but disabled.
- The torque-control "target reached during torque control" safety guard (programming error `1542`) is currently disabled and under investigation.

## Support

Unfortunately, we don't have a direct solution to your problem at the moment. If you encounter any issues, please [file a report on our GitHub](https://github.com/inxton/AXOpen/issues/new/choose). We appreciate your feedback and patience.

---
