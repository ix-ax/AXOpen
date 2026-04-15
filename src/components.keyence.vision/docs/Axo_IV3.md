# Axo_IV3

_Keyence IV3 fixed vision sensor_

Generated documentation for the `Axo_IV3` component.

# [CONTROLLER](#tab/controller)

## Declare component

[!code-pascal[](../../showcase/app/src/components.keyence.vision/Documentation/Axo_IV3_Showcase.st?name=ComponentDeclaration)]

## Declare initialization variables

*Most of the initialization variables come from the I/O system. The example below is for demonstration purposes.*

[!code-pascal[](../../showcase/app/src/components.keyence.vision/Documentation/Axo_IV3_Showcase.st?name=InitializationArgumentsDeclaration)]

## Initialize & Run

[!code-pascal[](../../showcase/app/src/components.keyence.vision/Documentation/Axo_IV3_Showcase.st?name=Initialization)]

[!INCLUDE [IntializeAndRun](../../../docfx/articles/notes/CYCLIC_UPDATE_NOTICE.md)]

## Use

[!code-pascal[](../../showcase/app/src/components.keyence.vision/Documentation/Axo_IV3_Showcase.st?name=Usage)]

## Source

View the library source at [`Axo_IV3.st`](https://github.com/Inxton/AXOpen/tree/3-unify-showcase/src/components.keyence.vision/ctrl/src/Axo_IV3/Axo_IV3.st).

# [.NET TWIN](#tab/twin)

## Live view

The `Axo_IV3` .NET twin exposes a reverse-proxy helper (`ConfigureProxy`) that
surfaces the device's built-in HTTP live view inside the application's web UI.
Two pragmas on the ST component instance drive the wiring:

| Pragma | Purpose |
|--------|---------|
| `{#ix-set:DeviceIpAddress = "..."}` | IP address of the Keyence IV3 device that the server will reach. |
| `{#ix-set:Proxy = "..."}` | Proxy identifier used to mount the reverse-proxy endpoint (`/{Proxy}/iv3-wm-i.html`). |

The showcase component declaration illustrates the `DeviceIpAddress` pragma:

[!code-pascal[](../../showcase/app/src/components.keyence.vision/Documentation/Axo_IV3_Showcase.st?name=ComponentDeclaration)]

The reverse-proxy middleware must be wired in the Blazor host (`Program.cs`)
before the Blazor endpoint handling so that image requests are routed through
the server and CORS is not required. `IHttpClientFactory` must also be
registered.

### Register `IHttpClientFactory`

[!code-csharp[](../../showcase/app/ix-blazor/showcase.blazor/Program.cs?name=KeyenceIv3HttpClient)]

### Wire the reverse-proxy middleware

[!code-csharp[](../../showcase/app/ix-blazor/showcase.blazor/Program.cs?name=KeyenceIv3ReverseProxy)]

## Source

View the .NET twin source at [`AXOpen.Components.Keyence.Vision`](https://github.com/Inxton/AXOpen/tree/3-unify-showcase/src/components.keyence.vision/src/AXOpen.Components.Keyence.Vision/).

# [BLAZOR](#tab/blazor)

`Axo_IV3` renders via the generic `AxoComponent` pattern using
`RenderableContentControl` — the runtime inspects the component type and
selects the matching rendering based on the `Presentation` attribute. A
dedicated `Axo_IV3View` is also available when richer visualization
(including the reverse-proxied live view) is required.

## Status display

[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/components-keyence-vision/Documentation/KeyenceVision.razor?name=GenericComponentStatusView)]

## Command control

[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/components-keyence-vision/Documentation/KeyenceVision.razor?name=GenericComponentCommandView)]

## Dedicated Axo_IV3 status view

[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/components-keyence-vision/Documentation/KeyenceVision.razor?name=Axo_IV3StatusView)]

## Dedicated Axo_IV3 command view

[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/components-keyence-vision/Documentation/KeyenceVision.razor?name=Axo_IV3CommandView)]

## Type-agnostic status view

[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/components-keyence-vision/Documentation/KeyenceVision.razor?name=RccComponentStatusView)]

## Type-agnostic command view

[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/components-keyence-vision/Documentation/KeyenceVision.razor?name=RccComponentCommandView)]

Available `Presentation` values: `Status-Display`, `Command-Control`, `Service-Control`, `Spot`, `Compact`.

## Source

View the Blazor package at [`AXOpen.Components.Keyence.Vision.blazor`](https://github.com/Inxton/AXOpen/tree/3-unify-showcase/src/components.keyence.vision/src/AXOpen.Components.Keyence.Vision.blazor/).

# [HARDWARE](#tab/hardware)

## Device template

PROFINET hardware template at `showcase/app/hwc/library_templates/Keyence_IV3/`.

## Device instantiation

[!code-yaml[](../../showcase/app/hwc/plc_line.hwl.yml?name=KeyenceIv3Device)]

## IO system wiring

[!code-yaml[](../../showcase/app/hwc/plc_line.hwl.yml?name=KeyenceIv3IoSystem)]

---
