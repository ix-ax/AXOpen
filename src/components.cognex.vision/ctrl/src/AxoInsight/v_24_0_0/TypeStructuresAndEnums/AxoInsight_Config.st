NAMESPACE AXOpen.Components.Cognex.Vision.v_24_0_0
    TYPE
        {#ix-attr:[Container(Layout.Wrap)]}
        {S7.extern=ReadWrite}
        AxoInsight_Config : 
        STRUCT
            {#ix-set:AttributeName = "<#Info time#>"}
            InfoTime : LTIME := LT#10S;
            {#ix-set:AttributeName = "<#Error time#>"}
            ErrorTime : LTIME := LT#50S;
            {#ix-set:AttributeName = "<#Task timeout#>"}
            TaskTimeout : LTIME := LT#50S;
            {#ix-set:AttributeName = "<#Max job number#>"}
            MaxJobNumber : UINT := UINT#999;
            {#ix-set:AttributeName = "<#Result data size#>"}
            ResultDataSize : UINT;
            {#ix-set:AttributeName = "<#User data size#>"}
            UserDataSize : UINT;
            {#ix-set:AttributeName = "<#Hardware IDs#>"}
            HWIDs : AxoInsight_HWIDs;
        END_STRUCT;
    END_TYPE 
END_NAMESPACE
