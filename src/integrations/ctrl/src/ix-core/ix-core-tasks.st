
NAMESPACE core
    using ix.framework.core;

    CLASS Tasks EXTENDS ix.framework.core.Context
        VAR PUBLIC
            {#ix-set:AttributeName = "Click to execute this command"}
            _commandTask : CommandTask;
            {#ix-set:AttributeName = "If true the command will end in failure."}
            _commandEndsInFailure : BOOL;
        END_VAR    
    
        VAR a : ULINT; END_VAR
        METHOD PROTECTED OVERRIDE Main
            _commandTask.Initialize(THIS);    

            IF(_commandTask.Execute()) THEN                
                IF(THIS.OpenCycleCount() MOD ULINT#250 = ULINT#0) THEN
                    if(_commandEndsInFailure) THEN
                        _commandTask.ThrowWhen(TRUE);    
                    ELSE                            
                        _commandTask.DoneWhen(TRUE);
                    END_IF;    
                END_IF;    
            END_IF;    
        END_METHOD
END_CLASS    
END_NAMESPACE
