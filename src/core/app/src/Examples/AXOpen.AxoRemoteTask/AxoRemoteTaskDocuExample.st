USING AXOpen.Core;

NAMESPACE AxoRemoteTaskDocuExamples
    //<AxoRemoteTaskExample>    
    {S7.extern=ReadWrite}
    CLASS MyRemoteTask EXTENDS AXOpen.Core.AxoRemoteTask
        VAR PUBLIC        
            Message : STRING[254];
        END_VAR
        
        METHOD PUBLIC Invoke : IAxoTaskState
            VAR_INPUT
                LogMessage : STRING[254];
            END_VAR;  
            Message := LogMessage;
            Invoke := SUPER.Invoke();
        END_METHOD

    END_CLASS 
    //</AxoRemoteTaskExample>
    {S7.extern=ReadWrite}
    CLASS RemoteTasks EXTENDS AXOpen.Core.AxoContext
        VAR PUBLIC            
            _remoteTask : MyRemoteTask;  
            _remoteTaskInvokeFromPlc : BOOL;     
            _doneCounter : INT;
        END_VAR    
    
        METHOD PROTECTED OVERRIDE Main

            //<AxoTaskIntitialization>
            _remoteTask.Initialize(THIS); // THIS = IAxoContext 
            //</AxoTaskIntitialization>

            //<AxoTaskInvoke>
            _remoteTask.Invoke('hello');                            
            //</AxoTaskInvoke>


            //<AxoTaskInvokeDone>
            IF(_remoteTask.Invoke('hello').IsDone()) THEN
                _doneCounter := _doneCounter + 1; 
            END_IF;    
            //</AxoTaskInvokeDone>
        
            //<AxoTaskInvokeDoneSeparatelly>    

            // Fire & Forget
            _remoteTask.Invoke('hello');

            // Wait for done somwhere else
            IF(_remoteTask.IsDone()) THEN
                _doneCounter := _doneCounter + 1; 
            END_IF;    

            //</AxoTaskInvokeDoneSeparatelly>

            //<AxoTaskRunning>
            IF(_remoteTask.IsBusy()) THEN
                ;// Do something after task started
            END_IF;   
            //</AxoTaskRunning>

            //<AxoTaskError>
            IF(_remoteTask.HasError()) THEN
                ;// Do something when an exception occurs on remote task.
            END_IF;   
            //</AxoTaskError>

            _remoteTask.Execute();
        END_METHOD
    END_CLASS    
END_NAMESPACE
