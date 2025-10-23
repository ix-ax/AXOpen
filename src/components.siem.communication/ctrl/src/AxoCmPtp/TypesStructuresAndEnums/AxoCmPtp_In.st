NAMESPACE AXOpen.Components.Siem.Communication
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Wrap)]}
    CLASS PUBLIC AxoCmPtp_In
        VAR PUBLIC 
            {#ix-set:AttributeName = "<#Status#>"}
            {#ix-attr:[ReadOnly()]}
            Status           :   AxoCmPtp_Status;
        END_VAR 
    END_CLASS    
END_NAMESPACE