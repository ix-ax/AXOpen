// USING AXOpen.Components.Drives;

NAMESPACE AXOpen.Components.Festo.Drives
    {S7.extern=ReadWrite}
    CLASS AxoCmmtAsDriveAxisReference IMPLEMENTS AXOpen.Components.Abstractions.Drives.IAxoAxisReference
        VAR PUBLIC
            FieldBus_In     :   AXOpen.Components.Festo.Drives.AxoCmmtAsDriveFieldBusIn;
            FieldBus_Out    :   AXOpen.Components.Festo.Drives.AxoCmmtAsDriveFieldBusOut;
            Parameter_In    :   AXOpen.Components.Festo.Drives.AxoCmmtAsDriveParameterIn;
            Parameter_Out   :   AXOpen.Components.Festo.Drives.AxoCmmtAsDriveParameterOut;
            Data            :   AXOpen.Components.Festo.Drives.AxoCmmtAsDriveAxisData;
            Config          :   AXOpen.Components.Drives.AxoDrive_Config;
            Status          :   AXOpen.Components.Drives.AxoDrive_Status;
        END_VAR
    END_CLASS
END_NAMESPACE