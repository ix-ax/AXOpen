NAMESPACE AXOpen.Components.Keyence.Vision
    TYPE
        {S7.extern=ReadWrite}
        Axo_SR_1000_OperationInstructionControl : 
        STRUCT
            {#ix-set:AttributeName = "<#Read Request#>"}
            ReadRequest :  BOOL;
            {#ix-set:AttributeName = "<#Preset Request#>"}
            PresetRequest :  BOOL;
            {#ix-set:AttributeName = "<#Register Preset Data Request#>"}
            RegisterPresetDataRequest :  BOOL;
            {#ix-set:AttributeName = "<#Tune Request#>"}
            TuneRequest :  BOOL;
        END_STRUCT;
    END_TYPE 
END_NAMESPACE
