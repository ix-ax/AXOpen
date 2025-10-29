# Automatic Rendering with AXOpen

AXOpen leverages [AX# rendering](https://inxton.github.io/axsharp/articles/blazor/RENDERABLECONTENT.html) to enable a variety of advanced features.

This document provides foundational information regarding the presentation methods used within AXOpen.

## Renderable Content Control

While [presentation modes in AX#](https://inxton.github.io/axsharp/articles/blazor/RENDERABLECONTENT.html#presentation-types) offer several options, AXOpen introduces additional presentation types:

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

## Layout Attributes & Organization

Auto‑rendered components rely on layout attributes applied to members of your `AxoComponent` (or derived) classes:

| Attribute | Effect |
|-----------|--------|
| `ComponentHeader` | Places the member into the fixed (always visible) header region. |
| `ComponentDetails("TabName")` | Places the member into a tab named `TabName` within the expandable details section. |
| `Container(Layout.Wrap)` / `Container(Layout.Stack)` | Controls arrangement of grouped children inside the region they appear. |

Guidelines:

* Put frequently observed primary command tasks in the header.
* Group secondary / diagnostic data into logically named tabs (e.g. Diagnostics, IO, Tuning).
* Avoid overpopulating the header; if more than ~4 primary members appear, move non‑critical ones into a details tab.
* When adding new members, maintain attribute ordering to keep stable layout diffs.

See `AXOCOMPONENT.md` and `guidelines/components.md` for deeper examples and conventions.