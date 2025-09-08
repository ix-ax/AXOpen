NAMESPACE AXOpen.Components.Keyence.Vision
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Stack)]}
    CLASS PUBLIC Axo_IV3_Config
        VAR PUBLIC 
            {#ix-set:AttributeName = "<#Info time#>"}
            InfoTime : LTIME := LT#5S;
            {#ix-set:AttributeName = "<#Error time#>"}
            ErrorTime : LTIME := LT#10S;
            {#ix-set:AttributeName = "<#Task timeout#>"}
            TaskTimeout : LTIME := LT#50S;
            {#ix-set:AttributeName = "<#Maximal program number#>"}
            MaxProgramNumber : UINT := UINT#31;         // by default 31, 127 in case of SDcard used
            {#ix-set:AttributeName = "<#Hardware IDs#>"}
            HWIDs : Axo_IV3_HWIDs;
        END_VAR 
    END_CLASS    
END_NAMESPACE

