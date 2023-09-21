PROGRAM MyProgram
    VAR_EXTERNAL
        sandbox : SandboContext;
        documentation : DocumentationContext;
        AxoRtc : AxoRtc.AxoS71500Rtc;
		PlcInputs : PlcInputs;
		PlcOutputs : PlcOutputs;
    END_VAR

    VAR

    END_VAR

    VAR_TEMP

    END_VAR
    CopyInputs();

    sandbox.PlcInputs := REF(PlcInputs);
    sandbox.PlcOutputs := REF(PlcOutputs);
    sandbox.Run();    
    sandbox.InjectRtc(AxoRtc);

    documentation.PlcInputs := REF(PlcInputs);
    documentation.PlcOutputs := REF(PlcOutputs);
    documentation.Run();    
    documentation.InjectRtc(AxoRtc);

    CopyOutputs();  
END_PROGRAM
