USING axosimple;
PROGRAM MyProgram
    VAR_EXTERNAL        
        Inputs : axosimple.Inputs;
        Outputs : axosimple.Outputs;          
        Context : axosimple.Context; 
        S71500Rtc :  AXOpen.S71500.Rtc;   
        ContextLogger : AXOpen.Logging.AxoLogger;           
    END_VAR
    
    //Copy this VAR_EXTERNAL section into the declaration part of your main program file inside your project.
	//Do not change any names, addresses or any another content.
	VAR_EXTERNAL
		PlcInputs : PlcInputs;
		PlcOutputs : PlcOutputs;
	END_VAR
	//Copy this function call at the very beginning of your program.
	//Do not change any names, addresses or any another content.
	CopyInputs();

    //PlcOutputs._11a1_DQ_8x24VDC_0_5A_ST_1 :=  BYTE#127;

    // Never modif this the context needs references to IN/OUT structures before it is used.
    Context.Inputs := REF(Inputs);
    Context.Outputs := REF(Outputs);
    Context.PlcInputs := REF(PlcInputs);
    Context.PlcOutputs := REF(PlcOutputs);

    
    ContextLogger.SetMinimumLevel(AXOpen.Logging.eLogLevel#Verbose);
    Context.InjectRtc(S71500Rtc);
    Context.InjectLogger(ContextLogger);
    // Executes the main context of this application.
    Context.Run();     
     
	//Copy this function call at the very end of your program.
	//Do not change any names, addresses or any another content.
	CopyOutputs();
END_PROGRAM
