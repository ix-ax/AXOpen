PROGRAM MyProgram
    VAR_EXTERNAL
        sandbox : SandboxContext;
        documentation : DocumentationContext;
        S71500Rtc :  AXOpen.S71500.Rtc;   
        S71500Rtm : AXOpen.S71500.Rtm;
    END_VAR

    VAR

    END_VAR

    VAR_TEMP

    END_VAR

    sandbox.InjectRtc(S71500Rtc);
    sandbox.InjectRtm(S71500Rtm);
    sandbox.Run();    

    documentation.InjectRtc(S71500Rtc);
    documentation.InjectRtm(S71500Rtm);
    documentation.Run();    
END_PROGRAM
