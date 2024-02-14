# AXOpen.VisualComposer

VisualComposer library is for creating draggable elements in AXOpen applications.

## Usage

~~~ HTML
<VisualComposerContainer Objects="@(new[] {Entry.Plc.Context.UnitTemplate})" Id="@Component.Symbol" />
~~~

## VisualComposerContainer

The `VisualComposerContainer` is default component that is used to generate customizable view.

### Attributes

- `Objects` - The list of ITwinObjects that will be available for display.
- `Id` - The id of the container. If not specified, the id is generated automatically.

## Customizing

All option that is bellow is only available with role Administrator.

## Adding items

- `Controller objects` - show all objects, that can be added to the view.

## Views options

- `Used objects` - show all object, that is used in view. Provide simple access to customizable or remove item
- `Create new` - create new view
- `Create copy` - create new view as copy of current selected view
- `Views` - show all views with clear zoom and pan, remove, add/remove from base views, enable/disable zooming and panning and set as default view
- `Background` - set background of view. You can choose from image or simple color
- `Change theme` - change color of icon for customizable item (black/white)
- after every change is view automatically saved into json

## Customizable options

With drag-and-drop you can move every item on view.

You can every item customizing with these options:

- `Top` - the top position of the object
- `Left` - the left position of the object
- `Presentation` - Command-Control, Status-Display or Spot. Can be checked `Custom` and write your own name of presentation
- `Transform` - the location from which the position will be calculated (combination of left, center, right and top, center, bottom)
- `Width` - width of element (double value in rem, or -1 for auto)
- `Height` - height of element (double value in rem, or -1 for auto)
- `ZIndex` - the layer in which the object should be located (int value, default is 0)
- `Scale` - zoom of item
- `Roles` - list of roles, that can see this item (`process_settings_access` or `process_settings_access, process_traceability_access`)
- `Template` - specifies the way the item is formatted and presented
- `Background` - item background
