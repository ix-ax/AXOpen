## Changes
<!--
    Leave this comment intact. Immediately below this comment add a new entry:
    ---------------------------------
    ### {axopen-version}

    **New features:**
    -

    **Bug fixes:**
    -

    **Other:**
    -

    **Breaking changes:**
    -
    ---------------------------------

    Replace {axopen-version} with the `next-version:` value from
    axopen/GitVersion.yml. New entries go at the TOP, immediately below
    this comment. The /axopen-docs skill resorts the file semver-descending
    on every run.
-->

### 0.62.3

**New features:**
- `AxoRemoteTask` (.NET twin) start/done handshake priority is now **configurable**. The batched `Connector.ReadBatchAsync` (Start+Done poll) and `Connector.WriteBatchAsync` (Done acknowledgement) each take their `eAccessPriority` from the new `HandshakeReadAccessPriority` / `HandshakeWriteAccessPriority` properties (default `eAccessPriority.Normal`). Seed them via the new optional `Initialize(handler, handshakeReadAccessPriority, handshakeWriteAccessPriority)` / `InitializeExclusively(...)` arguments, or set the properties directly any time. Raise to `eAccessPriority.High` to service the handshake ahead of lower-priority traffic.

**Other:**
- `AxoRemoteTask` (.NET twin) start/done handshake batches connector I/O: `ExecuteAsync` reads `StartSignature` + `DoneSignature` via a single `Connector.ReadBatchAsync` and writes the completion `DoneSignature` (set through `DoneSignature.Cyclic`) via `Connector.WriteBatchAsync`, replacing the previous per-signal `GetAsync`/`SetAsync` calls. This cuts connector round-trips on the remote-task start/done acknowledgement. No PLC-side API change — `Invoke()`, `Execute()`, `Abort()`, `Restore()`, and the `IsBusy`/`IsDone`/`HasError`/`IsAborted` semantics are unchanged.

**Breaking changes:**
- `AxoRemoteTask` handshake default priority is now `eAccessPriority.Normal` (previously hardcoded `eAccessPriority.High`). Existing callers that relied on the handshake being serviced at `High` should pass `eAccessPriority.High` to `Initialize(...)` or set `HandshakeReadAccessPriority` / `HandshakeWriteAccessPriority`. (In the built-in connectors `High` and `Normal` share the same batch chunking; the difference is queue/ordering priority relative to other connector traffic.)
- `AxoTaskView` (Blazor) disabled rendering: when `IsDisabled` is `TRUE` the activity indicator now keeps reflecting the task state (`Ready`/`Kicking`/`Busy` still render their ring/circle) instead of being replaced by the lock. The `lock-closed` icon moved to the trailing action-button area, hiding the `Reset task` / `Resume` buttons, while the control stays non-interactive. No `AxoTask` PLC-side API change.

### 0.56.2

**Bug fixes:**
- `AxoSequencer` step-timeout messenger: `_context` is now resolved on every `_msgStepTimedOut.Activate(...)` call rather than only on the first rising transition, and `ActiveContextCount` is refreshed each cycle the messenger remains active. Previously, once the step-timeout alarm was raised, the active-context counter never advanced, so the parent `AggregateMessage(1)` accumulation could leave the alarm stuck active and prevent it from falling on the next sequencer cycle.

### 0.56.1

**Bug fixes:**
- `AxoCauseAnalyzer`: severity-tier sort is now the outermost key — a higher-severity candidate (e.g. `Critical`) is never ranked below a lower one (e.g. `Error`) regardless of burst/ownership/age bonuses. Score remains the within-tier tie-breaker.
- `AxoCauseAnalyzer`: age contribution is capped at 7 days. An uninitialized `RisenUtc` (`DateTime.MinValue`) previously injected ~10⁹ minutes and dominated the score.
- `AxoCauseAnalyzer`: `BurstWindow` cutoff is clamped to `DateTime.MinValue` when the maximum `RisenUtc` is smaller than the window — prevents `DateTime` underflow before `ReadDetails` has populated `Risen`.
- `AxoCauseAnalyzer`: candidates with empty `DisplayMessage` (e.g. `MessageCode == 0`) are excluded from ranking — nothing meaningful to surface to the operator.
- `AxoIncidentBarView`: polling cadence now driven by `_analyzer.ActiveCount` instead of `Provider.ActiveMessagesCount`. The provider's count depends on `MsgCnt` aggregation reaching the observed root, which is not guaranteed in every project; the analyzer's count is authoritative.
- `AxoIncidentBarView.Tick()` now always reads message state first, then pulls details when any messenger reports a non-Idle state — previously the bar could skip detail reads entirely when the provider's aggregated active count was zero while individual messengers were active.

