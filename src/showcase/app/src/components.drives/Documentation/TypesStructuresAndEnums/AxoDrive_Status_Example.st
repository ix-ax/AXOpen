NAMESPACE AXOpen.Components.Drives
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Tabs)]}
    CLASS PUBLIC AxoDrive_Status_Example
        VAR PUBLIC 
            {#ix-set:AttributeName = "<#DriveStatusWord#>"}
            DriveStatusWord : WORD;
            {#ix-set:AttributeName = "<#ActualPosition#>"}
            ActualPosition : DINT;
            {#ix-set:AttributeName = "<#ActualVelocity#>"}
            ActualVelocity : DINT;
            {#ix-set:AttributeName = "<#DiagnosticMessage#>"}
            DiagnosticMessage : DWORD;
            {#ix-set:AttributeName = "<#ActualTorque#>"}
            ActualTorque : INT;
        END_VAR 
    END_CLASS    
END_NAMESPACE



