NAMESPACE AXOpen.Components.Dukane.Welders
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Wrap)]}
    CLASS PUBLIC Axo_IQ_SeriesWelder_Parameters
        VAR PUBLIC 
            {#ix-set:AttributeName = "<#ProcCtrl#>"}
            ProcCtrl                            : Axo_IQ_SeriesWelder_ProcessControl;       // 0x2100
            {#ix-set:AttributeName = "<#ProcLimits#>"}
            ProcLimits                          : Axo_IQ_SeriesWelder_ProcessLimits;        // 0x210A
            {#ix-set:AttributeName = "<#FreqCtrl#>"}
            FreqCtrl                            : Axo_IQ_SeriesWelder_FreqCtrl;             // 0x2117
            {#ix-set:AttributeName = "<#TriggerByPower#>"}
            TriggerByPower                      : Axo_IQ_SeriesWelder_TriggerByPower;       // 0x211C
            {#ix-set:AttributeName = "<#FreqCtrlMode#>"}
            FreqCtrlMode                        : DINT := 1;                                // 0x2120
            {#ix-set:AttributeName = "<#PowerReg#>"}
            PowerReg                            : Axo_IQ_SeriesWelder_PowerRegulation;      // 0x2129
            {#ix-set:AttributeName = "<#PressPretrigger#>"}
            PressPretrigger                     : Axo_IQ_SeriesWelder_PressPreTrigger;      // 0x212B
            {#ix-set:AttributeName = "<#PressTrigger#>"}
            PressTrigger                        : Axo_IQ_SeriesWelder_PressTrigger;         // 0x2130
            {#ix-set:AttributeName = "<#PressTriggerDelay#>"}
            PressTriggerDelay                   : Axo_IQ_SeriesWelder_PressTriggerDelay;    // 0x2132
            {#ix-set:AttributeName = "<#PressWeld#>"}
            PressWeld                           : Axo_IQ_SeriesWelder_PressWeld;            // 0x2136
            {#ix-set:AttributeName = "<#PressWeldScrub#>"}
            PressWeldScrub                      : Axo_IQ_SeriesWelder_PressWeldScrub;       // 0x2142
            {#ix-set:AttributeName = "<#PressPostWeld#>"}
            PressPostWeld                       : Axo_IQ_SeriesWelder_PressPostWeld;        // 0x2144
            {#ix-set:AttributeName = "<#PressLimits#>"}
            PressLimits                         : Axo_IQ_SeriesWelder_PressLimits;          // 0x214B
            {#ix-set:AttributeName = "<#AnalogSensor#>"}
            AnalogSensor                        : Axo_IQ_SeriesWelder_AnalogSensorSpec;     // 0x21AA
            {#ix-set:AttributeName = "<#AfterburstEnable#>"}
            AfterburstEnable                    : DINT;                                     // 0x21D2
            {#ix-set:AttributeName = "<#LimitWeld1TimeEnable#>"}
            LimitWeld1TimeEnable                : Axo_IQ_SeriesWelder_PressLimitEnable;     // 0x21D3
            {#ix-set:AttributeName = "<#LimitWeld1EnergyEnable#>"}
            LimitWeld1EnergyEnable              : Axo_IQ_SeriesWelder_PressLimitEnable;     // 0x21D4
            {#ix-set:AttributeName = "<#LimitWeld1PowerEnable#>"}
            LimitWeld1PowerEnable               : Axo_IQ_SeriesWelder_PressLimitEnable;     // 0x21D5
        END_VAR 
    END_CLASS    
END_NAMESPACE