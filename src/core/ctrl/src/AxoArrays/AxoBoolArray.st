NAMESPACE AXOpen.Core
    {S7.extern=ReadWrite}
    CLASS PUBLIC AxoBoolArray 
        VAR PUBLIC
            DataChanged : BOOL;
        END_VAR

        METHOD PUBLIC ToggleDataChangedFlag 
            DataChanged := NOT DataChanged;
        END_METHOD

        VAR PRIVATE 
            _dataChanged : BOOL;
        END_VAR

        METHOD PUBLIC DataHasChanged: BOOL
            DataHasChanged := DataChanged XOR _dataChanged;
            _dataChanged := DataChanged;
        END_METHOD
    END_CLASS
END_NAMESPACE
