NAMESPACE AXOpen.Components.Dukane.Welders
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Wrap)]}
    CLASS PUBLIC Axo_IQ_SeriesWelder_PressTrigger
        VAR PUBLIC 
            {#ix-set:AttributeName = "<#TriggerSource#>"}
            TriggerSource  : Axo_IQ_SeriesWelder_TriggerSource;
            {#ix-set:AttributeName = "<#TriggerByPositionLevel#>"}
            TriggerByPositionLevel : DINT;
        END_VAR 
    END_CLASS    
END_NAMESPACE