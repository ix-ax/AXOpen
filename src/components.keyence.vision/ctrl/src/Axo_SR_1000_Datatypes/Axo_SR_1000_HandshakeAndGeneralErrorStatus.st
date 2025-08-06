NAMESPACE AXOpen.Components.Keyence.Vision
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Stack)]}
    CLASS PUBLIC Axo_SR_1000_HandshakeAndGeneralErrorStatus 
        VAR PUBLIC
            {#ix-set:AttributeName = "<#Error#>"}
            Error : BOOL;
            {#ix-set:AttributeName = "<#Result Data Available#>"}
            ResultDataAvailable : BOOL;
            {#ix-set:AttributeName = "<#Result Data Strobe#>"}
            ResultDataStrobe : BOOL;
            {#ix-set:AttributeName = "<#Buffer Overflow Error#>"}
            BufferOverflowError : BOOL;
            {#ix-set:AttributeName = "<#General Error#>"}
            GeneralError : BOOL;
        END_VAR 
    END_CLASS    
END_NAMESPACE