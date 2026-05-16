# Keyence Vision

[!INCLUDE [General](../../../docfx/articles/notes/LIBRARYHEADER.md)]

## Description

`axopen.components.keyence.vision` provides AXOpen control components for
[Keyence](https://www.keyence.com/) industrial vision and code-reading
hardware over PROFINET. It encapsulates the cyclic I/O exchange,
trigger/result handshakes, and result-data parsing required to use these
devices from a SIMATIC AX application.

The package ships:

- A **PLC library** (`@inxton/axopen.components.keyence.vision`) — control
  components and data types.
- A **.NET twin** (`AXOpen.Components.Keyence.Vision`) — runtime mirror of
  the PLC types for orchestration and visualization. The `Axo_IV3` twin
  additionally exposes a reverse-proxy helper that surfaces the device's
  built-in HTTP live view inside the application's web UI.
- A **Blazor package** (`AXOpen.Components.Keyence.Vision.blazor`) — UI
  rendering. The components render via the generic `RenderableContentControl`
  pattern, with a dedicated `Axo_IV3View` available when richer visualization
  is required.

## Components

| Component | Device family | Purpose |
|-----------|---------------|---------|
| [`Axo_IV3`](Axo_IV3.md) | Keyence IV3 | Fixed vision sensor — pattern matching, presence/absence, with optional HTTP live view via the .NET twin's reverse-proxy helper. |
| [`Axo_SR_750`](Axo_SR_750.md) | Keyence SR-750 | Fixed barcode/2D-code reader — trigger/read cycles with result-data parsing. |
| [`Axo_SR_1000`](Axo_SR_1000.md) | Keyence SR-1000 | Fixed barcode/2D-code reader (next generation) — same usage pattern as SR-750 with the SR-1000 result/user data layout. |

## Hardware configuration

PROFINET device templates for each supported model live under
`showcase/app/hwc/library_templates/`:

- `Keyence_IV3/`
- `Keyence_SR_750/`
- `Keyence_SR_1000/`

The showcase `plc_line.hwl.yml` instantiates each device under the tagged
regions `KeyenceIv3Device`, `KeyenceSr750Device`/`KeyenceSr750IoSystem`, and
`KeyenceSr1000Device`/`KeyenceSr1000IoSystem`. See each component's
**HARDWARE** tab for the live YAML references.

## Dependencies

| Dependency | Why |
|------------|-----|
| `@inxton/axopen.io` | Base PROFINET I/O abstractions and hardware-diagnostics infrastructure. |

## Vendor documentation

- [Keyence — Vision Systems](https://www.keyence.com/products/vision/vision-sys/)
- [Keyence — IV3 Series](https://www.keyence.com/products/vision/vision-sys/iv3/)
- [Keyence — SR-750 Series](https://www.keyence.com/products/barcode/handheld/sr-750/)
- [Keyence — SR-1000 Series](https://www.keyence.com/products/barcode/fixed/sr-1000/)

## See also

- [AXOpen documentation](https://inxton.github.io/AXOpen/)
- [Troubleshooting](TROUBLES.md) — common issues and resolution steps.
- [Changelog](CHANGELOG.md) — version history.
