NAMESPACE AXOpen.Components.Ur.Robotics
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Wrap)]}
    CLASS AxoUrRobotics_Control_v_1_x_x 
        VAR PUBLIC
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Start program#>"}
            Start : BOOL;
            {#ix-set:AttributeName = "<#Stop program#>"}
            Stop : BOOL;
            {#ix-set:AttributeName = "<#Pause program#>"}
            Pause : BOOL;
            {#ix-set:AttributeName = "<#Set motor on#>"}
            MotorOn : BOOL;
            {#ix-set:AttributeName = "<#Run action#>"}
            RunAction : BOOL;

            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Master mode#>"}
            MasterMode : BYTE;
            
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
            {#ix-set:AttributeName = "<#Zones#>"}
            Zone : DINT;
            {#ix-set:AttributeName = "<#In position#>"}
            InPosition : DINT;
            {#ix-set:AttributeName = "<#Action number#>"}
            ActionNo : DINT; 
            {#ix-set:AttributeName = "<#Global robot speed#>"}
            GlobalSpeed : DINT; 
            {#ix-set:AttributeName = "<#Tool number#>"}
            ToolNo : DINT; 	
            {#ix-set:AttributeName = "<#Workobject number#>"}
            WorkobjectNo : DINT; 
            {#ix-set:AttributeName = "<#Point number#>"}
            PointNo : DINT; 		
            {#ix-set:AttributeName = "<#User specific speed 1#>"}
            UserSpecSpeed1 : REAL; 
            {#ix-set:AttributeName = "<#User specific speed 2#>"}
            UserSpecSpeed2 : REAL; 

            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Coordinates#>"}     
            Coordinates : AXOpen.Components.Abstractions.Robotics.AxoRoboticsCoordinates; 		

            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<UR Specific#>"}
            Outputs : AxoUrRoboticsOutputData_v_1_x_x;
        END_VAR
    END_CLASS
END_NAMESPACE
        