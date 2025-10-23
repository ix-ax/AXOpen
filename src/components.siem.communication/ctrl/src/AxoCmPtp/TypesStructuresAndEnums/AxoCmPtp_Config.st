NAMESPACE AXOpen.Components.Siem.Communication
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Stack)]}
    CLASS PUBLIC AxoCmPtp_Config
        VAR PUBLIC 
            {#ix-set:AttributeName = "<#Info time#>"}
            InfoTime : LTIME := LT#5S;
            {#ix-set:AttributeName = "<#Error time#>"}
            ErrorTime : LTIME := LT#0S;
            {#ix-set:AttributeName = "<#Task timeout#>"}
            TaskTimeout : LTIME := LT#0S;
            {#ix-set:AttributeName = "<#Port config#>"}
            PortConfig : AxoCmPtp_PortConfig;
        END_VAR 
    END_CLASS    
END_NAMESPACE

