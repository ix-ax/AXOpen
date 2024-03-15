NAMESPACE AXOpen.Components.SIEM.Identification
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Stack)]}
    CLASS PUBLIC AxoIOLink_RF200Device_Config 
        VAR PUBLIC 
            {#ix-set:AttributeName = "<#Info time#>"}
            InfoTime : LTIME := LT#2S;
            {#ix-set:AttributeName = "<#Error time#>"}
            ErrorTime : LTIME := LT#5S;
        END_VAR 
    END_CLASS    
END_NAMESPACE
