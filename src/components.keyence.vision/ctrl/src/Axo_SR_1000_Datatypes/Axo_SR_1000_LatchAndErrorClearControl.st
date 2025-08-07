NAMESPACE AXOpen.Components.Keyence.Vision
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Stack)]}
    CLASS PUBLIC Axo_SR_1000_LatchAndErrorClearControl 
        VAR PUBLIC
            {#ix-set:AttributeName = "<#Result Data Latch#>"}
            ResultDataLatch :  BOOL;
            {#ix-set:AttributeName = "<#Error Clear#>"}
            ErrorClear :  BOOL;
        END_VAR 
    END_CLASS    
END_NAMESPACE