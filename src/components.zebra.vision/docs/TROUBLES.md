# Troubleshooting

## Common issues

### Scanner does not respond to `Read()`

**Symptom:** `Read()` task stays `Busy` and eventually times out per `Config.TaskTimeout`.

**Cause:** PROFINET communication or scanner-side state. The component requires the scanner to be online and in a state ready to accept read commands.

**What to check:**
- The scanner is reachable on the network — TIA/PROFINET diagnostics should show the device green.
- `Config.HWIDs` are populated correctly — usually auto-filled by the I/O system from the GSDML mapping.
- `AxoEA3600.Run()` is being called cyclically from the application's `AxoContext` call tree (it does not have to be in `Main()` directly, but the parent chain must reach it).
- The scanner is not in an error condition — call `ClearError()` and retry.

### Read returns truncated payload (>64 bytes)

**Symptom:** Long barcodes are cut off at the 64-byte boundary.

**Cause:** Fragment reassembly is disabled.

**What to check:**
- Set `Config.FragmentEnable := TRUE` (default).
- Confirm the scanner firmware advertises fragmented payload support.

### `ClearError()` does not clear the error state

**Symptom:** Status remains in error after `ClearError()` task completes.

**Cause:** The underlying fault is still active (hardware fault, configuration mismatch, or persistent communication loss). `ClearError()` only acknowledges the current latched error — it does not fix the root cause.

**What to check:**
- Look at the scanner's status indicators and TIA diagnostic events for the underlying fault.
- After resolving the root cause, call `ClearError()` again.
- If the error persists, restart the scanner and verify the PROFINET configuration matches the device profile.

### ACK handshake errors / spurious retries

**Symptom:** Task duration is unexpectedly long; messenger reports protocol-level info messages repeatedly.

**Cause:** Handshake bit toggling between PLC and scanner is out of sync.

**What to check:**
- Set `Config.HandshakeEnable := TRUE` (default) — disabling it bypasses the protocol's ACK mechanism and is only intended for debugging.
- Verify cycle time is stable; large jitter can starve the handshake state machine.

### Continuous reading mode does not produce data

**Symptom:** With `Config.ContinuousReading := TRUE` and the scanner aimed at a barcode, no data appears in `ReadData`.

**Cause:** Continuous mode requires the scanner firmware to be configured for continuous output. The PLC-side flag only enables consumption of the continuous stream — it does not configure the scanner.

**What to check:**
- Configure the scanner's trigger/scan mode using Zebra's tooling (123Scan, web UI, or the device's configuration barcodes).
- Verify the scanner firmware version supports continuous PROFINET output.

## Diagnostics

The component exposes status through:
- `AxoEA3600.Status` — `AxoEA3600_Component_Status` with action and error IDs.
- `AxoEA3600.ReadData` — last successful read payload and barcode type.
- `Messenger` — internal diagnostic message stream (info/warning/error).

For PROFINET-level diagnostics use the `axopen.io` `AxoHwDiag` infrastructure
or TIA online diagnostics.

## Known limitations

- Maximum payload size is bounded by the configured PROFINET module
  (typical: 64 bytes per frame; up to ~256 bytes when fragments are
  reassembled).
- The `TemplateMethod_*` slots are device-profile-dependent placeholders;
  their semantics depend on the specific scanner firmware/profile loaded
  via the GSDML.

## Support

Report issues at [GitHub Issues](https://github.com/Inxton/AXOpen/issues).
