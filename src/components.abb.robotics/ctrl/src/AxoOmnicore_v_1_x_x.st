USING AXOpen.Core;
USING AXOpen.Messaging;
USING AXOpen.Messaging.Static;
USING AXOpen.Components.Robotics;
USING AXOpen.Components.Abstractions.Robotics;
USING Siemens.Simatic.S71500.Hardware.Utilities;
USING Siemens.Simatic.S71500.MemoryAccess;

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
            _hwID                   :   WORD;
            _hwIdDI_64_bytes        :   WORD;
            _hwIdDO_64_bytes        :   WORD;

            _initHwCheckDone        :   BOOL;
            _inputsAddress          :   UDINT;   
            _inputsCount            :   UINT;
            _outputsAddress         :   UDINT;  
            _outputsCount           :   UINT;             
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

        // Temporary workaround due to hwc station number issue
        {attribute 'obsolete' := 'This method is(will be) deprecated after releasing hwc3.1.0. Use Run(parent,hwID) instead.'}
        METHOD PUBLIC Run
            VAR_INPUT
                parent : IAxoObject;
                hwID            :   WORD;   
                hwIdDI_64_bytes :   WORD;   //  Hardware Id of the input data of the robot
                hwIdDO_64_bytes :   WORD;   //  Hardware Id of the output data of the robot
            END_VAR
            _hwID                           :=  hwID;
            _hwIdDI_64_bytes                :=  hwIdDI_64_bytes;
            _hwIdDO_64_bytes                :=  hwIdDO_64_bytes;

            _initHwCheckDone    :=  TRUE;
            THIS.Run(parent,hwID);
        END_METHOD


        ///<summary>
        /// Runs tasks and logic of this component.
        /// >[!IMPORTANT] This method must or one of its overloads be called cyclically.
        ///</summary>
        METHOD PUBLIC Run
            VAR_INPUT
                parent : IAxoObject;
                hwID            :   WORD;   
            END_VAR

            VAR 
                _dword: DWORD;
                _data : ARRAY[0..63] OF BYTE; 
                _retval                 :   WORD;
                _geoAddr                :   GeoAddr;
                _outHwid                :   UINT;
            END_VAR

            SUPER.Run(parent);

            Messenger.Serve(THIS);

            IF NOT _initHwCheckDone THEN
                IF parent = NULL THEN
                    Messenger.Activate(ULINT#700, eAxoMessageCategory#ProgrammingError);
                    RobotStatus.Error.Id := UINT#700;
                    RETURN;
                END_IF;
                IF hwID = WORD#0 THEN
                    Messenger.Activate(ULINT#701, eAxoMessageCategory#ProgrammingError);
                    RobotStatus.Error.Id := UINT#701;
                    RETURN;
                END_IF;
    
                _hwID                    := hwID;                                                      
                _retval := ReadSlotFromHardwareID(hardwareID := TO_UINT(_hwID), geoAddr :=_geoAddr);   
                IF _retval = WORD#8090 THEN
                    Messenger.Activate(UINT#702,eAxoMessageCategory#Error);
                    RobotStatus.Error.Id := UINT#702;
                    RETURN;
                END_IF;

                //******************Slot 1*****************//
                _geoAddr.Slot   :=  UINT#1;                                                            
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => _outHwid);        
                _hwIdDI_64_bytes :=  TO_WORD(_outHwid);                                         

                IF _hwIdDI_64_bytes = WORD#0 THEN
                    Messenger.Activate(UINT#703,eAxoMessageCategory#Error);
                    RobotStatus.Error.Id := UINT#703;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#704,eAxoMessageCategory#Error);
                    RobotStatus.Error.Id := UINT#704;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#705,eAxoMessageCategory#Error);
                    RobotStatus.Error.Id := UINT#705;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#706,eAxoMessageCategory#Error);
                    RobotStatus.Error.Id := UINT#706;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#707,eAxoMessageCategory#Error);
                    RobotStatus.Error.Id := UINT#707;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#708,eAxoMessageCategory#Error);
                    RobotStatus.Error.Id := UINT#708;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareIdentifier :=  _hwIdDI_64_bytes , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#64 THEN
                    Messenger.Activate(UINT#1301,eAxoMessageCategory#Error);
                    RobotStatus.Error.Id := UINT#1301;
                    RETURN;
                END_IF;
                
                //******************Slot 2*****************//
                _geoAddr.Slot   :=  UINT#2;                                                            
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => _outHwid);        
                _hwIdDO_64_bytes :=  TO_WORD(_outHwid);                                         

                IF _hwIdDO_64_bytes = WORD#0 THEN
                    Messenger.Activate(UINT#709,eAxoMessageCategory#Error);
                    RobotStatus.Error.Id := UINT#709;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#710,eAxoMessageCategory#Error);
                    RobotStatus.Error.Id := UINT#710;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#711,eAxoMessageCategory#Error);
                    RobotStatus.Error.Id := UINT#711;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#712,eAxoMessageCategory#Error);
                    RobotStatus.Error.Id := UINT#712;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#713,eAxoMessageCategory#Error);
                    RobotStatus.Error.Id := UINT#713;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#714,eAxoMessageCategory#Error);
                    RobotStatus.Error.Id := UINT#714;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareIdentifier :=  _hwIdDO_64_bytes , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _outputsCount <> UINT#64 THEN
                    Messenger.Activate(UINT#1302,eAxoMessageCategory#Error);
                    RobotStatus.Error.Id := UINT#1302;
                    RETURN;
                END_IF;

                _hwID       :=  hwID;

                IF parent = NULL THEN
                    Messenger.Activate(UINT#830,eAxoMessageCategory#Error);
                    RobotStatus.Error.Id := UINT#830;
                    RETURN;
                END_IF;

                IF _hwID  = WORD#0 THEN
                    Messenger.Activate(UINT#831,eAxoMessageCategory#Error);
                    RobotStatus.Error.Id := UINT#831;
                    RETURN;
                END_IF;
            
                IF _hwIdDI_64_bytes  = WORD#0 THEN
                    Messenger.Activate(UINT#832,eAxoMessageCategory#Error);
                    RobotStatus.Error.Id := UINT#832;
                    RETURN;
                END_IF;
            
                IF _hwIdDO_64_bytes  = WORD#0 THEN
                    Messenger.Activate(UINT#833,eAxoMessageCategory#Error);
                    RobotStatus.Error.Id := UINT#833;
                    RETURN;
                END_IF;
                _initHwCheckDone    := TRUE;
            END_IF;

            //**********************************************

            //***********UPDATE**INPUTS******************
            _retval := Siemens.Simatic.S71500.DistributedIO.ReadData(_hwIdDI_64_bytes ,_data);
            Messenger.ActivateOnCondition(ULINT#861,_retval > WORD#0, eAxoMessageCategory#ProgrammingError);
            IF _retval > WORD#0 THEN
                RobotStatus.Error.Id := UINT#861;
                RETURN;
            END_IF;


            //SYSTEM INPUTS
            Inputs.AutoOn                   := _data[0].%X0;
            Inputs.CycleOn                  := _data[0].%X1;
            Inputs.EmgStop                  := _data[0].%X2;
            Inputs.Error                    := _data[0].%X3;
            Inputs.MoveActive               := _data[0].%X4;
            Inputs.MoveInactive             := _data[0].%X5;
            Inputs.MotorOff                 := _data[0].%X6;
            Inputs.MotorOn                  := _data[0].%X7;

            Inputs.MotorOffState            := _data[1].%X0;
            Inputs.MotorOnState             := _data[1].%X1;
            Inputs.ProgExecError            := _data[1].%X2;
            Inputs.SafetyOk                 := _data[1].%X3;
            Inputs.SystemInputBusy          := _data[1].%X4;
            Inputs.PpMoved                  := _data[1].%X5;
            Inputs.MotionSupervision        := _data[1].%X6;
            Inputs.BatteryLow               := _data[1].%X7;

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

            //Safety signals
            Inputs.AutoStop_1               := _data[4].%X0;
            Inputs.AutoStop_2               := _data[4].%X1;
            Inputs.EmergencyStop_1          := _data[4].%X2;
            Inputs.EmergencyStop_2          := _data[4].%X3;
            Inputs.GeneralStop_1            := _data[4].%X4;
            Inputs.GeneralStop_2            := _data[4].%X5;
            Inputs.Enable_1                 := _data[4].%X6;
            Inputs.Enable_2                 := _data[4].%X7;

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
            Inputs.Coordinates.X:= TO_REAL(_dword)/REAL#10000.0-REAL#10000.0;

            _dword.%B3                      := _data[24];
            _dword.%B2                      := _data[25];
            _dword.%B1                      := _data[26];
            _dword.%B0                      := _data[27];
            Inputs.Coordinates.Y:= TO_REAL(_dword)/REAL#10000.0-REAL#10000.0;

            _dword.%B3                      := _data[28];
            _dword.%B2                      := _data[29];
            _dword.%B1                      := _data[30];
            _dword.%B0                      := _data[31];
            Inputs.Coordinates.Z:= TO_REAL(_dword)/REAL#10000.0-REAL#10000.0;

            _dword.%B3                      := _data[32];
            _dword.%B2                      := _data[33];
            _dword.%B1                      := _data[34];
            _dword.%B0                      := _data[35];
            Inputs.Coordinates.Rx:= TO_REAL(_dword)/REAL#10000.0-REAL#360.0;

            _dword.%B3                      := _data[36];
            _dword.%B2                      := _data[37];
            _dword.%B1                      := _data[39];
            _dword.%B0                      := _data[39];
            Inputs.Coordinates.Ry:= TO_REAL(_dword)/REAL#10000.0-REAL#360.0;

            _dword.%B3                      := _data[40];
            _dword.%B2                      := _data[41];
            _dword.%B1                      := _data[42];
            _dword.%B0                      := _data[43];
            Inputs.Coordinates.Rz:= TO_REAL(_dword)/REAL#10000.0-REAL#360.0;

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
            HardwareDiagnosticsTask.Run(THIS);

            _stopTasksAreActive := StopMovementsTask.IsBusy() OR StopMovementsAndProgramTask.IsBusy() OR StopProgramTask.IsBusy() OR StopMotorsTask.IsBusy();
            //****************************************
            //********************Diagnostics*********        
            HardwareDiagnosticsTask.Run(THIS,_hwID);
            //****************************************

            //*************RESTORE********************
            RestoreTask.IsDisabled := FALSE;
            IF RestoreTask.Execute() THEN
                THIS.Restore();
            END_IF;
            //****************************************

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
                RobotStatus.Action.Id :=  UINT#900;
                RobotStatus.Error.Id  :=  UINT#900;
            ELSIF StartAtMainTask.AbortTriggered()THEN
                RobotStatus.Action.Id :=  UINT#901;
                RobotStatus.Error.Id  :=  UINT#901;
            END_IF;     
            Messenger.ActivateOnCondition(ULINT#900,StartAtMainTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#901,StartAtMainTask.IsAborted(), eAxoMessageCategory#Error);
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

                    IF Inputs.CycleOn THEN
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
                RobotStatus.Action.Id :=  UINT#910;
                RobotStatus.Error.Id  :=  UINT#910;
            ELSIF StartMotorsAndProgramTask.AbortTriggered() THEN
                RobotStatus.Action.Id :=  UINT#911;
                RobotStatus.Error.Id  :=  UINT#911;
            END_IF;         
            Messenger.ActivateOnCondition(ULINT#910,StartMotorsAndProgramTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#911,StartMotorsAndProgramTask.IsAborted(), eAxoMessageCategory#Error);
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

                    IF Inputs.CycleOn THEN
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
                RobotStatus.Action.Id :=  UINT#920;
                RobotStatus.Error.Id  :=  UINT#920;
            ELSIF StartMotorsProgramAndMovementsTask.AbortTriggered() THEN
                RobotStatus.Action.Id :=  UINT#921;
                RobotStatus.Error.Id  :=  UINT#921;
            END_IF; 
            Messenger.ActivateOnCondition(ULINT#920,StartMotorsProgramAndMovementsTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#921,StartMotorsProgramAndMovementsTask.IsAborted(), eAxoMessageCategory#Error);
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

                    IF Inputs.MotorOnState THEN
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
                RobotStatus.Action.Id :=  UINT#940;
                RobotStatus.Error.Id  :=  UINT#940;
            ELSIF StartMotorsTask.AbortTriggered() THEN
                RobotStatus.Action.Id :=  UINT#941;
                RobotStatus.Error.Id  :=  UINT#941;
            END_IF;    
            Messenger.ActivateOnCondition(ULINT#940,StartMotorsTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#941,StartMotorsTask.IsAborted(), eAxoMessageCategory#Error);
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
                    END_IF;
                END_IF;	
                
                IF _progress = 663 THEN
                    _progress := 0;
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
                RobotStatus.Action.Id :=  UINT#950;
                RobotStatus.Error.Id  :=  UINT#950;
            ELSIF StartMovementsTask.AbortTriggered() THEN
                RobotStatus.Action.Id :=  UINT#951;
                RobotStatus.Error.Id  :=  UINT#951;
            END_IF;    
            Messenger.ActivateOnCondition(ULINT#950,StartMovementsTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#951,StartMovementsTask.IsAborted(), eAxoMessageCategory#Error);
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
                RobotStatus.Action.Id :=  UINT#970;
                RobotStatus.Error.Id  :=  UINT#970;
            ELSIF StartProgramTask.AbortTriggered()THEN
                RobotStatus.Action.Id :=  UINT#971;
                RobotStatus.Error.Id  :=  UINT#971;
            END_IF;     
            Messenger.ActivateOnCondition(ULINT#970,StartProgramTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#971,StartProgramTask.IsAborted(), eAxoMessageCategory#Error);
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
                
                IF _progress = 382 THEN	
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
                RobotStatus.Action.Id :=  UINT#980;
                RobotStatus.Error.Id  :=  UINT#980;
            ELSIF StopMotorsTask.AbortTriggered()THEN
                RobotStatus.Action.Id :=  UINT#981;
                RobotStatus.Error.Id  :=  UINT#981;
            END_IF;     
            Messenger.ActivateOnCondition(ULINT#980,StopMotorsTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#981,StopMotorsTask.IsAborted(), eAxoMessageCategory#Error);
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
                RobotStatus.Action.Id :=  UINT#990;
                RobotStatus.Error.Id  :=  UINT#990;
            ELSIF StopMovementsAndProgramTask.AbortTriggered()THEN
                RobotStatus.Action.Id :=  UINT#991;
                RobotStatus.Error.Id  :=  UINT#991;
            END_IF;     
            Messenger.ActivateOnCondition(ULINT#990,StopMovementsAndProgramTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#991,StopMovementsAndProgramTask.IsAborted(), eAxoMessageCategory#Error);
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
                    _progress := 300;
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
                RobotStatus.Action.Id :=  UINT#1000;
                RobotStatus.Error.Id  :=  UINT#1000;
            ELSIF StopMovementsTask.AbortTriggered()THEN
                RobotStatus.Action.Id :=  UINT#1001;
                RobotStatus.Error.Id  :=  UINT#1001;
            END_IF;     
            Messenger.ActivateOnCondition(ULINT#1000,StopMovementsTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#1001,StopMovementsTask.IsAborted(), eAxoMessageCategory#Error);
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
                RobotStatus.Action.Id :=  UINT#211;
                RobotStatus.Error.Id :=  UINT#0;
            ELSIF StopProgramTask.ErrorOccured() THEN
                RobotStatus.Action.Id :=  UINT#1010;
                RobotStatus.Error.Id  :=  UINT#1010;
            ELSIF StopProgramTask.AbortTriggered()THEN
                RobotStatus.Action.Id :=  UINT#1011;
                RobotStatus.Error.Id  :=  UINT#1011;
            END_IF;     
            Messenger.ActivateOnCondition(ULINT#1010,StopProgramTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#1011,StopProgramTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#212,StopProgramTask.RestoreTriggered() , eAxoMessageCategory#Error);
            IF StopProgramTask.RestoreTriggered() AND _progress >= 410 AND _progress <= 419  THEN
                RobotStatus.Action.Id :=  UINT#212;
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
            
            Messenger.ActivateOnCondition(ULINT#881,_someTaskIsActive AND Inputs.EmgStop, eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#882,_someTaskIsActive AND NOT Inputs.SafetyOk, eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#883,_someTaskIsActive AND Inputs.ProgExecError, eAxoMessageCategory#Error);

            IF _someTaskIsActive THEN
                IF(Inputs.EmgStop) THEN
                    RobotStatus.Error.Id := UINT#881;
                END_IF;
                IF(NOT Inputs.SafetyOk) THEN
                    RobotStatus.Error.Id := UINT#882;
                END_IF;
                IF(Inputs.ProgExecError) THEN
                    RobotStatus.Error.Id := UINT#883;
                END_IF;
            END_IF;
            //***********UPDATE**OUTPUTS*****************
            //SYSTEM OUTPUTS
            _data[0].%X0	     := Outputs.Interupt;     
            _data[0].%X1	     := Outputs.LoadProg;    
            _data[0].%X2         := Outputs.LoadAndStartProg; 
            _data[0].%X3         := Outputs.MotorOff;
            _data[0].%X4         := Outputs.MotorOn;   
            _data[0].%X5         := Outputs.MotorOnAndStart; 
            _data[0].%X6         := Outputs.ResetEmgStop;    
            _data[0].%X7         := Outputs.ResetError; 
 
            _data[1].%X0	     := Outputs.StartProgram;    
            _data[1].%X1	     := Outputs.StartAtMain;    
            _data[1].%X2         := Outputs.StopProgram;     
            _data[1].%X3         := Outputs.QuickStop;    
            _data[1].%X4         := Outputs.SoftStop;    
            _data[1].%X5         := Outputs.StopCycle;    
            _data[1].%X6         := Outputs.StopInstruction;    
            _data[1].%X7         := Outputs.LimitSpeed;    
                
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
            _dword               := TO_DWORD((Outputs.Coordinates.X +REAL#10000.0)*REAL#10000.0);
            _data[20]            := _dword.%B3;
            _data[21]            := _dword.%B2;
            _data[22]            := _dword.%B1;
            _data[23]            := _dword.%B0;

            _dword               := TO_DWORD((Outputs.Coordinates.Y +REAL#10000.0)*REAL#10000.0);
            _data[24]            := _dword.%B3;
            _data[25]            := _dword.%B2;
            _data[26]            := _dword.%B1;
            _data[27]            := _dword.%B0;

            _dword               := TO_DWORD((Outputs.Coordinates.Z +REAL#10000.0)*REAL#10000.0);
            _data[28]            := _dword.%B3;
            _data[29]            := _dword.%B2;
            _data[30]            := _dword.%B1;
            _data[31]            := _dword.%B0;

            _dword               := TO_DWORD((Outputs.Coordinates.Rx +REAL#360.0)*REAL#10000.0);
            _data[32]            := _dword.%B3;
            _data[33]            := _dword.%B2;
            _data[34]            := _dword.%B1;
            _data[35]            := _dword.%B0;

            _dword               := TO_DWORD((Outputs.Coordinates.Ry +REAL#360.0)*REAL#10000.0);
            _data[36]            := _dword.%B3;
            _data[37]            := _dword.%B2;
            _data[38]            := _dword.%B1;
            _data[39]            := _dword.%B0;

            _dword               := TO_DWORD((Outputs.Coordinates.Rz +REAL#360.0)*REAL#10000.0);
            _data[40]            := _dword.%B3;
            _data[41]            := _dword.%B2;
            _data[42]            := _dword.%B1;
            _data[43]            := _dword.%B0;

            _retval := Siemens.Simatic.S71500.DistributedIO.WriteData(_hwIdDO_64_bytes,_data);
            Messenger.ActivateOnCondition(ULINT#871,_retval > WORD#0, eAxoMessageCategory#ProgrammingError);
            IF _retval > WORD#0 THEN
                RobotStatus.Error.Id := UINT#871;
                RETURN;
            END_IF;
            //*******************************************
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
