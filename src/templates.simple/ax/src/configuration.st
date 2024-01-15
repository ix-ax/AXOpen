USING axosimple;
CONFIGURATION MyConfiguration
    TASK Main(Interval := T#10ms, Priority := 1);
    PROGRAM P1 WITH Main: MyProgram;

    VAR_GLOBAL     
        {S7.extern=ReadWrite}                   
        Inputs : axosimple.Inputs;
        {S7.extern=ReadWrite}  
        Outputs : axosimple.Outputs;    
        {S7.extern=ReadWrite}  
        Context : axosimple.Context;     
        {S7.extern=ReadWrite}  
        S71500Rtc :  AXOpen.S71500.Rtc;  
        {S7.extern=ReadWrite}  
        ContextLogger : AXOpen.Logging.AxoLogger;       
    END_VAR

END_CONFIGURATION
