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
- Initial CHANGELOG entry; documentation wired into central DocFX navigation.
- Added per-type documentation pages for every public interface (`IAxoDrive`, `IAxo_Power`, `IAxoAxisReference`, `IAxoRobotics`, `IAxoCodeReader`, `IAxoVisionSensor`), shared data type (`AxoComponent_Status`, `AxoRoboticsCoordinates`, `AxoRoboticsBasicCoordinates`, `AxoRoboticsMovementsParams`) and enumeration (`eAxoDriveDirection`, `eAxoExecutionMode`, `eAxoSource`, `eAxoRoboticsStopType`, `eAxoRoboticsDistance`).
- Rewrote `README.md` with contract inventory tables and expanded `TROUBLES.md` with contract-focused guidance (abstractions library has no runtime behaviour of its own).
- Updated `toc.yml` to group entries by Interfaces / Data types / Enumerations.
