USING AXOpen.Core;
USING AXOpen.Messaging;
USING AXOpen.Messaging.Static;
USING AXOpen.Components.Robotics;
USING AXOpen.Components.Abstractions.Robotics;

NAMESPACE AXOpen.Components.Abb.Robotics
    {S7.extern=ReadWrite}
    CLASS AxoOmnicore_v_1_x_x EXTENDS AXOpen.Core.AxoComponent IMPLEMENTS AXOpen.Components.Abstractions.Robotics.IAxoRobotics
        VAR PRIVATE
            _infoTimer              :   AXOpen.Timers.OnDelayTimer;
            _infoTime               :   LTIME := LT#2S;
            _errorTimer             :   AXOpen.Timers.OnDelayTimer;
            _errorTime              :   LTIME := LT#5S;
            _blink                  :   AXOpen.Timers.AxoBlinker;
            _context                :   IAxoContext;
            _stopTasksAreActive     :   BOOL;
            _stopType               :   eAxoRoboticsStopType;
            _someTaskIsActive       :   BOOL;
        END_VAR

        VAR PUBLIC //HEADER
                    
        END_VAR

        VAR PUBLIC //Tasks
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Tasks")]}            
            {#ix-set:AttributeName = "<#Restore#>"}
            RestoreTask : AxoTask;            

            {#ix-attr:[ComponentDetails("Tasks")]}            
            {#ix-set:AttributeName = "<#Stop movements#>"}
            StopMovementsTask : AxoTask;

            {#ix-attr:[ComponentDetails("Tasks")]}            
            {#ix-set:AttributeName = "<#Stop movements and program#>"}
            StopMovementsAndProgramTask : AxoTask;

            {#ix-attr:[ComponentDetails("Tasks")]}            
            {#ix-set:AttributeName = "<#Stop program#>"}
            StopProgramTask : AxoTask;

            {#ix-attr:[ComponentDetails("Tasks")]}            
            {#ix-set:AttributeName = "<#Stop motors#>"}
            StopMotorsTask : AxoTask;

            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Tasks")]}            
            {#ix-set:AttributeName = "<#Start at main#>"}
            StartAtMainTask : AxoTask;            

            {#ix-attr:[ComponentDetails("Tasks")]}            
            {#ix-set:AttributeName = "<#Start motors and program#>"}
            StartMotorsAndProgramTask : AxoTask;

            {#ix-attr:[ComponentDetails("Tasks")]}            
            {#ix-set:AttributeName = "<#Start program#>"}
            StartProgramTask : AxoTask;            

            {#ix-attr:[ComponentDetails("Tasks")]}            
            {#ix-set:AttributeName = "<#Start motors#>"}
            StartMotorsTask : AxoTask;            

            {#ix-attr:[ComponentDetails("Tasks")]}            
            {#ix-set:AttributeName = "<#Start movements#>"}
            StartMovementsTask : AxoTask;

            {#ix-attr:[ComponentDetails("Tasks")]}            
            {#ix-set:AttributeName = "<#Start motors program and movements#>"}
            StartMotorsProgramAndMovementsTask : AxoTask;

            {#ix-attr:[ComponentDetails("Tasks")]}            
            {#ix-set:AttributeName = "<#Start movements with extended parameters#>"}
            MovementParameters : AXOpen.Components.Abstractions.Robotics.AxoRoboticsMovementsParams;
        END_VAR
        
        VAR PUBLIC //CONFIG
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("Config")]}
            {#ix-attr:[ReadOnly()]}
            Config  :   AxoAbbRobotics_Config_v_1_x_x;
        END_VAR

        VAR PUBLIC //STATUS
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("Status")]}
            {#ix-attr:[ReadOnly()]}
            RobotStatus         :   AxoAbbRobotics_Component_Status_v_1_x_x;
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
            Inputs              :   AxoAbbRobotics_State_v_1_x_x;
            {#ix-attr:[ComponentDetails("Hardware signals")]}
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Outputs#>"}
            {#ix-attr:[ReadOnly()]}
            Outputs              :   AxoAbbRobotics_Control_v_1_x_x;
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
            Inputs.AutoOn                   := refInputs^       [0].%X0;
            Inputs.CycleOn                  := refInputs^       [0].%X1;
            Inputs.EmgStop                  := refInputs^       [0].%X2;
            Inputs.Error                    := refInputs^       [0].%X3;
            Inputs.MoveActive               := refInputs^       [0].%X4;
            Inputs.MoveInactive             := refInputs^       [0].%X5;
            Inputs.MotorOff                 := refInputs^       [0].%X6;
            Inputs.MotorOn                  := refInputs^       [0].%X7;

            Inputs.MotorOffState            := refInputs^       [1].%X0;
            Inputs.MotorOnState             := refInputs^       [1].%X1;
            Inputs.ProgExecError            := refInputs^       [1].%X2;
            Inputs.SafetyOk                 := refInputs^       [1].%X3;
            Inputs.SystemInputBusy          := refInputs^       [1].%X4;
            Inputs.PpMoved                  := refInputs^       [1].%X5;
            Inputs.MotionSupervision        := refInputs^       [1].%X6;
            Inputs.BatteryLow               := refInputs^       [1].%X7;

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

            //Safety signals
            Inputs.AutoStop_1               := refInputs^        [4].%X0;
            Inputs.AutoStop_2               := refInputs^        [4].%X1;
            Inputs.EmergencyStop_1          := refInputs^        [4].%X2;
            Inputs.EmergencyStop_2          := refInputs^        [4].%X3;
            Inputs.GeneralStop_1            := refInputs^        [4].%X4;
            Inputs.GeneralStop_2            := refInputs^        [4].%X5;
            Inputs.Enable_1                 := refInputs^        [4].%X6;
            Inputs.Enable_2                 := refInputs^        [4].%X7;

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

            _dword.%B3                      := refInputs^       [44];
            _dword.%B2                      := refInputs^       [45];
            _dword.%B1                      := refInputs^       [46];
            _dword.%B0                      := refInputs^       [47];
            Inputs.EventId                  := TO_UDINT(_dword);
            //*******************************************
            _context := THIS.GetContext();

            _infoTime := Config.InfoTime;
            _errorTime := Config.ErrorTime;

            //*************INITIALIZATION*************
            RestoreTask.Initialize(THIS);
            StopMovementsTask.Initialize(THIS);
            StopMovementsAndProgramTask.Initialize(THIS);
            StopProgramTask.Initialize(THIS);
            StopMotorsTask.Initialize(THIS);
            StartAtMainTask.Initialize(THIS);
            StartMotorsAndProgramTask.Initialize(THIS);
            StartProgramTask.Initialize(THIS);
            StartMotorsTask.Initialize(THIS);
            StartMovementsTask.Initialize(THIS);
            StartMotorsProgramAndMovementsTask.Initialize(THIS);
            HardwareDiagnosticsTask.Initialize(THIS);

            _stopTasksAreActive := StopMovementsTask.IsBusy() OR StopMovementsAndProgramTask.IsBusy() OR StopProgramTask.IsBusy() OR StopMotorsTask.IsBusy();
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
            StartAtMainTask.IsDisabled := _stopTasksAreActive;
            IF StartAtMainTask.Execute() THEN
                _blink.Blink(Context := _context, inOnTime:=T#500MS,inOffTime:=T#500MS);
                IF _progress = 0 THEN
                    THIS.CallTimers(FALSE);
                    _progress := 300;
                END_IF;
                
                IF _progress = 300 THEN  
                    Outputs.StartAtMain := _blink.output;
                            
                    IF _infoTimer.output THEN
                        IF NOT Inputs.PpMoved THEN
                            RobotStatus.Error.Id := UINT#600;//<#Waiting program pointer changed!#>
                        END_IF;
                    END_IF;

                    IF Inputs.PpMoved  THEN
                        THIS.CallTimers(FALSE);
                        Outputs.StartAtMain :=FALSE;
                        _progress:=301;                    
                    END_IF;
                END_IF;

                IF _progress = 301 THEN  
                    StartAtMainTask.DoneWhen(TRUE);
                    THIS.CallTimers(FALSE);
                    _progress := 0;
                END_IF;

                THIS.CallTimers(TRUE);
                StartAtMainTask.ThrowWhen(_errorTimer.output );
                RobotStatus.Action.Id := TO_UINT(_progress);
            END_IF;
            IF StartAtMainTask.DoneReached() THEN
                RobotStatus.Action.Id :=  UINT#302;
                RobotStatus.Error.Id :=  UINT#0;
            ELSIF StartAtMainTask.ErrorOccured() THEN
                RobotStatus.Action.Id :=  UINT#703;
                RobotStatus.Error.Id  :=  UINT#703;
            END_IF;
            //*******************************************

            //***********StartMotorsAndProgramTask*******
            StartMotorsAndProgramTask.IsDisabled := _stopTasksAreActive OR StartProgramTask.IsBusy() OR StartMotorsTask.IsBusy();
            IF StartMotorsAndProgramTask.Execute() THEN
                _blink.Blink(Context := _context, inOnTime:=T#500MS,inOffTime:=T#500MS);

                IF _progress = 0 THEN
                    THIS.CallTimers(FALSE);
                    _progress := 310;
                END_IF;
              
                IF _progress = 310 THEN //Switching to auto
                    IF _infoTimer.output THEN
                        IF NOT Inputs.AutoOn THEN
                            RobotStatus.Error.Id := UINT#610; 
                        END_IF;
                    END_IF;

                    IF Inputs.AutoOn THEN
                        THIS.CallTimers(FALSE);
                        _progress := 311;
                    END_IF;
                END_IF;

                IF _progress = 311 THEN	//Reseting error
                    Outputs.ResetError := Inputs.Error AND _blink.output;

                    IF _infoTimer.output THEN
                        IF Inputs.Error THEN
                            RobotStatus.Error.Id := UINT#611;
                        END_IF;
                    END_IF;

                    IF NOT Inputs.Error THEN
                        Outputs.ResetError:=FALSE;
                        THIS.CallTimers(FALSE);
                        _progress := 312;
                    END_IF;
                END_IF;
              
                IF _progress = 312 THEN	//Reseting emergency stop error
                    Outputs.ResetEmgStop := Inputs.EmgStop AND _blink.output;

                    IF _infoTimer.output THEN
                        IF Inputs.EmgStop THEN
                            RobotStatus.Error.Id := UINT#612;
                        END_IF;
                    END_IF;

                    IF NOT Inputs.EmgStop THEN
                        Outputs.ResetEmgStop:=FALSE;
                        THIS.CallTimers(FALSE);
                        _progress := 313;
                    END_IF;
                END_IF;
              
                IF _progress = 313 THEN	
                    Outputs.MotorOnAndStart:=_blink.output;	

                    IF Inputs.Error THEN 
                        THIS.CallTimers(FALSE);
                        _progress := 310;
                    END_IF;

                    IF _infoTimer.output THEN
                        IF NOT Inputs.MotorOnState THEN
                            RobotStatus.Error.Id := UINT#613;
                        END_IF;
                        IF NOT Inputs.CycleOn THEN
                            RobotStatus.Error.Id := UINT#614;
                        END_IF;
                        IF Inputs.Error THEN
                            RobotStatus.Error.Id := UINT#615;
                        END_IF;
                    END_IF;

                    IF Inputs.MotorOnState AND Inputs.CycleOn AND NOT Inputs.Error THEN
                         Outputs.MotorOnAndStart:=FALSE;
                         THIS.CallTimers(FALSE);
                         _progress := 314;
                    END_IF;
                END_IF;		
              
                IF _progress = 314 THEN	
                    StartMotorsAndProgramTask.DoneWhen(TRUE);
                    THIS.CallTimers(FALSE);
                    _progress := 0;
                END_IF;	              

                THIS.CallTimers(TRUE);
                StartMotorsAndProgramTask.ThrowWhen(_errorTimer.output);
                RobotStatus.Action.Id := TO_UINT(_progress);
            END_IF;
            IF StartMotorsAndProgramTask.DoneReached() THEN
                RobotStatus.Action.Id :=  UINT#315;
                RobotStatus.Error.Id :=  UINT#0;
            ELSIF StartMotorsAndProgramTask.ErrorOccured() THEN
                RobotStatus.Action.Id :=  UINT#704;
                RobotStatus.Error.Id  :=  UINT#704;
            END_IF;
            //*******************************************
                        
            //***********StartMotorsProgramAndMovementsTask*******
            StartMotorsProgramAndMovementsTask.IsDisabled := _stopTasksAreActive OR StartProgramTask.IsBusy() OR StartMotorsTask.IsBusy() OR StartMovementsTask.IsBusy();
            IF StartMotorsProgramAndMovementsTask.Execute() THEN
                _blink.Blink(Context := _context, inOnTime:=T#500MS,inOffTime:=T#500MS);

                IF _progress = 0 THEN
                    THIS.CallTimers(FALSE);
                    _progress := 320;
                END_IF;
              
                IF _progress = 320 THEN //Switching to auto
                    IF _infoTimer.output THEN
                        IF NOT Inputs.AutoOn THEN
                            RobotStatus.Error.Id := UINT#620; 
                        END_IF;
                    END_IF;

                    IF Inputs.AutoOn THEN
                        THIS.CallTimers(FALSE);
                        _progress := 321;
                    END_IF;
                END_IF;

                IF _progress = 321 THEN	//Reseting error
                    Outputs.ResetError := Inputs.Error AND _blink.output;

                    IF _infoTimer.output THEN
                        IF Inputs.Error THEN
                            RobotStatus.Error.Id := UINT#621;
                        END_IF;
                    END_IF;

                    IF NOT Inputs.Error THEN
                        Outputs.ResetError:=FALSE;
                        THIS.CallTimers(FALSE);
                        _progress := 322;
                    END_IF;
                END_IF;
              
                IF _progress = 322 THEN	//Reseting emergency stop error
                    Outputs.ResetEmgStop := Inputs.EmgStop AND _blink.output;

                    IF _infoTimer.output THEN
                        IF Inputs.EmgStop THEN
                            RobotStatus.Error.Id := UINT#622;
                        END_IF;
                    END_IF;

                    IF NOT Inputs.EmgStop THEN
                        Outputs.ResetEmgStop:=FALSE;
                        THIS.CallTimers(FALSE);
                        _progress := 323;
                    END_IF;
                END_IF;
              
                IF _progress = 323 THEN	
                    IF Inputs.Error THEN 
                        THIS.CallTimers(FALSE);
                        _progress := 320;
                    END_IF;

                    IF _infoTimer.output THEN
                        IF NOT Inputs.MotorOnState THEN
                            RobotStatus.Error.Id := UINT#623;
                        END_IF;
                        IF NOT Inputs.CycleOn THEN
                            RobotStatus.Error.Id := UINT#624;
                        END_IF;
                        IF Inputs.Error THEN
                            RobotStatus.Error.Id := UINT#625;
                        END_IF;
                    END_IF;

                    Outputs.MotorOnAndStart:=_blink.output;	
                    IF Inputs.MotorOnState AND Inputs.CycleOn AND NOT Inputs.Error THEN
                         Outputs.MotorOnAndStart:=FALSE;
                         THIS.CallTimers(FALSE);
                         _progress := 324;
                    END_IF;
                END_IF;		
	
                IF _progress = 324 THEN
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
                            RobotStatus.Error.Id := UINT#626;//<#Waiting for Inputs.ActionNo to be equal to Outputs.ActionNo!
                        END_IF;
                    END_IF;

                    IF Outputs.ActionNo = Inputs.ActionNo THEN
                        THIS.CallTimers(FALSE);
                        _progress := 325;
                    END_IF;
                END_IF;
                
                IF _progress = 325 THEN
                    IF _infoTimer.output THEN
                        IF Inputs.GlobalSpeed <> RobotStatus.CurrentMovementParameters.GlobalSpeed THEN
                            RobotStatus.Error.Id := UINT#627;//<#Waiting for Inputs.GlobalSpeed to be equal to MovementParameters.GlobalSpeed!
                        END_IF;
                        IF Inputs.ToolNo <> RobotStatus.CurrentMovementParameters.ToolNo THEN
                            RobotStatus.Error.Id := UINT#628;//<#Waiting for Inputs.ToolNo to be equal to MovementParameters.ToolNo!
                        END_IF;
                        IF Inputs.WorkobjectNo <> RobotStatus.CurrentMovementParameters.WorkobjectNo THEN
                            RobotStatus.Error.Id := UINT#629;//<#Waiting for Inputs.WorkobjectNo to be equal to MovementParameters.WorkobjectNo!
                        END_IF;
                        IF Inputs.PointNo <> RobotStatus.CurrentMovementParameters.PointNo THEN
                            RobotStatus.Error.Id := UINT#630;//<#Waiting for Inputs.PointNo to be equal to MovementParameters.PointNo!
                        END_IF;
                        IF Inputs.UserSpecSpeed1 <> RobotStatus.CurrentMovementParameters.UserSpecSpeed1 THEN
                            RobotStatus.Error.Id := UINT#631;//<#Waiting for Inputs.UserSpecSpeed1 to be equal to MovementParameters.UserSpecSpeed1!
                        END_IF;
                        IF Inputs.UserSpecSpeed2 <> RobotStatus.CurrentMovementParameters.UserSpecSpeed2 THEN
                            RobotStatus.Error.Id := UINT#632;//<#Waiting for Inputs.UserSpecSpeed2 to be equal to MovementParameters.UserSpecSpeed2!
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
                        _progress:=326;
                    END_IF;
                END_IF;		

                IF _progress = 326 THEN
                    IF _infoTimer.output THEN
                        IF Outputs.ActionNo <> Inputs.ActionNo THEN
                            RobotStatus.Error.Id := UINT#633;//<#Waiting for Inputs.ActionNo to be equal to Outputs.ActionNo!
                        END_IF;
                    END_IF;

                    IF Outputs.ActionNo = Inputs.ActionNo THEN
                        THIS.CallTimers(FALSE);
                        _progress:=327;
                    END_IF;
                END_IF;	
                
                IF _progress = 327 THEN
                    Outputs.ActionNo := RobotStatus.CurrentMovementParameters.ActionNo;

                    IF _infoTimer.output THEN
                        IF Outputs.ActionNo <> Inputs.ActionNo THEN
                            RobotStatus.Error.Id := UINT#634;//<#Waiting for Inputs.ActionNo to be equal to Outputs.ActionNo!
                        END_IF;
                    END_IF;
	
                    IF Outputs.ActionNo = Inputs.ActionNo THEN
                        THIS.CallTimers(FALSE);
                        Outputs.ActionNo := BYTE#255;
                        _progress:=328;
                    END_IF;
                END_IF;	

                IF _progress = 328 THEN
                    Outputs.ActionNo := BYTE#255;

                    IF _infoTimer.output THEN
                        IF Outputs.ActionNo <> Inputs.ActionNo THEN
                            RobotStatus.Error.Id := UINT#635;//<#Waiting for Inputs.ActionNo to be equal to Outputs.ActionNo!
                        END_IF;
                    END_IF;
	
                    IF Outputs.ActionNo = Inputs.ActionNo THEN
                        _progress := 0;
                        StartMotorsProgramAndMovementsTask.DoneWhen(TRUE);
                    END_IF;
                END_IF;	
                
	            THIS.CallTimers(TRUE);
                StartMotorsProgramAndMovementsTask.ThrowWhen(_errorTimer.output);
                RobotStatus.Action.Id := TO_UINT(_progress);
            END_IF;
            IF StartMotorsProgramAndMovementsTask.DoneReached() THEN
                RobotStatus.Action.Id :=  UINT#329;
                RobotStatus.Error.Id :=  UINT#0;
            ELSIF StartMotorsProgramAndMovementsTask.ErrorOccured() THEN
                RobotStatus.Action.Id :=  UINT#705;
                RobotStatus.Error.Id  :=  UINT#705;
            END_IF;
            //*******************************************
                        
            //***********StartMotorsTask*****************
            StartMotorsTask.IsDisabled := _stopTasksAreActive OR StartMotorsProgramAndMovementsTask.IsBusy() OR StartMotorsAndProgramTask.IsBusy();
            IF StartMotorsTask.Execute() THEN
                _blink.Blink(Context := _context, inOnTime:=T#500MS,inOffTime:=T#500MS);

                IF _progress = 0 THEN
                    THIS.CallTimers(FALSE);
                    _progress := 340;
                END_IF;
              
                IF _progress = 340 THEN //Switching to auto
                    IF _infoTimer.output THEN
                        IF NOT Inputs.AutoOn THEN
                            RobotStatus.Error.Id := UINT#640; 
                        END_IF;
                    END_IF;

                    IF Inputs.AutoOn THEN
                        THIS.CallTimers(FALSE);
                        _progress := 341;
                    END_IF;
                END_IF;

                IF _progress = 341 THEN	//Reseting error
                    Outputs.ResetError := Inputs.Error AND _blink.output;

                    IF _infoTimer.output THEN
                        IF Inputs.Error THEN
                            RobotStatus.Error.Id := UINT#641;
                        END_IF;
                    END_IF;

                    IF NOT Inputs.Error THEN
                        Outputs.ResetError:=FALSE;
                        THIS.CallTimers(FALSE);
                        _progress := 342;
                    END_IF;
                END_IF;
              
                IF _progress = 342 THEN	//Reseting emergency stop error
                    Outputs.ResetEmgStop := Inputs.EmgStop AND _blink.output;

                    IF _infoTimer.output THEN
                        IF Inputs.EmgStop THEN
                            RobotStatus.Error.Id := UINT#642;
                        END_IF;
                    END_IF;

                    IF NOT Inputs.EmgStop THEN
                        Outputs.ResetEmgStop:=FALSE;
                        THIS.CallTimers(FALSE);
                        _progress := 343;
                    END_IF;
                END_IF;
              
                IF _progress = 343 THEN	
                    IF Inputs.Error THEN 
                        THIS.CallTimers(FALSE);
                        _progress := 340;
                    END_IF;
                    IF _infoTimer.output THEN
                        IF NOT Inputs.MotorOnState THEN
                            RobotStatus.Error.Id := UINT#643;
                        END_IF;
                        IF Inputs.Error THEN
                            RobotStatus.Error.Id := UINT#644;
                        END_IF;
                    END_IF;

                    Outputs.MotorOn:=_blink.output;	
                    IF Inputs.MotorOnState AND NOT Inputs.Error THEN
                         Outputs.MotorOn:=FALSE;
                         THIS.CallTimers(FALSE);
                         _progress := 344;
                    END_IF;
                END_IF;		
              
                IF _progress = 344 THEN	
                    StartMotorsTask.DoneWhen(TRUE);
                    THIS.CallTimers(FALSE);
                    _progress := 0;
                END_IF;	              

                THIS.CallTimers(TRUE);
                StartMotorsTask.ThrowWhen(_errorTimer.output);
                RobotStatus.Action.Id := TO_UINT(_progress);
            END_IF;
            IF StartMotorsTask.DoneReached() THEN
                RobotStatus.Action.Id :=  UINT#345;
                RobotStatus.Error.Id :=  UINT#0;
            ELSIF StartMotorsTask.ErrorOccured() THEN
                RobotStatus.Action.Id :=  UINT#706;
                RobotStatus.Error.Id  :=  UINT#706;
            END_IF;
            //*******************************************
               
            //***********StartMovementsTask**************
            StartMovementsTask.IsDisabled := _stopTasksAreActive OR StartMotorsProgramAndMovementsTask.IsBusy();
            IF StartMovementsTask.Execute() THEN
                IF _progress = 0 THEN
                    THIS.CallTimers(FALSE);
                    _progress := 350;
                END_IF;
                
                IF _progress = 350 THEN
                    IF _infoTimer.output THEN
                        IF NOT Inputs.CycleOn THEN
                            RobotStatus.Error.Id := UINT#650;//<#Waiting for CycleOn!
                        END_IF;
                        IF NOT Inputs.MotorOnState THEN
                            RobotStatus.Error.Id := UINT#651;//<#Waiting for MotorOnState!
                        END_IF;
                        IF Inputs.MotorOnState THEN
                            RobotStatus.Error.Id := UINT#652;//<#Waiting for Error!
                        END_IF;
                    END_IF;

                    IF Inputs.CycleOn AND Inputs.MotorOnState AND NOT Inputs.Error THEN
                        THIS.CallTimers(FALSE);
                        _progress := 351;
                    END_IF;
                END_IF;
                
                IF _progress = 351 THEN

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
                            RobotStatus.Error.Id := UINT#654;//<#Waiting for Inputs.ActionNo to be equal to Outputs.ActionNo!
                        END_IF;
                    END_IF;

                    IF Outputs.ActionNo = Inputs.ActionNo THEN
                        THIS.CallTimers(FALSE);
                        _progress := 352;
                    END_IF;
                END_IF;
                
                IF _progress = 352 THEN
                    IF _infoTimer.output THEN
                        IF Inputs.GlobalSpeed <> RobotStatus.CurrentMovementParameters.GlobalSpeed THEN
                            RobotStatus.Error.Id := UINT#655;//<#Waiting for Inputs.GlobalSpeed to be equal to MovementParameters.GlobalSpeed!
                        END_IF;
                        IF Inputs.ToolNo <> RobotStatus.CurrentMovementParameters.ToolNo THEN
                            RobotStatus.Error.Id := UINT#656;//<#Waiting for Inputs.ToolNo to be equal to MovementParameters.ToolNo!
                        END_IF;
                        IF Inputs.WorkobjectNo <> RobotStatus.CurrentMovementParameters.WorkobjectNo THEN
                            RobotStatus.Error.Id := UINT#657;//<#Waiting for Inputs.WorkobjectNo to be equal to MovementParameters.WorkobjectNo!
                        END_IF;
                        IF Inputs.PointNo <> RobotStatus.CurrentMovementParameters.PointNo THEN
                            RobotStatus.Error.Id := UINT#658;//<#Waiting for Inputs.PointNo to be equal to MovementParameters.PointNo!
                        END_IF;
                        IF Inputs.UserSpecSpeed1 <> RobotStatus.CurrentMovementParameters.UserSpecSpeed1 THEN
                            RobotStatus.Error.Id := UINT#659;//<#Waiting for Inputs.UserSpecSpeed1 to be equal to MovementParameters.UserSpecSpeed1!
                        END_IF;
                        IF Inputs.UserSpecSpeed2 <> RobotStatus.CurrentMovementParameters.UserSpecSpeed2 THEN
                            RobotStatus.Error.Id := UINT#660;//<#Waiting for Inputs.UserSpecSpeed2 to be equal to MovementParameters.UserSpecSpeed2!
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
                        _progress:=353;
                    END_IF;
                END_IF;		

                IF _progress = 353 THEN
                    IF _infoTimer.output THEN
                        IF Outputs.ActionNo <> Inputs.ActionNo THEN
                            RobotStatus.Error.Id := UINT#661;//<#Waiting for Inputs.ActionNo to be equal to Outputs.ActionNo!
                        END_IF;
                    END_IF;

                    IF Outputs.ActionNo = Inputs.ActionNo THEN
                        THIS.CallTimers(FALSE);
                        _progress:=354;
                    END_IF;
                END_IF;	
                
                IF _progress = 354 THEN
                    Outputs.ActionNo := RobotStatus.CurrentMovementParameters.ActionNo;

                    IF _infoTimer.output THEN
                        IF Outputs.ActionNo <> Inputs.ActionNo THEN
                            RobotStatus.Error.Id := UINT#662;//<#Waiting for Inputs.ActionNo to be equal to Outputs.ActionNo!
                        END_IF;
                    END_IF;
	
                    IF Outputs.ActionNo = Inputs.ActionNo THEN
                        THIS.CallTimers(FALSE);
                        Outputs.ActionNo := BYTE#255;
                        _progress:=355;
                    END_IF;
                END_IF;	

                IF _progress = 355 THEN
                    Outputs.ActionNo := BYTE#255;

                    IF _infoTimer.output THEN
                        IF Outputs.ActionNo <> Inputs.ActionNo THEN
                            RobotStatus.Error.Id := UINT#663;//<#Waiting for Inputs.ActionNo to be equal to Outputs.ActionNo!
                        END_IF;
                    END_IF;
	
                    IF Outputs.ActionNo = Inputs.ActionNo THEN
                        _progress := 0;
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
                RobotStatus.Action.Id :=  UINT#356;
                RobotStatus.Error.Id :=  UINT#0;
            ELSIF StopMovementsTask.ErrorOccured() THEN
                RobotStatus.Action.Id :=  UINT#707;
                RobotStatus.Error.Id  :=  UINT#707;
            END_IF;
            //*******************************************

            //***********StartProgramTask*******
            StartProgramTask.IsDisabled := _stopTasksAreActive;
            IF StartProgramTask.Execute() THEN
                _blink.Blink(Context := _context, inOnTime:=T#500MS,inOffTime:=T#500MS);

                IF _progress = 0 THEN
                    THIS.CallTimers(FALSE);
                    _progress := 370;
                END_IF;
              
                IF _progress = 370 THEN //Switching to auto
                    Outputs.StartProgram:=_blink.output;

                    IF _infoTimer.output THEN
                        IF NOT Inputs.CycleOn THEN
                            RobotStatus.Error.Id := UINT#670; 
                        END_IF;
                        IF Inputs.SystemInputBusy THEN
                            RobotStatus.Error.Id := UINT#671; 
                        END_IF;
                    END_IF;
                    
                    IF  Inputs.CycleOn AND NOT Inputs.SystemInputBusy THEN
                        Outputs.StartProgram:=FALSE;
                        THIS.CallTimers(FALSE);
                        _progress := 371;
                    END_IF;
                END_IF;

                IF _progress = 371 THEN	
                    StartProgramTask.DoneWhen(TRUE);
                    THIS.CallTimers(FALSE);
                    _progress := 0;
                END_IF;	              

                THIS.CallTimers(TRUE);
                StartProgramTask.ThrowWhen(_errorTimer.output);
                RobotStatus.Action.Id := TO_UINT(_progress);
            END_IF;
            IF StartProgramTask.DoneReached() THEN
                RobotStatus.Action.Id :=  UINT#372;
                RobotStatus.Error.Id :=  UINT#0;
            ELSIF StartProgramTask.ErrorOccured() THEN
                RobotStatus.Action.Id :=  UINT#708;
                RobotStatus.Error.Id  :=  UINT#708;
            END_IF;
            //*******************************************

            //***********StopMotorsTask***************
            StopMotorsTask.IsDisabled := FALSE;
            IF StopMotorsTask.Execute() THEN
                _blink.Blink(Context := _context, inOnTime:=T#500MS,inOffTime:=T#500MS);

                IF _progress = 0 THEN
                    THIS.CallTimers(FALSE);
                    _progress := 380;
                END_IF;
              
                IF _progress = 380 THEN 
                    Outputs.MotorOff := TRUE;

                    IF _infoTimer.output THEN
                        IF NOT Inputs.MotorOffState THEN
                            RobotStatus.Error.Id := UINT#680; 
                        END_IF;
                        IF Inputs.SystemInputBusy THEN
                            RobotStatus.Error.Id := UINT#681; 
                        END_IF;
                    END_IF;
                    
                    IF  Inputs.MotorOffState AND NOT Inputs.SystemInputBusy THEN
                        Outputs.MotorOff:=FALSE;
                        THIS.CallTimers(FALSE);
                        _progress := 381;
                    END_IF;
                END_IF;

                IF _progress = 381 THEN	
                    StopMotorsTask.DoneWhen(TRUE);
                    THIS.CallTimers(FALSE);
                    _progress := 0;
                END_IF;	              

                THIS.CallTimers(TRUE);
                StopMotorsTask.ThrowWhen(_errorTimer.output);
                RobotStatus.Action.Id := TO_UINT(_progress);
            END_IF;
            IF StopMotorsTask.DoneReached() THEN
                RobotStatus.Action.Id :=  UINT#382;
                RobotStatus.Error.Id :=  UINT#0;
            ELSIF StopMotorsTask.ErrorOccured() THEN
                RobotStatus.Action.Id :=  UINT#709;
                RobotStatus.Error.Id  :=  UINT#709;
            END_IF;
            //*******************************************

            //***********StopMovementsAndProgramTask*****
            StopMovementsAndProgramTask.IsDisabled := FALSE;
            IF StopMovementsAndProgramTask.Execute() THEN
                IF _progress = 0 THEN
                    THIS.CallTimers(FALSE);
                    _progress := 390;
                END_IF;
                
                IF _progress = 390 THEN
                    Outputs.SoftStop := TRUE;
                    Outputs.QuickStop := FALSE;
                
                    IF _stopType = eAxoRoboticsStopType#Quick THEN
                        Outputs.SoftStop := FALSE;
                        Outputs.QuickStop := TRUE;
                    END_IF;
                
                    IF _infoTimer.output THEN
                        IF NOT Inputs.MoveInactive THEN
                            RobotStatus.Error.Id := UINT#690;//<#Waiting for MoveInactive!
                        END_IF;
                    END_IF;

                    IF Inputs.MoveInactive THEN
                        THIS.CallTimers(FALSE);
                        _progress := 391;
                    END_IF;
                END_IF;
                
                IF _progress = 391 THEN
                    Outputs.StopProgram:=TRUE;

                    IF _infoTimer.output THEN
                        IF Inputs.CycleOn THEN
                            RobotStatus.Error.Id := UINT#691;//<#Waiting for CycleOn!
                        END_IF;
                    END_IF;

                    IF NOT Inputs.CycleOn THEN
                        THIS.CallTimers(FALSE);
                        _progress := 392;
                    END_IF;
                END_IF;
                
                IF _progress = 392 THEN
                    Outputs.SoftStop := FALSE;
                    Outputs.QuickStop := FALSE;
                    Outputs.StopProgram:=FALSE;
                    StopMovementsAndProgramTask.DoneWhen(TRUE);
                    _progress := 0;
                END_IF;		

                THIS.CallTimers(TRUE);
                
                StopMovementsAndProgramTask.ThrowWhen(_errorTimer.output);

                RobotStatus.Action.Id := TO_UINT(_progress);
            END_IF;
            IF StopMovementsAndProgramTask.DoneReached() THEN
                RobotStatus.Action.Id :=  UINT#393;
                RobotStatus.Error.Id :=  UINT#0;
            ELSIF StopMovementsAndProgramTask.ErrorOccured() THEN
                RobotStatus.Action.Id :=  UINT#710;
                RobotStatus.Error.Id  :=  UINT#710;
            END_IF;
            //*******************************************
            
            //***********StopMovementsTask***************
            StopMovementsTask.IsDisabled := FALSE;
            IF StopMovementsTask.Execute() THEN
                IF _progress = 0 THEN
                    THIS.CallTimers(FALSE);
                    _progress := 400;
                END_IF;
                
                IF _progress = 400 THEN
                    Outputs.SoftStop := TRUE;
                    Outputs.QuickStop := FALSE;
                
                    IF _stopType = eAxoRoboticsStopType#Quick THEN
                        Outputs.SoftStop := FALSE;
                        Outputs.QuickStop := TRUE;
                    END_IF;
                
                    IF _infoTimer.output THEN
                        IF NOT Inputs.MoveInactive THEN
                            RobotStatus.Error.Id := UINT#692;//<#Waiting for MoveInactive!
                        END_IF;
                    END_IF;

                    IF Inputs.MoveInactive THEN
                        THIS.CallTimers(FALSE);
                        _progress := 401;
                    END_IF;
                END_IF;
                
                IF _progress = 401 THEN
                    Outputs.SoftStop := FALSE;
                    Outputs.QuickStop := FALSE;
                    _progress := 0;
                    StopMovementsTask.DoneWhen(TRUE);
                END_IF;		


                THIS.CallTimers(TRUE);
                
                StopMovementsTask.ThrowWhen(_errorTimer.output);

                RobotStatus.Action.Id := TO_UINT(_progress);
            END_IF;
            IF StopMovementsTask.DoneReached() THEN
                RobotStatus.Action.Id :=  UINT#402;
                RobotStatus.Error.Id :=  UINT#0;
            ELSIF StopMovementsTask.ErrorOccured() THEN
                RobotStatus.Action.Id :=  UINT#711;
                RobotStatus.Error.Id  :=  UINT#711;
            END_IF;
            //*******************************************

            //***********StopProgramTask*****************
            StopProgramTask.IsDisabled := FALSE;
            IF StopProgramTask.Execute() THEN
                IF _progress = 0 THEN
                    THIS.CallTimers(FALSE);
                    _progress := 410;
                END_IF;
                
                IF _progress = 410 THEN
                    Outputs.StopProgram:=TRUE;

                    IF _infoTimer.output THEN
                        IF Inputs.CycleOn THEN
                            RobotStatus.Error.Id := UINT#693;//<#Waiting for CycleOn!
                        END_IF;
                    END_IF;

                    IF NOT Inputs.CycleOn THEN
                        THIS.CallTimers(FALSE);
                        _progress := 411;
                    END_IF;
                END_IF;
                
                IF _progress = 411 THEN
                    Outputs.StopProgram:=FALSE;
                    StopProgramTask.DoneWhen(TRUE);
                    _progress := 0;
                END_IF;		

                THIS.CallTimers(TRUE);
                
                StopProgramTask.ThrowWhen(_errorTimer.output);

                RobotStatus.Action.Id := TO_UINT(_progress);
            END_IF;
            IF StopProgramTask.DoneReached() THEN
                RobotStatus.Action.Id :=  UINT#412;
                RobotStatus.Error.Id :=  UINT#0;
            ELSIF StopProgramTask.ErrorOccured() THEN
                RobotStatus.Action.Id :=  UINT#712;
                RobotStatus.Error.Id  :=  UINT#712;
            END_IF;
            //*******************************************
            
            _someTaskIsActive := StartAtMainTask.IsBusy()
                                OR StartMotorsAndProgramTask.IsBusy()
                                OR StartMovementsTask.IsBusy()
                                OR StartMovementsTask.IsBusy()
                                OR StopMovementsTask.IsBusy()
                                OR StopMovementsAndProgramTask.IsBusy()
                                OR StopProgramTask.IsBusy();
            
            Messenger.ActivateOnCondition(ULINT#713,_someTaskIsActive AND Inputs.EmgStop, eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#714,_someTaskIsActive AND NOT Inputs.SafetyOk, eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#715,_someTaskIsActive AND Inputs.ProgExecError, eAxoMessageCategory#Error);

            IF _someTaskIsActive THEN
                IF(Inputs.EmgStop) THEN
                    RobotStatus.Error.Id := UINT#713;
                END_IF;
                IF(NOT Inputs.SafetyOk) THEN
                    RobotStatus.Error.Id := UINT#714;
                END_IF;
                IF(Inputs.ProgExecError) THEN
                    RobotStatus.Error.Id := UINT#715;
                END_IF;
            END_IF;
            //***********UPDATE**OUTPUTS*****************
            //SYSTEM OUTPUTS
            refOutputs^     [0].%X0	        := Outputs.Interupt;     
            refOutputs^     [0].%X1	        := Outputs.LoadProg;    
            refOutputs^     [0].%X2         := Outputs.LoadAndStartProg; 
            refOutputs^     [0].%X3         := Outputs.MotorOff;
            refOutputs^     [0].%X4         := Outputs.MotorOn;   
            refOutputs^     [0].%X5         := Outputs.MotorOnAndStart; 
            refOutputs^     [0].%X6         := Outputs.ResetEmgStop;    
            refOutputs^     [0].%X7         := Outputs.ResetError; 

            refOutputs^     [1].%X0	        := Outputs.StartProgram;    
            refOutputs^     [1].%X1	        := Outputs.StartAtMain;    
            refOutputs^     [1].%X2         := Outputs.StopProgram;     
            refOutputs^     [1].%X3         := Outputs.QuickStop;    
            refOutputs^     [1].%X4         := Outputs.SoftStop;    
            refOutputs^     [1].%X5         := Outputs.StopCycle;    
            refOutputs^     [1].%X6         := Outputs.StopInstruction;    
            refOutputs^     [1].%X7         := Outputs.LimitSpeed;    
                
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
            refOutputs^     [17]            := _dword.%B2;
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
            StopMovementsTask.Restore();
            StopMovementsAndProgramTask.Restore();
            StopProgramTask.Restore();
            StopMotorsTask.Restore();
            StartAtMainTask.Restore();      
            StartMotorsAndProgramTask.Restore();
            StartProgramTask.Restore();         
            StartMotorsTask.Restore();         
            StartMovementsTask.Restore();
            StartMotorsProgramAndMovementsTask.Restore();
            RestoreTask.DoneWhen(TRUE);
        END_METHOD        
    
        METHOD PUBLIC StartAtMain : IAxoTaskState
            StartAtMain := StartAtMainTask.Invoke();
        END_METHOD
    
        METHOD PUBLIC StartMotorsAndProgram : IAxoTaskState
            StartMotorsAndProgram := StartMotorsAndProgramTask.Invoke();
        END_METHOD
    
        METHOD PUBLIC StartMotorsProgramAndMovements : IAxoTaskState
            VAR_IN_OUT
                inData : AxoRoboticsMovementsParams;
            END_VAR
            RobotStatus.CurrentMovementParameters := inData;

            StartMotorsProgramAndMovements := StartMotorsProgramAndMovementsTask.Invoke();
        END_METHOD
    
        METHOD PUBLIC StartMotors : IAxoTaskState
            StartMotors := StartMotorsTask.Invoke();
        END_METHOD
    
        METHOD PUBLIC StartMovements : IAxoTaskState
            VAR_IN_OUT
                inData : AxoRoboticsMovementsParams;
            END_VAR
            RobotStatus.CurrentMovementParameters := inData;

            StartMovements := StartMovementsTask.Invoke();
        END_METHOD
    
        METHOD PUBLIC StartProgram : IAxoTaskState
            StartProgram := StartProgramTask.Invoke();
        END_METHOD
            
        METHOD PUBLIC StopMotors : IAxoTaskState
            StopMotors := StopMotorsTask.Invoke();           
        END_METHOD

        METHOD PUBLIC StopMovementsAndProgram : IAxoTaskState
            VAR_INPUT
                inStopType : eAxoRoboticsStopType;
            END_VAR
            _stopType := inStopType;
            StopMovementsAndProgram := StopMovementsAndProgramTask.Invoke();
        END_METHOD
        
        METHOD PUBLIC StopMovements : IAxoTaskState
            VAR_INPUT
                inStopType : eAxoRoboticsStopType;
            END_VAR
            _stopType := inStopType;
            StopMovements := StopMovementsTask.Invoke();           
        END_METHOD
    
        METHOD PUBLIC StopProgram : IAxoTaskState
            StopProgram := StopProgramTask.Invoke();           
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
