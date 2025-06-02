NAMESPACE AXOpen.Components.Rexroth.Drives
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Wrap)]}
    CLASS PUBLIC AxoCtrlxDriveXsc_In
        VAR PUBLIC 
            {#ix-set:AttributeName = "<#Status#>"}
            {#ix-attr:[ReadOnly()]}
            Status           :   AxoCtrlxDriveXsc_Status;
        END_VAR 
    END_CLASS    
END_NAMESPACE