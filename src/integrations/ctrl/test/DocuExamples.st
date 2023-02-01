USING ix.core;
USING AxUnit;
USING ix.framework.core;

NAMESPACE DocuExamples
    CLASS CommandTaskExample EXTENDS Context         
        VAR PUBLIC
            _myCommandTask : CommandTask;
            _myCounter : ULINT;
        END_VAR
    
        METHOD PUBLIC Initialize
            // Initialization of the context needs to be called first
            // It does not need to be called cyclically, just once
            _myCommandTask.Initialize(THIS);
        END_METHOD

        METHOD PROTECTED OVERRIDE Main
            // Cyclicall call of the Execute
            IF _myCommandTask.Execute() THEN
                _myCounter := _myCounter + ULINT#1;
                _myCommandTask.DoneWhen(_myCounter = ULINT#100);
            END_IF;
        END_METHOD

        METHOD Examples
            // Wait for CommandTask to Complete 
            IF _myCommandTask.Invoke().IsDone() THEN
                ; //Do something
            END_IF;
            // ALTERNATIVELY
            _myCommandTask.Invoke();
            IF _myCommandTask.IsDone() THEN
                ; //Do something ALTERNATIV
            END_IF;

            // Make sure that the command task is executing 
            IF _myCommandTask.Invoke().IsBusy() THEN
                ; //Do something
            END_IF;

            // Check for command task's error 
            IF _myCommandTask.Invoke().HasError() THEN
                ; //Do something
            END_IF;
        END_METHOD
    END_CLASS      

    {TestFixture}
    CLASS CommandTaskTest
        VAR PROTECTED
           _MyContext : CommandTaskExample;
        END_VAR    

        {Test}
        METHOD PUBLIC counter
            VAR
                cycle : INT;
            END_VAR
            Assert.Equal(ULINT#0,_MyContext._myCounter);
            _MyContext.Initialize();
            _MyContext._myCommandTask.Invoke();
            FOR cycle := INT#0 TO INT#99 DO
                _MyContext.Execute();
            END_FOR;
            Assert.Equal(ULINT#100,_MyContext._myCounter);
        END_METHOD
    END_CLASS
END_NAMESPACE
