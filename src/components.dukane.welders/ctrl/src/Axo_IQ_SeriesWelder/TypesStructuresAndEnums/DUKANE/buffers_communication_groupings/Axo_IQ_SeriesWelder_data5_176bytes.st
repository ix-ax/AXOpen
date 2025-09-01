NAMESPACE AXOpen.Components.Dukane.Welders
    //0x21AA - 0x21D5
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Wrap)]}
    CLASS PUBLIC Axo_IQ_SeriesWelder_data5_176bytes
        VAR PUBLIC 
            {#ix-set:AttributeName = "<#ProcCtrl#>"}
            AnalogSensor            : Axo_IQ_SeriesWelder_AnalogSensorSpec;     // 0x21AA
            AfterburstEnable        : DINT;                                     // 0x21D2
            LimitWeld1TimeEnable    : Axo_IQ_SeriesWelder_PressLimitEnable;     // 0x21D3
            LimitWeld1EnergyEnable  : Axo_IQ_SeriesWelder_PressLimitEnable;     // 0x21D4
            LimitWeld1PowerEnable   : Axo_IQ_SeriesWelder_PressLimitEnable;     // 0x21D5
        END_VAR 
    END_CLASS    
END_NAMESPACE