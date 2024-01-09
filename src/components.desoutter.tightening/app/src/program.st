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

    sandbox.InjectRtc(_rtc);
    documentation.InjectRtc(_rtc);
    sandbox.Run();    
    documentation.Run();

    CopyOutputs();
END_PROGRAM
