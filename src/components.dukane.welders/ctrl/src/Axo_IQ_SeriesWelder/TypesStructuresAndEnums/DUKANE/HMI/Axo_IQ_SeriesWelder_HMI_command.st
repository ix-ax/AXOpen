NAMESPACE AXOpen.Components.Dukane.Welders
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Wrap)]}
    CLASS PUBLIC Axo_IQ_SeriesWelder_HMI_command
        VAR PUBLIC 
            {#ix-set:AttributeName = "<#read_active_setup#>"}
            read_active_setup           : BOOL;
            {#ix-set:AttributeName = "<#copy_setup#>"}
            copy_setup                  : BOOL;
            {#ix-set:AttributeName = "<#flip_freq_tracking_compat#>"}
            flip_freq_tracking_compat   : BOOL;   // Legacy comatibility type of contol of frequecny control mode (only switching to "Frequency tracking" and "Profiled")
            {#ix-set:AttributeName = "<#apply_scanned_freq#>"}
            apply_scanned_freq          : BOOL;
            {#ix-set:AttributeName = "<#dont_apply_scanned_freq#>"}
            dont_apply_scanned_freq     : BOOL;
            {#ix-set:AttributeName = "<#selected_analog_sensor#>"}
            selected_analog_sensor      : INT;   // selected analog sensor to be displayed/edited
        END_VAR 
    END_CLASS    
END_NAMESPACE