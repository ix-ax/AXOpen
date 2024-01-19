NAMESPACE AXOpen.Components.Mitsubishi.Robotics
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Wrap)]}
    CLASS AxoMitsubishiRobotics_State_v_1_x_x 
        VAR PUBLIC
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Operation rights#>"}
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
            {#ix-set:AttributeName = "<#High level error#>"}
            HighLevelError:BOOL;	
            {#ix-set:AttributeName = "<#Low level error#>"}
            LowLevelError:BOOL;	
            {#ix-set:AttributeName = "<#Warning level error (caution)#>"}
            CautionLevelError:BOOL;	
            {#ix-set:AttributeName = "<#Emergency stop#>"}
            EmergencyError:BOOL;	
            {#ix-set:AttributeName = "<#Rc Ready#>"}
            RcReady:BOOL;	
            {#ix-set:AttributeName = "<#Battery Low#>"}
            BatteryLow : BOOL;
            
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
            Zone : BYTE;
            {#ix-set:AttributeName = "<#In position#>"}
            InPosition : BYTE;

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
            ActionNo : BYTE;
            {#ix-set:AttributeName = "<#Global speed#>"}
            GlobalSpeed : BYTE;
            {#ix-set:AttributeName = "<#Tool number#>"}
            ToolNo : BYTE; 
            {#ix-set:AttributeName = "<#Workobject number#>"}
            WorkobjectNo : BYTE;
            {#ix-set:AttributeName = "<#PointNumber#>"}
            PointNo : BYTE;
            {#ix-set:AttributeName = "<#User specific speed 1#>"}
            UserSpecSpeed1 : DINT;
            {#ix-set:AttributeName = "<#User specific speed 2#>"}
            UserSpecSpeed2 : DINT;
            
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {attribute  addProperty Name "<#Coordinates#>"}     
            Coordinates : AXOpen.Components.Abstractions.Robotics.AxoRoboticsCoordinates; 		
        END_VAR
    END_CLASS
END_NAMESPACE
        