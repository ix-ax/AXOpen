NAMESPACE Template.Axolibrary
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Stack)]}
    CLASS PUBLIC TemplateComponent_Status
        VAR PUBLIC 
            {#ix-set:AttributeName = "<#Home sensor#>"}
            {#ix-attr:[ReadOnly()]}
            HomeSensor : BOOL;
            {#ix-set:AttributeName = "<#Work sensor#>"}
            {#ix-attr:[ReadOnly()]}
            WorkSensor : BOOL;
        END_VAR 
    END_CLASS    
END_NAMESPACE