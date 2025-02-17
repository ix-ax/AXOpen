USING AxUnit;
USING AXOpen.Core;

NAMESPACE AXOpen.Inspectors.AxoInspector_Tests  

    {TestFixture}
    {S7.extern=ReadWrite}
    CLASS AxoDataInspectorTests
        VAR PROTECTED
            _context : TestContext;
            _dataInspector    : AxoDataInspector;
            _dataInspectorData    : AxoDataInspectorData;
            _inspectedData : STRING;
            _sequencer  : AxoSequencer;
            _rtcMock :  AxoRtcMock;  
            _rtmMock : AxoRtmMock;

        END_VAR  

        VAR
            _contextBlank : TestContext;
            _dataInspectorBlank    : AxoDataInspector;            
            _sequencerBlank  : AxoSequencer;                                                
        END_VAR  


        {TestSetup}
        METHOD PUBLIC TestSetup
        // Will be called before MyTest_A AND before Test_B are executed
            _context := _contextBlank;
            _dataInspector := _dataInspectorBlank;
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
            _sequencer.Initialize(_context);          
            
            _dataInspectorData.FailTime := T#10s;
            _dataInspectorData.PassTime := T#2s;
        END_METHOD
 
        
        {Test}        
        METHOD PUBLIC data_inspection_correct_data_ok
            THIS.Initialize();
            
            //Arrange
            _context.Open();
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:30.0);
            _rtmMock.SetElapsed(LT#30S);
            _inspectedData := 'hello';
            _dataInspectorData.RequiredStatus := 'hello';

            //Act & Assert

            _dataInspector.Inspect(_sequencer,REF(_dataInspectorData),_inspectedData);
            _context.Close();
            //+1s
            _context.Open();
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:31.0);
            _rtmMock.SetElapsed(LT#31S);
            _dataInspector.Inspect(_sequencer,REF(_dataInspectorData),_inspectedData);
            Assert.Equal(eInspectorResult#Running, _dataInspector.Result());
            _context.Close();
            //+2s
            _context.Open();
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:32.0);
            _rtmMock.SetElapsed(LT#32S);
            _dataInspector.Inspect(_sequencer,REF(_dataInspectorData),_inspectedData);
            Assert.Equal(eInspectorResult#Passed, _dataInspector.Result());
            
            _context.Close();
        END_METHOD

        {Test}        
        METHOD PUBLIC data_inspection_correct_data_with_star_notation_1_ok
            THIS.Initialize();
            
            //Arrange
            _context.Open();
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:30.0);
            _rtmMock.SetElapsed(LT#30S);
            _inspectedData := '3hellow';
            _dataInspectorData.RequiredStatus := '#hello*';
            _dataInspectorData.StarNotationEnabled := TRUE;
            //Act & Assert

            _dataInspector.Inspect(_sequencer,REF(_dataInspectorData),_inspectedData);
            _context.Close();
            //+1s
            _context.Open();
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:31.0);
            _rtmMock.SetElapsed(LT#31S);
            _dataInspector.Inspect(_sequencer,REF(_dataInspectorData),_inspectedData);
            Assert.Equal(eInspectorResult#Running, _dataInspector.Result());
            _context.Close();
            //+2s
            _context.Open();
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:32.0);
            _rtmMock.SetElapsed(LT#32S);
            _dataInspector.Inspect(_sequencer,REF(_dataInspectorData),_inspectedData);
            Assert.Equal(eInspectorResult#Passed, _dataInspector.Result());
            
            _context.Close();
        END_METHOD

        {Test}        
        METHOD PUBLIC data_inspection_correct_data_with_star_notation_2_ok
            THIS.Initialize();
            
            //Arrange
            _context.Open();
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:30.0);
            _rtmMock.SetElapsed(LT#30S);
            _inspectedData := '3he1llowww';
            _dataInspectorData.RequiredStatus := '#he#llo***';
            _dataInspectorData.StarNotationEnabled := TRUE;
            //Act & Assert

            _dataInspector.Inspect(_sequencer,REF(_dataInspectorData),_inspectedData);
            _context.Close();
            //+1s
            _context.Open();
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:31.0);
            _rtmMock.SetElapsed(LT#31S);
            _dataInspector.Inspect(_sequencer,REF(_dataInspectorData),_inspectedData);
            Assert.Equal(eInspectorResult#Running, _dataInspector.Result());
            _context.Close();
            //+2s
            _context.Open();
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:32.0);
            _rtmMock.SetElapsed(LT#32S);
            _dataInspector.Inspect(_sequencer,REF(_dataInspectorData),_inspectedData);
            Assert.Equal(eInspectorResult#Passed, _dataInspector.Result());
            
            _context.Close();
        END_METHOD

        {Test}        
        METHOD PUBLIC data_inspection_correct_data_with_star_notation_3_ok
            THIS.Initialize();
            
            //Arrange
            _context.Open();
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:30.0);
            _rtmMock.SetElapsed(LT#30S);
            _inspectedData := 'h3He1llow';
            _dataInspectorData.RequiredStatus := '*#*e#llo*';
            _dataInspectorData.StarNotationEnabled := TRUE;
            //Act & Assert

            _dataInspector.Inspect(_sequencer,REF(_dataInspectorData),_inspectedData);
            _context.Close();
            //+1s
            _context.Open();
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:31.0);
            _rtmMock.SetElapsed(LT#31S);
            _dataInspector.Inspect(_sequencer,REF(_dataInspectorData),_inspectedData);
            Assert.Equal(eInspectorResult#Running, _dataInspector.Result());
            _context.Close();
            //+2s
            _context.Open();
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:32.0);
            _rtmMock.SetElapsed(LT#32S);
            _dataInspector.Inspect(_sequencer,REF(_dataInspectorData),_inspectedData);
            Assert.Equal(eInspectorResult#Passed, _dataInspector.Result());
            
            _context.Close();
        END_METHOD

        {Test}        
        METHOD PUBLIC data_inspection_incorrect_required_data_fail
            THIS.Initialize();
            
            //Arrange
            _context.Open();
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:30.0);
            _rtmMock.SetElapsed(LT#30S);
            _inspectedData := 'hello';
            _dataInspectorData.RequiredStatus := 'hellow';

            //Act & Assert

            _dataInspector.Inspect(_sequencer,REF(_dataInspectorData),_inspectedData);
            _context.Close();
            //+1s
            _context.Open();
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:31.0);
            _rtmMock.SetElapsed(LT#31S);
            _dataInspector.Inspect(_sequencer,REF(_dataInspectorData),_inspectedData);
            Assert.Equal(eInspectorResult#Running, _dataInspector.Result());
            _context.Close();
            //+11s
            _context.Open();
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:41.0);
            _rtmMock.SetElapsed(LT#41S);
            _dataInspector.Inspect(_sequencer,REF(_dataInspectorData),_inspectedData);
            Assert.Equal(eInspectorResult#Failed, _dataInspector.Result());
            
            _context.Close();
        END_METHOD

        {Test}        
        METHOD PUBLIC data_inspection_incorrect_inspected_data_fail
            THIS.Initialize();
            
            //Arrange
            _context.Open();
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:30.0);
            _rtmMock.SetElapsed(LT#30S);
            _inspectedData := 'hellow';
            _dataInspectorData.RequiredStatus := 'hello';

            //Act & Assert

            _dataInspector.Inspect(_sequencer,REF(_dataInspectorData),_inspectedData);
            _context.Close();
            //+1s
            _context.Open();
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:31.0);
            _rtmMock.SetElapsed(LT#31S);
            _dataInspector.Inspect(_sequencer,REF(_dataInspectorData),_inspectedData);
            Assert.Equal(eInspectorResult#Running, _dataInspector.Result());
            _context.Close();
            //+11s
            _context.Open();
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:41.0);
            _rtmMock.SetElapsed(LT#41S);
            _dataInspector.Inspect(_sequencer,REF(_dataInspectorData),_inspectedData);
            Assert.Equal(eInspectorResult#Failed, _dataInspector.Result());
            
            _context.Close();
        END_METHOD
     
      
       END_CLASS
END_NAMESPACE
