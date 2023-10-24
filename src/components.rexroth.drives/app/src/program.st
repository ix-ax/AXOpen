PROGRAM MyProgram
    VAR_EXTERNAL
        sandbox : SandboxContext;
        documentation : DocumentationContext;
        _rtc : AXOpen.S71500.Rtc;
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
    sandbox.InjectRtc(_rtc);
    
    documentation.Run();
    documentation.InjectRtc(_rtc);
 
    CopyOutputs();  
END_PROGRAM
