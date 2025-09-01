NAMESPACE AXOpen.Components.Dukane.Welders
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Wrap)]}
    CLASS PUBLIC Axo_IQ_SeriesWelder_TriggerByPower
        VAR PUBLIC 
            {#ix-set:AttributeName = "<#Enable#>"}
            Enable                  : DINT;   // 0-Disabled, 1-Enabled
            {#ix-set:AttributeName = "<#Trigger_Timout#>"}
            Trigger_Timout          : DINT;   // Range 0 - 65535 mS
            {#ix-set:AttributeName = "<#Trigger_Level#>"}
            Trigger_Level           : DINT;   // Range 0 - 65535 Watts
            {#ix-set:AttributeName = "<#PreTrigger_Amplitude#>"}
            PreTrigger_Amplitude    : DINT;   // Range - 20% - 100%            
        END_VAR 
    END_CLASS    
END_NAMESPACE