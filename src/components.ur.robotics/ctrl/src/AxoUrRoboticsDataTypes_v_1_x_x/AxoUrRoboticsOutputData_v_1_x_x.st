NAMESPACE AXOpen.Components.Ur.Robotics
    {#ix-attr:[Container(Layout.Wrap)]}
    {S7.extern=ReadWrite}
    CLASS PUBLIC AxoUrRoboticsOutputData_v_1_x_x
        VAR PUBLIC 
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Speed#>"}
            Speed   :   AxoUrRobotics_O2TRobot_v_1_x_x;
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#IO#>"}
            IO      :   AxoUrRobotics_O2TIo_v_1_x_x;
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Reg 1#>"}
            Reg1    :   AxoUrRobotics_O2TReg_v_1_x_x;
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Reg 2#>"}
            Reg2    :   AxoUrRobotics_O2TReg_v_1_x_x;
        END_VAR 
    END_CLASS    
END_NAMESPACE