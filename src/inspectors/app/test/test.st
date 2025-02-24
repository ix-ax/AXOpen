USING AxUnit;

NAMESPACE MyTest

    {TestFixture}
    {S7.extern=ReadWrite}
    CLASS MyTestFixture
        VAR
            sandbox : SandboxContext;
            documentation : DocumentationContext;
            _rtc :  AXOpen.Core.Dummies.MockAxoRtc;
            _rtm :  AXOpen.Core.Dummies.MockAxoRtm;
        END_VAR    
        {Test}

        METHOD PUBLIC SandboxTest
            VAR 
                i : UINT;
            END_VAR
            _rtm.SetElapsed(LTIME#2s);
            sandbox.InjectRtm(_rtm);
            _rtc.SetNowUTC(LDATE_AND_TIME#2012-01-12-15:58:12.123);
            sandbox.InjectRtc(_rtc);            
            sandbox._startInspection := TRUE;
            FOR i := UINT#0 TO UINT#3 DO
                sandbox.Run();               
            END_FOR;
            Assert.Equal(actual := TRUE, expected := TRUE);
        END_METHOD

        {Test}
        METHOD PUBLIC DocumentationTest
            VAR 
                i : UINT;
            END_VAR
            _rtm.SetElapsed(LTIME#2s);
            documentation.InjectRtm(_rtm);
            _rtc.SetNowUTC(LDATE_AND_TIME#2012-01-12-15:58:12.123);
            documentation.InjectRtc(_rtc);            
            documentation._startInspection := TRUE;
            FOR i := UINT#0 TO UINT#3 DO
                documentation.Run();               
            END_FOR;
            Assert.Equal(actual := documentation._automat.CurrentStep.Order, expected := ULINT#3);
        END_METHOD        
    END_CLASS

END_NAMESPACE
