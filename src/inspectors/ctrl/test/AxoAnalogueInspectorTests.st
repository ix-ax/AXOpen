USING AxUnit;
USING AXOpen.Core;

NAMESPACE AXOpen.Inspectors.AxoInspector_Tests  

    {TestFixture}
    {S7.extern=ReadWrite}
    CLASS AxoAnalogueInspectorTests
        VAR PROTECTED
            _context : TestContext;
            _rootObject :   AxoObject;
            _analogueInspector        : AxoInspector;
            _analogueInspectorData    : AxoAnalogueInspectorData;
            _inspectedInt : DINT;
            _sequencer  : AxoSequencer;
            _rtcMock :  AxoRtcMock;  
            _rtmMock :  AxoRtmMock;
            _testBool : BOOL;

            _testTimer: AXOpen.Timers.OnDelayTimer;
            _testTimeDelay: LTIME;
        END_VAR  

        VAR
            _contextBlank : TestContext;
            
            _analogueInspectorBlank    : AxoInspector;            
            _sequencerBlank  : AxoSequencer;                                                
        END_VAR    

        {TestSetup}
        METHOD PUBLIC TestSetup
        // Will be called before MyTest_A AND before Test_B are executed
            _context := _contextBlank;
            _rootObject.InitializeWithContext(_context);
            _analogueInspector := _analogueInspectorBlank;
            _sequencer := _sequencerBlank;
            _context.InjectRtc(_rtcMock);
            _context.InjectRtm(_rtmMock);
            _sequencer.Initialize(_rootObject);              
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
            _context := _contextBlank;
            _rootObject.InitializeWithContext(_context);
            _analogueInspector := _analogueInspectorBlank;
            _sequencer := _sequencerBlank;
            _context.InjectRtc(_rtcMock);
            _context.InjectRtm(_rtmMock);
            _sequencer.Initialize(_rootObject);  
            _analogueInspector.Initialize(_sequencer);

            _analogueInspectorData.FailTime := T#10s;
            _analogueInspectorData.PassTime := T#2s;
        END_METHOD
        
        {Test}        
        METHOD PUBLIC analogue_inspection_inspection_within_bounds_ok
            THIS.Initialize();

            //Arrange
            _context.Open();
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:30.0);
            _context.InjectRtc(_rtcMock);
            _rtmMock.SetElapsed(LT#30S);
            _context.InjectRtm(_rtmMock);

            _inspectedINT := 10;
            _analogueInspectorData.RequiredMin := 0;
            _analogueInspectorData.RequiredMax := 15;
            //Act & Assert
            _analogueInspector.Inspect(_sequencer,REF(_analogueInspectorData),_inspectedINT);
            _context.Close();

            //+1s
            _context.Open();
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:31.0);
            _context.InjectRtc(_rtcMock);
            _rtmMock.SetElapsed(LT#31S);
            _context.InjectRtm(_rtmMock);
            _analogueInspector.Inspect(_sequencer,REF(_analogueInspectorData),_inspectedINT);
            Assert.Equal(eInspectorResult#Running, _analogueInspector.Result());
            _context.Close();

            
            //+3s.
            _context.Open();
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:33.0);
            _rtmMock.SetElapsed(LT#33S);
            _analogueInspector.Inspect(_sequencer,REF(_analogueInspectorData),_inspectedINT);
            Assert.Equal(eInspectorResult#Passed, _analogueInspector.Result());
            
            _context.Close();
        END_METHOD

        {Test}        
        METHOD PUBLIC analogue_inspection_inspection_outside_bounds_fail
            THIS.Initialize();
            
            //Arrange
            _context.Open();
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:30.0);
            _context.InjectRtc(_rtcMock);
            _rtmMock.SetElapsed(LT#30S);
            _context.InjectRtm(_rtmMock);
            _inspectedINT := 20;
            _analogueInspectorData.RequiredMin := 0;
            _analogueInspectorData.RequiredMax := 15;
            //Act & Assert

            _analogueInspector.Inspect(_sequencer,REF(_analogueInspectorData),_inspectedINT);
            _context.Close();
            //+1s
            _context.Open();
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:31.0);
            _context.InjectRtc(_rtcMock);
            _rtmMock.SetElapsed(LT#31S);
            _context.InjectRtm(_rtmMock);
            _analogueInspector.Inspect(_sequencer,REF(_analogueInspectorData),_inspectedINT);
            Assert.Equal(eInspectorResult#Running, _analogueInspector.Result());
            _context.Close();
            //+11s
            _context.Open();
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:41.0);
            _rtmMock.SetElapsed(LT#41S);
            _analogueInspector.Inspect(_sequencer,REF(_analogueInspectorData),_inspectedINT);
            Assert.Equal(eInspectorResult#Failed, _analogueInspector.Result());
            
            _context.Close();
        END_METHOD
    END_CLASS
END_NAMESPACE
