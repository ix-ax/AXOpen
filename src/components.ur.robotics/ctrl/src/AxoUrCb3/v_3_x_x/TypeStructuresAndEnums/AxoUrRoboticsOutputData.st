NAMESPACE AXOpen.Components.Ur.Robotics.v_3_x_x
    {#ix-attr:[Container(Layout.Wrap)]}
    {S7.extern=ReadWrite}
    CLASS PUBLIC AxoUrRoboticsOutputData
        VAR PUBLIC 
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Speed#>"}
            Speed   :   AxoUrRobotics_O2TRobot;
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#IO#>"}
            IO      :   AxoUrRobotics_O2TIo;
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Reg 1#>"}
            Reg1    :   AxoUrRobotics_O2TReg;
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Reg 2#>"}
            Reg2    :   AxoUrRobotics_O2TReg;
        END_VAR 
    END_CLASS    
END_NAMESPACE