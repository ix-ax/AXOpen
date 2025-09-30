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
        METHOD PROTECTED OVERRIDE MAIN 
            // _step_1.Initialize(THIS);
            // _step_2.Initialize(THIS);
            // _step_3.Initialize(THIS);

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

    {S7.extern=ReadWrite}
    CLASS AxoSequencerContainerContext EXTENDS  AXOpen.Core.AxoContext
        //<InstanceDeclaration>
        VAR PUBLIC
            _mySequencerContainer : AxoSequencerContainerDocuExample;
        END_VAR
        //</InstanceDeclaration>
    
        VAR PRIVATE
            _rootObject :   AxoObject;
        END_VAR
        METHOD PROTECTED OVERRIDE Main
            //<InstanceRunning>
            _mySequencerContainer.Run(_rootObject);
            //</InstanceRunning>
        END_METHOD
    END_CLASS
END_NAMESPACE
