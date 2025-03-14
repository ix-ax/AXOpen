NAMESPACE AXOpen.Components.Keyence.Vision
    TYPE
        {S7.extern=ReadWrite}
        Axo_SR_750_ErrorStatus : 
        STRUCT
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
        END_STRUCT;
    END_TYPE 
END_NAMESPACE
