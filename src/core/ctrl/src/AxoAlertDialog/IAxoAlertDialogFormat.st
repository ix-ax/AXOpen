NAMESPACE AXOpen.Core
    INTERFACE PUBLIC IAxoAlertDialogFormat
        METHOD WithTitle : IAxoAlertDialogFormat
            VAR_INPUT
                inTitle : STRING;
            END_VAR
        END_METHOD

        METHOD WithMessage : IAxoAlertDialogFormat
            VAR_INPUT
                inMessage : STRING;
            END_VAR
        END_METHOD

        METHOD WithTimeToBurn : IAxoAlertDialogFormat
            VAR_INPUT
                inSeconds : UINT;
            END_VAR
        END_METHOD

        METHOD WithType : IAxoAlertDialogFormat
            VAR_INPUT
                inDialogType : eDialogType;
            END_VAR
        END_METHOD

        
    END_INTERFACE
END_NAMESPACE