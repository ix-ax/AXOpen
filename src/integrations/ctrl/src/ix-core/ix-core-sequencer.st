
NAMESPACE core
    using ix.framework.core;

    CLASS SequencerExample EXTENDS ix.framework.core.Context
        VAR PUBLIC
            {#ix-set:AttributeName = "<#Sequencer example#>"}
            coord : Sequencer;  
            Counter : ULINT;
        END_VAR    
            
        VAR PUBLIC 
            {#ix-set:Description = "Step number one"}
            step_1 : Step; 
            {#ix-set:Description = "Step number two"}
            step_2 : Step; 
            {#ix-set:Description = "Step number three"}
            step_3 : Step; 
            {#ix-set:Description = "Step number four"}
            step_4 : Step;
            {#ix-set:Description = "Step number five"}
            step_5 : Step;
            {#ix-set:Description = "Step number six"}
            step_6 : Step;
            {#ix-set:Description = "Step number seven"}
            step_7 : Step;
            {#ix-set:Description = "Step number eight"}
            step_8 : Step;
            {#ix-set:Description = "Step number nine"}
            step_9 : Step;
            {#ix-set:Description = "Step number ten"}
            step_10 : Step;
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

            coord.Open();
            
            IF(step_1.Execute(coord)) THEN  
                Counter := Counter + ULINT#1;
                IF(Counter >= ULINT#100) THEN
                    Counter := ULINT#0;
                    coord.MoveNext();
                END_IF;    
            END_IF;    
           
            IF(step_2.Execute(coord)) THEN
                Counter := Counter + ULINT#1;
                IF(Counter >= ULINT#100) THEN
                    Counter := ULINT#0;
                    coord.MoveNext();
                END_IF;    
            END_IF; 

            IF(step_3.Execute(coord)) THEN
                Counter := Counter + ULINT#1;
                IF(Counter >= ULINT#100) THEN
                    Counter := ULINT#0;
                    step_3.ThrowWhen(TRUE);
                    coord.MoveNext();
                END_IF;    
            END_IF; 

            IF(step_4.Execute(coord)) THEN
                Counter := Counter + ULINT#1;
                IF(Counter >= ULINT#100) THEN
                    Counter := ULINT#0;
                    coord.MoveNext();
                END_IF;    
            END_IF; 

            IF(step_5.Execute(coord)) THEN
                Counter := Counter + ULINT#1;
                IF(Counter >= ULINT#100) THEN
                    Counter := ULINT#0;
                    coord.MoveNext();
                END_IF;    
            END_IF; 

            IF(step_6.Execute(coord)) THEN
                Counter := Counter + ULINT#1;
                IF(Counter >= ULINT#100) THEN
                    Counter := ULINT#0;
                    coord.MoveNext();
                END_IF;    
            END_IF; 

            IF(step_7.Execute(coord)) THEN
                Counter := Counter + ULINT#1;
                IF(Counter >= ULINT#100) THEN
                    Counter := ULINT#0;
                    coord.MoveNext();
                END_IF;    
            END_IF; 

            IF(step_8.Execute(coord)) THEN
                Counter := Counter + ULINT#1;
                IF(Counter >= ULINT#100) THEN
                    Counter := ULINT#0;
                    coord.MoveNext();
                END_IF;    
            END_IF; 

            IF(step_9.Execute(coord)) THEN
                Counter := Counter + ULINT#1;
                IF(Counter >= ULINT#100) THEN
                    Counter := ULINT#0;
                    coord.MoveNext();
                END_IF;    
            END_IF; 

            IF(step_10.Execute(coord)) THEN
                Counter := Counter + ULINT#1;
                IF(Counter >= ULINT#100) THEN
                    Counter := ULINT#0;
                    coord.CompleteSequence();
                END_IF;    
            END_IF; 
        END_METHOD
END_CLASS    
END_NAMESPACE
