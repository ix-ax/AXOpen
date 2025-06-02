// USING AXOpen.Components.Drives;

NAMESPACE AXOpen.Components.Rexroth.Drives
    {S7.extern=ReadWrite}
    CLASS AxoCtrlxDriveXscAxisReference IMPLEMENTS AXOpen.Components.Abstractions.Drives.IAxoAxisReference
        VAR PUBLIC
            FieldBus_In     :   AXOpen.Components.Rexroth.Drives.AxoCtrlxDriveXscFieldBusIn;
            FieldBus_Out    :   AXOpen.Components.Rexroth.Drives.AxoCtrlxDriveXscFieldBusOut;
            Parameter_In    :   AXOpen.Components.Rexroth.Drives.AxoCtrlxDriveXscParameterIn;
            Parameter_Out   :   AXOpen.Components.Rexroth.Drives.AxoCtrlxDriveXscParameterOut;
            Data            :   AXOpen.Components.Rexroth.Drives.AxoCtrlxDriveXscAxisData;
            Config          :   AXOpen.Components.Drives.AxoDrive_Config;
            Status          :   AXOpen.Components.Drives.AxoDrive_Status;
        END_VAR
    END_CLASS
END_NAMESPACE
