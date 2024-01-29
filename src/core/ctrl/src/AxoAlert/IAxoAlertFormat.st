NAMESPACE AXOpen.Core
    INTERFACE PUBLIC IAxoAlertFormat
        METHOD WithTitle : IAxoAlertFormat
            VAR_INPUT
                inTitle : STRING;
            END_VAR
        END_METHOD

        METHOD WithMessage : IAxoAlertFormat
            VAR_INPUT
                inMessage : STRING;
            END_VAR
        END_METHOD

        METHOD WithTimeToBurn : IAxoAlertFormat
            VAR_INPUT
                inSeconds : UINT;
            END_VAR
        END_METHOD

        METHOD WithType : IAxoAlertFormat
            VAR_INPUT
                inDialogType : eDialogType;
            END_VAR
        END_METHOD

        METHOD IsShown : BOOL
        END_METHOD
        
    END_INTERFACE
END_NAMESPACE
