PROGRAM MyProgram
    VAR_EXTERNAL
        I_am_alive : ULINT;
        AxoCognexVisionExampleContext : AxoCognexVisionExample.AxoCognexVisionExampleContext;
		PlcInputs : PlcInputs;
		PlcOutputs : PlcOutputs;
        _rtc : AXOpen.S71500.Rtc;
	END_VAR

    CopyInputs();

    I_am_alive := I_am_alive + ULINT#1;
        
    AxoCognexVisionExampleContext.PlcInputs := REF(PlcInputs);
    AxoCognexVisionExampleContext.PlcOutputs := REF(PlcOutputs);
    AxoCognexVisionExampleContext.Run();
    AxoCognexVisionExampleContext.InjectRtc(_rtc);

    CopyOutputs();  
END_PROGRAM

