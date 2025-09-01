NAMESPACE AXOpen.Components.Dukane.Welders
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Wrap)]}
    CLASS PUBLIC Axo_IQ_SeriesWelder_PressPreTrigger
        VAR PUBLIC 
            {#ix-set:AttributeName = "<#PreTriggerSource#>"}
            PreTriggerSource : Axo_IQ_SeriesWelder_PreTriggerSource;
            {#ix-set:AttributeName = "<#Ignore1#>"}
            Ignore1 : DINT;
            {#ix-set:AttributeName = "<#Ignore2#>"}
            Ignore2 : DINT;
            {#ix-set:AttributeName = "<#PreTriggerTime#>"}
            PreTriggerTime : DINT;
            {#ix-set:AttributeName = "<#PreTriggerPosition#>"}
            PreTriggerPosition : DINT;
        END_VAR 
    END_CLASS    
END_NAMESPACE