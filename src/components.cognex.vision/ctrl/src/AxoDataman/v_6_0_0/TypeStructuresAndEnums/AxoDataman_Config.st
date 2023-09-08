NAMESPACE AXOpen.Cognex.Vision.v_6_0_0_0
    TYPE
        {#ix-attr:[Container(Layout.Stack)]}
        AxoDataman_Config : 
        STRUCT
            {#ix-set:AttributeName = "<#Continous reading#>"}
            ContinuousReading : BOOL := FALSE;
            {#ix-set:AttributeName = "<#Info time#>"}
            InfoTime : LTIME := LT#2S;
            {#ix-set:AttributeName = "<#Error time#>"}
            ErrorTime : LTIME := LT#5S;
        END_STRUCT;
    END_TYPE 
END_NAMESPACE