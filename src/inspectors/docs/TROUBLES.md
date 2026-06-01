# Troubleshooting

## Common Issues

### Inspector does not execute inspection

**Symptom:** The inspector's `Inspect()` method is called but no inspection result is produced.

**Cause:** The inspector must be properly initialized with a parent context via `Run(inParent)` before calling inspection methods. The parent chain must be established within the `AxoContext.Main()` call tree.

**Resolution:**
- Verify that `Run(inParent)` is called cyclically before any inspection method
- Check that the parent object has a valid context

### Inspector always returns `Failed` result

**Symptom:** Every inspection result is `Failed` regardless of actual values.

**Cause:** The inspection data bounds may be misconfigured, or the inspection was not properly restored between cycles.

**Resolution:**
- Verify `RequiredMin` and `RequiredMax` values in the inspector data configuration
- Ensure `Restore()` is called between inspection cycles
- Check that the data source provides values within the expected range

### Comprehensive result does not aggregate correctly

**Symptom:** `AxoComprehensiveResult` shows incorrect overall status despite individual inspectors passing.

**Cause:** All inspectors must be added to the comprehensive result before evaluation.

**Resolution:**
- Verify all inspectors are registered with the comprehensive result
- Check that `Evaluate()` is called after all individual inspections complete

## Support

Report issues at [GitHub Issues](https://github.com/ix-ax/axopen/issues).
