USING AxUnit;
USING AXOpen.Timers;
USING AXOpen.Rtc;
USING AXOpen.Logging;
USING AXOpen.Core;
USING AXOpen.Rtc;


NAMESPACE AXOpen.Timers_tests

   
    {TestFixture}
    {S7.extern=ReadWrite}
    CLASS AxoOnDelayTimersTests
        VAR PROTECTED
            _context : TestContext;
            _inspectedBool : BOOL;
            _rtcMock :  AxoRtcMock;  
            _signal : BOOL;
            _testTimerOnDelay: AXOpen.Timers.OnDelayTimer;
            _testTimeDelay: LTIME := LTIME#5s;
        END_VAR  

        METHOD PRIVATE Initialize
            _context.InjectRtc(_rtcMock);      
        END_METHOD



        {Test}        
        METHOD PUBLIC Timer_onDelay_overall_test
            THIS.Initialize();

            _context.Open();

            //all turn off, previous signal was false, input is false, output should be false
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:30.0);
            _signal := FALSE;
            _testTimerOnDelay.OnDelay(_context, _signal, _testTimeDelay);
            Assert.Equal(FALSE, _testTimeronDelay.output);

            //after 1 second, turn on signal, RISING EDGE detected, counter should start counting, output is still false
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:31.0);
            _signal := TRUE;
            _testTimerOnDelay.OnDelay(_context, _signal, _testTimeDelay);
            Assert.Equal(FALSE, _testTimerOnDelay.output);

            //after 6 second, time delay is counted, output should be on
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:36.0);
            _testTimerOnDelay.OnDelay(_context, _signal, _testTimeDelay);
            Assert.Equal(TRUE, _testTimerOnDelay.output);

            //after 7 second, nothing changed, output should be on
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:37.0);
            _testTimerOnDelay.OnDelay(_context, _signal, _testTimeDelay);
            Assert.Equal(TRUE, _testTimerOnDelay.output);


            //after 8 second, FALLING edge was detected, timer is reseted and output is FALSE
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:38.0);
            _signal := FALSE;
            _testTimerOnDelay.OnDelay(_context, _signal, _testTimeDelay);
            Assert.Equal(FALSE, _testTimerOnDelay.output);

            //after 9 second, nothing changed, output is still off
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:39.0);
            _testTimerOnDelay.OnDelay(_context, _signal, _testTimeDelay);
            Assert.Equal(FALSE, _testTimerOnDelay.output);
        
            
            //after 10 second, rising edge was detected, timer started count again, output is still FALSE
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:40.0);
            _signal := TRUE;
            _testTimerOnDelay.OnDelay(_context, _signal, _testTimeDelay);
            Assert.Equal(FALSE, _testTimerOnDelay.output);

            //after 13 second, falling edge was detected, timer was reseted, output is still FALSE
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:43.0);
            _signal := FALSE;
            _testTimerOnDelay.OnDelay(_context, _signal, _testTimeDelay);
            Assert.Equal(FALSE, _testTimerOnDelay.output);

          

            _context.Close();
        END_METHOD

        {Test}        
        METHOD PUBLIC Timer_onDelay_class_output_test
            THIS.Initialize();

            //arrange
            _context.Open();
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:33.123456);
            _signal := TRUE;
            
            //act/assert
            _testTimerOnDelay.OnDelay(_context, _signal, _testTimeDelay);
            Assert.Equal(FALSE, _testTimerOnDelay.output);
            
            //move 6 seconds in future
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:39.123456);
            _testTimerOnDelay.OnDelay(_context, _signal, _testTimeDelay);
            Assert.Equal(TRUE, _testTimerOnDelay.output);

            //move 8 seconds in future
            //setting input signal false
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:41.123456);
            _signal := FALSE;
            _testTimerOnDelay.OnDelay(_context, _signal, _testTimeDelay);
            Assert.Equal(FALSE, _testTimerOnDelay.output);


            _context.Close();
        END_METHOD
        

        {Test}        
        METHOD PUBLIC Timer_onDelay_method_output_test

            VAR_TEMP
                _methodOutput : BOOL;
            END_VAR
            THIS.Initialize();

            //arange
            _context.Open();
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:33.123456);
            _signal := TRUE;
           
            //act/assert
            _methodOutput := _testTimerOnDelay.OnDelay(_context, _signal, _testTimeDelay);
            Assert.Equal(FALSE, _methodOutput);
            
            //move 6 seconds in future
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:39.123456);
            _methodOutput := _testTimerOnDelay.OnDelay(_context, _signal, _testTimeDelay);
            Assert.Equal(TRUE, _methodOutput);

            //move 8 seconds in future
            //setting input signal false
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:41.123456);
            _signal := FALSE;
            _methodOutput := _testTimerOnDelay.OnDelay(_context, _signal, _testTimeDelay);
            Assert.Equal(FALSE, _methodOutput);

            _context.Close();
        END_METHOD

        {Test}        
        METHOD PUBLIC Timer_onDelay_delay_is_not_reached_test
            THIS.Initialize();

            //arrange
            _context.Open();
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:33.123456);
            _signal := TRUE;
            
            //act/assert
            _testTimerOnDelay.OnDelay(_context, _signal, _testTimeDelay);
            Assert.Equal(FALSE, _testTimerOnDelay.output);
            
            //move 2 seconds in future
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:35.123456);
            _testTimerOnDelay.OnDelay(_context, _signal, _testTimeDelay);
            Assert.Equal(FALSE, _testTimerOnDelay.output);


            _context.Close();
        END_METHOD

        {Test}        
        METHOD PUBLIC Timer_onDelay_class_output_setting_input_signal_false
            THIS.Initialize();

            //arrange
            _context.Open();

            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:33.123456);
            _signal := TRUE;

            //act/assert
            _testTimerOnDelay.OnDelay(_context, _signal, _testTimeDelay);
            Assert.Equal(FALSE, _testTimerOnDelay.output);

            //move 8 seconds in future
            //setting input signal false
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:41.123456);
            _signal := FALSE;
            _testTimerOnDelay.OnDelay(_context, _signal, _testTimeDelay);
            Assert.Equal(FALSE, _testTimerOnDelay.output);


            _context.Close();
        END_METHOD



        {Test}        
        METHOD PUBLIC Timer_onDelay_elapsed_time_not_empty
            VAR_TEMP
                _resultET : BOOL;
            END_VAR
            THIS.Initialize();
            //arrange
            _context.Open();
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:33.123456);
            _signal := TRUE;
            
            //act/assert
            _testTimerOnDelay.OnDelay(_context, _signal, _testTimeDelay);
            Assert.Equal(FALSE, _testTimerOnDelay.output);
            
            //move 7 seconds in future
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:40.123456);
            _testTimerOnDelay.OnDelay(_context, _signal, _testTimeDelay);
            _resultET := ((LTIME#7s) = _testTimerOnDelay.elapsedTime);
            Assert.Equal(TRUE, _testTimerOnDelay.output);
            Assert.Equal(TRUE, _resultET);
            

           

            _context.Close();
        END_METHOD

        
        {Test}        
        METHOD PUBLIC Timer_onDelay_zero_delay
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
            _testTimerOnDelay.OnDelay(_context, _signal, _testTimeDelay);
            Assert.Equal(TRUE, _testTimerOnDelay.output);
            
            _context.Close();
        END_METHOD

      
       


       END_CLASS
END_NAMESPACE
