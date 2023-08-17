USING AXOpen.Rtc;
USING AXOpen.Logging;
USING AXOpen.Core;
USING AXOpen.Rtc;
USING AxUnit;

NAMESPACE AXOpen.Inspectors.AxoDigitalInspector_Tests  

    CLASS AxoRtcMock IMPLEMENTS IAxoRtc
        VAR PRIVATE 
            _NowUTC : LDATE_AND_TIME;
        END_VAR

        METHOD INTERNAL SetNowUTC : LDATE_AND_TIME
            VAR_INPUT
                Set :  LDATE_AND_TIME;
            END_VAR;
            _NowUTC := Set;
        END_METHOD

        METHOD PUBLIC NowUTC : LDATE_AND_TIME
            NowUTC := _NowUTC;
        END_METHOD        
    END_CLASS

    CLASS TestContext IMPLEMENTS IAxoContext         
        VAR PROTECTED                        
            _openCounter : ULINT;
            _closeCounter : ULINT;
            _identityCounter : ULINT;
            _rtc :  IAxoRtc;
         END_VAR       
        METHOD PUBLIC Open : ULINT
            _openCounter := _openCounter + ULINT#1;
        END_METHOD    

        METHOD PUBLIC Close : ULINT
            _closeCounter := _closeCounter + ULINT#1;
        END_METHOD

        METHOD PUBLIC OpenCycleCount : ULINT
            OpenCycleCount := _openCounter;
        END_METHOD
                
        METHOD PUBLIC ClosedCycleCount : ULINT
            ClosedCycleCount := _closeCounter;
        END_METHOD

        METHOD PUBLIC CreateIdentity : ULINT            
            _identityCounter := _identityCounter + ULINT#1;
            CreateIdentity := _identityCounter;
        END_METHOD         

        METHOD PUBLIC GetRtc : IAxoRtc ; 
            GetRtc := _rtc;
        END_METHOD

        METHOD PUBLIC InjectRtc
             VAR_INPUT Rtc : IAxoRtc; 
            END_VAR ;
        
            _rtc := Rtc;
        END_METHOD
            
        VAR PRIVATE
            NULL_LOGGER : _NULL_LOGGER;
        END_VAR    
        METHOD PUBLIC GetLogger : AXOpen.Logging.IAxoLogger GetLogger := NULL_LOGGER; END_METHOD
        METHOD PUBLIC InjectLogger VAR_INPUT _logger : AXOpen.Logging.IAxoLogger; END_VAR ; END_METHOD
           
    END_CLASS      

    {TestFixture}
    CLASS AxoDigitalInspectorTests
        // VAR PROTECTED
        //     _context : TestContext;
        //     _digitalInspector    : AxoDigitalInspector;
        //     _inspectedBool : BOOL;
        //     _sequencer  : AxoSequencer;
        //     _rtcMock :  AxoRtcMock;  

        //     _testBool : BOOL;

        //     _testTimer: AXOpen.Timers.OnDelayContext;
        //     _testTimeDelay: LTIME;
        // END_VAR  

        // METHOD PRIVATE Initialize
        //     _context.InjectRtc(_rtcMock);
        //     _sequencer.Initialize(_context);            
        // END_METHOD
 
        
        // {Test}        
        // METHOD PUBLIC Timer_test_pass
        //     THIS.Initialize();
            
        //     _context.Open();
        

        //     _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:33.123456);
        //     _testBool := TRUE;
        //     _testTimeDelay := LTIME#13:14:3.45;

        //     _testTimer.Delay(_context,_testBool,_testTimeDelay);
        //     _inspectedBool := TRUE;
        //     _digitalInspector.Data()^.RequiredStatus := TRUE;

        //     _testBool := _digitalInspector.Inspect(_sequencer,_inspectedBool).Done();

        //     _rtcMock.SetNowUTC(LDT#1980-01-23-13:14:38.123456);

        //     _testBool := _digitalInspector.Inspect(_sequencer,_inspectedBool).Done();
        //     //_digitalInspector.WithCoordinator(_sequencer).Inspect(_sequencer,_inspectedBool).OnFail().CarryOn();
            
        // // WHILE NOT  _digitalInspector.Inspect(_sequencer,_inspectedBool).Done() DO
        // //         ;
        // //     END_WHILE;

          
        //     Assert.Equal(eInspectorResult#Passed, _digitalInspector.Data()^.Result);
            
           
        //     _context.Close();
        // END_METHOD

      
       END_CLASS
END_NAMESPACE
