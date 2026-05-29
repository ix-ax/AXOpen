## Changes
<!--
    Leave this comment intact. Immediately below this comment add a new entry:
    ---------------------------------
    ### {axopen-version}

    **New features:**
    -

    **Bug fixes:**
    -

    **Other:**
    -

    **Breaking changes:**
    -
    ---------------------------------

    Replace {axopen-version} with the `next-version:` value from
    axopen/GitVersion.yml. New entries go at the TOP, immediately below
    this comment. The /axopen-docs skill resorts the file semver-descending
    on every run.
-->

### 0.43.0

**Other:**
- Renamed `AxoDriveExample_Showcase.md` → `AxoDrive.md` (class-name; documents the abstract base class).
- Merged `Showcase2` scenario as additional section.
- Added .NET TWIN, BLAZOR tabs with source links.
- Removed obsolete `ComponentTemplate.md`.
- Expanded `README.md` with package matrix, public-type surface (`AxoDrive`, `Axo_Power`, `AxoMotionJogTask`, `AxoAxisRef*`, `AxoDriveParameterChannelIDN`, `eAxoDriveState`, `eAxoMotionTaskId`) and dependencies.
- Rewrote `TROUBLES.md` with common issues, PLCopen state table derived from `eAxoDriveState`, diagnostics checklist, and known limitations.
