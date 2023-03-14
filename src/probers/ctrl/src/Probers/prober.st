NAMESPACE ix.framework.probers
    CLASS PUBLIC ABSTRACT ProberWithCounterBase EXTENDS ix.framework.core.IxTask
        VAR PUBLIC                    
            RequredNumberOfCycles : ULINT;
            CurrentCyclesCount : ULINT;
            FailureDescription : STRING[254];     
        END_VAR
        
        METHOD PUBLIC Run            
            IF(THIS.Execute()) THEN               
                CurrentCyclesCount := CurrentCyclesCount + ULINT#1; 
                THIS.Test();          
                THIS.DoneWhen(CurrentCyclesCount >= RequredNumberOfCycles); 
            END_IF;    
        END_METHOD

        METHOD PROTECTED ABSTRACT Test
             
        END_METHOD 
        
        METHOD OVERRIDE OnRestore                             
            CurrentCyclesCount := ULINT#0;
            RequredNumberOfCycles := ULINT#0;    
            FailureDescription := '';         
        END_METHOD  
    END_CLASS
   
    CLASS PUBLIC ABSTRACT ProberWithCompletedCondition EXTENDS ix.framework.core.IxTask
        VAR PUBLIC                    
            FailureDescription : STRING[254];            
        END_VAR
        
        METHOD PUBLIC Run            
            IF(THIS.Execute()) THEN                                                         
                THIS.DoneWhen(THIS.Test()); 
            END_IF;    
        END_METHOD

        METHOD PROTECTED ABSTRACT Test : BOOL
             
        END_METHOD 
        
        METHOD OVERRIDE OnRestore                             
            FailureDescription := '';  
        END_METHOD  
    END_CLASS
END_NAMESPACE