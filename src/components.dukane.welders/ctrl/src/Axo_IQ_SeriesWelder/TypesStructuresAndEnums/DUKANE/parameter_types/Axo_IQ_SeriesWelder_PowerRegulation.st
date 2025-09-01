NAMESPACE AXOpen.Components.Dukane.Welders
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Wrap)]}
    CLASS PUBLIC Axo_IQ_SeriesWelder_PowerRegulation
        VAR PUBLIC 
            {#ix-set:AttributeName = "<#PowerRegulationEnable#>"}
            PowerRegulationEnable : DINT;
            {#ix-set:AttributeName = "<#PowerRegulationSetpoINT#>"}
            PowerRegulationSetpoINT : DINT;            
        END_VAR 
    END_CLASS    
END_NAMESPACE