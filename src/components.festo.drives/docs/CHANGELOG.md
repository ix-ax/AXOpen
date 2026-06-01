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

### 0.61.1

**Bug fixes:**
- Fixed `AxoCmmtAs` losing axis position while in torque control (issue #1152). A positioning move no longer completes on the `Telegram111_In.ZSW1.targetPosReached` bit alone — it now additionally requires the actual position to be within the `InPositionWindow` tolerance (`ABS(Position - ActualPosition) <= Config.InPositionWindow`) before advancing past the target-reached step.
- Removed an unstable torque-control guard that spuriously raised programming error `1542` when `targetPosReached` was asserted during torque-control states. The check is disabled pending further investigation.

**Other:**
- Annotated the `PROFIdriveTelegram_111_ZSW1` status signals with their hardware bit positions (X0–X15) in the attribute labels, and added matching bit-position comments to the ZSW1 mapping in `AxoCmmtAs`, clarifying which telegram bit drives each status signal.
- Documented the `InPositionWindow` positioning-tolerance parameter (provided by `AxoDrive_Config`) consumed by `AxoCmmtAs` move completion.

### 0.43.0

**Other:**
- Restructured documentation: renamed `AxoCmmtAs_Showcase.md`/`AxoCmmtAs_Showcase2.md` to a single `AxoCmmtAs.md` (class-name convention); removed `ComponentTemplate.md`.
- Added CONTROLLER, .NET TWIN, BLAZOR, and HARDWARE tabs with DocFX `[!code-pascal[]]`/`[!code-html[]]`/`[!code-yaml[]]` references to live showcase markers.
- Initial CHANGELOG entry.
