PROGRAM MyProgram
    VAR_EXTERNAL
        sandbox : SandboxContext;
        documentation : DocumentationContext;
        _rtc : AXOpen.S71500.Rtc;
    END_VAR

    sandbox.Run();    
    sandbox.InjectRtc(_rtc);

    documentation.Run();
    documentation.InjectRtc(_rtc);
END_PROGRAM
