# AXOpen.VisualComposer

VisualComposer library is for creating draggable elements in AXOpen applications.

## Usage

~~~ HTML
<VisualComposerContainer ImgSrc="logo-header.svg" Id="@Entry.Plc.Context.PneumaticManipulator.HumanReadable">
    @foreach (var axoObject in Entry.Plc.Context.PneumaticManipulator.GetChildren().Flatten(p => p.GetChildren()).OfType<AXOpen.Core.AxoObject>())
    {
        <VisualComposerItem AxoObject="axoObject" />
    }
</VisualComposerContainer>
~~~

## VisualComposerContainer

The `VisualComposerContainer` component is a container for `VisualComposerItem`. It is used to define the area where the items can be dragged.

### Attributes

ImgSrc - The path to the image that will be used as the background of the container.
Id - The id of the container. It is used to identify the container for saving current state into json.

## VisualComposerItem

The `VisualComposerItem` component is a draggable item. It is used to define the draggable items.

It can be used with or without a child component. If it is used without a child component, the default presentation will be used:

~~~ HTML
<VisualComposerItem AxoObject="axoObject" />
~~~

or with a child component, where you must define presentation:

~~~ HTML
<VisualComposerItem AxoObject="axoObject">
    <RenderableContentControl Context="AxoObject" Presentation="Command" />
</VisualComposerItem>
~~~

### Attributes

AxoObject - The axo object that will be used as the draggable item. It will be show in `RenderableContentControl`.

## Customizable option

If you have role Administrator you can every `VisualComposerItem` customizing with these options:

- position - can be moved on site
- show - show or hide
- Transform (combination of left, center, right, top, center, bottom)
- Presentation (Status-Display or Command-Control)
- Width - double value in rem, or -1 for auto
- Height - double value in rem, or -1 for auto
- ZIndex - int value, default is 0
