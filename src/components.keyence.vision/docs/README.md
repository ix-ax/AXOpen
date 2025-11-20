## Description


This library provide access to the Keyence IV3 vision system.


## Live view

The component allows to display live view from the Keyence IV3 vision system.

To enable the live view, you need to set the `DeviceIpAddress` property of the `Axo_IV3` component to the IP address of the Keyence IV3 device.

Example:
```st
{#ix-set:DeviceIpAddress = "192.168.1.106"}
KeyenceVisionSystem : AXOpen.Components.Keyence.Vision.Axo_IV3;
```

The live view will display the camera feed from the device at `http://{DeviceIpAddress}/iv3-wm-i.html` with the copyright footer removed.

**Note:** The server must be able to reach the device IP address for the live view to work. Make sure to register `IHttpClientFactory` in your DI container by adding `builder.Services.AddHttpClient();` in your `Program.cs`.



