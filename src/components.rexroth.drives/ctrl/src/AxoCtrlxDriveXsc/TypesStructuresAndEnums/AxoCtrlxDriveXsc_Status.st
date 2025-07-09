NAMESPACE AXOpen.Components.Rexroth.Drives
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Tabs)]}
    CLASS PUBLIC AxoCtrlxDriveXsc_Status
        VAR PUBLIC 
            {#ix-set:AttributeName = "<#DriveStatusWord_S_0_0135_0_0#>"}
            DriveStatusWord_S_0_0135_0_0 : AxoCtrlxDriveXscDriveStatusWord_S_0_0135_0_0;
            {#ix-set:AttributeName = "<#SignalStatusWord_S_0_0144_0_0#>"}
            SignalStatusWord_S_0_0144_0_0 : AxoCtrlxDriveXscSignalStatusWord_S_0_0144_0_0;
            {#ix-set:AttributeName = "<#ActualPosition_S_0_0386_0_0#>"}
            ActualPosition_S_0_0386_0_0 : DINT;
            {#ix-set:AttributeName = "<#ActualVelocity_S_0_0535_0_0#>"}
            ActualVelocity_S_0_0535_0_0 : DINT;
            {#ix-set:AttributeName = "<#DiagnosticMessage_S_0_0390_0_0#>"}
            DiagnosticMessage_S_0_0390_0_0 : DWORD;
            {#ix-set:AttributeName = "<#SupplyUnitStatusWord_S_0_1720_0_2#>"}
            SupplyUnitStatusWord_S_0_1720_0_2 : AxoCtrlxDriveXscSupplyUnitStatusWord_S_0_1720_0_2;
            {#ix-set:AttributeName = "<#ActualTorque_S_0_0084_0_0#>"}
            ActualTorque_S_0_0084_0_0 : INT;
        END_VAR 
    END_CLASS    
END_NAMESPACE



