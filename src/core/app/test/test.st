USING AxUnit;
USING AXOpen.Core;
USING AXOpen.Core.Dummies;

NAMESPACE MessengerTests

    {TestFixture}
    {S7.extern=ReadWrite}
    CLASS MessengerTestFixture
        VAR PROTECTED
            _context    :   AxoStaticMessengerExample.Messengers;        
            _rtc        :   MockAxoRtc;
            _rtm        :   MockAxoRtm;
        END_VAR            
        {TestSetup}
        METHOD PUBLIC TestSetup
            _rtm.SetElapsed(LTIME#2s);
            _context.InjectRtm(_rtm);
            _rtc.SetNowUTC(LDATE_AND_TIME#2012-01-12-15:58:12.123);
            _context.InjectRtc(_rtc);
        END_METHOD

        {TestTearDown}
        METHOD PUBLIC TestTearDown
            ;
        END_METHOD

        {FixtureSetup}
        METHOD PUBLIC FixtureSetup
            ;
        END_METHOD

        {FixtureTearDown}
        METHOD PUBLIC FixtureTearDown
            ;
        END_METHOD        
        
        {Test}
        METHOD PUBLIC _messenger1
            _context.Run();
            _context._messenger1condition := TRUE;
            _context.Run();
            _context._messenger1.AcknowledgeRequest := TRUE;
            _context.Run();
            _context._messenger1condition := FALSE;
            _context.Run();
            _context.Run();
            Assert.Equal(actual := TRUE, expected := TRUE);
        END_METHOD

        {Test}
        METHOD PUBLIC _messenger2
            _context.Run();
            _context._messenger2condition := TRUE;
            _context._messenger2code := UINT#1;
            _context.Run();
            _context._messenger2condition := FALSE;
            _context.Run();
            _context._messenger2.AcknowledgeRequest := TRUE;
            _context.Run();
            _context.Run();
            Assert.Equal(actual := TRUE, expected := TRUE);
        END_METHOD        

        {Test}
        METHOD PUBLIC _messenger2_ack
            _context.Run();
            _context._messenger2condition := TRUE;
            _context._messenger2code := UINT#1;
            _context.Run();
            _context._messenger2.AcknowledgeRequest := TRUE;
            _context.Run();
            _context._messenger2condition := FALSE;
            _context.Run();
            _context.Run();
            Assert.Equal(actual := TRUE, expected := TRUE);
        END_METHOD       
        
        {Test}
        METHOD PUBLIC _messenger6
            _context.Run();
            _context._messenger6condition_1 := TRUE;
            _context.Run();
            _context._messenger6.AcknowledgeRequest := TRUE;
            _context.Run();
            _context._messenger6condition_1 := FALSE;
            _context.Run();
            _context.Run();
            Assert.Equal(actual := TRUE, expected := TRUE);
        END_METHOD  





    END_CLASS

END_NAMESPACE


