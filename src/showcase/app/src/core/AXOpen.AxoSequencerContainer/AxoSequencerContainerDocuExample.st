USING AXOpen.Core;

NAMESPACE AxoSequencerContainerExamples
    {S7.extern=ReadWrite}
    CLASS AxoSequencerContainerDocuExample EXTENDS  AXOpen.Core.AxoSequencerContainer
        VAR PUBLIC
            _step_1 : AxoStep;
            _step_s : ARRAY[0..10] OF AxoStep;
            _myCounter : ULINT;
        END_VAR
        //<MAIN>
        METHOD PROTECTED OVERRIDE Main
            _myCounter := _myCounter + ULINT#1;

            IF(_step_1.Execute(THIS)) THEN
                IF(_myCounter >= ULINT#100 ) THEN
                    _myCounter := ULINT#0;
                    THIS.MoveNext();
                END_IF;
            END_IF;

            IF(_step_s[0].Execute(THIS)) THEN
                IF(_myCounter >= ULINT#100) THEN
                    _myCounter := ULINT#0;
                    THIS.MoveNext();
                END_IF;
            END_IF;

            IF(_step_s[1].Execute(THIS)) THEN
                IF(_myCounter >= ULINT#100) THEN
                    _myCounter := ULINT#0;
                    THIS.MoveNext();
                END_IF;
            END_IF;

            IF(_step_s[2].Execute(THIS)) THEN
                IF(_myCounter >= ULINT#100) THEN
                    _myCounter := ULINT#0;
                    THIS.MoveNext();
                END_IF;
            END_IF;

            IF(_step_s[3].Execute(THIS)) THEN
                IF(_myCounter >= ULINT#100) THEN
                    _myCounter := ULINT#0;
                    THIS.MoveNext();
                END_IF;
            END_IF;

            IF(_step_s[4].Execute(THIS)) THEN
                IF(_myCounter >= ULINT#100) THEN
                    _myCounter := ULINT#0;
                    THIS.MoveNext();
                END_IF;
            END_IF;

            IF(_step_s[5].Execute(THIS)) THEN
                IF(_myCounter >= ULINT#100) THEN
                    _myCounter := ULINT#0;
                    THIS.MoveNext();
                END_IF;
            END_IF;

            IF(_step_s[6].Execute(THIS)) THEN
                IF(_myCounter >= ULINT#100) THEN
                    _myCounter := ULINT#0;
                    THIS.MoveNext();
                END_IF;
            END_IF;

            IF(_step_s[7].Execute(THIS)) THEN
                IF(_myCounter >= ULINT#100) THEN
                    _myCounter := ULINT#0;
                    THIS.MoveNext();
                END_IF;
            END_IF;

            IF(_step_s[8].Execute(THIS)) THEN
                IF(_myCounter >= ULINT#100) THEN
                    _myCounter := ULINT#0;
                    THIS.MoveNext();
                END_IF;
            END_IF;

            IF(_step_s[9].Execute(THIS)) THEN
                IF(_myCounter >= ULINT#100) THEN
                    _myCounter := ULINT#0;
                    THIS.MoveNext();
                END_IF;
            END_IF;

            IF(_step_s[10].Execute(THIS)) THEN
                IF(_myCounter >= ULINT#100) THEN
                    _myCounter := ULINT#0;
                    THIS.CompleteSequence();
                END_IF;
            END_IF;
        END_METHOD
        //</MAIN>
    END_CLASS

    //<SequenceMode>
    {S7.extern=ReadWrite}
    CLASS AxoSequencerContainerRunOnceExample EXTENDS AXOpen.Core.AxoSequencerContainer
        VAR PUBLIC
            _restoreStep : AxoStep;
            _processStep : AxoStep;
            _checkStep : AxoStep;
            _finalStep : AxoStep;
            _myCounter : ULINT;
            _checkPassed : BOOL;
        END_VAR

        METHOD PROTECTED OVERRIDE Main
            // RunOnce mode: sequence executes once and stays Done
            THIS.SequenceMode := eAxoSequenceMode#RunOnce;

            _myCounter := _myCounter + ULINT#1;

            IF(_restoreStep.Execute(THIS, TRUE, '<#RESTORE STATE#>')) THEN
                _myCounter := ULINT#0;
                _checkPassed := FALSE;
                THIS.MoveNext();
            END_IF;

            IF(_processStep.Execute(THIS, TRUE, '<#PROCESS DATA#>')) THEN
                IF(_myCounter >= ULINT#100) THEN
                    _myCounter := ULINT#0;
                    THIS.MoveNext();
                END_IF;
            END_IF;

            IF(_checkStep.Execute(THIS, TRUE, '<#CHECK RESULT#>')) THEN
                IF(_myCounter >= ULINT#50) THEN
                    _myCounter := ULINT#0;
                    IF _checkPassed THEN
                        THIS.MoveNext();
                    ELSE
                        // Branch back to process step on failure
                        THIS.RequestStep(_processStep);
                    END_IF;
                END_IF;
            END_IF;

            IF(_finalStep.Execute(THIS, TRUE, '<#FINALIZE#>')) THEN
                THIS.CompleteSequence();
            END_IF;
        END_METHOD
    END_CLASS
    //</SequenceMode>

    //<RequestStep>
    {S7.extern=ReadWrite}
    CLASS AxoSequencerContainerBranchingExample EXTENDS AXOpen.Core.AxoSequencerContainer
        VAR PUBLIC
            _initStep : AxoStep;
            _evaluateStep : AxoStep;
            _pathAStep : AxoStep;
            _pathBStep : AxoStep;
            _doneStep : AxoStep;
            _condition : BOOL;
            _myCounter : ULINT;
        END_VAR

        METHOD PROTECTED OVERRIDE Main
            THIS.SequenceMode := eAxoSequenceMode#Cyclic;

            _myCounter := _myCounter + ULINT#1;

            IF(_initStep.Execute(THIS, TRUE, '<#INITIALIZE#>')) THEN
                _myCounter := ULINT#0;
                THIS.MoveNext();
            END_IF;

            IF(_evaluateStep.Execute(THIS, TRUE, '<#EVALUATE CONDITION#>')) THEN
                // Branch to different steps based on condition
                IF _condition THEN
                    THIS.RequestStep(_pathAStep);
                ELSE
                    THIS.RequestStep(_pathBStep);
                END_IF;
            END_IF;

            IF(_pathAStep.Execute(THIS, TRUE, '<#PATH A - CONDITION MET#>')) THEN
                IF(_myCounter >= ULINT#100) THEN
                    _myCounter := ULINT#0;
                    THIS.RequestStep(_doneStep);
                END_IF;
            END_IF;

            IF(_pathBStep.Execute(THIS, TRUE, '<#PATH B - CONDITION NOT MET#>')) THEN
                IF(_myCounter >= ULINT#100) THEN
                    _myCounter := ULINT#0;
                    THIS.RequestStep(_doneStep);
                END_IF;
            END_IF;

            IF(_doneStep.Execute(THIS, TRUE, '<#COMPLETE#>')) THEN
                THIS.CompleteSequence();
            END_IF;
        END_METHOD
    END_CLASS
    //</RequestStep>

    {S7.extern=ReadWrite}
    CLASS AxoSequencerContainerContext EXTENDS  AXOpen.Core.AxoObject
        //<InstanceDeclaration>
        VAR PUBLIC
            _mySequencerContainer : AxoSequencerContainerDocuExample;
        END_VAR
        //</InstanceDeclaration>
    
        VAR PRIVATE
            _rootObject :   AxoObject;
        END_VAR
        METHOD PUBLIC Execute
            //<InstanceRunning>
            _mySequencerContainer.Run(_rootObject);
            //</InstanceRunning>
        END_METHOD
    END_CLASS
END_NAMESPACE
