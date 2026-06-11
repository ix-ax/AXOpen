### [FIX] `AxoKrc5` local E-stop monitoring, 20002 rekey, opt-in task-timeout watchdog

**Note:** PLC fix in `src/components.kuka.robotics/ctrl/src/AxoKrc5/v_5_x_x/`. KRC5-only — `AxoKrc4` is unchanged. **Breaking:** public input `Inputs.Automatic` renamed to `Inputs.LocalEstopOk`. Branch: `1168-bug-update-krc4-following-the-updates-on-krc5` ([#1177](https://github.com/Inxton/AXOpen/pull/1177), refs #1168).

- fix!: Input bit `%X2` repurposed from `Inputs.Automatic` ("Automatic [AUT]") to `Inputs.LocalEstopOk` ("Local Emergency Stop OK"). Whenever `LocalEstopOk = FALSE` the component raises new error **20006** (`Error`) — unconditionally, every cycle, outside the task-busy safety gate that drives 20001–20005. Matching messenger text and `errorDescriptionDict` entries added to the .NET twin (`AxoKrc5.cs`); `AxoKrc5View.razor` header badge and inputs panel rebound to `LocalEstopOk` (polling updated in `AxoKrc5View.razor.cs`).
- fix: Safety message **20002** rekeyed to `Inputs.ExternalAutomatic = FALSE` (previously `Inputs.Automatic`, whose bit was repurposed); still raised as `Info` while a task is busy.
- fix: Task-duration watchdog reinstated as **opt-in** (partially reverting #1167): every task except `StartMotors` calls `ThrowWhen(Duration >= Config.TaskTimeout AND Config.TaskTimeout > T#0s, '{TaskName} timeout.')`. Config defaults changed `ErrorTime LT#5S → LT#0S`, `TaskTimeout LT#50S → LT#0S`, so the watchdog stays disabled out of the box; the `_errorTimer` (`ErrorTime`) watchdog remains removed.
- feat: Robot-side stop messages are auto-acknowledged — `Outputs.ErrorConfirmation := Inputs.StopMess AND NOT _blink.output` pulses during the waiting phases of `StartAtMain`, `StartMotorsAndProgram`, `StartMotorsProgramAndMovements`, `StartMotors`, `StartMovements`, and `StartProgram`. Blinker centralised to a single 1 s `_blink.Blink()` tick per `Run()` cycle (`BLINKER_TIME : TIME := T#1S`); per-task 500 ms blink calls removed.
- docs: `AxoKrc5.md` divergence note and Configuration section rewritten; `TROUBLES.md` records the per-class 20002 keying split, the new 20006 entry, and the KRC4 default-on vs KRC5 opt-in watchdog. Library CHANGELOG bumped to `0.63.0`; `GitVersion.yml` `next-version` `0.62.3 → 0.63.0` (minor — breaking rename recorded).

**Impact:** A dropped local E-stop is now reported immediately and persistently (20006) instead of masquerading as a mode condition; stuck robot stop messages self-acknowledge; integrators can re-arm the task watchdog per application by setting `Config.TaskTimeout > 0s`.

**Risks/Review:** Twin consumers and Blazor bindings referencing `AxoKrc5.Inputs.Automatic` must migrate to `Inputs.LocalEstopOk` (`AxoKrc4.Inputs.Automatic` unaffected). `StartMotorsTask` is the only task without the reinstated `ThrowWhen` — suspected oversight, documented as-is. Watchdog now defaults OFF (`LT#0S`) — applications relying on the old `LT#50S` self-abort must set it explicitly.

**Testing:** `apax ib` in `src/components.kuka.robotics`; exercise KRC5 cell: 20006 on local E-stop drop, 20002 on external-auto drop, timeout abort with `TaskTimeout > 0s`, `ErrorConfirmation` pulse while `StopMess` active.

### [FIX] `AxoKrc5` no longer throws spurious task-timeout errors

**Note:** PLC bug fix in `src/components.kuka.robotics/ctrl/src/AxoKrc5/v_5_x_x/AxoKrc5.st`. KRC5-only — `AxoKrc4` is unchanged. No public-API change. Branch: `1165-bug-kuka-issue-with-robot-reset` ([#1167](https://github.com/Inxton/AXOpen/pull/1167)).

- fix: Removed the `ThrowWhen` watchdog calls (`_errorTimer.output` and `Duration >= Config.TaskTimeout`) from every `AxoKrc5` task — `StartAtMain`, `StartMotors`, `StartProgram`, `StartMotorsAndProgram`, `StartMotorsProgramAndMovements`, `StartMovements`, `StopMotors`, and `StopMovementsAndProgram`. A stalled task now surfaces through the component's own status message instead of an additional, redundant task-timeout error that fired even when the component had already reported the proper condition.
- docs: `src/components.kuka.robotics/docs/AxoKrc5.md` and `TROUBLES.md` record the divergence (a 4th KRC5-only difference; `ErrorTime` / `TaskTimeout` no longer abort KRC5 tasks; the `TaskTimeout` watchdog troubleshooting bullet is now flagged KRC4-only). Library CHANGELOG bumped to `0.61.1`.

**Impact:** Operating a KRC5 robot no longer produces nuisance task-timeout errors on top of the component's genuine status message. `AxoKrc4` retains both watchdogs.

**Risks/Review:** KRC5 tasks no longer self-abort on duration; long-running or stuck tasks rely on the component status message and operator intervention rather than the `TaskTimeout` watchdog.

**Testing:** `apax ibt` in `src/components.kuka.robotics` — build + AxUnit suite green.

### [FIX] `axdev` password guard contradicted the secrets complexity policy

**Note:** Bug fix in `src/axopen.dev`. Branch: `feat/axdev-user-secrets-loader`.

- fix: `AXOpen.Dev.Validation.PasswordValidator` no longer rejects `$ & ( ) *`. These are endorsed by the set-time complexity policy (`configure-secrets.sh` requires a special char from `!@#$%^&*()_+-=`), so a password that satisfied the complexity rule was then rejected at use time by `axdev alf` / `axdev all` with "The PASSWORD contains problematic characters." The blocklist now keeps only genuinely-dangerous shell metacharacters (`` ` \ " ' | ; < > ? [ ] { } `` and whitespace) — safe because arguments reach apax/openssl via CliWrap (no shell). Error message and `PasswordValidatorTests` updated.

**Impact:** `apax alf` / `apax all` accept the same passwords the secrets-setup flow accepts; no more spurious rejection of compliant passwords.

**Testing:** `dotnet test src/axopen.dev/AXOpen.Dev.Tests` — 180 passed.

### [BUILD] `axdev` loads dotnet user-secrets at startup

**Note:** Developer-CLI enhancement in `src/axopen.dev`. No PLC source change, no public-API removal. Branch: `feat/axdev-user-secrets-loader`.

- feat: `AXOpen.Dev.Secrets.UserSecretsLoader` reads dotnet user-secrets into the process environment so PLC verbs resolve `AX_TARGET_PWD` / `AX_USERNAME` without a prior `source load-secrets.sh`. It locates the twin project's `<UserSecretsId>` (probes `../axpansion/twin` then `.`, overridable via the `AX_SECRETS_PROJECT` environment variable), reads its `secrets.json` from the OS user-secrets root, and flattens nested keys with the standard `key:subkey` convention.
- feat: New shared entry point `AxdevApp.Run(args)` calls `UserSecretsLoader.Load()` then builds and runs the command app. Both the packed `dotnet axdev` tool (`AXOpen.Dev.Tool/Program.cs`) and the in-repo dispatcher (`src/scripts/dev.cs`) now call `AxdevApp.Run` instead of `AxdevApp.Build().Run`.
- test: `AXOpen.Dev.Tests/Secrets/UserSecretsLoaderTests.cs` covers apply-from-store, existing-env-wins precedence, missing project / missing store / malformed JSON / no-`UserSecretsId` no-ops, the `AX_SECRETS_PROJECT` override, and nested-key flattening.

**Impact:**
- The template's credential UX (per-project `dotnet user-secrets`) is preserved while removing the bash `source load-secrets.sh` step, so apax verbs can call `axdev` directly on any platform.
- Precedence is non-surprising: an already-set environment variable (or apax variable) always wins over the secrets store; an explicit `-p/--password` still overrides everything in `PlcCommandSettings.ResolvePassword`.

**Risks/Review:**
- Secret loading is best-effort: a missing twin project, missing store, or unreadable JSON is a silent no-op, and the per-command argument guards still report any genuinely missing credential.

**Testing:**
- `dotnet test src/axopen.dev/AXOpen.Dev.Tests` — full suite green (176 passed), including the 8 new `UserSecretsLoaderTests`.

### [BUILD] Dependency-maintenance tooling + AXSharp `0.47.0-alpha.484` bump

**Note:** Build/CI tooling and dependency maintenance. No public-API change, no PLC source change. Branch: `deps-update`.

- feat: `scripts/update-latest-deps.ps1` — bumps all non-AXSharp dependencies (NuGet + npm) to their latest stable versions, sharing common helpers via `scripts/_deps-common.ps1`.
- feat: `scripts/update-vulnerable-deps.ps1` — scans npm and NuGet dependencies for known vulnerabilities and emits a report.
- chore: AXSharp packages bumped to `0.47.0-alpha.484` in `Directory.Packages.props`, with transitive dependencies reconciled. `.config/dotnet-tools.json` updated to match.
- chore: Added `.claude/skills/update-axsharp-version/SKILL.md` — skill for updating AXSharp and Inxton.Operon package versions.
- chore: Removed obsolete `package.json` / `package-lock.json` files across `src/components.abb.robotics`, `src/components.abstractions`, `src/data`, `src/data/src/AXOpen.Data.Blazor`, `src/inspectors`, and a stray `apax.yml`, to clean up the project structure.
- chore: `develop` branch GitVersion mode changed to `ContinuousDeployment`.
- chore: Styling dependencies refreshed (`src/styling/src/package.json` / lock; `momentum.css` regenerated).

**Impact:**
- Routine dependency bumps and vulnerability scanning are now scriptable and reproducible.
- AXSharp consumers build against `0.47.0-alpha.484`.
- Dead npm lockfiles no longer pollute the tree or trigger spurious tooling.

**Risks/Review:**
- Dependency version bumps can introduce behavioural drift; verify a full `dotnet build` and the styling render after pulling.

**Testing:**
- Run `scripts/update-latest-deps.ps1` and `scripts/update-vulnerable-deps.ps1` end-to-end (exit code 0).
- `dotnet build` from solution root succeeds against the bumped package set.

### [CORE] AxoSequencer step-timeout alarm — does not fall after timeout clears

**Note:** PLC bug fix in `src/core/ctrl/src/AxoCoordination/AxoSequencer/AxoSequencer.st` (`AxoStepTimedOutMessenger.Activate`). No public-API change. Branch: `fix-issue-when-timeout-sequencer-alarm-doesnot-fall`.

- fix: `AxoStepTimedOutMessenger.Activate` now resolves `_context := inParent.GetContext()` on every call rather than only on the first rising transition into `ActiveAcknowledgeNotRequired`, and refreshes `ActiveContextCount := _context.OpenCycleCount()` on every cycle the messenger remains non-Idle. Previously, `ActiveContextCount` was set once at rise time and never advanced, so the `AxoMessenger` base could not detect that `Activate` was still being called cycle-to-cycle, and the step-timeout alarm would not fall when the sequencer left the timed-out step.
- fix: Added explicit `Run(IAxoObject inParent)` override on `AxoSequencer` calling `SUPER.Run(inParent)` — placeholder for the per-cycle `_msgStepTimedOut.Serve(THIS)` wiring (currently commented) so the override site exists for the messenger lifecycle without changing observable behaviour.

**Impact:**
- Sequencer step-timeout alarms now transition Idle → Active → Idle correctly across the step-timeout boundary; operators no longer see a stale "Step timed out" entry persisting after the sequencer has advanced past the timed-out step.
- The aggregate count maintained via `THIS.GetParent().AggregateMessage(1)` is now driven by an `ActiveContextCount` that tracks the actual cycle of last activation, restoring the standard `AxoMessenger` fall semantics for this messenger.

**Risks/Review:**
- The `Run` override is a pass-through to `SUPER.Run` — no behavioural difference yet, but adds an extra virtual call per sequencer cycle. The commented `_msgStepTimedOut.Serve(THIS)` line is the intended wiring for a follow-up patch and is left in place as a documentation marker.

**Testing:**
- AxoSequencer step-timeout scenario in the showcase (`/core/AxoSequencer`) — induce a timeout, observe the messenger rises, then allow the step to complete and verify the alarm falls within one cycle of the step transition.

### [CORE] AxoIncidentBar — perf, ranking-accuracy, and sender-identification fixes

**Note:** Patch follow-up to the `0.56.0` AxoIncidentBar feature. All changes in `src/core/src/AXOpen.Core/AxoMessenger/Static/` and `src/core/src/AXOpen.Core.Blazor/AxoMessenger/Static/`. No PLC source change. No public-API removal; `IRankableMessage` gains one new member with an adapter-side default. Branch: `fix-incident-bar-perf-issues`.

- fix: `AxoCauseAnalyzer` ranking — severity-tier sort is now the outermost key (`OrderByDescending(SeverityWeight).ThenByDescending(Score)`). A `Critical` candidate is never ranked below an `Error` one regardless of burst/ownership/age bonuses. Score remains the within-tier tie-breaker. Previously a long-running, deeply-owned `Error` could outrank a freshly-risen `Critical`, hiding the more urgent alarm.
- fix: `AxoCauseAnalyzer` age contribution is capped at 7 days (`_maxAgeMinutes = 7 * 24 * 60`). Uninitialized `RisenUtc` (`DateTime.MinValue`) previously injected ~10⁹ minutes via `W_AGE` and dominated the score before `ReadDetails` had populated `Risen`.
- fix: `AxoCauseAnalyzer` `BurstWindow` cutoff is clamped to `DateTime.MinValue` when the maximum `RisenUtc` is smaller than the window — prevents `DateTime` underflow on the first cycle before `Risen` is read.
- fix: `AxoCauseAnalyzer` excludes candidates with empty `DisplayMessage` (e.g. `MessageCode == 0`) — there is nothing meaningful to surface to the operator, but those messengers would still consume burst-root credit.
- fix: `AxoIncidentBarView` polling cadence is now driven by `_analyzer.ActiveCount` instead of `Provider.ActiveMessagesCount`. `Provider.ActiveMessagesCount` depends on `MsgCnt` aggregation reaching the observed root, which is not guaranteed in every project topology; the analyzer's count comes from the just-read state and is authoritative.
- fix: `AxoIncidentBarView.Tick()` now always reads `ReadMessageStateAsync` first, then pulls `ReadDetails` when **any** messenger reports a non-Idle state. Previously the bar could skip detail reads entirely (and therefore never repopulate `Risen`/`Fallen`) when the provider's aggregated active count was zero while individual messengers were active.
- fix: `AxoIncidentBarView.ConfigurePolling` and `Tick` errors are now logged via Serilog instead of being silently swallowed — `Information` on successful configure (with messenger count), `Debug` per tick (with `ActiveCount` and `TopCause` symbol), `Warning` on read/recompute failure, `Error` on initialize failure. The previous `catch { /* swallow */ }` made polling lifecycle and per-tick state invisible without attaching a debugger.
- feat: `AxoCauseAnalyzer.SenderDisplayName` now produces a top-down `AttributeName` breadcrumb (e.g. `Station › Drive › Encoder`) walking from the messenger's owning component up to but excluding the unnamed root, with a fallback to `GetSymbolTail` when no chain is available. The previous single-segment `GetSymbolTail` was ambiguous for nested topologies (two `Encoder` messengers under different drives both displayed as `Encoder`).
- feat: `AxoIncidentBarView` renders the full PLC symbol path as a mono `text-xs` subtitle beneath the breadcrumb sender label, and as the `title` tooltip on hover, both on the top bar and in expanded rows.
- feat: `IRankableMessage` exposes a new `SenderSymbol` member (full PLC symbol path). `AxoMessengerRankableAdapter` accepts an optional `senderSymbol` projector and defaults `SenderSymbol` to the messenger symbol when none is supplied — existing call sites compile unchanged.
- feat: `AxoMessageProvider.ReadMessageStateAsync` now batches `Risen`, `Fallen`, and `Acknowledged` alongside the state/category/code triple. Burst-window decisions no longer require a separate `ReadDetails` round-trip in the common case.
- feat: `AxoMessageProvider.ReadDetails` issues its batch read at `eAccessPriority.Low` to reduce contention with operator-driven traffic on the same connector.
- docs: Updated `src/core/docs/AxoIncidentBar.md` ranking-formula section with a "Severity-tier outermost" note and an age-cap mention, replaced the Station/Drive cascade example to match the new severity-first sort order, and added a "Sender identification" subsection to the BLAZOR tab documenting the breadcrumb + `SenderSymbol` behaviour. Appended `0.56.1` entry to `src/core/docs/CHANGELOG.md`.

**Impact:**
- A `Critical` alarm always sits on top of the bar — the previously-possible inversion (long-running `Error` outranking a fresh `Critical`) is closed.
- Pre-first-detail-read cycles no longer rank random uninitialized-time alarms at the top.
- The bar now identifies the originating instance unambiguously when multiple components share the same component-level display name (`Encoder` under Drive 1 vs. Drive 2).
- Polling decisions match the analyzer's actual workload, so the bar correctly drops to the idle cadence (2500 ms) when there is genuinely nothing to rank, even in topologies where `Provider.ActiveMessagesCount` rolls up partially.
- Operators can correlate the breadcrumb sender with the underlying PLC variable path via the tooltip without leaving the bar.

**Risks/Review:**
- `IRankableMessage.SenderSymbol` is a new interface member. The library's own implementation (`AxoMessengerRankableAdapter`) supplies it via a defaulted constructor parameter. External code that **directly implements** `IRankableMessage` (no in-tree call sites) will need to add the member; this is a soft break tracked in "Other" of `src/core/docs/CHANGELOG.md` rather than "Breaking changes" because the interface was introduced in `0.56.0` and has no external implementers yet.
- `AxoMessageProvider.ReadDetails` priority dropped to `eAccessPriority.Low`. In projects with chronic high-priority operator traffic, the bar may now wait longer for its detail batch — `ActivePollingMs` (default 750 ms) is the worst-case staleness ceiling.
- Severity-first sort changes ranking output for any deployment that relied on the previous score-only order to surface ownership over severity. The Station/Drive example in `AxoIncidentBar.md` has been rewritten to reflect the new behaviour; deployments depending on the old order need to either escalate the owner's category or accept the new precedence.

**Testing:**
- `dotnet test src/core/tests/AXOpen.Core.Tests/Messaging/` — `AxoCauseAnalyzerTests`, `AxoIncidentBarPresenterTests`, `AxoMessengerRankableAdapterTests` updated to cover the new sort precedence, age cap, burst clamp, empty-message exclusion, and `SenderSymbol` projection.
- `dotnet build src/core/src/AXOpen.Core.Blazor/` — Razor compiles clean with the new Serilog using and `IRankableMessage.SenderSymbol` references.
- Showcase: `Pages/core/AxoIncidentBar.razor` — bar shows the breadcrumb on Station/Drive/Encoder topology and the mono symbol-path subtitle on hover.

### [CORE] AxoCauseAnalyzer + AxoIncidentBarView — probable-cause ranking and persistent operator incident bar over AxoMessenger

**Note:** Additive change in `src/core/src/AXOpen.Core/AxoMessenger/Static/` and `src/core/src/AXOpen.Core.Blazor/AxoMessenger/Static/`. No PLC source change required for application opt-in; the analyzer reads only fields `AxoMessenger` already exposes. Branch: `feat-most-probable-failure-cause`.

- feat: `AxoCauseAnalyzer` (`AXOpen.Messaging.Static`) — heuristic ranking layered on `AxoMessageProvider`. Scores each Error-or-above active messenger by severity (operator-actionability map: Critical=1.0, Error=0.9, ProgrammingError=0.85, Warning=0.6, Potential=0.4, Info=0.1), burst-root (earliest `Risen` within sliding `BurstWindow`, default 8 s, anchored on latest `Risen`), twin-tree topology (container-Symbol-prefix `DownstreamCount`), acknowledgement state, and age decay. `Changed` event fires only on top-cause symbol flip. Anti-strobe hold (`HoldDuration` default 2 s) suppresses PLC-cycle mid-read empty publishes. Static factory `AxoCauseAnalyzer.Create(AxoMessageProvider, options?, nowUtc?)` wires the adapter pipeline.
- feat: `AxoIncidentBarView` (`AXOpen.Core.Blazor`, namespace `AXOpen.Messaging.Static`) — sticky in-flow Blazor component (zero height when idle, no layout reflow) that renders the top probable cause as a severity-colored bar (`shadow-glow-{danger|warning|info}` + flat `bg-{token}/15` tint — color token matches the glow). `animate-pulse` for Critical/ProgrammingError until acknowledged. Click-to-expand panel shows top-5 candidates with score, evidence (burst-root, downstream count), optimistic Acknowledge, admin-gated Restore (`<AuthorizeView Roles="Administrator">`). Adaptive polling — 750 ms when any Error+ active, 2500 ms idle — using two-tier batch reads via the existing provider. `aria-live="polite"` for accessibility.
- feat: `AxoIncidentBarPresenter` — pure-logic seam. Exposes `CurrentState` (visibility, severity bucket, pulse flag, rows, ack-pending markers) and static Tailwind class mappers (`GlowClass`, `BadgeClass`, `BackgroundClass`, `ToSeverityBucket`). All decision logic is xUnit-testable without rendering or twin scaffolding. `IncidentBarSeverity` enum split into `Critical` / `Error` / `Warning` / `Info` / `None`.
- feat: `IRankableMessage` + `AxoMessengerRankableAdapter` — delegate-driven projection (`Func<string>`, `Func<DateTime>`, etc.) so tests fake fields without standing up an `AxoMessenger`. Delegates re-invoke on each access so the analyzer sees the latest batch-read value.
- feat: Default `CauseSeverityFloor = eAxoMessageCategory.Error`. Warning/Potential/Info still count in `ActiveCount` / `PeakSeverity` (global indicators stay accurate) but never enter the cause ranking. Configurable via `AxoCauseAnalyzerOptions`.
- fix: Topology heuristic now compares CONTAINER symbols (strip last segment), not messenger Symbols directly. Earlier draft treated sibling messengers as unrelated even when their parent components nested. New test `Topology_uses_container_prefix_not_messenger_symbol_prefix` locks the realistic twin-tree shape.
- feat: Showcase `AxoIncidentBarExample.st` (nested `Station` → `Drive` → `Encoder` + `Conveyor` → `Sensor`, each with its own `AxoMessenger` and condition flag) plus `Pages/core/AxoIncidentBar.razor` (Live Bar tab with operator controls, Topology code tab with snippet refs, Heuristic tab with ranking formula). NavMenu entry under Core; search registry entry.
- feat: Template `axopen.template.simple` — `MainLayout.razor` mounts `<AxoIncidentBarView Provider="@_alarmProvider" />` once per layout, cascades the provider so `GeneralAlarms.razor` consumes the same provider instance instead of walking the twin tree a second time.
- feat: Template `tailwind.css` extended with `@source` paths for `axopen/src/core/src/AXOpen.Core/**/*.cs` and `AXOpen.Core.Blazor/**/*.razor` so future bar class additions get JIT-compiled.
- docs: Added `src/core/docs/AxoIncidentBar.md` (ranking formula, severity floor, Blazor mount pattern). Cross-linked from `src/core/docs/toc.yml` under "Messengers (Alarms)". Appended `0.56.0` entry to `src/core/docs/CHANGELOG.md` (minor bump from `0.55.1`, GitVersion `next-version` updated).
- test: 28 new tests in `src/core/tests/AXOpen.Core.Tests/Messaging/` — `AxoCauseAnalyzerTests` (15: severity-floor, severity map, burst window, sliding burst, topology container prefix, ack de-prio, TopN clamp, anti-strobe hold, Changed event semantics, age decay), `AxoMessengerRankableAdapterTests` (2: projection + delegate re-invocation), `AxoCauseAnalyzerFactoryTests` (2: null guard + empty provider), `AxoIncidentBarPresenterTests` (26: visibility, severity bucket, pulse, additional count, rows, ack-pending, idle hysteresis, CSS class mapping, background-color-matches-glow invariant). Total: 69/69 green.

**Impact:**
- Operators see a single severity-colored bar above the layout with the highest-confidence root cause of the current incident, instead of scanning a flat alarm list.
- The bar collapses to zero height when no Error+ is active — no permanent UI cost when the line is healthy.
- Applications opt in by mounting one component in their `MainLayout.razor` and creating one provider. No ST source changes; no `AxoMessenger` API change.
- Engineers writing custom HMI surfaces can consume `AxoCauseAnalyzer` directly (events + `TopCause` / `ProbableCauses` properties) without the Blazor view.

**Risks/Review:**
- Severity-floor default is `Error`. Warning-only incidents do NOT raise the bar (intentional: operator noise reduction). Override via `AxoCauseAnalyzerOptions.CauseSeverityFloor` if a deployment needs Warning-level surfacing.
- `bg-{token}/15` and `shadow-glow-{token}` Tailwind classes must be present in the host app's compiled `momentum.css`. The template app's `tailwind.css` `@source` glob now covers the relevant axopen paths — rebuild required (`tailwind.ps1`) on first integration.
- Bar polling uses `System.Threading.Timer`; `IAsyncDisposable` cleans it up. If hosted in a Blazor Server circuit with frequent reconnects, monitor for orphaned timers under stress.
- `AxoIncidentBarView` consumes `AuthenticationStateProvider` cascaded parameter for the admin-gated Restore button. If the host app routes the bar outside an `AuthorizeRouteView` boundary, the cascading parameter is `null` and Restore degrades to no-op (no exception).

**Testing:**
- `dotnet test src/core/tests/AXOpen.Core.Tests/` — 69/69 green (17 pre-existing + 52 messaging).
- `dotnet build src/core/src/AXOpen.Core.Blazor/` — Razor compiles clean.
- `dotnet build src/showcase/app/ix-blazor/showcase.blazor/` after `apax ib` — 0 errors. Showcase page navigates to `/core/AxoIncidentBar` and renders the live bar with the topology controls.
- `dotnet build axopen.template.simple/axpansion/server/` — 0 errors. `MainLayout` cascades the provider; `GeneralAlarms.razor` consumes it without creating a second instance.

### [KUKA] KRC5 raw data exchange, coordinate-mirror diagnostics, and auto-mode severity fix ([#1151](https://github.com/Inxton/AXOpen/pull/1151))

**Note:** KRC5-only change in `src/components.kuka.robotics/`. `AxoKrc5` now diverges from `AxoKrc4` in three respects — `AxoKrc4` is intentionally left unchanged in this PR. Fixes #1148.

- feat: `AxoKrc5` exposes raw application-defined passthrough members `DataFromPlcToRobot : ARRAY[0..19] OF BYTE` (PLC → robot, output bytes `_data[44..63]`) and `DataFromRobotToPlc : ARRAY[0..15] OF BYTE` (robot → PLC, input bytes `_data[48..63]`). Both carry `RenderIgnore`; `Run()` transports them verbatim without interpretation. Wrapped in the new `<AxoKrc5DataExchangeDeclaration>` source region.
- feat: `AxoKrc5` adds per-axis coordinate-mirror task-`potential` identifiers `1501–1506` (`StartMotorsProgramAndMovements`) and `1511–1516` (`StartMovements`), raised via `TaskMessenger` while waiting for each `Inputs.Coordinates.{X,Y,Z,Rx,Ry,Rz}` to mirror the commanded value within `0.01` tolerance. Matching `.NET` twin entries added to both the `TaskMessenger` text list and `errorDescriptionDict` in `AxoKrc5.cs`.
- fix: `AxoKrc5` safety message `20002` (`Inputs.Automatic = FALSE` while a task is busy) is now raised as category `Info` instead of `Error` — losing auto mode mid-task is informational on KRC5, not a hard fault.
- feat: Showcase `AxoKrc5_v_5_x_x_Showcase.st` gained an "Exchange raw data with the robot" sequencer step (in `//<DataExchange>` markers); `Steps` widened `[0..19]` → `[0..20]`, `_lastByteFromRobot` status field added.
- docs: `AxoKrc5.md` relaxed the "identical public API to `AxoKrc4`" wording, added a **Data exchange** section (library declaration + showcase usage refs), and a note listing the three KRC5-only differences. `TROUBLES.md` flags the per-class differences (1501–1516, 20002 severity split). Appended `0.54.0` entry to `src/components.kuka.robotics/docs/CHANGELOG.md`.

**Impact:**
- Applications driving a KRC5 can now push and pull arbitrary byte payloads alongside the structured motion interface, without a library change.
- Operators see which specific axis is holding up a movement (per-coordinate `potential` IDs) rather than a single "coordinates not mirrored" wait.
- Dropping out of automatic mode mid-task no longer latches a KRC5 error state.

**Risks/Review:**
- `AxoKrc4` and `AxoKrc5` are no longer API/behaviour-identical. Documentation now states the divergence explicitly; if a follow-up backports these changes to `AxoKrc4`, the "KRC5-only" wording in `AxoKrc5.md` / `TROUBLES.md` must be reverted.
- The PLC→robot (`44..63`) and robot→PLC (`48..63`) windows overlap on the same physical I/O block in opposite directions — verify the controller-side mapping matches before relying on the passthrough.

**Testing:**
- `apax ib` in `src/showcase/app/` — the new KRC5 data-exchange sequencer step builds and runs through to `CompleteSequence`.
- `dotnet build` on `src/showcase/app/ix-blazor/showcase.blazor/` — the `AxoKrc5.cs` messenger/error-dictionary additions compile.
- `scripts/_build_documentation.ps1` — the new `[!code-pascal[]]` (showcase `DataExchange`) and `[!code-smalltalk[]]` (`AxoKrc5DataExchangeDeclaration`) directives resolve.

### [CORE] AxoToggleTaskView aligned with AxoTaskView ([#1143](https://github.com/Inxton/AXOpen/pull/1143))

**Note:** Blazor UI-only change in `src/core/src/AXOpen.Core.Blazor/AxoToggleTask/`. The PLC `AxoToggleTask` class and its public API (`SwitchOn()`, `SwitchOff()`, `Toggle()`, `IsSwitchOn()`, `IsSwitchOff()`, event-like overrides) are unchanged. Bundled with the AxoCmmtAs view expansion under the same PR; the toggle-view refactor is the core-library portion.

- refactor: `AxoToggleTaskView.razor` rebuilt to mirror `AxoTaskView`'s button shell (`flex items-center justify-between gap-2`), state-circle slot on the left (filled `bg-current` when ON, hollow `border-2 border-current` when OFF), uppercased center label, and invisible `size-5` right-slot spacer when `HideRestoreButton=false` to preserve width parity with `AxoTask`'s reset icon in row-of-2 grids.
- feat: Label format changed from `Description:State` to `DESCRIPTION — STATE` (uppercased, em-dash separator) so the on/off state reads alongside the toggle name without relying on color alone.
- feat: State-driven button color matches `AxoTaskView` vocabulary — `btn-success` (ON), `btn-info` (OFF), `btn-inactive blur-[1px]` (disabled).
- feat: Added `Class`, `Style`, and `aria-pressed` parameters/attributes for parity with `AxoTaskView` and improved accessibility.
- docs: Appended `0.50.0` entry to `src/core/docs/CHANGELOG.md`.

**Impact:**
- A row of `AxoTask` + `AxoToggleTask` buttons in a component view now lines up correctly (icon-left, label-center, icon-right) regardless of which task type each cell holds.
- Existing component proxy views that render `AxoToggleTask` via `AxoToggleTaskView` or `RenderableContentControl Presentation="Command"/"Status"` pick up the new look automatically — no host-app code changes required.

**Risks/Review:**
- `assets/AxoToggleTaskExampleVisu.gif` in `src/core/docs/assets/` was recorded against the previous bare-button rendering. Functional documentation prose in `AxoToggleTask.md` is still accurate, but the GIF visually diverges from the new view. Re-recording is a manual screen-capture step; not blocking.
- Pages that relied on the previous compact `Description:State` single-line look may now display wider buttons because of the icon + spacer slots.

**Testing:**
- `dotnet build axopen/src/core/src/AXOpen.Core.Blazor/axopen_core_blazor.csproj` — 0 errors.
- Render an `AxoToggleTask` next to an `AxoTask` in a Blazor showcase page (`Pages/core/DocuExamples/AxoToggleTaskDocu.razor` exposes four variants) and visually verify the icon/label/spacer columns align.
- Toggle the underlying PLC state and confirm the button switches between filled+`btn-success` and hollow+`btn-info`; set `Disable=true` and confirm `btn-inactive blur-[1px]` activates.

### [KUKA] KRC5 showcase, docs, and central changelog ([#1117](https://github.com/Inxton/AXOpen/pull/1117))

**Note:** Extends the KRC5 library assets landed in [#1116](https://github.com/Inxton/AXOpen/pull/1116) with full showcase and documentation coverage. No runtime behavior change in `AxoKrc4` — the existing class drives both KRC4 and KRC5 because the slot 1 / slot 2 = `DIO512` layout is identical.

- feat: Copied `kuka_krc5_dio512.hwl.yml` into `showcase/app/hwc/library_templates/kuka_krc5/`.
- feat: Added `<KukaKrc5Device>` (IP `192.168.100.106`, `kuka_rb2`) and `<KukaKrc5IoSystem>` regions to `showcase/app/hwc/plc_line.hwl.yml`.
- feat: Added third showcase ST file `AxoKrc4_v_5_x_x_Krc5Showcase.st` demonstrating the same `AxoKrc4` proxy driving a KRC5 device via `kuka_rb2_HwID`.
- feat: Wired the KRC5 instance (`axoKrc4_v_5_x_x_krc5`) into `KukaRobotics.st` documentation context.
- feat: Added `AxoKrc4 on KRC5` tab to the Blazor showcase page with live `RenderableContentControl`, code-reference, hardware-configuration, and example-sequence sub-tabs; registered KRC5 DocFX snippet markers (`Krc5GenericComponent*`).
- feat: Updated `ShowcasePageRegistry.cs` `SourceFilePaths` with the new KRC5 showcase, hwl template, and library assets; tags extended with `KRC4`/`KRC5`.
- docs: `src/components.kuka.robotics/docs/README.md` — Hardware-assets table extended with KRC5 rows; intro updated to state both KRC4 and KRC5 are supported.
- docs: `src/components.kuka.robotics/docs/AxoKrc4_v_5_x_x.md` — subtitle + intro updated; HARDWARE tab split per controller; new "KRC5 example" code-reference block; KRC5 device instantiation + IO system `[!code-yaml[]]` directives.
- docs: Appended `0.51.0` entry to `src/components.kuka.robotics/docs/CHANGELOG.md` covering the KRC5 library + showcase + docs work.

**Impact:**
- Application engineers can drop a KUKA KRC5 cell into their `plc_line.hwl.yml` using the shipped `kuka_krc5_dio512` template and use the existing `AxoKrc4` proxy — no library code changes required on consumer side.
- Showcase demonstrates the KRC5 integration live, side-by-side with two KRC4 variants.
- Central search index surfaces KRC5 documentation when users search for "KRC5" or "KUKA".

**Risks/Review:**
- New template uses the updated hwc address schema (`Type: IPv4/Profinet` split). Verify the showcase `apax hwc && apax hwfd` run regenerates `HwIdentifiers.st` with a `kuka_rb2_HwID` constant; if the generated name differs, update `AxoKrc4_v_5_x_x_Krc5Showcase.st` `Run()` argument.
- The KRC5 GSDML filename contains a space (`GSDML-V2.4-KUKA-KR C5-20220704.xml`) — any tooling that splits on whitespace must quote the path.
- Per-library CHANGELOG version bumped to `0.51.0` (minor — new feature).

**Testing:**
- `apax ib` in `src/showcase/app/` after `apax hwc && apax hwfd` to verify the KRC5 device wires through to the ST showcase.
- `dotnet build` on `src/showcase/app/ix-blazor/showcase.blazor/` to verify the razor page + search registry + HwIdentifiers reference compile.
- Load the "KUKA Robotics" page in the Blazor app and confirm all three tabs (KRC4 Example 1, KRC4 Example 2, AxoKrc4 on KRC5) render; on a connected PLC, verify the KRC5 sequencer step-logic cards populate.
- `scripts/_build_documentation.ps1` to verify the new `[!code-yaml]` / `[!code-pascal]` directives resolve against the new tagged regions.

### [KUKA] KRC4 documentation refresh and GSDML/hw template callouts ([#TBD](https://github.com/Inxton/AXOpen/pulls))

**Note:** Documentation-only change for `components.kuka.robotics`. No runtime behavior modified.

- docs: Added `<AxoKukaRoboticsConfigDeclaration>` and `<AxoKukaRoboticsHWIDsDeclaration>` tagged regions in `AxoKukaRobotics_Config.st` / `AxoKukaRobotics_HWIDs.st` so docs can reference them via `[!code-smalltalk[]]`.
- docs: Rewrote `docs/AxoKrc4_v_5_x_x.md` with full CONTROLLER / .NET TWIN / BLAZOR / HARDWARE tabs wired to the showcase and library source; added Capabilities + Configuration parameter table and an "Alternative example" block referencing `AxoKrc4_v_5_x_x_Showcase2.st`.
- docs: Expanded `docs/TROUBLES.md` with an error-ID reference covering the bring-up (700, 702, 710, 720–726, 1130–1133), cyclic I/O (1201, 1231), runtime-safety (20001–20005), and 500-range task *potential* identifiers; added component-specific diagnostics and known-limitations sections.
- docs: Updated `docs/README.md` with a "Hardware assets" table pointing at the library-shipped KRC4 GSDML (`ctrl/assets/kuka_krc4/GSDML-V2.33-KUKA-KRC4-ProfiNet_5.0-20181102.xml`) and the PROFINET hw template (`kuka_krc4_dio512.hwl.yml`); mirrored the callout in the `AxoKrc4_v_5_x_x.md` HARDWARE tab with GitHub links.
- docs: Repointed stale GitHub source links from branch `3-unify-showcase` to `dev`; appended `0.50.0` / `0.50.1` entries to `src/components.kuka.robotics/docs/CHANGELOG.md`.

**Impact:**
- Integrators see the shipped GSDML and hw template path directly from the library docs, without vendor round-trips.
- Troubleshooting KRC4 cells on-site is driven from a per-error-ID table instead of generic advice.
- `[!code-smalltalk[]]` refs in the component doc now render the live `Config` / `HWIDs` declarations from the library source.

**Risks/Review:**
- The new tagged regions must be preserved in future edits of `AxoKukaRobotics_Config.st` / `AxoKukaRobotics_HWIDs.st` — removing them breaks the doc references.
- PR number in this entry is `#TBD`; update once the PR is opened.

**Testing:**
- Build docs locally via `scripts/_build_documentation.ps1` and confirm the KRC4 pages render, the `[!code-*]` directives resolve, and the new GitHub links on the HARDWARE tab / README resolve to existing files.

### [CORE] Controller logger updates ([#1054](https://github.com/Inxton/AXOpen/pull/1054))

**Note:** Enhanced logging and messaging capabilities with new message categories and requalification features.

- feat: Added new `Potential` message category (severity level 150) for messages that may escalate to warnings or errors
- feat: Introduced message requalification system via `RequalifyDownstreamMessages()` to allow downstream message category promotion
- feat: Added `_messageCode` parameter to logger methods for improved message tracking and identification
- feat: Implemented step timeout detection in `AxoSequencer` with automatic error message generation
- feat: Enhanced `AxoMessageProvider` and `Flattener` to support configurable observation depth
- refactor: Standardized severity localization keys (simplified from "SeverityInfo" to "Info", etc.)
- refactor: Updated AxoMessenger logging signatures to use rise/fall signature markers for clarity
- chore: Bumped AXSharp packages to 0.47.0-alpha.452 and Siemens.Simatic.S7.Webserver.API to 3.3.24

**Impact:**
- Enables intermediate message categorization before escalation to warnings or errors
- Improves diagnostics through message code tracking and step timeout detection
- Provides better control over message severity in distributed systems
- Simplifies localization maintenance with consistent key naming

**New Message Categories:**
- `None` (0): No category; ignore non-critical messages
- `Info` (100): Informative messages with minimal impact
- `Potential` (150): Potential problems that may escalate (automatically requalified if configured)
- `Warning` (200): Possible problems affecting the process
- `Error` (300): Failures requiring intervention
- `Critical` (400): Critical system failures
- `ProgrammingError` (500): Implementation/configuration errors

**Risks/Review:**
- Existing code using old severity localization keys should be updated to use new simplified keys
- Message requalification logic should be tested in environments with coordinated components
- Step timeout thresholds should be validated for application-specific timing requirements

**Testing:**
- Unit tests for message requalification across all categories
- Integration tests for step timeout scenarios in sequencers
- Localization verification for all supported languages

### [INTEGRATIONS] Additional alignments with application template ([#768](https://github.com/Inxton/AXOpen/pull/768))

**Note:** Namespace and component renames require consumers to update imports, templates, and generated UI bindings before upgrading.

- refactor: Migrated application, configuration, and UI layers to `AXOpen.Components.Elements.*`, replacing legacy `AXOpen.Elements.*` usage
- refactor: Renamed the carousel component family to `AxoRotaryIndexingTable`, aligning state/control models, CRUD exposure, and tests with integration terminology
- feat: Introduced `AdamAxoObject` as a safe root context for top-level objects that previously relied on null parents
- feat: Expanded messaging suspension capabilities (including `_NULL_MESSAGING_SERVICE`) and exposed `IsSuspended()` for host applications
- fix: Routed data exchange writes through `Operation.WriteAsync`, unifying telemetry, task tracking, and error propagation in async workflows
- chore: Bumped AXSharp packages and CLI tools to `0.40.2-alpha.296`, realigned Apax catalogs, and reordered multi-root workspace entries for clarity
- misc: Normalized identifier naming (e.g., `inIdentifier`) and surfaced CRUD existence state for rotary indexing tables

**Impact:**
- Aligns component namespaces with package layout, simplifying discovery and upgrade paths across templates
- Clarifies rotary indexing semantics for operators and generated UIs, reducing friction when configuring indexing tables
- Provides a reliable root object for contexts and ensures messaging suspension hooks behave consistently during diagnostics
- Improves data exchange stability by enforcing a single async write path and updated dependency baselines

**Risks/Review:**
- Update all solution code, templates, and custom components referencing `AXOpen.Elements.*` or `AxoCarousel*` types
- Validate rotary indexing table workflows (state transitions, CRUD views, generated UI) after the rename
- Re-run messaging suspension scenarios to confirm the `_NULL_` implementation and new APIs behave as expected
- Execute pipeline/build steps after the AXSharp dependency bump and catalog realignments

**Testing:**
- Manual verification pending; run component regressions, data exchange tests, and messaging suspension coverage in CI

### Misc improvements ([#755](https://github.com/Inxton/AXOpen/pull/755))

**Note:** UI and dialog refactoring, as well as package version bumps, may affect backward compatibility for customizations or integrations.



- feat: Added Aventics pneumatic island GSDMLs (V2.3 & V2.34) for Siemens PLC integration
- feat: DotnetIxr Cake helper for executing `dotnet ixr` across folders
- feat: Added multi-root workspace file (`ctrl-workspace.code-workspace`) for control projects
- feat: Localization resource files (.resx) for Blazor, Data, Inspectors, IO, and component libraries
- refactor: Improved layouts in `AxoComponentView` and `AxoMessengerView`; updated help text formatting
- refactor: Dialog subsystem—better error handling and initialization
- chore: Bumped AXSharp.* to 0.40.1-alpha.287 and Inxton.Operon to 0.2.0-alpha.87
- misc: Improved logging and message consistency across modules
- fix: Minor stability and quality adjustments

**Impact:**
- Easier onboarding for pneumatic islands
- Faster interface generation via ixr helper
- Cleaner UI and improved operator/developer experience
- Foundation for multilingual deployments
- Larger solution surface mainly from resource and GSDML XML additions

**Risks/Review:**
- Validate GSDML XMLs in engineering tools
- Confirm resource file conventions
- Test DotnetIxr helper in CI
- Check UI for regressions

**Testing:**
- Manual validation implied; further import/build/smoke tests recommended
