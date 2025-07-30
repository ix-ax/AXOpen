NAMESPACE AXOpen.Components.Siem.Identification
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Wrap)]}
    CLASS PUBLIC AxoSimaticIdentCyclic_In
        VAR PUBLIC 
            {#ix-set:AttributeName = "<#Status#>"}
            {#ix-attr:[ReadOnly()]}
            Status           :   AxoSimaticIdentCyclic_Status;
        END_VAR 
    END_CLASS    
END_NAMESPACE