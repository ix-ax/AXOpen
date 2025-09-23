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
            Enable : ARRAY[0..10] OF BOOL;
        END_VAR

        METHOD PROTECTED OVERRIDE Main    
            THIS.InitializeRootObject(coord);

            IF coord.Open() THEN
            
                Counter := Counter + ULINT#1;

                IF(step_1.Execute(coord,Enable[1])) THEN  
                    IF(Counter >= ULINT#100 ) THEN
                        Counter := ULINT#0;
                        coord.MoveNext();
                    END_IF;    
                END_IF;    
            
                IF(step_2.Execute(coord,Enable[2])) THEN
                    IF(Counter >= ULINT#100) THEN
                        Counter := ULINT#0;
                        coord.MoveNext();
                    END_IF;    
                END_IF; 

                IF(step_3.Execute(coord,Enable[3])) THEN
                    IF(Counter >= ULINT#100) THEN
                        Counter := ULINT#0;
                        coord.MoveNext();
                    END_IF;    
                END_IF; 

                IF(step_4.Execute(coord,Enable[4])) THEN
                    IF(Counter >= ULINT#100) THEN
                        Counter := ULINT#0;
                        coord.MoveNext();
                    END_IF;    
                END_IF; 

                IF(step_5.Execute(coord,Enable[5])) THEN
                    IF(Counter >= ULINT#100) THEN
                        Counter := ULINT#0;
                        coord.MoveNext();
                    END_IF;    
                END_IF; 

                IF(step_6.Execute(coord,Enable[6])) THEN
                    IF(Counter >= ULINT#100) THEN
                        Counter := ULINT#0;
                        coord.MoveNext();
                    END_IF;    
                END_IF; 

                IF(step_7.Execute(coord,Enable[7])) THEN
                    IF(Counter >= ULINT#100) THEN
                        Counter := ULINT#0;
                        coord.MoveNext();
                    END_IF;    
                END_IF; 

                IF(step_8.Execute(coord,Enable[8])) THEN
                    IF(Counter >= ULINT#100) THEN
                        Counter := ULINT#0;
                        coord.MoveNext();
                    END_IF;    
                END_IF; 

                IF(step_9.Execute(coord,Enable[9])) THEN
                    IF(Counter >= ULINT#100) THEN
                        Counter := ULINT#0;
                        coord.MoveNext();
                    END_IF;    
                END_IF; 

                IF(step_10.Execute(coord,Enable[10])) THEN
                    IF(Counter >= ULINT#100) THEN
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
