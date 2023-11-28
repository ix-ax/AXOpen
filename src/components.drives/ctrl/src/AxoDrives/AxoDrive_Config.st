NAMESPACE AXOpen.Components.Drives
    {#ix-attr:[Container(Layout.Wrap)]}
    {S7.extern=ReadWrite}
    CLASS AxoDrive_Config 
        VAR PUBLIC
            {#ix-set:AttributeName = "<#Info time#>"}
            InfoTime : LTIME := LT#2S;
            {#ix-set:AttributeName = "<#Error time#>"}
            ErrorTime : LTIME := LT#5S;
        END_VAR
    END_CLASS 
END_NAMESPACE
