NAMESPACE AXOpen.Components.Keyence.Vision
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Stack)]}
    CLASS PUBLIC Axo_SR_750_TerminalStatus 
        VAR PUBLIC
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
        END_VAR 
    END_CLASS    
END_NAMESPACE