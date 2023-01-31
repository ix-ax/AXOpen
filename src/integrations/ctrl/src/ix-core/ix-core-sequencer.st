
NAMESPACE core
    using ix.framework.core;

    CLASS SequencerExample EXTENDS ix.framework.core.Context
        VAR PUBLIC
            coord : Sequencer;        
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
        END_VAR
        
        METHOD PROTECTED OVERRIDE Main    
            step_1.Initialize(THIS);
            step_2.Initialize(THIS);
            step_3.Initialize(THIS);
            step_4.Initialize(THIS);
            coord.Initialize(THIS);

            coord.Open();
            
            IF(step_1.Execute(coord)) THEN  
                IF((THIS.OpenCycleCount() MOD ULINT#1000) = ULINT#0) THEN
                    coord.MoveNext();
                END_IF;    
            END_IF;    
           
            IF(step_2.Execute(coord)) THEN
                IF((THIS.OpenCycleCount() MOD ULINT#1250) = ULINT#0) THEN
                    coord.MoveNext();
                END_IF;    
            END_IF; 

            IF(step_3.Execute(coord)) THEN
                IF((THIS.OpenCycleCount() MOD ULINT#1500) = ULINT#0) THEN
                    coord.MoveNext();
                END_IF;    
            END_IF; 
            IF(step_4.Execute(coord)) THEN
                IF((THIS.OpenCycleCount() MOD ULINT#3500) = ULINT#0) THEN
                    coord.MoveNext();
                END_IF;    
            END_IF; 
        END_METHOD
END_CLASS    
END_NAMESPACE
