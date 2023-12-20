USING AXOpen.Core;
USING AXOpen.Rtc;
USING AXOpen.Logging;

NAMESPACE AxoIO.Tests
    {S7.extern=ReadWrite}
    CLASS TestContext IMPLEMENTS AXOpen.Core.IAxoContext
        VAR
            _openCounter : ULINT;
            _closeCounter : ULINT; 
            _RtcMock : AxoRtcMock;
            _LoggerMock : AxoLoggerMock;
          
        END_VAR

        var PUBLIC
            SignalParent : AxoObject;
        END_VAR
            
        METHOD PUBLIC Open : ULINT
            _openCounter := _openCounter + ULINT#1;
            SignalParent.Initialize(this);
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
            GetRtc :=  _RtcMock;
        END_METHOD

        METHOD PUBLIC InjectRtc
            VAR_INPUT
                Rtc : IAxoRtc;
            END_VAR

            ;
        END_METHOD

        METHOD PUBLIC GetLogger : IAxoLogger
            GetLogger := _LoggerMock;
        END_METHOD

        METHOD PUBLIC InjectLogger
            VAR_INPUT
                _logger : IAxoLogger;
            END_VAR

            ;
        END_METHOD
    END_CLASS
END_NAMESPACE
