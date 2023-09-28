USING AXOpen.Components.Rexroth.Drives;
USING AXOpen.Core;
USING AXOpen.Rtc;
USING AXOpen.Logging;

NAMESPACE AxoRexrothDrive.Tests
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
    CLASS CylinderTests 
        VAR 
            context : TestContext;
            drive : AxoIndraDrive;
            _refAxisIn       :   REF_TO  ARRAY[*] OF BYTE;   //  Reference to the input data of the axis
            _refAxisOut      :   REF_TO  ARRAY[*] OF BYTE;   //  Reference to the output data of the axis

            _done : BOOL;
        END_VAR           
        {Test}
        METHOD PUBLIC AxoReset
            WHILE _done DO
                context.Open();
                drive.AxoReset();
                drive.Run(context, _refAxisIn, _refAxisOut, FALSE, FALSE, FALSE);
                AxUnit.Assert.Equal(FALSE, FALSE);   
                context.Close();            
            END_WHILE;
            
            
        END_METHOD
    END_CLASS    
END_NAMESPACE
