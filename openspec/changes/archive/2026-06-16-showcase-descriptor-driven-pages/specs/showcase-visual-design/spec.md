## ADDED Requirements

### Requirement: Momentum-token visual language

Every showcase surface (shell, navigation, index, page layout, sub-tabs, and the shared UI kit)
SHALL express color, radius, and typography through Operon's Momentum design tokens
(`text-text`, `bg-background`, `border-border`, `text-primary`, the semantic
`success`/`warning`/`danger`/`info`, and the result/station colors) and Tailwind utilities. Raw
Tailwind palette values (`slate-*`, `cyan-*`, `emerald-*`, `amber-*`) and inline `style=` layout
SHALL NOT be used for showcase surfaces, so a single theme change restyles the whole app.

#### Scenario: A surface renders from tokens, not hardcoded palette

- **WHEN** a showcase surface is rendered
- **THEN** its colors, radii, and type derive from Momentum tokens and Tailwind utilities, with no
  hardcoded `slate`/`cyan`/`emerald` palette classes or inline layout styles

### Requirement: Operon components for status and feedback

Status, feedback, and container patterns SHALL use Operon's Momentum component classes rather than
hand-rolled equivalents: maturity/status indicators use the Operon badge, live-demo callouts use
the Operon alert, snippet loading uses the Operon spinner, and panels use the Operon card. The
existing `Tab`, `Toast`, `HeroIcon`, and modal components SHALL be retained.

#### Scenario: Maturity renders as an Operon badge with semantic color

- **WHEN** a component's maturity is displayed
- **THEN** it renders via the Operon badge using the semantic `success`/`warning`/`danger` tokens,
  not bespoke colored-dot markup

### Requirement: Dark-mode toggle

The application SHALL provide a header control that switches the theme by setting `data-theme` on
the document root and persists the choice in `localStorage`, restoring it on load. Both light and
dark themes SHALL be legible because all showcase surfaces use Momentum tokens, which already
define a complete dark palette.

#### Scenario: Theme choice persists across reloads

- **WHEN** the user toggles dark mode and reloads the application
- **THEN** the previously selected theme is reapplied on load and every showcase surface renders
  correctly in that theme

### Requirement: Per-vendor accent from the descriptor

When a `ShowcasePageDescriptor` declares an `AccentColor`, the page layout SHALL expose it as a CSS
custom property on the page root and use it for the hero gradient, the maturity badge tint, and the
navigation accent. When `AccentColor` is absent, these SHALL fall back to the Momentum
`--color-primary` default. Accent styling SHALL be driven entirely by tokens/custom properties —
no per-vendor stylesheet.

#### Scenario: Accent applied, with default fallback

- **WHEN** a descriptor with an `AccentColor` is rendered
- **THEN** its hero, badge tint, and nav accent use that color
- **AND WHEN** a descriptor without an `AccentColor` is rendered
- **THEN** those elements use the default primary accent

### Requirement: Live running-sequence timeline

The example-sequence presentation SHALL render a step sequence as a vertical timeline with a
connector line and per-step state: the active step is emphasized (glow/pulse via
`--color-result-running`), completed steps are marked done (`--color-result-passed`), and
idle/disabled steps are muted, each showing its order. The per-step Structured Text code block and
the live step fields SHALL remain available.

#### Scenario: Active step is emphasized in the timeline

- **WHEN** a sequencer is running and a step is active
- **THEN** that step is visually emphasized in the timeline while completed steps show a done state
  and idle steps are muted, and each step still exposes its code block and live fields

### Requirement: Brand typography and motion

The application SHALL load the brand font named in the Momentum tokens (Familjen Grotesk) and a
monospace font for code, applied through the existing `--font-sans`/`--font-mono` tokens. Subtle
motion (hover lift, tab transition, active-step pulse) MAY be applied using the keyframes already
defined in the tokens, and all motion SHALL be disabled when the user requests
`prefers-reduced-motion`.

#### Scenario: Reduced motion is honored

- **WHEN** the user's system requests reduced motion
- **THEN** decorative motion is disabled while the interface remains fully functional and legible
