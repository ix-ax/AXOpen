# AXOpenComponentsPneumatics

The `AXOpenComponentsPneumatics` library controls and operates the basic pneumatic actuators. 

## AxoCylinder

`AxoCylinder` provides the essential control and operation of a basic pneumatic cylinder, including two controlling output signals for both directions and two end-position sensors. The following preconditions need to be met to make `AxoCylinder` work as expected.
- two pneumatic valves must be used
- when the first valve is open and the second one is closed, the cylinder moves in one direction. When the first valve is closed and the second one is open, the cylinder moves in opposite direction
- when both valves are closed, the cylinder stops and does not move
- TODO add pneumatic schematics 

### Implementation
The `AxoCylinder` is designed to be used as a member of the `AxoContext` or `AxoObject`.
Therefore, its instance must be initialized with the proper `AxoContext` or `AxoObject` before any use. 
Also, the hardware signals must be assigned first before calling any method of this instance. 
To accomplish this, call the `Run` method cyclically with the proper variables (i.e. inside the `Main` method of the relevant `AxoContext`) as in the example below:

**Example of the initialization and hardware signal assignment**
[!code-smalltalk[](../../../../src/components.pneumatics/app/src/Documentation/DocumentationContext.st?name=DeclarationAndHWIO_Assignement)]

To trigger the movements, two public methods, `MoveToHome` and `MoveOut` are present. 
**Example of using MoveToHome method**
[!code-smalltalk[](../../../../src/components.pneumatics/app/src/Documentation/DocumentationContext.st?name=MoveToHome)]
**Example of using MoveOut method**
[!code-smalltalk[](../../../../src/components.pneumatics/app/src/Documentation/DocumentationContext.st?name=MoveToWork)]

To stop the movement, when the cylinder is moving, the public `Stop` method is present. 
**Example of using Stop method**
[!code-smalltalk[](../../../../src/components.pneumatics/app/src/Documentation/DocumentationContext.st?name=Stop)]
>[!NOTE] 
>If the `Stop` method does not work as expected, check if your pneumatic circuit meets the precondition.

**Blocking the movement**
To block the movement, there are four public methods present:
`SuspendMoveToInWhile(Condition)` - Suspends the movement to the in position while the `Condition` is `TRUE`. If the task was already invoked, it remains still executing and, with the falling edge of the `Condition` cylinder, continues its movement to the in position. If the task is invoked when `Condition` is already `TRUE`, the task starts to be executed, but the movement starts also with the falling edge of the `Condition`. 
`SuspendMoveToOutWhile(Condition)` - Works exactly the same as `SuspendMoveToInWhile(Condition)` but in the opposite direction (to the out position).
**Example of using SuspendMoveToInWhile method**
[!code-smalltalk[](../../../../src/components.pneumatics/app/src/Documentation/DocumentationContext.st?name=SuspendMoveToInWhile)]
**Example of using SuspendMoveToOutWhile method**
[!code-smalltalk[](../../../../src/components.pneumatics/app/src/Documentation/DocumentationContext.st?name=SuspendMoveToOutWhile)]

`AbortMoveToHomeWhen(Condition)` - Aborts the movement to the in position when the `Condition` is `TRUE`. If the task was already invoked, it is restored and disabled. After the falling edge of the `Condition` cylinder does not continue its movement to the in position. The task needs to be invoked again to start the movement. 
`AbortMoveToWorkWhen(Condition)` - Works exactly the same as `AbortMoveToHomeWhen(Condition)` but in the opposite direction (to the out position).
**Example of using AbortMoveToHomeWhen method**
[!code-smalltalk[](../../../../src/components.pneumatics/app/src/Documentation/DocumentationContext.st?name=AbortMoveToHomeWhen)]
**Example of using AbortMoveToWorkWhen method**
[!code-smalltalk[](../../../../src/components.pneumatics/app/src/Documentation/DocumentationContext.st?name=AbortMoveToWorkWhen)]


**How to visualize `AxoCylinder`**
On the UI side, use the `RenderableContentControl` and set its Context according to the placement of the instance of the `AxoCylinder`.
[!code-csharp[](../../../../src/components.pneumatics/app/ix-blazor/PneumaticComponents.blazor/Pages/Documentation.razor?name=RenderedView)]
