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

    sandbox.InjectRtc(_rtc);
    sandbox.InjectRtm(_rtm);
    sandbox.PlcInputs := REF(PlcInputs);
    sandbox.PlcOutputs := REF(PlcOutputs);
    sandbox.Run();    
    
    documentation.InjectRtc(_rtc);
    documentation.InjectRtm(_rtm);
    documentation.PlcInputs := REF(PlcInputs);
    documentation.PlcOutputs := REF(PlcOutputs);
    documentation.Run();    
    
    CopyOutputs();  
END_PROGRAM
