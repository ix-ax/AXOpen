USING axosimple;
PROGRAM MyProgram
    VAR_EXTERNAL        
        Inputs : axosimple.Inputs;
        Outputs : axosimple.Outputs;          
        Context : axosimple.Context; 
        S71500Rtc :  AXOpen.S71500.Rtc;   
        ContextLogger : AXOpen.Logging.AxoLogger;           
    END_VAR
    
    // Never modif this the context needs references to IN/OUT structures before it is used.
    Context.Inputs := REF(Inputs);
    Context.Outputs := REF(Outputs);
   
    ContextLogger.SetMinimumLevel(AXOpen.Logging.eLogLevel#Warning);
    Context.InjectRtc(S71500Rtc);
    Context.InjectLogger(ContextLogger);
    // Executes the main context of this application.
    Context.Run();     
END_PROGRAM
