USING AxUnit;
USING AXOpen.Core;

NAMESPACE AXOpen.Inspectors.AxoInspector_Tests  

    {TestFixture}
    CLASS AxoDataInspectorTests
        VAR PROTECTED
            _context : TestContext;
            _dataInspector    : AxoDataInspector;
            _inspectedData : STRING;
            _sequencer  : AxoSequencer;
            _rtcMock :  AxoRtcMock;  

        END_VAR  

        METHOD PRIVATE Initialize
            _context.InjectRtc(_rtcMock);

            _sequencer.Initialize(_context);          
            
            _dataInspector.Data()^.FailTime := T#10s;
            _dataInspector.Data()^.PassTime := T#2s;
        END_METHOD
 
        
        {Test}        
        METHOD PUBLIC data_inspection_correct_data_ok
            THIS.Initialize();
            
            //Arrange
            _context.Open();
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:30.0);
            _inspectedData := 'hello';
            _dataInspector.Data()^.RequiredStatus := 'hello';

            //Act & Assert

            _dataInspector.Inspect(_sequencer,_inspectedData);
            //+1s
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:31.0);
            _dataInspector.Inspect(_sequencer,_inspectedData);
            Assert.Equal(eInspectorResult#Running, _dataInspector.Result());
            //+2s
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:32.0);
            _dataInspector.Inspect(_sequencer,_inspectedData);
            Assert.Equal(eInspectorResult#Passed, _dataInspector.Result());
            
            _context.Close();
        END_METHOD

        {Test}        
        METHOD PUBLIC data_inspection_correct_data_with_star_notation_1_ok
            THIS.Initialize();
            
            //Arrange
            _context.Open();
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:30.0);
            _inspectedData := '3hellow';
            _dataInspector.Data()^.RequiredStatus := '#hello*';
            _dataInspector.Data()^.StarNotationEnabled := TRUE;
            //Act & Assert

            _dataInspector.Inspect(_sequencer,_inspectedData);
            //+1s
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:31.0);
            _dataInspector.Inspect(_sequencer,_inspectedData);
            Assert.Equal(eInspectorResult#Running, _dataInspector.Result());
            //+2s
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:32.0);
            _dataInspector.Inspect(_sequencer,_inspectedData);
            Assert.Equal(eInspectorResult#Passed, _dataInspector.Result());
            
            _context.Close();
        END_METHOD

        {Test}        
        METHOD PUBLIC data_inspection_correct_data_with_star_notation_2_ok
            THIS.Initialize();
            
            //Arrange
            _context.Open();
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:30.0);
            _inspectedData := '3he1llowww';
            _dataInspector.Data()^.RequiredStatus := '#he#llo***';
            _dataInspector.Data()^.StarNotationEnabled := TRUE;
            //Act & Assert

            _dataInspector.Inspect(_sequencer,_inspectedData);
            //+1s
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:31.0);
            _dataInspector.Inspect(_sequencer,_inspectedData);
            Assert.Equal(eInspectorResult#Running, _dataInspector.Result());
            //+2s
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:32.0);
            _dataInspector.Inspect(_sequencer,_inspectedData);
            Assert.Equal(eInspectorResult#Passed, _dataInspector.Result());
            
            _context.Close();
        END_METHOD

        {Test}        
        METHOD PUBLIC data_inspection_correct_data_with_star_notation_3_ok
            THIS.Initialize();
            
            //Arrange
            _context.Open();
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:30.0);
            _inspectedData := 'h3He1llow';
            _dataInspector.Data()^.RequiredStatus := '*#*e#llo*';
            _dataInspector.Data()^.StarNotationEnabled := TRUE;
            //Act & Assert

            _dataInspector.Inspect(_sequencer,_inspectedData);
            //+1s
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:31.0);
            _dataInspector.Inspect(_sequencer,_inspectedData);
            Assert.Equal(eInspectorResult#Running, _dataInspector.Result());
            //+2s
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:32.0);
            _dataInspector.Inspect(_sequencer,_inspectedData);
            Assert.Equal(eInspectorResult#Passed, _dataInspector.Result());
            
            _context.Close();
        END_METHOD

        {Test}        
        METHOD PUBLIC data_inspection_incorrect_required_data_fail
            THIS.Initialize();
            
            //Arrange
            _context.Open();
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:30.0);
            _inspectedData := 'hello';
            _dataInspector.Data()^.RequiredStatus := 'hellow';

            //Act & Assert

            _dataInspector.Inspect(_sequencer,_inspectedData);
            //+1s
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:31.0);
            _dataInspector.Inspect(_sequencer,_inspectedData);
            Assert.Equal(eInspectorResult#Running, _dataInspector.Result());
            //+11s
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:41.0);
            _dataInspector.Inspect(_sequencer,_inspectedData);
            Assert.Equal(eInspectorResult#Failed, _dataInspector.Result());
            
            _context.Close();
        END_METHOD

        {Test}        
        METHOD PUBLIC data_inspection_incorrect_inspected_data_fail
            THIS.Initialize();
            
            //Arrange
            _context.Open();
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:30.0);
            _inspectedData := 'hellow';
            _dataInspector.Data()^.RequiredStatus := 'hello';

            //Act & Assert

            _dataInspector.Inspect(_sequencer,_inspectedData);
            //+1s
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:31.0);
            _dataInspector.Inspect(_sequencer,_inspectedData);
            Assert.Equal(eInspectorResult#Running, _dataInspector.Result());
            //+11s
            _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:41.0);
            _dataInspector.Inspect(_sequencer,_inspectedData);
            Assert.Equal(eInspectorResult#Failed, _dataInspector.Result());
            
            _context.Close();
        END_METHOD
     
      
       END_CLASS
END_NAMESPACE
