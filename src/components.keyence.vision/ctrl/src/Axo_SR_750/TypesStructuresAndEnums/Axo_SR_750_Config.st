NAMESPACE AXOpen.Components.Keyence.Vision
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Stack)]}
    CLASS PUBLIC Axo_SR_750_Config  
        VAR PUBLIC 
            {#ix-set:AttributeName = "<#Continous reading#>"}
            ContinuousReading : BOOL := FALSE;
            {#ix-set:AttributeName = "<#Info time#>"}
            InfoTime : LTIME := LT#2S;
            {#ix-set:AttributeName = "<#Error time#>"}
            ErrorTime : LTIME := LT#5S;
            {#ix-set:AttributeName = "<#Task timeout#>"}
            TaskTimeout : LTIME := LT#50S;
            {#ix-set:AttributeName = "<#Hardware IDs#>"}
            HWIDs : Axo_SR_750_HWIDs;
            {#ix-set:AttributeName = "<#Result data size#>"}
            {S7.extern=ReadOnly}
            ResultDataSize : eAxo_SR_750_ResultDataSize := eAxo_SR_750_ResultDataSize#RESULT_DATA_SIZE_INVALID;
            {#ix-set:AttributeName = "<#User data size#>"}
            {S7.extern=ReadOnly}
            UserDataSize : eAxo_SR_750_UserDataSize := eAxo_SR_750_UserDataSize#USER_DATA_SIZE_INVALID;        
        END_VAR 
    END_CLASS    
END_NAMESPACE