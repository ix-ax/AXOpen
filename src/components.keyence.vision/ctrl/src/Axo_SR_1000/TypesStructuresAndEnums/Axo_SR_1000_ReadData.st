NAMESPACE AXOpen.Components.Keyence.Vision
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Stack)]}
    CLASS PUBLIC Axo_SR_1000_ReadData 
        VAR PUBLIC
            {#ix-set:AttributeName = "<#Result Data Ready Count#>"}
            ResultDataReadyCount : UINT;
            {#ix-set:AttributeName = "<#Result Data Update Count#>"}
            ResultDataUpdateCount : UINT;
            {#ix-set:AttributeName = "<#_Reserved#>"}
            _Reserved : UINT;
            {#ix-set:AttributeName = "<#Result Data Size#>"}
            ResultDataSize : UINT;
            // {#ix-set:AttributeName = "<#Result Data#>"}
            // ResultData : ARRAY[0..245] OF BYTE;
        END_VAR 
    END_CLASS    
END_NAMESPACE