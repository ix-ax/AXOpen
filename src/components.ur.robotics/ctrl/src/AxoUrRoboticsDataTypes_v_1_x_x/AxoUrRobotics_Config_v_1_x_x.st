NAMESPACE AXOpen.Components.Ur.Robotics
    {#ix-attr:[Container(Layout.Stack)]}
    {S7.extern=ReadWrite}
    CLASS PUBLIC AxoUrRobotics_Config_v_1_x_x
        VAR PUBLIC 
            {#ix-set:AttributeName = "<#Info time#>"}
            InfoTime : LTIME := LT#2S;
            {#ix-set:AttributeName = "<#Error time#>"}
            ErrorTime : LTIME := LT#5S;
            {#ix-set:AttributeName = "<#Remote power on enabled#>"}
            RemotePowerOnEnabled:BOOL :=FALSE;
            {#ix-set:AttributeName = "<#Remote power on pulse time#>"}
            RemotePowerOnPulse : TIME := T#500MS;
            {#ix-set:AttributeName = "<#IP address#>"}
            IpAddress : STRING;
        END_VAR 
    END_CLASS    
END_NAMESPACE