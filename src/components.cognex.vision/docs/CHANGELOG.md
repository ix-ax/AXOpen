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

### 0.57.0

**New features:**
- Added `AxoVisionProNet.md` documenting the TCP/.NET VisionPro variant (`AxoVisionProNet`): CONTROLLER tab (declaration, init, usage, manual control, commissioning, error recovery), .NET TWIN tab (`InitializeVisionClientAsync` TCP wiring), BLAZOR tab (dedicated `AxoVisionProNetView` + RCC presentations).

**Other:**
- Linked `AxoVisionProNet.md` from `toc.yml` and referenced both VisionPro variants from `README.md`.

### 0.43.0

**Other:**
- Renamed component docs to class-name convention: `AxoDataman.md`, `AxoInsight_v_6_0_0.md`, `AxoInsight_v_24_0_0.md`, `AxoVisionPro.md`.
- Merged `AxoDataman_Secondary` into `AxoDataman.md` as additional scenario.
- Added .NET TWIN, BLAZOR, HARDWARE tabs with source links and DocFX directives.
- Removed obsolete `ComponentTemplate.md`.
- Rewired `[!code-pascal[]]` references to renamed showcase files (`AxoDataman.st`, `AxoDataman_Secondary.st`, `AxoInsight_v_6_0_0.st`, `AxoInsight_v_24_0_0.st`, `AxoVisionPro.st`) and corrected namespace to `AXOpen.Components.Cognex.Vision`. Updated source link branch to `troublesense-integration`.
