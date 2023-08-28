PROGRAM MyProgram
    VAR_EXTERNAL
        sandbox : SandboContext;
        documentation : DocumentationContext;
        AxoRtc : AxoRtc.AxoS71500Rtc;
    END_VAR

    VAR

    END_VAR

    VAR_TEMP

    END_VAR
    sandbox.Run();    
    sandbox.InjectRtc(AxoRtc);
END_PROGRAM
