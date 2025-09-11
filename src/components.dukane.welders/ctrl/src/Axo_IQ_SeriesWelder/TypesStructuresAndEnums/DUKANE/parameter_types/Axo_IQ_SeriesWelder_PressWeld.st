NAMESPACE AXOpen.Components.Dukane.Welders
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Wrap)]}
    CLASS PUBLIC Axo_IQ_SeriesWelder_PressWeld
        VAR PUBLIC 
            {#ix-set:AttributeName = "<#Weld1Source#>"}
            Weld1Source             : Axo_IQ_SeriesWelder_WeldSource;   // 0x2136
            {#ix-set:AttributeName = "<#Weld1Timeout#>"}
            Weld1Timeout            : DINT;                             // 0x2137
            {#ix-set:AttributeName = "<#Weld1Distance#>"}
            Weld1Distance           : DINT;                             // 0x2138
            {#ix-set:AttributeName = "<#Weld1Position#>"}
            Weld1Position           : DINT;                             // 0x2139
            {#ix-set:AttributeName = "<#Weld2Source#>"}
            Weld2Source             : Axo_IQ_SeriesWelder_WeldSource;   // 0x213A
            {#ix-set:AttributeName = "<#Weld2SecondarySource#>"}
            Weld2SecondarySource    : DINT;                             // 0x213B
            {#ix-set:AttributeName = "<#Weld2Timeout#>"}
            Weld2Timeout            : DINT;                             // 0x213C
            {#ix-set:AttributeName = "<#Weld2Time#>"}
            Weld2Time               : DINT;                             // 0x213D
            {#ix-set:AttributeName = "<#Weld2Energy#>"}
            Weld2Energy             : DINT;                             // 0x213E
            {#ix-set:AttributeName = "<#Weld2Power#>"}
            Weld2Power              : DINT;                             // 0x213F
            {#ix-set:AttributeName = "<#Weld2Distance#>"}
            Weld2Distance           : DINT;                             // 0x2140
            {#ix-set:AttributeName = "<#Weld2Position#>"}
            Weld2Position           : DINT;                             // 0x2141        
        END_VAR 
    END_CLASS
END_NAMESPACE
