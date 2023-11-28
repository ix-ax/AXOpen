// USING AXOpen.Components.Example;
USING AXOpen.Core;
USING AXOpen.Rtc;
USING AXOpen.Logging;

NAMESPACE AxoCmmtAsDriveTests.Tests
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
    CLASS AxoCmmtAsDriveTests
        VAR 
            context : TestContext;
            drive   : AXOpen.Components.Festo.Drives.AxoCmmtAsDrive;
            _AxisIn          :   ARRAY[0..10] OF BYTE;       //  Input data of the axis
            _AxisOut         :   ARRAY[0..10] OF BYTE;       //  Output data of the axis
            _Enable          :   BOOL;                       //  As long as ‘Enable’ is true, power is being enabled.
            _EnablePositive  :   BOOL;                       //  As long as ‘Enable’ is true, this permits motion in positive direction
            _EnableNegative  :   BOOL;                       //  As long as ‘Enable’ is true, this permits motion in negative direction
            _busy : BOOL;
        END_VAR           
        {Test}
        METHOD PUBLIC AxoHome
            AxUnit.Assert.Equal(TRUE,TRUE);   
        END_METHOD
    END_CLASS    
END_NAMESPACE
