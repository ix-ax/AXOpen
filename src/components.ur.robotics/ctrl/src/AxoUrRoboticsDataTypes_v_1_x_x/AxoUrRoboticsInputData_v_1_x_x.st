NAMESPACE AXOpen.Components.Ur.Robotics
    {#ix-attr:[Container(Layout.Stack)]}
    {S7.extern=ReadWrite}
    CLASS PUBLIC AxoUrRoboticsInputData_v_1_x_x
        VAR PUBLIC 
            {#ix-set:AttributeName = "<#Robot#>"}
            Robot : AxoUrRoboticsT2ORobot_v_1_x_x;
            {#ix-set:AttributeName = "<#State#>"}
            Safety : AxoUrRoboticsT2OSafety_v_1_x_x;
            {#ix-set:AttributeName = "<#IO state#>"}
            IO : AxoUrRoboticsT2OIo_v_1_x_x;
            {#ix-set:AttributeName = "<#Tool state#>"}
            Tool : AxoUrRoboticsT2OTool_v_1_x_x;
            {#ix-set:AttributeName = "<#Joints#>"}
            Joints : AxoUrRoboticsT2OJoints_v_1_x_x;
            {#ix-set:AttributeName = "<#TCP#>"}
            TCP : AxoUrRoboticsT2OTcp_v_1_x_x;
            {#ix-set:AttributeName = "<#Bits#>"}
            Bits : AxoUrRoboticsT2OBitRegs_v_1_x_x;
            {#ix-set:AttributeName = "<#Ints#>"}
            Ints : AxoUrRoboticsT2OIntRegs_v_1_x_x;
            {#ix-set:AttributeName = "<#Floats#>"}
            Floats : AxoUrRoboticsT2OFloatRegs_v_1_x_x;	
        END_VAR 
    END_CLASS    
END_NAMESPACE