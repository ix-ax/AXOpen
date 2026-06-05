USING AXOpen.Core;

NAMESPACE AxoTaskExamples

    // Demonstrates the disabled-state indicator in AxoTaskView:
    //   - The task is kept perpetually Busy (self-invoked, never completed),
    //     so it always sits in an "active" state.
    //   - Rendering this task through a DISABLED / display-only AxoTaskView
    //     (Disable=true, e.g. the Status presentation) draws the activity
    //     circle with a lock icon INSIDE it, instead of replacing the circle.
    //   - Note: a task disabled on the PLC side via SetIsDisabled(TRUE) aborts
    //     while Busy (see AxoTaskLight.Execute), so the lock-inside-circle
    //     visual is a VIEW-level disable of a genuinely running task.
    {S7.extern=ReadWrite}
    CLASS AxoTaskDisabledExample EXTENDS AXOpen.Core.AxoObject

        //<ComponentDeclaration>
        VAR PUBLIC
            {#ix-set:AttributeName = "<#Always-active task — render display-only#>"}
            _activeTask : AXOpen.Core.AxoTask;
            {#ix-set:AttributeName = "<#Idle (Ready) task — render display-only#>"}
            _idleTask : AXOpen.Core.AxoTask;
        END_VAR
        //</ComponentDeclaration>

        METHOD PUBLIC Execute

            //<Initialization>
            _activeTask.Run(THIS);
            _idleTask.Run(THIS);
            //</Initialization>

            //<AxoTaskAlwaysActivePattern>
            // Execute() first (satisfies the cyclic-execute-called check), then
            // Invoke(). Invoke() only acts while the task is Ready, so once the
            // task is Busy it is a no-op and the task stays active indefinitely.
            _activeTask.Execute();
            _activeTask.Invoke();
            //</AxoTaskAlwaysActivePattern>

            //<AxoTaskIdlePattern>
            // _idleTask is wired into the object tree but never invoked, so it
            // stays in the Ready (not-busy) state. Rendered through a disabled
            // view it shows the lock inside the empty Ready circle.
            //</AxoTaskIdlePattern>

        END_METHOD
    END_CLASS
END_NAMESPACE
