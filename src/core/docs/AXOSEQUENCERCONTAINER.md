# AxoSequencerContainer

`AxoSequencerContainer` is an `AxoCordinator` class that extends from `AxoSequencer`. The main difference is that this class is abstract so it is not possible to instantiate it directly. The user-defined class that extends from `AxoSequencerContainer` needs to be created and then instantiated.

In the extended class `MAIN()` method needs to be created and all sequencer logic needs to be placed there. Then the sequencer is called via `Run(IAxoObject)` or `Run(IAxoContext)` methods, that ensure initialization of the sequencer with `AxoObject` or with `AxoContext`. Moreover the `Run()` method also ensures calling the `Open()` method, so it is not neccessary to call it explicitelly in comparison with `AxoSequencer`.

### Example of using AxoSequencerContainer
#### Example of the declaration of the user-defined class that extends from AxoSequencerContainer 
[!code-smalltalk[](../app/src/Examples/AXOpen.AxoSequencerContainer/AxoSequencerContainerDocuExample.st?range=4-10,42)]
#### Example of implementation MAIN method inside the user-defined class that extends from AxoSequencerContainer 
All the custom logic of the sequencer needs to be placed here.
[!code-smalltalk[](../app/src/Examples/AXOpen.AxoSequencerContainer/AxoSequencerContainerDocuExample.st?name=MAIN)]
#### Example of declaration of the instance of the user-defined class that extends from AxoSequencerContainer 
[!code-smalltalk[](../app/src/Examples/AXOpen.AxoSequencerContainer/AxoSequencerContainerDocuExample.st?name=InstanceDeclaration)]
#### Example of calling of the instance of the user-defined class that extends from AxoSequencerContainer 
[!code-smalltalk[](../app/src/Examples/AXOpen.AxoSequencerContainer/AxoSequencerContainerDocuExample.st?name=InstanceRunning)]