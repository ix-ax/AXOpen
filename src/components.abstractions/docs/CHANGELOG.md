# Changelog

### 0.43.0

**Other:**
- Initial CHANGELOG entry; documentation wired into central DocFX navigation.
- Added per-type documentation pages for every public interface (`IAxoDrive`, `IAxo_Power`, `IAxoAxisReference`, `IAxoRobotics`, `IAxoCodeReader`, `IAxoVisionSensor`), shared data type (`AxoComponent_Status`, `AxoRoboticsCoordinates`, `AxoRoboticsBasicCoordinates`, `AxoRoboticsMovementsParams`) and enumeration (`eAxoDriveDirection`, `eAxoExecutionMode`, `eAxoSource`, `eAxoRoboticsStopType`, `eAxoRoboticsDistance`).
- Rewrote `README.md` with contract inventory tables and expanded `TROUBLES.md` with contract-focused guidance (abstractions library has no runtime behaviour of its own).
- Updated `toc.yml` to group entries by Interfaces / Data types / Enumerations.
