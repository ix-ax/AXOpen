USING axosimple;
CONFIGURATION MyConfiguration
    TASK Main(Interval := T#10ms, Priority := 1);
    PROGRAM P1 WITH Main: MyProgram;

    VAR_GLOBAL  
        Inputs : axosimple.Inputs;
        Outputs : axosimple.Outputs;    
        Context : axosimple.Context;     
        S71500Rtc :  AXOpen.S71500.Rtc;  
        ContextLogger : AXOpen.Logging.AxoLogger;       
    END_VAR
END_CONFIGURATION
