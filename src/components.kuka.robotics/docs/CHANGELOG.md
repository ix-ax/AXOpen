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

### 0.51.0

**New features:**
- Added **KUKA KRC5** controller support: the library now ships the KRC5
  GSDML (`ctrl/assets/kuka_krc5/GSDML-V2.4-KUKA-KR C5-20220704.xml`) and
  the matching PROFINET device template (`ctrl/assets/kuka_krc5/kuka_krc5_dio512.hwl.yml`).
  The existing `AxoKrc4` class drives both KRC4 and KRC5 — the DIO512 slot
  layout is identical between the two controllers.

**Other:**
- `README.md` — Hardware-assets table extended with KRC5 rows; description
  updated to call out support for both KRC4 and KRC5 controllers.
- `AxoKrc4_v_5_x_x.md` — subtitle and intro updated to cover KRC4/KRC5;
  HARDWARE tab split into per-controller asset sections; new "KRC5 example"
  code-reference block pointing at the `AxoKrc4_v_5_x_x_Krc5Showcase.st`
  showcase file; added KRC5 device instantiation + IO system wiring
  `[!code-yaml[]]` blocks.
- Showcase: added `AxoKrc4_v_5_x_x_Krc5Showcase.st` (third instance, driven
  by `kuka_rb2_HwID`); wired into the `KukaRobotics` documentation context;
  added an "AxoKrc4 on KRC5" tab to the Blazor page with live rendering,
  code reference, hardware configuration, and sequencer views; added KRC5
  search-registry entries.

### 0.52.0

**New features:**
- Split documentation into per-class doc files following the current
  `{ComponentName}.md` naming convention: `AxoKrc4.md` (primary reference
  with full Capabilities / Configuration / HARDWARE prose) and a thinner
  `AxoKrc5.md` that cross-links to `AxoKrc4.md` for shared API material
  and only adds KRC5-specific bits (showcase reference, hwc template, vendor
  GSDML link).

**Other:**
- `README.md` — Components table now lists both `AxoKrc4` and `AxoKrc5`
  as sibling proxies; the "single proxy drives both" wording was replaced
  with an accurate "two sibling classes with identical public API"
  description. Configuration & state types table generalised to
  `AxoKrc{4,5}_*` to reflect that each class ships its own supporting types.
- `TROUBLES.md` — Header, runtime-safety section, and Known-limitations
  generalised from "`AxoKrc4`" alone to "`AxoKrc4` / `AxoKrc5`".
- `toc.yml` — Components subtree replaced legacy `AxoKrc4_v_5_x_x` entry
  with separate `AxoKrc4` and `AxoKrc5` entries.
- Repointed `[!code-smalltalk[]]` references from the non-existent
  `AxoKukaRobotics_Datatypes_v_5_x_x/AxoKukaRobotics_Config.st` path to the
  actual per-class paths under
  `ctrl/src/AxoKrc{4,5}/v_5_x_x/TypesStructuresAndEnums/`.
- Removed broken references to `AxoKrc4_v_5_x_x_Showcase2.st` and
  `AxoKrc4_v_5_x_x_Krc5Showcase.st` (renamed/removed since 0.51.0). New
  per-class docs reference the current `AxoKrc4_v_5_x_x_Showcase.st` and
  `AxoKrc5_v_5_x_x_Showcase.st` files.
- Legacy combined `AxoKrc4_v_5_x_x.md` removed (content migrated into
  `AxoKrc4.md`).

**New regions:**
- `AxoKrc4_Config.st` — `<AxoKrc4ConfigDeclaration>`.
- `AxoKrc4_HWIDs.st` — `<AxoKrc4HWIDsDeclaration>`.
- `AxoKrc5_Config.st` — `<AxoKrc5ConfigDeclaration>` (in addition to the
  existing `<AxoKukaRoboticsConfigDeclaration>` region, whose dangling close
  tag was also corrected).
- `AxoKrc5_HWIDs.st` — `<AxoKrc5HWIDsDeclaration>` (in addition to the
  existing `<AxoKukaRoboticsHWIDsDeclaration>` region).
