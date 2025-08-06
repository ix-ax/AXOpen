USING AXOpen.Core;
USING AXOpen.Messaging;
USING AXOpen.Messaging.Static;
USING AXOpen.Components.Robotics;
USING AXOpen.Components.Abstractions.Robotics;
USING Siemens.Simatic.S71500.Hardware.Utilities;

NAMESPACE AXOpen.Components.Mitsubishi.Robotics.v_1_x_x
    {S7.extern=ReadWrite}
    CLASS AxoCr800 EXTENDS AXOpen.Core.AxoComponent IMPLEMENTS AXOpen.Components.Abstractions.Robotics.IAxoRobotics
        VAR PRIVATE
            _infoTimer          :   AXOpen.Timers.OnDelayTimer;
            _errorTimer         :   AXOpen.Timers.OnDelayTimer;
            _blink              :   AXOpen.Timers.AxoBlinker;
            _context            :   IAxoContext;
            
            _dword: DWORD;
            _data : ARRAY[0..63] OF BYTE; 

            _initHwCheckDone        :   BOOL;
            _retval                 :   WORD;
            _geoAddr                :   GeoAddr;
            _outHwid                :   UINT;
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
            Config  :   AxoMitsubishiRobotics_Config;
        END_VAR

        VAR PUBLIC //STATUS
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("Status")]}
            {#ix-attr:[ReadOnly()]}
            Status         :   AxoMitsubishiRobotics_Component_Status;
            {#ix-attr:[ComponentDetails("Status")]}
            {#ix-attr:[ReadOnly()]}
            {#ix-set:AttributeName = "<#Power progress#>"}
            _power_progress     :   INT := 0;
            {#ix-attr:[ComponentDetails("Status")]}
            {#ix-attr:[ReadOnly()]}
            {#ix-set:AttributeName = "<#Movement progress#>"}
            _movement_progress  :   INT := 0;
            Messenger           :   AXOpen.Messaging.Static.AxoMessenger;
            TaskMessenger       :   AXOpen.Messaging.Static.AxoMessenger;
        END_VAR

        VAR PUBLIC //Hardware signals
            {#ix-attr:[ComponentDetails("Hardware signals")]}
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Inputs#>"}
            {#ix-attr:[ReadOnly()]}
            Inputs              :   AxoMitsubishiRobotics_State;
            {#ix-attr:[ComponentDetails("Hardware signals")]}
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Outputs#>"}
            {#ix-attr:[ReadOnly()]}
            Outputs              :   AxoMitsubishiRobotics_Control;
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
                parent  :   IAxoObject;
                hwID    :   UINT;
            END_VAR

            SUPER.Run(parent);

            Messenger.Serve(THIS);

            IF NOT _initHwCheckDone THEN
                IF parent = NULL THEN
                    Messenger.Activate(UINT#700, eAxoMessageCategory#ProgrammingError);
                    Status.Error.Id := UINT#700;
                    RETURN;
                END_IF;
                Config.HWIDs.HwID_Device :=  hwID;
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
                _geoAddr.Slot   :=  UINT#1;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_InOut_64_byte);        
                IF Config.HWIDs.HwID_InOut_64_byte = UINT#0 THEN
                    Messenger.Activate(UINT#710,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#710;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#711,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#711;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#712,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#712;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#713,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#713;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#714,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#714;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#715,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#715;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareIdentifier :=  TO_WORD(Config.HWIDs.HwID_InOut_64_byte) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#64 OR _outputsCount <> UINT#64 THEN
                    Messenger.Activate(UINT#716,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#716;
                    RETURN;
                END_IF;

                IF parent = NULL THEN
                    Messenger.Activate(UINT#1130,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1130;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_Device  = UINT#0 THEN
                    Messenger.Activate(UINT#1131,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1131;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_InOut_64_byte  = UINT#0 THEN
                    Messenger.Activate(UINT#1132,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1132;
                    RETURN;
                END_IF;

                _initHwCheckDone    := TRUE;
            END_IF;            


            //***********UPDATE**INPUTS******************
            _retVal := Siemens.Simatic.S71500.DistributedIO.ReadData(TO_WORD(Config.HWIDs.HwID_InOut_64_byte) ,_data);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1201, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1201;
                RETURN;
            END_IF;

            //SYSTEM INPUTS
            Inputs.OperationEnable          := _data[0].%X0;
            Inputs.AutoEnable               := _data[0].%X1;
            Inputs.Start                    := _data[0].%X2;
            Inputs.Stop                     := _data[0].%X3;
            Inputs.ProgramReset             := _data[0].%X4;
            Inputs.ErrorReset               := _data[0].%X5;
            Inputs.CycleStop                := _data[0].%X6;
            Inputs.ServoOff                 := _data[0].%X7;

            Inputs.ServoOn                  := _data[1].%X0;
            Inputs.HighLevelError           := _data[1].%X1;
            Inputs.LowLevelError            := _data[1].%X2;
            Inputs.CautionLevelError        := _data[1].%X3;
            Inputs.EmergencyError           := _data[1].%X4;
            Inputs.RcReady                  := _data[1].%X5;
            Inputs.BatteryLow               := _data[1].%X6;

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

            // //Safety signals
            // index:=4;
            // Inputs.AutoStop_1               := _data[4].%X0;
            // Inputs.AutoStop_2               := _data[4].%X1;
            // Inputs.EmergencyStop_1          := _data[4].%X2;
            // Inputs.EmergencyStop_2          := _data[4].%X3;
            // Inputs.GeneralStop_1            := _data[4].%X4;
            // Inputs.GeneralStop_2            := _data[4].%X5;
            // Inputs.Enable_1                 := _data[4].%X6;
            // Inputs.Enable_2                 := _data[4].%X7;

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
            Inputs.Coordinates.X:= TO_REAL(TO_DINT(_dword))/REAL#10000.0-REAL#10000.0;

            _dword.%B0                      := _data[24];
            _dword.%B1                      := _data[25];
            _dword.%B2                      := _data[26];
            _dword.%B3                      := _data[27];
            Inputs.Coordinates.Y:= TO_REAL(TO_DINT(_dword))/REAL#10000.0-REAL#10000.0;

            _dword.%B0                      := _data[28];
            _dword.%B1                      := _data[29];
            _dword.%B2                      := _data[30];
            _dword.%B3                      := _data[31];
            Inputs.Coordinates.Z:= TO_REAL(TO_DINT(_dword))/REAL#10000.0-REAL#10000.0;

            _dword.%B0                      := _data[32];
            _dword.%B1                      := _data[33];
            _dword.%B2                      := _data[34];
            _dword.%B3                      := _data[35];
            Inputs.Coordinates.Rx:= TO_REAL(TO_DINT(_dword))/REAL#10000.0-REAL#360.0;

            _dword.%B0                      := _data[36];
            _dword.%B1                      := _data[37];
            _dword.%B2                      := _data[38];
            _dword.%B3                      := _data[39];
            Inputs.Coordinates.Ry:= TO_REAL(TO_DINT(_dword))/REAL#10000.0-REAL#360.0;

            _dword.%B0                      := _data[40];
            _dword.%B1                      := _data[41];
            _dword.%B2                      := _data[42];
            _dword.%B3                      := _data[43];
            Inputs.Coordinates.Rz:= TO_REAL(TO_DINT(_dword))/REAL#10000.0-REAL#360.0;
   
            //*******************************************
            _context := THIS.GetContext();

            //*************INITIALIZATION*************
            RestoreTask.Run(THIS);
            StartAtMainTask.Run(THIS);
            StartMotorsAndProgramTask.Run(THIS);
            StopMovementsTask.Run(THIS);
            StopMovementsAndProgramTask.Run(THIS);
            StartMovementsTask.Run(THIS);
            HardwareDiagnosticsTask.Run(THIS);
            //****************************************
            //********************Diagnostics*********        
            HardwareDiagnosticsTask.Run(THIS,Config.HWIDs.HwID_Device);
            //****************************************

            //*************RESTORE********************
            RestoreTask.IsDisabled := FALSE;
            IF RestoreTask.Execute(THIS) THEN
                THIS.Restore();
            END_IF;
            //****************************************

            //*************StartAtMainTask***************
            StartAtMainTask.IsDisabled := Inputs.Start;
            IF StartAtMainTask.StartTriggered() THEN
                Status.Action.Id :=  UINT#100;
            END_IF;
            Messenger.ActivateOnCondition(ULINT#100,StartAtMainTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#101,StartAtMainTask.IsDone(), eAxoMessageCategory#Info);
            IF StartAtMainTask.Execute(THIS) THEN
                _blink.Blink(Context := _context, inOnTime:=T#500MS,inOffTime:=T#500MS);
                IF _power_progress = 0 THEN
                    Status.Error.Id := UINT#0;
                    Outputs.ActionNo := BYTE#255;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _power_progress := 300;
                END_IF;
                
                IF _power_progress = 300 THEN     //Switching to auto mode
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#500, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#500;
                    END_IF;

                    Outputs.AutoEnable:=TRUE;

                    IF Inputs.AutoEnable THEN
                        THIS.CallTimers(FALSE);
                        _power_progress := 301;
                    END_IF;
                END_IF;
                
                IF _power_progress = 301 THEN //Enabling operations
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#501, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#501;
                    END_IF;

                    Outputs.OperationEnable:=TRUE;

                    IF Inputs.OperationEnable THEN
                        THIS.CallTimers(FALSE);
                        _power_progress := 302;
                    END_IF;
                END_IF;
                
                IF _power_progress = 302 THEN //Reseting error
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#502, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#502;
                    END_IF;

                    Outputs.ErrorReset := Inputs.ErrorReset AND _blink.output;

                    IF NOT Inputs.ErrorReset THEN
                        Outputs.ErrorReset:=FALSE;
                        THIS.CallTimers(FALSE);
                        _power_progress := 303;
                    END_IF;
                END_IF;
                
                IF _power_progress = 303 THEN //<#Robot Emergency Stop Reset#>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#503, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#503;
                    END_IF;

                    Outputs.ErrorReset := Inputs.EmergencyError AND _blink.output;

                    IF NOT Inputs.EmergencyError THEN
                        Outputs.ErrorReset:=FALSE;
                        THIS.CallTimers(FALSE);
                        _power_progress := 304;
                    END_IF;
                END_IF;

                IF _power_progress = 304 THEN //Reseting program
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#504, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#504;
                    END_IF;

                    Outputs.ProgramReset :=   _blink.output;
                   
                    IF Inputs.ProgramReset THEN
                        THIS.CallTimers(FALSE);
                        _power_progress := 305;
                        Outputs.ProgramReset :=FALSE;
                    END_IF;
                END_IF;

                IF _power_progress = 305 THEN //Done
                    _power_progress := 0;
                    StartAtMainTask.DoneWhen(TRUE);
                END_IF;

                THIS.CallTimers(TRUE);
                StartAtMainTask.ThrowWhen(_errorTimer.output );
                Status.Action.Id := TO_UINT(_power_progress);
                StartAtMainTask.ThrowWhen(StartAtMainTask.Duration >= Config.TaskTimeout AND Config.TaskTimeout > T#0s ,'StartAtMainTask timeout.');
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
            Messenger.ActivateOnCondition(ULINT#10001,StartAtMainTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#102,StartAtMainTask.RestoreTriggered() , eAxoMessageCategory#Error);
            IF StartAtMainTask.RestoreTriggered() AND _power_progress >= 300 AND _power_progress <= 309  THEN
                Status.Action.Id :=  UINT#102;
                _power_progress := 0;
            END_IF;
            //*******************************************

            //***********StartMotorsAndProgramTask*******
            StartMotorsAndProgramTask.IsDisabled := FALSE;
            IF StartMotorsAndProgramTask.StartTriggered() THEN
                Status.Action.Id :=  UINT#110;
            END_IF;
            Messenger.ActivateOnCondition(ULINT#110,StartMotorsAndProgramTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#111,StartMotorsAndProgramTask.IsDone(), eAxoMessageCategory#Info);
            IF StartMotorsAndProgramTask.Execute(THIS) THEN
                IF _power_progress = 0 THEN
                    Status.Error.Id := UINT#0;
                    Outputs.ActionNo := BYTE#255;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _power_progress := 310;
                END_IF;
              
                IF _power_progress = 310 THEN //Switching to auto mode
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#510, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#510;
                    END_IF;
                    
                    Outputs.AutoEnable:=TRUE;

                    IF Inputs.AutoEnable THEN
                        THIS.CallTimers(FALSE);
                        _power_progress := 311;
                    END_IF;
                END_IF;
              
                IF _power_progress = 311 THEN //Enabling operations
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#511, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#511;
                    END_IF;
                    
                    Outputs.OperationEnable:=TRUE;
                    
                    IF  Inputs.OperationEnable THEN
                        THIS.CallTimers(FALSE);
                        _power_progress := 312;
                    END_IF;
                END_IF;
              
                IF _power_progress = 312 THEN //Reseting error
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#512, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#512;
                    END_IF;
                    
                    Outputs.ErrorReset := Inputs.ErrorReset AND _blink.output;

                    IF NOT Inputs.ErrorReset THEN
                        Outputs.ErrorReset:=FALSE;
                        THIS.CallTimers(FALSE);
                        _power_progress := 313;
                    END_IF;
                END_IF;

                IF _power_progress = 313 THEN //<#Robot Emergency Stop Reset#>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#513, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#513;
                    END_IF;
                    
                    Outputs.ErrorReset := Inputs.EmergencyError AND _blink.output;

                    IF NOT Inputs.EmergencyError THEN
                        Outputs.ErrorReset:=FALSE;
                        THIS.CallTimers(FALSE);
                        _power_progress := 314;
                    END_IF;
                END_IF;
              
                IF _power_progress = 314 THEN	//Start servomotors
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#514, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#514;
                    END_IF;

                    IF Inputs.HighLevelError OR Inputs.LowLevelError OR Inputs.CautionLevelError OR  Inputs.EmergencyError THEN 
                        THIS.CallTimers(FALSE);
                        _power_progress := 310;
                    END_IF;
                    
                    Outputs.ServoOn:=_blink.output;

                    IF Inputs.ServoOn THEN
                         THIS.CallTimers(FALSE);
                         _power_progress := 315;
                    END_IF;
                END_IF;		

                IF _power_progress = 315 THEN	//Start servomotors
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#515, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#515;
                    END_IF;

                    IF Inputs.HighLevelError OR Inputs.LowLevelError OR Inputs.CautionLevelError OR  Inputs.EmergencyError THEN 
                        THIS.CallTimers(FALSE);
                        _power_progress := 310;
                    END_IF;
                    
                    Outputs.ServoOn:=_blink.output;

                    IF NOT Inputs.ErrorReset THEN
                         Outputs.ServoOn:=FALSE;
                         THIS.CallTimers(FALSE);
                         _power_progress := 316;
                    END_IF;
                END_IF;		
                
                IF _power_progress = 316 THEN	//Start program
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#516, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#516;
                    END_IF;

                    IF Inputs.HighLevelError OR Inputs.LowLevelError OR Inputs.CautionLevelError OR  Inputs.EmergencyError THEN 
                        THIS.CallTimers(FALSE);
                        _power_progress := 310;
                    END_IF;

                    Outputs.Start:=_blink.output;

                    IF Inputs.Start THEN
                        Outputs.Start:=FALSE;
                        _power_progress := 317;
                    END_IF;
                END_IF;		

                IF _power_progress = 317 THEN	//Start program
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#517, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#517;
                    END_IF;

                    IF Inputs.HighLevelError OR Inputs.LowLevelError OR Inputs.CautionLevelError OR  Inputs.EmergencyError THEN 
                        THIS.CallTimers(FALSE);
                        _power_progress := 310;
                    END_IF;

                    Outputs.Start:=_blink.output;
                   
                    IF NOT Inputs.ErrorReset THEN
                        Outputs.Start:=FALSE;
                        _power_progress := 318;
                    END_IF;
                END_IF;		
                
                IF _power_progress = 318 THEN	//Done
                    _power_progress := 0;
                    StartMotorsAndProgramTask.DoneWhen(TRUE);               
                END_IF;		
                
                THIS.CallTimers(TRUE);
                StartMotorsAndProgramTask.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_power_progress);
                StartMotorsAndProgramTask.ThrowWhen(StartMotorsAndProgramTask.Duration >= Config.TaskTimeout AND Config.TaskTimeout > T#0s ,'StartMotorsAndProgramTask timeout.');
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
            Messenger.ActivateOnCondition(ULINT#10011,StartMotorsAndProgramTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#112,StartMotorsAndProgramTask.RestoreTriggered() , eAxoMessageCategory#Error);
            IF StartMotorsAndProgramTask.RestoreTriggered() AND _power_progress >= 310 AND _power_progress <= 319  THEN
                Status.Action.Id :=  UINT#112;
                _power_progress := 0;
            END_IF;   
            //*******************************************
                        
            //***********StopMovementsTask***************
            StopMovementsTask.IsDisabled := FALSE;
            IF StopMovementsTask.StartTriggered() THEN
                Status.Action.Id :=  UINT#120;
            END_IF;
            Messenger.ActivateOnCondition(ULINT#120,StopMovementsTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#121,StopMovementsTask.IsDone(), eAxoMessageCategory#Info);
            IF StopMovementsTask.Execute(THIS) THEN
                IF _power_progress = 0 THEN
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _power_progress := 320;
                END_IF;
                
                IF _power_progress = 320 THEN // Switching to auto
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#520, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#520;
                    END_IF;
                    
                    Outputs.AutoEnable:=TRUE;

                    IF Inputs.AutoEnable THEN
                        THIS.CallTimers(FALSE);
                        _power_progress := 321;
                    END_IF;
                END_IF;
                
                IF _power_progress = 321 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#521, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#521;
                    END_IF;

                    Outputs.OperationEnable:=TRUE;

                    IF Inputs.OperationEnable THEN
                        THIS.CallTimers(FALSE);
                        _power_progress := 322;
                    END_IF;
                END_IF;

                IF _power_progress = 322 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#522, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#522;
                    END_IF;
                    
                    Outputs.Stop:=TRUE ;
                    Outputs.Start:=FALSE ;
                    
                    IF Inputs.Stop THEN
                        Outputs.Stop:=FALSE;
                        THIS.CallTimers(FALSE);
                        _power_progress := 323;
                    END_IF;
                END_IF;		

                IF _power_progress = 323 THEN // Done
                    _power_progress := 0;
                    StopMovementsTask.DoneWhen(TRUE);
                END_IF;	

                THIS.CallTimers(TRUE);
                StopMovementsTask.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_power_progress);
                StopMovementsTask.ThrowWhen(StopMovementsTask.Duration >= Config.TaskTimeout AND Config.TaskTimeout > T#0s ,'StopMovementsTask timeout.');
            END_IF;
            IF StopMovementsTask.DoneReached() THEN
                Status.Action.Id :=  UINT#121;
                Status.Error.Id :=  UINT#0;
            ELSIF StopMovementsTask.ErrorOccured() THEN
                Status.Action.Id :=  UINT#10020;
                Status.Error.Id  :=  UINT#10020;
            ELSIF StopMovementsTask.AbortTriggered() THEN
                Status.Action.Id :=  UINT#10021;
                Status.Error.Id  :=  UINT#10021;
            END_IF; 
            Messenger.ActivateOnCondition(ULINT#10020,StopMovementsTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#10021,StopMovementsTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#122,StopMovementsTask.RestoreTriggered() , eAxoMessageCategory#Error);
            IF StopMovementsTask.RestoreTriggered() AND _power_progress >= 320 AND _power_progress <= 339  THEN
                Status.Action.Id :=  UINT#122;
                _power_progress := 0;
            END_IF;  
            //*******************************************

            //***********StopMovementsAndProgramTask*****
            StopMovementsAndProgramTask.IsDisabled := FALSE;
            IF StopMovementsAndProgramTask.StartTriggered() THEN
                Status.Action.Id :=  UINT#130;
            END_IF;
            Messenger.ActivateOnCondition(ULINT#130,StopMovementsAndProgramTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#131,StopMovementsAndProgramTask.IsDone(), eAxoMessageCategory#Info);
            IF StopMovementsAndProgramTask.Execute(THIS) THEN
                IF _power_progress = 0 THEN
                    StartMovementsTask.Restore();
                    _movement_progress := 0;
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _power_progress := 330;
                END_IF;
                
                IF _power_progress = 330 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#530, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#530;
                    END_IF;

                    Outputs.AutoEnable:=TRUE;

                    IF Inputs.AutoEnable THEN
                        THIS.CallTimers(FALSE);
                        _power_progress := 331;
                    END_IF;
                END_IF;
                
                IF _power_progress = 331 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#531, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#531;
                    END_IF;

                    Outputs.OperationEnable:=TRUE;

                    IF  Inputs.OperationEnable THEN
                        THIS.CallTimers(FALSE);
                        _power_progress := 332;
                    END_IF;
                END_IF;
                
                IF _power_progress = 332 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#532, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#532;
                    END_IF;

                    Outputs.Stop:=TRUE;
                    Outputs.Start:=FALSE ;

                    IF Inputs.Stop  THEN
                        Outputs.Stop:=FALSE;
                        THIS.CallTimers(FALSE);
                        _power_progress := 333;                        
                    END_IF;
                END_IF;		
                                
                IF _power_progress = 333 THEN // Done
                    _power_progress := 0;
                    StopMovementsAndProgramTask.DoneWhen(TRUE);
                END_IF;		

                THIS.CallTimers(TRUE);
                StopMovementsAndProgramTask.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_power_progress);
                StopMovementsAndProgramTask.ThrowWhen(StopMovementsAndProgramTask.Duration >= Config.TaskTimeout AND Config.TaskTimeout > T#0s ,'StopMovementsAndProgramTask timeout.');
            END_IF;
            IF StopMovementsAndProgramTask.DoneReached() THEN
                Status.Action.Id :=  UINT#131;
                Status.Error.Id :=  UINT#0;
            ELSIF StopMovementsAndProgramTask.ErrorOccured() THEN
                Status.Action.Id :=  UINT#10030;
                Status.Error.Id  :=  UINT#10030;
            ELSIF StopMovementsAndProgramTask.AbortTriggered() THEN
                Status.Action.Id :=  UINT#10031;
                Status.Error.Id  :=  UINT#10031;
            END_IF;    
            Messenger.ActivateOnCondition(ULINT#10030,StopMovementsAndProgramTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#10031,StopMovementsAndProgramTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#132,StopMovementsAndProgramTask.RestoreTriggered() , eAxoMessageCategory#Error);
            IF StopMovementsAndProgramTask.RestoreTriggered() AND _power_progress >= 330 AND _power_progress <= 339 THEN
                Status.Action.Id :=  UINT#132;
                _power_progress := 0;
            END_IF;  
            //*******************************************
            
            //***********StartMovementsTask**************
            StartMovementsTask.IsDisabled := FALSE;
            IF StartMovementsTask.StartTriggered() THEN
                Status.Action.Id :=  UINT#140;
            END_IF;
            Messenger.ActivateOnCondition(ULINT#140,StartMovementsTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#141,StartMovementsTask.IsDone(), eAxoMessageCategory#Info);
            IF StartMovementsTask.Execute(THIS) THEN
                IF _movement_progress = 0 THEN
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _movement_progress := 340;
                END_IF;
                
                IF _movement_progress = 340 THEN
                    IF _infoTimer.output THEN
                        IF NOT Inputs.AutoEnable THEN   //<#Waiting for AutoEnable!
                            TaskMessenger.Activate( UINT#540, eAxoMessageCategory#Warning);
                            Status.Error.Id := UINT#540;
                        END_IF;
                        IF NOT Inputs.OperationEnable THEN//<#Waiting for OperationEnable!
                            TaskMessenger.Activate( UINT#541, eAxoMessageCategory#Warning);
                            Status.Error.Id := UINT#541;
                        END_IF;
                        IF NOT Inputs.ServoOn THEN//<#Waiting for ServoOn!
                            TaskMessenger.Activate( UINT#542, eAxoMessageCategory#Warning);
                            Status.Error.Id := UINT#542;
                        END_IF;
                        IF Inputs.ErrorReset THEN//<#Waiting for ErrorReset!
                            TaskMessenger.Activate( UINT#543, eAxoMessageCategory#Warning);
                            Status.Error.Id := UINT#543;
                        END_IF;
                    END_IF;

                    IF Inputs.AutoEnable AND Inputs.OperationEnable AND Inputs.ServoOn AND NOT Inputs.ErrorReset THEN
                        THIS.CallTimers(FALSE);
                        _movement_progress := 344;
                    END_IF;
                END_IF;
                
                IF _movement_progress = 344 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#544, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#544;
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
                        _movement_progress := 345;
                    END_IF;
                END_IF;
                
                IF _movement_progress = 345 THEN
                    IF _infoTimer.output THEN
                        IF Inputs.GlobalSpeed <> Status.CurrentMovementParameters.GlobalSpeed THEN
                            TaskMessenger.Activate( UINT#545, eAxoMessageCategory#Warning);
                            Status.Error.Id := UINT#545;//<#Waiting for Inputs.GlobalSpeed to be equal to MovementParameters.GlobalSpeed!
                        END_IF;
                        IF Inputs.ToolNo <> Status.CurrentMovementParameters.ToolNo THEN
                            TaskMessenger.Activate( UINT#546, eAxoMessageCategory#Warning);
                            Status.Error.Id := UINT#546;//<#Waiting for Inputs.ToolNo to be equal to MovementParameters.ToolNo!
                        END_IF;
                        IF Inputs.WorkobjectNo <> Status.CurrentMovementParameters.WorkobjectNo THEN
                            TaskMessenger.Activate( UINT#547, eAxoMessageCategory#Warning);
                            Status.Error.Id := UINT#547;//<#Waiting for Inputs.WorkobjectNo to be equal to MovementParameters.WorkobjectNo!
                        END_IF;
                        IF Inputs.PointNo <> Status.CurrentMovementParameters.PointNo THEN
                            TaskMessenger.Activate( UINT#548, eAxoMessageCategory#Warning);
                            Status.Error.Id := UINT#548;//<#Waiting for Inputs.PointNo to be equal to MovementParameters.PointNo!
                        END_IF;
                        IF Inputs.UserSpecSpeed1 <> Status.CurrentMovementParameters.UserSpecSpeed1 THEN
                            TaskMessenger.Activate( UINT#549, eAxoMessageCategory#Warning);
                            Status.Error.Id := UINT#549;//<#Waiting for Inputs.UserSpecSpeed1 to be equal to MovementParameters.UserSpecSpeed1!
                        END_IF;
                        IF Inputs.UserSpecSpeed2 <> Status.CurrentMovementParameters.UserSpecSpeed2 THEN
                            TaskMessenger.Activate( UINT#550, eAxoMessageCategory#Warning);
                            Status.Error.Id := UINT#550;//<#Waiting for Inputs.UserSpecSpeed2 to be equal to MovementParameters.UserSpecSpeed2!
                        END_IF;
                    END_IF;

                    IF 	Inputs.GlobalSpeed      = Status.CurrentMovementParameters.GlobalSpeed AND
                        Inputs.ToolNo           = Status.CurrentMovementParameters.ToolNo AND
                        Inputs.WorkobjectNo     = Status.CurrentMovementParameters.WorkobjectNo AND
                        Inputs.PointNo          = Status.CurrentMovementParameters.PointNo AND
                        Inputs.UserSpecSpeed1   = Status.CurrentMovementParameters.UserSpecSpeed1 AND
                        Inputs.UserSpecSpeed2   = Status.CurrentMovementParameters.UserSpecSpeed2 AND
                        AXOpen.Components.Robotics.CoordinatesAreNearlyEqual(Inputs.Coordinates,Status.CurrentMovementParameters.Coordinates,REAL#0.01,REAL#0.01,REAL#0.01,REAL#0.01,REAL#0.01,REAL#0.01) THEN
                        Outputs.ActionNo := BYTE#255;
                        THIS.CallTimers(FALSE);
                        _movement_progress:=351;
                    END_IF;
                END_IF;		

                IF _movement_progress = 351 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#551, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#551;
                    END_IF;

                    IF Outputs.ActionNo = Inputs.ActionNo THEN
                        THIS.CallTimers(FALSE);
                        _movement_progress:=352;
                    END_IF;
                END_IF;	
                
                IF _movement_progress = 352 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#552, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#552;
                    END_IF;

                    Outputs.ActionNo := Status.CurrentMovementParameters.ActionNo;

                    IF Outputs.ActionNo = Inputs.ActionNo THEN
                        THIS.CallTimers(FALSE);
                        _movement_progress:=353;
                    END_IF;
                END_IF;	

                IF _movement_progress = 353 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#553, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#553;
                    END_IF;

                    Outputs.ActionNo := BYTE#255;
	
                    IF Outputs.ActionNo = Inputs.ActionNo THEN
                        _movement_progress := 354;
                    END_IF;
                END_IF;	

                IF _movement_progress = 354 THEN
                    _movement_progress := 0;
                    StartMovementsTask.DoneWhen(TRUE);
                END_IF;	

	            THIS.CallTimers(TRUE);
                StartMovementsTask.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_movement_progress);
                StartMovementsTask.ThrowWhen(StartMovementsTask.Duration >= Config.TaskTimeout AND Config.TaskTimeout > T#0s ,'StartMovementsTask timeout.');
            END_IF;
            IF StartMovementsTask.IsFirstExecutionCycle() THEN
                MovementParameters := Status.CurrentMovementParameters;
            END_IF;
            IF StartMovementsTask.DoneReached() THEN
                Status.Action.Id :=  UINT#141;
                Status.Error.Id :=  UINT#0;
            ELSIF StartMovementsTask.ErrorOccured() THEN
                Status.Action.Id :=  UINT#10040;
                Status.Error.Id  :=  UINT#10040;
            ELSIF StartMovementsTask.AbortTriggered() THEN
                Status.Action.Id :=  UINT#10041;
                Status.Error.Id  :=  UINT#10041;
            END_IF;    
            Messenger.ActivateOnCondition(ULINT#10040,StartMovementsTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#10041,StartMovementsTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#142,StartMovementsTask.RestoreTriggered() , eAxoMessageCategory#Error);
            IF StartMovementsTask.RestoreTriggered() AND _movement_progress >= 340 AND _movement_progress <= 349 THEN
                Status.Action.Id :=  UINT#142;
                _movement_progress := 0;
            END_IF;  
            //*******************************************

            //***********UPDATE**OUTPUTS*****************
            //SYSTEM OUTPUTS
            _data[0].%X0	     := Outputs.OperationEnable;    
            _data[0].%X1	     := Outputs.AutoEnable;    
            _data[0].%X2         := Outputs.Start; 
            _data[0].%X3         := Outputs.Stop;
            _data[0].%X4         := Outputs.ProgramReset;   
            _data[0].%X5         := Outputs.ErrorReset; 
            _data[0].%X6         := Outputs.CycleStop;    
            _data[0].%X7         := Outputs.ServoOff; 

            _data[1].%X0 	     := Outputs.ServoOn;    
            _data[1].%X1 	     := Outputs.GeneralPurposeReset;    
            _data[1].%X2 	     := Outputs.OverideSpecifications;    
                
            //Tool signals
            _data[2].%X0 	     := Outputs.Tool_1_Retract;    
            _data[2].%X1 	     := Outputs.Tool_1_Extend;    
            _data[2].%X2	     := Outputs.Tool_2_Retract;    
            _data[2].%X3	     := Outputs.Tool_2_Extend;    
            _data[2].%X4	     := Outputs.Tool_3_Retract;    
            _data[2].%X5	     := Outputs.Tool_3_Extend;    
            _data[2].%X6         := Outputs.Tool_4_Retract;    
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
            _dword               := TO_DWORD(TO_DINT((Outputs.Coordinates.X +REAL#10000.0)*REAL#10000.0));
            _data[20]            := _dword.%B0;
            _data[21]            := _dword.%B1;
            _data[22]            := _dword.%B2;
            _data[23]            := _dword.%B3;

            _dword               := TO_DWORD(TO_DINT((Outputs.Coordinates.Y +REAL#10000.0)*REAL#10000.0));
            _data[24]            := _dword.%B0;
            _data[25]            := _dword.%B1;
            _data[26]            := _dword.%B2;
            _data[27]            := _dword.%B3;

            _dword               := TO_DWORD(TO_DINT((Outputs.Coordinates.Z +REAL#10000.0)*REAL#10000.0));
            _data[28]            := _dword.%B0;
            _data[29]            := _dword.%B1;
            _data[30]            := _dword.%B2;
            _data[31]            := _dword.%B3;

            _dword               := TO_DWORD(TO_DINT((Outputs.Coordinates.Rx +REAL#360.0)*REAL#10000.0));
            _data[32]            := _dword.%B0;
            _data[33]            := _dword.%B1;
            _data[34]            := _dword.%B2;
            _data[35]            := _dword.%B3;

            _dword               := TO_DWORD(TO_DINT((Outputs.Coordinates.Ry +REAL#360.0)*REAL#10000.0));
            _data[36]            := _dword.%B0;
            _data[37]            := _dword.%B1;
            _data[38]            := _dword.%B2;
            _data[39]            := _dword.%B3;

            _dword               := TO_DWORD(TO_DINT((Outputs.Coordinates.Rz +REAL#360.0)*REAL#10000.0));
            _data[40]            := _dword.%B0;
            _data[41]            := _dword.%B1;
            _data[42]            := _dword.%B2;
            _data[43]            := _dword.%B3;

            _retVal := Siemens.Simatic.S71500.DistributedIO.WriteData(TO_WORD(Config.HWIDs.HwID_InOut_64_byte),_data);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1231, eAxoMessageCategory#ProgrammingError);
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
            StartAtMainTask.Restore();
            StartMotorsAndProgramTask.Restore();
            StopMovementsTask.Restore();
            StopMovementsAndProgramTask.Restore();
            StartMovementsTask.Restore();
            Status.Action.Id :=  UINT#50;
            _power_progress := 0;
            _movement_progress := 0;
            RestoreTask.DoneWhen(TRUE);
        END_METHOD        
    
        METHOD PUBLIC StartAtMain : IAxoTaskState
            StartAtMain := StartAtMainTask.Invoke(THIS);
        END_METHOD
    
        METHOD PUBLIC StartMotorsAndProgram : IAxoTaskState
            StartMotorsAndProgram := StartMotorsAndProgramTask.Invoke(THIS);
        END_METHOD
    
        METHOD PUBLIC StartMovements : IAxoTaskState
            VAR_IN_OUT
                inData : AxoRoboticsMovementsParams;
            END_VAR
            Status.CurrentMovementParameters := inData;

            StartMovements := StartMovementsTask.Invoke(THIS);
        END_METHOD
    
        METHOD PUBLIC StopMovements : IAxoTaskState
            VAR_INPUT
                inStopType : eAxoRoboticsStopType;
            END_VAR
            StopMovements := StopMovementsTask.Invoke(THIS);           
        END_METHOD
    
        METHOD PUBLIC StopMovementsAndProgram : IAxoTaskState
            VAR_INPUT
                inStopType : eAxoRoboticsStopType;
            END_VAR

            StopMovementsAndProgram := StopMovementsAndProgramTask.Invoke(THIS);
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
