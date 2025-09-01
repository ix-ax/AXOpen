NAMESPACE AXOpen.Components.Dukane.Welders
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Wrap)]}
    CLASS PUBLIC Axo_IQ_SeriesWelder_Interface
        VAR PUBLIC 
            {#ix-set:AttributeName = "<#_in#>"}
            _in                      : Axo_IQ_SeriesWelder_SystemInputs;     // Inputs from iQ system - synchronous communication
            {#ix-set:AttributeName = "<#_out#>"}
            _out                     : Axo_IQ_SeriesWelder_SystemOutputs;    // Outputs to iQ system - synchronous communication
            {#ix-set:AttributeName = "<#p#>"}
            p                       : Axo_IQ_SeriesWelder_Parameters;       // Parameters (to be potentialy edited by user)
            {#ix-set:AttributeName = "<#r#>"}
            r                       : Axo_IQ_SeriesWelder_Buffers;          // Read buffers for parameter data transfer and user change detection
            {#ix-set:AttributeName = "<#w#>"}
            w                       : Axo_IQ_SeriesWelder_Buffers;          // Write buffers for parameter transfer to the iQ (also to prevent inconsistent changes during transfer)
            {#ix-set:AttributeName = "<#m#>"}
            m                       : Axo_IQ_SeriesWelder_ModelInfo;        // Information on HW / SW versions etc.
            {#ix-set:AttributeName = "<#hmi#>"}
            hmi                     : Axo_IQ_SeriesWelder_HMI;              // HMI control bits and values (apart from parameters)
            {#ix-set:AttributeName = "<#test_scan_results#>"}
            test_scan_results       : Axo_IQ_SeriesWelder_TestScanResults;
            {#ix-set:AttributeName = "<#copy_setups#>"}
            copy_setups             : Axo_IQ_SeriesWelder_CopySetup;
            {#ix-set:AttributeName = "<#detect_structure_change#>"}
            detect_structure_change : BOOL;                                 // when data structure was changed during development to force a refresh
        END_VAR 
    END_CLASS    
END_NAMESPACE