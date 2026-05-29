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

### 0.56.4

**Other:**
- Corrected the BLAZOR tab of `AxoCtrlxDriveXsc` and `AxoIndraDrive` docs to reflect the dedicated Blazor views (`AxoCtrlxDriveXscView`, `AxoIndraDriveView`) now resolved by `RenderableContentControl`, with source links.
- Enriched `README.md` with a Components table (ctrlX DRIVE XSC + IndraDrive), a Dependencies table, and the Bosch Rexroth vendor link.
- Populated `TROUBLES.md` with drive-specific common issues, the `eAxoDriveState` error states and `Errorstop` recovery, diagnostics, and known limitations.

### 0.43.0

**Other:**
- Restructured documentation to class-name convention; removed legacy `*_Showcase.md` and `ComponentTemplate.md` placeholders.
- Added CONTROLLER, .NET TWIN, BLAZOR, and HARDWARE tabs with DocFX source references wired to live showcase markers.
- Initial CHANGELOG entry.
