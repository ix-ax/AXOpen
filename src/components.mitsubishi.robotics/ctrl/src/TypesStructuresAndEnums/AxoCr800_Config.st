NAMESPACE AXOpen.Components.Mitsubishi.Robotics.v_1_x_x
    {#ix-attr:[Container(Layout.Stack)]}
    {S7.extern=ReadWrite}
    CLASS PUBLIC AxoCr800_Config
        VAR PUBLIC 
            {#ix-set:AttributeName = "<#Info time#>"}
            InfoTime : LTIME := LT#2S;
            {#ix-set:AttributeName = "<#Error time#>"}
            ErrorTime : LTIME := LT#0S;
            {#ix-set:AttributeName = "<#Task timeout#>"}
            TaskTimeout : LTIME := LT#0S;
            {#ix-set:AttributeName = "<#Hardware IDs#>"}
            HWIDs   :   AxoCr800_HWIDs;
        END_VAR 
    END_CLASS    
END_NAMESPACE
 