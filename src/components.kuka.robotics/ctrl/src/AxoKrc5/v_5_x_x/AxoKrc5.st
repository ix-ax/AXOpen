USING AXOpen.Core;
USING AXOpen.Messaging;
USING AXOpen.Messaging.Static;
USING AXOpen.Components.Robotics;
USING AXOpen.Components.Abstractions.Robotics;
USING Siemens.Simatic.Hardware.Utilities;

NAMESPACE AXOpen.Components.Kuka.Robotics.v_5_x_x
    {S7.extern=ReadWrite}
    CLASS AxoKrc5 EXTENDS AXOpen.Core.AxoComponent IMPLEMENTS AXOpen.Components.Abstractions.Robotics.IAxoRobotics
        VAR PRIVATE
            _infoTimer              :   AXOpen.Timers.OnDelayTimer;
            _errorTimer             :   AXOpen.Timers.OnDelayTimer;
            _context                :   IAxoContext;
            _stopTasksAreActive     :   BOOL;
            _stopType               :   eAxoRoboticsStopType;
            _someTaskIsActive       :   BOOL;

            _dword: DWORD;
            _data : ARRAY[0..63] OF BYTE; 

            _initHwCheckDone        :   BOOL;
            _retval                 :   WORD;
            _geoAddr                :   GeoAddr;
            _outHwid                :   UINT;
            _blink                  :   AXOpen.Timers.AxoBlinker;   
            _inputsAddress          :   UDINT;   
            _inputsCount            :   UINT;
            _outputsAddress         :   UDINT;  
            _outputsCount           :   UINT;             
            _movementExecuting      :   BOOL;
            _inputsManualPV         :   BOOL;
        END_VAR

        VAR PUBLIC //HEADER
                    
        END_VAR

        VAR PUBLIC //Tasks
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Tasks")]}            
            {#ix-set:AttributeName = "<#Restore#>"}
            RestoreTask : AxoTask;            

            {#ix-attr:[ComponentDetails("Tasks")]}            
            {#ix-set:AttributeName = "<#Reset all outputs#>"}
            ResetAllOutputsTask : AxoTask;

            {#ix-attr:[ComponentDetails("Tasks")]}            
            {#ix-set:AttributeName = "<#Start motors#>"}
            StartMotorsTask : AxoTask;            

            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Tasks")]}            
            {#ix-set:AttributeName = "<#Start at main#>"}
            StartAtMainTask : AxoTask;            

            {#ix-attr:[ComponentDetails("Tasks")]}            
            {#ix-set:AttributeName = "<#Start motors program and movements#>"}
            StartMotorsProgramAndMovementsTask : AxoTask;

            {#ix-attr:[ComponentDetails("Tasks")]}            
            {#ix-set:AttributeName = "<#Start movements with extended parameters#>"}
            MovementParameters : AXOpen.Components.Abstractions.Robotics.AxoRoboticsMovementsParams;

            {#ix-attr:[ComponentDetails("Tasks")]}            
            {#ix-set:AttributeName = "<#Start program#>"}
            StartProgramTask : AxoTask;            

            {#ix-attr:[ComponentDetails("Tasks")]}            
            {#ix-set:AttributeName = "<#Start movements#>"}
            StartMovementsTask : AxoTask;

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
            {#ix-set:AttributeName = "<#Stop program#>"}
            StopProgramTask : AxoTask;

            {#ix-attr:[ComponentDetails("Tasks")]}            
            {#ix-set:AttributeName = "<#Stop motors#>"}
            StopMotorsTask : AxoTask;
        END_VAR
        
        VAR PUBLIC //CONFIG
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("Config")]}
            {#ix-attr:[ReadOnly()]}
            Config  :   AxoKrc5_Config;
        END_VAR

        VAR PUBLIC //STATUS
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("Status")]}
            {#ix-attr:[ReadOnly()]}
            Status          :   AxoKrc5_Component_Status;
            Messenger       :   AXOpen.Messaging.Static.AxoMessenger;
            TaskMessenger   :   AXOpen.Messaging.Static.AxoMessenger;
            {#ix-attr:[ComponentDetails("Status")]}
            {#ix-attr:[ReadOnly()]}
            {#ix-set:AttributeName = "<#Power progress#>"}
            _power_progress     :   INT := 0;
            {#ix-attr:[ComponentDetails("Status")]}
            {#ix-attr:[ReadOnly()]}
            {#ix-set:AttributeName = "<#Movement progress#>"}
            _movement_progress  :   INT := 0;            
        END_VAR

        VAR PUBLIC //Hardware signals
            {#ix-attr:[ComponentDetails("Hardware signals")]}
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Inputs#>"}
            {#ix-attr:[ReadOnly()]}
            Inputs              :   AxoKrc5_State;
            {#ix-attr:[ComponentDetails("Hardware signals")]}
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Outputs#>"}
            {#ix-attr:[ReadOnly()]}
            Outputs              :   AxoKrc5_Control;
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
                inParent    : IAxoObject;
                hwID    :   UINT;   
            END_VAR

            SUPER.Run(inParent);

            Messenger.Serve(THIS);

            IF NOT _initHwCheckDone THEN
                IF inParent = NULL THEN
                    Messenger.Activate(UINT#700, eAxoMessageCategory#ProgrammingError);
                    Status.Error.Id := UINT#700;
                    RETURN;
                END_IF;
                Config.HWIDs.HwID_Device:= hwID;                                                      
                IF Config.HWIDs.HwID_Device = UINT#0 THEN
                    Messenger.Activate(UINT#701, eAxoMessageCategory#ProgrammingError);
                    Status.Error.Id := UINT#701;
                    RETURN;
                END_IF;
    
                _retval := ReadSlotFromHardwareID(hardwareID := Config.HWIDs.HwID_Device, geoAddr :=_geoAddr);   
                IF _retval = WORD#8090 THEN
                    Messenger.Activate(UINT#702,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#702;
                    RETURN;
                END_IF;

                //******************Slot 1*****************//
                _geoAddr.Slot   :=  UINT#1;                        //Needs to be checked, by default there is a safety module configured once gsdml file is applied                                    
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_None);        
                IF Config.HWIDs.HwID_None <> UINT#0 THEN
                    Messenger.Activate(UINT#710,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#710;
                    RETURN;
                END_IF;
                // IF _retval = WORD#8091 THEN
                //     Messenger.Activate(UINT#711,eAxoMessageCategory#Error);
                //     Status.Error.Id := UINT#711;
                //     RETURN;
                // END_IF;
                // IF _retval = WORD#8094 THEN
                //     Messenger.Activate(UINT#712,eAxoMessageCategory#Error);
                //     Status.Error.Id := UINT#712;
                //     RETURN;
                // END_IF;
                // IF _retval = WORD#8095 THEN
                //     Messenger.Activate(UINT#713,eAxoMessageCategory#Error);
                //     Status.Error.Id := UINT#713;
                //     RETURN;
                // END_IF;
                // IF _retval = WORD#8096 THEN
                //     Messenger.Activate(UINT#714,eAxoMessageCategory#Error);
                //     Status.Error.Id := UINT#714;
                //     RETURN;
                // END_IF;
                // IF _retval = WORD#8097 THEN
                //     Messenger.Activate(UINT#715,eAxoMessageCategory#Error);
                //     Status.Error.Id := UINT#715;
                //     RETURN;
                // END_IF;
                // ReadHardwareIOAddress(hardwareIdentifier :=  _hwId_None , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                // IF _inputsCount <> UINT#0 OR _outputsCount <> UINT#0 THEN
                //     Messenger.Activate(UINT#716,eAxoMessageCategory#Error);
                //     Status.Error.Id := UINT#716;
                //     RETURN;
                // END_IF;
                //******************Slot 2*****************//
                _geoAddr.Slot   :=  UINT#2;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_512_DI_DO);        
                IF Config.HWIDs.HwID_512_DI_DO = UINT#0 THEN
                    Messenger.Activate(UINT#720,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#720;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#721,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#721;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#722,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#722;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#723,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#723;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#724,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#724;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#725,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#725;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HwID_512_DI_DO) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#64 OR _outputsCount <> UINT#64 THEN
                    Messenger.Activate(UINT#726,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#726;
                    RETURN;
                END_IF;
 
                IF inParent = NULL THEN
                    Messenger.Activate(UINT#1130,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1130;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_Device  = UINT#0 THEN
                    Messenger.Activate(UINT#1131,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1131;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_None <> UINT#0 THEN
                    Messenger.Activate(UINT#1132,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1132;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_512_DI_DO  = UINT#0 THEN
                    Messenger.Activate(UINT#1133,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1133;
                    RETURN;
                END_IF;

                _initHwCheckDone    := TRUE;
            END_IF;            

            //***********UPDATE**INPUTS******************
            _retVal := Siemens.Simatic.DistributedIO.ReadData((Config.HWIDs.HwID_512_DI_DO) ,_data);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1201, eAxoMessageCategory#Error);
                Status.Error.Id := UINT#1201;
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

            _dword.%B0                      := _data[12];
            _dword.%B1                      := _data[13];
            _dword.%B2                      := _data[14];
            _dword.%B3                      := _data[15];
            Inputs.UserSpecSpeed1           := TO_DINT(_dword);

            _dword.%B0                      := _data[16];
            _dword.%B1                      := _data[17];
            _dword.%B2                      := _data[18];
            _dword.%B3                      := _data[19];
            Inputs.UserSpecSpeed2           := TO_DINT(_dword);

            _dword.%B0                      := _data[20];
            _dword.%B1                      := _data[21];
            _dword.%B2                      := _data[22];
            _dword.%B3                      := _data[23];
            Inputs.Coordinates.X:= TO_REAL(TO_DINT(_dword))*REAL#0.0001; 

            _dword.%B0                      := _data[24];
            _dword.%B1                      := _data[25];
            _dword.%B2                      := _data[26];
            _dword.%B3                      := _data[27];
            Inputs.Coordinates.Y:= TO_REAL(TO_DINT(_dword))*REAL#0.0001;

            _dword.%B0                      := _data[28];
            _dword.%B1                      := _data[29];
            _dword.%B2                      := _data[30];
            _dword.%B3                      := _data[31];
            Inputs.Coordinates.Z:= TO_REAL(TO_DINT(_dword))*REAL#0.0001;

            _dword.%B0                      := _data[32];
            _dword.%B1                      := _data[33];
            _dword.%B2                      := _data[34];
            _dword.%B3                      := _data[35];
            Inputs.Coordinates.Rx:= TO_REAL(TO_DINT(_dword))*REAL#0.0001;

            _dword.%B0                      := _data[36];
            _dword.%B1                      := _data[37];
            _dword.%B2                      := _data[38];
            _dword.%B3                      := _data[39];
            Inputs.Coordinates.Ry:= TO_REAL(TO_DINT(_dword))*REAL#0.0001; 

            _dword.%B0                      := _data[40];
            _dword.%B1                      := _data[41];
            _dword.%B2                      := _data[42];
            _dword.%B3                      := _data[43];
            Inputs.Coordinates.Rz:= TO_REAL(TO_DINT(_dword))*REAL#0.0001; 

            _dword.%B0                      := _data[44];
            _dword.%B1                      := _data[45];
            _dword.%B2                      := _data[46];
            _dword.%B3                      := _data[47];
            Inputs.EventId                  := TO_UDINT(_dword);
            //*******************************************
            _context := THIS.GetContext();

            //*********MOVE**ENABLE**IN**MANUAL*******
            IF Inputs.Manual  AND NOT _inputsManualPV THEN
                Outputs.MoveEnable := TRUE;
            ELSIF NOT Inputs.Manual  AND _inputsManualPV THEN
                Outputs.MoveEnable := FALSE;
            END_IF;
            _inputsManualPV := Inputs.Manual;   
            //****************************************
            //*************INITIALIZATION*************
            RestoreTask.Run(THIS);
            StopMovementsTask.Run(THIS);
            StopMovementsAndProgramTask.Run(THIS);
            StopProgramTask.Run(THIS);
            StopMotorsTask.Run(THIS);
            StartAtMainTask.Run(THIS);
            StartMotorsAndProgramTask.Run(THIS);
            StartProgramTask.Run(THIS);
            StartMotorsTask.Run(THIS);
            StartMovementsTask.Run(THIS);
            StartMotorsProgramAndMovementsTask.Run(THIS);
            ResetAllOutputsTask.Run(THIS);
            HardwareDiagnosticsTask.Run(THIS);

            _stopTasksAreActive := StopMovementsTask.IsBusy() OR StopMovementsAndProgramTask.IsBusy() OR StopProgramTask.IsBusy() OR StopMotorsTask.IsBusy();
            _movementExecuting := FALSE;
            //****************************************
            //********************Diagnostics*********        
            HardwareDiagnosticsTask.Run(THIS,Config.HWIDs.HwID_Device);
            //****************************************

            //*************RESTORE********************
            RestoreTask.SetIsDisabled(FALSE);
            IF RestoreTask.Execute(THIS) THEN
                THIS.Restore();
            END_IF;
            //****************************************

            //*************StartAtMainTask************
            StartAtMainTask.SetIsDisabled(_stopTasksAreActive);
            IF StartAtMainTask.StartTriggered() THEN
                Status.Action.Id :=  UINT#100;
            END_IF;
            Messenger.ActivateOnCondition(ULINT#100,StartAtMainTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#101,StartAtMainTask.IsDone(), eAxoMessageCategory#Info);
            IF StartAtMainTask.Execute(THIS) THEN
                _blink.Blink(Context := _context, inOnTime:=T#500MS,inOffTime:=T#500MS);
                IF _power_progress = 0 THEN
                    Status.Error.Id :=  UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _power_progress := 300;
                END_IF;
                // Start at main running: waiting for the program pointer changed.
                IF _power_progress = 300 THEN  
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#500, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#500;
                    END_IF;

                    Outputs.MoveEnable := TRUE;
                    Outputs.DrivesOff := TRUE;
                    Outputs.ActionNo := BYTE#255;

                    Outputs.StartAtMain := NOT Inputs.PpMoved  AND _blink.output;
                            
                    IF Inputs.PpMoved  THEN
                        THIS.CallTimers(FALSE);
                        Outputs.StartAtMain :=FALSE;
                        _power_progress:=301;                    
                    END_IF;
                END_IF;
                // Start at main finished.
                IF _power_progress = 301 THEN  
                    StartAtMainTask.DoneWhen(TRUE);
                    THIS.CallTimers(FALSE);
                    _power_progress := 0;
                END_IF;

                THIS.CallTimers(TRUE);
                StartAtMainTask.ThrowWhen(_errorTimer.output );
                Status.Action.Id := TO_UINT(_power_progress);
                StartAtMainTask.ThrowWhen(StartAtMainTask.Duration >= Config.TaskTimeout AND Config.TaskTimeout > T#0s ,'<#StartAtMainTask timeout.#>');
            END_IF;
            IF StartAtMainTask.DoneReached() THEN
                Status.Action.Id :=  UINT#101;
                Status.Error.Id :=  UINT#0;
            ELSIF StartAtMainTask.ErrorOccured() THEN
                Status.Action.Id :=  UINT#10000;
                Status.Error.Id  :=  UINT#10000;
            ELSIF StartAtMainTask.AbortTriggered()THEN
                Status.Action.Id :=  UINT#10001;
                Status.Error.Id  :=  UINT#10001;
            END_IF;     
            Messenger.ActivateOnCondition(ULINT#10000,StartAtMainTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#10001,StartAtMainTask.IsAborted(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#102,StartAtMainTask.RestoreTriggered() , eAxoMessageCategory#Info);
            IF StartAtMainTask.RestoreTriggered() AND _power_progress >= 300 AND _power_progress <= 309  THEN
                Status.Action.Id :=  UINT#102;
                _power_progress := 0;
            END_IF;
            //*******************************************

 
            //***********StartMotorsAndProgramTask*******
            StartMotorsAndProgramTask.SetIsDisabled(_stopTasksAreActive OR StartProgramTask.IsBusy() OR StartMotorsTask.IsBusy());
            IF StartMotorsAndProgramTask.StartTriggered() THEN
                Status.Action.Id :=  UINT#110;
            END_IF;
            Messenger.ActivateOnCondition(ULINT#110,StartMotorsAndProgramTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#111,StartMotorsAndProgramTask.IsDone(), eAxoMessageCategory#Info);
            IF StartMotorsAndProgramTask.Execute(THIS) THEN
                _blink.Blink(Context := _context, inOnTime:=T#500MS,inOffTime:=T#500MS);

                IF _power_progress = 0 THEN
                    Status.Error.Id :=  UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _power_progress := 310;
                END_IF;
                // Start motors and program running: waiting for the 'UserSafetySwitchClosed' is on.
                IF _power_progress = 310 THEN 
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#510, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#510;
                    END_IF;
                    Outputs.MoveEnable := TRUE;
                    Outputs.DrivesOff := TRUE;
                    Outputs.ActionNo := BYTE#255;

                    IF Inputs.UserSafetySwitchClosed THEN
                        THIS.CallTimers(FALSE);
                        _power_progress := 311;
                    END_IF;
                END_IF;
                // Start motors and program running: waiting for the 'AlarmStopActive' is on.
                IF _power_progress = 311 THEN	
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#511, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#511;
                    END_IF;

                    IF Inputs.AlarmStopActive THEN
                        THIS.CallTimers(FALSE);
                        _power_progress := 312;
                    END_IF;
                END_IF;
                // Start motors and program running: waiting for the 'DrivesReady' is on.
                IF _power_progress = 312 THEN	
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#512, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#512;
                    END_IF;

                    Outputs.DrivesOff:=TRUE;		
                    Outputs.DrivesOn:=_blink.output;	

                    IF Inputs.DrivesReady THEN
                        Outputs.DrivesOn:=FALSE;
                        THIS.CallTimers(FALSE);
                        _power_progress := 313;
                    END_IF;
                END_IF;
                // Start motors and program running: waiting for the 'StopMess' is off.
                IF _power_progress = 313 THEN	
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#513, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#513;
                    END_IF;

                    Outputs.ErrorConfirmation := Inputs.StopMess AND _blink.output;

                    IF NOT Inputs.StopMess THEN
                         THIS.CallTimers(FALSE);
                         _power_progress := 314;
                    END_IF;
                END_IF;		
                // Start motors and program running: waiting for the 'RcReady' is on.
                IF _power_progress = 314 THEN	
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#514, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#514;
                    END_IF;

                    Outputs.MoveEnable:=TRUE;	

                    IF Inputs.RcReady THEN
                         THIS.CallTimers(FALSE);
                         _power_progress := 315;
                    END_IF;
                END_IF;	
                // Start motors and program running: waiting for the 'InterfaceActivated' is on.
                IF _power_progress = 315 THEN	
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#515, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#515;
                    END_IF;

                    Outputs.ActivateInterface:=TRUE;	

                    IF Inputs.InterfaceActivated THEN
                         THIS.CallTimers(FALSE);
                         _power_progress := 316;
                    END_IF;
                END_IF;	
                // Start motors and program running: waiting for the 'ProActive' is on.
                IF _power_progress = 316 THEN	
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#516, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#516;
                    END_IF;

                    IF Inputs.StopMess OR NOT Inputs.AlarmStopActive OR NOT Inputs.RcReady THEN 
                        _power_progress := 310;
                    END_IF;

                    Outputs.ExternalStart:=_blink.output;	

                    IF Inputs.ProActive THEN
                        Outputs.ExternalStart:=FALSE;	
                        THIS.CallTimers(FALSE);
                         _power_progress := 317;
                    END_IF;
                END_IF;	
                // Start motors and program finished.
                IF _power_progress = 317 THEN	
                    StartMotorsAndProgramTask.DoneWhen(TRUE);
                    THIS.CallTimers(FALSE);
                    _power_progress := 0;
                END_IF;	              

                THIS.CallTimers(TRUE);
                StartMotorsAndProgramTask.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_power_progress);
                StartMotorsAndProgramTask.ThrowWhen(StartMotorsAndProgramTask.Duration >= Config.TaskTimeout AND Config.TaskTimeout > T#0s ,'<#StartMotorsAndProgramTask timeout.#>');
            END_IF;
            IF StartMotorsAndProgramTask.DoneReached() THEN
                Status.Action.Id :=  UINT#111;
                Status.Error.Id :=  UINT#0;
            ELSIF StartMotorsAndProgramTask.ErrorOccured() THEN
                Status.Action.Id :=  UINT#10010;
                Status.Error.Id  :=  UINT#10010;
            ELSIF StartMotorsAndProgramTask.AbortTriggered() THEN
                Status.Action.Id :=  UINT#10011;
                Status.Error.Id  :=  UINT#10011;
            END_IF;         
            Messenger.ActivateOnCondition(ULINT#10010,StartMotorsAndProgramTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#10011,StartMotorsAndProgramTask.IsAborted(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#112,StartMotorsAndProgramTask.RestoreTriggered() , eAxoMessageCategory#Info);
            IF StartMotorsAndProgramTask.RestoreTriggered() AND _power_progress >= 310 AND _power_progress <= 319  THEN
                Status.Action.Id :=  UINT#112;
                _power_progress := 0;
            END_IF;   
            //*******************************************
                        
            //****StartMotorsProgramAndMovementsTask*****
            StartMotorsProgramAndMovementsTask.SetIsDisabled(_stopTasksAreActive OR StartProgramTask.IsBusy() OR StartMotorsTask.IsBusy() OR StartMovementsTask.IsBusy());
            IF StartMotorsProgramAndMovementsTask.StartTriggered() THEN
                Status.Action.Id :=  UINT#120;
            END_IF;
            Messenger.ActivateOnCondition(ULINT#120,StartMotorsProgramAndMovementsTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#121,StartMotorsProgramAndMovementsTask.IsDone(), eAxoMessageCategory#Info);
            IF StartMotorsProgramAndMovementsTask.Execute(THIS) THEN
                _blink.Blink(Context := _context, inOnTime:=T#500MS,inOffTime:=T#500MS);

                IF _power_progress = 0 THEN
                    Status.Error.Id :=  UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _power_progress := 320;
                END_IF;
                // Start motors program and movements running: waiting for the 'UserSafetySwitchClosed' is on.
                IF _power_progress = 320 THEN 
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#520, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#520;
                    END_IF;

                    Outputs.MoveEnable := TRUE;
                    Outputs.DrivesOff := TRUE;
                    Outputs.ActionNo := BYTE#255;

                    IF Inputs.UserSafetySwitchClosed THEN
                        THIS.CallTimers(FALSE);
                        _power_progress := 321;
                    END_IF;
                END_IF;
                // Start motors program and movements running: waiting for the 'AlarmStopActive' is on.
                IF _power_progress = 321 THEN	
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#521, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#521;
                    END_IF;

                    IF Inputs.AlarmStopActive THEN
                        THIS.CallTimers(FALSE);
                        _power_progress := 322;
                    END_IF;
                END_IF;
                // Start motors program and movements running: waiting for the 'DrivesReady' is on.
                IF _power_progress = 322 THEN	
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#522, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#522;
                    END_IF;

                    Outputs.DrivesOff:=TRUE;		
                    Outputs.DrivesOn:=_blink.output;	

                    IF Inputs.DrivesReady THEN
                        Outputs.DrivesOn:=FALSE;
                        THIS.CallTimers(FALSE);
                        _power_progress := 323;
                    END_IF;
                END_IF;
                // Start motors program and movements running: waiting for the 'StopMess' is off.
                IF _power_progress = 323 THEN	
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#523, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#523;
                    END_IF;

                    Outputs.ErrorConfirmation := Inputs.StopMess AND _blink.output;

                    IF NOT Inputs.StopMess THEN
                         THIS.CallTimers(FALSE);
                         _power_progress := 324;
                    END_IF;
                END_IF;		
                // Start motors program and movements running: waiting for the 'RcReady' is on.
                IF _power_progress = 324 THEN	
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#524, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#524;
                    END_IF;

                    Outputs.MoveEnable:=TRUE;	

                    IF Inputs.RcReady THEN
                         THIS.CallTimers(FALSE);
                         _power_progress := 325;
                    END_IF;
                END_IF;	
                // Start motors program and movements running: waiting for the 'InterfaceActivated' is on.
                IF _power_progress = 325 THEN	
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#525, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#525;
                    END_IF;

                    Outputs.ActivateInterface:=TRUE;	

                    IF Inputs.InterfaceActivated THEN
                         THIS.CallTimers(FALSE);
                         _power_progress := 326;
                    END_IF;
                END_IF;	
                // Start motors program and movements running: waiting for the 'ProActive' is on.
                IF _power_progress = 326 THEN	
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#526, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#526;
                    END_IF;

                    IF Inputs.StopMess OR NOT Inputs.AlarmStopActive OR NOT Inputs.RcReady THEN 
                        _power_progress := 320;
                    END_IF;
                    
                    IF NOT Inputs.ProActive AND Inputs.Error THEN  
                        Outputs.StartAtMain := _blink.output AND NOT Inputs.PpMoved;
                    ELSE
                        Outputs.ExternalStart:=_blink.output;	
                    END_IF;                        

                    IF Inputs.ProActive THEN
                        Outputs.ExternalStart:=FALSE;	
                        THIS.CallTimers(FALSE);
                         _power_progress := 327;
                    END_IF;
                END_IF;
                // Start motors program and movements running: sending parameters of the movement to the controller.
                IF _power_progress = 327 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#527, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#527;
                    END_IF;

                    Outputs.GlobalSpeed     := Status.CurrentMovementParameters.GlobalSpeed;
                    Outputs.ToolNo          := Status.CurrentMovementParameters.ToolNo;
                    Outputs.WorkobjectNo    := Status.CurrentMovementParameters.WorkobjectNo;
                    Outputs.PointNo         := Status.CurrentMovementParameters.PointNo;
                    Outputs.UserSpecSpeed1  := Status.CurrentMovementParameters.UserSpecSpeed1;
                    Outputs.UserSpecSpeed2  := Status.CurrentMovementParameters.UserSpecSpeed2;
                    Outputs.Coordinates     := Status.CurrentMovementParameters.Coordinates; 		
                
                    Outputs.ActionNo := BYTE#254;

                    IF Outputs.ActionNo = Inputs.ActionNo THEN
                        THIS.CallTimers(FALSE);
                        _power_progress := 328;
                    END_IF;
                END_IF;
                // Start motors program and movements running: waiting for the movement parameters sent to the controller to be mirrored back.
                IF _power_progress = 328 THEN
                    IF _infoTimer.output THEN
                        IF Inputs.GlobalSpeed <> Status.CurrentMovementParameters.GlobalSpeed THEN
                            TaskMessenger.Activate( UINT#528, eAxoMessageCategory#Potential);
                            Status.Error.Id :=      UINT#528;//<#Waiting for Inputs.GlobalSpeed to be equal to MovementParameters.GlobalSpeed!
                        END_IF;
                        IF Inputs.ToolNo <> Status.CurrentMovementParameters.ToolNo THEN
                            TaskMessenger.Activate( UINT#529, eAxoMessageCategory#Potential);
                            Status.Error.Id :=      UINT#529;//<#Waiting for Inputs.ToolNo to be equal to MovementParameters.ToolNo!
                        END_IF;
                        IF Inputs.WorkobjectNo <> Status.CurrentMovementParameters.WorkobjectNo THEN
                            TaskMessenger.Activate( UINT#530, eAxoMessageCategory#Potential);
                            Status.Error.Id :=      UINT#530;//<#Waiting for Inputs.WorkobjectNo to be equal to MovementParameters.WorkobjectNo!
                        END_IF;
                        IF Inputs.PointNo <> Status.CurrentMovementParameters.PointNo THEN
                            TaskMessenger.Activate( UINT#531, eAxoMessageCategory#Potential);
                            Status.Error.Id :=      UINT#531;//<#Waiting for Inputs.PointNo to be equal to MovementParameters.PointNo!
                        END_IF;
                        IF Inputs.UserSpecSpeed1 <> Status.CurrentMovementParameters.UserSpecSpeed1 THEN
                            TaskMessenger.Activate( UINT#532, eAxoMessageCategory#Potential);
                            Status.Error.Id :=      UINT#532;//<#Waiting for Inputs.UserSpecSpeed1 to be equal to MovementParameters.UserSpecSpeed1!
                        END_IF;
                        IF Inputs.UserSpecSpeed2 <> Status.CurrentMovementParameters.UserSpecSpeed2 THEN
                            TaskMessenger.Activate( UINT#533, eAxoMessageCategory#Potential);
                            Status.Error.Id :=      UINT#533;//<#Waiting for Inputs.UserSpecSpeed2 to be equal to MovementParameters.UserSpecSpeed2!
                        END_IF;
                    END_IF;

                    IF 	Inputs.GlobalSpeed      = Status.CurrentMovementParameters.GlobalSpeed AND
                        Inputs.ToolNo           = Status.CurrentMovementParameters.ToolNo AND
                        Inputs.WorkobjectNo     = Status.CurrentMovementParameters.WorkobjectNo AND
                        Inputs.PointNo          = Status.CurrentMovementParameters.PointNo AND
                        Inputs.UserSpecSpeed1   = Status.CurrentMovementParameters.UserSpecSpeed1 AND
                        Inputs.UserSpecSpeed2   = Status.CurrentMovementParameters.UserSpecSpeed2 AND
                        AXOpen.Components.Robotics.CoordinatesAreNearlyEqual(Inputs.Coordinates,Status.CurrentMovementParameters.Coordinates,REAL#0.01,REAL#0.01,REAL#0.01,REAL#0.01,REAL#0.01,REAL#0.01) THEN
                        THIS.CallTimers(FALSE);
                        _power_progress:=334;
                    END_IF;
                END_IF;		
                // Start motors program and movements running: acknowleadging of the movement parameters.
                IF _power_progress = 334 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#534, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#534;
                    END_IF;

                    Outputs.ActionNo := BYTE#253;

                    IF Outputs.ActionNo = Inputs.ActionNo THEN
                        THIS.CallTimers(FALSE);
                        _power_progress:=335;
                    END_IF;
                END_IF;	
                // Start motors program and movements running: waiting for the movement is finished.
                IF _power_progress = 335 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#535, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#535;
                    END_IF;
                    
                    _movementExecuting := TRUE;

                    Outputs.ActionNo := Status.CurrentMovementParameters.ActionNo;
	
                    IF Outputs.ActionNo = Inputs.ActionNo THEN
                        THIS.CallTimers(FALSE);
                        _power_progress:=336;
                    END_IF;
                END_IF;	
                // Start motors program and movements running: acknowleadging of the finished movement.
                IF _power_progress = 336 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#536, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#536;
                    END_IF;

                    Outputs.ActionNo := BYTE#255;

                    IF Outputs.ActionNo = Inputs.ActionNo THEN
                        THIS.CallTimers(FALSE);
                        _power_progress := 337;
                    END_IF;
                END_IF;	
                // Start motors program and movements finished.
                IF _power_progress = 337 THEN
                    _power_progress := 0;
                    StartMotorsProgramAndMovementsTask.DoneWhen(TRUE);
                END_IF;	

                THIS.CallTimers(NOT _movementExecuting);
                StartMotorsProgramAndMovementsTask.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_power_progress);
                StartMotorsProgramAndMovementsTask.ThrowWhen(StartMotorsProgramAndMovementsTask.Duration >= Config.TaskTimeout AND Config.TaskTimeout > T#0s ,'<#StartMotorsProgramAndMovementsTask timeout.#>');
            END_IF;
            IF StartMotorsProgramAndMovementsTask.IsFirstExecutionCycle() THEN
                MovementParameters := Status.CurrentMovementParameters;
            END_IF;
            IF StartMotorsProgramAndMovementsTask.DoneReached() THEN
                Status.Action.Id :=  UINT#121;
                Status.Error.Id :=  UINT#0;
            ELSIF StartMotorsProgramAndMovementsTask.ErrorOccured() THEN
                Status.Action.Id :=  UINT#10020;
                Status.Error.Id  :=  UINT#10020;
            ELSIF StartMotorsProgramAndMovementsTask.AbortTriggered() THEN
                Status.Action.Id :=  UINT#10021;
                Status.Error.Id  :=  UINT#10021;
            END_IF; 
            Messenger.ActivateOnCondition(ULINT#10020,StartMotorsProgramAndMovementsTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#10021,StartMotorsProgramAndMovementsTask.IsAborted(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#122,StartMotorsProgramAndMovementsTask.RestoreTriggered() , eAxoMessageCategory#Info);
            IF StartMotorsProgramAndMovementsTask.RestoreTriggered() AND _power_progress >= 320 AND _power_progress <= 339  THEN
                Status.Action.Id :=  UINT#122;
                _power_progress := 0;
            END_IF;  
            //*******************************************

            //***********StartMotorsTask*****************
            StartMotorsTask.SetIsDisabled(_stopTasksAreActive OR StartMotorsProgramAndMovementsTask.IsBusy() OR StartMotorsAndProgramTask.IsBusy());
            IF StartMotorsTask.StartTriggered() THEN
                Status.Action.Id :=  UINT#140;
            END_IF;
            Messenger.ActivateOnCondition(ULINT#140,StartMotorsTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#141,StartMotorsTask.IsDone(), eAxoMessageCategory#Info);
            IF StartMotorsTask.Execute(THIS) THEN
                _blink.Blink(Context := _context, inOnTime:=T#500MS,inOffTime:=T#500MS);

                IF _power_progress = 0 THEN
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _power_progress := 340;
                END_IF;
                // Start motors running: waiting for the 'UserSafetySwitchClosed' is on.
                IF _power_progress = 340 THEN 
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#540, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#540;
                    END_IF;
                    Outputs.MoveEnable := TRUE;
                    Outputs.DrivesOff := TRUE;

                    IF Inputs.UserSafetySwitchClosed THEN
                        THIS.CallTimers(FALSE);
                        _power_progress := 341;
                    END_IF;
                END_IF;
                // Start motors running: waiting for the 'AlarmStopActive' is on.
                IF _power_progress = 341 THEN	
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#541, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#541;
                    END_IF;

                    IF Inputs.AlarmStopActive THEN
                        THIS.CallTimers(FALSE);
                        _power_progress := 342;
                    END_IF;
                END_IF;
                // Start motors running: waiting for the 'DrivesReady' is on.
                IF _power_progress = 342 THEN	
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#542, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#542;
                    END_IF;

                    Outputs.DrivesOff:=TRUE;
                    Outputs.DrivesOn:=_blink.output;	

                    IF Inputs.DrivesReady  THEN
                        Outputs.DrivesOn:=FALSE;
                        THIS.CallTimers(FALSE);
                        _power_progress := 343;
                    END_IF;
                END_IF;
                // Start motors finished.
                IF _power_progress = 343 THEN	
                    StartMotorsTask.DoneWhen(TRUE);
                    THIS.CallTimers(FALSE);
                    _power_progress := 0;
                END_IF;	              

                THIS.CallTimers(TRUE);
                StartMotorsTask.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_power_progress);
            END_IF;
            IF StartMotorsTask.DoneReached() THEN
                Status.Action.Id :=  UINT#141;
                Status.Error.Id :=  UINT#0;
            ELSIF StartMotorsTask.ErrorOccured() THEN
                Status.Action.Id :=  UINT#10040;
                Status.Error.Id  :=  UINT#10040;
            ELSIF StartMotorsTask.AbortTriggered() THEN
                Status.Action.Id :=  UINT#10041;
                Status.Error.Id  :=  UINT#10041;
            END_IF;    
            Messenger.ActivateOnCondition(ULINT#10040,StartMotorsTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#10041,StartMotorsTask.IsAborted(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#142,StartMotorsTask.RestoreTriggered() , eAxoMessageCategory#Info);
            IF StartMotorsTask.RestoreTriggered() AND _power_progress >= 340 AND _power_progress <= 349 THEN
                Status.Action.Id :=  UINT#142;
                _power_progress := 0;
            END_IF;  
            //*******************************************
  
            //***********StartMovementsTask**************
            StartMovementsTask.SetIsDisabled(FALSE);
            IF StartMovementsTask.StartTriggered() THEN
                Status.Action.Id :=  UINT#150;
            END_IF;
            Messenger.ActivateOnCondition(ULINT#150,StartMovementsTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#151,StartMovementsTask.IsDone(), eAxoMessageCategory#Info);
            IF StartMovementsTask.Execute(THIS) THEN
                IF _movement_progress = 0 THEN
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _movement_progress := 350;
                END_IF;
                // Start movements running: waiting for the 'ProActive' is on.
                IF _movement_progress = 350 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#550, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#550;
                    END_IF;
                    Outputs.MoveEnable := TRUE;
                    Outputs.DrivesOff := TRUE;

                    IF Inputs.ProActive THEN
                        THIS.CallTimers(FALSE);
                        _movement_progress := 351;
                    END_IF;
                END_IF;
                // Start movements running: waiting for the 'DrivesReady' is on.
                IF _movement_progress = 351 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#551, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#551;
                    END_IF;

                    IF Inputs.DrivesReady THEN
                        THIS.CallTimers(FALSE);
                        _movement_progress := 352;
                    END_IF;
                END_IF;
                // Start movements running: waiting for the 'StopMess' is off.
                IF _movement_progress = 352 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#552, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#552;
                    END_IF;
                                        
                    IF NOT Inputs.StopMess THEN
                        THIS.CallTimers(FALSE);
                        _movement_progress := 353;
                    END_IF;
                END_IF;
                // Start movements running: sending parameters of the movement to the controller.
                IF _movement_progress = 353 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#553, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#553;
                    END_IF;
                            
                    Outputs.GlobalSpeed     := Status.CurrentMovementParameters.GlobalSpeed;
                    Outputs.ToolNo          := Status.CurrentMovementParameters.ToolNo;
                    Outputs.WorkobjectNo    := Status.CurrentMovementParameters.WorkobjectNo;
                    Outputs.PointNo         := Status.CurrentMovementParameters.PointNo;
                    Outputs.UserSpecSpeed1  := Status.CurrentMovementParameters.UserSpecSpeed1;
                    Outputs.UserSpecSpeed2  := Status.CurrentMovementParameters.UserSpecSpeed2;
                    Outputs.Coordinates     := Status.CurrentMovementParameters.Coordinates; 		
                
                    Outputs.ActionNo := BYTE#254;

                    IF Outputs.ActionNo = Inputs.ActionNo THEN
                        THIS.CallTimers(FALSE);
                        _movement_progress := 354;
                    END_IF;
                END_IF;
                // Start movements running: waiting for the movement parameters sent to the controller to be mirrored back.
                IF _movement_progress = 354 THEN
                    IF _infoTimer.output THEN
                        IF Inputs.GlobalSpeed <> Status.CurrentMovementParameters.GlobalSpeed THEN
                            TaskMessenger.Activate( UINT#554, eAxoMessageCategory#Potential);
                            Status.Error.Id :=      UINT#554;//<#Waiting for Inputs.GlobalSpeed to be equal to MovementParameters.GlobalSpeed!
                        END_IF;
                        IF Inputs.ToolNo <> Status.CurrentMovementParameters.ToolNo THEN
                            TaskMessenger.Activate( UINT#555, eAxoMessageCategory#Potential);
                            Status.Error.Id :=      UINT#555;//<#Waiting for Inputs.ToolNo to be equal to MovementParameters.ToolNo!
                        END_IF;
                        IF Inputs.WorkobjectNo <> Status.CurrentMovementParameters.WorkobjectNo THEN
                            TaskMessenger.Activate( UINT#556, eAxoMessageCategory#Potential);
                            Status.Error.Id :=      UINT#556;//<#Waiting for Inputs.WorkobjectNo to be equal to MovementParameters.WorkobjectNo!
                        END_IF;
                        IF Inputs.PointNo <> Status.CurrentMovementParameters.PointNo THEN
                            TaskMessenger.Activate( UINT#557, eAxoMessageCategory#Potential);
                            Status.Error.Id :=      UINT#557;//<#Waiting for Inputs.PointNo to be equal to MovementParameters.PointNo!
                        END_IF;
                        IF Inputs.UserSpecSpeed1 <> Status.CurrentMovementParameters.UserSpecSpeed1 THEN
                            TaskMessenger.Activate( UINT#558, eAxoMessageCategory#Potential);
                            Status.Error.Id :=      UINT#558;//<#Waiting for Inputs.UserSpecSpeed1 to be equal to MovementParameters.UserSpecSpeed1!
                        END_IF;
                        IF Inputs.UserSpecSpeed2 <> Status.CurrentMovementParameters.UserSpecSpeed2 THEN
                            TaskMessenger.Activate( UINT#559, eAxoMessageCategory#Potential);
                            Status.Error.Id :=      UINT#559;//<#Waiting for Inputs.UserSpecSpeed2 to be equal to MovementParameters.UserSpecSpeed2!
                        END_IF;
                    END_IF;

                    IF 	Inputs.GlobalSpeed      = Status.CurrentMovementParameters.GlobalSpeed AND
                        Inputs.ToolNo           = Status.CurrentMovementParameters.ToolNo AND
                        Inputs.WorkobjectNo     = Status.CurrentMovementParameters.WorkobjectNo AND
                        Inputs.PointNo          = Status.CurrentMovementParameters.PointNo AND
                        Inputs.UserSpecSpeed1   = Status.CurrentMovementParameters.UserSpecSpeed1 AND
                        Inputs.UserSpecSpeed2   = Status.CurrentMovementParameters.UserSpecSpeed2 AND
                        AXOpen.Components.Robotics.CoordinatesAreNearlyEqual(Inputs.Coordinates,Status.CurrentMovementParameters.Coordinates,REAL#0.01,REAL#0.01,REAL#0.01,REAL#0.01,REAL#0.01,REAL#0.01) THEN
                        THIS.CallTimers(FALSE);
                        _movement_progress:=360;
                    END_IF;
                END_IF;		
                // Start movements running: acknowleadging of the movement parameters.
                IF _movement_progress = 360 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#560, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#560;
                    END_IF;

                    Outputs.ActionNo := BYTE#253;

                    IF Outputs.ActionNo = Inputs.ActionNo THEN
                        THIS.CallTimers(FALSE);
                        _movement_progress:=361;
                    END_IF;
                END_IF;	
                // Start movements running: waiting for the movement is finished.
                IF _movement_progress = 361 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#561, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#561;
                    END_IF;

                    _movementExecuting := TRUE;

                    Outputs.ActionNo := Status.CurrentMovementParameters.ActionNo;

                    IF Outputs.ActionNo = Inputs.ActionNo THEN
                        THIS.CallTimers(FALSE);
                        _movement_progress:=362;
                    END_IF;
                END_IF;	
                // Start movements running: acknowleadging of the finished movement.
                IF _movement_progress = 362 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#562, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#562;
                    END_IF;

                    Outputs.ActionNo := BYTE#255;

                    IF Outputs.ActionNo = Inputs.ActionNo THEN
                        THIS.CallTimers(FALSE);
                        _movement_progress := 363;
                    END_IF;
                END_IF;	
                // Start movements finished.
                IF _movement_progress = 363 THEN
                    _movement_progress := 0;
                    THIS.CallTimers(FALSE);
                    StartMovementsTask.DoneWhen(TRUE);
                END_IF;	

	            THIS.CallTimers(NOT _movementExecuting);
                
                StartMovementsTask.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_movement_progress);
                StartMovementsTask.ThrowWhen(StartMovementsTask.Duration >= Config.TaskTimeout AND Config.TaskTimeout > T#0s ,'<#StartMovementsTask timeout.#>');
            END_IF;
            IF StartMovementsTask.IsFirstExecutionCycle() THEN
                MovementParameters := Status.CurrentMovementParameters;
            END_IF;
            IF StartMovementsTask.DoneReached() THEN
                Status.Action.Id :=  UINT#151;
                Status.Error.Id :=  UINT#0;
            ELSIF StartMovementsTask.ErrorOccured() THEN
                Status.Action.Id :=  UINT#10050;
                Status.Error.Id  :=  UINT#10050;
            ELSIF StartMovementsTask.AbortTriggered() THEN
                Status.Action.Id :=  UINT#10051;
                Status.Error.Id  :=  UINT#10051;
            END_IF;    
            Messenger.ActivateOnCondition(ULINT#10050,StartMovementsTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#10051,StartMovementsTask.IsAborted(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#152,StartMovementsTask.RestoreTriggered() , eAxoMessageCategory#Info);
            IF StartMovementsTask.RestoreTriggered() AND _movement_progress >= 350 AND _movement_progress <= 369 THEN
                Status.Action.Id :=  UINT#152;
                _movement_progress := 0;
            END_IF;  
            //*******************************************
  
            //***********StartProgramTask****************
            StartProgramTask.SetIsDisabled(_stopTasksAreActive);
            IF StartAtMainTask.StartTriggered() THEN
                Status.Action.Id :=  UINT#170;
            END_IF;
            Messenger.ActivateOnCondition(ULINT#170,StartAtMainTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#171,StartAtMainTask.IsDone(), eAxoMessageCategory#Info);
            IF StartProgramTask.Execute(THIS) THEN
                _blink.Blink(Context := _context, inOnTime:=T#500MS,inOffTime:=T#500MS);

                IF _power_progress = 0 THEN
                    Status.Error.Id :=  UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _power_progress := 370;
                END_IF;
                // Start program running: waiting for the 'UserSafetySwitchClosed' is on.
                IF _power_progress = 370 THEN 
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#570, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#570;
                    END_IF;
                    Outputs.MoveEnable := TRUE;
                    Outputs.DrivesOff := TRUE;
                    Outputs.ActionNo := BYTE#255;
                    
                    IF  Inputs.UserSafetySwitchClosed THEN
                        THIS.CallTimers(FALSE);
                        _power_progress := 371;
                    END_IF;
                END_IF;
                // Start program running: waiting for the 'AlarmStopActive' is on.
                IF _power_progress = 371 THEN 
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#571, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#571;
                    END_IF;

                    IF Inputs.AlarmStopActive THEN
                        THIS.CallTimers(FALSE);
                        _power_progress := 372;
                    END_IF;
                END_IF;
                // Start program running: waiting for the 'DrivesReady' is on.
                IF _power_progress = 372 THEN 
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#572, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#572;
                    END_IF;
		
                    Outputs.DrivesOff:=TRUE;		
                    Outputs.DrivesOn:=_blink.output;
                    IF Inputs.DrivesReady  THEN
                        Outputs.DrivesOn:=FALSE;
                        THIS.CallTimers(FALSE);
                        _power_progress := 373;
                    END_IF;
                END_IF;
                // Start program running: waiting for the 'StopMess' is off.
                IF _power_progress = 373 THEN 
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#573, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#573;
                    END_IF;

                    Outputs.ErrorConfirmation := Inputs.StopMess AND _blink.output;
                    
                    IF NOT Inputs.StopMess THEN
                        Outputs.ErrorConfirmation:=FALSE;
                        THIS.CallTimers(FALSE);
                        _power_progress := 374;
                    END_IF;
                END_IF;
                // Start program running: waiting for the 'RcReady' is on.
                IF _power_progress = 374 THEN 
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#574, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#574;
                    END_IF;

                    Outputs.MoveEnable:=TRUE;
                    
                    IF Inputs.RcReady THEN
                        THIS.CallTimers(FALSE);
                        _power_progress := 375;
                    END_IF;
                END_IF;
                // Start program running: waiting for the 'InterfaceActivated' is on.
                IF _power_progress = 375 THEN 
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#575, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#575;
                    END_IF;

                    Outputs.ActivateInterface:=TRUE;
                    
                    IF Inputs.InterfaceActivated THEN
                        THIS.CallTimers(FALSE);
                        _power_progress := 376;
                    END_IF;
                END_IF;
                // Start program running: waiting for the 'ProActive' is on.
                IF _power_progress = 376 THEN 
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#576, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#576;
                    END_IF;

                    IF Inputs.StopMess OR NOT Inputs.AlarmStopActive OR NOT Inputs.RcReady THEN 
                        _power_progress := 370;
                    END_IF;

                    Outputs.ExternalStart:=_blink.output;
                    
                    IF Inputs.ProActive THEN
                        Outputs.ExternalStart:= FALSE;
                        THIS.CallTimers(FALSE);
                        _power_progress := 377;
                    END_IF;
                END_IF;
                // Start program finished.
                IF _power_progress = 377 THEN	
                    StartProgramTask.DoneWhen(TRUE);
                    THIS.CallTimers(FALSE);
                    _power_progress := 0;
                END_IF;	              

                THIS.CallTimers(TRUE);
                StartProgramTask.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_power_progress);
                StartProgramTask.ThrowWhen(StartProgramTask.Duration >= Config.TaskTimeout AND Config.TaskTimeout > T#0s ,'<#StartProgramTask timeout.#>');
            END_IF;
            IF StartProgramTask.DoneReached() THEN
                Status.Action.Id :=  UINT#171;
                Status.Error.Id :=  UINT#0;
            ELSIF StartProgramTask.ErrorOccured() THEN
                Status.Action.Id :=  UINT#10070;
                Status.Error.Id  :=  UINT#10070;
            ELSIF StartProgramTask.AbortTriggered()THEN
                Status.Action.Id :=  UINT#10071;
                Status.Error.Id  :=  UINT#10071;
            END_IF;     
            Messenger.ActivateOnCondition(ULINT#10070,StartProgramTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#10071,StartProgramTask.IsAborted(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#172,StartProgramTask.RestoreTriggered() , eAxoMessageCategory#Info);
            IF StartProgramTask.RestoreTriggered() AND _power_progress >= 370 AND _power_progress <= 379  THEN
                Status.Action.Id :=  UINT#172;
                _power_progress := 0;
            END_IF;
            //*******************************************
 
            //***********StopMotorsTask******************
            StopMotorsTask.SetIsDisabled(FALSE);
            IF StartAtMainTask.StartTriggered() THEN
                Status.Action.Id :=  UINT#180;
            END_IF;
            Messenger.ActivateOnCondition(ULINT#180,StartAtMainTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#181,StartAtMainTask.IsDone(), eAxoMessageCategory#Info);
            IF StopMotorsTask.Execute(THIS) THEN
                _blink.Blink(Context := _context, inOnTime:=T#500MS,inOffTime:=T#500MS);

                IF _power_progress = 0 THEN
                    Status.Error.Id :=  UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _power_progress := 380;
                END_IF;
                // Stop motors running: waiting for the 'DrivesReady' is off.
                IF _power_progress = 380 THEN 
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#580, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#580;
                    END_IF;

                    Outputs.DrivesOn :=TRUE;
                    Outputs.DrivesOff := _blink.output;
                    
                    IF NOT Inputs.DrivesReady  THEN
                        Outputs.DrivesOff :=FALSE;
                        THIS.CallTimers(FALSE);
                        _power_progress := 381;
                    END_IF;
                END_IF;
                // Stop motors finished.
                IF _power_progress = 381 THEN	
                    StopMotorsTask.DoneWhen(TRUE);
                    THIS.CallTimers(FALSE);
                    _power_progress := 0;
                END_IF;	              

                THIS.CallTimers(TRUE);
                StopMotorsTask.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_power_progress);
                StopMotorsTask.ThrowWhen(StopMotorsTask.Duration >= Config.TaskTimeout AND Config.TaskTimeout > T#0s ,'<#StopMotorsTask timeout.#>');
            END_IF;
            IF StopMotorsTask.DoneReached() THEN
                Status.Action.Id :=  UINT#181;
                Status.Error.Id :=  UINT#0;
            ELSIF StopMotorsTask.ErrorOccured() THEN
                Status.Action.Id :=  UINT#10080;
                Status.Error.Id  :=  UINT#10080;
            ELSIF StopMotorsTask.AbortTriggered()THEN
                Status.Action.Id :=  UINT#10081;
                Status.Error.Id  :=  UINT#10081;
            END_IF;     
            Messenger.ActivateOnCondition(ULINT#10080,StopMotorsTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#10081,StopMotorsTask.IsAborted(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#182,StopMotorsTask.RestoreTriggered() , eAxoMessageCategory#Info);
            IF StopMotorsTask.RestoreTriggered() AND _power_progress >= 380 AND _power_progress <= 389  THEN
                Status.Action.Id :=  UINT#182;
                _power_progress := 0;
            END_IF;
            //*******************************************

            //***********StopMovementsAndProgramTask*****
            StopMovementsAndProgramTask.SetIsDisabled(FALSE);
            IF StopMovementsAndProgramTask.StartTriggered() THEN
                Status.Action.Id :=  UINT#190;
            END_IF;
            Messenger.ActivateOnCondition(ULINT#190,StopMovementsAndProgramTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#191,StopMovementsAndProgramTask.IsDone(), eAxoMessageCategory#Info);
            IF StopMovementsAndProgramTask.Execute(THIS) THEN
                IF _power_progress = 0 THEN
                    _movement_progress := 0;
                    Status.Error.Id :=  UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _power_progress := 390;
                END_IF;
                // Stop movements and program running: waiting for the 'RobotStopped' is on.
                IF _power_progress = 390 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#590, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#590;
                    END_IF;

                    Outputs.MoveEnable := FALSE;

                    IF Inputs.RobotStopped THEN
                        THIS.CallTimers(FALSE);
                        _power_progress := 391;
                    END_IF;
                END_IF;
                // Stop movements and program running: waiting for the 'ProActive' is off.
                IF _power_progress = 391 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#591, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#591;
                    END_IF;

                    IF NOT Inputs.ProActive THEN
                        THIS.CallTimers(FALSE);
                        _power_progress := 392;
                    END_IF;
                END_IF;
                // Stop movements and program finished.
                IF _power_progress = 392 THEN
                    StopMovementsAndProgramTask.DoneWhen(TRUE);
                    _power_progress := 0;
                END_IF;		

                THIS.CallTimers(TRUE);
                
                StopMovementsAndProgramTask.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_power_progress);
                StopMovementsAndProgramTask.ThrowWhen(StopMovementsAndProgramTask.Duration >= Config.TaskTimeout AND Config.TaskTimeout > T#0s ,'<#StopMovementsAndProgramTask timeout.#>');
            END_IF;
            IF StopMovementsAndProgramTask.DoneReached() THEN
                Status.Action.Id :=  UINT#191;
                Status.Error.Id :=  UINT#0;
            ELSIF StopMovementsAndProgramTask.ErrorOccured() THEN
                Status.Action.Id :=  UINT#10090;
                Status.Error.Id  :=  UINT#10090;
            ELSIF StopMovementsAndProgramTask.AbortTriggered()THEN
                Status.Action.Id :=  UINT#10091;
                Status.Error.Id  :=  UINT#10091;
            END_IF;     
            Messenger.ActivateOnCondition(ULINT#10090,StopMovementsAndProgramTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#10091,StopMovementsAndProgramTask.IsAborted(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#192,StopMovementsAndProgramTask.RestoreTriggered() , eAxoMessageCategory#Info);
            IF StopMovementsAndProgramTask.RestoreTriggered() AND _power_progress >= 390 AND _power_progress <= 399  THEN
                Status.Action.Id :=  UINT#192;
                _power_progress := 0;
            END_IF;
            //*******************************************
            
            //***********StopMovementsTask***************
            StopMovementsTask.SetIsDisabled(FALSE);
            IF StopMovementsTask.StartTriggered() THEN
                Status.Action.Id :=  UINT#400;
            END_IF;
            Messenger.ActivateOnCondition(ULINT#200,StopMovementsTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#201,StopMovementsTask.IsDone(), eAxoMessageCategory#Info);
            IF StopMovementsTask.Execute(THIS) THEN
                IF _power_progress = 0 THEN
                    Status.Error.Id :=  UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _power_progress := 400;
                END_IF;
                // Stop movements running: waiting for the 'RobotStopped' is on.
                IF _power_progress = 400 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#600, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#600;
                    END_IF;

                    Outputs.MoveEnable := FALSE;

                    IF Inputs.RobotStopped THEN
                        THIS.CallTimers(FALSE);
                        _power_progress := 401;
                    END_IF;
                END_IF;
                // Stop movements finished.
                IF _power_progress = 401 THEN
                    _power_progress := 0;
                    StopMovementsTask.DoneWhen(TRUE);
                END_IF;		


                THIS.CallTimers(TRUE);
                
                StopMovementsTask.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_power_progress);
                StopMovementsTask.ThrowWhen(StopMovementsTask.Duration >= Config.TaskTimeout AND Config.TaskTimeout > T#0s ,'<#StopMovementsTask timeout.#>');
            END_IF;
            IF StopMovementsTask.DoneReached() THEN
                Status.Action.Id :=  UINT#201;
                Status.Error.Id :=  UINT#0;
            ELSIF StopMovementsTask.ErrorOccured() THEN
                Status.Action.Id :=  UINT#10100;
                Status.Error.Id  :=  UINT#10100;
            ELSIF StopMovementsTask.AbortTriggered()THEN
                Status.Action.Id :=  UINT#10101;
                Status.Error.Id  :=  UINT#10101;
            END_IF;     
            Messenger.ActivateOnCondition(ULINT#10100,StopMovementsTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#10101,StopMovementsTask.IsAborted(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#202,StopMovementsTask.RestoreTriggered() , eAxoMessageCategory#Info);
            IF StopMovementsTask.RestoreTriggered() AND _power_progress >= 400 AND _power_progress <= 409  THEN
                Status.Action.Id :=  UINT#202;
                _power_progress := 0;
            END_IF;
            //*******************************************

            //***********StopProgramTask*****************
            StopProgramTask.SetIsDisabled(FALSE);
            IF StopProgramTask.StartTriggered() THEN
                Status.Action.Id :=  UINT#210;
            END_IF;
            Messenger.ActivateOnCondition(ULINT#210,StopProgramTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#211,StopProgramTask.IsDone(), eAxoMessageCategory#Info);
            IF StopProgramTask.Execute(THIS) THEN
                IF _power_progress = 0 THEN
                    Status.Error.Id :=  UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _power_progress := 410;
                END_IF;
                // Stop program running: waiting for the 'ProActive' is off.
                IF _power_progress = 410 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#610, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#610;
                    END_IF;

                    Outputs.MoveEnable:=FALSE;

                    IF NOT Inputs.ProActive THEN
                        THIS.CallTimers(FALSE);
                        _power_progress := 411;
                    END_IF;
                END_IF;
                // Stop program finished.
                IF _power_progress = 411 THEN
                    StopProgramTask.DoneWhen(TRUE);
                    _power_progress := 0;
                END_IF;		

                THIS.CallTimers(TRUE);
                
                StopProgramTask.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_power_progress);
                StopProgramTask.ThrowWhen(StopProgramTask.Duration >= Config.TaskTimeout AND Config.TaskTimeout > T#0s ,'<#StopProgramTask timeout.#>');
            END_IF;
            IF StopProgramTask.DoneReached() THEN
                Status.Action.Id :=  UINT#911;
                Status.Error.Id :=  UINT#0;
            ELSIF StopProgramTask.ErrorOccured() THEN
                Status.Action.Id :=  UINT#10110;
                Status.Error.Id  :=  UINT#10110;
            ELSIF StopProgramTask.AbortTriggered()THEN
                Status.Action.Id :=  UINT#10111;
                Status.Error.Id  :=  UINT#10111;
            END_IF;     
            Messenger.ActivateOnCondition(ULINT#10110,StopProgramTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#10111,StopProgramTask.IsAborted(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#212,StopProgramTask.RestoreTriggered() , eAxoMessageCategory#Info);
            IF StopProgramTask.RestoreTriggered() AND _power_progress >= 410 AND _power_progress <= 419  THEN
                Status.Action.Id :=  UINT#912;
                _power_progress := 0;
            END_IF;
            //*******************************************
            
            //***********ResetAllOutputsTask*****************
            ResetAllOutputsTask.SetIsDisabled(FALSE);
            IF ResetAllOutputsTask.StartTriggered() THEN
                Status.Action.Id :=  UINT#220;
            END_IF;
            Messenger.ActivateOnCondition(ULINT#220,ResetAllOutputsTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#221,ResetAllOutputsTask.IsDone(), eAxoMessageCategory#Info);
            IF ResetAllOutputsTask.Execute(THIS) THEN
                IF _power_progress = 0 THEN
                    Status.Error.Id :=  UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _power_progress := 420;
                END_IF;
                // Reset all outputs running: 
                IF _power_progress = 420 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#620, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#620;
                    END_IF;

                    Outputs.ExternalStart       :=      FALSE;
                    Outputs.MoveEnable          :=      FALSE;
                    Outputs.ErrorConfirmation   :=      FALSE;
                    Outputs.DrivesOff           :=      FALSE;
                    Outputs.DrivesOn            :=      FALSE;
                    Outputs.ActivateInterface   :=      FALSE;
                    Outputs.StartAtMain         :=      FALSE;

                    Outputs.MasterMode          :=      BYTE#0;
                
                    Outputs.Tool_1_Retract      :=      FALSE;
                    Outputs.Tool_1_Extend       :=      FALSE;
                    Outputs.Tool_2_Retract      :=      FALSE;
                    Outputs.Tool_2_Extend       :=      FALSE;
                    Outputs.Tool_3_Retract      :=      FALSE;
                    Outputs.Tool_3_Extend       :=      FALSE;
                    Outputs.Tool_4_Retract      :=      FALSE;
                    Outputs.Tool_4_Extend       :=      FALSE;
                
                    Outputs.Zone                :=      BYTE#0;
                    Outputs.InPosition          :=      BYTE#0;
                    Outputs.ActionNo            :=      BYTE#0; 
                    Outputs.GlobalSpeed         :=      BYTE#0; 
                    Outputs.ToolNo              :=      BYTE#0; 	
                    Outputs.WorkobjectNo        :=      BYTE#0; 
                    Outputs.PointNo             :=      BYTE#0; 		
                    Outputs.UserSpecSpeed1      :=      REAL#0.0; 
                    Outputs.UserSpecSpeed2      :=      REAL#0.0; 
            
                    Outputs.Coordinates.X       :=      REAL#0.0; 
                    Outputs.Coordinates.Y       :=      REAL#0.0;
                    Outputs.Coordinates.Z       :=      REAL#0.0;
                    Outputs.Coordinates.Rx      :=      REAL#0.0;
                    Outputs.Coordinates.Ry      :=      REAL#0.0;
                    Outputs.Coordinates.Rz      :=      REAL#0.0;

                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _power_progress := 421;
                    END_IF;
                END_IF;
                // Reset all outputs finished.
                IF _power_progress = 421 THEN
                    ResetAllOutputsTask.DoneWhen(TRUE);
                    _power_progress := 0;
                END_IF;		

                THIS.CallTimers(TRUE);
                
                ResetAllOutputsTask.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_power_progress);
                ResetAllOutputsTask.ThrowWhen(ResetAllOutputsTask.Duration >= Config.TaskTimeout AND Config.TaskTimeout > T#0s ,'<#ResetAllOutputsTask timeout.#>');
            END_IF;
            IF ResetAllOutputsTask.DoneReached() THEN
                Status.Action.Id :=  UINT#921;
                Status.Error.Id :=  UINT#0;
            ELSIF ResetAllOutputsTask.ErrorOccured() THEN
                Status.Action.Id :=  UINT#10120;
                Status.Error.Id  :=  UINT#10120;
            ELSIF ResetAllOutputsTask.AbortTriggered()THEN
                Status.Action.Id :=  UINT#10121;
                Status.Error.Id  :=  UINT#10121;
            END_IF;     
            Messenger.ActivateOnCondition(ULINT#10120,ResetAllOutputsTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#10121,ResetAllOutputsTask.IsAborted(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#222,ResetAllOutputsTask.RestoreTriggered() , eAxoMessageCategory#Info);
            IF ResetAllOutputsTask.RestoreTriggered() AND _power_progress >= 420 AND _power_progress <= 429  THEN
                Status.Action.Id :=  UINT#922;
                _power_progress := 0;
            END_IF;
            //*******************************************

            _someTaskIsActive := StartAtMainTask.IsBusy()
                                OR StartMotorsAndProgramTask.IsBusy()
                                OR StartMovementsTask.IsBusy()
                                OR StopMovementsTask.IsBusy()
                                OR StopMovementsAndProgramTask.IsBusy()
                                OR StopProgramTask.IsBusy();
            

            IF _someTaskIsActive THEN
                IF(Inputs.Manual) THEN
                    Messenger.Activate(UINT#20001,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#20001;
                END_IF;
                IF(NOT Inputs.Automatic) THEN
                    Messenger.Activate(UINT#20002,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#20002;
                END_IF;
                IF(NOT Inputs.AlarmStopActive) THEN
                    Messenger.Activate(UINT#20003,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#20003;
                END_IF;
                IF(NOT Inputs.UserSafetySwitchClosed) THEN
                    Messenger.Activate(UINT#20004,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#20004;
                END_IF;
                IF(Inputs.Error) THEN
                    Messenger.Activate(UINT#20005,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#20005;
                END_IF;
            END_IF;

            //***********UPDATE**OUTPUTS*****************
            //SYSTEM OUTPUTS
            _data[0].%X0	     := Outputs.ExternalStart;     
            _data[0].%X1	     := Outputs.MoveEnable;    
            _data[0].%X2         := Outputs.ErrorConfirmation; 
            _data[0].%X3         := Outputs.DrivesOff;
            _data[0].%X4         := Outputs.DrivesOn;   
            _data[0].%X5         := Outputs.ActivateInterface; 
            _data[0].%X6         := Outputs.StartAtMain;    
            _data[0].%X7         := FALSE;    
 
            _data[1].%X0	     := FALSE;    
            _data[1].%X1	     := FALSE;    
            _data[1].%X2         := FALSE;     
            _data[1].%X3         := FALSE;    
            _data[1].%X4         := FALSE;    
            _data[1].%X5         := FALSE;    
            _data[1].%X6         := FALSE;    
            _data[1].%X7         := FALSE;    

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

            _dword               := TO_DWORD(TO_DINT(Outputs.UserSpecSpeed1));
            _data[12]            := _dword.%B0;
            _data[13]            := _dword.%B1;
            _data[14]            := _dword.%B2;
            _data[15]            := _dword.%B3;

            _dword               := TO_DWORD(TO_DINT(Outputs.UserSpecSpeed2));
            _data[16]            := _dword.%B0;
            _data[17]            := _dword.%B1;
            _data[18]            := _dword.%B2;
            _data[19]            := _dword.%B3;

            ////Coordinates
            _dword               := TO_DWORD(TO_DINT(Outputs.Coordinates.X * REAL#10000.0)); 
            _data[20]            := _dword.%B0;
            _data[21]            := _dword.%B1;
            _data[22]            := _dword.%B2;
            _data[23]            := _dword.%B3;

            _dword               := TO_DWORD(TO_DINT(Outputs.Coordinates.Y * REAL#10000.0));
            _data[24]            := _dword.%B0;
            _data[25]            := _dword.%B1;
            _data[26]            := _dword.%B2;
            _data[27]            := _dword.%B3;

            _dword               := TO_DWORD(TO_DINT(Outputs.Coordinates.Z * REAL#10000.0)); 
            _data[28]            := _dword.%B0;
            _data[29]            := _dword.%B1;
            _data[30]            := _dword.%B2;
            _data[31]            := _dword.%B3;

            _dword               := TO_DWORD(TO_DINT(Outputs.Coordinates.Rx * REAL#10000.0)); 
            _data[32]            := _dword.%B0;
            _data[33]            := _dword.%B1;
            _data[34]            := _dword.%B2;
            _data[35]            := _dword.%B3;

            _dword               := TO_DWORD(TO_DINT(Outputs.Coordinates.Ry * REAL#10000.0)); 
            _data[36]            := _dword.%B0;
            _data[37]            := _dword.%B1;
            _data[38]            := _dword.%B2;
            _data[39]            := _dword.%B3;

            _dword               := TO_DWORD(TO_DINT(Outputs.Coordinates.Rz * REAL#10000.0)); 
            _data[40]            := _dword.%B0;
            _data[41]            := _dword.%B1;
            _data[42]            := _dword.%B2;
            _data[43]            := _dword.%B3;

            _retVal := Siemens.Simatic.DistributedIO.WriteData((Config.HWIDs.HwID_512_DI_DO),_data);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1231, eAxoMessageCategory#Error);
                Status.Error.Id := UINT#1231;
                RETURN;
            END_IF;
            //*******************************************
        END_METHOD

        METHOD PROTECTED OVERRIDE ManualControl
            Status.CurrentMovementParameters := MovementParameters;
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
            ResetAllOutputsTask.Restore();
            _power_progress := 0;
            _movement_progress := 0;                  
            Status.Action.Id :=  UINT#50;
            RestoreTask.DoneWhen(TRUE);
        END_METHOD        
    
        METHOD PUBLIC StartAtMain : IAxoTaskState
            StartAtMain := StartAtMainTask.Invoke(THIS);
        END_METHOD
    
        METHOD PUBLIC StartMotorsAndProgram : IAxoTaskState
            StartMotorsAndProgram := StartMotorsAndProgramTask.Invoke(THIS);
        END_METHOD
    
        METHOD PUBLIC StartMotorsProgramAndMovements : IAxoTaskState
            VAR_IN_OUT
                inData : AxoRoboticsMovementsParams;
            END_VAR
            Status.CurrentMovementParameters := inData;

            StartMotorsProgramAndMovements := StartMotorsProgramAndMovementsTask.Invoke(THIS);
        END_METHOD
    
        METHOD PUBLIC StartMotors : IAxoTaskState
            StartMotors := StartMotorsTask.Invoke(THIS);
        END_METHOD
    
        METHOD PUBLIC StartMovements : IAxoTaskState
            VAR_IN_OUT
                inData : AxoRoboticsMovementsParams;
            END_VAR
            Status.CurrentMovementParameters := inData;

            StartMovements := StartMovementsTask.Invoke(THIS);
        END_METHOD
    
        METHOD PUBLIC StartProgram : IAxoTaskState
            StartProgram := StartProgramTask.Invoke(THIS);
        END_METHOD
            
        METHOD PUBLIC StopMotors : IAxoTaskState
            StopMotors := StopMotorsTask.Invoke(THIS);           
        END_METHOD

        METHOD PUBLIC StopMovementsAndProgram : IAxoTaskState
            VAR_INPUT
                inStopType : eAxoRoboticsStopType;
            END_VAR
            _stopType := inStopType;
            StopMovementsAndProgram := StopMovementsAndProgramTask.Invoke(THIS);
        END_METHOD
        
        METHOD PUBLIC StopMovements : IAxoTaskState
            VAR_INPUT
                inStopType : eAxoRoboticsStopType;
            END_VAR
            _stopType := inStopType;
            StopMovements := StopMovementsTask.Invoke(THIS);           
        END_METHOD
    
        METHOD PUBLIC StopProgram : IAxoTaskState
            StopProgram := StopProgramTask.Invoke(THIS);           
        END_METHOD

        METHOD PUBLIC ResetAllOutputs : IAxoTaskState
            ResetAllOutputs := ResetAllOutputsTask.Invoke(THIS);           
        END_METHOD

        METHOD PRIVATE CallTimers
            VAR_INPUT
                signal : BOOL;
            END_VAR
            
            _infoTimer.OnDelay(THIS, signal AND Config.InfoTime > LT#0S ,Config.InfoTime);
            _errorTimer.OnDelay(THIS, signal AND Config.ErrorTime > LT#0S , Config.ErrorTime);
        END_METHOD
    END_CLASS
END_NAMESPACE




