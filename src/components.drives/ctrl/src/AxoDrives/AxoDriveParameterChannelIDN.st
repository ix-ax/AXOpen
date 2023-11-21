USING AXOpen.Core;
NAMESPACE AXOpen.Components.Drives
    CLASS AxoDriveParameterChannelIdnIn
        VAR PUBLIC
            StatusWord  :   WORD;
            Index       :   WORD;
            SubIndex    :   WORD;
            ValueHigh   :   WORD;
            ValueLow    :   WORD;
        END_VAR
    END_CLASS
    CLASS AxoDriveParameterChannelIdnOut
        VAR PUBLIC
            ControlWord :   WORD;
            Index       :   WORD;
            SubIndex    :   WORD;
            ValueHigh   :   WORD;
            ValueLow    :   WORD;
        END_VAR
    END_CLASS
END_NAMESPACE

