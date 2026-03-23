NAMESPACE AXOpen.Components.Drives
    {#ix-attr:[Container(Layout.Wrap)]}
    {S7.extern=ReadWrite}
    CLASS AxoDrive_Config 
        VAR PUBLIC
            {#ix-set:AttributeName = "<#Info time#>"}
            InfoTime : LTIME := LT#2S;
            {#ix-set:AttributeName = "<#Error time#>"}
            ErrorTime : LTIME := LT#5S;
            {#ix-set:AttributeName = "<#Task timeout#>"}
            TaskTimeout : LTIME := LT#50S;
            {#ix-set:AttributeName = "<#InTorque window percentage#>"}
            InTorqueWindowPerCent     :   LREAL := LREAL#5.0;
            {#ix-set:AttributeName = "<#InTorque window time#>"}
            InTorqueWindowTime     : LTIME := LT#100ms;
        END_VAR
    END_CLASS 
END_NAMESPACE
