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

**New features:**
- Added dedicated Blazor views `AxoCtrlxDriveXscView` and `AxoIndraDriveView` (with `Status`, `Command`, and `Spot` derivatives) for the Rexroth drive components.

**Bug fixes:**
- `AxoCtrlxDriveXsc`: reworked torque and velocity scaling calculations, switched torque/velocity parameters to degrees and adjusted scaling values, and fixed torque scaling for linear actuators.
- `AxoCtrlxDriveXsc`: retrigger scaling-parameter reading when leaving operation mode so scaling stays consistent.
- `AxoCtrlxDriveXsc`: added message-timer resets so diagnostic messages clear correctly.

**Other:**
- `AxoCtrlxDriveXsc`: filter the `C00E2054` ("NOT HOMED") diagnostic message while homing is in progress.
- `AxoCtrlxDriveXsc`: added a debug message for the unknown error code `F4035`.
- `AxoCtrlxDriveXsc`: removed the homing (`AxoHome`) task timeout.
- Added ctrlX DRIVE servo-drive communication-configuration reference images under `ctrl/assets/rexroth_ctrlx_drive/servodrive_communication_config/`.
- Added a step-by-step "Drive commissioning (ctrlX DRIVE Engineering)" section to `AxoCtrlxDriveXsc.md` (PROFINET/FSP profile, Consumer/Producer telegrams, signal control/status word mapping, operation-mode selection) with screenshots under `docs/pics/rexroth_ctrlx_drive/`.
- Corrected the BLAZOR tab of `AxoCtrlxDriveXsc` and `AxoIndraDrive` docs to reflect the dedicated Blazor views (`AxoCtrlxDriveXscView`, `AxoIndraDriveView`) now resolved by `RenderableContentControl`, with source links.
- Enriched `README.md` with a Components table (ctrlX DRIVE XSC + IndraDrive), a Dependencies table, and the Bosch Rexroth vendor link.
- Populated `TROUBLES.md` with drive-specific common issues, the `eAxoDriveState` error states and `Errorstop` recovery, diagnostics, and known limitations.

### 0.43.0

**Other:**
- Restructured documentation to class-name convention; removed legacy `*_Showcase.md` and `ComponentTemplate.md` placeholders.
- Added CONTROLLER, .NET TWIN, BLAZOR, and HARDWARE tabs with DocFX source references wired to live showcase markers.
- Initial CHANGELOG entry.
