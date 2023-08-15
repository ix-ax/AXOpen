PROGRAM MyProgram
    VAR_EXTERNAL
        I_am_alive : ULINT;
        AxoCognexVisionExampleContext : AxoCognexVisionExample.AxoCognexVisionExampleContext;
		PlcInputs : PlcInputs;
		PlcOutputs : PlcOutputs;
	END_VAR

    CopyInputs();

    I_am_alive := I_am_alive + ULINT#1;

    
    AxoCognexVisionExampleContext.PlcInputs := REF(PlcInputs);
    AxoCognexVisionExampleContext.PlcOutputs := REF(PlcOutputs);
    AxoCognexVisionExampleContext.Run();

    CopyOutputs();  
END_PROGRAM

