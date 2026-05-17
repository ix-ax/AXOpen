# Troubleshooting

## Common Issues

### Object does not execute or remains in initial state

The object's `Run()` or `Execute()` method must be called **cyclically** — once
per PLC scan — from within the call tree of your `AxoContext.Main()` method. It
does not need to be called directly in `Main()`; it can be called from any depth
in the object hierarchy (e.g., inside another `AxoObject.Run()`, from a station
object, from a sequencer step), as long as the call originates from the context's
open cycle.

**Check the following:**
- The object instance is declared as a VAR of an `AxoObject` or `AxoContext`
  that itself participates in the call tree
- The parent object's `Run(inParent)` is called before or around this object's
  execution — this establishes the context chain
- The call is not guarded by a condition that prevents it from executing every
  cycle

### Object reports context-related errors

Each `AxoObject` must be able to resolve its `AxoContext` through the parent
chain. If the context is `NULL`:
- Verify that `Run(inParent)` is called with a valid parent reference (`THIS`
  from the enclosing object, not a literal `NULL` or uninitialized reference)
- Verify the top-level context calls `Main()` inside its cyclic program

### AxoTask remains in Busy state indefinitely

- The owning object's `Run()` must continue to be called cyclically while a
  task is executing — tasks advance their state machine inside `Run()`
- Call `Restore()` on the task between successive invocations to reset its
  state machine before issuing a new command
- Verify `DoneWhen(condition)` is eventually called with `TRUE` — if the
  completion condition is never met, the task stays Busy forever

### AxoTask stays in Done/Error and won't re-invoke

After completing (`Done`) or failing (`Error`), the task must be explicitly
restored before it can be invoked again:
- Call `Restore()` to return to `Ready` state, then call `Invoke()` again
- Alternatively, stop calling `Invoke()` for two consecutive context cycles —
  the task auto-transitions from `Done` to `Ready`
- From `Error` state, only `Restore()` works — there is no auto-transition

### AxoRemoteTask enters error state "REMOTE TASK IS NOT INITIALIZED"

Every `AxoRemoteTask` instance that gets `Invoke()`d from the PLC must have a
corresponding `.Initialize(handler)` call in the .NET application's `Program.cs`.
Without this, the `IsInitialized` flag remains `FALSE` and the task transitions
to `Error`.

**Check the following:**
- `Program.cs` contains a call like:
  `Entry.Plc.Ctx.{path}._remoteTask.Initialize(() => { ... });`
- The .NET application is running and connected to the PLC
- The `Initialize()` call occurs before `app.Run()` in `Program.cs`

### AxoDialog does not appear on the HMI

AxoDialog uses SignalR for cross-client synchronization. If dialogs don't
appear:
- Verify `builder.Services.AddAxoCoreServices()` is called in `Program.cs`
- Verify `app.MapHub<SignalRDialogHub>(SignalRDialogHub.HUB_URL_SUFFIX)` is
  called after `app.MapBlazorHub()` in `Program.cs`
- Verify the Blazor page includes an `<AxoDialogLocator>` component with the
  correct `ObservedObjects` list
- Verify the dialog's `Show()` or `ShowWithExternalClose()` method is called
  cyclically from within the PLC context

### AxoAlert toast notifications not showing

- Verify `<AxoAlertToast/>` is present in `MainLayout.razor`
- Verify `<AxoAlertDialogLocator>` is placed in `MainLayout.razor` (for
  app-wide alerts) or in the specific Razor page
- Only one instance of `AxoAlertDialogLocator` should exist per scope

### AxoLogger messages not appearing in .NET console

AxoLogger requires .NET-side dequeuing to forward PLC log entries:
- Verify `StartDequeuing(logger, interval)` is called in `Program.cs`:
  `Entry.Plc.Ctx.{path}.Logger.StartDequeuing(new SerilogLogger(...), 250);`
- Verify `ConstructIdentitiesAsync()` is awaited before logging starts —
  without identity resolution, sender information is incomplete
- Check that the PLC-side `SetMinimumLevel()` is not filtering out the
  messages you expect to see
- Remember the 100-entry queue limit — high-frequency logging can cause
  entries to be dropped before dequeuing

### AxoSequencer steps execute out of order or skip

- Steps must be declared as unique instances — never reuse the same `AxoStep`
  variable for multiple steps in a sequence
- Do not nest step `Execute()` calls inside other steps or control structures
- Step order is fixed during the `Configuring` state (first cycle after
  `Open()` or `Run()`) — do not dynamically reorder steps while `Running`
- Verify each step eventually calls `MoveNext()`, `RequestStep()`, or
  `CompleteSequence()` — a step without a transition blocks the sequence

### AxoMessenger does not display messages

- `Serve(rootObject)` must be called **before** `Activate()` or
  `ActivateOnCondition()` in the same cycle — reversed order causes messages
  to be silently dropped
- Verify the `PlcTextList` attribute is defined on the messenger's declaration
  with the correct `[code]:'<#text#>':'<#help#>'` format
- Verify the message code passed to `Activate()` matches an entry in the
  text list

### Unexpected behavior after dependency update

- Verify that all `apax.yml` dependency versions are aligned — mismatched
  versions between foundation libraries can cause interface incompatibilities
- Run `apax clean && apax install && apax build` to ensure a clean rebuild

