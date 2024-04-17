NAMESPACE AXOpen.Components.Abb.Robotics
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Wrap)]}
    CLASS AxoAbbRobotics_State_v_1_x_x 
        VAR PUBLIC
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#AutoOn#>"}
            AutoOn : BOOL;
            {#ix-set:AttributeName = "<#CycleOn#>"}
            CycleOn : BOOL;
            {#ix-set:AttributeName = "<#Emergency stop#>"}
            EmgStop : BOOL;
            {#ix-set:AttributeName = "<#Error#>"}
            Error : BOOL;
            {#ix-set:AttributeName = "<#Event ID#>"}
            EventId : UDINT;
            {#ix-set:AttributeName = "<#Move active#>"}
            MoveActive : BOOL;
            {#ix-set:AttributeName = "<#Move inactive#>"}
            MoveInactive : BOOL;
            {#ix-set:AttributeName = "<#Motor off#>"}
            MotorOff : BOOL;

            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Motor on#>"}
            MotorOn : BOOL;	
            {#ix-set:AttributeName = "<#Motor off state#>"}
            MotorOffState : BOOL;
            {#ix-set:AttributeName = "<#Motor on state#>"}
            MotorOnState : BOOL;
            {#ix-set:AttributeName = "<#Program execution error#>"}
            ProgExecError : BOOL;
            {#ix-set:AttributeName = "<#Safety OK#>"}
            SafetyOk : BOOL;
            {#ix-set:AttributeName = "<#System input busy#>"}
            SystemInputBusy : BOOL;
            {#ix-set:AttributeName = "<#Program pointer moved#>"}
            PpMoved : BOOL;
            {#ix-set:AttributeName = "<#Motion supervision#>"}
            MotionSupervision : BOOL;
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
            {#ix-set:AttributeName = "<#Auto stop 1#>"}
            AutoStop_1 : BOOL;
            {#ix-set:AttributeName = "<#Auto stop 2#>"}
            AutoStop_2 : BOOL;
            {#ix-set:AttributeName = "<#Emergency stop 1#>"}
            EmergencyStop_1 : BOOL;
            {#ix-set:AttributeName = "<#Emergency stop 2#>"}
            EmergencyStop_2 : BOOL;
            {#ix-set:AttributeName = "<#General stop 1#>"}
            GeneralStop_1 : BOOL;
            {#ix-set:AttributeName = "<#General stop 2#>"}
            GeneralStop_2 : BOOL;
            {#ix-set:AttributeName = "<#Enable 1#>"}
            Enable_1 : BOOL;
            {#ix-set:AttributeName = "<#Enable 2#>"}
            Enable_2 : BOOL;
        
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
        