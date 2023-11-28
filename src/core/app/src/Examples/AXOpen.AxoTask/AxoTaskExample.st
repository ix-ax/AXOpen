USING AXOpen.Core;

NAMESPACE AxoTaskExamples

    {S7.extern=ReadWrite}
    CLASS MyCommandTask EXTENDS AXOpen.Core.AxoTask
        VAR PUBLIC
        {#ix-set:AttributeName = "<#Counter#>"}
        _counter : ULINT;
        END_VAR

        METHOD PROTECTED OVERRIDE OnRestore
            _counter := ULINT#0;
        END_METHOD
    END_CLASS    

    {S7.extern=ReadWrite}
    CLASS Tasks EXTENDS AXOpen.Core.AxoContext
        VAR PUBLIC
            {#ix-set:AttributeName = "Click to execute this command"}
            _commandTask : MyCommandTask;
            {#ix-set:AttributeName = "If true the command will end in failure."}
            _commandEndsInFailure : BOOL;
            {#ix-set:AttributeName = "If true remote abort is enabled"}
            _enableRemoteAbort : BOOL := FALSE;
            {#ix-set:AttributeName = "If true remote restore is enabled"}
            _enableRemoteRestore : BOOL := TRUE;
            {#ix-set:AttributeName = "First entry counter"}
            _firstEntryCounter :ULINT;
        END_VAR    
    
        METHOD PROTECTED OVERRIDE Main
            _commandTask.Initialize(THIS);    

            _commandTask.SetRemoteAbortEnabled(_enableRemoteAbort);
            _commandTask.SetRemoteRestoreEnabled(_enableRemoteRestore);

            IF(_commandTask.Execute()) THEN     
                IF _commandTask.IsFirstExecutionCycle() THEN
                    _firstEntryCounter := _firstEntryCounter + ULINT#1;
                END_IF;
                _commandTask._counter := _commandTask._counter + ULINT#1;        
                IF (_commandTask._counter MOD ULINT#250) = ULINT#0 THEN
                    IF(_commandEndsInFailure) THEN
                        _commandTask.ThrowWhen(TRUE);    
                    ELSE                            
                        _commandTask.DoneWhen(TRUE);
                    END_IF;    
                END_IF;    
            END_IF;    
        END_METHOD
    END_CLASS    
END_NAMESPACE
