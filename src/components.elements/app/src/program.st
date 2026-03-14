USING AXOpen.Components.Elements;
PROGRAM MyProgram
    VAR_EXTERNAL
        sandbox : SandboxContext;
        documentation : DocumentationContext;
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
