USING AxUnit;
USING AXOpen.Core;

NAMESPACE AXOpen.Inspectors.AxoInspector_Tests  

    {TestFixture}
    {S7.extern=ReadWrite}
    CLASS AxoDigitalInspectorTests
        VAR PROTECTED
            _context : TestContext;
            _digitalInspector    : AxoInspector;
            _digitalInspectorData    : AxoDigitalInspectorData;
            _inspectedBool : BOOL;
            _sequencer  : AxoSequencer;
            _rtcMock :  AxoRtcMock;  
            _rtmMock : AxoRtmMock;

            _testBool : BOOL;

            _testTimer: AXOpen.Timers.OnDelayTimer;
            _testTimeDelay: LTIME;

            _comprehensiveResult: AxoComprehensiveResult;

            _LocalUtcTime : LDATE_AND_TIME;
            _AcumulatedElaplsedTime : LTIME;
        END_VAR  

        
        VAR
            _contextBlank : TestContext;
            _digitalInspectorBlank    : AxoInspector;            
            _sequencerBlank  : AxoSequencer;      
            _retryStep  : AxoStep;      
            _terminateStep  : AxoStep;      

        END_VAR  


        {TestSetup}
        METHOD PUBLIC TestSetup
        // Will be called before MyTest_A AND before Test_B are executed
            _context := _contextBlank;
            _digitalInspector := _digitalInspectorBlank;
            _sequencer := _sequencerBlank;
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


        METHOD PRIVATE Initialize
            _context.InjectRtc(_rtcMock);
            _context.InjectRtm(_rtmMock);
            _context.InitializeRootObject(_sequencer);
            
            _digitalInspectorData.FailTime := T#10s;
            _digitalInspectorData.PassTime := T#2s;
        END_METHOD
 
        
        {Test}        
        METHOD PUBLIC digital_inspection_inspection_true_ok
            THIS.Initialize();
            
            //Arrange
            _context.Open();
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:30.0);
            _rtmMock.SetElapsed(LT#30S);
            _inspectedBool := TRUE;
            _digitalInspectorData.RequiredStatus := TRUE;

            //Act & Assert

            _digitalInspector.Inspect(_sequencer,REF(_digitalInspectorData),_inspectedBool);
            _context.Close();
            //+1s
            _context.Open();
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:31.0);
            _rtmMock.SetElapsed(LT#31S);
            _digitalInspector.Inspect(_sequencer,REF(_digitalInspectorData),_inspectedBool);
            Assert.Equal(eInspectorResult#Running, _digitalInspector.Result());
            _context.Close();
            //+2s
            _context.Open();
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:32.0);
            _rtmMock.SetElapsed(LT#32S);
            _digitalInspector.Inspect(_sequencer,REF(_digitalInspectorData),_inspectedBool);
            Assert.Equal(eInspectorResult#Passed, _digitalInspector.Result());
            
            _context.Close();
        END_METHOD

        {Test}        
        METHOD PUBLIC digital_inspection_inspection_false_ok
            THIS.Initialize();
            
            //Arrange
            _context.Open();
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:30.0);
            _rtmMock.SetElapsed(LT#30S);
            _inspectedBool := FALSE;
            _digitalInspectorData.RequiredStatus := FALSE;

            //Act & Assert

            _digitalInspector.Inspect(_sequencer,REF(_digitalInspectorData),_inspectedBool);
            _context.Close();
            //+1s
            _context.Open();
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:31.0);
            _rtmMock.SetElapsed(LT#31S);
            _digitalInspector.Inspect(_sequencer,REF(_digitalInspectorData),_inspectedBool);
            Assert.Equal(eInspectorResult#Running, _digitalInspector.Result());
            _context.Close();
            //+2s
            _context.Open();
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:32.0);
            _rtmMock.SetElapsed(LT#32S);
            _digitalInspector.Inspect(_sequencer,REF(_digitalInspectorData),_inspectedBool);
            Assert.Equal(eInspectorResult#Passed, _digitalInspector.Result());
            
            _context.Close();
        END_METHOD

        {Test}        
        METHOD PUBLIC digital_inspection_inspection_true_fail
            THIS.Initialize();
            
            //Arrange
            _context.Open();
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:30.0);
            _rtmMock.SetElapsed(LT#30S);
            _inspectedBool := TRUE;
            _digitalInspectorData.RequiredStatus := FALSE;

            //Act & Assert

            _digitalInspector.Inspect(_sequencer,REF(_digitalInspectorData),_inspectedBool);
            _context.Close();
            //+5s
            _context.Open();
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:35.0);
            _rtmMock.SetElapsed(LT#31S);
            _digitalInspector.Inspect(_sequencer,REF(_digitalInspectorData),_inspectedBool);
            Assert.Equal(eInspectorResult#Running, _digitalInspector.Result());
            _context.Close();
            //+11s
            _context.Open();
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:41.0);
            _rtmMock.SetElapsed(LT#41S);
            _digitalInspector.Inspect(_sequencer,REF(_digitalInspectorData),_inspectedBool);
            Assert.Equal(eInspectorResult#Failed, _digitalInspector.Result());
            
            _context.Close();
        END_METHOD

        {Test}        
        METHOD PUBLIC digital_inspection_inspection_false_fail
            THIS.Initialize();
            
            //Arrange
            _context.Open();
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:30.0);
            _rtmMock.SetElapsed(LT#30S);
            _inspectedBool := FALSE;
            _digitalInspectorData.RequiredStatus := TRUE;

            //Act & Assert

            _digitalInspector.Inspect(_sequencer,REF(_digitalInspectorData),_inspectedBool);
            _context.Close();
            //+5s
            _context.Open();
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:35.0);
            _rtmMock.SetElapsed(LT#35S);
            _digitalInspector.Inspect(_sequencer,REF(_digitalInspectorData),_inspectedBool);
            Assert.Equal(eInspectorResult#Running, _digitalInspector.Result());
            _context.Close();
            //+11s
            _context.Open();
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:41.0);
            _rtmMock.SetElapsed(LT#41S);
            _digitalInspector.Inspect(_sequencer,REF(_digitalInspectorData),_inspectedBool);
            Assert.Equal(eInspectorResult#Failed, _digitalInspector.Result());
            
            _context.Close();
        END_METHOD

        {Test}        
        METHOD PUBLIC digital_inspection_coordinator_inspection_ok
            THIS.Initialize();
            

            //Arrange
            _context.Open();
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:30.0);
            _rtmMock.SetElapsed(LT#30S);
            _inspectedBool := TRUE;
            _digitalInspectorData.RequiredStatus := TRUE;

            //Act & Assert

            _digitalInspector.WithCoordinator(_sequencer).Inspect(_sequencer,REF(_digitalInspectorData),_inspectedBool).OnFail().CarryOn();
            _context.Close();

            //+1s
            _context.Open();
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:31.0);
            _rtmMock.SetElapsed(LT#31S);
            _digitalInspector.WithCoordinator(_sequencer).Inspect(_sequencer,REF(_digitalInspectorData),_inspectedBool).OnFail().CarryOn();
            Assert.Equal(eInspectorResult#Running, _digitalInspector.Result());
            _context.Close();
            //+2s
            _context.Open();
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:32.0);
            _rtmMock.SetElapsed(LT#32S);
            _digitalInspector.WithCoordinator(_sequencer).Inspect(_sequencer,REF(_digitalInspectorData),_inspectedBool).OnFail().CarryOn();
            Assert.Equal(eInspectorResult#Passed, _digitalInspector.Result());
            
            _context.Close();
        END_METHOD

        {Test}        
        METHOD PUBLIC digital_inspection_update_comprehensive_inspection_fail
            THIS.Initialize();
            

            //Arrange
            _context.Open();
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:30.0);
            _rtmMock.SetElapsed(LT#30S);
            _inspectedBool := FALSE;
            _digitalInspectorData.RequiredStatus := TRUE;

            //Act & Assert

            _digitalInspector.WithCoordinator(_sequencer).Inspect(_sequencer,REF(_digitalInspectorData),_inspectedBool).UpdateComprehensiveResult(_comprehensiveResult).OnFail().CarryOn();
            _context.Close();

            //+5s
            _context.Open();
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:35.0);
            _rtmMock.SetElapsed(LT#35S);
            _digitalInspector.WithCoordinator(_sequencer).Inspect(_sequencer,REF(_digitalInspectorData),_inspectedBool).UpdateComprehensiveResult(_comprehensiveResult).OnFail().CarryOn();
            Assert.Equal(eInspectorResult#Running, _digitalInspector.Result());
            _context.Close();
            //+11s
            _context.Open();
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:41.0);
            _rtmMock.SetElapsed(LT#41S);
            _digitalInspector.WithCoordinator(_sequencer).Inspect(_sequencer,REF(_digitalInspectorData),_inspectedBool).UpdateComprehensiveResult(_comprehensiveResult).OnFail().CarryOn();
            Assert.Equal(eInspectorResult#Failed, _digitalInspector.Result());
            Assert.Equal(eOverallResult#Failed, _comprehensiveResult.Result);
            _context.Close();
        END_METHOD

        METHOD _SimulateCheckWithDialog 
            VAR_INPUT
                diffTime : LTIME;
            END_VAR
            
            _LocalUtcTime := _LocalUtcTime + diffTime;
            _AcumulatedElaplsedTime := _AcumulatedElaplsedTime + diffTime;

            _context.Open();
            _rtcMock.SetNowUTC(_LocalUtcTime);
            _rtmMock.SetElapsed(_AcumulatedElaplsedTime);

           _digitalInspector.WithCoordinator(_sequencer)
            .Inspect(_sequencer,REF(_digitalInspectorData),_inspectedBool)
            .UpdateComprehensiveResult(_comprehensiveResult , 'Failures', 'ErrorCodes')
            .Dialog(_retryStep, _terminateStep);

            _context.Close();
        END_METHOD

        {Test}        
        METHOD PUBLIC digital_inspection_update_comprehensiveresult_when_fail

            THIS.Initialize();
            
            _LocalUtcTime := LDT#2025-07-07-07:07:01.0;
            _inspectedBool := FALSE; // detected status
            _digitalInspectorData.RequiredStatus := TRUE;
            _digitalInspectorData.PassTime := T#0ms;
            _digitalInspectorData.FailTime := T#0ms;
            _digitalInspectorData.Result := eInspectorResult#NoAction;     
            _comprehensiveResult.Result :=  eOverallresult#NoAction;
            //******************* test start *********************/
            this._SimulateCheckWithDialog(LT#10MS); 
            Assert.Equal(eInspectorResult#Running, _digitalInspector.Result());
            
            this._SimulateCheckWithDialog(LT#100MS); // inspector fail
            
            Assert.Equal(eOverallResult#NoAction, _comprehensiveResult.Result);
            Assert.Equal(eInspectorResult#Failed, _digitalInspector.Result());

            this._SimulateCheckWithDialog(LT#10MS); // wait for dialog
            this._SimulateCheckWithDialog(LT#10MS); // wait for dialog

            Assert.Equal(eOverallResult#NoAction, _comprehensiveResult.Result);
            Assert.Equal(eInspectorResult#Failed, _digitalInspector.Result());

            this._digitalInspector._DL._dialogueTerminate := true; // answer with dialog

            this._SimulateCheckWithDialog(LT#10MS);

            Assert.Equal(eOverallResult#Failed, _comprehensiveResult.Result);
            Assert.Equal('Failures', _comprehensiveResult.GetFailures());
            Assert.Equal('ErrorCodes', _comprehensiveResult.GetErrorCodes());

        END_METHOD

        {Test}        
        METHOD PUBLIC digital_inspection_pass_with_zero_time

            THIS.Initialize();
            
            _LocalUtcTime := LDT#2025-07-07-07:07:01.0;
            _inspectedBool := TRUE; // detected status
            _digitalInspectorData.RequiredStatus := TRUE;
            _digitalInspectorData.PassTime := T#0ms;
            _digitalInspectorData.FailTime := T#20ms;
            _digitalInspectorData.Result := eInspectorResult#NoAction;
            _comprehensiveResult.Result := eOverallresult#InProgress;

            //******************* test *********************/

            Assert.Equal(eOverallResult#InProgress, _comprehensiveResult.Result);
            Assert.Equal(eInspectorResult#NoAction, _digitalInspector.Result());

            this._SimulateCheckWithDialog(LT#10MS); // inpsecotor task in kick status

            Assert.Equal(eOverallResult#InProgress, _comprehensiveResult.Result);
            Assert.Equal(eInspectorResult#Passed, _digitalInspector.Result());

            Assert.Equal(eOverallResult#InProgress, _comprehensiveResult.Result);
            Assert.Equal('', _comprehensiveResult.GetFailures());
            Assert.Equal('', _comprehensiveResult.GetErrorCodes());


        END_METHOD
      
      
       END_CLASS
END_NAMESPACE
