# Changelog

### 0.43.0

**Other:**
- Restructured documentation to class-name convention: added `AxoKrc4_v_5_x_x.md`; removed legacy `*_Showcase.md`, `*_Showcase2.md`, and `ComponentTemplate.md`.
- Added CONTROLLER, .NET TWIN, BLAZOR, and HARDWARE tabs with DocFX source references wired to live showcase markers.
- Initial CHANGELOG entry.

### 0.50.0

**Other:**
- `README.md` — added Components, Configuration/state types, Packages, Dependencies tables and the KUKA vendor link.
- `AxoKrc4_v_5_x_x.md` — added Capabilities and Configuration sections with a `Config` parameter table; wired `[!code-smalltalk[]]` references to new `AxoKukaRoboticsConfigDeclaration` / `AxoKukaRoboticsHWIDsDeclaration` regions in the library source; added an "Alternative example" block referencing `AxoKrc4_v_5_x_x_Showcase2.st`; expanded the HARDWARE tab with slot layout and `hwID` resolution flow.
- `TROUBLES.md` — added component-specific common-issues, runtime-safety, and error-ID reference sections covering IDs 700, 701, 702, 710, 720–726, 1130–1133, 1201, 1231, 20001–20005, and the 500-range task *potential* identifiers; retained the existing Support pointer.
- Repointed stale GitHub source links from branch `3-unify-showcase` to `dev`.

**New regions:**
- `AxoKukaRobotics_Config.st` — `<AxoKukaRoboticsConfigDeclaration>`.
- `AxoKukaRobotics_HWIDs.st` — `<AxoKukaRoboticsHWIDsDeclaration>`.

### 0.50.1

**Other:**
- `README.md` — added a "Hardware assets" table pointing at the
  library-shipped GSDML (`ctrl/assets/kuka_krc4/GSDML-V2.33-KUKA-KRC4-ProfiNet_5.0-20181102.xml`)
  and the PROFINET hw template (`ctrl/assets/kuka_krc4/kuka_krc4_dio512.hwl.yml`),
  plus a note that the showcase re-uses the same template.
- `AxoKrc4_v_5_x_x.md` — HARDWARE tab now opens with a "Library-shipped
  assets" section linking the GSDML and hw template on GitHub, so
  integrators see where the raw assets live inside this package.
