NAMESPACE AXOpen.Components.Rexroth.Drives
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Tabs)]}
    // {#ix-attr:[ReadOnly()]}            
    CLASS PUBLIC AxoCtrlxDriveXsc_Status
        VAR PUBLIC 
            {#ix-set:AttributeName = "<#DriveStatusWord_S_0_0135_0_0#>"}
            // {#ix-attr:[ReadOnly()]}            
            DriveStatusWord_S_0_0135_0_0 : AxoCtrlxDriveXscDriveStatusWord_S_0_0135_0_0;
            {#ix-set:AttributeName = "<#SignalStatusWord_S_0_0144_0_0#>"}
            // {#ix-attr:[ReadOnly()]}            
            SignalStatusWord_S_0_0144_0_0 : AxoCtrlxDriveXscSignalStatusWord_S_0_0144_0_0;
            {#ix-set:AttributeName = "<#ActualPosition_S_0_0386_0_0#>"}
            // {#ix-attr:[ReadOnly()]}            
            ActualPosition_S_0_0386_0_0 : REAL;
            {#ix-set:AttributeName = "<#ActualVelocity_S_0_0535_0_0#>"}
            // {#ix-attr:[ReadOnly()]}            
            ActualVelocity_S_0_0535_0_0 : REAL;
            {#ix-set:AttributeName = "<#DiagnosticMessage_S_0_0390_0_0#>"}
            // {#ix-attr:[ReadOnly()]}            
            DiagnosticMessage_S_0_0390_0_0 : DWORD;
            {#ix-set:AttributeName = "<#SupplyUnitStatusWord_S_0_1720_0_2#>"}
            // {#ix-attr:[ReadOnly()]}            
            SupplyUnitStatusWord_S_0_1720_0_2 : AxoCtrlxDriveXscSupplyUnitStatusWord_S_0_1720_0_2;
            {#ix-set:AttributeName = "<#ActualTorque_S_0_0084_0_0#>"}
            // {#ix-attr:[ReadOnly()]}            
            ActualTorque_S_0_0084_0_0 : REAL;
        END_VAR 
    END_CLASS    
END_NAMESPACE



