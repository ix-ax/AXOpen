NAMESPACE AXOpen.Components.Keyence.Vision
    TYPE
        {S7.extern=ReadWrite}
        Axo_SR_1000_CompletionClearControl : 
        STRUCT
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
        END_STRUCT;
    END_TYPE 
END_NAMESPACE
