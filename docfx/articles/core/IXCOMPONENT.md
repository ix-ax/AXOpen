# IxComponent

`IxComponent` is an abstract class extending the IxObject, and it is the base building block for the "hardware-related devices" like a pneumatic piston, servo drive, robot, etc., so as for the, let's say, "virtual devices" like counter, database, etc. `IxComponent` is designed to group all possible methods, tasks, settings, and status information into one consistent class. As the `IxComponent` is an abstract class, it cannot be instantiated and must be extended. In the extended class, two methods are mandatory. 

`Restore()` - inside this method, the logic for resetting the IxComponent or restoring it from any state to its initial state should be placed.

`ManualControl()` - inside this method, the logic for manual operations with the component should be placed. To be able to control the `IxComponent` instance manually, the method `ActivateManualControl()` of this instance needs to be called cyclically.

The base class contains two additional method to deal with the manual control of the `IxComponent`. 
`ActivateManualControl()` - when this method is called cyclically, the `IxComponent` changes its behavior to manually controllable and ensure the call of the `ManualControl()` method in the derived class.

`IsManuallyControllable()` -returns `TRUE` when the `IxComponent` is manually controllable. 

**Layout attributes `ComponentHeader` and `ComponentDetails`**

The visual view of the extended `IxComponent` on the UI side could be done both ways. Manually with complete control over the design or by using the auto-rendering mechanism of the `RenderableContentControl` (TODO add a link to docu of the RenderableContentControl) element, which is, in most cases, more than perfect.
To take full advantage of the auto-rendering mechanism, the base class has implemented the additional layout attributes `ComponentHeader` and `ComponentDetails(TabName)`. The auto-rendered view is divided into two parts: the fixed one and the expandable one. 
All `IxComponent` members with the `ComponentHeader` layout attribute defined will be displayed in the fixed part. 
All members with the `ComponentDetails(TabName)` layout attribute defined will be displayed in the expandable part inside the `TabControl` with "TabName". 
All members are added in the order in which they are defined, taking into account their layout attributes like `Container(Layout.Wrap)` or `Container(Layout.Stack)`.

**How to implement `IxComponent`**

Example of the implementation very simple `IxComponent` with members placed only inside the Header.
[!code-smalltalk[](../../../src/integrations/ctrl/src/Examples/ix-core-IxComponent/IxComponentHeaderOnlyExample.st?name=Implementation)]

**How to use `IxComponent`**

The instance of the extended `IxComponent` must be defined inside the `IxContext`.
[!code-smalltalk[](../../../src/integrations/ctrl/src/Examples/ix-core-IxComponent/IxComponentHeaderOnlyExample.st?name=Using)]

Inside the `Main()` method of the related `IxContext` following rules must be applied. The `Initialize()` method of the extended instance of the `IxComponent` must be called first.
The `Run()` method with the respective input and output variables must be called afterwards.

**How to visualize `IxComponent`**

On the UI side use the `RenderableContentControl` and set its Context according the placement of the instance of the `IxComponent`.
[!code-csharp[](../../../src/integrations/integration.blazor/Pages/IxCoreComponentHeaderOnlyExample.razor?name=RenderedView)]

The rendered result should then looks as follows:

![Alt text](~/images/VerySimpleComponentExampleWithHeaderOnlyDefined.gif)

In case of more complex `IxComponent` the most important members should be placed in the fixed part (Header) and the rest of the members should be placed inside the expandable part (Details). The members inside the expandable part should be organize inside the tabs.  

**More complex `IxComponent`**
Example of the implementation more complex `IxComponent` with members placed also in several tabs inside the expandable part (Details).

[!code-smalltalk[](../../../src/integrations/ctrl/src/Examples/ix-core-IxComponent/IxComponentExample.st?name=Implementation)]

For the complex types of the `IxComponent` it is also recomended to organize partial groups of the members into the classes as it is in this example.

[!code-smalltalk[](../../../src/integrations/ctrl/src/Examples/ix-core-IxComponent/IxComponentExample.st?name=ClassDefinitions)]

Instantiate and call the `IxComponent` instance.

[!code-smalltalk[](../../../src/integrations/ctrl/src/Examples/ix-core-IxComponent/IxComponentExample.st?name=Using)]

UI side of the `IxComponent`.
[!code-csharp[](../../../src/integrations/integration.blazor/Pages/IxCoreComponentExample.razor?name=RenderedView)]

and the rendered result:

![Alt text](~/images/ComplexComponentExample.gif)