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

The component allows to display live view from the Keyence IV3 vision system.

To enable the live view, you need to set the `DeviceIpAddress` property of the `Axo_IV3` component to the IP address of the Keyence IV3 device, and define a proxy for the reverse proxy endpoint.

### Setup in Structured Text

Example:
```st
{#ix-set:DeviceIpAddress = "192.168.1.106"}
{#ix-set:Proxy = "keyence_iv3"}
KeyenceVisionSystem : AXOpen.Components.Keyence.Vision.Axo_IV3;
```

### Accessing the Live View

The live view is accessed through a reverse proxy endpoint. The component will fetch the camera feed from the device and serve it through the reverse proxy, which is accessible at `/{Proxy}/iv3-wm-i.html`, where `{Proxy}` is the proxy identifier of the component (e.g., `keyence_iv3` in the example above).

### Blazor Application Setup

To enable the reverse proxy functionality in your Blazor application, you must call the `ConfigureProxy` method from the `Axo_IV3` component in your middleware pipeline. This should be done before the Blazor endpoint handling.

Add the following to your `Program.cs`:

```csharp
// Register HttpClientFactory
builder.Services.AddHttpClient();

// Build the app
var app = builder.Build();

// Configure Keyence IV3 reverse proxy
app.Use(async (context, next) =>
{
    var keyenceComponent = /* Get your Axo_IV3 component instance */;
    await keyenceComponent.ConfigureProxy(context, next);
});

// ... rest of your middleware configuration
```

**Note:** The server must be able to reach the device IP address for the live view to work. Make sure to register `IHttpClientFactory` in your DI container by adding `builder.Services.AddHttpClient();` in your `Program.cs`.

The reverse proxy setup allows the web application to access the Keyence IV3 live view without CORS issues, as the request is proxied through the server backend rather than being accessed directly from the browser.


## Source

View the .NET twin source at [`AXOpen.Components.Keyence.Vision`](https://github.com/Inxton/AXOpen/tree/3-unify-showcase/src/components.keyence.vision/src/AXOpen.Components.Keyence.Vision/).

# [BLAZOR](#tab/blazor)

`Axo_IV3` does not ship a dedicated Blazor view. It renders via the generic `AxoComponent` pattern using `RenderableContentControl`, which inspects the component type at runtime and selects the matching rendering based on the `Presentation` attribute.

## Status display

[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/components-keyence-vision/Documentation/KeyenceVision.razor?name=GenericComponentStatusView)]

## Command control

[!code-html[](../../showcase/app/ix-blazor/showcase.blazor/Pages/components-keyence-vision/Documentation/KeyenceVision.razor?name=GenericComponentCommandView)]

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

---
