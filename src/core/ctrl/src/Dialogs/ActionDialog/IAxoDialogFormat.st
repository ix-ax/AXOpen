NAMESPACE AXOpen.Core
    INTERFACE PUBLIC IAxoDialogFormat
        METHOD WithCaption : IAxoDialogAnswer
            VAR_INPUT
                inCaption : STRING;
            END_VAR
        END_METHOD
        METHOD WithOk : IAxoDialogAnswer
        END_METHOD
        METHOD WithText : IAxoDialogAnswer
            VAR_INPUT
                inText : STRING;
            END_VAR
        END_METHOD
        METHOD WithType : IAxoDialogAnswer
            VAR_INPUT
                inDialogType : eDialogType;
            END_VAR
        END_METHOD
        METHOD WithYesNo : IAxoDialogAnswer
        END_METHOD
        METHOD WithYesNoCancel : IAxoDialogAnswer
        END_METHOD
    END_INTERFACE
END_NAMESPACE