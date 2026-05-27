# AxoIncidentBar

*Probable-cause ranking + persistent operator-facing incident bar over `AxoMessenger`.*

`AxoCauseAnalyzer` ranks active `AxoMessenger` instances and surfaces the most
likely *cause* of the current failure pattern. `AxoIncidentBarView` renders the
top probable cause as a persistent, severity-colored bar at the top of the
application layout, with a click-to-expand panel listing additional candidates,
score breakdown, and acknowledgement controls.

The cause analyzer reads only what `AxoMessenger` already exposes — no PLC
source changes are required to opt in. See [AxoMessenger](AxoMessenger.md) for
the underlying messaging primitive.

---

## Why it exists

`AxoMessageProvider` returns a flat list of all active messengers. During a
real cascade failure (a sensor trips → conveyor stops → station enters E-stop)
the operator sees three simultaneous alarms with no indication of which one is
the *cause* versus a *symptom*. `AxoCauseAnalyzer` applies a heuristic to score
each active messenger and rank the most likely root cause to the top of the
list. `AxoIncidentBarView` then renders that ranking as a single, visually
unmissable bar so the operator's attention lands on the right thing first.

---

## Severity floor

By default only **Error**, **ProgrammingError**, and **Critical** messages
enter the cause ranking. Warnings, Potentials, and Infos still count toward
`AxoMessageProvider.ActiveMessagesCount` (so the existing badge indicators stay
accurate), but they never appear in the bar. The floor is configurable via
`AxoCauseAnalyzerOptions.CauseSeverityFloor`.

---

## Ranking formula

Each Error-or-above active messenger is scored:

```
Score =  0.40 * severity_weight(Category)
       + 0.30 * (is_burst_root ? 1 : 0)
       + 0.20 * log10(1 + DownstreamCount)
       + 0.10 * (is_acknowledged ? 0 : 1)
       - 0.02 * minutes_since_risen
```

| Term | Meaning |
|------|---------|
| `severity_weight` | Critical=1.0, Error=0.9, ProgrammingError=0.85, Warning=0.6, Potential=0.4, Info=0.1 — operator-actionability map, not enum ordinals |
| `is_burst_root` | TRUE for the earliest `Risen` within the sliding `BurstWindow` (default 8 s, anchored on the latest `Risen`) — likely root of a cascade |
| `DownstreamCount` | Number of *other* active messengers whose container Symbol is a descendant of this messenger's container Symbol (twin-tree ownership) |
| `is_acknowledged` | Ack'd-but-still-active messages are de-prioritized but still listed (operator already saw them) |
| `minutes_since_risen` | Long-running alarms decay below freshly-risen peers |

**Anti-strobe**: when the source briefly reads empty mid-PLC-cycle, the
published top cause is held for `HoldDuration` (default 2 s) before clearing.

**Idle hysteresis**: the bar itself remains visible for `IdleHysteresis`
(default 2 s) after the last cause clears, then collapses to zero height.

---

# [CONTROLLER](#tab/controller)

## Nested twin-tree topology

The cause analyzer's topology heuristic identifies a parent component as
"owner" of its descendants' alarms via Symbol prefix. To exercise it, declare
messengers at multiple tree levels:

[!code-pascal[](../../showcase/app/src/core/AXOpen.Messaging/AxoIncidentBarExample.st?name=TopologyDeclaration)]

The Station container holds a Drive sub-component (which holds an Encoder
leaf) and a Conveyor sub-component (which holds a Sensor leaf). Each level
declares its own `AxoMessenger`.

## Activate the messenger

Standard `ActivateOnCondition` works unchanged — the analyzer never needs the
PLC code to know it exists:

[!code-pascal[](../../showcase/app/src/core/AXOpen.Messaging/AxoIncidentBarExample.st?name=StationActivate)]

When Station and Drive both fire at the same time, the analyzer detects that
Drive's container is a descendant of Station's container (Symbol-prefix check
stripped of the messenger's own segment), credits Station with `DownstreamCount = 1`,
and ranks Station above Drive even though Drive is `Critical` and Station is
`Error` — because Station owns more of the cascade.

# [BLAZOR](#tab/blazor)

## Create a provider

`AxoIncidentBarView` consumes an `AxoMessageProvider`. Create it once per
layout / circuit, scoped to the relevant twin object root:

[!code-csharp[](../../showcase/app/ix-blazor/showcase.blazor/Pages/core/AxoIncidentBar.razor?name=ProviderCreate)]

## Mount the bar

Drop `AxoIncidentBarView` into your layout (typically near the top of
`MainLayout.razor`, above `@Body`):

[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/core/AxoIncidentBar.razor?name=BarMount)]

The bar is in-flow — it has zero height when no Error+ cause is active, so
nothing else needs to reflow. Severity drives the color (`shadow-glow-danger`
+ `bg-danger/15` for Error/Critical, `warning` and `info` for the other
buckets); Critical and ProgrammingError additionally animate with
`animate-pulse` until acknowledged.

## Parameters

| Parameter | Type | Default | Purpose |
|-----------|------|---------|---------|
| `Provider` | `AxoMessageProvider` | required | Source of active messengers |
| `Options` | `AxoCauseAnalyzerOptions?` | `null` (defaults) | Override `BurstWindow`, `HoldDuration`, `IdleHysteresis`, `TopN`, `CauseSeverityFloor` |
| `PlcLabel` | `string?` | `null` | Optional prefix for multi-PLC stacked deployments |
| `AllowRestore` | `bool` | `false` | Show admin-only "Restore parent task" button in expanded panel |
| `Class` | `string?` | `null` | Extra Tailwind classes appended to the outer card |
| `ActivePollingMs` | `int` | `750` | Tier-2 batch-read cadence while any Error+ active |
| `IdlePollingMs` | `int` | `2500` | Tier-1 lightweight cadence when idle |

***

## Multi-PLC deployments

Pass each PLC context as its own provider and stack the bars vertically. The
analyzer's topology check uses `Symbol` prefix per-PLC, which is naturally
correct (no cross-PLC parenting).

## Programmatic access

The analyzer can be used without the bar. `AxoCauseAnalyzer.Create(provider)`
returns an instance whose `TopCause`, `ProbableCauses`, `ActiveCount`,
`PeakSeverity`, and `Changed` event are usable from any C# host (custom HMI,
logging sinks, external monitoring). `AxoIncidentBarPresenter` provides a
pure-logic seam (no rendering) for custom UI shells.

## Testing

The analyzer is unit-tested via `IRankableMessage` — a thin abstraction over
`AxoMessenger` that takes plain delegates, so tests do not need twin
scaffolding. The full ranking spec is locked in
`axopen/src/core/tests/AXOpen.Core.Tests/Messaging/AxoCauseAnalyzerTests.cs`
and the presenter logic in `AxoIncidentBarPresenterTests.cs`.

See also [AxoMessenger](AxoMessenger.md) · [AxoLogger](AxoLogger.md).
