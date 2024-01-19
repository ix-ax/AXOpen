USING AXOpen.Core;
USING AXOpen.Messaging;
USING AXOpen.Messaging.Static;
USING AXOpen.Components.Robotics;
USING AXOpen.Components.Abstractions.Robotics;

NAMESPACE AXOpen.Components.Mitsubishi.Robotics
    {S7.extern=ReadWrite}
    CLASS AxoCr800_v_1_x_x EXTENDS AXOpen.Core.AxoComponent IMPLEMENTS AXOpen.Components.Abstractions.Robotics.IAxoRobotics
        VAR PRIVATE
            _infoTimer      :   AXOpen.Timers.OnDelayTimer;
            _infoTime       :   LTIME := LT#2S;
            _errorTimer     :   AXOpen.Timers.OnDelayTimer;
            _errorTime      :   LTIME := LT#5S;
            _blink          :   AXOpen.Timers.AxoBlinker;
            _context        :   IAxoContext;
        END_VAR

        VAR PUBLIC //HEADER
                    
        END_VAR

        VAR PUBLIC //Tasks
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Tasks")]}            
            {#ix-set:AttributeName = "<#Restore#>"}
            RestoreTask : AxoTask;            

            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Tasks")]}            
            {#ix-set:AttributeName = "<#Start at main#>"}
            StartAtMainTask : AxoTask;            

            {#ix-attr:[ComponentDetails("Tasks")]}            
            {#ix-set:AttributeName = "<#Start motors and program#>"}
            StartMotorsAndProgramTask : AxoTask;

            {#ix-attr:[ComponentDetails("Tasks")]}            
            {#ix-set:AttributeName = "<#Stop movements#>"}
            StopMovementsTask : AxoTask;

            {#ix-attr:[ComponentDetails("Tasks")]}            
            {#ix-set:AttributeName = "<#Stop movements and program#>"}
            StopMovementsAndProgramTask : AxoTask;

            {#ix-attr:[ComponentDetails("Tasks")]}            
            {#ix-set:AttributeName = "<#Start movements with extended parameters#>"}
            StartMovementsTask : AxoTask;

            {#ix-attr:[ComponentDetails("Tasks")]}            
            {#ix-set:AttributeName = "<#Start movements with extended parameters#>"}
            MovementParameters : AXOpen.Components.Abstractions.Robotics.AxoRoboticsMovementsParams;
        END_VAR
        
        VAR PUBLIC //CONFIG
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("Config")]}
            {#ix-attr:[ReadOnly()]}
            Config  :   AxoCr800Config_v_1_x_x;
        END_VAR

        VAR PUBLIC //STATUS
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("Status")]}
            {#ix-attr:[ReadOnly()]}
            RobotStatus         :   AxoMitsubishiRobotics_Component_Status_v_1_x_x;
            Messenger           :   AXOpen.Messaging.Static.AxoMessenger;
            TaskMessenger       :   AXOpen.Messaging.Static.AxoMessenger;
            _progress           :   INT := 0;
        END_VAR

        VAR PUBLIC //Hardware signals
            {#ix-attr:[ComponentDetails("Hardware signals")]}
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Inputs#>"}
            {#ix-attr:[ReadOnly()]}
            Inputs              :   AxoMitsubishiRobotics_State_v_1_x_x;
            {#ix-attr:[ComponentDetails("Hardware signals")]}
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Outputs#>"}
            {#ix-attr:[ReadOnly()]}
            Outputs              :   AxoMitsubishiRobotics_Control_v_1_x_x;
        END_VAR    

        VAR PUBLIC //HardwareDiagnostics
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("Hardware diagnostics")]}
            {#ix-set:AttributeName = "<#Update diagnostics#>"}
            HardwareDiagnosticsTask :   AXOpen.Io.AxoHardwareDiagnostics;
        END_VAR

        ///<summary>
        /// Runs tasks and logic of this component.
        /// >[!IMPORTANT] This method must or one of its overloads be called cyclically.
        ///</summary>
        METHOD PUBLIC Run
            VAR_INPUT
                parent : IAxoObject;
                hwID            :   UINT;
                refInputs       :   REF_TO  ARRAY[*] OF BYTE;   //  Reference to the input data of the robot
                refOutputs      :   REF_TO  ARRAY[*] OF BYTE;   //  Reference to the output data of the robot
            END_VAR

            Messenger.ActivateOnCondition(ULINT#700,parent = NULL, eAxoMessageCategory#ProgrammingError);

            IF parent = NULL THEN
                RobotStatus.Error.Id := UINT#700;
                RETURN;
            END_IF;

            THIS.Initialize(parent);
            THIS.Execute(hwID,refInputs,refOutputs);
        END_METHOD

        ///<summary>
        /// Runs tasks and logic of this component.
        /// >[!IMPORTANT] This method must or one of its overloads be called cyclically.
        ///</summary>
        METHOD PUBLIC Run 
            VAR_INPUT
                parent          :   IAxoContext;
                hwID            :   UINT;
                refInputs       :   REF_TO  ARRAY[*] OF BYTE;   //  Reference to the input data of the robot
                refOutputs      :   REF_TO  ARRAY[*] OF BYTE;   //  Reference to the output data of the robot
            END_VAR

            Messenger.ActivateOnCondition(ULINT#700,parent = NULL, eAxoMessageCategory#ProgrammingError);

            IF parent = NULL THEN
                RobotStatus.Error.Id := UINT#700;
                RETURN;
            END_IF;

            THIS.Initialize(parent);
            THIS.Execute(hwID,refInputs,refOutputs);

        END_METHOD

        METHOD PRIVATE Execute 
            VAR_INPUT
                hwID            :   UINT;
                refInputs       :   REF_TO  ARRAY[*] OF BYTE;   //  Reference to the input data of the robot
                refOutputs      :   REF_TO  ARRAY[*] OF BYTE;   //  Reference to the output data of the robot
            END_VAR
            VAR 
                _dword: DWORD;
            END_VAR

            Messenger.ActivateOnCondition(ULINT#701,refInputs       = NULL, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#702,refOutputs      = NULL, eAxoMessageCategory#ProgrammingError);
            IF refInputs        = NULL THEN
                RobotStatus.Error.Id := UINT#701;
                RETURN;
            ELSIF refOutputs        = NULL THEN
                RobotStatus.Error.Id := UINT#702;
                RETURN;
            END_IF;

            THIS.Open();
            //***********UPDATE**INPUTS******************
            //SYSTEM INPUTS
            Inputs.OperationEnable          := refInputs^       [0].%X0;
            Inputs.AutoEnable               := refInputs^       [0].%X1;
            Inputs.Start                    := refInputs^       [0].%X2;
            Inputs.Stop                     := refInputs^       [0].%X3;
            Inputs.ProgramReset             := refInputs^       [0].%X4;
            Inputs.ErrorReset               := refInputs^       [0].%X5;
            Inputs.CycleStop                := refInputs^       [0].%X6;
            Inputs.ServoOff                 := refInputs^       [0].%X7;

            Inputs.ServoOn                  := refInputs^       [1].%X0;
            Inputs.HighLevelError           := refInputs^       [1].%X1;
            Inputs.LowLevelError            := refInputs^       [1].%X2;
            Inputs.CautionLevelError        := refInputs^       [1].%X3;
            Inputs.EmergencyError           := refInputs^       [1].%X4;
            Inputs.RcReady                  := refInputs^       [1].%X5;
            Inputs.BatteryLow               := refInputs^       [1].%X6;

            //Area/positions flags this  should be obsolete because Zones and InPosition is used as byte below
            Inputs.InArea_1                 := refInputs^       [2].%X0;
            Inputs.InArea_2                 := refInputs^       [2].%X1;
            Inputs.InArea_3                 := refInputs^       [2].%X2;
            Inputs.InArea_4                 := refInputs^       [2].%X3;
            Inputs.InPosition_1             := refInputs^       [2].%X4;
            Inputs.InPosition_2             := refInputs^       [2].%X5;
            Inputs.InPosition_3             := refInputs^       [2].%X6;
            Inputs.InPosition_4             := refInputs^       [2].%X7;

            //Tool signals
            Inputs.Tool_1_Retract           := refInputs^       [3].%X0;
            Inputs.Tool_1_Extend            := refInputs^       [3].%X1;
            Inputs.Tool_2_Retract           := refInputs^       [3].%X2;
            Inputs.Tool_2_Extend            := refInputs^       [3].%X3;
            Inputs.Tool_3_Retract           := refInputs^       [3].%X4;
            Inputs.Tool_3_Extend            := refInputs^       [3].%X5;
            Inputs.Tool_4_Retract           := refInputs^       [3].%X6;
            Inputs.Tool_4_Extend            := refInputs^       [3].%X7;

            // //Safety signals
            // index:=4;
            // Inputs.AutoStop_1               := refInputs^        [4].%X0;
            // Inputs.AutoStop_2               := refInputs^        [4].%X1;
            // Inputs.EmergencyStop_1          := refInputs^        [4].%X2;
            // Inputs.EmergencyStop_2          := refInputs^        [4].%X3;
            // Inputs.GeneralStop_1            := refInputs^        [4].%X4;
            // Inputs.GeneralStop_2            := refInputs^        [4].%X5;
            // Inputs.Enable_1                 := refInputs^        [4].%X6;
            // Inputs.Enable_2                 := refInputs^        [4].%X7;

            Inputs.Zone                     := refInputs^       [5];
            Inputs.InPosition               := refInputs^       [6];

            //Movement parameters
            Inputs.ActionNo                 := refInputs^       [7];
            Inputs.GlobalSpeed              := refInputs^       [8];
            Inputs.ToolNo                   := refInputs^       [9];
            Inputs.WorkobjectNo             := refInputs^       [10];
            Inputs.PointNo                  := refInputs^       [11];

            _dword.%B3                      := refInputs^       [12];
            _dword.%B2                      := refInputs^       [13];
            _dword.%B1                      := refInputs^       [14];
            _dword.%B0                      := refInputs^       [15];
            Inputs.UserSpecSpeed1           := TO_DINT(_dword);

            _dword.%B3                      := refInputs^       [16];
            _dword.%B2                      := refInputs^       [17];
            _dword.%B1                      := refInputs^       [18];
            _dword.%B0                      := refInputs^       [19];
            Inputs.UserSpecSpeed2           := TO_DINT(_dword);

            _dword.%B3                      := refInputs^       [20];
            _dword.%B2                      := refInputs^       [21];
            _dword.%B1                      := refInputs^       [22];
            _dword.%B0                      := refInputs^       [23];
            Inputs.Coordinates.X:= TO_REAL(_dword)/REAL#10000.0-REAL#10000.0;

            _dword.%B3                      := refInputs^       [24];
            _dword.%B2                      := refInputs^       [25];
            _dword.%B1                      := refInputs^       [26];
            _dword.%B0                      := refInputs^       [27];
            Inputs.Coordinates.Y:= TO_REAL(_dword)/REAL#10000.0-REAL#10000.0;

            _dword.%B3                      := refInputs^       [28];
            _dword.%B2                      := refInputs^       [29];
            _dword.%B1                      := refInputs^       [30];
            _dword.%B0                      := refInputs^       [31];
            Inputs.Coordinates.Z:= TO_REAL(_dword)/REAL#10000.0-REAL#10000.0;

            _dword.%B3                      := refInputs^       [32];
            _dword.%B2                      := refInputs^       [33];
            _dword.%B1                      := refInputs^       [34];
            _dword.%B0                      := refInputs^       [35];
            Inputs.Coordinates.Rx:= TO_REAL(_dword)/REAL#10000.0-REAL#360.0;

            _dword.%B3                      := refInputs^       [36];
            _dword.%B2                      := refInputs^       [37];
            _dword.%B1                      := refInputs^       [39];
            _dword.%B0                      := refInputs^       [39];
            Inputs.Coordinates.Ry:= TO_REAL(_dword)/REAL#10000.0-REAL#360.0;

            _dword.%B3                      := refInputs^       [40];
            _dword.%B2                      := refInputs^       [41];
            _dword.%B1                      := refInputs^       [42];
            _dword.%B0                      := refInputs^       [43];
            Inputs.Coordinates.Rz:= TO_REAL(_dword)/REAL#10000.0-REAL#360.0;
            //*******************************************
            _context := THIS.GetContext();

            _infoTime := Config.InfoTime;
            _errorTime := Config.ErrorTime;

            //*************INITIALIZATION*************
            RestoreTask.Initialize(THIS);
            StartAtMainTask.Initialize(THIS);
            StartMotorsAndProgramTask.Initialize(THIS);
            StopMovementsTask.Initialize(THIS);
            StopMovementsAndProgramTask.Initialize(THIS);
            StartMovementsTask.Initialize(THIS);
            HardwareDiagnosticsTask.Initialize(THIS);
            //****************************************
            //********************Diagnostics*********        
            HardwareDiagnosticsTask.Run(hwID);
            //****************************************

            //*************RESTORE********************
            RestoreTask.IsDisabled := FALSE;
            IF RestoreTask.Execute() THEN
                THIS.Restore();
            END_IF;
            //****************************************

            //*************StartAtMainTask***************
            StartAtMainTask.IsDisabled := FALSE;
            IF StartAtMainTask.Execute() THEN
                _blink.Blink(Context := _context, inOnTime:=T#500MS,inOffTime:=T#500MS);
                IF _progress = 0 THEN
                    THIS.CallTimers(FALSE);
                    _progress := 300;
                END_IF;
                
                IF _progress = 300 THEN     //Switching to auto mode
                    Outputs.AutoEnable:=TRUE;

                    IF _infoTimer.output THEN
                        IF NOT Inputs.AutoEnable THEN
                            RobotStatus.Error.Id := UINT#600;//<#Waiting for Auto signal! #>
                        END_IF;
                    END_IF;

                    IF Inputs.AutoEnable THEN
                        THIS.CallTimers(FALSE);
                        _progress := 301;
                    END_IF;
                END_IF;
                
                IF _progress = 301 THEN //Enabling operations
                    Outputs.OperationEnable:=TRUE;
                    
                    IF _infoTimer.output THEN
                        IF NOT Inputs.OperationEnable THEN
                            RobotStatus.Error.Id := UINT#601;//<#Waiting for Operation enable signal!
                        END_IF;
                    END_IF;

                    IF Inputs.OperationEnable THEN
                        THIS.CallTimers(FALSE);
                        _progress := 302;
                    END_IF;
                END_IF;
                
                IF _progress = 302 THEN //Reseting error
                    Outputs.ErrorReset := Inputs.ErrorReset AND _blink.output;

                    IF _infoTimer.output THEN
                        IF Inputs.ErrorReset THEN
                            RobotStatus.Error.Id := UINT#602;//<#Waiting for ErrorReset!
                        END_IF;
                    END_IF;

                    IF NOT Inputs.ErrorReset THEN
                        Outputs.ErrorReset:=FALSE;
                        THIS.CallTimers(FALSE);
                        _progress := 303;
                    END_IF;
                END_IF;
                
                IF _progress = 303 THEN //<#Robot Emergency Stop Reset#>
                    Outputs.ErrorReset := Inputs.EmergencyError AND _blink.output;

                    IF _infoTimer.output THEN
                        IF Inputs.EmergencyError THEN
                            RobotStatus.Error.Id := UINT#603;//<#Waiting for EmergencyError!
                        END_IF;
                    END_IF;

                    IF NOT Inputs.EmergencyError THEN
                        Outputs.ErrorReset:=FALSE;
                        THIS.CallTimers(FALSE);
                        _progress := 304;
                    END_IF;
                END_IF;

                IF _progress = 304 THEN //Reseting program
                    Outputs.ProgramReset :=   _blink.output;

                    IF _infoTimer.output THEN
                        IF NOT Inputs.ProgramReset THEN
                            RobotStatus.Error.Id := UINT#604;//<#Waiting program reset changed!
                        END_IF;
                    END_IF;
                    
                    IF Inputs.ProgramReset THEN
                        THIS.CallTimers(FALSE);
                        _progress := 305;
                        Outputs.ProgramReset :=FALSE;
                    END_IF;
                END_IF;

                IF _progress = 305 THEN //Done
                    StartAtMainTask.DoneWhen(Inputs.ProgramReset);
                END_IF;

                THIS.CallTimers(TRUE);
                
                StartAtMainTask.ThrowWhen(_errorTimer.output );

                RobotStatus.Action.Id := TO_UINT(_progress);
            END_IF;
            IF StartAtMainTask.DoneReached() THEN
                RobotStatus.Action.Id :=  UINT#305;
                RobotStatus.Error.Id :=  UINT#0;
            ELSIF StartAtMainTask.ErrorOccured() THEN
                RobotStatus.Action.Id :=  UINT#703;
                RobotStatus.Error.Id  :=  UINT#703;
            END_IF;
            //*******************************************

            //***********StartMotorsAndProgramTask*******
            StartMotorsAndProgramTask.IsDisabled := FALSE;
            IF StartMotorsAndProgramTask.Execute() THEN

                IF _progress = 0 THEN
                    THIS.CallTimers(FALSE);
                    _progress := 310;
                END_IF;
              
                IF _progress = 310 THEN //Switching to auto mode
                    Outputs.AutoEnable:=TRUE;

                    IF _infoTimer.output THEN
                        IF NOT Inputs.AutoEnable THEN
                            RobotStatus.Error.Id := UINT#610;//<#Waiting for Auto signal! #>
                        END_IF;
                    END_IF;

                    IF  Inputs.AutoEnable THEN
                        THIS.CallTimers(FALSE);
                        _progress := 311;
                    END_IF;
                END_IF;
              
                IF _progress = 311 THEN //Enabling operations
                    Outputs.OperationEnable:=TRUE;
                    
                    IF _infoTimer.output THEN
                        IF NOT  Inputs.OperationEnable THEN
                            RobotStatus.Error.Id := UINT#6111;//<#Waiting for Operation enable signal!
                        END_IF;
                    END_IF;
                    
                    IF  Inputs.OperationEnable THEN
                        THIS.CallTimers(FALSE);
                        _progress := 312;
                    END_IF;
                END_IF;
              
                IF _progress = 312 THEN //Reseting error
                    Outputs.ErrorReset := Inputs.ErrorReset AND _blink.output;

                    IF _infoTimer.output THEN
                        IF Inputs.ErrorReset THEN
                            RobotStatus.Error.Id := UINT#612;//<#Waiting for ErrorReset!
                        END_IF;
                    END_IF;

                    IF NOT Inputs.ErrorReset THEN
                        Outputs.ErrorReset:=FALSE;
                        THIS.CallTimers(FALSE);
                        _progress := 313;
                    END_IF;
                END_IF;

                IF _progress = 313 THEN //<#Robot Emergency Stop Reset#>
                    Outputs.ErrorReset := Inputs.EmergencyError AND _blink.output;

                    IF _infoTimer.output THEN
                        IF Inputs.EmergencyError THEN
                            RobotStatus.Error.Id := UINT#613;//<#Waiting for EmergencyError!
                        END_IF;
                    END_IF;

                    IF NOT Inputs.EmergencyError THEN
                        Outputs.ErrorReset:=FALSE;
                        THIS.CallTimers(FALSE);
                        _progress := 314;
                    END_IF;
                END_IF;
              
                IF _progress = 314 THEN	//Start servomotors
                    IF Inputs.HighLevelError OR Inputs.LowLevelError OR Inputs.CautionLevelError OR  Inputs.EmergencyError THEN 
                        THIS.CallTimers(FALSE);
                        _progress := 310;
                    END_IF;

                    IF _infoTimer.output THEN
                        IF NOT Inputs.ServoOn THEN
                            RobotStatus.Error.Id := UINT#614;//<#Waiting for ServoOn!
                        END_IF;
                        IF Inputs.ErrorReset THEN
                            RobotStatus.Error.Id := UINT#615;//<#Waiting for ErrorReset!
                        END_IF;                        
                    END_IF;
                    
                    Outputs.ServoOn:=_blink.output;

                    IF Inputs.ServoOn AND NOT Inputs.ErrorReset THEN
                         Outputs.ServoOn:=FALSE;
                         THIS.CallTimers(FALSE);
                         _progress := 315;
                    END_IF;
                END_IF;		

                IF _progress = 315 THEN	//Start program
                    IF Inputs.HighLevelError OR Inputs.LowLevelError OR Inputs.CautionLevelError OR  Inputs.EmergencyError THEN 
                        THIS.CallTimers(FALSE);
                        _progress := 310;
                    END_IF;

                    Outputs.Start:=_blink.output;

                    IF _infoTimer.output THEN
                        IF NOT Inputs.Start THEN
                            RobotStatus.Error.Id := UINT#616;//<#Waiting for Start!
                        END_IF;
                        IF Inputs.ErrorReset THEN
                            RobotStatus.Error.Id := UINT#617;//<#Waiting for ErrorReset!
                        END_IF;                        
                    END_IF;
                    
                    IF Inputs.Start AND NOT Inputs.ErrorReset THEN
                        Outputs.Start:=FALSE;
                        _progress := 316;
                    END_IF;
                END_IF;		

                IF _progress = 316 THEN	//Done
                    StartMotorsAndProgramTask.DoneWhen(Inputs.ServoOn AND Inputs.Start AND NOT Inputs.ErrorReset);               
                END_IF;		
                
                THIS.CallTimers(TRUE);
                
                StartMotorsAndProgramTask.ThrowWhen(_errorTimer.output);
                RobotStatus.Action.Id := TO_UINT(_progress);
            END_IF;
            IF StartMotorsAndProgramTask.DoneReached() THEN
                RobotStatus.Action.Id :=  UINT#316;
                RobotStatus.Error.Id :=  UINT#0;
            ELSIF StartMotorsAndProgramTask.ErrorOccured() THEN
                RobotStatus.Action.Id :=  UINT#704;
                RobotStatus.Error.Id  :=  UINT#704;
            END_IF;
            //*******************************************
                        
            //***********StopMovementsTask***************
            StopMovementsTask.IsDisabled := FALSE;
            IF StopMovementsTask.Execute() THEN
                IF _progress = 0 THEN
                    THIS.CallTimers(FALSE);
                    _progress := 320;
                END_IF;
                
                IF _progress = 320 THEN // Switching to auto
                    Outputs.AutoEnable:=TRUE;

                    IF _infoTimer.output THEN
                        IF NOT Inputs.AutoEnable THEN
                            RobotStatus.Error.Id := UINT#620;//<#Waiting for AutoEnable!
                        END_IF;
                    END_IF;

                    IF Inputs.AutoEnable THEN
                        THIS.CallTimers(FALSE);
                        _progress := 321;
                    END_IF;
                END_IF;
                
                IF _progress = 321 THEN
                    Outputs.OperationEnable:=TRUE;

                    IF _infoTimer.output THEN
                        IF NOT Inputs.OperationEnable THEN
                            RobotStatus.Error.Id := UINT#621;//<#Waiting for OperationEnable!
                        END_IF;
                    END_IF;

                    IF Inputs.OperationEnable THEN
                        THIS.CallTimers(FALSE);
                        _progress := 322;
                    END_IF;
                END_IF;

                IF _progress = 322 THEN
                    Outputs.Stop:=TRUE ;
                    Outputs.Start:=FALSE ;
                    
                    IF _infoTimer.output THEN
                        IF NOT Inputs.Stop THEN
                            RobotStatus.Error.Id := UINT#622;//<#Waiting for Stop!
                        END_IF;
                    END_IF;

                    IF Inputs.Stop THEN
                        Outputs.Stop:=FALSE;
                        THIS.CallTimers(FALSE);
                        _progress := 323;
                    END_IF;
                END_IF;		

                IF _progress = 323 THEN // Done
                    StopMovementsTask.DoneWhen(Inputs.Stop);
                END_IF;	

                THIS.CallTimers(TRUE);
                
                StopMovementsTask.ThrowWhen(_errorTimer.output);

                RobotStatus.Action.Id := TO_UINT(_progress);
            END_IF;
            IF StopMovementsTask.DoneReached() THEN
                RobotStatus.Action.Id :=  UINT#323;
                RobotStatus.Error.Id :=  UINT#0;
            ELSIF StopMovementsTask.ErrorOccured() THEN
                RobotStatus.Action.Id :=  UINT#705;
                RobotStatus.Error.Id  :=  UINT#705;
            END_IF;
            //*******************************************

            //***********StopMovementsAndProgramTask*****
            StopMovementsAndProgramTask.IsDisabled := FALSE;
            IF StopMovementsAndProgramTask.Execute() THEN
                IF _progress = 0 THEN
                    THIS.CallTimers(FALSE);
                    _progress := 330;
                END_IF;
                
                IF _progress = 330 THEN
	                Outputs.AutoEnable:=TRUE;

                    IF _infoTimer.output THEN
                        IF NOT Inputs.AutoEnable THEN
                            RobotStatus.Error.Id := UINT#630;//<#Waiting for AutoEnable!
                        END_IF;
                    END_IF;

                    IF Inputs.AutoEnable THEN
                        THIS.CallTimers(FALSE);
                        _progress := 331;
                    END_IF;
                END_IF;
                
                IF _progress = 331 THEN
                    Outputs.OperationEnable:=TRUE;

                    IF _infoTimer.output THEN
                        IF NOT Inputs.OperationEnable THEN
                            RobotStatus.Error.Id := UINT#631;//<#Waiting for OperationEnable!
                        END_IF;
                    END_IF;

                    IF  Inputs.OperationEnable THEN
                        THIS.CallTimers(FALSE);
                        _progress := 332;
                    END_IF;
                END_IF;
                
                IF _progress = 332 THEN
                    Outputs.Stop:=TRUE;
                    Outputs.Start:=FALSE ;

                    IF _infoTimer.output THEN
                        IF NOT Inputs.Stop THEN
                            RobotStatus.Error.Id := UINT#632;//<#Waiting for Stop!
                        END_IF;
                    END_IF;

                    IF Inputs.Stop  THEN
                        Outputs.Stop:=FALSE;
                        THIS.CallTimers(FALSE);
                        _progress := 333;                        
                    END_IF;
                END_IF;		
                        
                                
                IF _progress = 333 THEN // Done
                    StopMovementsAndProgramTask.DoneWhen(Inputs.Stop);
                END_IF;		

                THIS.CallTimers(TRUE);
                
                StopMovementsAndProgramTask.ThrowWhen(_errorTimer.output);

                RobotStatus.Action.Id := TO_UINT(_progress);
            END_IF;
            IF StopMovementsTask.DoneReached() THEN
                RobotStatus.Action.Id :=  UINT#333;
                RobotStatus.Error.Id :=  UINT#0;
            ELSIF StopMovementsTask.ErrorOccured() THEN
                RobotStatus.Action.Id :=  UINT#706;
                RobotStatus.Error.Id  :=  UINT#706;
            END_IF;
            //*******************************************
            
            //***********StartMovementsTask**************
            StartMovementsTask.IsDisabled := FALSE;
            IF StartMovementsTask.Execute() THEN
                IF _progress = 0 THEN
                    THIS.CallTimers(FALSE);
                    _progress := 340;
                END_IF;
                
                IF _progress = 340 THEN
                    IF _infoTimer.output THEN
                        IF NOT Inputs.AutoEnable THEN
                            RobotStatus.Error.Id := UINT#640;//<#Waiting for AutoEnable!
                        END_IF;
                        IF NOT Inputs.OperationEnable THEN
                            RobotStatus.Error.Id := UINT#641;//<#Waiting for OperationEnable!
                        END_IF;
                        IF NOT Inputs.ServoOn THEN
                            RobotStatus.Error.Id := UINT#642;//<#Waiting for ServoOn!
                        END_IF;
                        IF Inputs.ErrorReset THEN
                            RobotStatus.Error.Id := UINT#643;//<#Waiting for ErrorReset!
                        END_IF;
                    END_IF;

                    IF Inputs.AutoEnable AND Inputs.OperationEnable AND Inputs.ServoOn AND NOT Inputs.ErrorReset THEN
                        THIS.CallTimers(FALSE);
                        _progress := 341;
                    END_IF;
                END_IF;
                
                IF _progress = 341 THEN

                    Outputs.GlobalSpeed     := RobotStatus.CurrentMovementParameters.GlobalSpeed;
                    Outputs.ToolNo          := RobotStatus.CurrentMovementParameters.ToolNo;
                    Outputs.WorkobjectNo    := RobotStatus.CurrentMovementParameters.WorkobjectNo;
                    Outputs.PointNo         := RobotStatus.CurrentMovementParameters.PointNo;
                    Outputs.UserSpecSpeed1  := RobotStatus.CurrentMovementParameters.UserSpecSpeed1;
                    Outputs.UserSpecSpeed2  := RobotStatus.CurrentMovementParameters.UserSpecSpeed2;
                    Outputs.Coordinates     := RobotStatus.CurrentMovementParameters.Coordinates; 		
                
                    Outputs.ActionNo := BYTE#254;
                    IF _infoTimer.output THEN
                        IF Outputs.ActionNo <> Inputs.ActionNo THEN
                            RobotStatus.Error.Id := UINT#644;//<#Waiting for Inputs.ActionNo to be equal to Outputs.ActionNo!
                        END_IF;
                    END_IF;

                    IF Outputs.ActionNo = Inputs.ActionNo THEN
                        THIS.CallTimers(FALSE);
                        _progress := 342;
                    END_IF;
                END_IF;
                
                IF _progress = 342 THEN
                    IF _infoTimer.output THEN
                        IF Inputs.GlobalSpeed <> RobotStatus.CurrentMovementParameters.GlobalSpeed THEN
                            RobotStatus.Error.Id := UINT#645;//<#Waiting for Inputs.GlobalSpeed to be equal to MovementParameters.GlobalSpeed!
                        END_IF;
                        IF Inputs.ToolNo <> RobotStatus.CurrentMovementParameters.ToolNo THEN
                            RobotStatus.Error.Id := UINT#646;//<#Waiting for Inputs.ToolNo to be equal to MovementParameters.ToolNo!
                        END_IF;
                        IF Inputs.WorkobjectNo <> RobotStatus.CurrentMovementParameters.WorkobjectNo THEN
                            RobotStatus.Error.Id := UINT#647;//<#Waiting for Inputs.WorkobjectNo to be equal to MovementParameters.WorkobjectNo!
                        END_IF;
                        IF Inputs.PointNo <> RobotStatus.CurrentMovementParameters.PointNo THEN
                            RobotStatus.Error.Id := UINT#648;//<#Waiting for Inputs.PointNo to be equal to MovementParameters.PointNo!
                        END_IF;
                        IF Inputs.UserSpecSpeed1 <> RobotStatus.CurrentMovementParameters.UserSpecSpeed1 THEN
                            RobotStatus.Error.Id := UINT#649;//<#Waiting for Inputs.UserSpecSpeed1 to be equal to MovementParameters.UserSpecSpeed1!
                        END_IF;
                        IF Inputs.UserSpecSpeed2 <> RobotStatus.CurrentMovementParameters.UserSpecSpeed2 THEN
                            RobotStatus.Error.Id := UINT#650;//<#Waiting for Inputs.UserSpecSpeed2 to be equal to MovementParameters.UserSpecSpeed2!
                        END_IF;
                    END_IF;

                    IF 	Inputs.GlobalSpeed      = RobotStatus.CurrentMovementParameters.GlobalSpeed AND
                        Inputs.ToolNo           = RobotStatus.CurrentMovementParameters.ToolNo AND
                        Inputs.WorkobjectNo     = RobotStatus.CurrentMovementParameters.WorkobjectNo AND
                        Inputs.PointNo          = RobotStatus.CurrentMovementParameters.PointNo AND
                        Inputs.UserSpecSpeed1   = RobotStatus.CurrentMovementParameters.UserSpecSpeed1 AND
                        Inputs.UserSpecSpeed2   = RobotStatus.CurrentMovementParameters.UserSpecSpeed2 AND
                        AXOpen.Components.Robotics.CoordinatesAreNearlyEqual(Inputs.Coordinates,RobotStatus.CurrentMovementParameters.Coordinates,REAL#0.01,REAL#0.01,REAL#0.01,REAL#0.01,REAL#0.01,REAL#0.01) THEN
                        Outputs.ActionNo := BYTE#255;
                        THIS.CallTimers(FALSE);
                        _progress:=343;
                    END_IF;
                END_IF;		

                IF _progress = 343 THEN
                    IF _infoTimer.output THEN
                        IF Outputs.ActionNo <> Inputs.ActionNo THEN
                            RobotStatus.Error.Id := UINT#651;//<#Waiting for Inputs.ActionNo to be equal to Outputs.ActionNo!
                        END_IF;
                    END_IF;

                    IF Outputs.ActionNo = Inputs.ActionNo THEN
                        THIS.CallTimers(FALSE);
                        _progress:=344;
                    END_IF;
                END_IF;	
                
                IF _progress = 344 THEN
                    Outputs.ActionNo := RobotStatus.CurrentMovementParameters.ActionNo;

                    IF _infoTimer.output THEN
                        IF Outputs.ActionNo <> Inputs.ActionNo THEN
                            RobotStatus.Error.Id := UINT#652;//<#Waiting for Inputs.ActionNo to be equal to Outputs.ActionNo!
                        END_IF;
                    END_IF;
	
                    IF Outputs.ActionNo = Inputs.ActionNo THEN
                        THIS.CallTimers(FALSE);
                        Outputs.ActionNo := BYTE#255;
                        _progress:=345;
                    END_IF;
                END_IF;	

                IF _progress = 345 THEN
                    Outputs.ActionNo := BYTE#255;

                    IF _infoTimer.output THEN
                        IF Outputs.ActionNo <> Inputs.ActionNo THEN
                            RobotStatus.Error.Id := UINT#653;//<#Waiting for Inputs.ActionNo to be equal to Outputs.ActionNo!
                        END_IF;
                    END_IF;
	
                    IF Outputs.ActionNo = Inputs.ActionNo THEN
                        StartMovementsTask.DoneWhen(TRUE);
                    END_IF;
                END_IF;	
                
	            THIS.CallTimers(TRUE);
                
                StartMovementsTask.ThrowWhen(_errorTimer.output);

                RobotStatus.Action.Id := TO_UINT(_progress);
            END_IF;
            IF StartMovementsTask.IsFirstExecutionCycle() THEN
                MovementParameters := RobotStatus.CurrentMovementParameters;
            END_IF;
            IF StopMovementsTask.DoneReached() THEN
                RobotStatus.Action.Id :=  UINT#346;
                RobotStatus.Error.Id :=  UINT#0;
            ELSIF StopMovementsTask.ErrorOccured() THEN
                RobotStatus.Action.Id :=  UINT#707;
                RobotStatus.Error.Id  :=  UINT#707;
            END_IF;
            //*******************************************

            //***********UPDATE**OUTPUTS*****************
            //SYSTEM OUTPUTS
            refOutputs^     [0].%X0	        := Outputs.OperationEnable;    
            refOutputs^     [0].%X1	        := Outputs.AutoEnable;    
            refOutputs^     [0].%X2         := Outputs.Start; 
            refOutputs^     [0].%X3         := Outputs.Stop;
            refOutputs^     [0].%X4         := Outputs.ProgramReset;   
            refOutputs^     [0].%X5         := Outputs.ErrorReset; 
            refOutputs^     [0].%X6         := Outputs.CycleStop;    
            refOutputs^     [0].%X7         := Outputs.ServoOff; 

            refOutputs^     [1].%X0 	    := Outputs.ServoOn;    
            refOutputs^     [1].%X1 	    := Outputs.GeneralPurposeReset;    
            refOutputs^     [1].%X2 	    := Outputs.OverideSpecifications;    
                
            //Tool signals
            refOutputs^     [2].%X0 	    := Outputs.Tool_1_Retract;    
            refOutputs^     [2].%X1 	    := Outputs.Tool_1_Extend;    
            refOutputs^     [2].%X2	        := Outputs.Tool_2_Retract;    
            refOutputs^     [2].%X3	        := Outputs.Tool_2_Extend;    
            refOutputs^     [2].%X4	        := Outputs.Tool_3_Retract;    
            refOutputs^     [2].%X5	        := Outputs.Tool_3_Extend;    
            refOutputs^     [2].%X6 	    := Outputs.Tool_4_Retract;    
            refOutputs^     [2].%X7	        := Outputs.Tool_4_Extend;    

            //master mode  such as manual/auto ..
            refOutputs^     [3]             := Outputs.MasterMode;

            //zone
            refOutputs^     [5]             := Outputs.Zone;

            //position
            refOutputs^     [6]             := Outputs.InPosition;

            //Movement parameters
            refOutputs^     [7]             := Outputs.ActionNo;
            refOutputs^     [8]             := Outputs.GlobalSpeed;
            refOutputs^     [9]             := Outputs.ToolNo;
            refOutputs^     [10]            := Outputs.WorkobjectNo;
            refOutputs^     [11]            := Outputs.PointNo;

            _dword                          := TO_DWORD(Outputs.UserSpecSpeed1);
            refOutputs^     [12]            := _dword.%B3;
            refOutputs^     [13]            := _dword.%B2;
            refOutputs^     [14]            := _dword.%B1;
            refOutputs^     [15]            := _dword.%B0;

            _dword                          := TO_DWORD(Outputs.UserSpecSpeed2);
            refOutputs^     [16]            := _dword.%B3;
            refOutputs^     [18]            := _dword.%B2;
            refOutputs^     [18]            := _dword.%B1;
            refOutputs^     [19]            := _dword.%B0;

            ////Coordinates
            _dword                          := TO_DWORD((Outputs.Coordinates.X +REAL#10000.0)*REAL#10000.0);
            refOutputs^     [20]            := _dword.%B3;
            refOutputs^     [21]            := _dword.%B2;
            refOutputs^     [22]            := _dword.%B1;
            refOutputs^     [23]            := _dword.%B0;

            _dword                          := TO_DWORD((Outputs.Coordinates.Y +REAL#10000.0)*REAL#10000.0);
            refOutputs^     [24]            := _dword.%B3;
            refOutputs^     [25]            := _dword.%B2;
            refOutputs^     [26]            := _dword.%B1;
            refOutputs^     [27]            := _dword.%B0;

            _dword                          := TO_DWORD((Outputs.Coordinates.Z +REAL#10000.0)*REAL#10000.0);
            refOutputs^     [28]            := _dword.%B3;
            refOutputs^     [29]            := _dword.%B2;
            refOutputs^     [30]            := _dword.%B1;
            refOutputs^     [31]            := _dword.%B0;

            _dword                          := TO_DWORD((Outputs.Coordinates.Rx +REAL#360.0)*REAL#10000.0);
            refOutputs^     [32]            := _dword.%B3;
            refOutputs^     [33]            := _dword.%B2;
            refOutputs^     [34]            := _dword.%B1;
            refOutputs^     [35]            := _dword.%B0;

            _dword                          := TO_DWORD((Outputs.Coordinates.Ry +REAL#360.0)*REAL#10000.0);
            refOutputs^     [36]            := _dword.%B3;
            refOutputs^     [37]            := _dword.%B2;
            refOutputs^     [38]            := _dword.%B1;
            refOutputs^     [39]            := _dword.%B0;

            _dword                          := TO_DWORD((Outputs.Coordinates.Rz +REAL#360.0)*REAL#10000.0);
            refOutputs^     [40]            := _dword.%B3;
            refOutputs^     [41]            := _dword.%B2;
            refOutputs^     [42]            := _dword.%B1;
            refOutputs^     [43]            := _dword.%B0;
            //*******************************************
            THIS.Close();
        END_METHOD

        METHOD PROTECTED OVERRIDE ManualControl
            RobotStatus.CurrentMovementParameters := MovementParameters;
        END_METHOD
        
        ///<summary>
        /// Restores this component into intial state.        
        ///</summary>
        METHOD PUBLIC OVERRIDE Restore
            StartAtMainTask.Restore();
            StartMotorsAndProgramTask.Restore();
            StopMovementsTask.Restore();
            StopMovementsAndProgramTask.Restore();
            StartMovementsTask.Restore();
            RestoreTask.DoneWhen(TRUE);
        END_METHOD        
    
        METHOD PUBLIC StartAtMain : IAxoTaskState
            StartAtMain := StartAtMainTask.Invoke();
        END_METHOD
    
        METHOD PUBLIC StartMotorsAndProgram : IAxoTaskState
            StartMotorsAndProgram := StartMotorsAndProgramTask.Invoke();
        END_METHOD
    
        METHOD PUBLIC StartMovements : IAxoTaskState
            VAR_IN_OUT
                inData : AxoRoboticsMovementsParams;
            END_VAR
            RobotStatus.CurrentMovementParameters := inData;

            StartMovements := StartMovementsTask.Invoke();
        END_METHOD
    
        METHOD PUBLIC StopMovements : IAxoTaskState
            VAR_INPUT
                inStopType : eAxoRoboticsStopType;
            END_VAR
            StopMovements := StopMovementsTask.Invoke();           
        END_METHOD
    
        METHOD PUBLIC StopMovementsAndProgram : IAxoTaskState
            VAR_INPUT
                inStopType : eAxoRoboticsStopType;
            END_VAR

            StopMovementsAndProgram := StopMovementsAndProgramTask.Invoke();
        END_METHOD

        METHOD PRIVATE CallTimers
            VAR_INPUT
                signal : BOOL;
            END_VAR
            
            _infoTimer.OnDelay(THIS, signal , _infoTime);
            _errorTimer.OnDelay(THIS, signal , _errorTime );
        END_METHOD
    END_CLASS
END_NAMESPACE
