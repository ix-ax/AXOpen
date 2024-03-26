NAMESPACE Template.Axolibrary
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Stack)]}
    CLASS PUBLIC TemplateComponent_Control
        VAR PUBLIC 
            {#ix-set:AttributeName = "<#Move home signal#>"}
            {#ix-attr:[ReadOnly()]}
            MoveHomeSignal : BOOL;
            {#ix-set:AttributeName = "<#Move work signal#>"}
            {#ix-attr:[ReadOnly()]}
            MoveWorkSignal : BOOL;
        END_VAR 
    END_CLASS    
END_NAMESPACE