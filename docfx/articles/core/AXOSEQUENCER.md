# AxoSequencer

AxoSequencer is an AxoCordinator class provides triggering the AxoStep-s inside the sequence in the order they are written.

AxoSequencer extends from AxoTask so it also has to be initialized by calling its `Initialize()` method and started using its `Invoke()` method.
    
AxoSequencer contains following methods:
- `Open()`: this method must be called cyclically before any logic. All the logic of the sequencers must be placed inside the `if` condition. It provides some configuration mechanism that ensures that the steps are going to be executed in the order, they are written. During the very first call of the sequence, no step is executed as the AxoSequencer is in the configuring state. From the second context cycle after the AxoSequencer has been invoked the AxoSequencer change its state to running and starts the execution from the first step upto the last one. When AxoSequencer is in running state, order of the step cannot be changed. 
- `MoveNext()`: Terminates the currently executed step and moves the AxoSequencer's pointer to the next step in order of execution.
- `RequestStep()`: Terminates the currently executed step and set the AxoSequencer's pointer to the order of the `RequestedStep`. When the order of the `RequestedStep` is higher than the order of the currently finished step (the requested step is "after" the current one) the requested step is started in the same context cycle. When the order of the `RequestedStep` is lower than the order of the currently finished step (the requested step is "before" the current one) the requested step is started in the next context cycle.
- `CompleteSequence()`: Terminates the currently executed step, completes (finishes) the execution of this AxoSequencer and set the coordination state to Idle. If the `SequenceMode` of the AxoSequencer is set to `Cyclic`, following `Open()` method call in the next context cycle switch it again into the configuring state, reasign the order of the individual steps (even if the orders have been changed) and subsequently set AxoSequencer back into the running state. If the `SequenceMode` of the AxoSequencer is set to `RunOnce`, terminates also execution of the AxoSequencer itself.
- `GetCoordinatorState()': Returns the current state of the AxoSequencer. 
    - `Idle`
    - `Configuring`: assigning the orders to the steps, no step is executed.
    - `Running`: orders to the steps are already assigned, step is executed.
- `SetSteppingMode()`: Sets the stepping mode of the AxoSequencer. Following values are possible.
    - `None`:
    - `StepByStep`: if this mode is choosen, each step needs to be started by the invocation of the `StepIn` commmand.
    - `Continous`: if this mode is choosen (default), each step is started automaticcaly after the previous one has been completed.
- `GetSteppingMode()`: Gets the current stepping mode of the AxoSequencer. 
- `SetSequenceMode()`: Sets the sequence mode of the AxoSequencer. Following values are possible.
    - `None`:
    - `RunOnce`: if this mode is choosen, after calling the method `CompleteSequence()` the execution of the sequence is terminated.
    - `Cyclic`: if this mode is choosen (default), after calling the method `CompleteSequence()` the execution of the sequence is "reordered" and started from beginning.
- `GetSequenceMode()`: Gets the current sequence mode of the AxoSequencer. 
- `GetNumberOfConfiguredSteps()`: Gets the number of the configured steps in the sequence. 

### Example of using AxoSequencer
#### Example of the declaration of the AxoSequencer and AxoStep 
[!code-smalltalk[](../../../src/integrations/ctrl/src/Examples/AXOpen.AxoSequencer/AxoSequencerDocuExample.st?range=4-11,84)]
#### Initialization
Initialization of the context needs to be called first. It does not need to be called cyclically, just once.
[!code-smalltalk[](../../../src/integrations/ctrl/src/Examples/AXOpen.AxoSequencer/AxoSequencerDocuExample.st?name=Initialize)]
#### Open
The `Open()` method must be called cyclically before any logic. All the logic of the sequencers must be placed inside the `if` condition, as follows.
[!code-smalltalk[](../../../src/integrations/ctrl/src/Examples/AXOpen.AxoSequencer/AxoSequencerDocuExample.st?name=Open)]
#### Step
Example of the most simple use of the `Execute()` method of the `AxoStep` class, only with the AxoCoordinator defined. 
[!code-smalltalk[](../../../src/integrations/ctrl/src/Examples/AXOpen.AxoSequencer/AxoSequencerDocuExample.st?name=SimpleStep)]
Example of use of the `Execute()` method of the `AxoStep` class with the Enable condition. 
This step is going to be executed just in the first run of the sequence, as during the second one, the Enable parameter will have the value of FALSE.
[!code-smalltalk[](../../../src/integrations/ctrl/src/Examples/AXOpen.AxoSequencer/AxoSequencerDocuExample.st?name=EnableStep)]
Example of use of the `Execute()` method of the `AxoStep` class with all three parameters defined.
[!code-smalltalk[](../../../src/integrations/ctrl/src/Examples/AXOpen.AxoSequencer/AxoSequencerDocuExample.st?name=FullStep)]
