## 1. Descriptor model

- [x] 1.1 Create `Models/Showcase/HardwareRef.cs` (`Label`, `InstancePath`+`DeviceRegion`, `TemplatePath`+`TemplateRegion`, `IoSystemPath`+`IoSystemRegion`)
- [x] 1.2 Create `Models/Showcase/CustomTab.cs` (`Title`, `RenderFragment Content`; also `Snippet`/`Note` for snippet-based tabs)
- [x] 1.3 Create `Models/Showcase/ComponentShowcase.cs` (`DisplayName`, `MaturityKey`, declaration/init/extra `(Path,Region)` snippets, `List<HardwareRef>`, `List<CustomTab>`, optional `Intro`, and the three typed delegates `Twin`/`Sequencer`/`Steps` over `ShowcaseContext`)
- [x] 1.4 Create `Models/Showcase/ShowcasePageDescriptor.cs` (route/title/namespace/category/vendor/icon/description/tags/source-paths, nav metadata, library+hardware refs, `List<ComponentShowcase>`, `RootBind`, `Intro`, `UsesLayout`, optional `AccentColor`/`BrandIcon`) + `SnippetRef`/`SourceRef` support types
- [x] 1.5 Twin root type confirmed: global-namespace `ShowcaseContext` (Onliners twin, `ix/.g/Onliners/`, git-ignored, compile-time via the `ix` ref); delegates `Func<ShowcaseContext, ITwinObject>` / `Func<ShowcaseContext, AxoSequencer>` / `Func<ShowcaseContext, IEnumerable<AxoStep>>`

## 2. Catalog skeleton

- [x] 2.1 Create `Catalog/ShowcaseCatalog.cs` with `IReadOnlyList<ShowcasePageDescriptor> All` and named descriptor properties (Cognex only for now)
- [x] 2.2 Add `ToSearchableEntry(descriptor)` projection to `SearchablePageEntry`
- [x] 2.3 Add `Validate()` (route/title/source-paths non-empty; every `MaturityKey` resolves via `ComponentMaturityService`)

## 3. Layout + sub-components (pilot infra)

- [x] 3.1 Create `Shared/Showcase/ShowcaseHeader.razor` (breadcrumb + gradient header from descriptor)
- [x] 3.2 Create `Shared/Showcase/ShowcaseSidebar.razor` (Component Overview + Source References + `LibraryResources`)
- [x] 3.3 Create `Shared/Showcase/CodeReferenceTab.razor` wrapping the `if/loading/else` snippet ladder once (extracted to `SnippetView.razor`)
- [x] 3.4 Create `Shared/Showcase/AutomaticRenderingTab.razor` (`RenderableContentControl` via `Twin` delegate + presentation selector)
- [x] 3.5 Create `Shared/Showcase/HardwareConfigTab.razor` (device/template/io-system regions per `HardwareRef`)
- [x] 3.6 Create `Shared/Showcase/ExampleSequenceTab.razor` (`AxoTaskCommandView` + `AxoSequencerCommandView` + `AxoStepCard` loop)
- [x] 3.7 Create `Shared/Showcase/ShowcasePageLayout.razor` (`@inherits RenderableComponentBase`, `@inject CodeSnippetProvider`): assemble sub-components; generic `OnInitializedAsync` snippet load + step-dictionary build; generic `ConfigurePolling` over components / `RootBind`; handle `CustomTabs`, `Intro`, 0-component pages

## 4. Pilot migration — Cognex (verification gate)

- [x] 4.1 Author the full Cognex descriptor in the catalog (6 components, `.NET connection` `CustomTab`, VisionProNet `Intro` + `VisionProNetCommissioning` extra region, hardware refs)
- [x] 4.2 Thin `Pages/components-cognex-vision/Documentation/CognexVision.razor` to `@page` + `@using` + `<ShowcasePageLayout/>`, keeping its `@if (false)` DocFX marker block verbatim
- [x] 4.3 Build clean (0 errors); runtime click-through parity is a manual check (live demo, presentation selector, code refs, hardware tabs, example sequence + step cards, maturity badge, source modal, `.NET` tab)
- [x] 4.4 Sanity-check the common path: author Dukane descriptor (2 components; Twin path differs from Sequencer/Steps path — validates independent delegates) and thin its page
- [x] 4.5 Lock the delegate + escape-hatch API based on pilot results before mass rollout (delegates + SnippetView ladder + CustomTab/Intro/RootBind hatches validated by the Cognex build)

## 5. Roll out remaining scaffold pages

- [x] 5.1 Migrate the marker-bearing standard pages (vision, drives, elements, pneumatics, robotics vendors, identification, tightening, welders, press) — descriptor + thinned page, **retaining each `@if (false)` block verbatim including the `@using`s its typed-view fixtures need** (Elements/Pneumatics/Keyence use `<Axo…View>`, not just RCC), one at a time with a parity check
- [x] 5.2 Migrate divergent pages: Festo bespoke tab (`CustomTab`); 0-component Robotics (`RootBind`, no component tabs)
- [x] 5.3 Migrate the marker-free foundation scaffold pages (Abstractions, ComponentsAbstractions, Inspectors, Io, Probers, Simatic1500, Timers, Utils) — thin freely; no `@if (false)` block to preserve
- [x] 5.4 Add catalog entries (`UsesLayout = false`) for bespoke Core/Data/Security/VisualComposer pages so nav/search/index cover them without changing their markup

