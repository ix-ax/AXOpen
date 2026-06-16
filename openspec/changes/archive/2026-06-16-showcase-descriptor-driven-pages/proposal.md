## Why

The showcase Blazor app re-lists the same ~48 AXOpen components by hand across five drifting
surfaces — 28 `*/Documentation/*.razor` pages (a copy-pasted scaffold; Cognex alone is 1,246
lines), `NavMenu.razor`, `Index.razor`, `COMPONENTS_MATURITY.md` lookups, and
`ShowcasePageRegistry.cs`. Adding or changing a component means editing several places that
silently fall out of sync. A single descriptor model that every surface derives from collapses
the duplication and makes the showcase consistent and cheap to extend.

## What Changes

- Introduce a **new descriptor model** (`ShowcasePageDescriptor`, `ComponentShowcase`,
  `HardwareRef`, `CustomTab`) and a static **`ShowcaseCatalog`** that is the single source of
  truth for showcase pages.
- Add one reusable **`ShowcasePageLayout`** (plus SRP sub-components) that renders any
  descriptor into the existing page scaffold — live demo, code-reference, hardware, and
  example-sequence tabs — replacing the per-page boilerplate.
- Thin every `*/Documentation/*.razor` scaffold page to `@page` + `<ShowcasePageLayout/>` +
  its **preserved `@if (false)` DocFX marker block** (115 doc references across 19 pages must
  keep resolving).
- Generate `NavMenu` and the `Index` matrix from the catalog; fold maturity lookups into the
  descriptor (`MaturityKey`).
- Repoint `ShowcaseSearchService` and `ContentIndexService` to the catalog and **remove**
  `ShowcasePageRegistry.cs` (its `SearchablePageEntry` type is retained as the search
  projection). **BREAKING** for any code referencing `ShowcasePageRegistry.GetAllPages()`
  (internal to this app only).
- Add a `#if DEBUG` startup validation guard asserting descriptor coverage and maturity-key
  resolution.
- PLC `ShowcaseContext` and all `.st` files are **untouched**; live binding goes through the
  existing single `Entry.Plc.Ctx` via three compile-safe delegates.
- Restyle every showcase surface onto Operon's **Momentum** design tokens and component classes
  (badges, alerts, spinners, cards), replacing the hardcoded `slate`/`cyan`/`emerald` palette and
  inline styles so the app matches the design system and gains dark mode.
- Add a **dark-mode toggle** (Momentum's dark theme already exists), load the **brand font**
  (Familjen Grotesk) + a code mono, and apply subtle motion using the keyframes already in the
  tokens.
- Give each descriptor a **per-vendor accent** (`AccentColor` + optional `BrandIcon`) that drives
  branded page heroes, badges, and navigation accents.
- Redesign the example-sequence view into a **live running-sequence timeline** (active-step glow,
  done/idle states via result tokens) and rework `Index` into a branded landing hero + category
  matrix.

## Capabilities

### New Capabilities
- `showcase-catalog`: the descriptor model and `ShowcaseCatalog` single-source-of-truth —
  page/component descriptors, maturity binding, the `SearchablePageEntry` projection, and the
  debug validation guard.
- `showcase-page-rendering`: the `ShowcasePageLayout` that renders a descriptor into the
  standard live documentation scaffold — snippet loading, typed twin/sequencer/steps binding,
  custom tabs / intro / root-bind escape hatches, and verbatim DocFX marker preservation on
  thinned pages.
- `showcase-discoverability`: navigation, the Index overview matrix, and search/content-index
  all derived from the catalog instead of hand-maintained lists.
- `showcase-visual-design`: a coherent look built on Operon's Momentum tokens and components —
  dark-mode toggle, brand font + micro-motion, per-vendor accents, and a live running-sequence
  timeline — replacing the hardcoded palette and inline styles.

### Modified Capabilities
<!-- None: no existing specs in openspec/specs/. -->

## Impact

- **Scope:** `src/showcase/app/ix-blazor/showcase.blazor` only.
- **Create:** `Models/Showcase/*`, `Catalog/ShowcaseCatalog.cs`, `Shared/Showcase/ShowcasePageLayout.razor` + sub-components.
- **Modify:** 28 `*/Documentation/*.razor` pages, `Shared/NavMenu.razor`, `Pages/Index.razor`,
  `Services/Search/ShowcaseSearchService.cs`, `Services/Search/ContentIndexService.cs`,
  `Program.cs`.
- **Delete:** `Services/Search/ShowcasePageRegistry.cs` (keep `SearchablePageEntry`).
- **Reuse (unchanged):** `CodeSnippetProvider`, `ComponentMaturityService`, and the
  `Shared/Showcase/*` UI kit.
- **External contract:** DocFX docs reference 115 snippet regions inside the 19 thinned razor
  pages — these marker blocks must survive the thinning or published documentation breaks. (A
  raw repo-wide grep shows 180 `?name=` refs / 52 docs; the other 65 target bespoke
  `UsesLayout=false` pages and out-of-app templates, which are not thinned.)
- **Restyle (visual):** `_Host.cshtml` (brand font + code mono + theme bootstrap),
  `Shared/TopRow.razor`, `Shared/MainLayout.razor`, `Shared/Showcase/MaturityBadge.razor`,
  `Shared/Showcase/AxoStepCard.razor` (→ live timeline), `wwwroot/css/*` (token-based custom CSS),
  plus a small theme-toggle JS interop; descriptors gain `AccentColor`/`BrandIcon`.
- **Untouched:** all PLC `.st`, including `src/showcase/app/src/ShowcaseContext.st`.
