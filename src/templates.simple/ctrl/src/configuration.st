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

    //Copy this VAR_GLOBAL section into your configuration file inside your project.
	//Do not change any names, addresses or any another content.
	VAR_GLOBAL
		HwInputs AT %IB0 : HwInputs;
		HwOutputs AT %QB0 : HwOutputs;
		PlcInputs : PlcInputs;
		PlcOutputs : PlcOutputs;
	END_VAR

END_CONFIGURATION
