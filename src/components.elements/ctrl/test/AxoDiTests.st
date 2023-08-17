USING AxUnit;
USING AXOpen.Elements;
USING AXOpen.Pneumatics;
USING AXOpen.Core;
USING AXOpen.Rtc;
USING AXOpen.Logging;

NAMESPACE AxoDi.Tests
    CLASS TestContext IMPLEMENTS AXOpen.Core.IAxoContext
        VAR
            _openCounter : ULINT;
            _closeCounter : ULINT; 
        END_VAR
              
        METHOD PUBLIC Open : ULINT
            _openCounter := _openCounter + ULINT#1;
        END_METHOD    

        METHOD PUBLIC Close : ULINT
            _closeCounter := _closeCounter + ULINT#1;
        END_METHOD

        METHOD PUBLIC CreateIdentity : ULINT
            ;
        END_METHOD

        METHOD PUBLIC OpenCycleCount : ULINT
            OpenCycleCount := _openCounter;
        END_METHOD

        METHOD PUBLIC GetRtc : AXOpen.Rtc.IAxoRtc
            ;
        END_METHOD

        METHOD PUBLIC InjectRtc
            VAR_INPUT
                Rtc : IAxoRtc;
            END_VAR

            ;
        END_METHOD

        METHOD PUBLIC GetLogger : IAxoLogger
            ;
        END_METHOD

        METHOD PUBLIC InjectLogger
            VAR_INPUT
                _logger : IAxoLogger;
            END_VAR

            ;
        END_METHOD
    END_CLASS
    {TestFixture}
    CLASS AxoTests 
        VAR 
            context : TestContext;
            _testAxoDi : AxoDi;
            _signal : BOOL;
      
            _done : BOOL;
        END_VAR   

        {Test}
        METHOD PUBLIC CheckForSignalStatusTrue
   
            context.Open();
            _signal := TRUE;
            _testAxoDi.AxoDiSignal(context,_signal);

            AxUnit.Assert.Equal(TRUE, _testAxoDi.IsTrue());
            AxUnit.Assert.Equal(FALSE, _testAxoDi.IsFalse());

            context.Close();            
        
            
            
        END_METHOD

        {Test}
        METHOD PUBLIC CheckForSignalStatusFalse
   
            context.Open();
            _signal := FALSE;
            _testAxoDi.AxoDiSignal(context,_signal);

            AxUnit.Assert.Equal(FALSE, _testAxoDi.IsTrue());
            AxUnit.Assert.Equal(TRUE, _testAxoDi.IsFalse());

            context.Close();            
        
            
            
        END_METHOD

    END_CLASS    
END_NAMESPACE
