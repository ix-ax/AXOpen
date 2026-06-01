USING AXOpen.Core;
USING AXOpen.Messaging.Static;
USING AXOpen.Messaging;
USING AXOpen.Core;
USING AXOpen.Components.Abstractions;
USING AXOpen.Components.Abstractions.Drives;


NAMESPACE AXOpen.Components.Drives
    {S7.extern=ReadWrite}
    CLASS AxoDriveAxisReferenceExample IMPLEMENTS AXOpen.Components.Abstractions.Drives.IAxoAxisReference
        VAR PUBLIC // HWin
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("HW inputs")]}
            {#ix-attr:[ReadOnly()]}
            Inputs  :   AxoDrive_Status_Example;
        END_VAR
        VAR PUBLIC // HWout
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("HW outputs")]}
            {#ix-attr:[ReadOnly()]}
            Outputs  :   AxoDrive_Control_Example;
        END_VAR
        VAR PUBLIC // HWIDs
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("HWids")]}
            {#ix-attr:[ReadOnly()]}
            HWIDs  :   AxoDrive_HWIDs_Example;
        END_VAR     
        VAR PUBLIC // Data
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("Data")]}
            {#ix-attr:[ReadOnly()]}
            Data            :   AxoDrive_Data_Example;
        END_VAR                
        VAR PUBLIC
            Config          :   AXOpen.Components.Drives.AxoDrive_Config;
            Status          :   AXOpen.Components.Drives.AxoDrive_Status;
        END_VAR
    END_CLASS
END_NAMESPACE
