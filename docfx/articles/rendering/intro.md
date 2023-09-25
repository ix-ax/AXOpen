# Automatic Rendering with AXOpen

AXOpen leverages [AX# rendering](https://ix-ax.github.io/axsharp/articles/blazor/RENDERABLECONTENT.html) to enable a variety of advanced features.

This document provides foundational information regarding the presentation methods used within AXOpen.

## Renderable Content Control

While [presentation modes in AX#](https://ix-ax.github.io/axsharp/articles/blazor/RENDERABLECONTENT.html#presentation-types) offer several options, AXOpen introduces additional presentation types:

| Presentation Type | Description                                                                                  |
| ----------------- | -------------------------------------------------------------------------------------------- |
| Command           | Allows interaction with a UI control, permitting modifications and controls of the component. |
| Status            | Grants visibility of a UI control without the capability to modify or control the component.  |

### Examples:

**To enable manipulation of the `DriveX` component:**

```XML
<RenderableContentControl Context="@Entry.Plc.Station001.Components.DriveX" Presentation="Command"/>
```

**To view the status of the `DriveX` component without interaction:**

```XML
<RenderableContentControl Context="@Entry.Plc.Station001.Components.DriveX" Presentation="Status"/>
```

**To engage with visual components within the 'Components' structure for manual control:**

```XML
<RenderableContentControl Context="@Entry.Plc.Station001.Components" Presentation="Command"/>
```

**To observe the state of visual components within the 'Components' structure without manual interaction:**

```XML
<RenderableContentControl Context="@Entry.Plc.Station001.Components" Presentation="Status"/>
```

---