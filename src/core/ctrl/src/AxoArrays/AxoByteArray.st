NAMESPACE AXOpen.Core
    {#ix-prop: public string DisplayFormat}
    CLASS PUBLIC AxoByteArray 
        VAR PUBLIC
            DataChanged : BOOL;
        END_VAR

        METHOD PUBLIC ToggleDataChangedFlag 
            DataChanged := NOT DataChanged;
        END_METHOD
    END_CLASS
END_NAMESPACE
