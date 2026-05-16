NAMESPACE AXOpen.Components.Drives
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Tabs)]}
    CLASS PUBLIC AxoDrive_Control_Example
        VAR PUBLIC 
            {#ix-set:AttributeName = "<#DriveControlWord#>"}
            DriveControlWord : WORD;
            {#ix-set:AttributeName = "<#CommandPosition#>"}
            CommandPosition : DINT;
            {#ix-set:AttributeName = "<#CommandVelocity#>"}
            CommandVelocity : DINT;
            {#ix-set:AttributeName = "<#CommandAcceleration#>"}
            CommandAcceleration : DINT;
            {#ix-set:AttributeName = "<#CommandDecceleration#>"}
            CommandDecceleration : DINT;
            {#ix-set:AttributeName = "<#CommandTorque#>"}
            CommandTorque : INT;
            {#ix-set:AttributeName = "<#CommandJerk#>"}
            CommandJerk : DINT;
        END_VAR 
    END_CLASS    
END_NAMESPACE