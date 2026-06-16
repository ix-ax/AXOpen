## Context

The showcase Blazor app (`src/showcase/app/ix-blazor/showcase.blazor`) renders AXOpen
components as live documentation pages, all bound to one PLC `ShowcaseContext : AxoContext` via
`Entry.Plc.Ctx.*`. The PLC side is already consolidated and healthy; this change is entirely
app-side. The pain is duplication: 28 `*/Documentation/*.razor` pages copy-paste a large
scaffold (Cognex is 1,246 lines), and the same component list is re-maintained in
`NavMenu.razor`, `Index.razor`, `COMPONENTS_MATURITY.md` lookups, and
`Services/Search/ShowcasePageRegistry.cs`.

Two facts verified in code constrain the design:

1. **DocFX snippet markers must survive.** Documentation references snippet regions that live
   inside the razor pages. The at-risk subset is **115 `?name=…` references into the 19 thinned
   `Pages/.../Documentation/*.razor` files**, held in each page's non-rendered
   `@if (false) { <!-- <Name> --> … }` block; thinned pages must keep that block verbatim. (A
   raw repo-wide grep returns 180 refs / 52 docs — the extra 65 target bespoke
   `UsesLayout = false` pages and the out-of-app `template.axolibrary`, none of which are
   thinned, so they are not at risk.)
2. **No shared .NET base for `Sequencer`/`Steps`.** The per-component twin members implement
   `ITwinObject` and expose `.Sequencer` (`AXOpen.Core.AxoSequencer`) and `.Steps`
   (`IEnumerable<AXOpen.Core.AxoStep>`) by ST convention, with no common interface. A single
   "resolve to twin" delegate would force reflection to reach those members.

## Goals / Non-Goals

**Goals:**
- One descriptor model + `ShowcaseCatalog` as the single source of truth for showcase pages.
- One reusable `ShowcasePageLayout` (with SRP sub-components) that reproduces today's page
  behavior from a descriptor.
- Generate navigation and the index matrix, and source search, from the catalog.
- Preserve DocFX snippet references and existing search behavior.
- SOLID, reusable structure; pilot-first to lock the template API.
- A coherent, compelling look built on Operon's Momentum tokens/components — dark mode, brand
  font, per-vendor accents, micro-motion, and a live sequence timeline.

**Non-Goals:**
- No changes to PLC `.st` (including `ShowcaseContext.st`).
- No change to the single-context architecture or binding root `Entry.Plc.Ctx`.
- No rework of bespoke Core/Data/Security/VisualComposer pages' internals — they keep their own
  markup (catalog entries with `UsesLayout = false` for nav/search/index only).
- No new test project; validation is a DEBUG startup guard.

## Decisions

**New descriptor model, not an extension of `SearchablePageEntry`.** The user chose a fresh
model that supersedes `ShowcasePageRegistry`. `SearchablePageEntry` is kept solely as the search
projection type. *Alternative considered:* extend the existing registry (more DRY) — rejected by
the user in favor of a clean model; the projection keeps search code stable regardless.

**Three compile-safe delegates over `ShowcaseContext`** (`Twin`, `Sequencer`, `Steps`) per
component, instead of one `Bind`-to-twin delegate plus reflection. This keeps the live binding
strongly typed. *Alternative considered:* string `ContextPath` + reflection (pure-data,
serializable) — rejected to avoid runtime fragility reaching `Sequencer`/`Steps`.

**Thinned page = `@page` + `@using` + `<ShowcasePageLayout/>` + preserved `@if (false)`
markers** (~20–30 lines, not ~10). The marker block is non-negotiable because of the 115 doc
references. The retained `@using` set must cover everything the marker block references — some
blocks (Elements, Pneumatics, Keyence) use typed `<Axo…View>` fixtures, not just RCC — so
thinning is not a blind strip. *Alternative considered:* moving snippets to standalone partials
— larger, riskier change deferred.

