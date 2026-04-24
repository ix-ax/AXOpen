NAMESPACE AXOpen.Components.Cognex.Vision
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Stack)]}
    CLASS PUBLIC AxoVisionProNet_Config
        VAR PUBLIC 
            {#ix-set:AttributeName = "<#Info time#>"}
            InfoTime : LTIME := LT#5S;
            {#ix-set:AttributeName = "<#Error time#>"}
            ErrorTime : LTIME := LT#10S;
            {#ix-set:AttributeName = "<#Task timeout#>"}
            TaskTimeout : LTIME := LT#50S;

        END_VAR 
    END_CLASS    
END_NAMESPACE