# Draggable

Draggable library is for creating draggable elements in AXOpen applications.

## Usage

~~~ HTML
<DraggableContainer ImgSrc="logo-header.svg">
    @foreach (var axoObject in Entry.Plc.Context.PneumaticManipulator.GetChildren().Flatten(p => p.GetChildren()).OfType<AXOpen.Core.AxoObject>())
        {
            <DraggableItem AxoObject="axoObject" />
        }
</DraggableContainer>
~~~

## DraggableContainer

The `DraggableContainer` component is a container for draggable items. It is used to define the area where the items can be dragged.

### Attributes

ImgSrc - The path to the image that will be used as the background of the container.

## DraggableItem

The `DraggableItem` component is a draggable item. It is used to define the draggable items.

It can be used with or without a child component. If it is used without a child component, the default presentation will be used:

~~~ HTML
<DraggableItem AxoObject="axoObject" />
~~~

or with a child component, where you must define presentation:

~~~ HTML
<DraggableItem AxoObject="axoObject">
    <RenderableContentControl Context="AxoObject" Presentation="Command" />
</DraggableItem>
~~~

### Attributes

AxoObject - The axo object that will be used as the draggable item. It will be show in `RenderableContentControl`.
