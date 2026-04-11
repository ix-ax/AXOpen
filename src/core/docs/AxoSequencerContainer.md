# AxoSequencerContainer

`AxoSequencerContainer` extends `AxoSequencer` and is the **preferred way** to implement sequences in AXOpen applications. Unlike `AxoSequencer` which requires explicit `Open()` calls, `AxoSequencerContainer` is self-managing — you extend it, override `Main`, and place all step logic there.

## Key differences from AxoSequencer

| Aspect | AxoSequencer | AxoSequencerContainer |
|--------|-------------|----------------------|
| Instantiation | Direct | Abstract — must extend |
| Open() call | Manual (required) | Automatic (handled by `Run()`) |
| Logic location | Inline in calling code | Encapsulated in `Main` override |
| Reusability | Single-use | Reusable class pattern |

## When to use

Use `AxoSequencerContainer` for production sequences (Automat, Ground, Service modes). Use `AxoSequencer` for simple inline demos or one-off sequences.

### Example of using AxoSequencerContainer
#### Example of the declaration of the user-defined class that extends from AxoSequencerContainer 
[!code-smalltalk[](../../showcase/app/src/core/AXOpen.AxoSequencerContainer/AxoSequencerContainerDocuExample.st?range=4-10,42)]
#### Example of implementation MAIN method inside the user-defined class that extends from AxoSequencerContainer 
All the custom logic of the sequencer needs to be placed here.
[!code-smalltalk[](../../showcase/app/src/core/AXOpen.AxoSequencerContainer/AxoSequencerContainerDocuExample.st?name=MAIN)]
#### Example of declaration of the instance of the user-defined class that extends from AxoSequencerContainer 
[!code-smalltalk[](../../showcase/app/src/core/AXOpen.AxoSequencerContainer/AxoSequencerContainerDocuExample.st?name=InstanceDeclaration)]
#### Example of calling of the instance of the user-defined class that extends from AxoSequencerContainer 
[!code-smalltalk[](../../showcase/app/src/core/AXOpen.AxoSequencerContainer/AxoSequencerContainerDocuExample.st?name=InstanceRunning)]

### SequenceMode — RunOnce with localizable descriptions

The following example demonstrates `eAxoSequenceMode#RunOnce` mode with localizable step descriptions and `RequestStep` for conditional branching back to a previous step:
[!code-smalltalk[](../../showcase/app/src/core/AXOpen.AxoSequencerContainer/AxoSequencerContainerDocuExample.st?name=SequenceMode)]

### Branching with RequestStep

Use `RequestStep` to branch to different steps based on runtime conditions. When the target step is declared after the current one, it executes in the same cycle; when before, in the next cycle:
[!code-smalltalk[](../../showcase/app/src/core/AXOpen.AxoSequencerContainer/AxoSequencerContainerDocuExample.st?name=RequestStep)]