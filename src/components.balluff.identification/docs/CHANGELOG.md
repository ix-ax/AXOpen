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
- Renamed component doc from `Axo_BIS_M_4XX_045_Showcase.md` to `Axo_BIS_M_4XX_045.md` (class-name convention).
- Merged `Showcase2` scenario into the main doc as "Additional scenario".
- Added .NET TWIN, BLAZOR tabs with source links and DocFX `[!code-html[]]` references to live showcase markers.
- Removed obsolete `ComponentTemplate.md` placeholder.
- Retargeted all showcase `[!code-pascal[]]` references to the renamed files `Axo_BIS_M_4XX_045.st` (sequencer-driven main example) and `Axo_BIS_M_4XX_045_ManualControl.st` (HMI-driven scenario).
- Updated Source links to track the current working branch (`troublesense-integration`).