## 6. Discoverability

- [x] 6.1 Rewrite `Shared/NavMenu.razor` to generate from `ShowcaseCatalog.All` (filter `ShowInNav`, group by `NavGroup`, order by `NavOrder`); keep static Home / Visual Composer / Security and `ExpandableMenuItem`/`MenuItem`
- [x] 6.2 Rewrite `Pages/Index.razor` as a category-grouped matrix from the catalog with maturity badges and route links (remove the 8 hand cards)

## 7. Search/content migration

- [x] 7.1 Repoint `Services/Search/ShowcaseSearchService.cs` to `ShowcaseCatalog.All.Select(ToSearchableEntry)`
- [x] 7.2 Repoint `Services/Search/ContentIndexService.cs` to the catalog projection
- [x] 7.3 Delete `Services/Search/ShowcasePageRegistry.cs` (retain `SearchablePageEntry`); fix references

## 8. Guard

- [x] 8.1 Call `ShowcaseCatalog.Validate()` from `Program.cs` under `#if DEBUG` (added `HasMaturity` to the maturity service; guard caught a real drift — VisionProNet's `Cognex VisionPro Net` key had no row, now aligned to the library key)

## 9. Visual design (Momentum / Operon)

- [x] 9.1 Load brand assets in `_Host.cshtml`: Familjen Grotesk + JetBrains Mono (`display=swap`, preconnect); mono applied to `code/pre/kbd/.font-mono`
- [x] 9.2 Dark-mode toggle: switch in `TopRow.razor` via `themeInterop` (sets `data-theme` on `<html>` + `localStorage`); anti-FOUC bootstrap script in `<head>`
- [x] 9.3 Token re-base: `TopRow.razor`, `MaturityBadge.razor` (semantic dot tokens), `SourceFileLink.razor` (link tokens), and all new layout/sub-components built on Momentum tokens (MainLayout/NavMenu were already token-based; CodeBlock keeps its dark code surface)
- [x] 9.4 Per-vendor accent: layout sets `--accent` from `Descriptor.AccentColor`; hero gradient + brand glyph + Index card rail read `var(--accent)` with a `--color-primary` fallback
- [x] 9.5 Live sequence timeline: `AxoStepCard` redesigned (state rail, numbered badge, active glow/pulse via `--color-result-running`, disabled muted, order badges); keeps code block + live fields
- [x] 9.6 Branded `Index`: hero (primary gradient) + catalog-driven category matrix with vendor glyph/accent + component counts + "Explore by area" cards
- [x] 9.7 Micro-motion: `.hover-lift` (`--btn-hover-translate`) on cards + `.step-active-glow` pulse, both gated on `prefers-reduced-motion`
- [x] 9.8 Link the app's compiled Tailwind (`css/momentum.css`) in `_Host` and regenerate it (so token utilities resolve); the app previously relied only on package CSS

## 10. Verification

- [x] 10.1 `dotnet build` the `showcase.blazor` project clean — 0 errors (PLC unaffected)
- [x] 10.2 Run with `AXOPEN_USE_DUMMY_CONNECTOR=true`; click-through pilot + divergent pages (Robotics 0-component, Festo bespoke). Verified live via headless Edge + CDP: pilot (Cognex) DOM 51 KB, Drives 34 KB — Presentation select + Automatic-rendering/Code-reference tabs + Live Demo Controls all render over the circuit; Robotics (0-comp 57 KB) + Festo (bespoke 44 KB) render; server log clean. Surfaced + fixed two prerender-path bugs: (a) `ServerPrerendered` deadlocked any full AxoComponent render (sync PLC read during prerender) → set `App` render-mode to `Server` in `_Host.cshtml`; (b) `blazor.server.js` started the circuit before the inline interop script defined `registerSearchShortcut`, crashing the circuit (`SearchDialog.OnAfterRenderAsync`) → moved `blazor.server.js` to load last
- [x] 10.3 Confirm DocFX `?name=` references still map to marker regions present in thinned pages. At-risk subset = **115 refs / 19 thinned pages**; a raw repo-wide grep returns **180 refs / 52 docs** (the extra 65 are in bespoke `UsesLayout=false` pages — Core DocuExamples, Data Rendering/DistributedData — and out-of-app `template.axolibrary`, none thinned), so filter the grep to the 19 targets
- [x] 10.4 NavMenu generated from catalog + Index matrix + search/content-index all catalog-sourced and build-clean (runtime row-navigation / SearchDialog hits are part of the manual 10.2 click-through)
- [x] 10.5 Scaffold-page bodies dropped ~9,645 → 931 lines (28 pages); DocFX cross-check 115/115 regions resolve; DEBUG `Validate()` invariants verified (38 unique routes, all `UsesLayout` entries carry SourceFilePaths)
- [x] 10.6 Toggle dark mode across pilot + Index + a divergent page; confirm tokens (no raw palette) render both themes correctly, and `prefers-reduced-motion` disables motion. Verified via CDP on pilot: `data-theme` light→dark flips token `--color-primary` #0A319E → #89C4FF (theme-aware tokens, no raw palette); in-app toggle uses the same `themeInterop.set`/`data-theme` path. `prefers-reduced-motion` gating is static CSS (`_Host.cshtml` `.hover-lift`/`.step-active-glow` zeroed under the media query)
