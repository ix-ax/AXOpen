NAMESPACE AXOpen.Components.Keyence.Vision
    TYPE
        {S7.extern=ReadWrite}
        Axo_SR_1000_HandshakeAndGeneralErrorStatus : 
        STRUCT
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
        END_STRUCT;
    END_TYPE 
END_NAMESPACE
