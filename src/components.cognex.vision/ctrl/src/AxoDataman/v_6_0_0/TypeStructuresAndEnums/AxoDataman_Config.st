NAMESPACE AXOpen.Components.Cognex.Vision.v_6_0_0_0
    TYPE
        {#ix-attr:[Container(Layout.Stack)]}
        {S7.extern=ReadWrite}
        AxoDataman_Config : 
        STRUCT
            {#ix-set:AttributeName = "<#Continous reading#>"}
            ContinuousReading : BOOL := FALSE;
            {#ix-set:AttributeName = "<#Info time#>"}
            InfoTime : LTIME := LT#2S;
            {#ix-set:AttributeName = "<#Error time#>"}
            ErrorTime : LTIME := LT#5S;
            {#ix-set:AttributeName = "<#Result data size#>"}
            ResultDataSize : eAxoDataman_ResultDataSize := eAxoDataman_ResultDataSize#RESULT_DATA_SIZE_INVALID;
            {#ix-set:AttributeName = "<#User data size#>"}
            UserDataSize : eAxoDataman_UserDataSize := eAxoDataman_UserDataSize#USER_DATA_SIZE_INVALID;        
        END_STRUCT;
    END_TYPE 
END_NAMESPACE
