## Description


This library provide access to the Keyence IV3 vision system.


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



