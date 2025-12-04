NAMESPACE AXOpen.Io
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Stack)]}
    CLASS PUBLIC AxoHwDiag_Config
        VAR PUBLIC 
            {#ix-set:AttributeName = "<#Info time#>"}
<<<<<<< HEAD
            InfoTime : LTIME := LT#5S;
            {#ix-set:AttributeName = "<#Error time#>"}
            ErrorTime : LTIME := LT#10S;
            {#ix-set:AttributeName = "<#Task timeout#>"}
            TaskTimeout : LTIME := LT#50S;
=======
            InfoTime : LTIME := LT#0S;
            {#ix-set:AttributeName = "<#Error time#>"}
            ErrorTime : LTIME := LT#0S;
            {#ix-set:AttributeName = "<#Task timeout#>"}
            TaskTimeout : LTIME := LT#0S;
>>>>>>> 878
            {#ix-set:AttributeName = "<#Hardware IDs#>"}
            HWIDs : AxoHwDiag_HWIDs;
        END_VAR 
    END_CLASS    
END_NAMESPACE

