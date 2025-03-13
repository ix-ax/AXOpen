NAMESPACE AXOpen.Components.Keyence.Vision
    TYPE
        {S7.extern=ReadWrite}
        Axo_SR_1000_TerminalStatus : 
        STRUCT
            {#ix-set:AttributeName = "<#IN1 Status#>"}
            IN1_Status : BOOL;
            {#ix-set:AttributeName = "<#IN2 Status#>"}
            IN2_Status : BOOL;
            {#ix-set:AttributeName = "<#OUT1 Status#>"}
            OUT1_Status : BOOL;
            {#ix-set:AttributeName = "<#OUT2 Status#>"}
            OUT2_Status : BOOL;
            {#ix-set:AttributeName = "<#OUT3 Status#>"}
            OUT3_Status : BOOL;
        END_STRUCT;
    END_TYPE 
END_NAMESPACE
