NAMESPACE AXOpen.Components.Ur.Robotics.v_3_x_x
    {#ix-attr:[Container(Layout.Wrap)]}
    {S7.extern=ReadWrite}
    CLASS PUBLIC AxoUrRoboticsInputData
        VAR PUBLIC 
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Robot#>"}
            Robot : AxoUrRoboticsT2ORobot;
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#State#>"}
            Safety : AxoUrRoboticsT2OSafety;
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#IO state#>"}
            IO : AxoUrRoboticsT2OIo;
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Tool state#>"}
            Tool : AxoUrRoboticsT2OTool;
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Joints#>"}
            Joints : AxoUrRoboticsT2OJoints;
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#TCP#>"}
            TCP : AxoUrRoboticsT2OTcp;
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Bits#>"}
            Bits : AxoUrRoboticsT2OBitRegs;
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Ints#>"}
            Ints : AxoUrRoboticsT2OIntRegs;
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Floats#>"}
            Floats : AxoUrRoboticsT2OFloatRegs;	
        END_VAR 
    END_CLASS    
END_NAMESPACE