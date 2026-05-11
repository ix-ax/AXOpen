NAMESPACE AXOpen.Components.Kuka.Robotics.v_5_x_x
    // <AxoKukaRoboticsConfigDeclaration>
    {#ix-attr:[Container(Layout.Stack)]}
    {S7.extern=ReadWrite}
    CLASS PUBLIC AxoKrc5_Config
        VAR PUBLIC 
            {#ix-set:AttributeName = "<#Info time#>"}
            InfoTime : LTIME := LT#2S;
            {#ix-set:AttributeName = "<#Error time#>"}
            ErrorTime : LTIME := LT#5S;
            {#ix-set:AttributeName = "<#Task timeout#>"}
            TaskTimeout : LTIME := LT#50S;
            {#ix-set:AttributeName = "<#Hardware IDs#>"}
            HWIDs : AxoKrc5_HWIDs;            
        END_VAR 
    END_CLASS    
    // <AxoKukaRoboticsConfigDeclaration>
END_NAMESPACE

