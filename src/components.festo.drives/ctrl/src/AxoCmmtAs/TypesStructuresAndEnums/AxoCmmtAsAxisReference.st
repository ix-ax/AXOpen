
NAMESPACE AXOpen.Components.Festo.Drives
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Tabs)]}
    CLASS AxoCmmtAsAxisReference IMPLEMENTS AXOpen.Components.Abstractions.Drives.IAxoAxisReference
        VAR PUBLIC // Telegram 111
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("Telegram 111")]}
            {#ix-attr:[ReadOnly()]}
            {#ix-set:AttributeName = "<#Telegram111 Inputs#>"}
            Telegram111_In  :   AXOpen.Components.Festo.Drives.PROFIdriveTelegram_111_IN;
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("Telegram 111")]}
            {#ix-attr:[ReadOnly()]}
            {#ix-set:AttributeName = "<#Telegram111 Outputs#>"}
            Telegram111_Out :   AXOpen.Components.Festo.Drives.PROFIdriveTelegram_111_OUT;
        END_VAR
        VAR PUBLIC // Telegram 750
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("Telegram 750")]}
            {#ix-attr:[ReadOnly()]}
            {#ix-set:AttributeName = "<#Telegram750 Inputs#>"}
            Telegram750_In  :   AXOpen.Components.Festo.Drives.PROFIdriveTelegram_750_IN;
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("Telegram 750")]}
            {#ix-attr:[ReadOnly()]}
            {#ix-set:AttributeName = "<#Telegram750 Outputs#>"}
            Telegram750_Out :   AXOpen.Components.Festo.Drives.PROFIdriveTelegram_750_OUT;
        END_VAR   
        VAR PUBLIC // HWIDs
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("HWids")]}
            {#ix-attr:[ReadOnly()]}
            HWIDs  :   AXOpen.Components.Festo.Drives.AxoCmmtAsAxisHWIDs;
        END_VAR          
        VAR PUBLIC // Data
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("Data")]}
            {#ix-attr:[ReadOnly()]}
            Data            :   AXOpen.Components.Festo.Drives.AxoCmmtAsAxisData;
        END_VAR     
        VAR PUBLIC
            Config          :   AXOpen.Components.Drives.AxoDrive_Config;
            Status          :   AXOpen.Components.Drives.AxoDrive_Status;
        END_VAR                   
    END_CLASS
END_NAMESPACE
