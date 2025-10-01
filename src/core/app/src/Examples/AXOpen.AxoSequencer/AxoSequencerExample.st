USING AXOpen.Core;

NAMESPACE AxoSequencerExamples

    {S7.extern=ReadWrite}
    CLASS SequencerExample EXTENDS  AXOpen.Core.AxoContext
        VAR PUBLIC
            {#ix-set:AttributeName = "<#Sequencer example#>"}
            coord : AxoSequencer;  
            Counter : ULINT;
            {#ix-set:AttributeName = "<#MicroStep-should be set to zero when entering new step#>"}
            MicroStep : UINT;
        END_VAR    
            
        VAR PUBLIC 
            {#ix-set:Description = "Step number one"}
            step_1 : AxoStep; 
            {#ix-set:Description = "Step number two"}
            step_2 : AxoStep; 
            {#ix-set:Description = "Step number three"}
            step_3 : AxoStep; 
            {#ix-set:Description = "Step number four"}
            step_4 : AxoStep;
            {#ix-set:Description = "Step number five"}
            step_5 : AxoStep;
            {#ix-set:Description = "Step number six"}
            step_6 : AxoStep;
            {#ix-set:Description = "Step number seven"}
            step_7 : AxoStep;
            {#ix-set:Description = "Step number eight"}
            step_8 : AxoStep;
            {#ix-set:Description = "Step number nine"}
            step_9 : AxoStep;
            {#ix-set:Description = "Step number ten"}
            step_10 : AxoStep;
            Enable : ARRAY[1..10] OF BOOL :=[10(TRUE)];
        END_VAR

        METHOD PROTECTED OVERRIDE Main    
            THIS.InitializeRootObject(coord);

            IF coord.Open() THEN
            
                IF(step_1.Execute(coord,Enable[1], 'Step_1')) THEN  
                    IF step_1.IsFirstEntryToStep() THEN
                        Counter := ULINT#100;
                    END_IF;
                    Counter := Counter + ULINT#1;
                    IF(Counter >= ULINT#200 ) THEN
                        Counter := ULINT#0;
                        coord.MoveNext();
                    END_IF;    
                END_IF;    
            
                IF(step_2.Execute(coord,Enable[2], 'Step_2')) THEN
                    IF step_2.IsFirstEntryToStep() THEN
                        Counter := ULINT#200;
                    END_IF;
                    Counter := Counter + ULINT#1;
                    IF(Counter >= ULINT#300 ) THEN
                        Counter := ULINT#0;
                        coord.MoveNext();
                    END_IF;    
                END_IF; 

                IF(step_3.Execute(coord,Enable[3], 'Step_3')) THEN
                    IF step_3.IsFirstEntryToStep() THEN
                        Counter := ULINT#300;
                    END_IF;
                    Counter := Counter + ULINT#1;
                    IF(Counter >= ULINT#400 ) THEN
                        Counter := ULINT#0;
                        coord.MoveNext();
                    END_IF;    
                END_IF; 

                IF(step_4.Execute(coord,Enable[4], 'Step_4')) THEN
                    IF step_4.IsFirstEntryToStep() THEN
                        Counter := ULINT#400;
                    END_IF;
                    Counter := Counter + ULINT#1;
                    IF(Counter >= ULINT#500 ) THEN
                        Counter := ULINT#0;
                        coord.MoveNext();
                    END_IF;    
                END_IF; 

                IF(step_5.Execute(coord,Enable[5], 'Step_5')) THEN
                    IF step_5.IsFirstEntryToStep() THEN
                        Counter := ULINT#500;
                    END_IF;
                    Counter := Counter + ULINT#1;
                    IF(Counter >= ULINT#600 ) THEN
                        Counter := ULINT#0;
                        coord.MoveNext();
                    END_IF;    
                END_IF; 

                IF(step_6.Execute(coord,Enable[6], 'Step_6')) THEN
                    IF step_6.IsFirstEntryToStep() THEN
                        Counter := ULINT#600;
                    END_IF;
                    Counter := Counter + ULINT#1;
                    IF(Counter >= ULINT#700 ) THEN
                        Counter := ULINT#0;
                        coord.MoveNext();
                    END_IF;    
                END_IF; 

                IF(step_7.Execute(coord,Enable[7], 'Step_7')) THEN
                    IF step_7.IsFirstEntryToStep() THEN
                        Counter := ULINT#700;
                    END_IF;
                    Counter := Counter + ULINT#1;
                    IF(Counter >= ULINT#800 ) THEN
                        Counter := ULINT#0;
                        coord.RequestStep(step_1);
                        // coord.MoveNext();
                    END_IF;    
                END_IF; 

                IF(step_8.Execute(coord,Enable[8], 'Step_8')) THEN
                    IF step_8.IsFirstEntryToStep() THEN
                        Counter := ULINT#800;
                    END_IF;
                    Counter := Counter + ULINT#1;
                    IF(Counter >= ULINT#900 ) THEN
                        Counter := ULINT#0;
                        coord.MoveNext();
                    END_IF;    
                END_IF; 

                IF(step_9.Execute(coord,Enable[9], 'Step_9')) THEN
                    IF step_9.IsFirstEntryToStep() THEN
                        Counter := ULINT#900;
                    END_IF;
                    Counter := Counter + ULINT#1;
                    IF(Counter >= ULINT#1000 ) THEN
                        Counter := ULINT#0;
                        coord.MoveNext();
                    END_IF;    
                END_IF; 

                IF(step_10.Execute(coord,Enable[10], 'Step_10')) THEN
                    IF step_10.IsFirstEntryToStep() THEN
                        Counter := ULINT#1000;
                    END_IF;
                    Counter := Counter + ULINT#1;
                    IF(Counter >= ULINT#1100 ) THEN
                        Counter := ULINT#0;
                        coord.CompleteSequence();
                    END_IF;    
                END_IF; 
                coord.SetMicroStepValue(coord.GetMicroStepValue() + UINT#2);
                MicroStep := coord.GetMicroStepValue();
            END_IF; 

        END_METHOD
    END_CLASS    
END_NAMESPACE
