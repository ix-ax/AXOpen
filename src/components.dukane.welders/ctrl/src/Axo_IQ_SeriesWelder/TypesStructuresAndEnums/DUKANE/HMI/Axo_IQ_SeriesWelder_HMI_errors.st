NAMESPACE AXOpen.Components.Dukane.Welders
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Wrap)]}
    CLASS PUBLIC Axo_IQ_SeriesWelder_HMI_errors
        VAR PUBLIC 
            {#ix-set:AttributeName = "<#Err_B7_iQData#>"}
            Err_B7_iQData                   : BOOL;
            {#ix-set:AttributeName = "<#Err_B0_iQData#>"}
            Err_B0_iQData                   : BOOL;
            {#ix-set:AttributeName = "<#Err_B7_CopySetup#>"}
            Err_B7_CopySetup                : BOOL;
            {#ix-set:AttributeName = "<#Err_B0_CopySetup#>"}
            Err_B0_CopySetup                : BOOL;
            {#ix-set:AttributeName = "<#Err_B0_ConnectionLost#>"}
            Err_B0_ConnectionLost           : BOOL;
            {#ix-set:AttributeName = "<#Err_RDREC_Parameters#>"}
            Err_RDREC_Parameters            : BOOL;
            {#ix-set:AttributeName = "<#Err_RDREC_ScanFreq#>"}
            Err_RDREC_ScanFreq              : BOOL;
            {#ix-set:AttributeName = "<#Err_RDREC_ModelNumber#>"}
            Err_RDREC_ModelNumber           : BOOL;
            {#ix-set:AttributeName = "<#Err_RDREC_SerialNumber#>"}
            Err_RDREC_SerialNumber          : BOOL;
            {#ix-set:AttributeName = "<#Err_RDREC_MB_FirmwareVersion#>"}
            Err_RDREC_MB_FirmwareVersion    : BOOL;
            {#ix-set:AttributeName = "<#Err_RDREC_FP_FirmwareVersion#>"}
            Err_RDREC_FP_FirmwareVersion    : BOOL;
            {#ix-set:AttributeName = "<#Err_RDREC_MB_BootLoaderVersion#>"}
            Err_RDREC_MB_BootLoaderVersion  : BOOL;
            {#ix-set:AttributeName = "<#Err_RDREC_FP_BootLoaderVersion#>"}
            Err_RDREC_FP_BootLoaderVersion  : BOOL;
            {#ix-set:AttributeName = "<#Err_availble#>"}
            Err_availble                    : BOOL;
            {#ix-set:AttributeName = "<#Err_iQ_AnyFault#>"}
            Err_iQ_AnyFault                 : BOOL;
            
        END_VAR 
    END_CLASS    
END_NAMESPACE