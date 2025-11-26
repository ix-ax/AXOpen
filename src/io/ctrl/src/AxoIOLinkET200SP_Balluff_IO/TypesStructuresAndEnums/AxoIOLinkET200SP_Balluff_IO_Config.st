NAMESPACE AXOpen.Io
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Stack)]}
    CLASS PUBLIC AxoIOLinkET200SP_Balluff_IO_Config
        VAR PUBLIC 
            {#ix-set:AttributeName = "<#Info time#>"}
            InfoTime : LTIME := LT#5S;
            {#ix-set:AttributeName = "<#Error time#>"}
            ErrorTime : LTIME := LT#10S;
            {#ix-set:AttributeName = "<#Task timeout#>"}
            TaskTimeout : LTIME := LT#50S;
            {#ix-set:AttributeName = "<#Hardware ID#>"}
            Hwid : UINT;
            {#ix-set:AttributeName = "<#Port 1#>"}
            Port_1 : eAxoIOLinkET200SP_Balluff_PortConfig;
            {#ix-set:AttributeName = "<#Port 2#>"}
            Port_2 : eAxoIOLinkET200SP_Balluff_PortConfig;
            {#ix-set:AttributeName = "<#Port 3#>"}
            Port_3 : eAxoIOLinkET200SP_Balluff_PortConfig;
            {#ix-set:AttributeName = "<#Port 4#>"}
            Port_4 : eAxoIOLinkET200SP_Balluff_PortConfig;
        END_VAR 
    END_CLASS    
END_NAMESPACE

