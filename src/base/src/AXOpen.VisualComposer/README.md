# AXOpen.VisualComposer

VisualComposer library is for creating draggable elements in AXOpen applications.

## Usage

~~~ HTML
<VisualComposerContainer Objects="@(new[] {Entry.Plc.Context.UnitTemplate})" />
~~~

## VisualComposerContainer

The `VisualComposerContainer` is default component that is used to generate customizable view.

### Attributes

Objects - The list of ITwinObject from which is been claim all children and all primitives.
Id - The id of the container. If not specified, the id is generated automatically.

## Customizing

You can pan and zoom the entire Visual Composer container by holding the Ctrl key.
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

- `Save` - save current layout
- `Save as default` - save current layout as default layout. Default layout is loaded when application is started. Its available for every user.
- `Save as` - save current layout as new layout. Only administrator can change to this layout. (from name of new file is removed all special characters, that is not supported in file name)
- `Templates` - show all templates with remove buttons
- `Set image` - set image for current layout
