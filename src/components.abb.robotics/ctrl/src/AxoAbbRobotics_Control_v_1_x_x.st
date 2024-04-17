NAMESPACE AXOpen.Components.Abb.Robotics
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Wrap)]}
    CLASS AxoAbbRobotics_Control_v_1_x_x 
        VAR PUBLIC
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Interuption actually running instruction#>"}
            Interupt : BOOL;
            {#ix-set:AttributeName = "<#Load program#>"}
            LoadProg : BOOL;	
            {#ix-set:AttributeName = "<#Load and run program#>"}
            LoadAndStartProg : BOOL;
            {#ix-set:AttributeName = "<#Switch off the motors#>"}
            MotorOff : BOOL;	
            {#ix-set:AttributeName = "<#Switch on the motors#>"}
            MotorOn : BOOL;	
            {#ix-set:AttributeName = "<#Switch on the motors and start program#>"}
            MotorOnAndStart : BOOL; 
            {#ix-set:AttributeName = "<#Emergency stop acknowledge#>"}
            ResetEmgStop : BOOL;
            {#ix-set:AttributeName = "<#Error acknowledge#>"}
            ResetError : BOOL; 

            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Program start#>"}
            StartProgram : BOOL;	
            {#ix-set:AttributeName = "<#Program start at main#>"}
            StartAtMain : BOOL; 	
            {#ix-set:AttributeName = "<#Program stop#>"}
            StopProgram : BOOL;	
            {#ix-set:AttributeName = "<#Stop movement-quick#>"}
            QuickStop : BOOL; 
            {#ix-set:AttributeName = "<#Stop movement-soft#>"}
            SoftStop : BOOL;	
            {#ix-set:AttributeName = "<#Stop program at the end of the cycle#>"}
            StopCycle : BOOL; 	
            {#ix-set:AttributeName = "<#Stop program at the end of the instruction#>"}
            StopInstruction : BOOL;
            {#ix-set:AttributeName = "<#Speed limitation#>"}
            LimitSpeed : BOOL;

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
            {#ix-set:AttributeName = "<#Coordinates#>"}     
            Coordinates : AXOpen.Components.Abstractions.Robotics.AxoRoboticsCoordinates; 		
        END_VAR
    END_CLASS
END_NAMESPACE
        