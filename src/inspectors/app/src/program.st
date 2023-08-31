PROGRAM MyProgram
    VAR_EXTERNAL
        sandbox : SandboxContext;
        documentation : DocumentationContext;
        S71500Rtc :  AXOpen.S71500.Rtc;   
    END_VAR

    VAR

    END_VAR

    VAR_TEMP

    END_VAR
    sandbox.InjectRtc(S71500Rtc);
    sandbox.Run();    

    documentation.InjectRtc(S71500Rtc);
    documentation.Run();    
END_PROGRAM
