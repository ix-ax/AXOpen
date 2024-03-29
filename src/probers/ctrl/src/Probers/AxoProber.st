USING AXOpen.Core;
NAMESPACE AXOpen.Probers   
    {S7.extern=ReadWrite}
    CLASS PUBLIC ABSTRACT AxoProberWithCounterBase EXTENDS AXOpen.Core.AxoTask
        VAR PUBLIC                    
            RequredNumberOfCycles : ULINT;
            CurrentCyclesCount : ULINT;           
        END_VAR
     
        METHOD PRIVATE Run
            IF(THIS.Execute()) THEN               
                CurrentCyclesCount := CurrentCyclesCount + ULINT#1; 
                THIS.Test();          
                THIS.DoneWhen(CurrentCyclesCount >= RequredNumberOfCycles); 
            END_IF;   
        END_METHOD    

        METHOD PUBLIC Run            
            VAR_INPUT
                Parent : IAxoObject;
            END_VAR    
            THIS.Initialize(Parent);
            THIS.Run();
        END_METHOD

        METHOD PUBLIC Run            
            VAR_INPUT
                Context : IAxoContext;
            END_VAR    
            THIS.Initialize(Context);
            THIS.Run();
        END_METHOD

        METHOD PROTECTED ABSTRACT Test
             
        END_METHOD 
        
        METHOD OVERRIDE OnRestore                             
            CurrentCyclesCount := ULINT#0;
            RequredNumberOfCycles := ULINT#0;                  
        END_METHOD  
    END_CLASS
   
    {S7.extern=ReadWrite}
    CLASS PUBLIC ABSTRACT AxoProberWithCompletedCondition EXTENDS AXOpen.Core.AxoTask                
        METHOD PRIVATE Run
            IF(THIS.Execute()) THEN                                                         
                THIS.DoneWhen(THIS.Test());                 
            END_IF;    
        END_METHOD    

        METHOD PUBLIC Run            
            VAR_INPUT
                Parent : IAxoObject;
            END_VAR    
            THIS.Initialize(Parent);
            THIS.Run();
        END_METHOD

        METHOD PUBLIC Run            
            VAR_INPUT
                Context : IAxoContext;
            END_VAR    
            THIS.Initialize(Context);
            THIS.Run();
        END_METHOD

        METHOD PROTECTED ABSTRACT Test : BOOL
             
        END_METHOD              
    END_CLASS
END_NAMESPACE
