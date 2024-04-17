NAMESPACE AXOpen.Components.Kuka.Robotics
    {#ix-attr:[Container(Layout.Stack)]}
    {S7.extern=ReadWrite}
    CLASS PUBLIC AxoKukaRobotics_Config_v_5_x_x
        VAR PUBLIC 
            {#ix-set:AttributeName = "<#Info time#>"}
            InfoTime : LTIME := LT#2S;
            {#ix-set:AttributeName = "<#Error time#>"}
            ErrorTime : LTIME := LT#5S;
        END_VAR 
    END_CLASS    
END_NAMESPACE