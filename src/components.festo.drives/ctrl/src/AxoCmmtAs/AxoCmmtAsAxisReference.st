// USING AXOpen.Components.Drives;

NAMESPACE AXOpen.Components.Festo.Drives
    {S7.extern=ReadWrite}
    CLASS AxoCmmtAsAxisReference IMPLEMENTS AXOpen.Components.Abstractions.Drives.IAxoAxisReference
        VAR PUBLIC
            Telegram111_In  :   AXOpen.Components.Festo.Drives.PROFIdriveTelegram_111_IN;
            Telegram111_Out :   AXOpen.Components.Festo.Drives.PROFIdriveTelegram_111_OUT;
            Telegram750_In  :   AXOpen.Components.Festo.Drives.PROFIdriveTelegram_750_IN;
            Telegram750_Out :   AXOpen.Components.Festo.Drives.PROFIdriveTelegram_750_OUT;
            Data            :   AXOpen.Components.Festo.Drives.AxoCmmtAsAxisData;
            Config          :   AXOpen.Components.Drives.AxoDrive_Config;
            Status          :   AXOpen.Components.Drives.AxoDrive_Status;
        END_VAR
    END_CLASS
END_NAMESPACE
