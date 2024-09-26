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
            _rtmMock :  AxoRtmMock;  
            _signal : BOOL;
            _testTimerOnDelay: AXOpen.Timers.OnDelayTimer;
            _testTimeDelay: LTIME := LTIME#5s;
        END_VAR  

        METHOD PRIVATE Initialize
            _context.InjectRtm(_rtmMock);      
        END_METHOD


        VAR
            _contextBlank : TestContext;                                    
            _testTimerOnDelayBlank: AXOpen.Timers.OnDelayTimer;
            _testTimerOffDelayBlank: AXOpen.Timers.OffDelayTimer;            
        END_VAR    

        {TestSetup}
        METHOD PUBLIC TestSetup
        // Will be called before MyTest_A AND before Test_B are executed
            _context := _contextBlank;
            _testTimerOnDelay := _testTimerOnDelayBlank;            
        END_METHOD
    
        {TestTearDown}
        METHOD PUBLIC TestTearDown
        // Will be called after MyTest_A AND before Test_B where executed
            ;
        END_METHOD
    
        {FixtureSetup}
        METHOD PUBLIC FixtureSetup
        // Will be called once before the Tests are executed
            ;
        END_METHOD
    
        {FixtureTearDown}
        METHOD PUBLIC FixtureTearDown
        // Will be called after the Tests where executed
            ;
        END_METHOD



        {Test}        
        METHOD PUBLIC Timer_onDelay_overall_test
            THIS.Initialize();

            _context.Open();

            //all turn off, previous signal was false, input is false, output should be false
            //_rtmMock.SetNowUTC(LDT#1980-01-23-13:14:30.0);
            _rtmMock.SetElapsed(LT#30S);
            _signal := FALSE;
            _testTimerOnDelay.OnDelay(_context, _signal, _testTimeDelay);
            Assert.Equal(FALSE, _testTimeronDelay.output);

            //after 1 second, turn on signal, RISING EDGE detected, counter should start counting, output is still false
            //_rtmMock.SetNowUTC(LDT#1980-01-23-13:14:31.0);
            _rtmMock.SetElapsed(LT#31S);
            _signal := TRUE;
            _testTimerOnDelay.OnDelay(_context, _signal, _testTimeDelay);
            Assert.Equal(FALSE, _testTimerOnDelay.output);

            //after 6 second, time delay is counted, output should be on
            //_rtmMock.SetNowUTC(LDT#1980-01-23-13:14:36.0);
            _rtmMock.SetElapsed(LT#36S);
            _testTimerOnDelay.OnDelay(_context, _signal, _testTimeDelay);
            Assert.Equal(TRUE, _testTimerOnDelay.output);

            //after 7 second, nothing changed, output should be on
            //_rtmMock.SetNowUTC(LDT#1980-01-23-13:14:37.0);
            _rtmMock.SetElapsed(LT#37S);
            _testTimerOnDelay.OnDelay(_context, _signal, _testTimeDelay);
            Assert.Equal(TRUE, _testTimerOnDelay.output);


            //after 8 second, FALLING edge was detected, timer is reseted and output is FALSE
            //_rtmMock.SetNowUTC(LDT#1980-01-23-13:14:38.0);
            _rtmMock.SetElapsed(LT#38S);
            _signal := FALSE;
            _testTimerOnDelay.OnDelay(_context, _signal, _testTimeDelay);
            Assert.Equal(FALSE, _testTimerOnDelay.output);

            //after 9 second, nothing changed, output is still off
            //_rtmMock.SetNowUTC(LDT#1980-01-23-13:14:39.0);
            _rtmMock.SetElapsed(LT#39S);
            _testTimerOnDelay.OnDelay(_context, _signal, _testTimeDelay);
            Assert.Equal(FALSE, _testTimerOnDelay.output);
        
            
            //after 10 second, rising edge was detected, timer started count again, output is still FALSE
            //_rtmMock.SetNowUTC(LDT#1980-01-23-13:14:40.0);
            _rtmMock.SetElapsed(LT#40S);
            _signal := TRUE;
            _testTimerOnDelay.OnDelay(_context, _signal, _testTimeDelay);
            Assert.Equal(FALSE, _testTimerOnDelay.output);

            //after 13 second, falling edge was detected, timer was reseted, output is still FALSE
            //_rtmMock.SetNowUTC(LDT#1980-01-23-13:14:43.0);
            _rtmMock.SetElapsed(LT#43S);
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
            //_rtmMock.SetNowUTC(LDT#1980-01-23-13:14:33.123456);
            _rtmMock.SetElapsed(LT#33S);
            _signal := TRUE;
            
            //act/assert
            _testTimerOnDelay.OnDelay(_context, _signal, _testTimeDelay);
            Assert.Equal(FALSE, _testTimerOnDelay.output);
            
            //move 6 seconds in future
            //_rtmMock.SetNowUTC(LDT#1980-01-23-13:14:39.123456);
            _rtmMock.SetElapsed(LT#39S);
            _testTimerOnDelay.OnDelay(_context, _signal, _testTimeDelay);
            Assert.Equal(TRUE, _testTimerOnDelay.output);

            //move 8 seconds in future
            //setting input signal false
            //_rtmMock.SetNowUTC(LDT#1980-01-23-13:14:41.123456);
            _rtmMock.SetElapsed(LT#41S);
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
            //_rtmMock.SetNowUTC(LDT#1980-01-23-13:14:33.123456);
            _rtmMock.SetElapsed(LT#33S);
            _signal := TRUE;
           
            //act/assert
            _methodOutput := _testTimerOnDelay.OnDelay(_context, _signal, _testTimeDelay);
            Assert.Equal(FALSE, _methodOutput);
            
            //move 6 seconds in future
            //_rtmMock.SetNowUTC(LDT#1980-01-23-13:14:39.123456);
            _rtmMock.SetElapsed(LT#39S);
            _methodOutput := _testTimerOnDelay.OnDelay(_context, _signal, _testTimeDelay);
            Assert.Equal(TRUE, _methodOutput);

            //move 8 seconds in future
            //setting input signal false
            //_rtmMock.SetNowUTC(LDT#1980-01-23-13:14:41.123456);
            _rtmMock.SetElapsed(LT#41S);
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
            //_rtmMock.SetNowUTC(LDT#1980-01-23-13:14:33.123456);
            _rtmMock.SetElapsed(LT#33S);
            _signal := TRUE;
            
            //act/assert
            _testTimerOnDelay.OnDelay(_context, _signal, _testTimeDelay);
            Assert.Equal(FALSE, _testTimerOnDelay.output);
            
            //move 2 seconds in future
            //_rtmMock.SetNowUTC(LDT#1980-01-23-13:14:35.123456);
            _rtmMock.SetElapsed(LT#35S);
            _testTimerOnDelay.OnDelay(_context, _signal, _testTimeDelay);
            Assert.Equal(FALSE, _testTimerOnDelay.output);


            _context.Close();
        END_METHOD

        {Test}        
        METHOD PUBLIC Timer_onDelay_class_output_setting_input_signal_false
            THIS.Initialize();

            //arrange
            _context.Open();

            //_rtmMock.SetNowUTC(LDT#1980-01-23-13:14:33.123456);
            _rtmMock.SetElapsed(LT#33S);
            _signal := TRUE;

            //act/assert
            _testTimerOnDelay.OnDelay(_context, _signal, _testTimeDelay);
            Assert.Equal(FALSE, _testTimerOnDelay.output);

            //move 8 seconds in future
            //setting input signal false
            //_rtmMock.SetNowUTC(LDT#1980-01-23-13:14:41.123456);
            _rtmMock.SetElapsed(LT#41S);
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
            //_rtmMock.SetNowUTC(LDT#1980-01-23-13:14:33.123456);
            _rtmMock.SetElapsed(LT#33S);
            _signal := TRUE;
            
            //act/assert
            _testTimerOnDelay.OnDelay(_context, _signal, _testTimeDelay);
            Assert.Equal(FALSE, _testTimerOnDelay.output);
            
            //move 7 seconds in future
            //_rtmMock.SetNowUTC(LDT#1980-01-23-13:14:40.123456);
            _rtmMock.SetElapsed(LT#40S);
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
            //_rtmMock.SetNowUTC(LDT#1980-01-23-13:14:33.123456);
            _rtmMock.SetElapsed(LT#33S);
            _signal := TRUE;
            
            //act/assert
            _testTimerOnDelay.OnDelay(_context, _signal, _testTimeDelay);
            Assert.Equal(TRUE, _testTimerOnDelay.output);
            
            _context.Close();
        END_METHOD

      
       


       END_CLASS
END_NAMESPACE
