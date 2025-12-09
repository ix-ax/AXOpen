USING AXOpen.Io;

PROGRAM MyProgram
    VAR_EXTERNAL
        sandbox : SandboxContext;
        documentation : DocumentationContext;
        _rtc : AXOpen.S71500.Rtc;
        _rtm : AXOpen.S71500.Rtm;
        Inputs : Inputs;
		Outputs : Outputs;
    END_VAR

    VAR

    END_VAR

    VAR_TEMP

    END_VAR
    sandbox.InjectRtc(_rtc);
    sandbox.InjectRtm(_rtm);
    documentation.InjectRtc(_rtc);
    documentation.InjectRtm(_rtm);
    sandbox.Run();    
    documentation.Run();
END_PROGRAM
