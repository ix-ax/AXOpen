USING AxUnit;
USING AXOpen.Timers;
USING AXOpen.Rtc;
USING AXOpen.Logging;
USING AXOpen.Core;
USING AXOpen.Rtc;


NAMESPACE AXOpen.Timers_tests

   
    {TestFixture}
    CLASS AxoPulseTimersTests
        VAR PROTECTED
            _context : TestContext;
            _inspectedBool : BOOL;
            _rtcMock :  AxoRtcMock;  
            _signal : BOOL;
            _testTimerPulse: AXOpen.Timers.PulseContext;
            _pulseLength: LTIME := LTIME#5s;
        END_VAR  

        METHOD PRIVATE Initialize
            _context.InjectRtc(_rtcMock);      
        END_METHOD



        {Test}        
        METHOD PUBLIC Timer_Pulse_overall_test
            THIS.Initialize();

            _context.Open();

            //all turn off, previous signal was false, input is false, output should be false
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:30.0);
            _signal := FALSE;
            _testTimerPulse.Pulse(_context, _signal, _pulseLength);
            Assert.Equal(FALSE, _testTimerPulse.output);

            //after 1 second, turn on signal, RISING EDGE detected, counter should start counting, output is still false
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:31.0);
            _signal := TRUE;
            _testTimerPulse.Pulse(_context, _signal, _pulseLength);
            Assert.Equal(TRUE, _testTimerPulse.output);

            //after 2 second, counting continues, output is still true
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:32.0);
            _testTimerPulse.Pulse(_context, _signal, _pulseLength);
            Assert.Equal(TRUE, _testTimerPulse.output);

            //after 6 second, pulse length is counted, output will turn off
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:36.0);
            _testTimerPulse.Pulse(_context, _signal, _pulseLength);
            Assert.Equal(FALSE, _testTimerPulse.output);

            //after 7 second, nothing changed, output should be off
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:37.0);
            _testTimerPulse.Pulse(_context, _signal, _pulseLength);
            Assert.Equal(FALSE, _testTimerPulse.output);


            //after 8 second, FALLING edge was detected, and timer is counted, therefore is reseted, output is false
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:38.0);
            _signal := FALSE;
            _testTimerPulse.Pulse(_context, _signal, _pulseLength);
            Assert.Equal(FALSE, _testTimerPulse.output);

            // //after 9 second, nothing changed, output is still off
            // _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:39.0);
            // _testTimerOnDelay.OnDelay(_context, _signal, _testTimeDelay);
            // Assert.Equal(FALSE, _testTimerOnDelay.output);
        
            
            // //after 10 second, rising edge was detected, timer started count again, output is still FALSE
            // _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:40.0);
            // _signal := TRUE;
            // _testTimerOnDelay.OnDelay(_context, _signal, _testTimeDelay);
            // Assert.Equal(FALSE, _testTimerOnDelay.output);

            // //after 13 second, falling edge was detected, timer was reseted, output is still FALSE
            // _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:43.0);
            // _signal := FALSE;
            // _testTimerOnDelay.OnDelay(_context, _signal, _testTimeDelay);
            // Assert.Equal(FALSE, _testTimerOnDelay.output);

          

            _context.Close();
        END_METHOD

       

      
       


       END_CLASS
END_NAMESPACE