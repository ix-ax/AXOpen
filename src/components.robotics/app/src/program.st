PROGRAM MyProgram
    VAR_EXTERNAL
        sandbox : SandboxContext;
        documentation : DocumentationContext;
        _rtc : AXOpen.S71500.Rtc;
    END_VAR

    VAR

    END_VAR

    VAR_TEMP

    END_VAR
    sandbox.InjectRtc(_rtc);
    documentation.InjectRtc(_rtc);
    sandbox.Run();    
    documentation.Run();
END_PROGRAM
