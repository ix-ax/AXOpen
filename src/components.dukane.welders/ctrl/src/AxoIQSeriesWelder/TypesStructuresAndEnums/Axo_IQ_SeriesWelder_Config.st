NAMESPACE AXOpen.Components.Dukane.Welders
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Stack)]}
    CLASS PUBLIC Axo_IQ_SeriesWelder_Config
        VAR PUBLIC 
            {#ix-set:AttributeName = "<#Info time#>"}
            InfoTime : LTIME := LT#5S;
            {#ix-set:AttributeName = "<#Error time#>"}
            ErrorTime : LTIME := LT#10S;
            {#ix-set:AttributeName = "<#Task timeout#>"}
            TaskTimeout : LTIME := LT#50S;
            {#ix-set:AttributeName = "<#Hardware IDs#>"}
            HWIDs : Axo_IQ_SeriesWelder_HWIDs;
        END_VAR 
    END_CLASS    
END_NAMESPACE