---

## Error States

### eAxoTaskState

| Value | Name      | Description                                                                                                                                                 |
|-------|-----------|-------------------------------------------------------------------------------------------------------------------------------------------------------------|
| 1     | `Ready`   | Task is idle and can be invoked. Initial state after creation or `Restore()`.                                                                               |
| 2     | `Kicking` | Transitional state after `Invoke()` — the task is preparing to execute. Transitions to `Busy` on the next `Execute()` call.                                 |
| 3     | `Busy`    | Task is actively executing. `Execute()` returns `TRUE` in this state. Exits via `DoneWhen(TRUE)`, `ThrowWhen(TRUE)`, or `Abort()`.                          |
| 4     | `Done`    | Task completed successfully. `IsDone()` returns `TRUE`. Auto-transitions to `Ready` if `Invoke()` is not called for 2+ cycles.                              |
| 5     | `Aborted` | Task was interrupted by `Abort()`. `IsAborted()` returns `TRUE`. Call `Resume()` to return to `Busy`, or `Restore()` to reset.                              |
| 10    | `Error`   | Task terminated with a failure via `ThrowWhen(TRUE)`. `HasError()` returns `TRUE`. Only `Restore()` exits this state. Check `ErrorDetails` for the message. |

### eDialogAnswer

| Value | Name       | Description                                |
|-------|------------|--------------------------------------------|
| 0     | `NoAnswer` | Dialog is still waiting for user response. |
| 10    | `Ok`       | User clicked OK.                           |
| 20    | `Yes`      | User clicked Yes.                          |
| 30    | `No`       | User clicked No.                           |
| 40    | `Cancel`   | User clicked Cancel.                       |

### eDialogType

| Value | Name        | Description                                |
|-------|-------------|--------------------------------------------|
| 0     | `Undefined` | Default, no visual type applied.           |
| 10    | `Info`      | Informational dialog (blue styling).       |
| 20    | `Success`   | Success confirmation (green styling).      |
| 30    | `Danger`    | Critical/destructive action (red styling). |
| 40    | `Warning`   | Warning notification (yellow styling).     |

---

## Diagnostics

### Reading AxoTask state

| Property / Method | Type            | Meaning                                                           |
|-------------------|-----------------|-------------------------------------------------------------------|
| `Status`          | `eAxoTaskState` | Current task state (Ready, Kicking, Busy, Done, Aborted, Error)   |
| `IsDone()`        | `BOOL`          | Returns `TRUE` when task completed successfully                   |
| `IsBusy()`        | `BOOL`          | Returns `TRUE` when task is executing                             |
| `HasError()`      | `BOOL`          | Returns `TRUE` when task is in Error state                        |
| `IsAborted()`     | `BOOL`          | Returns `TRUE` when task was aborted                              |
| `ErrorDetails`    | `STRING`        | Error message text (populated by `ThrowWhen` or remote exception) |

### Reading AxoRemoteTask state

In addition to all AxoTask diagnostics:

| Property               | Type   | Meaning                                                  |
|------------------------|--------|----------------------------------------------------------|
| `IsInitialized`        | `BOOL` | `TRUE` when .NET handler is connected via `Initialize()` |
| `HasRemoteException`   | `BOOL` | `TRUE` when the .NET handler threw an exception          |
| `IsBeingCalledCounter` | `INT`  | Increments each cycle `Execute()` is called while busy   |

### Reading AxoSequencer state

| Property / Method              | Type                   | Meaning                                     |
|--------------------------------|------------------------|---------------------------------------------|
| `GetCoordinatorState()`        | `AxoCoordinatorStates` | `Idle`, `Configuring`, or `Running`         |
| `GetNumberOfConfiguredSteps()` | `INT`                  | Total steps registered during configuration |
| `SequenceMode`                 | `eAxoSequenceMode`     | `RunOnce` or `Cyclic`                       |
| `SteppingMode`                 | `eAxoSteppingMode`     | `Continuous` or `StepByStep`                |

### Reading AxoLogger state

| Property                  | Type        | Meaning                                                 |
|---------------------------|-------------|---------------------------------------------------------|
| `Carret`                  | `INT`       | Current write position in the 100-entry circular buffer |
| `MinimumLevel`            | `eLogLevel` | Messages below this level are discarded on the PLC side |
| `LogEntries[n].ToDequeue` | `BOOL`      | `TRUE` if this entry hasn't been read by .NET yet       |

---

## Known Limitations

- **AxoLogger queue size**: Fixed at 100 entries. High-frequency logging can
  overflow the buffer before .NET dequeues entries. There is no configuration
  option to change this limit.
- **AxoDialog single-instance**: Only one dialog can be active per `AxoDialog`
  instance at a time. Calling `Show()` again while a dialog is pending replaces
  the previous dialog.
- **AxoRemoteTask non-deterministic**: Execution time of the .NET handler is
  not bounded — network latency, .NET garbage collection, and thread scheduling
  can introduce variable delays.
- **AxoSequencer step limit**: Step arrays must be pre-allocated. The maximum
  number of steps is determined by the array size at compile time.

---

## Support

If you encounter any issues not covered here, please [file a report on our GitHub](https://github.com/inxton/AXOpen/issues/new/choose). We appreciate your feedback and patience.
