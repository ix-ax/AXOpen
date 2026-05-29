USING AXOpen.Core;

NAMESPACE AxoTaskExamples

    // Demonstrates the Error terminal state in AxoTaskView:
    //   - Invoke kicks the task into Busy.
    //   - After a fixed number of Execute cycles, ErrorDetails is populated
    //     and ThrowWhen(TRUE) transitions the task to Error.
    //   - Restore (Reset task button) returns the task to Ready and clears
    //     the counter for the next demonstration.
    {S7.extern=ReadWrite}
    CLASS AxoTaskErrorExample EXTENDS AXOpen.Core.AxoObject

        //<ComponentDeclaration>
        VAR PUBLIC
            {#ix-set:AttributeName = "<#Failing task#>"}
            _failingTask : AXOpen.Core.AxoTask;
            _counter : ULINT;
        END_VAR
        //</ComponentDeclaration>

        METHOD PUBLIC Execute

            //<Initialization>
            _failingTask.Run(THIS);
            //</Initialization>

            //<AxoTaskErrorPattern>
            IF _failingTask.Execute() THEN
                _counter := _counter + ULINT#1;
                IF _counter > ULINT#250 THEN
                    _failingTask.ErrorDetails := 'Counter limit exceeded during execution.';
                    _failingTask.ThrowWhen(TRUE);
                END_IF;
            END_IF;

            IF _failingTask.IsReady() THEN
                _counter := ULINT#0;
            END_IF;
            //</AxoTaskErrorPattern>

        END_METHOD
    END_CLASS
END_NAMESPACE
