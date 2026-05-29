USING AXOpen.Core;

NAMESPACE AxoTaskExamples

    // Demonstrates the Aborted terminal state in AxoTaskView:
    //   - Invoke kicks the task into Busy.
    //   - After a fixed number of Execute cycles, Abort() transitions the
    //     task to Aborted (stop icon + Resume button appear in the view).
    //   - Resume returns the task to Busy; counter is reset on Abort so the
    //     next run gets a fresh window before re-aborting.
    //   - Restore (Reset task button) returns the task to Ready.
    {S7.extern=ReadWrite}
    CLASS AxoTaskAbortedExample EXTENDS AXOpen.Core.AxoObject

        //<ComponentDeclaration>
        VAR PUBLIC
            {#ix-set:AttributeName = "<#Aborting task#>"}
            _abortingTask : AXOpen.Core.AxoTask;
            _counter : ULINT;
        END_VAR
        //</ComponentDeclaration>

        METHOD PUBLIC Execute

            //<Initialization>
            _abortingTask.Run(THIS);
            //</Initialization>

            //<AxoTaskAbortedPattern>
            IF _abortingTask.Execute() THEN
                _counter := _counter + ULINT#1;
                IF _counter > ULINT#250 THEN
                    _counter := ULINT#0;
                    _abortingTask.Abort();
                END_IF;
            END_IF;

            IF _abortingTask.IsReady() THEN
                _counter := ULINT#0;
            END_IF;
            //</AxoTaskAbortedPattern>

        END_METHOD
    END_CLASS
END_NAMESPACE