**Validation as a `#if DEBUG` startup guard**, not an xUnit project. No test project exists in
the app; a guard gives fast feedback without new build weight. *Alternative considered:* a unit
test — heavier for a single invariant. *Refined during implementation:* structural problems
(empty/duplicate route, empty title, layout page with no source paths) throw; unresolved maturity
keys only warn, because `COMPONENTS_MATURITY.md` intentionally does not track every component
variant (the guard caught one such pre-existing gap — `Cognex VisionPro Net`).

**Pilot-first within one change.** Build the model + catalog (Cognex only) + layout + sub-tabs,
migrate `CognexVision` (6 components, a custom `.NET connection` tab, a VisionProNet intro and
extra region) end-to-end, then sanity-check one simple page (Dukane) before mass rollout. Locks
the delegate/escape-hatch API before touching 20+ pages.

**Sub-component decomposition (SRP):** `ShowcaseHeader`, `ShowcaseSidebar`,
`AutomaticRenderingTab`, `CodeReferenceTab` (wraps the `if/loading/else` ladder once),
`HardwareConfigTab`, `ExampleSequenceTab`. Each slice of the scaffold exists exactly once.

**Live rendering is uniformly `RenderableContentControl` + presentation selector.** Verified in
code: dedicated typed views (`<AxoDiView>`, `<AxoDoView>`, `<AxoCylinderView>`, …) appear *only*
inside pages' `@if (false)` marker blocks as DocFX snippet fixtures — they are never rendered
live; every live component tab uses RCC + the presentation `<select>`. So `AutomaticRenderingTab`
suffices for every component and **no live dedicated-view escape hatch is needed**. The only
consequence is the thinning caveat above (preserve the fixtures' `@using`s).

## Visual language (look & feel)

The app already ships Operon's **Momentum** design system — semantic color tokens, per-component
radii, a full `[data-theme=dark]` theme, and `.btn`/`.card`/`.nav` component classes — but the
showcase surfaces bypass it with a hardcoded `slate`/`cyan`/`emerald` palette and inline styles.
`NavMenu` is the reference for correct token usage; every other surface is re-based onto it. The
visual work is therefore mostly *adopting what exists*, plus a polish layer. It stays token- and
component-driven (one source of truth, SOLID/DRY) — no per-page bespoke CSS.

**Baseline (always applied):**
- **Token re-base.** Every surface uses Momentum tokens (`text-text`, `bg-background`,
  `border-border`, `text-primary`, and the semantic `success`/`warning`/`danger`/`info` +
  result/station colors) instead of raw Tailwind palette; inline `style=` shells become
  utilities. Dark mode then works for free.
- **Operon component adoption.** Maturity/status → Operon `.badge`; live-demo notes → `.alert`;
  snippet loading → Operon spinner; cards → `.card` + `--radius-card`. Keep `Tab`, `Toast`,
  `HeroIcon`, modal.

**Compelling layer:**
- **Dark-mode toggle.** A header switch sets `data-theme` on `<html>` and persists in
  `localStorage` (read on load via a tiny interop); Momentum's dark tokens already cover it.
- **Brand font + micro-motion.** Load Familjen Grotesk (already named in `--font-sans`, just not
  fetched) + a code mono for snippets; add hover-lift (`--btn-hover-translate`), tab cross-fade,
  and an active-step pulse using the existing `ripple`/`wiggle` keyframes. Gate motion on
  `prefers-reduced-motion`.
- **Per-vendor accent.** Descriptors gain `AccentColor` (a CSS color) and optional `BrandIcon`
  (HeroIcon name or logo asset). The layout sets `--accent`/`--accent-soft` on the page root; the
  hero gradient, maturity badge tint, and nav dot read `var(--accent)` — branded but consistent.
  No per-vendor stylesheet; absent → falls back to `--color-primary`.
- **Live running-sequence timeline.** `AxoStepCard`/`ExampleSequenceTab` become a vertical
  timeline: a connector line, active step glows/pulses (`--color-result-running`), done steps
  check (`--color-result-passed`), idle/disabled muted, with order badges — so a running PLC reads
  at a glance. Keeps the per-step code block + live fields.
- **Branded Index + shell.** `Index` becomes a hero (primary-gradient) + category matrix with
  vendor glyphs and maturity at a glance; `TopRow`/`MainLayout` move onto tokens.

**Descriptor additions:** `ShowcasePageDescriptor.AccentColor` (string, optional) and `BrandIcon`
(string, optional) — pure presentation data, no effect on binding or search.

**Visual risks:** accent-gradient contrast in dark mode (mitigate with `color-mix` toward
background, as Momentum already does); font-load flash (preload + `font-display:swap`); motion
overuse (gate on `prefers-reduced-motion`).

## Risks / Trade-offs

- **DocFX doc breakage (115 refs / 19 files)** → preserve every `@if (false)` marker block
  verbatim; after migration, confirm every `?name=` reference still maps to a present region.
- **Per-page divergence** (Festo bespoke tab, Cognex `.NET` tab, 0-component Robotics) →
  `CustomTab` + `Intro` + `RootBind` escape hatches; optional sections in the layout.
- **Twin-resolution seam** → three typed delegates over `ShowcaseContext`; no reflection. Cost:
  catalog code references the generated twin type (acceptable; it is the app's own type).
- **Large diff / regressions** → pilot-first locks the API; migrate one page at a time with a
  per-page visual/behavioral parity check.
- **Search/nav drift mid-migration** → keep the `SearchablePageEntry` projection so search
  internals are stable while the source swaps underneath; delete `ShowcasePageRegistry` last.

## Migration Plan

1. **Pilot — Cognex.** Model + `ShowcaseCatalog` (Cognex descriptor) + `ShowcasePageLayout` +
   sub-tabs; migrate `CognexVision.razor` end-to-end keeping its marker block; lock the seam;
   verify parity; sanity-check Dukane (1 component).
2. **Roll out** remaining scaffold pages, including divergent ones via escape hatches.
3. **Generate** `NavMenu` + `Index` matrix from the catalog; fold in maturity keys.
4. **Migrate** `ShowcaseSearchService` + `ContentIndexService` to the catalog projection;
   delete `ShowcasePageRegistry.cs`.
5. **Guard** — add `ShowcaseCatalog.Validate()` under `#if DEBUG` in `Program.cs`.

Rollback: the change is additive until step 4; reverting the page edits and restoring
`ShowcasePageRegistry` returns to the prior state.

## Resolved Questions

Resolved by code inspection during exploration:

- **Twin root type for the delegates** → the generated **global-namespace `ShowcaseContext`**
  (the "Onliners" twin at `ix/.g/Onliners/ShowcaseContext.g.cs`, `: AXOpen.Core.AxoContext`). It
  is generated and git-ignored, available at compile time via the `ix` project reference, so the
  catalog references `ShowcaseContext` bare (no `using`). Per-page members are concrete twins
  (e.g. `cognex_vision_documentation : AXOpen.Components.Cognex.Vision.CognexVision`). The three
  delegates are `Func<ShowcaseContext, ITwinObject>`, `Func<ShowcaseContext, AxoSequencer>`, and
  `Func<ShowcaseContext, IEnumerable<AxoStep>>`.
- **Page count** → **28** `*/Documentation/*.razor` scaffold pages exist (not ~25): **19 carry
  DocFX markers** (preserve verbatim) and **9 carry none** (Abstractions, ComponentsAbstractions,
  Robotics, Inspectors, Io, Probers, Simatic1500, Timers, Utils — thin freely). All 28 migrate to
  the layout.
- **Core/Data pages** → they keep their own markup (`UsesLayout = false`) and their own DocFX
  marker blocks are never thinned, so they are safe to add to the catalog now for unified
  nav/index/search. Included in this change as `UsesLayout = false` entries.
