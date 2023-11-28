USING AXOpen.Core;
NAMESPACE AXOpen.Components.Drives
    {S7.extern=ReadWrite}
    CLASS AxoDriveParameterChannelIdnIn
        VAR PUBLIC
            StatusWord  :   WORD;
            Index       :   WORD;
            SubIndex    :   WORD;
            ValueHigh   :   WORD;
            ValueLow    :   WORD;
        END_VAR
    END_CLASS
    {S7.extern=ReadWrite}
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

