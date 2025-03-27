USING AxUnit;
USING AXOpen.Core;
USING AXOpen.Core.Dummies;

NAMESPACE DocumentationTest
    {TestFixture}
    {S7.extern=ReadWrite}
    CLASS DocumentationFixture
        VAR PROTECTED
            documentation : AxoStaticMessengerDocuExample.MessengersExamples;        
            _rtc             :   MockAxoRtc;
            _rtm             :   MockAxoRtm;
        END_VAR    

        {TestSetup}
        METHOD PUBLIC TestSetup
            _rtm.SetElapsed(LTIME#2s);
            documentation.InjectRtm(_rtm);
            _rtc.SetNowUTC(LDATE_AND_TIME#2012-01-12-15:58:12.123);
            documentation.InjectRtc(_rtc);
        END_METHOD


        {Test}
        METHOD PUBLIC DocumentationRunTest
            documentation.Run();
            documentation._messenger1condition := TRUE;
            documentation._messenger2condition := TRUE;
            documentation._messenger2code := UINT#1;
            documentation.Run();
            documentation._messenger1.AcknowledgeRequest := TRUE;
            documentation._messenger2condition := FALSE;
            documentation.Run();
            documentation._messenger2.AcknowledgeRequest := TRUE;
            documentation._messenger1condition := FALSE;
            documentation.Run();
            documentation.Run();
            Assert.Equal(actual := TRUE, expected := TRUE);
        END_METHOD
    END_CLASS



END_NAMESPACE
