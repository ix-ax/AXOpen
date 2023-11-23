# AXOpen.VisualComposer

VisualComposer library is for creating draggable elements in AXOpen applications.

## Usage

~~~ HTML
<VisualComposerContainer ImgSrc="logo-header.svg" Objects="@(new [] { Entry.Plc.Context.StarterUnitTemplate })"/>
~~~

## VisualComposerContainer

The `VisualComposerContainer` is default component that is used to generate customizable view.

### Attributes

ImgSrc - The path to the image that will be used as the background of the container.
Objects - The list of ITwinObject from which is been claim all children and all primitives.

## Customizing

All option that is bellow is only available with role Administrator.

## Adding items

- `Show all` button you can show all children that is available from objects. And you can add them into view.
- `Show all primitives` button you can show all primitives that is available from objects. And you can add them into view.

### Customizable option

With drag-and-drop you can move every item on site.

You can every item customizing with these options:

- Presentation (Status-Display or Command-Control) - can be checked `Custom` and write your own name of presentation
- Transform (combination of left, center, right, top, center, bottom)
- Width - double value in rem, or -1 for auto
- Height - double value in rem, or -1 for auto
- ZIndex - int value, default is 0
- Roles - list of roles, that can see this item (`process_settings_access` or `process_settings_access, process_traceability_access`)

### Layout

- `Save as default` - save current layout as default layout. Default layout is loaded when application is started. Its available for every user.
- `Save as` - save current layout as new layout. Only administrator can change to this layout. (from name of new file is removed all special characters, that is not supported in file name)
- `Remove` - show all layouts with remove button,