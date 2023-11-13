USING AXOpen.Core;

NAMESPACE AxoSequencerExamples
 
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
        END_VAR

        METHOD PROTECTED OVERRIDE Main    
            step_1.Initialize(THIS);
            step_2.Initialize(THIS);
            step_3.Initialize(THIS);
            step_4.Initialize(THIS);
            step_5.Initialize(THIS);
            step_6.Initialize(THIS);
            step_7.Initialize(THIS);
            step_8.Initialize(THIS);
            step_9.Initialize(THIS);
            step_10.Initialize(THIS);
            coord.Initialize(THIS);

            IF coord.Open() THEN
            
                Counter := Counter + ULINT#1;

                IF(step_1.Execute(coord)) THEN  
                    IF(Counter >= ULINT#100 ) THEN
                        Counter := ULINT#0;
                        coord.MoveNext();
                    END_IF;    
                END_IF;    
            
                IF(step_2.Execute(coord)) THEN
                    IF(Counter >= ULINT#100) THEN
                        Counter := ULINT#0;
                        coord.MoveNext();
                    END_IF;    
                END_IF; 

                IF(step_3.Execute(coord)) THEN
                    IF(Counter >= ULINT#100) THEN
                        Counter := ULINT#0;
                        step_3.ThrowWhen(TRUE);
                        coord.MoveNext();
                    END_IF;    
                END_IF; 

                IF(step_4.Execute(coord)) THEN
                    IF(Counter >= ULINT#100) THEN
                        Counter := ULINT#0;
                        coord.MoveNext();
                    END_IF;    
                END_IF; 

                IF(step_5.Execute(coord)) THEN
                    IF(Counter >= ULINT#100) THEN
                        Counter := ULINT#0;
                        coord.MoveNext();
                    END_IF;    
                END_IF; 

                IF(step_6.Execute(coord)) THEN
                    IF(Counter >= ULINT#100) THEN
                        Counter := ULINT#0;
                        coord.MoveNext();
                    END_IF;    
                END_IF; 

                IF(step_7.Execute(coord)) THEN
                    IF(Counter >= ULINT#100) THEN
                        Counter := ULINT#0;
                        coord.MoveNext();
                    END_IF;    
                END_IF; 

                IF(step_8.Execute(coord)) THEN
                    IF(Counter >= ULINT#100) THEN
                        Counter := ULINT#0;
                        coord.MoveNext();
                    END_IF;    
                END_IF; 

                IF(step_9.Execute(coord)) THEN
                    IF(Counter >= ULINT#100) THEN
                        Counter := ULINT#0;
                        coord.MoveNext();
                    END_IF;    
                END_IF; 

                IF(step_10.Execute(coord)) THEN
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
