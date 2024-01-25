NAMESPACE AXOpen.Components.Ur.Robotics
    {#ix-attr:[Container(Layout.Stack)]}
    {S7.extern=ReadWrite}
    CLASS PUBLIC AxoUrRoboticsT2OTcp_v_1_x_x
        VAR PUBLIC 
            {#ix-set:AttributeName = "<#Actual TCP Position#>"}
            Postition : AXOpen.Components.Abstractions.Robotics.AxoRoboticsCoordinates;
            {#ix-set:AttributeName = "<#Actual TCP Velocity#>"}
            Velocity : AXOpen.Components.Abstractions.Robotics.AxoRoboticsCoordinates;
            {#ix-set:AttributeName = "<#Actual TCP Force#>"}
            Force : AXOpen.Components.Abstractions.Robotics.AxoRoboticsBasicCoordinates;
            {#ix-set:AttributeName = "<#Actual TCP Torque#>"}
            Torque : AXOpen.Components.Abstractions.Robotics.AxoRoboticsBasicCoordinates;
            {#ix-set:AttributeName = "<#TCP force scalar [N]#>"}
            TCP_ForceScalar : REAL;
        END_VAR 
    END_CLASS    
END_NAMESPACE