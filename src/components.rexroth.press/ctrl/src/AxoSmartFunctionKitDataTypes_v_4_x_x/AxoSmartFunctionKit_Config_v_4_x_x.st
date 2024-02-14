NAMESPACE AXOpen.Components.Rexroth.Press
    {#ix-attr:[Container(Layout.Stack)]}
    {S7.extern=ReadWrite}
    CLASS PUBLIC AxoSmartFunctionKit_Config_v_4_x_x
        VAR PUBLIC 
            {#ix-set:AttributeName = "<#Info time#>"}
            InfoTime : LTIME := LT#10S;
            {#ix-set:AttributeName = "<#Error time#>"}
            ErrorTime : LTIME := LT#30S;
            {#ix-set:AttributeName = "<#Location of the curve export#>"}
            CurveExportLocation : STRING ;
            {#ix-set:AttributeName = "<#Ip address#>"}
            IpAddress : STRING ;
        END_VAR 
    END_CLASS    
END_NAMESPACE