USING AXOpen.Core;
USING AXOpen.Messaging;
USING AXOpen.Messaging.Static;
USING AXOpen.Components.Robotics;
USING AXOpen.Components.Abstractions.Robotics;

NAMESPACE AXOpen.Components.Kuka.Robotics
    {S7.extern=ReadWrite}
    CLASS AxoKrc4_v_5_x_x EXTENDS AXOpen.Core.AxoComponent IMPLEMENTS AXOpen.Components.Abstractions.Robotics.IAxoRobotics
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
            _hwID                   :   WORD;
            _hwId_512_DI_DO         :   WORD;
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
            Config  :   AxoKukaRobotics_Config_v_5_x_x;
        END_VAR

        VAR PUBLIC //STATUS
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("Status")]}
            {#ix-attr:[ReadOnly()]}
            RobotStatus         :   AxoKukaRobotics_Component_Status_v_5_x_x;
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
            Inputs              :   AxoKukaRobotics_State_v_5_x_x;
            {#ix-attr:[ComponentDetails("Hardware signals")]}
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Outputs#>"}
            {#ix-attr:[ReadOnly()]}
            Outputs              :   AxoKukaRobotics_Control_v_5_x_x;
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
                hwID            :   WORD;   
                hwId_512_DI_DO  :   WORD;   //  Hardware Id of the input data of the robot
            END_VAR

            Messenger.Serve(THIS);

            Messenger.ActivateOnCondition(ULINT#700,parent = NULL, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#701,hwId_512_DI_DO = WORD#0, eAxoMessageCategory#ProgrammingError);

            IF parent = NULL THEN
                RobotStatus.Error.Id := UINT#700;
                RETURN;
            ELSIF hwId_512_DI_DO = WORD#0 THEN
                RobotStatus.Error.Id := UINT#701;
                RETURN;
            END_IF;

            _hwID            :=  hwID           ;
            _hwId_512_DI_DO  :=  hwId_512_DI_DO;

            THIS.Initialize(parent);
            THIS.Execute();
        END_METHOD

        ///<summary>
        /// Runs tasks and logic of this component.
        /// >[!IMPORTANT] This method must or one of its overloads be called cyclically.
        ///</summary>
        METHOD PUBLIC Run 
            VAR_INPUT
                parent          :   IAxoContext;
                hwID            :   WORD;   
                hwId_512_DI_DO  :   WORD;   //  Hardware Id of the input data of the robot
            END_VAR

            Messenger.Serve(THIS);

            Messenger.ActivateOnCondition(ULINT#700,parent = NULL, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#701,hwId_512_DI_DO = WORD#0, eAxoMessageCategory#ProgrammingError);

            IF parent = NULL THEN
                RobotStatus.Error.Id := UINT#700;
                RETURN;
            ELSIF hwId_512_DI_DO = WORD#0 THEN
                RobotStatus.Error.Id := UINT#701;
                RETURN;
            END_IF;

            _hwID            :=  hwID           ;
            _hwId_512_DI_DO  :=  hwId_512_DI_DO;

            THIS.Initialize(parent);
            THIS.Execute();
        END_METHOD

        METHOD PRIVATE Execute 
            VAR 
                _dword: DWORD;
                _data : ARRAY[0..63] OF BYTE; 
                returnValue : WORD;
            END_VAR

            THIS.Open();

            //***********UPDATE**INPUTS******************
            returnValue := Siemens.Simatic.S71500.DistributedIO.ReadData(_hwId_512_DI_DO ,_data);
            Messenger.ActivateOnCondition(ULINT#703,returnValue > WORD#0, eAxoMessageCategory#ProgrammingError);
            IF returnValue > WORD#0 THEN
                RobotStatus.Error.Id := UINT#703;
                RETURN;
            END_IF;

            //SYSTEM INPUTS
            Inputs.RcReady                  := _data[0].%X0;
            Inputs.AlarmStopActive          := _data[0].%X1;
            Inputs.UserSafetySwitchClosed   := _data[0].%X2;
            Inputs.DrivesReady              := _data[0].%X3;
            Inputs.RobotCalibrated          := _data[0].%X4;
            Inputs.InterfaceActivated       := _data[0].%X5;
            Inputs.StopMess                 := _data[0].%X6;
            Inputs.RobotStopped             := _data[0].%X7;

            Inputs.InHome                   := _data[1].%X0;
            Inputs.Manual                   := _data[1].%X1;
            Inputs.Automatic                := _data[1].%X2;
            Inputs.ExternalAutomatic        := _data[1].%X3;
            Inputs.ProActive                := _data[1].%X4;
            Inputs.PpMoved                  := _data[1].%X5;
            Inputs.Error                    := _data[1].%X6;
            Inputs.ProgramMoveActive        := _data[1].%X7;


            //Area/positions flags this  should be obsolete because Zones and InPosition is used as byte below
            Inputs.InArea_1                 := _data[2].%X0;
            Inputs.InArea_2                 := _data[2].%X1;
            Inputs.InArea_3                 := _data[2].%X2;
            Inputs.InArea_4                 := _data[2].%X3;
            Inputs.InPosition_1             := _data[2].%X4;
            Inputs.InPosition_2             := _data[2].%X5;
            Inputs.InPosition_3             := _data[2].%X6;
            Inputs.InPosition_4             := _data[2].%X7;

            //Tool signals
            Inputs.Tool_1_Retract           := _data[3].%X0;
            Inputs.Tool_1_Extend            := _data[3].%X1;
            Inputs.Tool_2_Retract           := _data[3].%X2;
            Inputs.Tool_2_Extend            := _data[3].%X3;
            Inputs.Tool_3_Retract           := _data[3].%X4;
            Inputs.Tool_3_Extend            := _data[3].%X5;
            Inputs.Tool_4_Retract           := _data[3].%X6;
            Inputs.Tool_4_Extend            := _data[3].%X7;

            Inputs.Zone                     := _data[5];
            Inputs.InPosition               := _data[6];

            //Movement parameters
            Inputs.ActionNo                 := _data[7];
            Inputs.GlobalSpeed              := _data[8];
            Inputs.ToolNo                   := _data[9];
            Inputs.WorkobjectNo             := _data[10];
            Inputs.PointNo                  := _data[11];

            _dword.%B3                      := _data[12];
            _dword.%B2                      := _data[13];
            _dword.%B1                      := _data[14];
            _dword.%B0                      := _data[15];
            Inputs.UserSpecSpeed1           := TO_DINT(_dword);

            _dword.%B3                      := _data[16];
            _dword.%B2                      := _data[17];
            _dword.%B1                      := _data[18];
            _dword.%B0                      := _data[19];
            Inputs.UserSpecSpeed2           := TO_DINT(_dword);

            _dword.%B3                      := _data[20];
            _dword.%B2                      := _data[21];
            _dword.%B1                      := _data[22];
            _dword.%B0                      := _data[23];
            // Inputs.Coordinates.X:= TO_REAL(_dword)/REAL#10000.0-REAL#10000.0;
            Inputs.Coordinates.X:= TO_REAL(_dword)*REAL#0.0001; //Todo check negative values

            _dword.%B3                      := _data[24];
            _dword.%B2                      := _data[25];
            _dword.%B1                      := _data[26];
            _dword.%B0                      := _data[27];
            // Inputs.Coordinates.Y:= TO_REAL(_dword)/REAL#10000.0-REAL#10000.0;
            Inputs.Coordinates.Y:= TO_REAL(_dword)*REAL#0.0001; //Todo check negative values

            _dword.%B3                      := _data[28];
            _dword.%B2                      := _data[29];
            _dword.%B1                      := _data[30];
            _dword.%B0                      := _data[31];
            // Inputs.Coordinates.Z:= TO_REAL(_dword)/REAL#10000.0-REAL#10000.0;
            Inputs.Coordinates.Z:= TO_REAL(_dword)*REAL#0.0001; //Todo check negative values

            _dword.%B3                      := _data[32];
            _dword.%B2                      := _data[33];
            _dword.%B1                      := _data[34];
            _dword.%B0                      := _data[35];
            // Inputs.Coordinates.Rx:= TO_REAL(_dword)/REAL#10000.0-REAL#360.0;
            Inputs.Coordinates.Rx:= TO_REAL(_dword)*REAL#0.0001; //Todo check negative values

            _dword.%B3                      := _data[36];
            _dword.%B2                      := _data[37];
            _dword.%B1                      := _data[39];
            _dword.%B0                      := _data[39];
            // Inputs.Coordinates.Ry:= TO_REAL(_dword)/REAL#10000.0-REAL#360.0;
            Inputs.Coordinates.Ry:= TO_REAL(_dword)*REAL#0.0001; //Todo check negative values

            _dword.%B3                      := _data[40];
            _dword.%B2                      := _data[41];
            _dword.%B1                      := _data[42];
            _dword.%B0                      := _data[43];
            // Inputs.Coordinates.Rz:= TO_REAL(_dword)/REAL#10000.0-REAL#360.0;
            Inputs.Coordinates.Rz:= TO_REAL(_dword)*REAL#0.0001; //Todo check negative values

            _dword.%B3                      := _data[44];
            _dword.%B2                      := _data[45];
            _dword.%B1                      := _data[46];
            _dword.%B0                      := _data[47];
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
            HardwareDiagnosticsTask.Run(_hwID);
            //****************************************

            //*************RESTORE********************
            RestoreTask.IsDisabled := FALSE;
            IF RestoreTask.Execute() THEN
                THIS.Restore();
            END_IF;
            //****************************************
(*
            //*************StartAtMainTask***************
            StartAtMainTask.IsDisabled := _stopTasksAreActive;
            IF StartAtMainTask.StartTriggered() THEN
                RobotStatus.Action.Id :=  UINT#100;
            END_IF;
            Messenger.ActivateOnCondition(ULINT#100,StartAtMainTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#101,StartAtMainTask.IsDone(), eAxoMessageCategory#Info);
            IF StartAtMainTask.Execute() THEN
                _blink.Blink(Context := _context, inOnTime:=T#500MS,inOffTime:=T#500MS);
                IF _progress = 0 THEN
                    RobotStatus.Error.Id :=  UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 300;
                END_IF;
                
                IF _progress = 300 THEN  
                    TaskMessenger.ActivateOnCondition(ULINT#600, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        RobotStatus.Error.Id := UINT#600;
                    END_IF;

                    Outputs.StartAtMain := _blink.output;
                            
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
                RobotStatus.Action.Id :=  UINT#101;
                RobotStatus.Error.Id :=  UINT#0;
            ELSIF StartAtMainTask.ErrorOccured() THEN
                RobotStatus.Action.Id :=  UINT#800;
                RobotStatus.Error.Id  :=  UINT#800;
            ELSIF StartAtMainTask.AbortTriggered()THEN
                RobotStatus.Action.Id :=  UINT#801;
                RobotStatus.Error.Id  :=  UINT#801;
            END_IF;     
            Messenger.ActivateOnCondition(ULINT#800,StartAtMainTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#801,StartAtMainTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#102,StartAtMainTask.RestoreTriggered() , eAxoMessageCategory#Error);
            IF StartAtMainTask.RestoreTriggered() AND _progress >= 300 AND _progress <= 309  THEN
                RobotStatus.Action.Id :=  UINT#102;
                _progress := 0;
            END_IF;
            //*******************************************

            //***********StartMotorsAndProgramTask*******
            StartMotorsAndProgramTask.IsDisabled := _stopTasksAreActive OR StartProgramTask.IsBusy() OR StartMotorsTask.IsBusy();
            IF StartMotorsAndProgramTask.StartTriggered() THEN
                RobotStatus.Action.Id :=  UINT#110;
            END_IF;
            Messenger.ActivateOnCondition(ULINT#110,StartMotorsAndProgramTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#111,StartMotorsAndProgramTask.IsDone(), eAxoMessageCategory#Info);
            IF StartMotorsAndProgramTask.Execute() THEN
                _blink.Blink(Context := _context, inOnTime:=T#500MS,inOffTime:=T#500MS);

                IF _progress = 0 THEN
                    RobotStatus.Error.Id :=  UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 310;
                END_IF;

                IF _progress = 310 THEN //Switching to auto
                    TaskMessenger.ActivateOnCondition(ULINT#610, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        RobotStatus.Error.Id := UINT#610;
                    END_IF;

                    IF Inputs.AutoOn THEN
                        THIS.CallTimers(FALSE);
                        _progress := 311;
                    END_IF;
                END_IF;

                IF _progress = 311 THEN	//Reseting error
                    TaskMessenger.ActivateOnCondition(ULINT#611, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        RobotStatus.Error.Id := UINT#611;
                    END_IF;

                    Outputs.ResetError := Inputs.Error AND _blink.output;

                    IF NOT Inputs.Error THEN
                        Outputs.ResetError:=FALSE;
                        THIS.CallTimers(FALSE);
                        _progress := 312;
                    END_IF;
                END_IF;
              
                IF _progress = 312 THEN	//Reseting emergency stop error
                    TaskMessenger.ActivateOnCondition(ULINT#612, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        RobotStatus.Error.Id := UINT#612;
                    END_IF;

                    Outputs.ResetEmgStop := Inputs.EmgStop AND _blink.output;

                    IF NOT Inputs.EmgStop THEN
                        Outputs.ResetEmgStop:=FALSE;
                        THIS.CallTimers(FALSE);
                        _progress := 313;
                    END_IF;
                END_IF;
              
                IF _progress = 313 THEN	
                    TaskMessenger.ActivateOnCondition(ULINT#613, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        RobotStatus.Error.Id := UINT#613;
                    END_IF;

                    Outputs.MotorOnAndStart:=_blink.output;	

                    IF Inputs.Error THEN 
                        THIS.CallTimers(FALSE);
                        _progress := 310;
                    END_IF;

                    IF Inputs.MotorOnState THEN
                         THIS.CallTimers(FALSE);
                         _progress := 314;
                    END_IF;
                END_IF;		
              
                IF _progress = 314 THEN	
                    TaskMessenger.ActivateOnCondition(ULINT#614, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        RobotStatus.Error.Id := UINT#614;
                    END_IF;

                    Outputs.MotorOnAndStart:=_blink.output;	

                    IF Inputs.Error THEN 
                        THIS.CallTimers(FALSE);
                        _progress := 310;
                    END_IF;

                    IF Inputs.CycleOn THEN
                         THIS.CallTimers(FALSE);
                         _progress := 315;
                    END_IF;
                END_IF;	

                IF _progress = 315 THEN	
                    TaskMessenger.ActivateOnCondition(ULINT#615, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        RobotStatus.Error.Id := UINT#615;
                    END_IF;

                    Outputs.MotorOnAndStart:=_blink.output;	

                    IF NOT Inputs.Error THEN 
                        THIS.CallTimers(FALSE);
                        _progress := 310;
                    END_IF;

                    IF NOT Inputs.Error THEN
                         THIS.CallTimers(FALSE);
                         Outputs.MotorOnAndStart := FALSE;
                         _progress := 316;
                    END_IF;
                END_IF;	

                IF _progress = 316 THEN	
                    StartMotorsAndProgramTask.DoneWhen(TRUE);
                    THIS.CallTimers(FALSE);
                    _progress := 0;
                END_IF;	              

                THIS.CallTimers(TRUE);
                StartMotorsAndProgramTask.ThrowWhen(_errorTimer.output);
                RobotStatus.Action.Id := TO_UINT(_progress);
            END_IF;
            IF StartMotorsAndProgramTask.DoneReached() THEN
                RobotStatus.Action.Id :=  UINT#111;
                RobotStatus.Error.Id :=  UINT#0;
            ELSIF StartMotorsAndProgramTask.ErrorOccured() THEN
                RobotStatus.Action.Id :=  UINT#810;
                RobotStatus.Error.Id  :=  UINT#810;
            ELSIF StartMotorsAndProgramTask.AbortTriggered() THEN
                RobotStatus.Action.Id :=  UINT#811;
                RobotStatus.Error.Id  :=  UINT#811;
            END_IF;         
            Messenger.ActivateOnCondition(ULINT#810,StartMotorsAndProgramTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#811,StartMotorsAndProgramTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#112,StartMotorsAndProgramTask.RestoreTriggered() , eAxoMessageCategory#Error);
            IF StartMotorsAndProgramTask.RestoreTriggered() AND _progress >= 310 AND _progress <= 319  THEN
                RobotStatus.Action.Id :=  UINT#112;
                _progress := 0;
            END_IF;   
            //*******************************************
                        
            //***********StartMotorsProgramAndMovementsTask*******
            StartMotorsProgramAndMovementsTask.IsDisabled := _stopTasksAreActive OR StartProgramTask.IsBusy() OR StartMotorsTask.IsBusy() OR StartMovementsTask.IsBusy();
            IF StartMotorsProgramAndMovementsTask.StartTriggered() THEN
                RobotStatus.Action.Id :=  UINT#120;
            END_IF;
            Messenger.ActivateOnCondition(ULINT#120,StartMotorsProgramAndMovementsTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#121,StartMotorsProgramAndMovementsTask.IsDone(), eAxoMessageCategory#Info);
            IF StartMotorsProgramAndMovementsTask.Execute() THEN
                _blink.Blink(Context := _context, inOnTime:=T#500MS,inOffTime:=T#500MS);

                IF _progress = 0 THEN
                    RobotStatus.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 320;
                END_IF;

                IF _progress = 320 THEN //Switching to auto
                    TaskMessenger.ActivateOnCondition(ULINT#620, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        RobotStatus.Error.Id := UINT#620;
                    END_IF;


                    IF Inputs.AutoOn THEN
                        THIS.CallTimers(FALSE);
                        _progress := 321;
                    END_IF;
                END_IF;

                IF _progress = 321 THEN	//Reseting error
                    TaskMessenger.ActivateOnCondition(ULINT#621, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        RobotStatus.Error.Id := UINT#621;
                    END_IF;

                    Outputs.ResetError := Inputs.Error AND _blink.output;

                    IF NOT Inputs.Error THEN
                        Outputs.ResetError:=FALSE;
                        THIS.CallTimers(FALSE);
                        _progress := 322;
                    END_IF;
                END_IF;
              
                IF _progress = 322 THEN	//Reseting emergency stop error
                    TaskMessenger.ActivateOnCondition(ULINT#622, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        RobotStatus.Error.Id := UINT#622;
                    END_IF;

                    Outputs.ResetEmgStop := Inputs.EmgStop AND _blink.output;

                    IF NOT Inputs.EmgStop THEN
                        Outputs.ResetEmgStop:=FALSE;
                        THIS.CallTimers(FALSE);
                        _progress := 323;
                    END_IF;
                END_IF;
              
                IF _progress = 323 THEN	
                    TaskMessenger.ActivateOnCondition(ULINT#623, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        RobotStatus.Error.Id := UINT#623;
                    END_IF;

                    Outputs.MotorOnAndStart:=_blink.output;	

                    IF Inputs.Error THEN 
                        THIS.CallTimers(FALSE);
                        _progress := 320;
                    END_IF;

                    IF Inputs.MotorOnState THEN
                         THIS.CallTimers(FALSE);
                         _progress := 324;
                    END_IF;
                END_IF;		
              
                IF _progress = 324 THEN	
                    TaskMessenger.ActivateOnCondition(ULINT#624, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        RobotStatus.Error.Id := UINT#624;
                    END_IF;

                    Outputs.MotorOnAndStart:=_blink.output;	

                    IF Inputs.Error THEN 
                        THIS.CallTimers(FALSE);
                        _progress := 320;
                    END_IF;

                    IF Inputs.CycleOn THEN
                         THIS.CallTimers(FALSE);
                         _progress := 325;
                    END_IF;
                END_IF;	

                IF _progress = 325 THEN	
                    TaskMessenger.ActivateOnCondition(ULINT#625, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        RobotStatus.Error.Id := UINT#625;
                    END_IF;

                    Outputs.MotorOnAndStart:=_blink.output;	

                    IF NOT Inputs.Error THEN 
                        THIS.CallTimers(FALSE);
                        _progress := 320;
                    END_IF;

                    IF NOT Inputs.Error THEN
                         THIS.CallTimers(FALSE);
                         Outputs.MotorOnAndStart := FALSE;
                         _progress := 326;
                    END_IF;
                END_IF;	
	
                IF _progress = 326 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#626, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        RobotStatus.Error.Id := UINT#626;
                    END_IF;

                    Outputs.GlobalSpeed     := RobotStatus.CurrentMovementParameters.GlobalSpeed;
                    Outputs.ToolNo          := RobotStatus.CurrentMovementParameters.ToolNo;
                    Outputs.WorkobjectNo    := RobotStatus.CurrentMovementParameters.WorkobjectNo;
                    Outputs.PointNo         := RobotStatus.CurrentMovementParameters.PointNo;
                    Outputs.UserSpecSpeed1  := RobotStatus.CurrentMovementParameters.UserSpecSpeed1;
                    Outputs.UserSpecSpeed2  := RobotStatus.CurrentMovementParameters.UserSpecSpeed2;
                    Outputs.Coordinates     := RobotStatus.CurrentMovementParameters.Coordinates; 		
                
                    Outputs.ActionNo := BYTE#254;

                    IF Outputs.ActionNo = Inputs.ActionNo THEN
                        THIS.CallTimers(FALSE);
                        _progress := 327;
                    END_IF;
                END_IF;
                
                IF _progress = 327 THEN
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
                        THIS.CallTimers(FALSE);
                        _progress:=333;
                    END_IF;
                END_IF;		

                IF _progress = 333 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#633, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        RobotStatus.Error.Id := UINT#633;
                    END_IF;

                    Outputs.ActionNo := BYTE#255;

                    IF Outputs.ActionNo = Inputs.ActionNo THEN
                        THIS.CallTimers(FALSE);
                        _progress:=334;
                    END_IF;
                END_IF;	
                
                IF _progress = 334 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#634, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        RobotStatus.Error.Id := UINT#634;
                    END_IF;

                    Outputs.ActionNo := RobotStatus.CurrentMovementParameters.ActionNo;
	
                    IF Outputs.ActionNo = Inputs.ActionNo THEN
                        THIS.CallTimers(FALSE);
                        _progress:=335;
                    END_IF;
                END_IF;	

                IF _progress = 335 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#635, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        RobotStatus.Error.Id := UINT#635;
                    END_IF;

                    Outputs.ActionNo := BYTE#255;

                    IF Outputs.ActionNo = Inputs.ActionNo THEN
                        _progress := 0;
                        StartMotorsProgramAndMovementsTask.DoneWhen(TRUE);
                    END_IF;
                END_IF;	
                
	            THIS.CallTimers(TRUE);
                StartMotorsProgramAndMovementsTask.ThrowWhen(_errorTimer.output);
                RobotStatus.Action.Id := TO_UINT(_progress);
            END_IF;
            IF StartMotorsProgramAndMovementsTask.IsFirstExecutionCycle() THEN
                MovementParameters := RobotStatus.CurrentMovementParameters;
            END_IF;
            IF StartMotorsProgramAndMovementsTask.DoneReached() THEN
                RobotStatus.Action.Id :=  UINT#121;
                RobotStatus.Error.Id :=  UINT#0;
            ELSIF StartMotorsProgramAndMovementsTask.ErrorOccured() THEN
                RobotStatus.Action.Id :=  UINT#820;
                RobotStatus.Error.Id  :=  UINT#820;
            ELSIF StartMotorsProgramAndMovementsTask.AbortTriggered() THEN
                RobotStatus.Action.Id :=  UINT#821;
                RobotStatus.Error.Id  :=  UINT#821;
            END_IF; 
            Messenger.ActivateOnCondition(ULINT#820,StartMotorsProgramAndMovementsTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#821,StartMotorsProgramAndMovementsTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#122,StartMotorsProgramAndMovementsTask.RestoreTriggered() , eAxoMessageCategory#Error);
            IF StartMotorsProgramAndMovementsTask.RestoreTriggered() AND _progress >= 320 AND _progress <= 339  THEN
                RobotStatus.Action.Id :=  UINT#122;
                _progress := 0;
            END_IF;  
            //*******************************************
                        
            //***********StartMotorsTask*****************
            StartMotorsTask.IsDisabled := _stopTasksAreActive OR StartMotorsProgramAndMovementsTask.IsBusy() OR StartMotorsAndProgramTask.IsBusy();
            IF StartMotorsTask.StartTriggered() THEN
                RobotStatus.Action.Id :=  UINT#140;
            END_IF;
            Messenger.ActivateOnCondition(ULINT#140,StartMotorsTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#141,StartMotorsTask.IsDone(), eAxoMessageCategory#Info);
            IF StartMotorsTask.Execute() THEN
                _blink.Blink(Context := _context, inOnTime:=T#500MS,inOffTime:=T#500MS);

                IF _progress = 0 THEN
                    RobotStatus.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 340;
                END_IF;
              
                IF _progress = 340 THEN //Switching to auto
                    TaskMessenger.ActivateOnCondition(ULINT#640, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        RobotStatus.Error.Id := UINT#640;
                    END_IF;

                    IF Inputs.AutoOn THEN
                        THIS.CallTimers(FALSE);
                        _progress := 341;
                    END_IF;
                END_IF;

                IF _progress = 341 THEN	//Reseting error
                    TaskMessenger.ActivateOnCondition(ULINT#641, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        RobotStatus.Error.Id := UINT#641;
                    END_IF;

                    Outputs.ResetError := Inputs.Error AND _blink.output;

                    IF NOT Inputs.Error THEN
                        Outputs.ResetError:=FALSE;
                        THIS.CallTimers(FALSE);
                        _progress := 342;
                    END_IF;
                END_IF;
              
                IF _progress = 342 THEN	//Reseting emergency stop error
                    TaskMessenger.ActivateOnCondition(ULINT#642, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        RobotStatus.Error.Id := UINT#642;
                    END_IF;

                    Outputs.ResetEmgStop := Inputs.EmgStop AND _blink.output;

                    IF NOT Inputs.EmgStop THEN
                        Outputs.ResetEmgStop:=FALSE;
                        THIS.CallTimers(FALSE);
                        _progress := 343;
                    END_IF;
                END_IF;
              
                IF _progress = 343 THEN	
                    TaskMessenger.ActivateOnCondition(ULINT#643, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        RobotStatus.Error.Id := UINT#643;
                    END_IF;

                    IF Inputs.Error THEN 
                        THIS.CallTimers(FALSE);
                        _progress := 340;
                    END_IF;

                    Outputs.MotorOn:=_blink.output;	

                    IF Inputs.MotorOnState THEN
                         THIS.CallTimers(FALSE);
                         _progress := 344;
                    END_IF;
                END_IF;		

                IF _progress = 344 THEN	
                    TaskMessenger.ActivateOnCondition(ULINT#644, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        RobotStatus.Error.Id := UINT#644;
                    END_IF;

                    IF Inputs.Error THEN 
                        THIS.CallTimers(FALSE);
                        _progress := 340;
                    END_IF;

                    Outputs.MotorOn:=_blink.output;	

                    IF NOT Inputs.Error  THEN
                         Outputs.MotorOn:=FALSE;
                         THIS.CallTimers(FALSE);
                         _progress := 345;
                    END_IF;
                END_IF;		
              
                IF _progress = 345 THEN	
                    StartMotorsTask.DoneWhen(TRUE);
                    THIS.CallTimers(FALSE);
                    _progress := 0;
                END_IF;	              

                THIS.CallTimers(TRUE);
                StartMotorsTask.ThrowWhen(_errorTimer.output);
                RobotStatus.Action.Id := TO_UINT(_progress);
            END_IF;
            IF StartMotorsTask.DoneReached() THEN
                RobotStatus.Action.Id :=  UINT#141;
                RobotStatus.Error.Id :=  UINT#0;
            ELSIF StartMotorsTask.ErrorOccured() THEN
                RobotStatus.Action.Id :=  UINT#840;
                RobotStatus.Error.Id  :=  UINT#840;
            ELSIF StartMotorsTask.AbortTriggered() THEN
                RobotStatus.Action.Id :=  UINT#841;
                RobotStatus.Error.Id  :=  UINT#841;
            END_IF;    
            Messenger.ActivateOnCondition(ULINT#840,StartMotorsTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#841,StartMotorsTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#142,StartMotorsTask.RestoreTriggered() , eAxoMessageCategory#Error);
            IF StartMotorsTask.RestoreTriggered() AND _progress >= 340 AND _progress <= 349 THEN
                RobotStatus.Action.Id :=  UINT#142;
                _progress := 0;
            END_IF;  
            //*******************************************
               
            //***********StartMovementsTask**************
            StartMovementsTask.IsDisabled := _stopTasksAreActive OR StartMotorsProgramAndMovementsTask.IsBusy();
            IF StartMovementsTask.StartTriggered() THEN
                RobotStatus.Action.Id :=  UINT#150;
            END_IF;
            Messenger.ActivateOnCondition(ULINT#150,StartMovementsTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#151,StartMovementsTask.IsDone(), eAxoMessageCategory#Info);
            IF StartMovementsTask.Execute() THEN
                IF _progress = 0 THEN
                    RobotStatus.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 350;
                END_IF;
                
                IF _progress = 350 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#650, _infoTimer.output, eAxoMessageCategory#Warning);

                    IF _infoTimer.output THEN
                        RobotStatus.Error.Id := UINT#650;
                    END_IF;

                    IF Inputs.CycleOn THEN
                        THIS.CallTimers(FALSE);
                        _progress := 351;
                    END_IF;
                END_IF;
                
                IF _progress = 351 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#651, _infoTimer.output, eAxoMessageCategory#Warning);

                    IF _infoTimer.output THEN
                        RobotStatus.Error.Id := UINT#651;
                    END_IF;

                    IF Inputs.MotorOnState THEN
                        THIS.CallTimers(FALSE);
                        _progress := 352;
                    END_IF;
                END_IF;

                IF _progress = 352 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#652, _infoTimer.output, eAxoMessageCategory#Warning);

                    IF _infoTimer.output THEN
                        RobotStatus.Error.Id := UINT#652;
                    END_IF;
                                        
                    IF NOT Inputs.Error THEN
                        THIS.CallTimers(FALSE);
                        _progress := 353;
                    END_IF;
                END_IF;

                IF _progress = 353 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#653, _infoTimer.output, eAxoMessageCategory#Warning);

                    IF _infoTimer.output THEN
                        RobotStatus.Error.Id := UINT#653;
                    END_IF;
                            
                    Outputs.GlobalSpeed     := RobotStatus.CurrentMovementParameters.GlobalSpeed;
                    Outputs.ToolNo          := RobotStatus.CurrentMovementParameters.ToolNo;
                    Outputs.WorkobjectNo    := RobotStatus.CurrentMovementParameters.WorkobjectNo;
                    Outputs.PointNo         := RobotStatus.CurrentMovementParameters.PointNo;
                    Outputs.UserSpecSpeed1  := RobotStatus.CurrentMovementParameters.UserSpecSpeed1;
                    Outputs.UserSpecSpeed2  := RobotStatus.CurrentMovementParameters.UserSpecSpeed2;
                    Outputs.Coordinates     := RobotStatus.CurrentMovementParameters.Coordinates; 		
                
                    Outputs.ActionNo := BYTE#254;

                    IF Outputs.ActionNo = Inputs.ActionNo THEN
                        THIS.CallTimers(FALSE);
                        _progress := 354;
                    END_IF;
                END_IF;
                
                IF _progress = 354 THEN
                    IF _infoTimer.output THEN
                        IF Inputs.GlobalSpeed <> RobotStatus.CurrentMovementParameters.GlobalSpeed THEN
                            RobotStatus.Error.Id := UINT#654;//<#Waiting for Inputs.GlobalSpeed to be equal to MovementParameters.GlobalSpeed!
                        END_IF;
                        IF Inputs.ToolNo <> RobotStatus.CurrentMovementParameters.ToolNo THEN
                            RobotStatus.Error.Id := UINT#655;//<#Waiting for Inputs.ToolNo to be equal to MovementParameters.ToolNo!
                        END_IF;
                        IF Inputs.WorkobjectNo <> RobotStatus.CurrentMovementParameters.WorkobjectNo THEN
                            RobotStatus.Error.Id := UINT#656;//<#Waiting for Inputs.WorkobjectNo to be equal to MovementParameters.WorkobjectNo!
                        END_IF;
                        IF Inputs.PointNo <> RobotStatus.CurrentMovementParameters.PointNo THEN
                            RobotStatus.Error.Id := UINT#657;//<#Waiting for Inputs.PointNo to be equal to MovementParameters.PointNo!
                        END_IF;
                        IF Inputs.UserSpecSpeed1 <> RobotStatus.CurrentMovementParameters.UserSpecSpeed1 THEN
                            RobotStatus.Error.Id := UINT#658;//<#Waiting for Inputs.UserSpecSpeed1 to be equal to MovementParameters.UserSpecSpeed1!
                        END_IF;
                        IF Inputs.UserSpecSpeed2 <> RobotStatus.CurrentMovementParameters.UserSpecSpeed2 THEN
                            RobotStatus.Error.Id := UINT#659;//<#Waiting for Inputs.UserSpecSpeed2 to be equal to MovementParameters.UserSpecSpeed2!
                        END_IF;
                    END_IF;

                    IF 	Inputs.GlobalSpeed      = RobotStatus.CurrentMovementParameters.GlobalSpeed AND
                        Inputs.ToolNo           = RobotStatus.CurrentMovementParameters.ToolNo AND
                        Inputs.WorkobjectNo     = RobotStatus.CurrentMovementParameters.WorkobjectNo AND
                        Inputs.PointNo          = RobotStatus.CurrentMovementParameters.PointNo AND
                        Inputs.UserSpecSpeed1   = RobotStatus.CurrentMovementParameters.UserSpecSpeed1 AND
                        Inputs.UserSpecSpeed2   = RobotStatus.CurrentMovementParameters.UserSpecSpeed2 AND
                        AXOpen.Components.Robotics.CoordinatesAreNearlyEqual(Inputs.Coordinates,RobotStatus.CurrentMovementParameters.Coordinates,REAL#0.01,REAL#0.01,REAL#0.01,REAL#0.01,REAL#0.01,REAL#0.01) THEN
                        THIS.CallTimers(FALSE);
                        _progress:=360;
                    END_IF;
                END_IF;		

                IF _progress = 360 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#660, _infoTimer.output, eAxoMessageCategory#Warning);

                    IF _infoTimer.output THEN
                        RobotStatus.Error.Id := UINT#660;
                    END_IF;

                    Outputs.ActionNo := BYTE#255;

                    IF Outputs.ActionNo = Inputs.ActionNo THEN
                        THIS.CallTimers(FALSE);
                        _progress:=361;
                    END_IF;
                END_IF;	
                
                IF _progress = 361 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#661, _infoTimer.output, eAxoMessageCategory#Warning);

                    IF _infoTimer.output THEN
                        RobotStatus.Error.Id := UINT#661;
                    END_IF;

                    Outputs.ActionNo := RobotStatus.CurrentMovementParameters.ActionNo;

                    IF Outputs.ActionNo = Inputs.ActionNo THEN
                        THIS.CallTimers(FALSE);
                        _progress:=662;
                    END_IF;
                END_IF;	

                IF _progress = 662 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#662, _infoTimer.output, eAxoMessageCategory#Warning);

                    IF _infoTimer.output THEN
                        RobotStatus.Error.Id := UINT#662;
                    END_IF;

                    Outputs.ActionNo := BYTE#255;

                    IF Outputs.ActionNo = Inputs.ActionNo THEN
                        _progress := 663;
                        StartMovementsTask.DoneWhen(TRUE);
                    END_IF;
                END_IF;	
                
                IF _progress = 663 THEN
                    _progress := 663;
                    StartMovementsTask.DoneWhen(TRUE);
                END_IF;	
	            THIS.CallTimers(TRUE);
                
                StartMovementsTask.ThrowWhen(_errorTimer.output);

                RobotStatus.Action.Id := TO_UINT(_progress);
            END_IF;
            IF StartMovementsTask.IsFirstExecutionCycle() THEN
                MovementParameters := RobotStatus.CurrentMovementParameters;
            END_IF;
            IF StartMovementsTask.DoneReached() THEN
                RobotStatus.Action.Id :=  UINT#151;
                RobotStatus.Error.Id :=  UINT#0;
            ELSIF StartMovementsTask.ErrorOccured() THEN
                RobotStatus.Action.Id :=  UINT#850;
                RobotStatus.Error.Id  :=  UINT#850;
            ELSIF StartMovementsTask.AbortTriggered() THEN
                RobotStatus.Action.Id :=  UINT#851;
                RobotStatus.Error.Id  :=  UINT#851;
            END_IF;    
            Messenger.ActivateOnCondition(ULINT#850,StartMovementsTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#851,StartMovementsTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#152,StartMovementsTask.RestoreTriggered() , eAxoMessageCategory#Error);
            IF StartMovementsTask.RestoreTriggered() AND _progress >= 350 AND _progress <= 369 THEN
                RobotStatus.Action.Id :=  UINT#152;
                _progress := 0;
            END_IF;  
            //*******************************************
 
            //***********StartProgramTask*******
            StartProgramTask.IsDisabled := _stopTasksAreActive;
            IF StartAtMainTask.StartTriggered() THEN
                RobotStatus.Action.Id :=  UINT#170;
            END_IF;
            Messenger.ActivateOnCondition(ULINT#170,StartAtMainTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#171,StartAtMainTask.IsDone(), eAxoMessageCategory#Info);
            IF StartProgramTask.Execute() THEN
                _blink.Blink(Context := _context, inOnTime:=T#500MS,inOffTime:=T#500MS);

                IF _progress = 0 THEN
                    RobotStatus.Error.Id :=  UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 370;
                END_IF;
              
                IF _progress = 370 THEN 
                    TaskMessenger.ActivateOnCondition(ULINT#670, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        RobotStatus.Error.Id := UINT#670;
                    END_IF;

                    Outputs.StartProgram:=_blink.output;
                    
                    IF  Inputs.CycleOn THEN
                        THIS.CallTimers(FALSE);
                        _progress := 371;
                    END_IF;
                END_IF;

                IF _progress = 371 THEN 
                    TaskMessenger.ActivateOnCondition(ULINT#671, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        RobotStatus.Error.Id := UINT#671;
                    END_IF;

                    Outputs.StartProgram:=_blink.output;
                    
                    IF  NOT Inputs.SystemInputBusy THEN
                        Outputs.StartProgram:=FALSE;
                        THIS.CallTimers(FALSE);
                        _progress := 372;
                    END_IF;
                END_IF;

                IF _progress = 372 THEN	
                    StartProgramTask.DoneWhen(TRUE);
                    THIS.CallTimers(FALSE);
                    _progress := 0;
                END_IF;	              

                THIS.CallTimers(TRUE);
                StartProgramTask.ThrowWhen(_errorTimer.output);
                RobotStatus.Action.Id := TO_UINT(_progress);
            END_IF;
            IF StartProgramTask.DoneReached() THEN
                RobotStatus.Action.Id :=  UINT#171;
                RobotStatus.Error.Id :=  UINT#0;
            ELSIF StartProgramTask.ErrorOccured() THEN
                RobotStatus.Action.Id :=  UINT#870;
                RobotStatus.Error.Id  :=  UINT#870;
            ELSIF StartProgramTask.AbortTriggered()THEN
                RobotStatus.Action.Id :=  UINT#871;
                RobotStatus.Error.Id  :=  UINT#871;
            END_IF;     
            Messenger.ActivateOnCondition(ULINT#870,StartProgramTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#871,StartProgramTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#172,StartProgramTask.RestoreTriggered() , eAxoMessageCategory#Error);
            IF StartProgramTask.RestoreTriggered() AND _progress >= 370 AND _progress <= 379  THEN
                RobotStatus.Action.Id :=  UINT#172;
                _progress := 0;
            END_IF;
            //*******************************************

            //***********StopMotorsTask***************
            StopMotorsTask.IsDisabled := FALSE;
            IF StartAtMainTask.StartTriggered() THEN
                RobotStatus.Action.Id :=  UINT#180;
            END_IF;
            Messenger.ActivateOnCondition(ULINT#180,StartAtMainTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#181,StartAtMainTask.IsDone(), eAxoMessageCategory#Info);
            IF StopMotorsTask.Execute() THEN
                _blink.Blink(Context := _context, inOnTime:=T#500MS,inOffTime:=T#500MS);

                IF _progress = 0 THEN
                    RobotStatus.Error.Id :=  UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 380;
                END_IF;
              
                IF _progress = 380 THEN 
                    TaskMessenger.ActivateOnCondition(ULINT#680, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        RobotStatus.Error.Id := UINT#680;
                    END_IF;

                    Outputs.MotorOff := TRUE;
                   
                    IF  Inputs.MotorOffState  THEN
                        THIS.CallTimers(FALSE);
                        _progress := 381;
                    END_IF;
                END_IF;

                IF _progress = 381 THEN 
                    TaskMessenger.ActivateOnCondition(ULINT#681, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        RobotStatus.Error.Id := UINT#681;
                    END_IF;

                    Outputs.MotorOff := TRUE;
                   
                    IF  NOT Inputs.SystemInputBusy THEN
                        Outputs.MotorOff:=FALSE;
                        THIS.CallTimers(FALSE);
                        _progress := 382;
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
                RobotStatus.Action.Id :=  UINT#181;
                RobotStatus.Error.Id :=  UINT#0;
            ELSIF StopMotorsTask.ErrorOccured() THEN
                RobotStatus.Action.Id :=  UINT#880;
                RobotStatus.Error.Id  :=  UINT#880;
            ELSIF StopMotorsTask.AbortTriggered()THEN
                RobotStatus.Action.Id :=  UINT#881;
                RobotStatus.Error.Id  :=  UINT#881;
            END_IF;     
            Messenger.ActivateOnCondition(ULINT#880,StopMotorsTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#881,StopMotorsTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#182,StopMotorsTask.RestoreTriggered() , eAxoMessageCategory#Error);
            IF StopMotorsTask.RestoreTriggered() AND _progress >= 380 AND _progress <= 389  THEN
                RobotStatus.Action.Id :=  UINT#182;
                _progress := 0;
            END_IF;
            //*******************************************

            //***********StopMovementsAndProgramTask*****
            StopMovementsAndProgramTask.IsDisabled := FALSE;
            IF StopMovementsAndProgramTask.StartTriggered() THEN
                RobotStatus.Action.Id :=  UINT#190;
            END_IF;
            Messenger.ActivateOnCondition(ULINT#190,StopMovementsAndProgramTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#191,StopMovementsAndProgramTask.IsDone(), eAxoMessageCategory#Info);
            IF StopMovementsAndProgramTask.Execute() THEN
                IF _progress = 0 THEN
                    RobotStatus.Error.Id :=  UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 390;
                END_IF;
                
                IF _progress = 390 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#690, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        RobotStatus.Error.Id := UINT#690;
                    END_IF;

                    Outputs.SoftStop := TRUE;
                    Outputs.QuickStop := FALSE;
                
                    IF _stopType = eAxoRoboticsStopType#Quick THEN
                        Outputs.SoftStop := FALSE;
                        Outputs.QuickStop := TRUE;
                    END_IF;

                    IF Inputs.MoveInactive THEN
                        THIS.CallTimers(FALSE);
                        _progress := 391;
                    END_IF;
                END_IF;
                
                IF _progress = 391 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#691, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        RobotStatus.Error.Id := UINT#691;
                    END_IF;

                    Outputs.StopProgram:=TRUE;

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
                RobotStatus.Action.Id :=  UINT#191;
                RobotStatus.Error.Id :=  UINT#0;
            ELSIF StopMovementsAndProgramTask.ErrorOccured() THEN
                RobotStatus.Action.Id :=  UINT#890;
                RobotStatus.Error.Id  :=  UINT#890;
            ELSIF StopMovementsAndProgramTask.AbortTriggered()THEN
                RobotStatus.Action.Id :=  UINT#891;
                RobotStatus.Error.Id  :=  UINT#891;
            END_IF;     
            Messenger.ActivateOnCondition(ULINT#890,StopMovementsAndProgramTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#891,StopMovementsAndProgramTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#192,StopMovementsAndProgramTask.RestoreTriggered() , eAxoMessageCategory#Error);
            IF StopMovementsAndProgramTask.RestoreTriggered() AND _progress >= 390 AND _progress <= 399  THEN
                RobotStatus.Action.Id :=  UINT#192;
                _progress := 0;
            END_IF;
            //*******************************************
            
            //***********StopMovementsTask***************
            StopMovementsTask.IsDisabled := FALSE;
            IF StopMovementsTask.StartTriggered() THEN
                RobotStatus.Action.Id :=  UINT#400;
            END_IF;
            Messenger.ActivateOnCondition(ULINT#200,StopMovementsTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#201,StopMovementsTask.IsDone(), eAxoMessageCategory#Info);
            IF StopMovementsTask.Execute() THEN
                IF _progress = 0 THEN
                    RobotStatus.Error.Id :=  UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 400;
                END_IF;
                
                IF _progress = 400 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#692, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        RobotStatus.Error.Id := UINT#692;
                    END_IF;

                    Outputs.SoftStop := TRUE;
                    Outputs.QuickStop := FALSE;
                
                    IF _stopType = eAxoRoboticsStopType#Quick THEN
                        Outputs.SoftStop := FALSE;
                        Outputs.QuickStop := TRUE;
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
                RobotStatus.Action.Id :=  UINT#201;
                RobotStatus.Error.Id :=  UINT#0;
            ELSIF StopMovementsTask.ErrorOccured() THEN
                RobotStatus.Action.Id :=  UINT#900;
                RobotStatus.Error.Id  :=  UINT#900;
            ELSIF StopMovementsTask.AbortTriggered()THEN
                RobotStatus.Action.Id :=  UINT#901;
                RobotStatus.Error.Id  :=  UINT#901;
            END_IF;     
            Messenger.ActivateOnCondition(ULINT#900,StopMovementsTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#901,StopMovementsTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#202,StopMovementsTask.RestoreTriggered() , eAxoMessageCategory#Error);
            IF StopMovementsTask.RestoreTriggered() AND _progress >= 400 AND _progress <= 409  THEN
                RobotStatus.Action.Id :=  UINT#202;
                _progress := 0;
            END_IF;
            //*******************************************

            //***********StopProgramTask*****************
            StopProgramTask.IsDisabled := FALSE;
            IF StopProgramTask.StartTriggered() THEN
                RobotStatus.Action.Id :=  UINT#210;
            END_IF;
            Messenger.ActivateOnCondition(ULINT#210,StopProgramTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#211,StopProgramTask.IsDone(), eAxoMessageCategory#Info);
            IF StopProgramTask.Execute() THEN
                IF _progress = 0 THEN
                    RobotStatus.Error.Id :=  UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 410;
                END_IF;
                
                IF _progress = 410 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#693, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        RobotStatus.Error.Id := UINT#693;
                    END_IF;

                    Outputs.StopProgram:=TRUE;

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
                RobotStatus.Action.Id :=  UINT#911;
                RobotStatus.Error.Id :=  UINT#0;
            ELSIF StopProgramTask.ErrorOccured() THEN
                RobotStatus.Action.Id :=  UINT#910;
                RobotStatus.Error.Id  :=  UINT#910;
            ELSIF StopProgramTask.AbortTriggered()THEN
                RobotStatus.Action.Id :=  UINT#911;
                RobotStatus.Error.Id  :=  UINT#911;
            END_IF;     
            Messenger.ActivateOnCondition(ULINT#910,StopProgramTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#911,StopProgramTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#212,StopProgramTask.RestoreTriggered() , eAxoMessageCategory#Error);
            IF StopProgramTask.RestoreTriggered() AND _progress >= 410 AND _progress <= 419  THEN
                RobotStatus.Action.Id :=  UINT#912;
                _progress := 0;
            END_IF;
            //*******************************************
            
            _someTaskIsActive := StartAtMainTask.IsBusy()
                                OR StartMotorsAndProgramTask.IsBusy()
                                OR StartMovementsTask.IsBusy()
                                OR StartMovementsTask.IsBusy()
                                OR StopMovementsTask.IsBusy()
                                OR StopMovementsAndProgramTask.IsBusy()
                                OR StopProgramTask.IsBusy();
            
            Messenger.ActivateOnCondition(ULINT#705,_someTaskIsActive AND Inputs.EmgStop, eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#706,_someTaskIsActive AND NOT Inputs.SafetyOk, eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#707,_someTaskIsActive AND Inputs.ProgExecError, eAxoMessageCategory#Error);

            IF _someTaskIsActive THEN
                IF(Inputs.EmgStop) THEN
                    RobotStatus.Error.Id := UINT#705;
                END_IF;
                IF(NOT Inputs.SafetyOk) THEN
                    RobotStatus.Error.Id := UINT#706;
                END_IF;
                IF(Inputs.ProgExecError) THEN
                    RobotStatus.Error.Id := UINT#707;
                END_IF;
            END_IF;
*)
            //***********UPDATE**OUTPUTS*****************
            //SYSTEM OUTPUTS
            _data[0].%X0	     := Outputs.ExternalStart;     
            _data[0].%X1	     := Outputs.MoveEnable;    
            _data[0].%X2         := Outputs.ErrorConfirmation; 
            _data[0].%X3         := Outputs.DrivesOff;
            _data[0].%X4         := Outputs.DrivesOn;   
            _data[0].%X5         := Outputs.ActivateInterface; 
            _data[0].%X6         := Outputs.StartAtMain;    
 
            // _data[1].%X0	     := Outputs.StartProgram;    
            // _data[1].%X1	     := Outputs.StartAtMain;    
            // _data[1].%X2         := Outputs.StopProgram;     
            // _data[1].%X3         := Outputs.QuickStop;    
            // _data[1].%X4         := Outputs.SoftStop;    
            // _data[1].%X5         := Outputs.StopCycle;    
            // _data[1].%X6         := Outputs.StopInstruction;    
            // _data[1].%X7         := Outputs.LimitSpeed;    

            //Tool signals
            _data[2].%X0         := Outputs.Tool_1_Retract;    
            _data[2].%X1 	     := Outputs.Tool_1_Extend;    
            _data[2].%X2	     := Outputs.Tool_2_Retract;    
            _data[2].%X3	     := Outputs.Tool_2_Extend;    
            _data[2].%X4	     := Outputs.Tool_3_Retract;    
            _data[2].%X5	     := Outputs.Tool_3_Extend;    
            _data[2].%X6 	     := Outputs.Tool_4_Retract;    
            _data[2].%X7	     := Outputs.Tool_4_Extend;    

            //master mode  such as manual/auto ..
            _data[3]             := Outputs.MasterMode;

            //zone
            _data[5]             := Outputs.Zone;

            //position
            _data[6]             := Outputs.InPosition;

            //Movement parameters
            _data[7]             := Outputs.ActionNo;
            _data[8]             := Outputs.GlobalSpeed;
            _data[9]             := Outputs.ToolNo;
            _data[10]            := Outputs.WorkobjectNo;
            _data[11]            := Outputs.PointNo;

            _dword               := TO_DWORD(Outputs.UserSpecSpeed1);
            _data[12]            := _dword.%B3;
            _data[13]            := _dword.%B2;
            _data[14]            := _dword.%B1;
            _data[15]            := _dword.%B0;

            _dword               := TO_DWORD(Outputs.UserSpecSpeed2);
            _data[16]            := _dword.%B3;
            _data[17]            := _dword.%B2;
            _data[18]            := _dword.%B1;
            _data[19]            := _dword.%B0;

            ////Coordinates
            // _dword               := TO_DWORD((Outputs.Coordinates.X +REAL#10000.0)*REAL#10000.0);
            _dword               := TO_DWORD(Outputs.Coordinates.X * REAL#10000.0); //  Todo check negative values
            _data[20]            := _dword.%B3;
            _data[21]            := _dword.%B2;
            _data[22]            := _dword.%B1;
            _data[23]            := _dword.%B0;

            // _dword               := TO_DWORD((Outputs.Coordinates.Y +REAL#10000.0)*REAL#10000.0);
            _dword               := TO_DWORD(Outputs.Coordinates.Y * REAL#10000.0); //  Todo check negative values
            _data[24]            := _dword.%B3;
            _data[25]            := _dword.%B2;
            _data[26]            := _dword.%B1;
            _data[27]            := _dword.%B0;

            // _dword               := TO_DWORD((Outputs.Coordinates.Z +REAL#10000.0)*REAL#10000.0);
            _dword               := TO_DWORD(Outputs.Coordinates.Z * REAL#10000.0); //  Todo check negative values
            _data[28]            := _dword.%B3;
            _data[29]            := _dword.%B2;
            _data[30]            := _dword.%B1;
            _data[31]            := _dword.%B0;

            // _dword               := TO_DWORD((Outputs.Coordinates.Rx +REAL#360.0)*REAL#10000.0);
            _dword               := TO_DWORD(Outputs.Coordinates.Rx * REAL#10000.0); //  Todo check negative values
            _data[32]            := _dword.%B3;
            _data[33]            := _dword.%B2;
            _data[34]            := _dword.%B1;
            _data[35]            := _dword.%B0;

            // _dword               := TO_DWORD((Outputs.Coordinates.Ry +REAL#360.0)*REAL#10000.0);
            _dword               := TO_DWORD(Outputs.Coordinates.Ry * REAL#10000.0); //  Todo check negative values
            _data[36]            := _dword.%B3;
            _data[37]            := _dword.%B2;
            _data[38]            := _dword.%B1;
            _data[39]            := _dword.%B0;

            // _dword               := TO_DWORD((Outputs.Coordinates.Rz +REAL#360.0)*REAL#10000.0);
            _dword               := TO_DWORD(Outputs.Coordinates.Rz * REAL#10000.0); //  Todo check negative values
            _data[40]            := _dword.%B3;
            _data[41]            := _dword.%B2;
            _data[42]            := _dword.%B1;
            _data[43]            := _dword.%B0;

            returnValue := Siemens.Simatic.S71500.DistributedIO.WriteData(_hwId_512_DI_DO,_data);
            Messenger.ActivateOnCondition(ULINT#704,returnValue > WORD#0, eAxoMessageCategory#ProgrammingError);
            IF returnValue > WORD#0 THEN
                RobotStatus.Error.Id := UINT#704;
                RETURN;
            END_IF;
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
            RobotStatus.Action.Id :=  UINT#50;
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
