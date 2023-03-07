using ix.framework.core;

NAMESPACE IxRemoteTaskDocuExamples
    //<IxRemoteTaskExample>    
    CLASS MyRemoteTask EXTENDS IxRemoteTask
        VAR PUBLIC        
            Message : STRING[254];
        END_VAR
        
        METHOD PUBLIC Invoke : IIxTaskState
            VAR_INPUT
                LogMessage : STRING[254];
            END_VAR;  
            Message := LogMessage;
            Invoke := SUPER.Invoke();
        END_METHOD

    END_CLASS 
    //</IxRemoteTaskExample>
    CLASS RemoteTasks EXTENDS ix.framework.core.IxContext
        VAR PUBLIC            
            _remoteTask : MyRemoteTask;  
            _remoteTaskInvokeFromPlc : BOOL;     
            _doneCounter : INT;
        END_VAR    
    
        METHOD PROTECTED OVERRIDE Main

            //<IxTaskIntitialization>
            _remoteTask.Initialize(THIS); // THIS = IIContext 
            //</IxTaskIntitialization>

            //<IxTaskInvoke>
            _remoteTask.Invoke('hello');                            
            //</IxTaskInvoke>


            //<IxTaskInvokeDone>
            IF(_remoteTask.Invoke('hello').IsDone()) THEN
                _doneCounter := _doneCounter + 1; 
            END_IF;    
            //</IxTaskInvokeDone>
        
            //<IxTaskInvokeDoneSeparatelly>    

            // Fire & Forget
            _remoteTask.Invoke('hello');

            // What for done somwhere else
            IF(_remoteTask.IsDone()) THEN
                _doneCounter := _doneCounter + 1; 
            END_IF;    

            //</IxTaskInvokeDoneSeparatelly>

            //<IxTaskRunning>
            IF(_remoteTask.IsBusy()) THEN
                ;// Do something after task started
            END_IF;   
            //</IxTaskRunning>

            //<IxTaskError>
            IF(_remoteTask.HasError()) THEN
                ;// Do something when an exception occurs on remote task.
            END_IF;   
            //</IxTaskError>

            _remoteTask.Execute();

        END_METHOD
    END_CLASS    
END_NAMESPACE
