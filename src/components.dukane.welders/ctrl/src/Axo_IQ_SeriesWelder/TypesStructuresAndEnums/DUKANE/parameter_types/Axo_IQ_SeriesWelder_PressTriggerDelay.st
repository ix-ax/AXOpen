NAMESPACE AXOpen.Components.Dukane.Welders
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Wrap)]}
    CLASS PUBLIC Axo_IQ_SeriesWelder_PressTriggerDelay
        VAR PUBLIC 
            {#ix-set:AttributeName = "<#TriggerDelaySource#>"}
            TriggerDelaySource : DINT;
            {#ix-set:AttributeName = "<#TriggerDelayTimeout#>"}
            TriggerDelayTimeout : DINT;
            {#ix-set:AttributeName = "<#TriggerDelayTime#>"}
            TriggerDelayTime : DINT;
            {#ix-set:AttributeName = "<#TriggerDelayDistance#>"}
            TriggerDelayDistance : DINT;
        END_VAR 
    END_CLASS   
END_NAMESPACE
