USING ix.core;
USING AxUnit;
USING ix.framework.core;

NAMESPACE DocuExamples
    CLASS IxTaskExample EXTENDS IxContext         
        VAR PUBLIC
            _myTask : IxTask;
            _myCounter : ULINT;
        END_VAR
    
        METHOD PUBLIC Initialize
            // Initialization of the context needs to be called first
            // It does not need to be called cyclically, just once
            _myTask.Initialize(THIS);
        END_METHOD

        METHOD PROTECTED OVERRIDE Main
            // Cyclicall call of the Execute
            IF _myTask.Execute() THEN
                _myCounter := _myCounter + ULINT#1;
                _myTask.DoneWhen(_myCounter = ULINT#100);
            END_IF;
        END_METHOD

        METHOD Examples
            // Wait for IxTask to Complete 
            IF _myTask.Invoke().IsDone() THEN
                ; //Do something
            END_IF;
            // ALTERNATIVELY
            _myTask.Invoke();
            IF _myTask.IsDone() THEN
                ; //Do something ALTERNATIV
            END_IF;

            // Make sure that the IxTask is executing 
            IF _myTask.Invoke().IsBusy() THEN
                ; //Do something
            END_IF;

            // Check for IxTask's error 
            IF _myTask.Invoke().HasError() THEN
                ; //Do something
            END_IF;
        END_METHOD
    END_CLASS      

    {TestFixture}
    CLASS IxTaskTest
        VAR PROTECTED
           _MyContext : IxTaskExample;
        END_VAR    

        {Test}
        METHOD PUBLIC counter_inside_task_should_have_value_of_100
            VAR
                cycle : INT;
            END_VAR
            Assert.Equal(ULINT#0,_MyContext._myCounter);
            _MyContext.Initialize();
            _MyContext._myTask.Invoke();
            FOR cycle := INT#0 TO INT#99 DO
                _MyContext.Execute();
            END_FOR;
            Assert.Equal(TRUE,_MyContext._myTask.IsDone());
            Assert.Equal(ULINT#100,_MyContext._myCounter);
        END_METHOD
    END_CLASS

    CLASS IxSequencerExample EXTENDS IxContext
        VAR PUBLIC
            _mySequencer : IxSequencer;
            _step_1 : IxStep;
            _step_2 : IxStep;
            _step_3 : IxStep;
            _myCounter : ULINT;
        END_VAR
    
        METHOD PUBLIC Initialize
            // Initialization of the context needs to be called first
            // It does not need to be called cyclically, just once
            _mySequencer.Initialize(THIS);
            _step_1.Initialize(THIS);
            _step_2.Initialize(THIS);
            _step_3.Initialize(THIS);
        END_METHOD

        METHOD PROTECTED OVERRIDE Main
            _mySequencer.Open();

            // Example of the most simple use of Execute() method of step class, only with IxCoordinator defined. 
            IF _step_1.Execute(_mySequencer) THEN
                // do something
                _myCounter := _myCounter + ULINT#1;
                IF (_myCounter MOD ULINT#5) = ULINT#0 THEN
                    // continue to the next step of the sequence
                    _mySequencer.MoveNext();
                END_IF;
            END_IF;

            // Example of use of the Execute() method of step class with Enable condition.
            // This step is going to be executed just in the first run of the sequence,
            // as during the second run, the Enable parameter will have the value of FALSE.
            IF _step_2.Execute(coord := _mySequencer, Enable := _myCounter <= ULINT#20) THEN
                _myCounter := _myCounter + ULINT#1;
                IF _myCounter = ULINT#20 THEN
                    // Jumping to step 1. As it is jumping backwards, the execution of step 1  
                    // is going to be started in the next context cycle.
                    _mySequencer.RequestStep(_step_1);
                END_IF;
            END_IF;

            // Example of use of the Execute() method of step class with all three parameters defined.
            IF _step_3.Execute(coord := _mySequencer, Enable := TRUE, Description := 'This is a description of the step 3' ) THEN
                _myCounter := _myCounter + ULINT#1;
                IF (_myCounter MOD ULINT#7) = ULINT#0 THEN
                    // Finalize the sequence and initiate the execution from the first step.
                    _mySequencer.CompleteSequence();
                END_IF;
            END_IF;
        END_METHOD   
    END_CLASS

    {TestFixture}
    CLASS IxSequencerTest
        VAR PROTECTED
            _MyContext : IxSequencerExample;
        END_VAR    

        {Test}
        METHOD PUBLIC counter
            VAR
                cycle : INT;
            END_VAR
            Assert.Equal(ULINT#0,_MyContext._myCounter);
            _MyContext.Initialize();
            _MyContext._mySequencer.Invoke();
            FOR cycle := INT#1 TO INT#96 DO
                _MyContext.Execute();
            END_FOR;
            Assert.Equal(TRUE,_MyContext._step_3.IsBusy());
            Assert.Equal(ULINT#97,_MyContext._myCounter);
        END_METHOD
    END_CLASS

END_NAMESPACE
