USING AXOpen.Core;

NAMESPACE AxoSequencerExamples
    {S7.extern=ReadWrite}
    CLASS AxoSequencerDocuExample EXTENDS  AXOpen.Core.AxoContext
        VAR PUBLIC
            _mySequencer : AXOpen.Core.AxoSequencer;
            _step_1 : AxoStep;
            _step_2 : AxoStep;
            _step_3 : AxoStep;
            _myCounter : ULINT;
        END_VAR
    
        //<Initialize>
        METHOD PUBLIC Initialize
            _mySequencer.Initialize(THIS);
            _step_1.Initialize(THIS);
            _step_2.Initialize(THIS);
            _step_3.Initialize(THIS);
        END_METHOD
        //</Initialize>

        METHOD PROTECTED OVERRIDE Main
            //<Open>
            THIS.Initialize();    
            IF _mySequencer.Open() THEN
                //All sequence logic needs to be placed inside the condition
                _myCounter := _myCounter + ULINT#1;

                IF _step_1.Execute(_mySequencer) THEN
                    IF (_myCounter > ULINT#50) THEN
                        _mySequencer.MoveNext();
                    END_IF;
                END_IF;

                IF _step_2.Execute(_mySequencer) THEN
                    IF (_myCounter > ULINT#100) THEN
                        _mySequencer.MoveNext();
                    END_IF;
                END_IF;

                IF _step_3.Execute(_mySequencer) THEN
                    IF (_myCounter > ULINT#150) THEN
                        _myCounter := ULINT#0;
                        _mySequencer.CompleteSequence();
                    END_IF;
                END_IF;
            END_IF;
            //</Open>
        END_METHOD   

        METHOD StepExamples
            //<SimpleStep>
            IF _step_1.Execute(_mySequencer) THEN
                _myCounter := _myCounter + ULINT#1;
                // do something
                IF (_myCounter MOD ULINT#5) = ULINT#0 THEN
                    // continue to the next step of the sequence
                    _mySequencer.MoveNext();
                END_IF;
            END_IF;
            //</SimpleStep>

            //<EnableStep>
                IF _step_2.Execute(coord := _mySequencer, Enable := _myCounter <= ULINT#20) THEN
                    _myCounter := _myCounter + ULINT#1;
                    IF _myCounter = ULINT#20 THEN
                        // Jumping to step 1. As it is jumping backwards, the execution of step 1  
                        // is going to be started in the next context cycle.
                        _mySequencer.RequestStep(_step_1);
                    END_IF;
                END_IF;
            //</EnableStep>

            //<FullStep>
                IF _step_3.Execute(coord := _mySequencer, Enable := TRUE, Description := 'This is a description of the step 3' ) THEN
                    _myCounter := _myCounter + ULINT#1;
                    IF (_myCounter MOD ULINT#7) = ULINT#0 THEN
                        // Finalize the sequence and initiate the execution from the first step.
                        _mySequencer.CompleteSequence();
                    END_IF;
                END_IF;
            //</FullStep>
        END_METHOD   
    END_CLASS
END_NAMESPACE