**Other:**
- `AxoCauseAnalyzer.SenderDisplayName` now produces a top-down `AttributeName` breadcrumb (e.g. `Station › Drive › Encoder`) walking from the messenger's owning component up to but excluding the unnamed root, with a fallback to `GetSymbolTail` when no chain is available.
- `AxoIncidentBarView` renders the full PLC symbol path as a mono `text-xs` subtitle and as the `title` tooltip on the sender label, both on the top bar and in expanded rows — enabling operators to identify the originating instance unambiguously when multiple components share the same display name.
- `AxoMessageProvider.ReadMessageStateAsync` now batches `Risen`, `Fallen`, and `Acknowledged` alongside the state/category/code triple — fewer separate detail reads needed for burst-window decisions.
- `AxoMessageProvider.ReadDetails` issues its batch read at `eAccessPriority.Low` to reduce contention with operator-driven traffic.
- Added Serilog diagnostics to `AxoIncidentBarView.ConfigurePolling` and `Tick` (`Information`, `Debug`, `Warning`, `Error`) so polling lifecycle and per-tick state are visible without attaching a debugger.
- `IRankableMessage` exposes a new `SenderSymbol` member (full PLC symbol path). `AxoMessengerRankableAdapter` accepts an optional `senderSymbol` projector and falls back to the messenger symbol when none is supplied — existing call sites compile unchanged.

### 0.56.0

**New features:**
- Added `AxoCauseAnalyzer` (`AXOpen.Messaging.Static`) — heuristic probable-cause ranking layered on `AxoMessageProvider`. Scores active Error+ messengers by severity, burst-root (earliest within sliding `BurstWindow`), twin-tree topology (container-Symbol-prefix `DownstreamCount`), acknowledgement state, and age decay. Hold-cached against PLC-cycle strobe; `Changed` event fires only on top-cause symbol flip.
- Added `AxoIncidentBarView` (`AXOpen.Core.Blazor`, `AXOpen.Messaging.Static`) — sticky in-flow Blazor component that renders the top probable cause as a severity-colored bar with click-to-expand panel, optimistic acknowledge, admin-gated restore, `aria-live=polite` for accessibility, adaptive 750 ms (active) / 2500 ms (idle) polling cadence using two-tier batch reads.
- Added `AxoIncidentBarPresenter` — pure-logic seam exposing `CurrentState` (visibility, severity bucket, pulse flag, rows, ack-pending markers) and static Tailwind class mappers (`GlowClass`, `BadgeClass`, `BackgroundClass`) for custom UI shells.
- Added `IRankableMessage` + `AxoMessengerRankableAdapter` — delegate-driven projection of `AxoMessenger` so the analyzer can be unit-tested without twin scaffolding.
- Added showcase `AxoIncidentBarExample.st` (nested Station → Drive → Encoder + Conveyor → Sensor topology) and `Pages/core/AxoIncidentBar.razor` page demonstrating the bar end-to-end.

**Other:**
- Documentation: added `AxoIncidentBar.md` describing the ranking formula, severity floor (default Error), and Blazor mount pattern. Cross-linked from `AxoMessenger.md` via TOC.

### 0.55.1

**Other:**
- `AxoTaskView` Busy state revised: button colour is now `btn-success` (was `btn-attention`) and the state icon is a solid filled circle rendered with `bg-(--color-btn-success)` — replacing the previous spinning ring (`animate-spin`). The match between button background and circle reinforces "running, healthy".
- `AxoTaskView` Aborted state button colour is now `btn-warning` (was `btn-attention`) so it reads visibly as "halted by user, attention needed" against the Operon palette.
- `AxoTaskView` and `AxoToggleTaskView` Disabled state no longer applies `blur-[1px]`. Disabled buttons stay sharp at `btn-inactive`; on `AxoTaskView` the `lock-closed` icon already conveys the disabled affordance.
- `AxoTaskView`, `AxoToggleTaskView`, and `AxoMomentaryTaskView` now have a fixed button height (`h-11`) with `py-1!` padding override. Labels are clamped to two lines (`line-clamp-2`) with balanced wrap (`text-balance`), break-anywhere overflow (`wrap-anywhere`), tight leading, and `text-xs` size — long descriptions wrap then ellipsise without the button growing vertically.
- `AxoMomentaryTaskView` button colour now follows state: `btn-primary` while pressed (ON), `btn-info` while released (OFF). Label is uppercased.

