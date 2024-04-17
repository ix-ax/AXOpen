NAMESPACE AXOpen.Components.Kuka.Robotics
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Wrap)]}
    CLASS AxoKukaRobotics_State_v_5_x_x 
        VAR PUBLIC
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#ControlReady [RC_RDY1]#>"}
            RcReady : BOOL;			
            {#ix-set:AttributeName = "<#AlarmStopActive [ALARM_STOP]#>"}
            AlarmStopActive : BOOL;			
            {#ix-set:AttributeName = "<#UserSafetySwitchClosed [USER_SAF]#>"}
            UserSafetySwitchClosed : BOOL;	
            {#ix-set:AttributeName = "<#DrivesReady [PERI_RDY]#>"}
            DrivesReady : BOOL;				
            {#ix-set:AttributeName = "<#RobotCalibrated [ROB_CAL]#>"}
            RobotCalibrated : BOOL;			
            {#ix-set:AttributeName = "<#InterfaceActivated [I_O_ACTCONF]#>"}
            InterfaceActivated : BOOL;		
            {#ix-set:AttributeName = "<#ErrorCollection [STOPMESS]#>"}
            StopMess : BOOL;			
            {#ix-set:AttributeName = "<#RobotStopped [ROB_STOPPED]#>"}
            RobotStopped : BOOL;			

            
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#InHome [IN_HOME]#>"}
            InHome : BOOL;					
            {#ix-set:AttributeName = "<#Manual [T1]#>"}
            Manual : BOOL;					
            {#ix-set:AttributeName = "<#Automatic [AUT]#>"}
            Automatic : BOOL;				
            {#ix-set:AttributeName = "<#ExternalAutomatic [EXT]#>"}
            ExternalAutomatic : BOOL;		
            {#ix-set:AttributeName = "<#ProcesActive [PRO_ACT]#>"}
            ProActive : BOOL;	
            {#ix-set:AttributeName = "<#ProgramMoveActive [PROGRAM MOVEMENT ACTIVE]#>"}
            ProgramMoveActive : BOOL;				
            {#ix-set:AttributeName = "<#Event ID#>"}
            EventId : UDINT;
            {#ix-set:AttributeName = "<#PpMoved#>"}
            PpMoved : BOOL;					
            {#ix-set:AttributeName = "<#StartAtMain#>"}
            StartAtMain : BOOL;	
            {#ix-set:AttributeName = "<#Error#>"}
            Error : BOOL;
        
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
        