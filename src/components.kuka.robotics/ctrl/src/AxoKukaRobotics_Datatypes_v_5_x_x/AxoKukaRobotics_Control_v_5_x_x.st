NAMESPACE AXOpen.Components.Kuka.Robotics
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Wrap)]}
    CLASS AxoKukaRobotics_Control_v_5_x_x 
        VAR PUBLIC
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Program Start [EXT_START]#>"}
            ExternalStart : BOOL;	
            {#ix-set:AttributeName = "<#Move Enable [MOVE_ENABLE]#>"}
            MoveEnable : BOOL;			
            {#ix-set:AttributeName = "<#Error Confirmation [CONF_MESS]#>"} 
            ErrorConfirmation : BOOL;	
            {#ix-set:AttributeName = "<#Drives Off [DRIVES_OFF]#>"}
            DrivesOff : BOOL;			
            {#ix-set:AttributeName = "<#Drives On [DRIVES_ON]#>"}
            DrivesOn : BOOL;			
            {#ix-set:AttributeName = "<#Activate Interface [I_O_ACT]#>"}
            ActivateInterface : BOOL;	
            {#ix-set:AttributeName = "<#Start At Main [START_AT_MAIN]#>"}
            StartAtMain : BOOL;			
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
            {#ix-set:AttributeName = "<#Tool 1 retract#>"}
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
        