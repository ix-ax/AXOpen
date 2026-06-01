NAMESPACE AXOpen.Components.Keyence.Vision
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Stack)]}
    CLASS PUBLIC Axo_SR_750_ErrorStatus  
        VAR PUBLIC
            {#ix-set:AttributeName = "<#Read Failure#>"}
            ReadFailure : BOOL;
            {#ix-set:AttributeName = "<#Preset Failure#>"}
            PresetFailure : BOOL;
            {#ix-set:AttributeName = "<#Register Preset Data Failure #>"}
            RegisterPresetDataFailure : BOOL;
            {#ix-set:AttributeName = "<#Tune Failure #>"}
            TuneFailure : BOOL;
            {#ix-set:AttributeName = "<#EXT. Request Failure #>"}
            EXT_RequestFailure : BOOL;
        END_VAR 
    END_CLASS    
END_NAMESPACE