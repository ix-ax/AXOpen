USING AxUnit;

NAMESPACE MyTest

    {TestFixture}
    {S7.extern=ReadWrite}
    CLASS MyTestFixture
        VAR
            sandbox : SandboxContext;
            S71500Rtc :  AXOpen.S71500.Rtc;   
            S71500Rtm : AXOpen.S71500.Rtm;
        END_VAR    
        {Test}
        METHOD PUBLIC MyTestMethod
            sandbox.InjectRtc(S71500Rtc);
            sandbox.InjectRtm(S71500Rtm);
            sandbox._startInspection := TRUE;
            sandbox.Run();               
            Assert.Equal(actual := TRUE, expected := TRUE);
        END_METHOD
    END_CLASS

END_NAMESPACE
