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
