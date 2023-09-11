NAMESPACE AXOpen.Components.Cognex.Vision.v_6_0_0_0
    TYPE
        {#ix-attr:[Container(Layout.Wrap)]}
        AxoInsight_Config : 
        STRUCT
            {#ix-set:AttributeName = "<#Info time#>"}
            InfoTime : LTIME := LT#2S;
            {#ix-set:AttributeName = "<#Error time#>"}
            ErrorTime : LTIME := LT#5S;
            {#ix-set:AttributeName = "<#Max job number#>"}
            MaxJobNumber : UINT := UINT#999;
        END_STRUCT;
    END_TYPE 
END_NAMESPACE