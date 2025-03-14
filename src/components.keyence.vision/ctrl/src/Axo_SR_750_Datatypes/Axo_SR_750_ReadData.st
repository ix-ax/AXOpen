NAMESPACE AXOpen.Components.Keyence.Vision
    TYPE
        {S7.extern=ReadWrite}
        Axo_SR_750_ReadData : 
        STRUCT
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
        END_STRUCT;
    END_TYPE 
END_NAMESPACE
