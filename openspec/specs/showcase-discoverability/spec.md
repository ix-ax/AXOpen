# showcase-discoverability Specification

## Purpose

Drive every discoverability surface — navigation, the index overview matrix, and search/content-index — from the showcase catalog so that adding or hiding a page is governed entirely by its descriptor, with no hand-maintained parallel lists.

## Requirements

### Requirement: Navigation generated from the catalog

`NavMenu` SHALL be generated from the catalog: entries filtered by `ShowInNav`, grouped by
`NavGroup`, and ordered by `NavOrder`, while retaining the static Home, Visual Composer, and
Security items and the existing `ExpandableMenuItem`/`MenuItem` presentation. The navigation
SHALL NOT be a hand-maintained list of page links.

#### Scenario: New descriptor appears in navigation

- **WHEN** a descriptor with `ShowInNav = true` is added to the catalog
- **THEN** it appears under its `NavGroup` in the menu at its `NavOrder` position without edits
  to `NavMenu.razor`

#### Scenario: Hidden pages are excluded

- **WHEN** a descriptor has `ShowInNav = false`
- **THEN** it does not appear in the navigation menu

### Requirement: Index overview matrix

`Index` SHALL render a grouped overview matrix of catalog pages, grouped by category, with a
maturity badge per entry and rows linking to each page `Route`. The previous hand-listed card
grid SHALL be removed.

#### Scenario: Index lists catalog pages with maturity

- **WHEN** the landing page renders
- **THEN** it shows the catalog pages grouped by category, each with its maturity badge and a
  working link to its route

### Requirement: Search and content-index sourced from the catalog

`ShowcaseSearchService` and `ContentIndexService` SHALL obtain their pages from the catalog
projection, and `ShowcasePageRegistry` SHALL be removed. Search behavior — metadata matching
and full-text content results — SHALL remain equivalent to before the migration.

#### Scenario: Search returns equivalent results

- **WHEN** a query is run after the migration
- **THEN** metadata and full-text results cover the same pages and source files as before, and
  no code references the removed `ShowcasePageRegistry`
