USING AXOpen.Core;
USING AXOpen.Messaging;
USING AXOpen.Messaging.Static;
USING AXOpen.Components.Robotics;
USING AXOpen.Components.Abstractions.Robotics;

NAMESPACE AXOpen.Components.Mitsubishi.Robotics
    {S7.extern=ReadWrite}
    CLASS AxoCr800_v_1_x_x EXTENDS AXOpen.Core.AxoComponent IMPLEMENTS AXOpen.Components.Abstractions.Robotics.IAxoRobotics
        VAR PRIVATE
            _infoTimer          :   AXOpen.Timers.OnDelayTimer;
            _infoTime           :   LTIME := LT#2S;
            _errorTimer         :   AXOpen.Timers.OnDelayTimer;
            _errorTime          :   LTIME := LT#5S;
            _blink              :   AXOpen.Timers.AxoBlinker;
            _context            :   IAxoContext;
            _hwID               :   WORD;
            _hwIdInOut_64_byte  :   WORD;            
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
                parent              : IAxoObject;
                hwID                :   WORD;
                hwIdInOut_64_byte   :   WORD;
            END_VAR

            Messenger.Serve(THIS);
            Messenger.ActivateOnCondition(ULINT#700,parent = NULL, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#701,hwIdInOut_64_byte = WORD#0, eAxoMessageCategory#ProgrammingError);

            IF parent = NULL THEN
                RobotStatus.Error.Id := UINT#700;
                RETURN;
            ELSIF hwIdInOut_64_byte = WORD#0 THEN
                RobotStatus.Error.Id := UINT#701;
                RETURN;
            END_IF;

            _hwID               :=  hwID;
            _hwIdInOut_64_byte  :=  hwIdInOut_64_byte;

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
                hwID                :   WORD;
                hwIdInOut_64_byte   :   WORD;
            END_VAR

            Messenger.Serve(THIS);
            Messenger.ActivateOnCondition(ULINT#700,parent = NULL, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#701,hwIdInOut_64_byte = WORD#0, eAxoMessageCategory#ProgrammingError);

            IF parent = NULL THEN
                RobotStatus.Error.Id := UINT#700;
                RETURN;
            ELSIF hwIdInOut_64_byte = WORD#0 THEN
                RobotStatus.Error.Id := UINT#701;
                RETURN;
            END_IF;

            _hwID               :=  hwID;
            _hwIdInOut_64_byte  :=  hwIdInOut_64_byte;

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
            returnValue := Siemens.Simatic.S71500.DistributedIO.ReadData(_hwIdInOut_64_byte ,_data);
            Messenger.ActivateOnCondition(ULINT#702,returnValue > WORD#0, eAxoMessageCategory#ProgrammingError);
            IF returnValue > WORD#0 THEN
                RobotStatus.Error.Id := UINT#702;
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

            returnValue := Siemens.Simatic.S71500.DistributedIO.WriteData(_hwIdInOut_64_byte,_data);
            Messenger.ActivateOnCondition(ULINT#703,returnValue > WORD#0, eAxoMessageCategory#ProgrammingError);
            IF returnValue > WORD#0 THEN
                RobotStatus.Error.Id := UINT#703;
                RETURN;
            END_IF;            
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
            HardwareDiagnosticsTask.Run(_hwID);
            //****************************************

            //*************RESTORE********************
            RestoreTask.IsDisabled := FALSE;
            IF RestoreTask.Execute() THEN
                THIS.Restore();
            END_IF;
            //****************************************

            //*************StartAtMainTask***************
            StartAtMainTask.IsDisabled := FALSE;
            IF StartAtMainTask.StartTriggered() THEN
                RobotStatus.Action.Id :=  UINT#100;
            END_IF;
            Messenger.ActivateOnCondition(ULINT#100,StartAtMainTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#101,StartAtMainTask.IsDone(), eAxoMessageCategory#Info);
            IF StartAtMainTask.Execute() THEN
                _blink.Blink(Context := _context, inOnTime:=T#500MS,inOffTime:=T#500MS);
                IF _progress = 0 THEN
                    RobotStatus.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 300;
                END_IF;
                
                IF _progress = 300 THEN     //Switching to auto mode
                    TaskMessenger.ActivateOnCondition(ULINT#600, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        RobotStatus.Error.Id := UINT#600;
                    END_IF;

                    Outputs.AutoEnable:=TRUE;

                    IF Inputs.AutoEnable THEN
                        THIS.CallTimers(FALSE);
                        _progress := 301;
                    END_IF;
                END_IF;
                
                IF _progress = 301 THEN //Enabling operations
                    TaskMessenger.ActivateOnCondition(ULINT#601, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        RobotStatus.Error.Id := UINT#601;
                    END_IF;

                    Outputs.OperationEnable:=TRUE;

                    IF Inputs.OperationEnable THEN
                        THIS.CallTimers(FALSE);
                        _progress := 302;
                    END_IF;
                END_IF;
                
                IF _progress = 302 THEN //Reseting error
                    TaskMessenger.ActivateOnCondition(ULINT#602, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        RobotStatus.Error.Id := UINT#602;
                    END_IF;

                    Outputs.ErrorReset := Inputs.ErrorReset AND _blink.output;

                    IF NOT Inputs.ErrorReset THEN
                        Outputs.ErrorReset:=FALSE;
                        THIS.CallTimers(FALSE);
                        _progress := 303;
                    END_IF;
                END_IF;
                
                IF _progress = 303 THEN //<#Robot Emergency Stop Reset#>
                    TaskMessenger.ActivateOnCondition(ULINT#603, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        RobotStatus.Error.Id := UINT#603;
                    END_IF;

                    Outputs.ErrorReset := Inputs.EmergencyError AND _blink.output;

                    IF NOT Inputs.EmergencyError THEN
                        Outputs.ErrorReset:=FALSE;
                        THIS.CallTimers(FALSE);
                        _progress := 304;
                    END_IF;
                END_IF;

                IF _progress = 304 THEN //Reseting program
                    TaskMessenger.ActivateOnCondition(ULINT#604, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        RobotStatus.Error.Id := UINT#604;
                    END_IF;

                    Outputs.ProgramReset :=   _blink.output;
                   
                    IF Inputs.ProgramReset THEN
                        THIS.CallTimers(FALSE);
                        _progress := 305;
                        Outputs.ProgramReset :=FALSE;
                    END_IF;
                END_IF;

                IF _progress = 305 THEN //Done
                    _progress := 0;
                    StartAtMainTask.DoneWhen(TRUE);
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
            StartMotorsAndProgramTask.IsDisabled := FALSE;
            IF StartMotorsAndProgramTask.StartTriggered() THEN
                RobotStatus.Action.Id :=  UINT#110;
            END_IF;
            Messenger.ActivateOnCondition(ULINT#110,StartMotorsAndProgramTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#111,StartMotorsAndProgramTask.IsDone(), eAxoMessageCategory#Info);
            IF StartMotorsAndProgramTask.Execute() THEN
                IF _progress = 0 THEN
                    RobotStatus.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 310;
                END_IF;
              
                IF _progress = 310 THEN //Switching to auto mode
                    TaskMessenger.ActivateOnCondition(ULINT#610, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        RobotStatus.Error.Id := UINT#610;
                    END_IF;
                    
                    Outputs.AutoEnable:=TRUE;

                    IF Inputs.AutoEnable THEN
                        THIS.CallTimers(FALSE);
                        _progress := 311;
                    END_IF;
                END_IF;
              
                IF _progress = 311 THEN //Enabling operations
                    TaskMessenger.ActivateOnCondition(ULINT#611, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        RobotStatus.Error.Id := UINT#611;
                    END_IF;
                    
                    Outputs.OperationEnable:=TRUE;
                    
                    IF  Inputs.OperationEnable THEN
                        THIS.CallTimers(FALSE);
                        _progress := 312;
                    END_IF;
                END_IF;
              
                IF _progress = 312 THEN //Reseting error
                    TaskMessenger.ActivateOnCondition(ULINT#612, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        RobotStatus.Error.Id := UINT#612;
                    END_IF;
                    
                    Outputs.ErrorReset := Inputs.ErrorReset AND _blink.output;

                    IF NOT Inputs.ErrorReset THEN
                        Outputs.ErrorReset:=FALSE;
                        THIS.CallTimers(FALSE);
                        _progress := 313;
                    END_IF;
                END_IF;

                IF _progress = 313 THEN //<#Robot Emergency Stop Reset#>
                    TaskMessenger.ActivateOnCondition(ULINT#613, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        RobotStatus.Error.Id := UINT#613;
                    END_IF;
                    
                    Outputs.ErrorReset := Inputs.EmergencyError AND _blink.output;

                    IF NOT Inputs.EmergencyError THEN
                        Outputs.ErrorReset:=FALSE;
                        THIS.CallTimers(FALSE);
                        _progress := 314;
                    END_IF;
                END_IF;
              
                IF _progress = 314 THEN	//Start servomotors
                    TaskMessenger.ActivateOnCondition(ULINT#614, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        RobotStatus.Error.Id := UINT#614;
                    END_IF;

                    IF Inputs.HighLevelError OR Inputs.LowLevelError OR Inputs.CautionLevelError OR  Inputs.EmergencyError THEN 
                        THIS.CallTimers(FALSE);
                        _progress := 310;
                    END_IF;
                    
                    Outputs.ServoOn:=_blink.output;

                    IF Inputs.ServoOn THEN
                         THIS.CallTimers(FALSE);
                         _progress := 315;
                    END_IF;
                END_IF;		

                IF _progress = 315 THEN	//Start servomotors
                    TaskMessenger.ActivateOnCondition(ULINT#615, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        RobotStatus.Error.Id := UINT#615;
                    END_IF;

                    IF Inputs.HighLevelError OR Inputs.LowLevelError OR Inputs.CautionLevelError OR  Inputs.EmergencyError THEN 
                        THIS.CallTimers(FALSE);
                        _progress := 310;
                    END_IF;
                    
                    Outputs.ServoOn:=_blink.output;

                    IF NOT Inputs.ErrorReset THEN
                         Outputs.ServoOn:=FALSE;
                         THIS.CallTimers(FALSE);
                         _progress := 316;
                    END_IF;
                END_IF;		
                
                IF _progress = 316 THEN	//Start program
                    TaskMessenger.ActivateOnCondition(ULINT#616, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        RobotStatus.Error.Id := UINT#616;
                    END_IF;

                    IF Inputs.HighLevelError OR Inputs.LowLevelError OR Inputs.CautionLevelError OR  Inputs.EmergencyError THEN 
                        THIS.CallTimers(FALSE);
                        _progress := 310;
                    END_IF;

                    Outputs.Start:=_blink.output;

                    IF Inputs.Start THEN
                        Outputs.Start:=FALSE;
                        _progress := 317;
                    END_IF;
                END_IF;		

                IF _progress = 317 THEN	//Start program
                    TaskMessenger.ActivateOnCondition(ULINT#617, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        RobotStatus.Error.Id := UINT#617;
                    END_IF;

                    IF Inputs.HighLevelError OR Inputs.LowLevelError OR Inputs.CautionLevelError OR  Inputs.EmergencyError THEN 
                        THIS.CallTimers(FALSE);
                        _progress := 310;
                    END_IF;

                    Outputs.Start:=_blink.output;
                   
                    IF NOT Inputs.ErrorReset THEN
                        Outputs.Start:=FALSE;
                        _progress := 318;
                    END_IF;
                END_IF;		
                
                IF _progress = 318 THEN	//Done
                    _progress := 0;
                    StartMotorsAndProgramTask.DoneWhen(TRUE);               
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
                        
            //***********StopMovementsTask***************
            StopMovementsTask.IsDisabled := FALSE;
            IF StopMovementsTask.StartTriggered() THEN
                RobotStatus.Action.Id :=  UINT#120;
            END_IF;
            Messenger.ActivateOnCondition(ULINT#120,StopMovementsTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#121,StopMovementsTask.IsDone(), eAxoMessageCategory#Info);
            IF StopMovementsTask.Execute() THEN
                IF _progress = 0 THEN
                    RobotStatus.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 320;
                END_IF;
                
                IF _progress = 320 THEN // Switching to auto
                    TaskMessenger.ActivateOnCondition(ULINT#620, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        RobotStatus.Error.Id := UINT#620;
                    END_IF;
                    
                    Outputs.AutoEnable:=TRUE;

                    IF Inputs.AutoEnable THEN
                        THIS.CallTimers(FALSE);
                        _progress := 321;
                    END_IF;
                END_IF;
                
                IF _progress = 321 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#621, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        RobotStatus.Error.Id := UINT#621;
                    END_IF;

                    Outputs.OperationEnable:=TRUE;

                    IF Inputs.OperationEnable THEN
                        THIS.CallTimers(FALSE);
                        _progress := 322;
                    END_IF;
                END_IF;

                IF _progress = 322 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#622, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        RobotStatus.Error.Id := UINT#622;
                    END_IF;
                    
                    Outputs.Stop:=TRUE ;
                    Outputs.Start:=FALSE ;
                    
                    IF Inputs.Stop THEN
                        Outputs.Stop:=FALSE;
                        THIS.CallTimers(FALSE);
                        _progress := 323;
                    END_IF;
                END_IF;		

                IF _progress = 323 THEN // Done
                    _progress := 0;
                    StopMovementsTask.DoneWhen(TRUE);
                END_IF;	

                THIS.CallTimers(TRUE);
                
                StopMovementsTask.ThrowWhen(_errorTimer.output);

                RobotStatus.Action.Id := TO_UINT(_progress);
            END_IF;
            IF StopMovementsTask.DoneReached() THEN
                RobotStatus.Action.Id :=  UINT#121;
                RobotStatus.Error.Id :=  UINT#0;
            ELSIF StopMovementsTask.ErrorOccured() THEN
                RobotStatus.Action.Id :=  UINT#820;
                RobotStatus.Error.Id  :=  UINT#820;
            ELSIF StopMovementsTask.AbortTriggered() THEN
                RobotStatus.Action.Id :=  UINT#821;
                RobotStatus.Error.Id  :=  UINT#821;
            END_IF; 
            Messenger.ActivateOnCondition(ULINT#820,StopMovementsTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#821,StopMovementsTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#122,StopMovementsTask.RestoreTriggered() , eAxoMessageCategory#Error);
            IF StopMovementsTask.RestoreTriggered() AND _progress >= 320 AND _progress <= 339  THEN
                RobotStatus.Action.Id :=  UINT#122;
                _progress := 0;
            END_IF;  
            //*******************************************

            //***********StopMovementsAndProgramTask*****
            StopMovementsAndProgramTask.IsDisabled := FALSE;
            IF StopMovementsAndProgramTask.StartTriggered() THEN
                RobotStatus.Action.Id :=  UINT#130;
            END_IF;
            Messenger.ActivateOnCondition(ULINT#130,StopMovementsAndProgramTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#131,StopMovementsAndProgramTask.IsDone(), eAxoMessageCategory#Info);
            IF StopMovementsAndProgramTask.Execute() THEN
                IF _progress = 0 THEN
                    RobotStatus.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 330;
                END_IF;
                
                IF _progress = 330 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#630, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        RobotStatus.Error.Id := UINT#630;
                    END_IF;

                    Outputs.AutoEnable:=TRUE;

                    IF Inputs.AutoEnable THEN
                        THIS.CallTimers(FALSE);
                        _progress := 331;
                    END_IF;
                END_IF;
                
                IF _progress = 331 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#631, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        RobotStatus.Error.Id := UINT#631;
                    END_IF;

                    Outputs.OperationEnable:=TRUE;

                    IF  Inputs.OperationEnable THEN
                        THIS.CallTimers(FALSE);
                        _progress := 332;
                    END_IF;
                END_IF;
                
                IF _progress = 332 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#632, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        RobotStatus.Error.Id := UINT#632;
                    END_IF;

                    Outputs.Stop:=TRUE;
                    Outputs.Start:=FALSE ;

                    IF Inputs.Stop  THEN
                        Outputs.Stop:=FALSE;
                        THIS.CallTimers(FALSE);
                        _progress := 333;                        
                    END_IF;
                END_IF;		
                                
                IF _progress = 333 THEN // Done
                    _progress := 0;
                    StopMovementsAndProgramTask.DoneWhen(TRUE);
                END_IF;		

                THIS.CallTimers(TRUE);
                
                StopMovementsAndProgramTask.ThrowWhen(_errorTimer.output);

                RobotStatus.Action.Id := TO_UINT(_progress);
            END_IF;
            IF StopMovementsAndProgramTask.DoneReached() THEN
                RobotStatus.Action.Id :=  UINT#131;
                RobotStatus.Error.Id :=  UINT#0;
            ELSIF StopMovementsAndProgramTask.ErrorOccured() THEN
                RobotStatus.Action.Id :=  UINT#830;
                RobotStatus.Error.Id  :=  UINT#830;
            ELSIF StopMovementsAndProgramTask.AbortTriggered() THEN
                RobotStatus.Action.Id :=  UINT#831;
                RobotStatus.Error.Id  :=  UINT#831;
            END_IF;    
            Messenger.ActivateOnCondition(ULINT#830,StopMovementsAndProgramTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#831,StopMovementsAndProgramTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#132,StopMovementsAndProgramTask.RestoreTriggered() , eAxoMessageCategory#Error);
            IF StopMovementsAndProgramTask.RestoreTriggered() AND _progress >= 330 AND _progress <= 339 THEN
                RobotStatus.Action.Id :=  UINT#132;
                _progress := 0;
            END_IF;  
            //*******************************************
            
            //***********StartMovementsTask**************
            StartMovementsTask.IsDisabled := FALSE;
            IF StartMovementsTask.StartTriggered() THEN
                RobotStatus.Action.Id :=  UINT#140;
            END_IF;
            Messenger.ActivateOnCondition(ULINT#140,StartMovementsTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#141,StartMovementsTask.IsDone(), eAxoMessageCategory#Info);
            IF StartMovementsTask.Execute() THEN
                IF _progress = 0 THEN
                    RobotStatus.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 340;
                END_IF;
                
                IF _progress = 340 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#640, _infoTimer.output AND NOT Inputs.AutoEnable, eAxoMessageCategory#Warning);
                    TaskMessenger.ActivateOnCondition(ULINT#641, _infoTimer.output AND NOT Inputs.OperationEnable, eAxoMessageCategory#Warning);
                    TaskMessenger.ActivateOnCondition(ULINT#642, _infoTimer.output AND NOT Inputs.ServoOn, eAxoMessageCategory#Warning);
                    TaskMessenger.ActivateOnCondition(ULINT#643, _infoTimer.output AND Inputs.ErrorReset, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        RobotStatus.Error.Id := UINT#640;
                    END_IF;
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
                        _progress := 344;
                    END_IF;
                END_IF;
                
                IF _progress = 344 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#644, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        RobotStatus.Error.Id := UINT#644;
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
                        _progress := 345;
                    END_IF;
                END_IF;
                
                IF _progress = 345 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#645, _infoTimer.output AND Inputs.GlobalSpeed <> RobotStatus.CurrentMovementParameters.GlobalSpeed, eAxoMessageCategory#Warning);
                    TaskMessenger.ActivateOnCondition(ULINT#646, _infoTimer.output AND Inputs.ToolNo <> RobotStatus.CurrentMovementParameters.ToolNo, eAxoMessageCategory#Warning);
                    TaskMessenger.ActivateOnCondition(ULINT#647, _infoTimer.output AND Inputs.WorkobjectNo <> RobotStatus.CurrentMovementParameters.WorkobjectNo, eAxoMessageCategory#Warning);
                    TaskMessenger.ActivateOnCondition(ULINT#648, _infoTimer.output AND Inputs.PointNo <> RobotStatus.CurrentMovementParameters.PointNo, eAxoMessageCategory#Warning);
                    TaskMessenger.ActivateOnCondition(ULINT#649, _infoTimer.output AND Inputs.UserSpecSpeed1 <> RobotStatus.CurrentMovementParameters.UserSpecSpeed1, eAxoMessageCategory#Warning);
                    TaskMessenger.ActivateOnCondition(ULINT#650, _infoTimer.output AND Inputs.UserSpecSpeed2 <> RobotStatus.CurrentMovementParameters.UserSpecSpeed2, eAxoMessageCategory#Warning);

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
                        _progress:=351;
                    END_IF;
                END_IF;		

                IF _progress = 351 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#651, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        RobotStatus.Error.Id := UINT#651;
                    END_IF;

                    IF Outputs.ActionNo = Inputs.ActionNo THEN
                        THIS.CallTimers(FALSE);
                        _progress:=352;
                    END_IF;
                END_IF;	
                
                IF _progress = 352 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#652, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        RobotStatus.Error.Id := UINT#652;
                    END_IF;

                    Outputs.ActionNo := RobotStatus.CurrentMovementParameters.ActionNo;

                    IF Outputs.ActionNo = Inputs.ActionNo THEN
                        THIS.CallTimers(FALSE);
                        _progress:=353;
                    END_IF;
                END_IF;	

                IF _progress = 353 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#653, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        RobotStatus.Error.Id := UINT#653;
                    END_IF;

                    Outputs.ActionNo := BYTE#255;
	
                    IF Outputs.ActionNo = Inputs.ActionNo THEN
                        _progress := 354;
                    END_IF;
                END_IF;	

                IF _progress = 354 THEN
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
                RobotStatus.Action.Id :=  UINT#141;
                RobotStatus.Error.Id :=  UINT#0;
            ELSIF StartMovementsTask.ErrorOccured() THEN
                RobotStatus.Action.Id :=  UINT#840;
                RobotStatus.Error.Id  :=  UINT#840;
            ELSIF StartMovementsTask.AbortTriggered() THEN
                RobotStatus.Action.Id :=  UINT#841;
                RobotStatus.Error.Id  :=  UINT#841;
            END_IF;    
            Messenger.ActivateOnCondition(ULINT#840,StartMovementsTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#841,StartMovementsTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#142,StartMovementsTask.RestoreTriggered() , eAxoMessageCategory#Error);
            IF StartMovementsTask.RestoreTriggered() AND _progress >= 340 AND _progress <= 349 THEN
                RobotStatus.Action.Id :=  UINT#142;
                _progress := 0;
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
            RobotStatus.Action.Id :=  UINT#50;
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
