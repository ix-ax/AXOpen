USING AXOpen.Components.Pneumatics;

PROGRAM MyProgram
    VAR_EXTERNAL
        sandbox : SandboxContext;
        documentation : DocumentationContext;
        _rtc : AXOpen.S71500.Rtc;
        _rtm : AXOpen.S71500.Rtm;
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
    sandbox.InjectRtm(_rtm);
    
    documentation.PlcInputs := REF(PlcInputs);
    documentation.PlcOutputs := REF(PlcOutputs);
    documentation.Run();    
    documentation.InjectRtc(_rtc);
    documentation.InjectRtm(_rtm);
    
    CopyOutputs();  
END_PROGRAM
