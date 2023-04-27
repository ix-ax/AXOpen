USING axosimple;
CONFIGURATION MyConfiguration
    TASK Main(Interval := T#25ms, Priority := 1);
    PROGRAM P1 WITH Main: MyProgram;

    VAR_GLOBAL  
        Inputs : axosimple.Inputs;
        Outputs : axosimple.Outputs;    
        Context : axosimple.Context;     
    END_VAR
END_CONFIGURATION
