NAMESPACE AXOpen.Components.Zebra.Vision
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Wrap)]}
    CLASS PUBLIC AxoEA3600_Out
        VAR PUBLIC 
            Ctrl_Reserved_8             : BOOL;   // Reserved / unused
            Ctrl_Reserved_9             : BOOL;   // Reserved / unused
            Ctrl_Reserved_10            : BOOL;   // Reserved / unused
            Ctrl_Reserved_11            : BOOL;   // Reserved / unused
            Ctrl_Reserved_12            : BOOL;   // Reserved / unused
            Ctrl_Reserved_13            : BOOL;   // Reserved / unused
            Ctrl_Reserved_14            : BOOL;   // Reserved / unused
            Ctrl_Reserved_15            : BOOL;   // Reserved / unused
            Ctrl_EnableTransfer         : BOOL;   // Set to enable barcode transfer
            Ctrl_EnableHandshake        : BOOL;   // Set to enable transfer handshaking
            Ctrl_EnableFragmentation    : BOOL;   // Set to enable fragmentation of large barcodes
            Ctrl_Reserved_3             : BOOL;   // Reserved / unused
            Ctrl_ClearFaults            : BOOL;   // Set to clear faults in the scanner barcode transfer interface
            Ctrl_StartScan              : BOOL;   // Set to start scan session.
            Ctrl_StopScan               : BOOL;   // Set to stop scan session.
            Ctrl_SendAction             : BOOL;   // Set to trigger the scanner user action.
            AckCounter                  : UINT;   // Used in transfer handshaking to indicate that the data block has been processed
            UIActionCode                : WORD;   // Scanner user indication code
        END_VAR 
    END_CLASS    
END_NAMESPACE