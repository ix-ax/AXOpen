NAMESPACE AXOpen.Components.Dukane.Welders
    //second data record buffer type (record read) 128bytes total
    //statring at index 0x2100 (8448) - power regulation enable
    //last contained index is 0x211F
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Wrap)]}
    CLASS PUBLIC Axo_IQ_SeriesWelder_data1_132bytes
        VAR PUBLIC 
            {#ix-set:AttributeName = "<#ProcCtrl#>"}
            ProcCtrl        : Axo_IQ_SeriesWelder_ProcessControl;       // 0x2100
            {#ix-set:AttributeName = "<#ProcLimits#>"}
            ProcLimits      : Axo_IQ_SeriesWelder_ProcessLimits;        // 0x210A
            {#ix-set:AttributeName = "<#FreqCtrl#>"}
            FreqCtrl        : Axo_IQ_SeriesWelder_FreqCtrl;             // 0x2117
            {#ix-set:AttributeName = "<#TriggerByPower#>"}
            TriggerByPower  : Axo_IQ_SeriesWelder_TriggerByPower;       // 0x211C
            {#ix-set:AttributeName = "<#FreqCtrlMode#>"}
            FreqCtrlMode    : DINT;                                     // 0x2120
        END_VAR 
    END_CLASS    
END_NAMESPACE