NAMESPACE AXOpen.Components.Dukane.Welders
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Wrap)]}
    CLASS PUBLIC Axo_IQ_SeriesWelder_HMI
        VAR PUBLIC 
            {#ix-set:AttributeName = "<#c#>"}
            c : Axo_IQ_SeriesWelder_HMI_command;
            {#ix-set:AttributeName = "<#s#>"}
            s : Axo_IQ_SeriesWelder_HMI_status;
            {#ix-set:AttributeName = "<#e#>"}
            e : Axo_IQ_SeriesWelder_HMI_errors;
            // {#ix-set:AttributeName = "<#read_status#>"}
            read_status : Array[-16..16] of DWORD;
            // {#ix-set:AttributeName = "<#write_status#>"}
            write_status : Array[-16..16] of DWORD;
            {#ix-set:AttributeName = "<#analog_sensor_data#>"}
            analog_sensor_data : Axo_IQ_SeriesWelder_AnalogSensor;   // analog sensor data being currently displayed / to be edited
        END_VAR 
    END_CLASS    
END_NAMESPACE