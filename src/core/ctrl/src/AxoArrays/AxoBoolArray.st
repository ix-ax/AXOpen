NAMESPACE AXOpen.Core
    {S7.extern=ReadWrite}
    CLASS PUBLIC AxoBoolArray 
        VAR PUBLIC
            DataChanged : BOOL;
        END_VAR

        METHOD PUBLIC ToggleDataChangedFlag 
            DataChanged := NOT DataChanged;
        END_METHOD
    END_CLASS
END_NAMESPACE
