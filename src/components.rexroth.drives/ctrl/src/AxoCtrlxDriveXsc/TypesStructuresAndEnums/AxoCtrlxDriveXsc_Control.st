NAMESPACE AXOpen.Components.Rexroth.Drives
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Tabs)]}
    CLASS PUBLIC AxoCtrlxDriveXsc_Control
        VAR PUBLIC 
            {#ix-set:AttributeName = "<#DriveControlWord_S_0_0134_0_0#>"}
            DriveControlWord_S_0_0134_0_0 : AxoCtrlxDriveXscDriveControlWord_S_0_0134_0_0;
            {#ix-set:AttributeName = "<#SignalControlWord_S_0_0145_0_0#>"}
            SignalControlWord_S_0_0145_0_0 :    AxoCtrlxDriveXscSignalControlWord_S_0_0145_0_0;
            {#ix-set:AttributeName = "<#CommandPosition_S_0_0282_0_0#>"}
            CommandPosition_S_0_0282_0_0 : DINT;
            {#ix-set:AttributeName = "<#CommandVelocity_S_0_0259_0_0#>"}
            CommandVelocity_S_0_0259_0_0 : DINT;
            {#ix-set:AttributeName = "<#CommandAcceleration_S_0_0260_0_0#>"}
            CommandAcceleration_S_0_0260_0_0 : DINT;
            {#ix-set:AttributeName = "<#CommandDecceleration_S_0_0359_0_0#>"}
            CommandDecceleration_S_0_0359_0_0 : DINT;
            {#ix-set:AttributeName = "<#SupplyUnitControlWord_S_0_1720_0_1#>"}
            SupplyUnitControlWord_S_0_1720_0_1  : AxoCtrlxDriveXscSupplyUnitControlWord_S_0_1720_0_1;
            {#ix-set:AttributeName = "<#BipolarTorqueLimitation_S_0_0092_0_0#>"}
            BipolarTorqueLimitation_S_0_0092_0_0: INT;
            {#ix-set:AttributeName = "<#CommandTorque_S_0_0080_0_0#>"}
            CommandTorque_S_0_0080_0_0 : INT;
            {#ix-set:AttributeName = "<#CommandJerk_S_0_0193_0_0#>"}
            CommandJerk_S_0_0193_0_0 : DINT;
        END_VAR 
    END_CLASS    
END_NAMESPACE