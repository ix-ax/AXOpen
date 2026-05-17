NAMESPACE AXOpen.Components.Keyence.Vision
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Stack)]}
    CLASS PUBLIC Axo_SR_750_CompletionStatus  
        VAR PUBLIC
            {#ix-set:AttributeName = "<#Read Complete#>"}
            ReadComplete : BOOL;
            {#ix-set:AttributeName = "<#Preset Complete#>"}
            PresetComplete : BOOL;
            {#ix-set:AttributeName = "<#Register Preset Data Complete#>"}
            RegisterPresetDataComplete : BOOL;
            {#ix-set:AttributeName = "<#Tune Complete#>"}
            TuneComplete : BOOL;
            {#ix-set:AttributeName = "<#EXT. Request Complete#>"}
            EXT_RequestComplete : BOOL;
        END_VAR 
    END_CLASS    
END_NAMESPACE