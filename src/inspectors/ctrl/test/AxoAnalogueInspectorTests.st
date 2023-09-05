USING AxUnit;
USING AXOpen.Core;

NAMESPACE AXOpen.Inspectors.AxoInspector_Tests  

    {TestFixture}
    CLASS AxoAnalogueInspectorTests
        VAR PROTECTED
            _context : TestContext;
            _analogueInspector    : AxoAnalogueInspector;
            _inspectedInt : DINT;
            _sequencer  : AxoSequencer;
            _rtcMock :  AxoRtcMock;  

            _testBool : BOOL;

            _testTimer: AXOpen.Timers.OnDelayTimer;
            _testTimeDelay: LTIME;
        END_VAR  

        METHOD PRIVATE Initialize
            _context.InjectRtc(_rtcMock);

            _sequencer.Initialize(_context);          
            
            _analogueInspector.Data()^.FailTime := T#10s;
            _analogueInspector.Data()^.PassTime := T#2s;
        END_METHOD
 
        
        {Test}        
        METHOD PUBLIC analgoue_inspection_inspection_within_bounds_ok
            THIS.Initialize();
            
            //Arrange
            _context.Open();
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:30.0);
            _inspectedINT := 10;
            _analogueInspector.Data()^.RequiredMin := 0;
            _analogueInspector.Data()^.RequiredMax := 15;
            //Act & Assert

            _analogueInspector.Inspect(_sequencer,_inspectedINT);
            //+1s
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:31.0);
            _analogueInspector.Inspect(_sequencer,_inspectedINT);
            Assert.Equal(eInspectorResult#Running, _analogueInspector.Result());
            //+3s.
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:33.0);
            _analogueInspector.Inspect(_sequencer,_inspectedINT);
            Assert.Equal(eInspectorResult#Passed, _analogueInspector.Result());
            
            _context.Close();
        END_METHOD

        {Test}        
        METHOD PUBLIC analgoue_inspection_inspection_outside_bounds_fail
            THIS.Initialize();
            
            //Arrange
            _context.Open();
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:30.0);
            _inspectedINT := 20;
            _analogueInspector.Data()^.RequiredMin := 0;
            _analogueInspector.Data()^.RequiredMax := 15;
            //Act & Assert

            _analogueInspector.Inspect(_sequencer,_inspectedINT);
            //+1s
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:31.0);
            _analogueInspector.Inspect(_sequencer,_inspectedINT);
            Assert.Equal(eInspectorResult#Running, _analogueInspector.Result());
            //+11s
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:41.0);
            _analogueInspector.Inspect(_sequencer,_inspectedINT);
            Assert.Equal(eInspectorResult#Failed, _analogueInspector.Result());
            
            _context.Close();
        END_METHOD

        
      
       END_CLASS
END_NAMESPACE
