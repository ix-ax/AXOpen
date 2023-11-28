USING AXOpen.Core;

NAMESPACE AxoSequencerContainerExamples
    {S7.extern=ReadWrite}
    CLASS AxoSequencerContainerDocuExample EXTENDS  AXOpen.Core.AxoSequencerContainer
        VAR PUBLIC
            _step_1 : AxoStep;
            _step_2 : AxoStep;
            _step_3 : AxoStep;
            _myCounter : ULINT;
        END_VAR
        //<MAIN>
        METHOD PROTECTED OVERRIDE MAIN 
            _step_1.Initialize(THIS);
            _step_2.Initialize(THIS);
            _step_3.Initialize(THIS);

            _myCounter := _myCounter + ULINT#1;

            IF(_step_1.Execute(THIS)) THEN  
                IF(_myCounter >= ULINT#100 ) THEN
                    _myCounter := ULINT#0;
                    THIS.MoveNext();
                END_IF;    
            END_IF;    
        
            IF(_step_2.Execute(THIS)) THEN
                IF(_myCounter >= ULINT#100) THEN
                    _myCounter := ULINT#0;
                    THIS.MoveNext();
                END_IF;    
            END_IF; 

            IF(_step_3.Execute(THIS)) THEN
                IF(_myCounter >= ULINT#100) THEN
                    _myCounter := ULINT#0;
                    _step_3.ThrowWhen(TRUE);
                    THIS.CompleteSequence();
                END_IF;    
            END_IF; 
        END_METHOD
        //</MAIN>
    END_CLASS

    {S7.extern=ReadWrite}
    CLASS AxoSequencerContainerContext EXTENDS  AXOpen.Core.AxoContext
        //<InstanceDeclaration>
        VAR PUBLIC
            _mySequencerContainer : AxoSequencerContainerDocuExample;
        END_VAR
        //</InstanceDeclaration>
    

        METHOD PROTECTED OVERRIDE Main
            //<InstanceRunning>
            _mySequencerContainer.Run(THIS);
            //</InstanceRunning>
        END_METHOD   

    END_CLASS
END_NAMESPACE
