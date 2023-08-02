NAMESPACE AXOpen.Cognex.Vision.v_6_0_0_0
    TYPE
        {#ix-attr:[Container(Layout.Stack)]}
        AxoDataman_Config : 
        STRUCT
            ContinuousReading : BOOL := FALSE;
            InfoTime : LTIME := LT#2S;
            ErrorTime : LTIME := LT#5S;
        END_STRUCT;
    END_TYPE 
END_NAMESPACE