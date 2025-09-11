NAMESPACE AXOpen.Components.Dukane.Welders
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Wrap)]}
    CLASS PUBLIC Axo_IQ_SeriesWelder_HMI_status
        VAR PUBLIC 
            {#ix-set:AttributeName = "<#RunningAndActiveSetupNotSame#>"}
            RunningAndActiveSetupNotSame    : BOOL;
            {#ix-set:AttributeName = "<#DisplayApplyScannedFrequency#>"}
            DisplayApplyScannedFrequency    : BOOL;
            {#ix-set:AttributeName = "<#ComsSyncReadOK#>"}
            ComsSyncReadOK                  : BOOL;
            {#ix-set:AttributeName = "<#AsyncWriteIndicator#>"}
            AsyncWriteIndicator             : BOOL;   // Indicates acyclic write request in progress (extended by another 500ms for hmi)
            {#ix-set:AttributeName = "<#AsyncReadIndicator#>"}
            AsyncReadIndicator              : BOOL;   // Indicates acyclic read request in progress (extended by another 500ms for hmi)
            {#ix-set:AttributeName = "<#current_analog_sensor#>"}
            current_analog_sensor           : INT;

        END_VAR 
    END_CLASS    
END_NAMESPACE
