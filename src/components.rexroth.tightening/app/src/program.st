USING AXOpen.Components.Rexroth.Tightening;

PROGRAM MyProgram
    VAR_EXTERNAL
        sandbox : AXOpen.Components.Rexroth.Tightening.SandboxContext;
        documentation : AXOpen.Components.Rexroth.Tightening.DocumentationContext;
        _rtc : AXOpen.S71500.Rtc;
        _rtm : AXOpen.S71500.Rtm;
    END_VAR

    sandbox.InjectRtc(_rtc);
    sandbox.InjectRtm(_rtm);
    sandbox.Run();    


    documentation.InjectRtc(_rtc);
    documentation.InjectRtm(_rtm);
    documentation.Run();
END_PROGRAM
