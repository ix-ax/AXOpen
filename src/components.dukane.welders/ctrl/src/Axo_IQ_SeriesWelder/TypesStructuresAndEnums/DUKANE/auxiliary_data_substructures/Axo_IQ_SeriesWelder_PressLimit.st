NAMESPACE AXOpen.Components.Dukane.Welders
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Wrap)]}
    CLASS PUBLIC Axo_IQ_SeriesWelder_PressLimit
        VAR PUBLIC 
            {#ix-set:AttributeName = "<#Enable#>"}
            Enable : Axo_IQ_SeriesWelder_PressLimitEnable;
            {#ix-set:AttributeName = "<#LowerBad#>"}
            LowerBad : DINT;
            {#ix-set:AttributeName = "<#LowerSuspect#>"}
            LowerSuspect : DINT;
            {#ix-set:AttributeName = "<#UpperSuspect#>"}
            UpperSuspect : DINT;
            {#ix-set:AttributeName = "<#UpperBad#>"}
            UpperBad : DINT;
        END_VAR 
    END_CLASS    
END_NAMESPACE