## Changes
<!--  
    Leave the file intact at the end of the file add the following:
    ---------------------------------
    ### {axopen-version}
    New features:
    Bug fixies:
    Other:
    Breaking:
    ---------------------------------

    {axopen-version} replace this with the current settings in GitVersion.yml file.
-->



### 0.43.0

**Other:**
- Renamed component doc from `Axo_BIS_M_4XX_045_Showcase.md` to `Axo_BIS_M_4XX_045.md` (class-name convention).
- Merged `Showcase2` scenario into the main doc as "Additional scenario".
- Added .NET TWIN, BLAZOR tabs with source links and DocFX `[!code-html[]]` references to live showcase markers.
- Removed obsolete `ComponentTemplate.md` placeholder.
- Retargeted all showcase `[!code-pascal[]]` references to the renamed files `Axo_BIS_M_4XX_045.st` (sequencer-driven main example) and `Axo_BIS_M_4XX_045_ManualControl.st` (HMI-driven scenario).
- Updated Source links to track the current working branch (`troublesense-integration`).
