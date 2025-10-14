NAMESPACE AXOpen.Components.Zebra.Vision
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Wrap)]}
    CLASS PUBLIC AxoEA3600_In
        VAR PUBLIC 
            {#ix-set:AttributeName = "<#Fragmented#>"}
            Status_Fragmented               :   BOOL;   // Set if barcode is fragmented
            {#ix-set:AttributeName = "<#First fragment#>"}
            Status_FirstFragment            :   BOOL;   // Set on first block of fragmented barcode
            {#ix-set:AttributeName = "<#Middle fragment#>"}
            Status_MiddleFragment           :   BOOL;   // Set on intermediate blocks of fragmented barcode
            {#ix-set:AttributeName = "<#Last fragment#>"}
            Status_LastFragment             :   BOOL;   // Set on last block of fragmented barcode
            {#ix-attr:[RenderIgnore()]} 
            Status_Reserved_12              :   BOOL;   // Reserved / unused
            {#ix-attr:[RenderIgnore()]} 
            Status_Reserved_13              :   BOOL;   // Reserved / unused
            {#ix-attr:[RenderIgnore()]} 
            Status_Reserved_14              :   BOOL;   // Reserved / unused
            {#ix-attr:[RenderIgnore()]} 
            Status_Reserved_15              :   BOOL;   // Reserved / unused
            {#ix-set:AttributeName = "<#Transfer enabled#>"}
            Status_TransferEnabled          :   BOOL;   // Set if barcode transfer is enabled
            {#ix-set:AttributeName = "<#Handshake enabled#>"}
            Status_HandshakeEnabled         :   BOOL;   // Set if transfer handshaking is enabled
            {#ix-set:AttributeName = "<#Fragmentation enabled#>"}
            Status_FragmentationEnabled     :   BOOL;   // Set if fragmentation of large barcodes is enabled
            {#ix-set:AttributeName = "<#Cache overflow#>"}
            Status_CacheOverflow            :   BOOL;   // Set if internal scanner cache overflows
            {#ix-set:AttributeName = "<#Input data overflow#>"}
            Status_InputDataOverflow        :   BOOL;   // Set if barcode data is larger than 494 bytes and is truncated
            {#ix-set:AttributeName = "<#Waiting for handshake#>"}
            Status_WaitingForHandshake      :   BOOL;   // Set if transfer is waiting for a handshake
            {#ix-set:AttributeName = "<#Trigger state#>"}
            Status_TriggerState             :   BOOL;   // Set when the trigger is pulled, cleared when released.
            {#ix-set:AttributeName = "<#Scanner type#>"}
            Status_ScannerType              :   BOOL;   // Reserved / unused
            {#ix-set:AttributeName = "<#Update counter#>"}
            UpdateCounter                   :   UINT;   // Incremented to indicate new barcode data
            {#ix-set:AttributeName = "<#Barcode type#>"}
            BarcodeType                     :   INT;    // Type of barcode contained in the Data field.
            {#ix-set:AttributeName = "<#Number of scanners#>"}
            NumberOfAttachedScanners        :   BYTE;
            {#ix-set:AttributeName = "<#Battery charge state#>"}
            BatteryStateOfCharge            :   BYTE;
            {#ix-set:AttributeName = "<#Battery voltage#>"}
            BatteryVoltage                  :   INT;
            {#ix-set:AttributeName = "<#Battery temperature#>"}
            BatteryTemp                     :   INT;
            {#ix-attr:[RenderIgnore()]} 
            BatteryDateOfManufacture        :   ARRAY[0..7] OF BYTE;    // Reserved for future expansion
            {#ix-attr:[RenderIgnore()]} 
            Reserved                        :   INT;
            {#ix-set:AttributeName = "<#Length of the data#>"}
            Length                          :   UINT;   // Length of barcode data in the Data field
            Data                            :   ARRAY[0..63] OF BYTE;   // Barcode data
        END_VAR 
    END_CLASS    
END_NAMESPACE