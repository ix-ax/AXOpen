USING AxUnit;
USING AXOpen.Timers;
USING AXOpen.Rtc;
USING AXOpen.Logging;
USING AXOpen.Core;
USING AXOpen.Rtc;


NAMESPACE AXOpen.Timers_tests

   
    {TestFixture}
    {S7.extern=ReadWrite}
    CLASS AxoOffDelayTimersTests
        VAR PROTECTED
            _context : TestContext;
            _inspectedBool : BOOL;
            _rtcMock :  AxoRtcMock;  
            _signal : BOOL;
            _testTimerOnDelay: AXOpen.Timers.OnDelayTimer;
            _testTimerOffDelay: AXOpen.Timers.OffDelayTimer;
            _testTimeDelay: LTIME := LTIME#5s;
        END_VAR  

        METHOD PRIVATE Initialize
            _context.InjectRtc(_rtcMock);        
        END_METHOD

        {Test}        
        METHOD PUBLIC Timer_offDelay_class_output_test
            THIS.Initialize();

            _context.Open();

            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:33.123456);
            _signal := TRUE;
            _testTimerOffDelay.OffDelay(_context, _signal, _testTimeDelay);
            Assert.Equal(TRUE, _testTimerOffDelay.output);
            
            //move 6 seconds in future, timer stil don't count, true is output
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:39.123456);
            _testTimerOffDelay.OffDelay(_context, _signal, _testTimeDelay);
            Assert.Equal(TRUE, _testTimerOffDelay.output);

            //here, timer starts count
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:41.123456);
            _signal := FALSE;
            _testTimerOffDelay.OffDelay(_context, _signal, _testTimeDelay);
            Assert.Equal(TRUE, _testTimerOffDelay.output);


            //here, timer should hit delay and turn off signal
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:46.123456);
            _testTimerOffDelay.OffDelay(_context, _signal, _testTimeDelay);
            Assert.Equal(FALSE, _testTimerOffDelay.output);


            _context.Close();
        END_METHOD




        {Test}        
        METHOD PUBLIC Timer_offDelay_overall_test
            THIS.Initialize();

            _context.Open();

            //all turn off, previous signal was false, input is false, output should be false
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:30.0);
            _signal := FALSE;
            _testTimerOffDelay.OffDelay(_context, _signal, _testTimeDelay);
            Assert.Equal(FALSE, _testTimerOffDelay.output);

            //after 1 second, turn on signal, output should be on
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:31.0);
            _signal := TRUE;
            _testTimerOffDelay.OffDelay(_context, _signal, _testTimeDelay);
            Assert.Equal(TRUE, _testTimerOffDelay.output);

            //after 2 second, turn off signal, FALLING EDGE detected, output should be on, timer should start counting
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:32.0);
            _signal := FALSE;
            _testTimerOffDelay.OffDelay(_context, _signal, _testTimeDelay);
            Assert.Equal(TRUE, _testTimerOffDelay.output);


            //after 7 second, timer count passed delay, output should be false
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:35.0);
            _testTimerOffDelay.OffDelay(_context, _signal, _testTimeDelay);
            Assert.Equal(FALSE, _testTimerOffDelay.output);
        
            
            //after 10 second, rising edge was detected, timer is reseted and output should be true
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:40.0);
            _signal := TRUE;
            _testTimerOffDelay.OffDelay(_context, _signal, _testTimeDelay);
            Assert.Equal(TRUE, _testTimerOffDelay.output);

            //after 11 second, falling edge was detected, timer should start count again
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:41.0);
            _signal := FALSE;
           _testTimerOffDelay.OffDelay(_context, _signal, _testTimeDelay);
            Assert.Equal(TRUE, _testTimerOffDelay.output);

            //after 13 second, rising edge was detected, timer is reseted, output is still true
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:43.0);
            _signal := TRUE;
            _testTimerOffDelay.OffDelay(_context, _signal, _testTimeDelay);
            Assert.Equal(TRUE, _testTimerOffDelay.output);




            _context.Close();
        END_METHOD



        {Test}        
        METHOD PUBLIC Timer_offDelay_method_output_test
            VAR_TEMP
                _methodOutput: BOOL;
            END_VAR
            THIS.Initialize();

            _context.Open();

            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:33.123456);
            _signal := TRUE;
            _methodOutput := _testTimerOffDelay.OffDelay(_context, _signal, _testTimeDelay);
            Assert.Equal(TRUE, _methodOutput);
            
            //move 6 seconds in future, timer stil don't count, true is output
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:39.123456);
            _methodOutput := _testTimerOffDelay.OffDelay(_context, _signal, _testTimeDelay);
            Assert.Equal(TRUE, _methodOutput);

            //here, timer starts count
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:41.123456);
            _signal := FALSE;
            _methodOutput := _testTimerOffDelay.OffDelay(_context, _signal, _testTimeDelay);
            Assert.Equal(TRUE, _methodOutput);


            //here, timer should hit delay and turn off signal
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:46.123456);
            _methodOutput := _testTimerOffDelay.OffDelay(_context, _signal, _testTimeDelay);
            Assert.Equal(FALSE, _methodOutput);


            _context.Close();
        END_METHOD

        {Test}        
        METHOD PUBLIC Timer_offDelay_delay_is_not_reached_output_is_true
            VAR_TEMP
                _methodOutput: BOOL;
            END_VAR
            THIS.Initialize();

            _context.Open();

            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:33.123456);
            _signal := TRUE;
            _methodOutput := _testTimerOffDelay.OffDelay(_context, _signal, _testTimeDelay);
            Assert.Equal(TRUE, _methodOutput);
            
            //move 3 seconds in future
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:36.123456);
            _methodOutput := _testTimerOffDelay.OffDelay(_context, _signal, _testTimeDelay);
            Assert.Equal(TRUE, _methodOutput);

      


            _context.Close();
        END_METHOD

        {Test}        
        METHOD PUBLIC Timer_offDelay_zero_delay
            VAR_TEMP
                _resultET : BOOL;
            END_VAR
            THIS.Initialize();

            //arange
            _context.Open();
            _testTimeDelay := LT#0s;
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:33.123456);
            _signal := TRUE;
            
            //act/assert
            _testTimerOffDelay.OffDelay(_context, _signal, _testTimeDelay);
            Assert.Equal(TRUE, _testTimerOffDelay.output);
            
            _context.Close();
        END_METHOD

        {Test}        
        METHOD PUBLIC Timer_offDelay_evertyhing_off
            VAR_TEMP
                _resultET : BOOL;
            END_VAR
            THIS.Initialize();

            //arange
            _context.Open();
    
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:33.123456);
            _signal := FALSE;
            
            //act/assert
            _testTimerOffDelay.OffDelay(_context, _signal, _testTimeDelay);
            Assert.Equal(FALSE, _testTimerOffDelay.output);
            
            _context.Close();
        END_METHOD

    


       END_CLASS
END_NAMESPACE
