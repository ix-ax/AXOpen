USING sandboxtest;
CONFIGURATION MyConfiguration
   
    //  1 (lowest) to 26 (highest). 15-monitoring task 
   
    TASK Main(Interval := T#20ms, Priority := 2);
    PROGRAM P1 WITH Main: MyProgram;

    VAR_GLOBAL  
        Inputs : sandboxtest.Inputs;
        Outputs : sandboxtest.Outputs;    
        Context : sandboxtest.Context;     
        S71500Rtc :  AXOpen.S71500.Rtc;  
        ContextLogger : AXOpen.Logging.AxoLogger;       
    END_VAR

END_CONFIGURATION
