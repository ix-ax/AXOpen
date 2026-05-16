NAMESPACE AXOpen.Components.Keyence.Vision
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Stack)]}
    CLASS PUBLIC Axo_SR_750_CompletionClearControl  
        VAR PUBLIC
            {#ix-set:AttributeName = "<#Read Complete Clear#>"}
            ReadCompleteClear :  BOOL;
            {#ix-set:AttributeName = "<#Preset Complete Clear#>"}
            PresetCompleteClear :  BOOL;
            {#ix-set:AttributeName = "<#Register Preset Data Complete Clear#>"}
            RegisterPresetDataCompleteClear :  BOOL;
            {#ix-set:AttributeName = "<#Tune Complete Clear#>"}
            TuneCompleteClear : BOOL;
            {#ix-set:AttributeName = "<#EXT. Request Complete Clear#>"}
            EXT_RequestCompleteClear :  BOOL;
        END_VAR 
    END_CLASS    
END_NAMESPACE