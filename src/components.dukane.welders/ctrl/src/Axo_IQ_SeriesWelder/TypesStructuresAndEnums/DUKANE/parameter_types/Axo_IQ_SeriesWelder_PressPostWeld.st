NAMESPACE AXOpen.Components.Dukane.Welders
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Wrap)]}
    CLASS PUBLIC Axo_IQ_SeriesWelder_PressPostWeld
        VAR PUBLIC 
            {#ix-set:AttributeName = "<#DynamicHoldMode#>"}
            DynamicHoldMode : Axo_IQ_SeriesWelder_DynamicHoldMode;
            {#ix-set:AttributeName = "<#DynamicHoldTimeout#>"}
            DynamicHoldTimeout : DINT;
            {#ix-set:AttributeName = "<#DynamicHoldDistance#>"}
            DynamicHoldDistance : DINT;
            {#ix-set:AttributeName = "<#DynamicHoldForce#>"}
            DynamicHoldForce : DINT;
            {#ix-set:AttributeName = "<#StaticHoldMode#>"}
            StaticHoldMode : DINT;
            {#ix-set:AttributeName = "<#StaticHoldTime#>"}
            StaticHoldTime : DINT;
            {#ix-set:AttributeName = "<#AfterburstAmplitude#>"}
            AfterburstAmplitude : DINT;
        END_VAR 
    END_CLASS    
END_NAMESPACE
