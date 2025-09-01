NAMESPACE AXOpen.Components.Dukane.Welders
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Wrap)]}
    CLASS PUBLIC Axo_IQ_SeriesWelder_PressWeldScrub
        VAR PUBLIC 
            {#ix-set:AttributeName = "<#ScrubMode#>"}
            ScrubMode : DINT;
            {#ix-set:AttributeName = "<#ScrubTime#>"}
            ScrubTime : DINT;
        END_VAR 
    END_CLASS    
END_NAMESPACE