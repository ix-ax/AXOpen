NAMESPACE AXOpen.Components.Keyence.Vision
    TYPE
        {S7.extern=ReadWrite}
        Axo_SR_1000_CompletionStatus : 
        STRUCT
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
        END_STRUCT;
    END_TYPE 
END_NAMESPACE