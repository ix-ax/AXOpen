NAMESPACE AXOpen.Components.Keyence.Vision
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Stack)]}
    CLASS PUBLIC Axo_SR_750_OperationalResultStatus  
        VAR PUBLIC
            {#ix-set:AttributeName = "<#Read Result Code#>"}
            ReadResultCode :  UINT;
            {#ix-set:AttributeName = "<#Preset Result Code#>"}
            PresetResultCode :  UINT;
            {#ix-set:AttributeName = "<#Register Preset Data Result Code#>"}
            RegisterPresetDataResultCode :  UINT;
            {#ix-set:AttributeName = "<#Tune Result Code#>"}
            TuneResultCode :  UINT;
            {#ix-set:AttributeName = "<#_Reserved[0]#>"}
            _Reserved_0 :  UINT;
            {#ix-set:AttributeName = "<#_Reserved[1]#>"}
            _Reserved_1 :  UINT;
            {#ix-set:AttributeName = "<#_Reserved[2]#>"}
            _Reserved_2 :  UINT;
            {#ix-set:AttributeName = "<#EXT. Request Result Code#>"}
            EXT_RequestResultCode :  UINT;
            {#ix-set:AttributeName = "<#General Error Code#>"}
            GeneralErrorCode :  UINT;
            {#ix-set:AttributeName = "<#_Reserved[3]#>"}
            _Reserved_3 :  UINT;
        END_VAR 
    END_CLASS    
END_NAMESPACE