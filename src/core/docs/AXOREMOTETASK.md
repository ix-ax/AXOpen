# AxoRemoteTask

`AxoRemoteTask` provides task execution, where the execution of the task is deferred to .NET environment. AxoRemoteTask derives from [AxoTask](AXOTASK.md).

`AxoRemoteTask` needs to be initialized to set the proper AxoContext.

> [!IMPORTANT]
> The deferred execution in .NET environment is not hard-real time nor deterministic. You would typically use the AxoRemoteTask when it would be hard to achieve a goal in the PLC, but you can delegate the access to the non-hard-real and nondeterministic environment. Examples of such use would be database access, complex calculations, and email sending.

**AxoTask initialization within a AxoContext**

[!code-smalltalk[](../app/src/Examples/AXOpen.AxoRemoteTask/AxoRemoteTaskDocuExample.st?name=AxoTaskIntitialization)]

There are two key methods for managing the AxoRemoteTask:

- `Invoke()` fires the execution of the AxoRemoteTask (can be called fire&forget or cyclically)
- `Execute()` method must be called cyclically. *In contrast to `AxoTask` the method does not execute any logic. You will need to call the `Execute` method cyclically which will deffer the logic execution in .NET environment.*


There are the following differences in behavior of DoneWhen and ThrowWhen methods:

- *`DoneWhen(Done_Condition)`* - Unlike AxoTask **Done condition is handled internally. It does not have an effect.**
- *`ThrowWhen(Error_Condition)`* - Unlike AxoTask **Exception emission is handled internally. It does not have an effect.**

For termination of the execution of the AxoRemoteTask there are the following methods:
- `Abort()` - terminates the execution of the AxoRemoteTask and enters the `Ready` state if the AxoRemoteTask is in the `Busy` state; otherwise does nothing.

To reset the AxoRemoteTask from any state at any moment, there is the following method:
- `Restore()` acts as a reset of the AxoRemoteTask (sets the state into `Ready` from any state of the AxoRemoteTask).

The `AxoRemoteTask` executes upon the `Invoke` method call. `Invoke` fires the execution of `Execute` logic upon the first call, and `Invoke` does not need cyclical calling.

[!code-smalltalk[](../app/src/Examples/AXOpen.AxoRemoteTask/AxoRemoteTaskDocuExample.st?name=AxoTaskInvoke)]

`Invoke()` method returns IAxoTaskState with the following members:

 - `IsBusy` indicates the execution started and is running.
 - `IsDone` indicates the execution completed with success.
 - `HasError` indicates the execution terminated with a failure.
 - `IsAborted` indicates that the execution of the AxoRemoteTask has been aborted. It should continue by calling the method `Resume()`.

## Task initialization in .NET

[!code-csharp[](../app/src/AXOpen.Integrations.Blazor/Program.cs?name=InitializeRemoteTask)]

In this example, when the PLC invokes this task it will write a message into console. You can use arbitrary code in place of the labmda expression.

![Alt text](assets/remote_exect.gif)


## Executing from PLC

Invoking the AxoRemoteTask and waiting for its completion at the same place.
[!code-smalltalk[](../app/src/Examples/AXOpen.AxoRemoteTask/AxoRemoteTaskDocuExample.st?name=AxoTaskInvokeDone)]
Invoking the AxoRemoteTask and waiting for its completion at the different places.
[!code-smalltalk[](../app/src/Examples/AXOpen.AxoRemoteTask/AxoRemoteTaskDocuExample.st?name=AxoTaskInvokeDoneSeparatelly)]
Checking if the AxoRemoteTask is executing.
[!code-smalltalk[](../app/src/Examples/AXOpen.AxoRemoteTask/AxoRemoteTaskDocuExample.st?name=AxoTaskRunning)]
Check for the AxoRemoteTask's error state. 
[!code-smalltalk[](../app/src/Examples/AXOpen.AxoRemoteTask/AxoRemoteTaskDocuExample.st?name=AxoTaskError)]


