USING AxUnit;
USING AXOpen.Core;

NAMESPACE AXOpen.Inspectors.AxoInspector_Tests  

    {TestFixture}
    {S7.extern=ReadWrite}
    CLASS AxoDigitalInspectorTests
        VAR PROTECTED
            _context : TestContext;
            _digitalInspector    : AxoDigitalInspector;
            _inspectedBool : BOOL;
            _sequencer  : AxoSequencer;
            _rtcMock :  AxoRtcMock;  

            _testBool : BOOL;

            _testTimer: AXOpen.Timers.OnDelayTimer;
            _testTimeDelay: LTIME;

            _comprehensiveResult: AxoComprehensiveResult;
        END_VAR  

        
        VAR
            _contextBlank : TestContext;
            _digitalInspectorBlank    : AxoDigitalInspector;            
            _sequencerBlank  : AxoSequencer;                                                
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

            _sequencer.Initialize(_context);          
            
            _digitalInspector.Data()^.FailTime := T#10s;
            _digitalInspector.Data()^.PassTime := T#2s;
        END_METHOD
 
        
        {Test}        
        METHOD PUBLIC digital_inspection_inspection_true_ok
            THIS.Initialize();
            
            //Arrange
            _context.Open();
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:30.0);
            _inspectedBool := TRUE;
            _digitalInspector.Data()^.RequiredStatus := TRUE;

            //Act & Assert

            _digitalInspector.Inspect(_sequencer,_inspectedBool);
            _context.Close();
            //+1s
            _context.Open();
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:31.0);
            _digitalInspector.Inspect(_sequencer,_inspectedBool);
            Assert.Equal(eInspectorResult#Running, _digitalInspector.Result());
            _context.Close();
            //+2s
            _context.Open();
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:32.0);
            _digitalInspector.Inspect(_sequencer,_inspectedBool);
            Assert.Equal(eInspectorResult#Passed, _digitalInspector.Result());
            
            _context.Close();
        END_METHOD

        {Test}        
        METHOD PUBLIC digital_inspection_inspection_false_ok
            THIS.Initialize();
            
            //Arrange
            _context.Open();
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:30.0);
            _inspectedBool := FALSE;
            _digitalInspector.Data()^.RequiredStatus := FALSE;

            //Act & Assert

            _digitalInspector.Inspect(_sequencer,_inspectedBool);
            _context.Close();
            //+1s
            _context.Open();
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:31.0);
            _digitalInspector.Inspect(_sequencer,_inspectedBool);
            Assert.Equal(eInspectorResult#Running, _digitalInspector.Result());
            _context.Close();
            //+2s
            _context.Open();
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:32.0);
            _digitalInspector.Inspect(_sequencer,_inspectedBool);
            Assert.Equal(eInspectorResult#Passed, _digitalInspector.Result());
            
            _context.Close();
        END_METHOD

        {Test}        
        METHOD PUBLIC digital_inspection_inspection_true_fail
            THIS.Initialize();
            
            //Arrange
            _context.Open();
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:30.0);
            _inspectedBool := TRUE;
            _digitalInspector.Data()^.RequiredStatus := FALSE;

            //Act & Assert

            _digitalInspector.Inspect(_sequencer,_inspectedBool);
            _context.Close();
            //+5s
            _context.Open();
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:35.0);
            _digitalInspector.Inspect(_sequencer,_inspectedBool);
            Assert.Equal(eInspectorResult#Running, _digitalInspector.Result());
            _context.Close();
            //+11s
            _context.Open();
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:41.0);
            _digitalInspector.Inspect(_sequencer,_inspectedBool);
            Assert.Equal(eInspectorResult#Failed, _digitalInspector.Result());
            
            _context.Close();
        END_METHOD

        {Test}        
        METHOD PUBLIC digital_inspection_inspection_false_fail
            THIS.Initialize();
            
            //Arrange
            _context.Open();
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:30.0);
            _inspectedBool := FALSE;
            _digitalInspector.Data()^.RequiredStatus := TRUE;

            //Act & Assert

            _digitalInspector.Inspect(_sequencer,_inspectedBool);
            _context.Close();
            //+5s
            _context.Open();
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:35.0);
            _digitalInspector.Inspect(_sequencer,_inspectedBool);
            Assert.Equal(eInspectorResult#Running, _digitalInspector.Result());
            _context.Close();
            //+11s
            _context.Open();
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:41.0);
            _digitalInspector.Inspect(_sequencer,_inspectedBool);
            Assert.Equal(eInspectorResult#Failed, _digitalInspector.Result());
            
            _context.Close();
        END_METHOD

        {Test}        
        METHOD PUBLIC digital_inspection_coordinator_inspection_ok
            THIS.Initialize();
            

            //Arrange
            _context.Open();
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:30.0);
            _inspectedBool := TRUE;
            _digitalInspector.Data()^.RequiredStatus := TRUE;

            //Act & Assert

            _digitalInspector.WithCoordinator(_sequencer).Inspect(_sequencer,_inspectedBool).OnFail().CarryOn();
            _context.Close();

            //+1s
            _context.Open();
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:31.0);
            _digitalInspector.WithCoordinator(_sequencer).Inspect(_sequencer,_inspectedBool).OnFail().CarryOn();
            Assert.Equal(eInspectorResult#Running, _digitalInspector.Result());
            _context.Close();
            //+2s
            _context.Open();
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:32.0);
            _digitalInspector.WithCoordinator(_sequencer).Inspect(_sequencer,_inspectedBool).OnFail().CarryOn();
            Assert.Equal(eInspectorResult#Passed, _digitalInspector.Result());
            
            _context.Close();
        END_METHOD

        {Test}        
        METHOD PUBLIC digital_inspection_update_comprehensive_inspection_fail
            THIS.Initialize();
            

            //Arrange
            _context.Open();
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:30.0);
            _inspectedBool := FALSE;
            _digitalInspector.Data()^.RequiredStatus := TRUE;

            //Act & Assert

            _digitalInspector.WithCoordinator(_sequencer).Inspect(_sequencer,_inspectedBool).UpdateComprehensiveResult(_comprehensiveResult).OnFail().CarryOn();
            _context.Close();

            //+5s
            _context.Open();
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:35.0);
            _digitalInspector.WithCoordinator(_sequencer).Inspect(_sequencer,_inspectedBool).UpdateComprehensiveResult(_comprehensiveResult).OnFail().CarryOn();
            Assert.Equal(eInspectorResult#Running, _digitalInspector.Result());
            _context.Close();
            //+11s
            _context.Open();
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:41.0);
            _digitalInspector.WithCoordinator(_sequencer).Inspect(_sequencer,_inspectedBool).UpdateComprehensiveResult(_comprehensiveResult).OnFail().CarryOn();
            Assert.Equal(eInspectorResult#Failed, _digitalInspector.Result());
            Assert.Equal(eOverallResult#Failed, _comprehensiveResult.Result);
            _context.Close();
        END_METHOD

      
       END_CLASS
END_NAMESPACE
