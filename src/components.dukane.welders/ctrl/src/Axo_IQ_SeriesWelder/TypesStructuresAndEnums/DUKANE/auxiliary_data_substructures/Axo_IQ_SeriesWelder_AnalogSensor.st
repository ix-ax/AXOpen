NAMESPACE AXOpen.Components.Dukane.Welders
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Wrap)]}
    CLASS PUBLIC Axo_IQ_SeriesWelder_AnalogSensor
        VAR PUBLIC 
            {#ix-set:AttributeName = "<#Enable#>"}
            Enable      : DINT;
            {#ix-set:AttributeName = "<#MIN_VOLT#>"}
            MIN_VOLT    : DINT;
            {#ix-set:AttributeName = "<#MAX_VOLT#>"}
            MAX_VOLT    : DINT;
            {#ix-set:AttributeName = "<#MIN_VAL#>"}
            MIN_VAL     : DINT;
            {#ix-set:AttributeName = "<#MAX_VAL#>"}
            MAX_VAL     : DINT;
        END_VAR 
    END_CLASS 
END_NAMESPACE
