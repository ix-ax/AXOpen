## ADDED Requirements

### Requirement: Reusable layout renders any descriptor

The system SHALL provide a single `ShowcasePageLayout` component that renders a
`ShowcasePageDescriptor` into the established documentation scaffold — breadcrumb, gradient
header, three-column sidebar/main split, "Live Demo Controls", presentation selector, and the
per-component tab set — reproducing the prior pages' visual structure and behavior. Per-page
scaffold markup SHALL NOT be duplicated across pages.

#### Scenario: Migrated page matches the original

- **WHEN** a previously hand-written documentation page is replaced by
  `<ShowcasePageLayout Descriptor="..."/>`
- **THEN** the rendered page presents the same sections, tabs, and controls as before for the
  same descriptor data

### Requirement: Generic snippet loading

The layout SHALL load each component's declaration, initialization, and extra Structured Text
regions, and each hardware reference region, through the existing `CodeSnippetProvider`, and
SHALL present loading and error states. Pages SHALL NOT contain per-component snippet-loading
code.

#### Scenario: Snippets load for all components

- **WHEN** the layout initializes for a descriptor with N components
- **THEN** it requests every declared snippet region via `CodeSnippetProvider` and renders each
  in a code block, showing a loading indicator until ready and an error state if a region is
  missing

### Requirement: Typed twin binding without reflection

The layout SHALL bind `RenderableContentControl` and all polling through each component's typed
delegates over the single `ShowcaseContext`. The layout SHALL NOT use reflection to reach a
component's `Sequencer` or `Steps`.

#### Scenario: Live demo binds through delegates

- **WHEN** a component tab renders its automatic-rendering view
- **THEN** the control is bound to the twin returned by the component's `Twin` delegate, and
  polling uses the `Sequencer` and `Steps` delegates

### Requirement: Escape hatches for divergent pages

The layout SHALL support pages that diverge from the common shape: a descriptor with zero
components SHALL render and poll its context node via a `RootBind` delegate; components MAY
declare additional `CustomTab`s; and a descriptor or component MAY supply an `Intro` fragment.

#### Scenario: Zero-component utility page

- **WHEN** a descriptor has no components but defines `RootBind`
- **THEN** the layout renders the page without a per-component tab set and polls the bound
  context node

#### Scenario: Component with a custom tab

- **WHEN** a component declares a `CustomTab`
- **THEN** that tab appears alongside the standard tabs with its supplied content

### Requirement: DocFX marker preservation on thinned pages

When a documentation page is thinned to use the layout, its non-rendered `@if (false)` snippet
marker block SHALL be retained verbatim so that existing `?name=` references from documentation
continue to resolve.

#### Scenario: Doc references still resolve after thinning

- **WHEN** a page is migrated to the layout
- **THEN** every snippet region referenced by a `?name=` link from the docs is still present in
  the page's preserved marker block
