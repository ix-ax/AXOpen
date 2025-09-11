NAMESPACE AXOpen.Components.Dukane.Welders
    //second data record buffer type (record read) 136bytes total
    //statring at index 0x2129 (8489) - power regulation enable
    //last contained index is 0x214A
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Wrap)]}
    CLASS PUBLIC Axo_IQ_SeriesWelder_data2_136bytes
        VAR PUBLIC 
            {#ix-set:AttributeName = "<#PowerReg#>"}
            PowerReg            : Axo_IQ_SeriesWelder_PowerRegulation;      // 0x2129
            {#ix-set:AttributeName = "<#PressPretrigger#>"}
            PressPretrigger     : Axo_IQ_SeriesWelder_PressPreTrigger;      // 0x212B
            {#ix-set:AttributeName = "<#PressTrigger#>"}
            PressTrigger        : Axo_IQ_SeriesWelder_PressTrigger;         // 0x2130
            {#ix-set:AttributeName = "<#PressTriggerDelay#>"}
            PressTriggerDelay   : Axo_IQ_SeriesWelder_PressTriggerDelay;    // 0x2132
            {#ix-set:AttributeName = "<#PressWeld#>"}
            PressWeld           : Axo_IQ_SeriesWelder_PressWeld;            // 0x2136
            {#ix-set:AttributeName = "<#PressWeldScrub#>"}
            PressWeldScrub      : Axo_IQ_SeriesWelder_PressWeldScrub;       // 0x2142
            {#ix-set:AttributeName = "<#PressPostWeld#>"}
            PressPostWeld       : Axo_IQ_SeriesWelder_PressPostWeld;        // 0x2144
        END_VAR 
    END_CLASS  
END_NAMESPACE
