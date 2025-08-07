NAMESPACE AXOpen.Components.Siem.Identification
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Stack)]}
    CLASS PUBLIC AxoSimaticIdentCyclic_Config
        VAR PUBLIC 
            {#ix-set:AttributeName = "<#Info time#>"}
            InfoTime : LTIME := LT#5S;
            {#ix-set:AttributeName = "<#Error time#>"}
            ErrorTime : LTIME := LT#10S;
            {#ix-set:AttributeName = "<#Task timeout#>"}
            TaskTimeout : LTIME := LT#50S;
            {#ix-set:AttributeName = "<#Port#>"}
            Port    : eAxoSimaticIdentCyclic_Port := eAxoSimaticIdentCyclic_Port#NONE;
            {#ix-set:AttributeName = "<#Reader IO image size (in bytes)#>"}
            IOsize  : eAxoSimaticIdentCyclic_IOsize := eAxoSimaticIdentCyclic_IOsize#INVALID;
            {#ix-set:AttributeName = "<#Hardware IDs#>"}
            HWIDs : AxoSimaticIdentCyclic_HWIDs;
            {#ix-set:AttributeName = "<#Data buffer low index#>"}
            DataBufferLowIndex  :  INT;
            {#ix-set:AttributeName = "<#Data buffer high index#>"}
            DataBufferHighIndex :  INT;
        END_VAR 
    END_CLASS    
END_NAMESPACE
