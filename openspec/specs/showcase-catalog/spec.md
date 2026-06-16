# showcase-catalog Specification

## Purpose

Define a single, hand-maintained catalog of showcase documentation pages as the only source of truth for navigation, index, search, and rendering. The catalog's descriptor model captures each page's presentation, binding, and visual data, projects searchable entries, sources maturity from one place, and is guarded by debug-time validation.

## Requirements

### Requirement: Single source of truth catalog

The system SHALL provide a static `ShowcaseCatalog` that is the only hand-maintained list of
showcase documentation pages. Every showcase documentation page SHALL be represented by exactly
one `ShowcasePageDescriptor` in the catalog, and no other surface (navigation, index, search,
rendering) SHALL maintain its own parallel list of pages.

#### Scenario: Every page has exactly one descriptor

- **WHEN** the catalog is enumerated
- **THEN** each routable showcase documentation page maps to exactly one descriptor, and no
  descriptor maps to a missing route

#### Scenario: Adding a page touches only the catalog

- **WHEN** a new showcase page is introduced
- **THEN** adding its descriptor to the catalog is sufficient for navigation, index, and search
  to include it, with no edits to `NavMenu.razor`, `Index.razor`, or any search service list

### Requirement: Descriptor model captures presentation and binding data

A `ShowcasePageDescriptor` SHALL carry the page's `Route`, `Title`, `LibraryNamespace`,
`Category`, optional `Vendor`/`VendorUrl`, `Icon`, `Description`, `Tags`, `SourceFilePaths`,
navigation metadata (`NavGroup`, `NavOrder`, `ShowInNav`), library and hardware references, and
its list of `ComponentShowcase` entries. Each `ComponentShowcase` SHALL carry a `DisplayName`,
a `MaturityKey`, the `(Path, Region)` pairs for its declaration/initialization/extra snippets,
its `HardwareRef` list, and three compile-safe delegates that resolve the live twin object, its
`AxoSequencer`, and its `AxoStep` collection from the single `ShowcaseContext`.

#### Scenario: Component descriptor resolves live PLC objects

- **WHEN** the layout is given a `ComponentShowcase` and the application's `Entry.Plc.Ctx`
- **THEN** the component's delegates return the live twin, sequencer, and steps without
  reflection over the context graph

#### Scenario: Descriptor exposes everything a page needs

- **WHEN** a descriptor is constructed for a page
- **THEN** it contains all data previously hardcoded in that page's markup (paths, links,
  component list, maturity keys), so the page body carries no per-component bookkeeping

### Requirement: Descriptor carries visual-presentation data

A `ShowcasePageDescriptor` SHALL support an optional `AccentColor` (a CSS color) and an optional
`BrandIcon` (a HeroIcon name or logo asset path) as pure presentation data. When present they SHALL
drive the page's branded accent (hero, badge tint, navigation accent); when absent the rendering
SHALL fall back to the Momentum `--color-primary` default. These fields SHALL NOT affect binding or
search behavior.

#### Scenario: Vendor accent applied from the descriptor

- **WHEN** a descriptor sets `AccentColor`
- **THEN** that page's hero, maturity badge tint, and navigation accent use it, while a descriptor
  without `AccentColor` renders with the default primary accent

### Requirement: Search projection from the catalog

The catalog SHALL expose a projection from each `ShowcasePageDescriptor` to a
`SearchablePageEntry` so that search and content-index consume the catalog directly. The
removed `ShowcasePageRegistry` static list SHALL NOT be reintroduced as a parallel source.

#### Scenario: Projection feeds search

- **WHEN** a search or content-index service requests the set of searchable pages
- **THEN** it receives entries projected from the catalog, covering the same routes and source
  file paths as before the migration

### Requirement: Maturity sourced from a single place

Component maturity SHALL be sourced only from `COMPONENTS_MATURITY.md` via
`ComponentMaturityService`, keyed by each `ComponentShowcase.MaturityKey`. Pages SHALL NOT
contain hardcoded maturity component-name strings.

#### Scenario: Maturity key drives the badge

- **WHEN** a component is rendered with a `MaturityKey`
- **THEN** its maturity badge reflects the entry parsed from `COMPONENTS_MATURITY.md` for that
  key

### Requirement: Debug-time catalog validation guard

In `DEBUG` builds the application SHALL validate the catalog at startup. Structural problems — a
descriptor with an empty `Route` or `Title`, a duplicate `Route`, or a layout-using descriptor with
no `SourceFilePaths` — SHALL throw at startup with a message identifying the offending descriptor.
Unresolved `ComponentShowcase.MaturityKey` values (keys absent from `COMPONENTS_MATURITY.md`) SHALL
be reported as startup warnings rather than fatal errors, because the maturity matrix does not track
every component variant and the badge falls back to the lowest level.

#### Scenario: Structural error fails fast in development

- **WHEN** a descriptor is missing a required field, duplicates a route, or uses the layout with no source paths
- **AND** the application starts in a `DEBUG` build
- **THEN** startup throws with a message identifying the offending descriptor

#### Scenario: Unresolved maturity key warns but does not block startup

- **WHEN** a component references a `MaturityKey` not present in `COMPONENTS_MATURITY.md`
- **AND** the application starts in a `DEBUG` build
- **THEN** a warning is logged naming the descriptor and key, and startup proceeds

#### Scenario: Release builds skip the guard

- **WHEN** the application runs a non-`DEBUG` build
- **THEN** the validation guard is not executed
