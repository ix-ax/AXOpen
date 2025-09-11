NAMESPACE AXOpen.Components.Dukane.Welders
    //second data record buffer type (record read) 136bytes total
    //statring at index 0x214B (8523) - trigger time limit - enable
    //last contained index is 0x2177
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Wrap)]}
    CLASS PUBLIC Axo_IQ_SeriesWelder_data3_180bytes
        VAR PUBLIC 
            {#ix-set:AttributeName = "<#TriggerTime#>"}
            TriggerTime             : Axo_IQ_SeriesWelder_PressLimit;   // 0x214B
            {#ix-set:AttributeName = "<#TriggerPosition#>"}
            TriggerPosition         : Axo_IQ_SeriesWelder_PressLimit;   // 0x2150
            {#ix-set:AttributeName = "<#TriggerDelayTime#>"}
            TriggerDelayTime        : Axo_IQ_SeriesWelder_PressLimit;   // 0x2155
            {#ix-set:AttributeName = "<#TriggerDelayDistance#>"}
            TriggerDelayDistance    : Axo_IQ_SeriesWelder_PressLimit;   // 0x215A
            {#ix-set:AttributeName = "<#Weld1Distance#>"}
            Weld1Distance           : Axo_IQ_SeriesWelder_PressLimit;   // 0x215F
            {#ix-set:AttributeName = "<#Weld1Position#>"}
            Weld1Position           : Axo_IQ_SeriesWelder_PressLimit;   // 0x2164
            {#ix-set:AttributeName = "<#Weld2Time#>"}
            Weld2Time               : Axo_IQ_SeriesWelder_PressLimit;   // 0x2169
            {#ix-set:AttributeName = "<#Weld2Energy#>"}
            Weld2Energy             : Axo_IQ_SeriesWelder_PressLimit;   // 0x216E
            {#ix-set:AttributeName = "<#Weld2Power#>"}
            Weld2Power              : Axo_IQ_SeriesWelder_PressLimit;   // 0x2173
        END_VAR 
    END_CLASS
END_NAMESPACE
