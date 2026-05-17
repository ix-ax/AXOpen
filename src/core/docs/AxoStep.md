# AxoStep

`AxoStep` extends `AxoTask` and provides coordinated execution within an `AxoSequencer` or `AxoSequencerContainer`. Each step represents one discrete action in a sequence — it executes its body while active and transitions to the next step via the coordinator.

## Execute() method

The `Execute()` method has three parameters:

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `coord` | `IAxoCoordinator` | Yes | Sequencer controlling this step's execution order |
| `Enable` | `BOOL` | No (default `TRUE`) | When `FALSE`, step body is skipped and execution order advances |
| `Description` | `STRING` | No | Localizable description shown in HMI (use `'<#text#>'` format) |

`Execute()` returns `TRUE` while the step is active. All step logic must be placed inside the `IF step.Execute(...) THEN ... END_IF` block.

### Simple step (coordinator only)
[!code-smalltalk[](../../showcase/app/src/core/AXOpen.AxoSequencer/AxoSequencerDocuExample.st?name=SimpleStep)]

### Step with Enable condition
[!code-smalltalk[](../../showcase/app/src/core/AXOpen.AxoSequencer/AxoSequencerDocuExample.st?name=EnableStep)]

### Step with all parameters
[!code-smalltalk[](../../showcase/app/src/core/AXOpen.AxoSequencer/AxoSequencerDocuExample.st?name=FullStep)]

## Public Members

| Member | Type | Access | Description |
|--------|------|--------|-------------|
| `Order` | `INT` | `GetStepOrder()` / `SetStepOrder()` | Position in the sequence — assigned during the coordinator's `Configuring` state |
| `StepDescription` | `STRING` | Set via `Execute(Description)` | Text displayed in HMI for this step |
| `IsActive` | `BOOL` | `GetIsActive()` / `SetIsActive()` | `TRUE` while this step is the current executing step |
| `IsEnabled` | `BOOL` | `GetIsEnabled()` / `SetIsEnabled()` | `FALSE` causes the step to be skipped |

## First-entry detection

Use `IsFirstEntryToStep()` inside the step body to execute one-time initialization logic on the first cycle of each step activation:

```
IF(step.Execute(coord, TRUE, '<#Initialize sensor#>')) THEN
    IF step.IsFirstEntryToStep() THEN
        counter := ULINT#0;  // Reset only on first entry
    END_IF;
    counter := counter + ULINT#1;
    IF(counter >= ULINT#100) THEN
        coord.MoveNext();
    END_IF;
END_IF;
```

## Step transitions

From inside a step body, use the **coordinator** to transition:

| Method | Effect |
|--------|--------|
| `coord.MoveNext()` | Advance to the next step in declaration order |
| `coord.RequestStep(targetStep)` | Jump to a specific step (forward = same cycle, backward = next cycle) |
| `coord.CompleteSequence()` | End the sequence (restart if `Cyclic`, stay done if `RunOnce`) |

## Rules

- Each `AxoStep` instance must be **unique** within a sequence — never reuse the same variable for multiple steps
- Do not nest step `Execute()` calls inside other steps
- Every active step must eventually call a transition method — a step without `MoveNext()` or `CompleteSequence()` blocks the entire sequence
- Step order is fixed during `Configuring` state — do not dynamically reorder while `Running`
