// USING AXOpen.Components.Drives;

NAMESPACE AXOpen.Components.Rexroth.Drives
    {S7.extern=ReadWrite}
    CLASS AxoCtrlxDriveXscAxisReference IMPLEMENTS AXOpen.Components.Abstractions.Drives.IAxoAxisReference
        VAR PUBLIC // HWin
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("HW inputs")]}
            {#ix-attr:[ReadOnly()]}
            Inputs  :   AxoCtrlxDriveXsc_Status;
        END_VAR
        VAR PUBLIC // HWout
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("HW outputs")]}
            // {#ix-attr:[ReadOnly()]}
            Outputs  :   AxoCtrlxDriveXsc_Control;
        END_VAR
        VAR PUBLIC // HWIDs
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("HWids")]}
            {#ix-attr:[ReadOnly()]}
            HWIDs  :   AxoCtrlxDriveXscHWIDs;
        END_VAR     
        VAR PUBLIC // Data
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("Data")]}
            {#ix-attr:[ReadOnly()]}
            Data            :   AXOpen.Components.Rexroth.Drives.AxoCtrlxDriveXscAxisData;
        END_VAR                
        VAR PUBLIC
            Config          :   AXOpen.Components.Drives.AxoDrive_Config;
            Status          :   AXOpen.Components.Drives.AxoDrive_Status;
        END_VAR
    END_CLASS
END_NAMESPACE
