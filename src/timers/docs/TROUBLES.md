# Troubleshooting

## Common Issues

### Timer does not start or stays at zero

**Symptom:** The timer's elapsed time remains at zero or the timer output never activates.

**Cause:** The timer must be called cyclically with an active input signal. A single call will not start the timer.

**Resolution:**
- Verify the timer is called every PLC cycle within the `AxoContext.Main()` call tree
- Check that the `IN` (enable) input is `TRUE` for the intended duration
- Verify that `PT` (preset time) is set to a non-zero value

### OnDelayTimer output activates immediately

**Symptom:** The `Q` output goes `TRUE` without waiting for the preset time.

**Cause:** The preset time (`PT`) may be set to zero or negative.

**Resolution:**
- Verify `PT` is set to a positive `TIME` value (e.g., `T#2S`)

### PulseTimer output does not deactivate

**Symptom:** The pulse output remains `TRUE` indefinitely.

**Cause:** The timer must continue to be called cyclically even after the input goes `FALSE`.

**Resolution:**
- Ensure the timer method is called every cycle regardless of the input state

## Support

Report issues at [GitHub Issues](https://github.com/ix-ax/axopen/issues).
