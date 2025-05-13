NAMESPACE AXOpen.Components.Keyence.Vision
    TYPE
        {#ix-attr:[Container(Layout.Stack)]}
        {S7.extern=ReadWrite}
        Axo_SR_750_Config : 
        STRUCT
            {#ix-set:AttributeName = "<#Continous reading#>"}
            ContinuousReading : BOOL := FALSE;
            {#ix-set:AttributeName = "<#Info time#>"}
            InfoTime : LTIME := LT#2S;
            {#ix-set:AttributeName = "<#Error time#>"}
            ErrorTime : LTIME := LT#5S;
            {#ix-set:AttributeName = "<#Result data size#>"}
            {S7.extern=ReadOnly}
            ResultDataSize : eAxo_SR_750_ResultDataSize := eAxo_SR_750_ResultDataSize#RESULT_DATA_SIZE_INVALID;
            {#ix-set:AttributeName = "<#User data size#>"}
            {S7.extern=ReadOnly}
            UserDataSize : eAxo_SR_750_UserDataSize := eAxo_SR_750_UserDataSize#USER_DATA_SIZE_INVALID;        
        END_STRUCT;
    END_TYPE 
END_NAMESPACE
