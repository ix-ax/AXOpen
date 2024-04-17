NAMESPACE AXOpen.Components.Ur.Robotics
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Wrap)]}
    CLASS AxoUrRobotics_State_v_1_x_x 
        VAR PUBLIC
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Robot Mode#>"}
            RobotMode : eAxoUrRoboticsRobotMode;
        
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#In area 1#>"}
            InArea_1 : BOOL;
            {#ix-set:AttributeName = "<#In area 2#>"}
            InArea_2 : BOOL;
            {#ix-set:AttributeName = "<#In area 3#>"}
            InArea_3 : BOOL;
            {#ix-set:AttributeName = "<#In area 4#>"}
            InArea_4 : BOOL;
            {#ix-set:AttributeName = "<#In position 1#>"}
            InPosition_1 : BOOL;
            {#ix-set:AttributeName = "<#In position 2#>"}
            InPosition_2 : BOOL;
            {#ix-set:AttributeName = "<#In position 3#>"}
            InPosition_3 : BOOL;
            {#ix-set:AttributeName = "<#In position 4#>"}
            InPosition_4 : BOOL;
            
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Zones#>"}
            Zone : DINT;
            {#ix-set:AttributeName = "<#In position#>"}
            InPosition : DINT;

            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Tool 1 retract#>"}
            Tool_1_Retract : BOOL;
            {#ix-set:AttributeName = "<#Tool 1 extend#>"}
            Tool_1_Extend : BOOL;
            {#ix-set:AttributeName = "<#Tool 2 retract#>"}
            Tool_2_Retract : BOOL;
            {#ix-set:AttributeName = "<#Tool 2 extend#>"}
            Tool_2_Extend : BOOL;
            {#ix-set:AttributeName = "<#Tool 3 retract#>"}
            Tool_3_Retract : BOOL;
            {#ix-set:AttributeName = "<#Tool 3 extend#>"}
            Tool_3_Extend : BOOL;
            {#ix-set:AttributeName = "<#Tool 4 retract#>"}
            Tool_4_Retract : BOOL;
            {#ix-set:AttributeName = "<#Tool 4 extend#>"}
            Tool_4_Extend : BOOL;
        
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Action number#>"}
            ActionNo : DINT;
            {#ix-set:AttributeName = "<#Global speed#>"}
            GlobalSpeed : DINT;
            {#ix-set:AttributeName = "<#Tool number#>"}
            ToolNo : DINT; 
            {#ix-set:AttributeName = "<#Workobject number#>"}
            WorkobjectNo : DINT;
            {#ix-set:AttributeName = "<#PointNumber#>"}
            PointNo : DINT;
            {#ix-set:AttributeName = "<#User specific speed 1#>"}
            UserSpecSpeed1 : REAL;
            {#ix-set:AttributeName = "<#User specific speed 2#>"}
            UserSpecSpeed2 : REAL;
            
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {attribute  addProperty Name "<#Coordinates#>"}     
            Coordinates : AXOpen.Components.Abstractions.Robotics.AxoRoboticsCoordinates; 	
            
            {attribute  addProperty Name "<#UR Specific#>"}     
            Inputs:AxoUrRoboticsInputData_v_1_x_x ;
        END_VAR
    END_CLASS
END_NAMESPACE
        