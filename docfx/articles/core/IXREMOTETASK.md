# IxRemoteTask

`IxRemoteTask` provides task execution, where the execution of the task is deferred to .NET environment. IxRemoteTask derives from [IxTask](IXTASK.md).

`IxRemoteTask` needs to be initialized to set the proper IxContext.

> [!IMPORTANT]
> The deferred execution in .NET environment is not hard-real time nor deterministic. You would typically use the IxRemoteTask when it would be hard to achieve a goal in the PLC, but you can delegate the access to the non-hard-real and nondeterministic environment. Examples of such use would be database access, complex calculations, and email sending.

**IxTask initialization within a IxContext**

[!code-smalltalk[](../../../src/integrations/ctrl/src/Examples/ix-core-IxRemoteTask/IxRemoteTaskDocuExample.st?name=IxTaskIntitialization)]

There are two key methods for managing the IxTask:

- `Invoke()` fires the execution of the IxTask (can be called fire&forget or cyclically)
- `Execute()` method must be called cyclically. *In contrast to `IxTask` the method does not execute any logic. You will need to call the `Execute` method cyclically which will deffer the logic execution in .NET environment.*


There are the following differences in behavior of DoneWhen and ThrowWhen methods:

- *`DoneWhen(Done_Condition)`* - Unlike IxTask **Done condition is handled internally. It does not have an effect.**
- *`ThrowWhen(Error_Condition)`* - Unlike IxTask **Exception emission is handled internally. It does not have an effect.**

For termination of the execution of the IxRemoteTask there are the following methods:
- `Abort()` - terminates the execution of the IxTask and enters the `Ready` state if the IxTask is in the `Busy` state; otherwise does nothing.

To reset the IxRemoteTask from any state at any moment, there is the following method:
- `Restore()` acts as a reset of the IxRemoteTask (sets the state into `Ready` from any state of the IxTask).

The `IxRemoteTask` executes upon the `Invoke` method call. `Invoke` fires the execution of `Execute` logic upon the first call, and `Invoke` does not need cyclical calling.

[!code-smalltalk[](../../../src/integrations/ctrl/src/Examples/ix-core-IxRemoteTask/IxRemoteTaskDocuExample.st?name=IxTaskInvoke)]

`Invoke()` method returns IIxTaskState with the following members:

 - `IsBusy` indicates the execution started and is running.
 - `IsDone` indicates the execution completed with success.
 - `HasError` indicates the execution terminated with a failure.
 - `IsAborted` indicates that the execution of the IxTask has been aborted. It should continue by calling the method `Resume()`.

## Task initialization in .NET

[!code-csharp[](../../../src/integrations/integration.blazor/Program.cs?name=InitializeRemoteTask)]

In this example, when the PLC invokes this task it will write a message into console. You can use arbitrary code in place of the labmda expression.

<img src="~/images/remote_exect.gif ">


## Executing from PLC

Invoking the IxRemoteTask and waiting for its completion at the same place.
[!code-smalltalk[](../../../src/integrations/ctrl/src/Examples/ix-core-IxRemoteTask/IxRemoteTaskDocuExample.st?name=IxTaskInvokeDone)]
Invoking the IxRemoteTask and waiting for its completion at the different places.
[!code-smalltalk[](../../../src/integrations/ctrl/src/Examples/ix-core-IxRemoteTask/IxRemoteTaskDocuExample.st?name=IxTaskInvokeDoneSeparatelly)]
Checking if the IxRemoteTask is executing.
[!code-smalltalk[](../../../src/integrations/ctrl/src/Examples/ix-core-IxRemoteTask/IxRemoteTaskDocuExample.st?name=IxTaskRunning)]
Check for the IxRemoteTask's error state. 
[!code-smalltalk[](../../../src/integrations/ctrl/src/Examples/ix-core-IxRemoteTask/IxRemoteTaskDocuExample.st?name=IxTaskError)]


