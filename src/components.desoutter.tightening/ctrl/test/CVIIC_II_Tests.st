USING AXOpen.Core;
USING AXOpen.Rtc;
USING AXOpen.Logging;

NAMESPACE Cylinder.Tests
    {S7.extern=ReadWrite}
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
    {S7.extern=ReadWrite}
    CLASS AxoCVIC_II_Tests 
        VAR 
            context : TestContext;
            screwdriver : AXOpen.Components.Desoutter.Tightening.AxoCVIC_II;
        END_VAR           
        {Test}
        METHOD PUBLIC Reset
            AxUnit.Assert.Equal(TRUE,TRUE);   
        END_METHOD
    END_CLASS    
END_NAMESPACE
