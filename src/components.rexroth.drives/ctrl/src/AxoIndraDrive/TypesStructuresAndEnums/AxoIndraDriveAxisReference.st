// USING AXOpen.Components.Drives;

NAMESPACE AXOpen.Components.Rexroth.Drives
    {S7.extern=ReadWrite}
    CLASS AxoIndraDriveAxisReference IMPLEMENTS AXOpen.Components.Abstractions.Drives.IAxoAxisReference
        VAR PUBLIC
            FieldBus_In     :   AXOpen.Components.Rexroth.Drives.AxoIndraDriveFieldBusIn;
            FieldBus_Out    :   AXOpen.Components.Rexroth.Drives.AxoIndraDriveFieldBusOut;
            Parameter_In    :   AXOpen.Components.Rexroth.Drives.AxoIndraDriveParameterIn;
            Parameter_Out   :   AXOpen.Components.Rexroth.Drives.AxoIndraDriveParameterOut;
            Data            :   AXOpen.Components.Rexroth.Drives.AxoIndraDriveAxisData;
            Config          :   AXOpen.Components.Drives.AxoDrive_Config;
            Status          :   AXOpen.Components.Drives.AxoDrive_Status;
        END_VAR
    END_CLASS
END_NAMESPACE
