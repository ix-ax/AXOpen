NAMESPACE AXOpen.Components.Keyence.Vision
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Stack)]}
    CLASS PUBLIC Axo_SR_750_OperationInstructionControl  
        VAR PUBLIC
            {#ix-set:AttributeName = "<#Read Request#>"}
            ReadRequest :  BOOL;
            {#ix-set:AttributeName = "<#Preset Request#>"}
            PresetRequest :  BOOL;
            {#ix-set:AttributeName = "<#Register Preset Data Request#>"}
            RegisterPresetDataRequest :  BOOL;
            {#ix-set:AttributeName = "<#Tune Request#>"}
            TuneRequest :  BOOL;
        END_VAR 
    END_CLASS    
END_NAMESPACE