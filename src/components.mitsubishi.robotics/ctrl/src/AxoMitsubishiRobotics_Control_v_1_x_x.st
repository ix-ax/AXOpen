NAMESPACE AXOpen.Components.Mitsubishi.Robotics
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Wrap)]}
    CLASS AxoMitsubishiRobotics_Control_v_1_x_x 
        VAR PUBLIC
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Operation enable (rights)#>"}
            OperationEnable:BOOL;
            {#ix-set:AttributeName = "<#Automatic operation enabled#>"}
            AutoEnable:BOOL;
            {#ix-set:AttributeName = "<#Start#>"}
            Start:BOOL;	
            {#ix-set:AttributeName = "<#Stop#>"}
            Stop:BOOL;
            {#ix-set:AttributeName = "<#Program reset#>"}
            ProgramReset:BOOL;
            {#ix-set:AttributeName = "<#Error Reset#>"}
            ErrorReset:BOOL;
            {#ix-set:AttributeName = "<#Cycle Stop#>"}
            CycleStop:BOOL;	
            {#ix-set:AttributeName = "<#Servo Off#>"}
            ServoOff:BOOL;

            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Servo On#>"}
            ServoOn:BOOL;	
            {#ix-set:AttributeName = "<#General Purpose reset#>"}
            GeneralPurposeReset:BOOL;	
            {#ix-set:AttributeName = "<#Overide specification#>"}
            OverideSpecifications:BOOL;	

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
            Zone : BYTE;
            {#ix-set:AttributeName = "<#In position#>"}
            InPosition : BYTE;
            {#ix-set:AttributeName = "<#Action number#>"}
            ActionNo : BYTE; 
            {#ix-set:AttributeName = "<#Global robot speed#>"}
            GlobalSpeed : BYTE; 
            {#ix-set:AttributeName = "<#Tool number#>"}
            ToolNo : BYTE; 	
            {#ix-set:AttributeName = "<#Workobject number#>"}
            WorkobjectNo : BYTE; 
            {#ix-set:AttributeName = "<#Point number#>"}
            PointNo : BYTE; 		
            {#ix-set:AttributeName = "<#User specific speed 1#>"}
            UserSpecSpeed1 : REAL; 
            {#ix-set:AttributeName = "<#User specific speed 2#>"}
            UserSpecSpeed2 : REAL; 

            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {attribute  addProperty Name "<#Coordinates#>"}     
            Coordinates : AXOpen.Components.Abstractions.Robotics.AxoRoboticsCoordinates; 		
        END_VAR
    END_CLASS
END_NAMESPACE
        