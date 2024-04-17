NAMESPACE Template.Axolibrary
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Stack)]}
    CLASS PUBLIC TemplateComponent_Config
        VAR PUBLIC 
            {#ix-set:AttributeName = "<#Info time#>"}
            InfoTime : LTIME := LT#5S;
            {#ix-set:AttributeName = "<#Error time#>"}
            ErrorTime : LTIME := LT#10S;
        END_VAR 
    END_CLASS    
END_NAMESPACE