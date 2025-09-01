NAMESPACE AXOpen.Components.Dukane.Welders
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Wrap)]}
    CLASS PUBLIC Axo_IQ_SeriesWelder_In
        VAR PUBLIC 
            {#ix-set:AttributeName = "<#Status#>"}
            {#ix-attr:[ReadOnly()]}
            Status           :   Axo_IQ_SeriesWelder_Status;
        END_VAR 
    END_CLASS    
END_NAMESPACE