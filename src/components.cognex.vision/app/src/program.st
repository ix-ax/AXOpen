PROGRAM MyProgram
    VAR_EXTERNAL
        I_am_alive : ULINT;
        AxoCognexVisionExampleContext : AxoCognexVisionExample.AxoCognexVisionExampleContext;
		PlcInputs : PlcInputs;
		PlcOutputs : PlcOutputs;
        AxoRtc : AxoRtc.AxoS71500Rtc;
	END_VAR

    CopyInputs();

    I_am_alive := I_am_alive + ULINT#1;
        
    AxoCognexVisionExampleContext.PlcInputs := REF(PlcInputs);
    AxoCognexVisionExampleContext.PlcOutputs := REF(PlcOutputs);
    AxoCognexVisionExampleContext.Run();
    AxoCognexVisionExampleContext.InjectRtc(AxoRtc);

    CopyOutputs();  
END_PROGRAM

