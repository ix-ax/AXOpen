USING AXOpen.Core;

NAMESPACE AxoTaskExamples
    CLASS AxoTaskDocuExample EXTENDS  AXOpen.Core.AxoContext         
        VAR PUBLIC
            {#ix-set:AttributeName = "<#Task name#>"}
            _myTask : AxoTask;
            _myCounter : ULINT;
        END_VAR

        METHOD PUBLIC Initialize
            // Initialization of the context needs to be called first
            // It does not need to be called cyclically, just once
            _myTask.Initialize(THIS);
        END_METHOD

        METHOD PROTECTED OVERRIDE Main
            _myTask.Initialize(THIS);
            // Cyclicall call of the Execute
            IF _myTask.Execute() THEN
                _myCounter := _myCounter + ULINT#1;
                _myTask.DoneWhen(_myCounter = ULINT#100);
            END_IF;
            IF _myTask.IsDone() THEN
                _myCounter := ULINT#0;
            END_IF;
        END_METHOD

        METHOD Examples
        //<AxoTaskInvokeDone>
            IF _myTask.Invoke().IsDone() THEN
                ; //Do something
            END_IF;
        //</AxoTaskInvokeDone>

        //<AxoTaskInvokeDoneSeparatelly>
            _myTask.Invoke();

            IF _myTask.IsDone() THEN
                ; //Do something
            END_IF;
        //</AxoTaskInvokeDoneSeparatelly>

        //<AxoTaskRunning>
             IF _myTask.Invoke().IsBusy() THEN
                ; //Do something
            END_IF;
        //</AxoTaskRunning>

        //<AxoTaskError>
            IF _myTask.Invoke().HasError() THEN
                ; //Do something
            END_IF;
        //</AxoTaskError>

        //<AxoTaskInvoke>
            _myTask.Invoke();
        //</AxoTaskInvoke>
        END_METHOD
    END_CLASS  

    //<AxoTaskEventLikeMethods>
    CLASS MyTaskExample EXTENDS AXOpen.Core.AxoTask
        VAR
            OnAbortCounter : ULINT;
            OnResumeCounter : ULINT;
            OnDoneCounter : ULINT;
            OnErrorCounter : ULINT;
            OnRestoreCounter : ULINT;
            OnStartCounter : ULINT;
            WhileErrorCounter : ULINT;
        END_VAR
        METHOD PROTECTED OVERRIDE OnAbort 
            OnAbortCounter := OnAbortCounter + ULINT#1;
        END_METHOD

        METHOD PROTECTED OVERRIDE OnResume 
            OnResumeCounter := OnResumeCounter + ULINT#1;
        END_METHOD

        METHOD PROTECTED OVERRIDE OnDone 
            OnDoneCounter := OnDoneCounter + ULINT#1;
        END_METHOD
    
        METHOD PROTECTED OVERRIDE OnError 
            OnErrorCounter := OnErrorCounter + ULINT#1;
        END_METHOD

        METHOD PROTECTED OVERRIDE OnRestore 
            OnRestoreCounter := OnRestoreCounter + ULINT#1;
        END_METHOD

        METHOD PROTECTED OVERRIDE OnStart 
            OnStartCounter := OnStartCounter + ULINT#1;
        END_METHOD

        METHOD PROTECTED OVERRIDE WhileError 
            WhileErrorCounter := WhileErrorCounter + ULINT#1;
        END_METHOD           
    END_CLASS
    //</AxoTaskEventLikeMethods>
END_NAMESPACE