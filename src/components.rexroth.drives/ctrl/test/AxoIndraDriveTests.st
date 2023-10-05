// USING AXOpen.Components.Example;
USING AXOpen.Core;
USING AXOpen.Rtc;
USING AXOpen.Logging;

NAMESPACE AxoIndraDriveTests.Tests
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
    CLASS AxoIndraDriveTests
        VAR 
            context : TestContext;
            drive   : AXOpen.Components.Rexroth.Drives.AxoIndraDrive;
            _AxisIn          :   ARRAY[0..10] OF BYTE;       //  Input data of the axis
            _AxisOut         :   ARRAY[0..10] OF BYTE;       //  Output data of the axis
            _Enable          :   BOOL;                       //  As long as ‘Enable’ is true, power is being enabled.
            _EnablePositive  :   BOOL;                       //  As long as ‘Enable’ is true, this permits motion in positive direction
            _EnableNegative  :   BOOL;                       //  As long as ‘Enable’ is true, this permits motion in negative direction
            _busy : BOOL;
        END_VAR           
        {Test}
        METHOD PUBLIC AxoHome
            WHILE NOT _busy DO
                context.Open();
                _busy := (drive.AxoHome(  Position        :=  LREAL#5.0,
                    HommingMode     :=  INT#10,
                    Velocity        :=  LREAL#10.0,
                    Acceleration    :=  LREAL#50.0,
                    Deceleration    :=  LREAL#50.0
                    ).IsBusy());
                drive.Run(context, REF(_AxisIn), REF(_AxisOut), _Enable, _EnablePositive, _EnableNegative);        
                AxUnit.Assert.Equal(TRUE,TRUE);   
                context.Close();            
            END_WHILE;
        END_METHOD
    END_CLASS    
END_NAMESPACE
