NAMESPACE AXOpen.Components.Keyence.Vision
    TYPE
        {S7.extern=ReadWrite}
        Axo_SR_750_LatchAndErrorClearControl : 
        STRUCT
            {#ix-set:AttributeName = "<#Result Data Latch#>"}
            ResultDataLatch :  BOOL;
            {#ix-set:AttributeName = "<#Error Clear#>"}
            ErrorClear :  BOOL;
        END_STRUCT;
    END_TYPE 
END_NAMESPACE
