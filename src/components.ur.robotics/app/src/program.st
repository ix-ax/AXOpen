USING AXOpen.Components.Ur.Robotics;

PROGRAM MyProgram
    VAR_EXTERNAL
        sandbox : SandboxContext;
        documentation : DocumentationContext;
        _rtc : AXOpen.S71500.Rtc;
        _rtm : AXOpen.S71500.Rtm;
    END_VAR

    sandbox.Run();    
    sandbox.InjectRtc(_rtc);
    sandbox.InjectRtm(_rtm);


    documentation.Run();
    documentation.InjectRtc(_rtc);
    documentation.InjectRtm(_rtm);
END_PROGRAM