### 0.55.0

**New features:**
- `AxoTaskView` now renders each lifecycle outcome distinctly. The previously dead state-to-class mapping in `AxoTaskView.razor.cs` is now wired into the button: `Ready` → `btn-info`, `Busy` → `btn-attention`, `Done` → `btn-success`, `Aborted` → `btn-warning` with a `stop` icon, `Error` → `btn-danger` with an `x-mark` icon. Disabled tasks override the state visual with a `lock-closed` icon and `btn-inactive blur-[1px]`.
- `AxoTaskView` exposes `Component.ErrorDetails` through the button's native `title` tooltip when the task is in the `Error` state — hover surfaces the message without modal navigation.
- `AxoTaskView` shows a dedicated `Resume` button (HeroIcon `play`) alongside `Reset task` when the task is in the `Aborted` state, calling `Component.ResumeTask()` directly from the proxy.
- `AxoTaskView` advertises current state to assistive technology via `aria-label="<description> — <state>"` on the action button.
- Added showcase examples `AxoTaskErrorExample` and `AxoTaskAbortedExample` (with tagged regions `AxoTaskErrorPattern` and `AxoTaskAbortedPattern`) demonstrating the Error and Aborted terminal states in the `/core/AxoTask` Live Demo tab.
- Added `ResumeTask` resource entry to `AxOpenCoreResources.resx` and all eight culture variants (de, de-DE, es, es-ES, hu-HU, pl-PL, sk, sk-SK) for the new Resume button tooltip.

### 0.50.0

**Other:**
- `AxoToggleTaskView` Blazor rendering aligned with `AxoTaskView` for visual consistency when both task buttons appear side-by-side in component views. Filled/hollow state circle on the left, uppercased `DESCRIPTION — STATE` label in the center, invisible right-slot spacer for width parity, and state-driven button color (`btn-success` ON / `btn-info` OFF / `btn-inactive blur-[1px]` disabled). No PLC API change — `SwitchOn()` / `SwitchOff()` / `Toggle()` / event-like overrides are unchanged.

### 0.43.0

**New features:**
- Added AxoAlert showcase example with dedicated doc markers (`AlertDeclaration`, `AlertShowPattern`, `AlertTypes`, `AlertRestore`)
- Added AxoLogger enriched examples: log levels, SetMinimumLevel, LogWithSender, LogWithMessageCode
- Added AxoContext service injection examples: InjectLogger, InjectMessengerService, InitializeRootObject
- Added AxoSequencerContainer RunOnce and RequestStep/branching examples with localizable descriptions
- Added AxoTask Abort/Resume/Restore code snippet references
- Added AxoDialog simple `Show()` fluent pattern example (HMI-only, without external close)
- Added AxoSequencer SequenceMode example

**Bug fixes:**
- Fixed missing `MapHub<SignalRDialogHub>` in showcase Program.cs — dialogs could not sync across clients
- Fixed missing `AxoRemoteTask.Initialize()` in showcase Program.cs — remote task entered error on invoke
- Fixed missing `AxoLogger.StartDequeuing()` in showcase Program.cs — PLC logs were not forwarded to .NET
- Fixed broken `MessageTextHelpDeclaration` tag reference in AxoMessenger.md (corrected to `PlcTextListDeclaration`)

**Other:**
- Renamed all core documentation files from UPPERCASE to PascalCase (e.g., `AXOTASK.md` → `AxoTask.md`)
- Updated all cross-references, toc.yml, search registry, and Blazor page path constants to match new filenames
- Added comment markers to Program.cs for documentation extraction (`AxoLoggerStartDequeuing`, `AxoRemoteTaskInitialize`, `MapDialogHub`, `AddBlazorServices`, `ConnectorConfiguration`, `AxoApplicationBuilder`)
- Added TROUBLES.md with structured troubleshooting for all core types
- Added CHANGELOG.md

**Breaking changes:**
- Documentation file renames may break external bookmarks or links referencing the old UPPERCASE filenames
