NAMESPACE AXOpen.Components.Dukane.Welders
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Wrap)]}
    CLASS PUBLIC Axo_IQ_SeriesWelder_FreqCtrl
        VAR PUBLIC 
            {#ix-set:AttributeName = "<#FreerunFrequency#>"}
            FreerunFrequency : DINT;
            {#ix-set:AttributeName = "<#LowerFrequencyBound#>"}
            LowerFrequencyBound : DINT;
            {#ix-set:AttributeName = "<#UpperFrequencyBound#>"}
            UpperFrequencyBound : DINT;
            {#ix-set:AttributeName = "<#LockandHoldModeEnable#>"}
            LockandHoldModeEnable : DINT;
            {#ix-set:AttributeName = "<#USPhaseAdjustment#>"}
            USPhaseAdjustment : DINT;
        END_VAR 
    END_CLASS    
END_NAMESPACE
