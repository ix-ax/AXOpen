USING AXOpen.Core;
USING AXOpen.Messaging;
USING AXOpen.Messaging.Static;
USING AXOpen.Components.Robotics;
USING AXOpen.Components.Abstractions.Robotics;

NAMESPACE AXOpen.Components.Ur.Robotics
    {S7.extern=ReadWrite}
    CLASS AxoUrCb3_v_3_x_x EXTENDS AXOpen.Core.AxoComponent IMPLEMENTS AXOpen.Components.Abstractions.Robotics.IAxoRobotics
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
            _hwID                                                    : WORD;
            _hwIdAxoUrRobotics_T2O_State                             : WORD;
            _hwIdAxoUrRobotics_T2O_IO                                : WORD;
            _hwIdAxoUrRobotics_T2O_Joints                            : WORD;
            _hwIdAxoUrRobotics_T2O_TCP                               : WORD;
            _hwIdAxoUrRobotics_T2O_General_Purpose_Bit_Registers     : WORD;
            _hwIdAxoUrRobotics_T2O_General_Purpose_Int_Registers     : WORD;
            _hwIdAxoUrRobotics_T2O_General_Purpose_Float_Registers   : WORD;
            _hwIdAxoUrRobotics_O2T_Robot_IO                          : WORD;
            _hwIdAxoUrRobotics_O2T_General_Purpose_Registers_1       : WORD;
            _hwIdAxoUrRobotics_O2T_General_Purpose_Registers_2       : WORD;
        END_VAR

        VAR PUBLIC //HEADER
                    
        END_VAR

        VAR PUBLIC //Tasks
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Tasks")]}            
            {#ix-set:AttributeName = "<#Restore#>"}
            RestoreTask : AxoTask;       
            
            {#ix-attr:[ComponentDetails("Tasks")]}            
            {#ix-set:AttributeName = "<#Power On Task#>"}
            PowerOnTask : AxoTask;

            {#ix-attr:[ComponentDetails("Tasks")]}            
            {#ix-set:AttributeName = "<#Stop movements#>"}
            StopMovementsTask : AxoTask;

            {#ix-attr:[ComponentDetails("Tasks")]}            
            {#ix-set:AttributeName = "<#Stop movements and program#>"}
            StopMovementsAndProgramTask : AxoTask;

            {#ix-attr:[ComponentDetails("Tasks")]}            
            {#ix-set:AttributeName = "<#Stop program#>"}
            StopProgramTask : AxoTask;

            // {#ix-attr:[ComponentDetails("Tasks")]}            
            // {#ix-set:AttributeName = "<#Stop motors#>"}
            // StopMotorsTask : AxoTask;

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
            Config  :   AxoUrRobotics_Config_v_1_x_x;
        END_VAR

        VAR PUBLIC //STATUS
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("Status")]}
            {#ix-attr:[ReadOnly()]}
            RobotStatus         :   AxoUrRobotics_Component_Status_v_1_x_x;
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
            Inputs              :   AxoUrRobotics_State_v_1_x_x;
            {#ix-attr:[ComponentDetails("Hardware signals")]}
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Outputs#>"}
            {#ix-attr:[ReadOnly()]}
            Outputs              :   AxoUrRobotics_Control_v_1_x_x;
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
                parent                                                  : IAxoObject;
                hwID                                                    : WORD;
                hwIdAxoUrRobotics_T2O_State                             : WORD;
                hwIdAxoUrRobotics_T2O_IO                                : WORD;
                hwIdAxoUrRobotics_T2O_Joints                            : WORD;
                hwIdAxoUrRobotics_T2O_TCP                               : WORD;
                hwIdAxoUrRobotics_T2O_General_Purpose_Bit_Registers     : WORD;
                hwIdAxoUrRobotics_T2O_General_Purpose_Int_Registers     : WORD;
                hwIdAxoUrRobotics_T2O_General_Purpose_Float_Registers   : WORD;
                hwIdAxoUrRobotics_O2T_Robot_IO                          : WORD;
                hwIdAxoUrRobotics_O2T_General_Purpose_Registers_1       : WORD;
                hwIdAxoUrRobotics_O2T_General_Purpose_Registers_2       : WORD;
                refPowerOnPulse                                         : REF_TO BOOL;
            END_VAR

            Messenger.Serve(THIS);

            Messenger.ActivateOnCondition(ULINT#700, parent = NULL, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#701, hwIdAxoUrRobotics_T2O_State = WORD#0, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#702, hwIdAxoUrRobotics_T2O_IO = WORD#0, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#703, hwIdAxoUrRobotics_T2O_Joints = WORD#0, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#704, hwIdAxoUrRobotics_T2O_TCP = WORD#0, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#705, hwIdAxoUrRobotics_T2O_General_Purpose_Bit_Registers = WORD#0, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#706, hwIdAxoUrRobotics_T2O_General_Purpose_Int_Registers = WORD#0, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#707, hwIdAxoUrRobotics_T2O_General_Purpose_Float_Registers = WORD#0, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#708, hwIdAxoUrRobotics_O2T_Robot_IO = WORD#0, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#709, hwIdAxoUrRobotics_O2T_General_Purpose_Registers_1 = WORD#0, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#710, hwIdAxoUrRobotics_O2T_General_Purpose_Registers_2 = WORD#0, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#711, refPowerOnPulse = NULL, eAxoMessageCategory#ProgrammingError);

            IF parent = NULL THEN
                RobotStatus.Error.Id := UINT#700;
                RETURN;
            ELSIF hwIdAxoUrRobotics_T2O_State = WORD#0 THEN
                RobotStatus.Error.Id := UINT#701;
                RETURN;
            ELSIF hwIdAxoUrRobotics_T2O_IO = WORD#0 THEN
                RobotStatus.Error.Id := UINT#702;
                RETURN;
            ELSIF hwIdAxoUrRobotics_T2O_Joints = WORD#0 THEN
                RobotStatus.Error.Id := UINT#703;
                RETURN;
            ELSIF hwIdAxoUrRobotics_T2O_TCP = WORD#0 THEN
                RobotStatus.Error.Id := UINT#704;
                RETURN;
            ELSIF hwIdAxoUrRobotics_T2O_General_Purpose_Bit_Registers = WORD#0 THEN
                RobotStatus.Error.Id := UINT#705;
                RETURN;
            ELSIF hwIdAxoUrRobotics_T2O_General_Purpose_Int_Registers = WORD#0 THEN
                RobotStatus.Error.Id := UINT#706;
                RETURN;
            ELSIF hwIdAxoUrRobotics_T2O_General_Purpose_Float_Registers = WORD#0 THEN
                RobotStatus.Error.Id := UINT#707;
                RETURN;
            ELSIF hwIdAxoUrRobotics_O2T_Robot_IO = WORD#0 THEN
                RobotStatus.Error.Id := UINT#708;
                RETURN;
            ELSIF hwIdAxoUrRobotics_O2T_General_Purpose_Registers_1 = WORD#0 THEN
                RobotStatus.Error.Id := UINT#709;
                RETURN;
            ELSIF hwIdAxoUrRobotics_O2T_General_Purpose_Registers_2 = WORD#0 THEN
                RobotStatus.Error.Id := UINT#710;
                RETURN;
            ELSIF refPowerOnPulse =  NULL THEN
                RobotStatus.Error.Id := UINT#711;
                RETURN;
            END_IF;

            _hwID := hwID;
            _hwIdAxoUrRobotics_T2O_State := hwIdAxoUrRobotics_T2O_State;
            _hwIdAxoUrRobotics_T2O_IO := hwIdAxoUrRobotics_T2O_IO;
            _hwIdAxoUrRobotics_T2O_Joints := hwIdAxoUrRobotics_T2O_Joints;
            _hwIdAxoUrRobotics_T2O_TCP := hwIdAxoUrRobotics_T2O_TCP;
            _hwIdAxoUrRobotics_T2O_General_Purpose_Bit_Registers := hwIdAxoUrRobotics_T2O_General_Purpose_Bit_Registers;
            _hwIdAxoUrRobotics_T2O_General_Purpose_Int_Registers := hwIdAxoUrRobotics_T2O_General_Purpose_Int_Registers;
            _hwIdAxoUrRobotics_T2O_General_Purpose_Float_Registers := hwIdAxoUrRobotics_T2O_General_Purpose_Float_Registers;
            _hwIdAxoUrRobotics_O2T_Robot_IO := hwIdAxoUrRobotics_O2T_Robot_IO;
            _hwIdAxoUrRobotics_O2T_General_Purpose_Registers_1 := hwIdAxoUrRobotics_O2T_General_Purpose_Registers_1;
            _hwIdAxoUrRobotics_O2T_General_Purpose_Registers_2 := hwIdAxoUrRobotics_O2T_General_Purpose_Registers_2;

            THIS.Initialize(parent);
            THIS.Execute(refPowerOnPulse);
        END_METHOD

        ///<summary>
        /// Runs tasks and logic of this component.
        /// >[!IMPORTANT] This method must or one of its overloads be called cyclically.
        ///</summary>
        METHOD PUBLIC Run 
            VAR_INPUT
                parent                                                  : IAxoContext;
                hwID                                                    : WORD;
                hwIdAxoUrRobotics_T2O_State                             : WORD;
                hwIdAxoUrRobotics_T2O_IO                                : WORD;
                hwIdAxoUrRobotics_T2O_Joints                            : WORD;
                hwIdAxoUrRobotics_T2O_TCP                               : WORD;
                hwIdAxoUrRobotics_T2O_General_Purpose_Bit_Registers     : WORD;
                hwIdAxoUrRobotics_T2O_General_Purpose_Int_Registers     : WORD;
                hwIdAxoUrRobotics_T2O_General_Purpose_Float_Registers   : WORD;
                hwIdAxoUrRobotics_O2T_Robot_IO                          : WORD;
                hwIdAxoUrRobotics_O2T_General_Purpose_Registers_1       : WORD;
                hwIdAxoUrRobotics_O2T_General_Purpose_Registers_2       : WORD;
                refPowerOnPulse                                         : REF_TO BOOL;
            END_VAR

            Messenger.Serve(THIS);

            Messenger.ActivateOnCondition(ULINT#700, parent = NULL, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#701, hwIdAxoUrRobotics_T2O_State = WORD#0, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#702, hwIdAxoUrRobotics_T2O_IO = WORD#0, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#703, hwIdAxoUrRobotics_T2O_Joints = WORD#0, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#704, hwIdAxoUrRobotics_T2O_TCP = WORD#0, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#705, hwIdAxoUrRobotics_T2O_General_Purpose_Bit_Registers = WORD#0, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#706, hwIdAxoUrRobotics_T2O_General_Purpose_Int_Registers = WORD#0, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#707, hwIdAxoUrRobotics_T2O_General_Purpose_Float_Registers = WORD#0, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#708, hwIdAxoUrRobotics_O2T_Robot_IO = WORD#0, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#709, hwIdAxoUrRobotics_O2T_General_Purpose_Registers_1 = WORD#0, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#710, hwIdAxoUrRobotics_O2T_General_Purpose_Registers_2 = WORD#0, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#711, refPowerOnPulse = NULL, eAxoMessageCategory#ProgrammingError);

            IF parent = NULL THEN
                RobotStatus.Error.Id := UINT#700;
                RETURN;
            ELSIF hwIdAxoUrRobotics_T2O_State = WORD#0 THEN
                RobotStatus.Error.Id := UINT#701;
                RETURN;
            ELSIF hwIdAxoUrRobotics_T2O_IO = WORD#0 THEN
                RobotStatus.Error.Id := UINT#702;
                RETURN;
            ELSIF hwIdAxoUrRobotics_T2O_Joints = WORD#0 THEN
                RobotStatus.Error.Id := UINT#703;
                RETURN;
            ELSIF hwIdAxoUrRobotics_T2O_TCP = WORD#0 THEN
                RobotStatus.Error.Id := UINT#704;
                RETURN;
            ELSIF hwIdAxoUrRobotics_T2O_General_Purpose_Bit_Registers = WORD#0 THEN
                RobotStatus.Error.Id := UINT#705;
                RETURN;
            ELSIF hwIdAxoUrRobotics_T2O_General_Purpose_Int_Registers = WORD#0 THEN
                RobotStatus.Error.Id := UINT#706;
                RETURN;
            ELSIF hwIdAxoUrRobotics_T2O_General_Purpose_Float_Registers = WORD#0 THEN
                RobotStatus.Error.Id := UINT#707;
                RETURN;
            ELSIF hwIdAxoUrRobotics_O2T_Robot_IO = WORD#0 THEN
                RobotStatus.Error.Id := UINT#708;
                RETURN;
            ELSIF hwIdAxoUrRobotics_O2T_General_Purpose_Registers_1 = WORD#0 THEN
                RobotStatus.Error.Id := UINT#709;
                RETURN;
            ELSIF hwIdAxoUrRobotics_O2T_General_Purpose_Registers_2 = WORD#0 THEN
                RobotStatus.Error.Id := UINT#710;
                RETURN;
            ELSIF refPowerOnPulse =  NULL THEN
                RobotStatus.Error.Id := UINT#711;
                RETURN;
            END_IF;

            _hwID := hwID;
            _hwIdAxoUrRobotics_T2O_State := hwIdAxoUrRobotics_T2O_State;
            _hwIdAxoUrRobotics_T2O_IO := hwIdAxoUrRobotics_T2O_IO;
            _hwIdAxoUrRobotics_T2O_Joints := hwIdAxoUrRobotics_T2O_Joints;
            _hwIdAxoUrRobotics_T2O_TCP := hwIdAxoUrRobotics_T2O_TCP;
            _hwIdAxoUrRobotics_T2O_General_Purpose_Bit_Registers := hwIdAxoUrRobotics_T2O_General_Purpose_Bit_Registers;
            _hwIdAxoUrRobotics_T2O_General_Purpose_Int_Registers := hwIdAxoUrRobotics_T2O_General_Purpose_Int_Registers;
            _hwIdAxoUrRobotics_T2O_General_Purpose_Float_Registers := hwIdAxoUrRobotics_T2O_General_Purpose_Float_Registers;
            _hwIdAxoUrRobotics_O2T_Robot_IO := hwIdAxoUrRobotics_O2T_Robot_IO;
            _hwIdAxoUrRobotics_O2T_General_Purpose_Registers_1 := hwIdAxoUrRobotics_O2T_General_Purpose_Registers_1;
            _hwIdAxoUrRobotics_O2T_General_Purpose_Registers_2 := hwIdAxoUrRobotics_O2T_General_Purpose_Registers_2;

            THIS.Initialize(parent);
            THIS.Execute(refPowerOnPulse);
        END_METHOD

        METHOD PRIVATE Execute 
            VAR_INPUT
                refPowerOnPulse : REF_TO BOOL;
            END_VAR
            VAR 
                _word : WORD;
                _dword: DWORD;
                returnValue : WORD;
                _data : ARRAY[0..103] OF BYTE;
                _data24 : ARRAY[0..23] OF BYTE;
                _data100 : ARRAY[0..99] OF BYTE;
            END_VAR

            THIS.Open();
            //***********UPDATE**INPUTS******************
            //Inputs Low level
            //INPUTS T2O STATE ROBOT => st_URO_CB3_T2OInfoData
            returnValue := Siemens.Simatic.S71500.DistributedIO.ReadData(_hwIdAxoUrRobotics_T2O_State, _data);
            Messenger.ActivateOnCondition(ULINT#712,returnValue > WORD#0, eAxoMessageCategory#ProgrammingError);
            IF returnValue > WORD#0 THEN
                RobotStatus.Error.Id := UINT#712;
                RETURN;
            END_IF;
            Inputs.Inputs.Robot.ControllerMajorVersion              := TO_USINT(_data[0]);
            Inputs.Inputs.Robot.ControllerMinorVersion              := TO_USINT(_data[1]);
            Inputs.Inputs.Robot.RobotMode                           := TO_USINT(_data[4]);
            Inputs.Inputs.Robot.RealtimeMachineSeconds              := TO_USINT(_data[5]);
            _word.%B1                                               := _data[6];
            _word.%B0                                               := _data[7];
            Inputs.Inputs.Robot.RealtimeMachineMilliseconds         := TO_UINT(_word);
            Inputs.Inputs.Robot.RealtimeMachineMinutes              := TO_USINT(_data[8]);
            Inputs.Inputs.Robot.RealtimeMachineHours                := TO_USINT(_data[9]);
            _word.%B1                                               := _data[10];
            _word.%B0                                               := _data[11];
            Inputs.Inputs.Robot.RealtimeMachineDays                 := TO_UINT(_word);
            _dword.%B3                                              := _data[12];
            _dword.%B2                                              := _data[13];
            _dword.%B1                                              := _data[14];
            _dword.%B0                                              := _data[15];
            Inputs.Inputs.Robot.RobotCurrent                        := TO_REAL(_dword);
            //INPUTS T2O STATE ROBOT => st_URO_CB3_T2OStateData
            Inputs.Inputs.Robot.PW_IsPowerOn                        := _data[16].%X0;
            Inputs.Inputs.Robot.PR_IsProgramRunning                 := _data[16].%X1;
            Inputs.Inputs.Robot.TB_IsTeachButtonPressed             := _data[16].%X2;
            Inputs.Inputs.Robot.PB_IsPowerButtonPressed             := _data[16].%X3;
            _dword.%B3                                              := _data[20];
            _dword.%B2                                              := _data[21];
            _dword.%B1                                              := _data[22];
            _dword.%B0                                              := _data[23];
            Inputs.Inputs.Robot.SpeedSliderFraction                 := REAL#100.0 * TO_REAL(_dword);
            Inputs.Inputs.Safety.SafetyMode                         := TO_USINT(_data[24]);
            Inputs.Inputs.Safety.NO_IsNormalMode                    := _data[28].%X0;
            Inputs.Inputs.Safety.RD_IsReducedMode                   := _data[28].%X1;
            Inputs.Inputs.Safety.PS_IsProtectiveStopped             := _data[28].%X2;
            Inputs.Inputs.Safety.RC_IsRecoveryMode                  := _data[28].%X3;
            Inputs.Inputs.Safety.SS_IsSafeguardStopped              := _data[28].%X4;
            Inputs.Inputs.Safety.SES_IsSystemEmergencyStopped       := _data[28].%X5;
            Inputs.Inputs.Safety.RES_IsRobotEmergencyStopped        := _data[28].%X6;
            Inputs.Inputs.Safety.ES_IsEmergencyStopped              := _data[28].%X7;
            Inputs.Inputs.Safety.VL_IsViolation                     := _data[29].%X0;
            Inputs.Inputs.Safety.FT_IsFault                         := _data[29].%X1;
            Inputs.Inputs.Safety.ST_IsStoppedDueSafety              := _data[29].%X2;

            //INPUTS T20 IO => st_URO_CB3_T2OIoStateData
            returnValue := Siemens.Simatic.S71500.DistributedIO.ReadData(_hwIdAxoUrRobotics_T2O_IO, _data);
            Messenger.ActivateOnCondition(ULINT#713,returnValue > WORD#0, eAxoMessageCategory#ProgrammingError);
            IF returnValue > WORD#0 THEN
                RobotStatus.Error.Id := UINT#713;
                RETURN;
            END_IF;
            Inputs.Inputs.IO.StandardDigitalInputs                  := TO_USINT(_data[0]);
            Inputs.Inputs.IO.ConfigurableDigitalInputs              := TO_USINT(_data[1]);
            Inputs.Inputs.IO.StandardDigitalOutputs                 := TO_USINT(_data[2]);
            Inputs.Inputs.IO.ConfigurableDigitalOutputs             := TO_USINT(_data[3]);
            Inputs.Inputs.IO.AnalogIoTypes                          := TO_USINT(_data[4]);
            _dword.%B3                                              := _data[8];
            _dword.%B2                                              := _data[9];
            _dword.%B1                                              := _data[10];
            _dword.%B0                                              := _data[11];
            Inputs.Inputs.IO.StandardAnalogInput_0                  := TO_REAL(_dword);
            _dword.%B3                                              := _data[12];
            _dword.%B2                                              := _data[13];
            _dword.%B1                                              := _data[14];
            _dword.%B0                                              := _data[15];
            Inputs.Inputs.IO.StandardAnalogInput_1                  := TO_REAL(_dword);            
            _dword.%B3                                              := _data[16];
            _dword.%B2                                              := _data[17];
            _dword.%B1                                              := _data[18];
            _dword.%B0                                              := _data[19];
            Inputs.Inputs.IO.StandardAnalogOutput_0                 := TO_REAL(_dword);
            _dword.%B3                                              := _data[20];
            _dword.%B2                                              := _data[21];
            _dword.%B1                                              := _data[22];
            _dword.%B0                                              := _data[23];
            Inputs.Inputs.IO.StandardAnalogOutput_1                 := TO_REAL(_dword);            
            _dword.%B3                                              := _data[24];
            _dword.%B2                                              := _data[25];
            _dword.%B1                                              := _data[26];
            _dword.%B0                                              := _data[27];
            Inputs.Inputs.IO.Current                                := TO_REAL(_dword);            

            Inputs.Inputs.IO.Euromap67InputBit_0                    := _data[28].%X0;
            Inputs.Inputs.IO.Euromap67InputBit_1                    := _data[28].%X1;
            Inputs.Inputs.IO.Euromap67InputBit_2                    := _data[28].%X2;
            Inputs.Inputs.IO.Euromap67InputBit_3                    := _data[28].%X3;
            Inputs.Inputs.IO.Euromap67InputBit_4                    := _data[28].%X4;
            Inputs.Inputs.IO.Euromap67InputBit_5                    := _data[28].%X5;
            Inputs.Inputs.IO.Euromap67InputBit_6                    := _data[28].%X6;
            Inputs.Inputs.IO.Euromap67InputBit_7                    := _data[28].%X7;
            Inputs.Inputs.IO.Euromap67InputBit_8                    := _data[29].%X0;
            Inputs.Inputs.IO.Euromap67InputBit_9                    := _data[29].%X1;
            Inputs.Inputs.IO.Euromap67InputBit_10                   := _data[29].%X2;
            Inputs.Inputs.IO.Euromap67InputBit_11                   := _data[29].%X3;
            Inputs.Inputs.IO.Euromap67InputBit_12                   := _data[29].%X4;
            Inputs.Inputs.IO.Euromap67InputBit_13                   := _data[29].%X5;
            Inputs.Inputs.IO.Euromap67InputBit_14                   := _data[29].%X6;
            Inputs.Inputs.IO.Euromap67InputBit_15                   := _data[29].%X7;
            Inputs.Inputs.IO.Euromap67InputBit_16                   := _data[30].%X0;
            Inputs.Inputs.IO.Euromap67InputBit_17                   := _data[30].%X1;
            Inputs.Inputs.IO.Euromap67InputBit_18                   := _data[30].%X2;
            Inputs.Inputs.IO.Euromap67InputBit_19                   := _data[30].%X3;
            Inputs.Inputs.IO.Euromap67InputBit_20                   := _data[30].%X4;
            Inputs.Inputs.IO.Euromap67InputBit_21                   := _data[30].%X5;
            Inputs.Inputs.IO.Euromap67InputBit_22                   := _data[30].%X6;
            Inputs.Inputs.IO.Euromap67InputBit_23                   := _data[30].%X7;
            Inputs.Inputs.IO.Euromap67InputBit_24                   := _data[31].%X0;
            Inputs.Inputs.IO.Euromap67InputBit_25                   := _data[31].%X1;
            Inputs.Inputs.IO.Euromap67InputBit_26                   := _data[31].%X2;
            Inputs.Inputs.IO.Euromap67InputBit_27                   := _data[31].%X3;
            Inputs.Inputs.IO.Euromap67InputBit_28                   := _data[31].%X4;
            Inputs.Inputs.IO.Euromap67InputBit_29                   := _data[31].%X5;
            Inputs.Inputs.IO.Euromap67InputBit_30                   := _data[31].%X6;
            Inputs.Inputs.IO.Euromap67InputBit_31                   := _data[31].%X7;

            Inputs.Inputs.IO.Euromap67OutputBit_0                   := _data[32].%X0;
            Inputs.Inputs.IO.Euromap67OutputBit_1                   := _data[32].%X1;
            Inputs.Inputs.IO.Euromap67OutputBit_2                   := _data[32].%X2;
            Inputs.Inputs.IO.Euromap67OutputBit_3                   := _data[32].%X3;
            Inputs.Inputs.IO.Euromap67OutputBit_4                   := _data[32].%X4;
            Inputs.Inputs.IO.Euromap67OutputBit_5                   := _data[32].%X5;
            Inputs.Inputs.IO.Euromap67OutputBit_6                   := _data[32].%X6;
            Inputs.Inputs.IO.Euromap67OutputBit_7                   := _data[32].%X7;
            Inputs.Inputs.IO.Euromap67OutputBit_8                   := _data[33].%X0;
            Inputs.Inputs.IO.Euromap67OutputBit_9                   := _data[33].%X1;
            Inputs.Inputs.IO.Euromap67OutputBit_10                  := _data[33].%X2;
            Inputs.Inputs.IO.Euromap67OutputBit_11                  := _data[33].%X3;
            Inputs.Inputs.IO.Euromap67OutputBit_12                  := _data[33].%X4;
            Inputs.Inputs.IO.Euromap67OutputBit_13                  := _data[33].%X5;
            Inputs.Inputs.IO.Euromap67OutputBit_14                  := _data[33].%X6;
            Inputs.Inputs.IO.Euromap67OutputBit_15                  := _data[33].%X7;
            Inputs.Inputs.IO.Euromap67OutputBit_16                  := _data[34].%X0;
            Inputs.Inputs.IO.Euromap67OutputBit_17                  := _data[34].%X1;
            Inputs.Inputs.IO.Euromap67OutputBit_18                  := _data[34].%X2;
            Inputs.Inputs.IO.Euromap67OutputBit_19                  := _data[34].%X3;
            Inputs.Inputs.IO.Euromap67OutputBit_20                  := _data[34].%X4;
            Inputs.Inputs.IO.Euromap67OutputBit_21                  := _data[34].%X5;
            Inputs.Inputs.IO.Euromap67OutputBit_22                  := _data[34].%X6;
            Inputs.Inputs.IO.Euromap67OutputBit_23                  := _data[34].%X7;
            Inputs.Inputs.IO.Euromap67OutputBit_24                  := _data[35].%X0;
            Inputs.Inputs.IO.Euromap67OutputBit_25                  := _data[35].%X1;
            Inputs.Inputs.IO.Euromap67OutputBit_26                  := _data[35].%X2;
            Inputs.Inputs.IO.Euromap67OutputBit_27                  := _data[35].%X3;
            Inputs.Inputs.IO.Euromap67OutputBit_28                  := _data[35].%X4;
            Inputs.Inputs.IO.Euromap67OutputBit_29                  := _data[35].%X5;
            Inputs.Inputs.IO.Euromap67OutputBit_30                  := _data[35].%X6;
            Inputs.Inputs.IO.Euromap67OutputBit_31                  := _data[35].%X7;

            _dword.%B3                                              := _data[36];
            _dword.%B2                                              := _data[37];
            _dword.%B1                                              := _data[38];
            _dword.%B0                                              := _data[39];
            Inputs.Inputs.IO.Euromap6724Voltage                     := TO_REAL(_dword);            

            _dword.%B3                                              := _data[40];
            _dword.%B2                                              := _data[41];
            _dword.%B1                                              := _data[42];
            _dword.%B0                                              := _data[43];
            Inputs.Inputs.IO.Euromap6724VCurrent                    := TO_REAL(_dword);  

            //INPUTS T20 IO => st_URO_CB3_T2OToolStateData
            Inputs.Inputs.Tool.ToolMode                             := TO_USINT(_data[44]);
            Inputs.Inputs.Tool.TDI_ToolDigitalInputs                := TO_USINT(_data[45]);
            Inputs.Inputs.Tool.TDO_ToolDigitalOutputs               := TO_USINT(_data[46]);
            Inputs.Inputs.Tool.TAIT_ToolAnalogInputTypes            := TO_USINT(_data[47]);

            _dword.%B3                                              := _data[48];
            _dword.%B2                                              := _data[49];
            _dword.%B1                                              := _data[50];
            _dword.%B0                                              := _data[51];
            Inputs.Inputs.Tool.ToolAnalogInput_0                    := TO_REAL(_dword);    

            _dword.%B3                                              := _data[52];
            _dword.%B2                                              := _data[53];
            _dword.%B1                                              := _data[54];
            _dword.%B0                                              := _data[55];
            Inputs.Inputs.Tool.ToolAnalogInput_1                    := TO_REAL(_dword);    

            _dword.%B3                                              := _data[56];
            _dword.%B2                                              := _data[57];
            _dword.%B1                                              := _data[58];
            _dword.%B0                                              := _data[59];
            Inputs.Inputs.Tool.ToolOutputVoltage                    := TO_REAL(_dword);    

            _dword.%B3                                              := _data[60];
            _dword.%B2                                              := _data[61];
            _dword.%B1                                              := _data[62];
            _dword.%B0                                              := _data[63];
            Inputs.Inputs.Tool.ToolCurrent                          := TO_REAL(_dword);    

            // //INPUTS T20 JOINT => st_URO_CB3_T2OJointsData
            returnValue := Siemens.Simatic.S71500.DistributedIO.ReadData(_hwIdAxoUrRobotics_T2O_Joints, _data);
            Messenger.ActivateOnCondition(ULINT#714,returnValue > WORD#0, eAxoMessageCategory#ProgrammingError);
            IF returnValue > WORD#0 THEN
                RobotStatus.Error.Id := UINT#714;
                RETURN;
            END_IF;
            _dword.%B3                                              := _data[0];
            _dword.%B2                                              := _data[1];
            _dword.%B1                                              := _data[2];
            _dword.%B0                                              := _data[3];
            Inputs.Inputs.Joints.JointPosition_0                    := REAL#57.2957795 * TO_REAL(_dword);    

            _dword.%B3                                              := _data[4];
            _dword.%B2                                              := _data[5];
            _dword.%B1                                              := _data[6];
            _dword.%B0                                              := _data[7];
            Inputs.Inputs.Joints.JointPosition_1                    := REAL#57.2957795 * TO_REAL(_dword);    

            _dword.%B3                                              := _data[8];
            _dword.%B2                                              := _data[9];
            _dword.%B1                                              := _data[10];
            _dword.%B0                                              := _data[11];
            Inputs.Inputs.Joints.JointPosition_2                    := REAL#57.2957795 * TO_REAL(_dword);    

            _dword.%B3                                              := _data[12];
            _dword.%B2                                              := _data[13];
            _dword.%B1                                              := _data[14];
            _dword.%B0                                              := _data[15];
            Inputs.Inputs.Joints.JointPosition_3                    := REAL#57.2957795 * TO_REAL(_dword);    

            _dword.%B3                                              := _data[16];
            _dword.%B2                                              := _data[17];
            _dword.%B1                                              := _data[18];
            _dword.%B0                                              := _data[19];
            Inputs.Inputs.Joints.JointPosition_4                    := REAL#57.2957795 * TO_REAL(_dword);    

            _dword.%B3                                              := _data[20];
            _dword.%B2                                              := _data[21];
            _dword.%B1                                              := _data[22];
            _dword.%B0                                              := _data[23];
            Inputs.Inputs.Joints.JointPosition_5                    := REAL#57.2957795 * TO_REAL(_dword);    

            _dword.%B3                                              := _data[24];
            _dword.%B2                                              := _data[25];
            _dword.%B1                                              := _data[26];
            _dword.%B0                                              := _data[27];
            Inputs.Inputs.Joints.JointVelocity_0                    :=  TO_REAL(_dword);    

            _dword.%B3                                              := _data[28];
            _dword.%B2                                              := _data[29];
            _dword.%B1                                              := _data[30];
            _dword.%B0                                              := _data[31];
            Inputs.Inputs.Joints.JointVelocity_1                    :=  TO_REAL(_dword);    

            _dword.%B3                                              := _data[32];
            _dword.%B2                                              := _data[33];
            _dword.%B1                                              := _data[34];
            _dword.%B0                                              := _data[35];
            Inputs.Inputs.Joints.JointVelocity_2                    :=  TO_REAL(_dword);    

            _dword.%B3                                              := _data[36];
            _dword.%B2                                              := _data[37];
            _dword.%B1                                              := _data[38];
            _dword.%B0                                              := _data[39];
            Inputs.Inputs.Joints.JointVelocity_3                    :=  TO_REAL(_dword);    

            _dword.%B3                                              := _data[40];
            _dword.%B2                                              := _data[41];
            _dword.%B1                                              := _data[42];
            _dword.%B0                                              := _data[43];
            Inputs.Inputs.Joints.JointVelocity_4                    :=  TO_REAL(_dword);    

            _dword.%B3                                              := _data[44];
            _dword.%B2                                              := _data[45];
            _dword.%B1                                              := _data[46];
            _dword.%B0                                              := _data[47];
            Inputs.Inputs.Joints.JointVelocity_5                    :=  TO_REAL(_dword);    

            _dword.%B3                                              := _data[48];
            _dword.%B2                                              := _data[49];
            _dword.%B1                                              := _data[50];
            _dword.%B0                                              := _data[51];
            Inputs.Inputs.Joints.JointCurrent_0                     :=  TO_REAL(_dword);    

            _dword.%B3                                              := _data[52];
            _dword.%B2                                              := _data[53];
            _dword.%B1                                              := _data[54];
            _dword.%B0                                              := _data[55];
            Inputs.Inputs.Joints.JointCurrent_1                     :=  TO_REAL(_dword);    

            _dword.%B3                                              := _data[56];
            _dword.%B2                                              := _data[57];
            _dword.%B1                                              := _data[58];
            _dword.%B0                                              := _data[59];
            Inputs.Inputs.Joints.JointCurrent_2                     :=  TO_REAL(_dword);    

            _dword.%B3                                              := _data[60];
            _dword.%B2                                              := _data[61];
            _dword.%B1                                              := _data[62];
            _dword.%B0                                              := _data[63];
            Inputs.Inputs.Joints.JointCurrent_3                     :=  TO_REAL(_dword);    

            _dword.%B3                                              := _data[64];
            _dword.%B2                                              := _data[65];
            _dword.%B1                                              := _data[66];
            _dword.%B0                                              := _data[67];
            Inputs.Inputs.Joints.JointCurrent_4                     :=  TO_REAL(_dword);    

            _dword.%B3                                              := _data[68];
            _dword.%B2                                              := _data[69];
            _dword.%B1                                              := _data[70];
            _dword.%B0                                              := _data[71];
            Inputs.Inputs.Joints.JointCurrent_5                     :=  TO_REAL(_dword);    

            _dword.%B3                                              := _data[72];
            _dword.%B2                                              := _data[73];
            _dword.%B1                                              := _data[74];
            _dword.%B0                                              := _data[75];
            Inputs.Inputs.Joints.JointTemperature_0                 :=  TO_REAL(_dword);    

            _dword.%B3                                              := _data[76];
            _dword.%B2                                              := _data[77];
            _dword.%B1                                              := _data[78];
            _dword.%B0                                              := _data[79];
            Inputs.Inputs.Joints.JointTemperature_1                 :=  TO_REAL(_dword);    

            _dword.%B3                                              := _data[80];
            _dword.%B2                                              := _data[81];
            _dword.%B1                                              := _data[82];
            _dword.%B0                                              := _data[83];
            Inputs.Inputs.Joints.JointTemperature_2                 :=  TO_REAL(_dword);    

            _dword.%B3                                              := _data[84];
            _dword.%B2                                              := _data[85];
            _dword.%B1                                              := _data[86];
            _dword.%B0                                              := _data[87];
            Inputs.Inputs.Joints.JointTemperature_3                 :=  TO_REAL(_dword);    

            _dword.%B3                                              := _data[88];
            _dword.%B2                                              := _data[89];
            _dword.%B1                                              := _data[90];
            _dword.%B0                                              := _data[91];
            Inputs.Inputs.Joints.JointTemperature_4                 :=  TO_REAL(_dword);    

            _dword.%B3                                              := _data[92];
            _dword.%B2                                              := _data[93];
            _dword.%B1                                              := _data[94];
            _dword.%B0                                              := _data[95];
            Inputs.Inputs.Joints.JointTemperature_5                 :=  TO_REAL(_dword);    

            Inputs.Inputs.Joints.JointMode_0                        := TO_USINT(_data[96]);
            Inputs.Inputs.Joints.JointMode_1                        := TO_USINT(_data[97]);
            Inputs.Inputs.Joints.JointMode_2                        := TO_USINT(_data[98]);
            Inputs.Inputs.Joints.JointMode_3                        := TO_USINT(_data[99]);
            Inputs.Inputs.Joints.JointMode_4                        := TO_USINT(_data[100]);
            Inputs.Inputs.Joints.JointMode_5                        := TO_USINT(_data[101]);

            //INPUTS T20 TCP => st_URO_CB3_T2OTcpData
            returnValue := Siemens.Simatic.S71500.DistributedIO.ReadData(_hwIdAxoUrRobotics_T2O_TCP, _data);
            Messenger.ActivateOnCondition(ULINT#715,returnValue > WORD#0, eAxoMessageCategory#ProgrammingError);
            IF returnValue > WORD#0 THEN
                RobotStatus.Error.Id := UINT#715;
                RETURN;
            END_IF;
            _dword.%B3                                              := _data[0];
            _dword.%B2                                              := _data[1];
            _dword.%B1                                              := _data[2];
            _dword.%B0                                              := _data[3];
            Inputs.Inputs.TCP.Postition.X                           := REAL#1000.0 * TO_REAL(_dword);  

            _dword.%B3                                              := _data[4];
            _dword.%B2                                              := _data[5];
            _dword.%B1                                              := _data[6];
            _dword.%B0                                              := _data[7];
            Inputs.Inputs.TCP.Postition.Y                           := REAL#1000.0 * TO_REAL(_dword);  

            _dword.%B3                                              := _data[8];
            _dword.%B2                                              := _data[9];
            _dword.%B1                                              := _data[10];
            _dword.%B0                                              := _data[11];
            Inputs.Inputs.TCP.Postition.Z                           := REAL#1000.0 * TO_REAL(_dword);  

            _dword.%B3                                              := _data[12];
            _dword.%B2                                              := _data[13];
            _dword.%B1                                              := _data[14];
            _dword.%B0                                              := _data[15];
            Inputs.Inputs.TCP.Postition.Rx                          := TO_REAL(_dword);  

            _dword.%B3                                              := _data[16];
            _dword.%B2                                              := _data[17];
            _dword.%B1                                              := _data[18];
            _dword.%B0                                              := _data[19];
            Inputs.Inputs.TCP.Postition.Ry                          := TO_REAL(_dword);  

            _dword.%B3                                              := _data[20];
            _dword.%B2                                              := _data[21];
            _dword.%B1                                              := _data[22];
            _dword.%B0                                              := _data[23];
            Inputs.Inputs.TCP.Postition.Rz                          := TO_REAL(_dword);  

            _dword.%B3                                              := _data[24];
            _dword.%B2                                              := _data[25];
            _dword.%B1                                              := _data[26];
            _dword.%B0                                              := _data[27];
            Inputs.Inputs.TCP.Velocity.X                            := REAL#1000.0 * TO_REAL(_dword);  

            _dword.%B3                                              := _data[28];
            _dword.%B2                                              := _data[29];
            _dword.%B1                                              := _data[30];
            _dword.%B0                                              := _data[31];
            Inputs.Inputs.TCP.Velocity.Y                            := REAL#1000.0 * TO_REAL(_dword);  

            _dword.%B3                                              := _data[32];
            _dword.%B2                                              := _data[33];
            _dword.%B1                                              := _data[34];
            _dword.%B0                                              := _data[35];
            Inputs.Inputs.TCP.Velocity.Z                            := REAL#1000.0 * TO_REAL(_dword);  

            _dword.%B3                                              := _data[36];
            _dword.%B2                                              := _data[37];
            _dword.%B1                                              := _data[38];
            _dword.%B0                                              := _data[39];
            Inputs.Inputs.TCP.Velocity.Rx                           := TO_REAL(_dword);  

            _dword.%B3                                              := _data[40];
            _dword.%B2                                              := _data[41];
            _dword.%B1                                              := _data[42];
            _dword.%B0                                              := _data[43];
            Inputs.Inputs.TCP.Velocity.Ry                           := TO_REAL(_dword);  

            _dword.%B3                                              := _data[44];
            _dword.%B2                                              := _data[45];
            _dword.%B1                                              := _data[46];
            _dword.%B0                                              := _data[47];
            Inputs.Inputs.TCP.Velocity.Rz                           := TO_REAL(_dword);  

            _dword.%B3                                              := _data[48];
            _dword.%B2                                              := _data[49];
            _dword.%B1                                              := _data[50];
            _dword.%B0                                              := _data[51];
            Inputs.Inputs.TCP.Force.X                               := TO_REAL(_dword);  

            _dword.%B3                                              := _data[52];
            _dword.%B2                                              := _data[53];
            _dword.%B1                                              := _data[54];
            _dword.%B0                                              := _data[55];
            Inputs.Inputs.TCP.Force.Y                               := TO_REAL(_dword);  

            _dword.%B3                                              := _data[56];
            _dword.%B2                                              := _data[57];
            _dword.%B1                                              := _data[58];
            _dword.%B0                                              := _data[59];
            Inputs.Inputs.TCP.Force.Z                               := TO_REAL(_dword);  

            _dword.%B3                                              := _data[60];
            _dword.%B2                                              := _data[61];
            _dword.%B1                                              := _data[62];
            _dword.%B0                                              := _data[63];
            Inputs.Inputs.TCP.Torque.X                              := TO_REAL(_dword);  

            _dword.%B3                                              := _data[64];
            _dword.%B2                                              := _data[65];
            _dword.%B1                                              := _data[66];
            _dword.%B0                                              := _data[67];
            Inputs.Inputs.TCP.Torque.Y                              := TO_REAL(_dword);  

            _dword.%B3                                              := _data[68];
            _dword.%B2                                              := _data[69];
            _dword.%B1                                              := _data[70];
            _dword.%B0                                              := _data[71];
            Inputs.Inputs.TCP.Torque.Z                              := TO_REAL(_dword);  

            _dword.%B3                                              := _data[72];
            _dword.%B2                                              := _data[73];
            _dword.%B1                                              := _data[74];
            _dword.%B0                                              := _data[75];
            Inputs.Inputs.TCP.TCP_ForceScalar                       := TO_REAL(_dword);  

            //INPUTS T20 BITS => st_URO_CB3_T2OBitRegsData
            returnValue := Siemens.Simatic.S71500.DistributedIO.ReadData(_hwIdAxoUrRobotics_T2O_General_Purpose_Bit_Registers, _data);
            Messenger.ActivateOnCondition(ULINT#716,returnValue > WORD#0, eAxoMessageCategory#ProgrammingError);
            IF returnValue > WORD#0 THEN
                RobotStatus.Error.Id := UINT#716;
                RETURN;
            END_IF;
            Inputs.Inputs.Bits.Register_0                           := _data[0].%X0;
            Inputs.Inputs.Bits.Register_1                           := _data[0].%X1;
            Inputs.Inputs.Bits.Register_2                           := _data[0].%X2;
            Inputs.Inputs.Bits.Register_3                           := _data[0].%X3;
            Inputs.Inputs.Bits.Register_4                           := _data[0].%X4;
            Inputs.Inputs.Bits.Register_5                           := _data[0].%X5;
            Inputs.Inputs.Bits.Register_6                           := _data[0].%X6;
            Inputs.Inputs.Bits.Register_7                           := _data[0].%X7;

            Inputs.Inputs.Bits.Register_8                           := _data[1].%X0;
            Inputs.Inputs.Bits.Register_9                           := _data[1].%X1;
            Inputs.Inputs.Bits.Register_10                          := _data[1].%X2;
            Inputs.Inputs.Bits.Register_11                          := _data[1].%X3;
            Inputs.Inputs.Bits.Register_12                          := _data[1].%X4;
            Inputs.Inputs.Bits.Register_13                          := _data[1].%X5;
            Inputs.Inputs.Bits.Register_14                          := _data[1].%X6;
            Inputs.Inputs.Bits.Register_15                          := _data[1].%X7;

            Inputs.Inputs.Bits.Register_16                          := _data[2].%X0;
            Inputs.Inputs.Bits.Register_17                          := _data[2].%X1;
            Inputs.Inputs.Bits.Register_18                          := _data[2].%X2;
            Inputs.Inputs.Bits.Register_19                          := _data[2].%X3;
            Inputs.Inputs.Bits.Register_20                          := _data[2].%X4;
            Inputs.Inputs.Bits.Register_21                          := _data[2].%X5;
            Inputs.Inputs.Bits.Register_22                          := _data[2].%X6;
            Inputs.Inputs.Bits.Register_23                          := _data[2].%X7;

            Inputs.Inputs.Bits.Register_24                          := _data[3].%X0;
            Inputs.Inputs.Bits.Register_25                          := _data[3].%X1;
            Inputs.Inputs.Bits.Register_26                          := _data[3].%X2;
            Inputs.Inputs.Bits.Register_27                          := _data[3].%X3;
            Inputs.Inputs.Bits.Register_28                          := _data[3].%X4;
            Inputs.Inputs.Bits.Register_29                          := _data[3].%X5;
            Inputs.Inputs.Bits.Register_30                          := _data[3].%X6;
            Inputs.Inputs.Bits.Register_31                          := _data[3].%X7;
            
            Inputs.Inputs.Bits.Register_32                          := _data[4].%X0;
            Inputs.Inputs.Bits.Register_33                          := _data[4].%X1;
            Inputs.Inputs.Bits.Register_34                          := _data[4].%X2;
            Inputs.Inputs.Bits.Register_35                          := _data[4].%X3;
            Inputs.Inputs.Bits.Register_36                          := _data[4].%X4;
            Inputs.Inputs.Bits.Register_37                          := _data[4].%X5;
            Inputs.Inputs.Bits.Register_38                          := _data[4].%X6;
            Inputs.Inputs.Bits.Register_39                          := _data[4].%X7;

            Inputs.Inputs.Bits.Register_40                          := _data[5].%X0;
            Inputs.Inputs.Bits.Register_41                          := _data[5].%X1;
            Inputs.Inputs.Bits.Register_42                          := _data[5].%X2;
            Inputs.Inputs.Bits.Register_43                          := _data[5].%X3;
            Inputs.Inputs.Bits.Register_44                          := _data[5].%X4;
            Inputs.Inputs.Bits.Register_45                          := _data[5].%X5;
            Inputs.Inputs.Bits.Register_46                          := _data[5].%X6;
            Inputs.Inputs.Bits.Register_47                          := _data[5].%X7;

            Inputs.Inputs.Bits.Register_48                          := _data[6].%X0;
            Inputs.Inputs.Bits.Register_49                          := _data[6].%X1;
            Inputs.Inputs.Bits.Register_50                          := _data[6].%X2;
            Inputs.Inputs.Bits.Register_51                          := _data[6].%X3;
            Inputs.Inputs.Bits.Register_52                          := _data[6].%X4;
            Inputs.Inputs.Bits.Register_53                          := _data[6].%X5;
            Inputs.Inputs.Bits.Register_54                          := _data[6].%X6;
            Inputs.Inputs.Bits.Register_55                          := _data[6].%X7;

            Inputs.Inputs.Bits.Register_56                          := _data[7].%X0;
            Inputs.Inputs.Bits.Register_57                          := _data[7].%X1;
            Inputs.Inputs.Bits.Register_58                          := _data[7].%X2;
            Inputs.Inputs.Bits.Register_59                          := _data[7].%X3;
            Inputs.Inputs.Bits.Register_60                          := _data[7].%X4;
            Inputs.Inputs.Bits.Register_61                          := _data[7].%X5;
            Inputs.Inputs.Bits.Register_62                          := _data[7].%X6;
            Inputs.Inputs.Bits.Register_63                          := _data[7].%X7;

            //INPUTS T20 BITS => st_URO_CB3_T2OIntRegsData
            returnValue := Siemens.Simatic.S71500.DistributedIO.ReadData(_hwIdAxoUrRobotics_T2O_General_Purpose_Int_Registers, _data);
            Messenger.ActivateOnCondition(ULINT#717,returnValue > WORD#0, eAxoMessageCategory#ProgrammingError);
            IF returnValue > WORD#0 THEN
                RobotStatus.Error.Id := UINT#717;
                RETURN;
            END_IF;
            _dword.%B3                                              := _data[0];
            _dword.%B2                                              := _data[1];
            _dword.%B1                                              := _data[2];
            _dword.%B0                                              := _data[3];
            Inputs.Inputs.Ints.Register_0                           := TO_DINT(_dword);

            _dword.%B3                                              := _data[4];
            _dword.%B2                                              := _data[5];
            _dword.%B1                                              := _data[6];
            _dword.%B0                                              := _data[7];
            Inputs.Inputs.Ints.Register_1                           := TO_DINT(_dword);

            _dword.%B3                                              := _data[8];
            _dword.%B2                                              := _data[9];
            _dword.%B1                                              := _data[10];
            _dword.%B0                                              := _data[11];
            Inputs.Inputs.Ints.Register_2                           := TO_DINT(_dword);

            _dword.%B3                                              := _data[12];
            _dword.%B2                                              := _data[13];
            _dword.%B1                                              := _data[14];
            _dword.%B0                                              := _data[15];
            Inputs.Inputs.Ints.Register_3                           := TO_DINT(_dword);

            _dword.%B3                                              := _data[16];
            _dword.%B2                                              := _data[17];
            _dword.%B1                                              := _data[18];
            _dword.%B0                                              := _data[19];
            Inputs.Inputs.Ints.Register_4                           := TO_DINT(_dword);

            _dword.%B3                                              := _data[20];
            _dword.%B2                                              := _data[21];
            _dword.%B1                                              := _data[22];
            _dword.%B0                                              := _data[23];
            Inputs.Inputs.Ints.Register_5                           := TO_DINT(_dword);

            _dword.%B3                                              := _data[24];
            _dword.%B2                                              := _data[25];
            _dword.%B1                                              := _data[26];
            _dword.%B0                                              := _data[27];
            Inputs.Inputs.Ints.Register_6                           := TO_DINT(_dword);

            _dword.%B3                                              := _data[28];
            _dword.%B2                                              := _data[29];
            _dword.%B1                                              := _data[30];
            _dword.%B0                                              := _data[31];
            Inputs.Inputs.Ints.Register_7                           := TO_DINT(_dword);

            _dword.%B3                                              := _data[32];
            _dword.%B2                                              := _data[33];
            _dword.%B1                                              := _data[34];
            _dword.%B0                                              := _data[35];
            Inputs.Inputs.Ints.Register_8                           := TO_DINT(_dword);

            _dword.%B3                                              := _data[36];
            _dword.%B2                                              := _data[37];
            _dword.%B1                                              := _data[38];
            _dword.%B0                                              := _data[39];
            Inputs.Inputs.Ints.Register_9                           := TO_DINT(_dword);

            _dword.%B3                                              := _data[40];
            _dword.%B2                                              := _data[41];
            _dword.%B1                                              := _data[42];
            _dword.%B0                                              := _data[43];
            Inputs.Inputs.Ints.Register_10                          := TO_DINT(_dword);

            _dword.%B3                                              := _data[44];
            _dword.%B2                                              := _data[45];
            _dword.%B1                                              := _data[46];
            _dword.%B0                                              := _data[47];
            Inputs.Inputs.Ints.Register_11                          := TO_DINT(_dword);

            _dword.%B3                                              := _data[48];
            _dword.%B2                                              := _data[49];
            _dword.%B1                                              := _data[50];
            _dword.%B0                                              := _data[51];
            Inputs.Inputs.Ints.Register_12                          := TO_DINT(_dword);

            _dword.%B3                                              := _data[52];
            _dword.%B2                                              := _data[53];
            _dword.%B1                                              := _data[54];
            _dword.%B0                                              := _data[55];
            Inputs.Inputs.Ints.Register_13                          := TO_DINT(_dword);

            _dword.%B3                                              := _data[56];
            _dword.%B2                                              := _data[57];
            _dword.%B1                                              := _data[58];
            _dword.%B0                                              := _data[59];
            Inputs.Inputs.Ints.Register_14                          := TO_DINT(_dword);

            _dword.%B3                                              := _data[60];
            _dword.%B2                                              := _data[61];
            _dword.%B1                                              := _data[62];
            _dword.%B0                                              := _data[63];
            Inputs.Inputs.Ints.Register_15                          := TO_DINT(_dword);

            _dword.%B3                                              := _data[64];
            _dword.%B2                                              := _data[65];
            _dword.%B1                                              := _data[66];
            _dword.%B0                                              := _data[67];
            Inputs.Inputs.Ints.Register_16                          := TO_DINT(_dword);

            _dword.%B3                                              := _data[68];
            _dword.%B2                                              := _data[69];
            _dword.%B1                                              := _data[70];
            _dword.%B0                                              := _data[71];
            Inputs.Inputs.Ints.Register_17                          := TO_DINT(_dword);

            _dword.%B3                                              := _data[72];
            _dword.%B2                                              := _data[73];
            _dword.%B1                                              := _data[74];
            _dword.%B0                                              := _data[75];
            Inputs.Inputs.Ints.Register_18                          := TO_DINT(_dword);

            _dword.%B3                                              := _data[76];
            _dword.%B2                                              := _data[77];
            _dword.%B1                                              := _data[78];
            _dword.%B0                                              := _data[79];
            Inputs.Inputs.Ints.Register_19                          := TO_DINT(_dword);

            _dword.%B3                                              := _data[80];
            _dword.%B2                                              := _data[81];
            _dword.%B1                                              := _data[82];
            _dword.%B0                                              := _data[83];
            Inputs.Inputs.Ints.Register_20                          := TO_DINT(_dword);

            _dword.%B3                                              := _data[84];
            _dword.%B2                                              := _data[85];
            _dword.%B1                                              := _data[86];
            _dword.%B0                                              := _data[87];
            Inputs.Inputs.Ints.Register_21                          := TO_DINT(_dword);

            _dword.%B3                                              := _data[88];
            _dword.%B2                                              := _data[89];
            _dword.%B1                                              := _data[90];
            _dword.%B0                                              := _data[91];
            Inputs.Inputs.Ints.Register_22                          := TO_DINT(_dword);

            _dword.%B3                                              := _data[92];
            _dword.%B2                                              := _data[93];
            _dword.%B1                                              := _data[94];
            _dword.%B0                                              := _data[95];
            Inputs.Inputs.Ints.Register_23                          := TO_DINT(_dword);

            //INPUTS T20 BITS => st_URO_CB3_T2OFloatRegsData
            returnValue := Siemens.Simatic.S71500.DistributedIO.ReadData(_hwIdAxoUrRobotics_T2O_General_Purpose_Float_Registers, _data);
            Messenger.ActivateOnCondition(ULINT#718,returnValue > WORD#0, eAxoMessageCategory#ProgrammingError);
            IF returnValue > WORD#0 THEN
                RobotStatus.Error.Id := UINT#718;
                RETURN;
            END_IF;
            _dword.%B3                                              := _data[0];
            _dword.%B2                                              := _data[1];
            _dword.%B1                                              := _data[2];
            _dword.%B0                                              := _data[3];
            Inputs.Inputs.Floats.Register_0                         := TO_REAL(_dword);

            _dword.%B3                                              := _data[4];
            _dword.%B2                                              := _data[5];
            _dword.%B1                                              := _data[6];
            _dword.%B0                                              := _data[7];
            Inputs.Inputs.Floats.Register_1                         := TO_REAL(_dword);

            _dword.%B3                                              := _data[8];
            _dword.%B2                                              := _data[9];
            _dword.%B1                                              := _data[10];
            _dword.%B0                                              := _data[11];
            Inputs.Inputs.Floats.Register_2                         := TO_REAL(_dword);

            _dword.%B3                                              := _data[12];
            _dword.%B2                                              := _data[13];
            _dword.%B1                                              := _data[14];
            _dword.%B0                                              := _data[15];
            Inputs.Inputs.Floats.Register_3                         := TO_REAL(_dword);

            _dword.%B3                                              := _data[16];
            _dword.%B2                                              := _data[17];
            _dword.%B1                                              := _data[18];
            _dword.%B0                                              := _data[19];
            Inputs.Inputs.Floats.Register_4                         := TO_REAL(_dword);

            _dword.%B3                                              := _data[20];
            _dword.%B2                                              := _data[21];
            _dword.%B1                                              := _data[22];
            _dword.%B0                                              := _data[23];
            Inputs.Inputs.Floats.Register_5                         := TO_REAL(_dword);

            _dword.%B3                                              := _data[24];
            _dword.%B2                                              := _data[25];
            _dword.%B1                                              := _data[26];
            _dword.%B0                                              := _data[27];
            Inputs.Inputs.Floats.Register_6                         := TO_REAL(_dword);

            _dword.%B3                                              := _data[28];
            _dword.%B2                                              := _data[29];
            _dword.%B1                                              := _data[30];
            _dword.%B0                                              := _data[31];
            Inputs.Inputs.Floats.Register_7                         := TO_REAL(_dword);

            _dword.%B3                                              := _data[32];
            _dword.%B2                                              := _data[33];
            _dword.%B1                                              := _data[34];
            _dword.%B0                                              := _data[35];
            Inputs.Inputs.Floats.Register_8                         := TO_REAL(_dword);

            _dword.%B3                                              := _data[36];
            _dword.%B2                                              := _data[37];
            _dword.%B1                                              := _data[38];
            _dword.%B0                                              := _data[39];
            Inputs.Inputs.Floats.Register_9                         := TO_REAL(_dword);

            _dword.%B3                                              := _data[40];
            _dword.%B2                                              := _data[41];
            _dword.%B1                                              := _data[42];
            _dword.%B0                                              := _data[43];
            Inputs.Inputs.Floats.Register_10                        := TO_REAL(_dword);

            _dword.%B3                                              := _data[44];
            _dword.%B2                                              := _data[45];
            _dword.%B1                                              := _data[46];
            _dword.%B0                                              := _data[47];
            Inputs.Inputs.Floats.Register_11                        := TO_REAL(_dword);

            _dword.%B3                                              := _data[48];
            _dword.%B2                                              := _data[49];
            _dword.%B1                                              := _data[50];
            _dword.%B0                                              := _data[51];
            Inputs.Inputs.Floats.Register_12                        := TO_REAL(_dword);

            _dword.%B3                                              := _data[52];
            _dword.%B2                                              := _data[53];
            _dword.%B1                                              := _data[54];
            _dword.%B0                                              := _data[55];
            Inputs.Inputs.Floats.Register_13                        := TO_REAL(_dword);

            _dword.%B3                                              := _data[56];
            _dword.%B2                                              := _data[57];
            _dword.%B1                                              := _data[58];
            _dword.%B0                                              := _data[59];
            Inputs.Inputs.Floats.Register_14                        := TO_REAL(_dword);

            _dword.%B3                                              := _data[60];
            _dword.%B2                                              := _data[61];
            _dword.%B1                                              := _data[62];
            _dword.%B0                                              := _data[63];
            Inputs.Inputs.Floats.Register_15                        := TO_REAL(_dword);

            _dword.%B3                                              := _data[64];
            _dword.%B2                                              := _data[65];
            _dword.%B1                                              := _data[66];
            _dword.%B0                                              := _data[67];
            Inputs.Inputs.Floats.Register_16                        := TO_REAL(_dword);

            _dword.%B3                                              := _data[68];
            _dword.%B2                                              := _data[69];
            _dword.%B1                                              := _data[70];
            _dword.%B0                                              := _data[71];
            Inputs.Inputs.Floats.Register_17                        := TO_REAL(_dword);

            _dword.%B3                                              := _data[72];
            _dword.%B2                                              := _data[73];
            _dword.%B1                                              := _data[74];
            _dword.%B0                                              := _data[75];
            Inputs.Inputs.Floats.Register_18                        := TO_REAL(_dword);

            _dword.%B3                                              := _data[76];
            _dword.%B2                                              := _data[77];
            _dword.%B1                                              := _data[78];
            _dword.%B0                                              := _data[79];
            Inputs.Inputs.Floats.Register_19                        := TO_REAL(_dword);

            _dword.%B3                                              := _data[80];
            _dword.%B2                                              := _data[81];
            _dword.%B1                                              := _data[82];
            _dword.%B0                                              := _data[83];
            Inputs.Inputs.Floats.Register_20                        := TO_REAL(_dword);

            _dword.%B3                                              := _data[84];
            _dword.%B2                                              := _data[85];
            _dword.%B1                                              := _data[86];
            _dword.%B0                                              := _data[87];
            Inputs.Inputs.Floats.Register_21                        := TO_REAL(_dword);

            _dword.%B3                                              := _data[88];
            _dword.%B2                                              := _data[89];
            _dword.%B1                                              := _data[90];
            _dword.%B0                                              := _data[91];
            Inputs.Inputs.Floats.Register_22                        := TO_REAL(_dword);

            _dword.%B3                                              := _data[92];
            _dword.%B2                                              := _data[93];
            _dword.%B1                                              := _data[94];
            _dword.%B0                                              := _data[95];
            Inputs.Inputs.Floats.Register_23                        := TO_REAL(_dword);


             Inputs.RobotMode := THIS.GetRobotModeDescription(Inputs.Inputs.Robot.RobotMode);
            //SYSTEM INPUTS
            //Area/positions flags this  should be obsolete because Zones and InPosition is used as byte below
            Inputs.InArea_1                                         := Inputs.Inputs.Bits.Register_0;
            Inputs.InArea_2                                         := Inputs.Inputs.Bits.Register_1;
            Inputs.InArea_3                                         := Inputs.Inputs.Bits.Register_2;
            Inputs.InArea_4                                         := Inputs.Inputs.Bits.Register_3;
            Inputs.InPosition_1                                     := Inputs.Inputs.Bits.Register_4;
            Inputs.InPosition_2                                     := Inputs.Inputs.Bits.Register_5;
            Inputs.InPosition_3                                     := Inputs.Inputs.Bits.Register_6;
            Inputs.InPosition_4                                     := Inputs.Inputs.Bits.Register_7;
            
            //Tool signals

            Inputs.Tool_1_Retract                                   := Inputs.Inputs.Bits.Register_8;
            Inputs.Tool_1_Extend                                    := Inputs.Inputs.Bits.Register_9;
            Inputs.Tool_2_Retract                                   := Inputs.Inputs.Bits.Register_10;
            Inputs.Tool_2_Extend                                    := Inputs.Inputs.Bits.Register_11;
            Inputs.Tool_3_Retract                                   := Inputs.Inputs.Bits.Register_12;
            Inputs.Tool_3_Extend                                    := Inputs.Inputs.Bits.Register_13;
            Inputs.Tool_4_Retract                                   := Inputs.Inputs.Bits.Register_14;
            Inputs.Tool_4_Extend                                    := Inputs.Inputs.Bits.Register_15;

            Inputs.Zone                                             := Inputs.Inputs.Ints.Register_0;
            Inputs.InPosition                                       := Inputs.Inputs.Ints.Register_1;

           //Movement parameters
            Inputs.ActionNo                                         := Inputs.Inputs.Ints.Register_2;
            Inputs.GlobalSpeed                                      := Inputs.Inputs.Ints.Register_3;
            Inputs.ToolNo                                           := Inputs.Inputs.Ints.Register_4;
            Inputs.WorkobjectNo                                     := Inputs.Inputs.Ints.Register_5;
            Inputs.PointNo                                          := Inputs.Inputs.Ints.Register_6;

            Inputs.UserSpecSpeed1                                   := Inputs.Inputs.Floats.Register_0;
            Inputs.UserSpecSpeed2                                   := Inputs.Inputs.Floats.Register_1;
            Inputs.Coordinates.X                                    := Inputs.Inputs.Floats.Register_2;
            Inputs.Coordinates.Y                                    := Inputs.Inputs.Floats.Register_3;
            Inputs.Coordinates.Z                                    := Inputs.Inputs.Floats.Register_4;
            Inputs.Coordinates.Rx                                   := Inputs.Inputs.Floats.Register_5;
            Inputs.Coordinates.Ry                                   := Inputs.Inputs.Floats.Register_6;
            Inputs.Coordinates.Rz                                   := Inputs.Inputs.Floats.Register_7;

            //*******************************************
            _context := THIS.GetContext();

            _infoTime := Config.InfoTime;
            _errorTime := Config.ErrorTime;

            //*************INITIALIZATION*************
            RestoreTask.Initialize(THIS);
            PowerOnTask.Initialize(THIS);
            StopMovementsTask.Initialize(THIS);
            StopMovementsAndProgramTask.Initialize(THIS);
            StopProgramTask.Initialize(THIS);
            // StopMotorsTask.Initialize(THIS);
            StartAtMainTask.Initialize(THIS);
            StartMotorsAndProgramTask.Initialize(THIS);
            StartProgramTask.Initialize(THIS);
            StartMotorsTask.Initialize(THIS);
            StartMovementsTask.Initialize(THIS);
            StartMotorsProgramAndMovementsTask.Initialize(THIS);
            HardwareDiagnosticsTask.Initialize(THIS);

            _stopTasksAreActive := StopMovementsTask.IsBusy() OR StopMovementsAndProgramTask.IsBusy() OR StopProgramTask.IsBusy();// OR StopMotorsTask.IsBusy();
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
            StartAtMainTask.IsDisabled := _stopTasksAreActive;
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
                
                IF _progress = 300 THEN  
                    TaskMessenger.ActivateOnCondition(ULINT#500, _infoTimer.output AND NOT Inputs.Inputs.Safety.NO_IsNormalMode , eAxoMessageCategory#Warning);
                    TaskMessenger.ActivateOnCondition(ULINT#501, _infoTimer.output AND NOT Inputs.Inputs.Safety.RD_IsReducedMode , eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        IF NOT Inputs.Inputs.Safety.NO_IsNormalMode THEN
                            RobotStatus.Error.Id := UINT#500;
                        END_IF;
                        IF NOT Inputs.Inputs.Safety.RD_IsReducedMode THEN
                            RobotStatus.Error.Id := UINT#501;
                        END_IF;
                    END_IF;

                    IF Inputs.Inputs.Safety.NO_IsNormalMode OR Inputs.Inputs.Safety.RD_IsReducedMode THEN
                        THIS.CallTimers(FALSE);
                        _progress:=302;                    
                    END_IF;
                END_IF;

                IF _progress = 302 THEN  
                    TaskMessenger.ActivateOnCondition(ULINT#502, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        RobotStatus.Error.Id := UINT#502;
                    END_IF;

                    IF Inputs.Inputs.Robot.PR_IsProgramRunning THEN
                        THIS.CallTimers(FALSE);
                        _progress:=303;                    
                    END_IF;
                END_IF;

                IF _progress = 303 THEN  
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
                    RobotStatus.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 310;
                END_IF;
              
                IF _progress = 310 THEN  
                    TaskMessenger.ActivateOnCondition(ULINT#510, _infoTimer.output AND NOT Inputs.Inputs.Safety.NO_IsNormalMode , eAxoMessageCategory#Warning);
                    TaskMessenger.ActivateOnCondition(ULINT#511, _infoTimer.output AND NOT Inputs.Inputs.Safety.RD_IsReducedMode , eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        IF NOT Inputs.Inputs.Safety.NO_IsNormalMode THEN
                            RobotStatus.Error.Id := UINT#510;
                        END_IF;
                        IF NOT Inputs.Inputs.Safety.RD_IsReducedMode THEN
                            RobotStatus.Error.Id := UINT#511;
                        END_IF;
                    END_IF;

                    IF Inputs.Inputs.Safety.NO_IsNormalMode OR Inputs.Inputs.Safety.RD_IsReducedMode THEN
                        THIS.CallTimers(FALSE);
                        _progress:=312;                    
                    END_IF;
                END_IF;

                IF _progress = 312 THEN	//Reseting error
                    TaskMessenger.ActivateOnCondition(ULINT#512, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        RobotStatus.Error.Id := UINT#512;
                    END_IF;

                    IF NOT Inputs.Inputs.Safety.FT_IsFault THEN
                        THIS.CallTimers(FALSE);
                        _progress := 313;
                    END_IF;
                END_IF;
              
                IF _progress = 313 THEN	//Reseting emergency stop error
                    TaskMessenger.ActivateOnCondition(ULINT#513, _infoTimer.output AND Inputs.Inputs.Safety.ES_IsEmergencyStopped , eAxoMessageCategory#Warning);
                    TaskMessenger.ActivateOnCondition(ULINT#514, _infoTimer.output AND Inputs.Inputs.Safety.PS_IsProtectiveStopped , eAxoMessageCategory#Warning);
                    TaskMessenger.ActivateOnCondition(ULINT#515, _infoTimer.output AND Inputs.Inputs.Safety.SS_IsSafeguardStopped , eAxoMessageCategory#Warning);
                    TaskMessenger.ActivateOnCondition(ULINT#516, _infoTimer.output AND Inputs.Inputs.Safety.RC_IsRecoveryMode , eAxoMessageCategory#Warning);
                    TaskMessenger.ActivateOnCondition(ULINT#517, _infoTimer.output AND Inputs.Inputs.Safety.ST_IsStoppedDueSafety , eAxoMessageCategory#Warning);
                    TaskMessenger.ActivateOnCondition(ULINT#518, _infoTimer.output AND Inputs.Inputs.Safety.VL_IsViolation , eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        IF Inputs.Inputs.Safety.ES_IsEmergencyStopped  THEN
                            RobotStatus.Error.Id := UINT#513;
                        END_IF;
                        IF Inputs.Inputs.Safety.PS_IsProtectiveStopped  THEN
                            RobotStatus.Error.Id := UINT#514;
                        END_IF;
                        IF Inputs.Inputs.Safety.SS_IsSafeguardStopped  THEN
                            RobotStatus.Error.Id := UINT#515;
                        END_IF;
                        IF Inputs.Inputs.Safety.RC_IsRecoveryMode  THEN
                            RobotStatus.Error.Id := UINT#516;
                        END_IF;
                        IF Inputs.Inputs.Safety.ST_IsStoppedDueSafety  THEN
                            RobotStatus.Error.Id := UINT#517;
                        END_IF;
                        IF Inputs.Inputs.Safety.VL_IsViolation  THEN
                            RobotStatus.Error.Id := UINT#518;
                        END_IF;
                    END_IF;

                    IF NOT Inputs.Inputs.Safety.ES_IsEmergencyStopped 
                        AND NOT Inputs.Inputs.Safety.PS_IsProtectiveStopped  
                        AND NOT Inputs.Inputs.Safety.SS_IsSafeguardStopped  
                        AND NOT Inputs.Inputs.Safety.RC_IsRecoveryMode 
                        AND NOT Inputs.Inputs.Safety.ST_IsStoppedDueSafety 
                        AND NOT Inputs.Inputs.Safety.VL_IsViolation THEN
                        THIS.CallTimers(FALSE);
                        _progress := 319;
                    END_IF;
                END_IF;
              
                IF _progress = 319 THEN	
                    TaskMessenger.ActivateOnCondition(ULINT#519, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        RobotStatus.Error.Id := UINT#519;
                    END_IF;

                    Outputs.MotorOn:=_blink.output;	

                    IF Inputs.Inputs.Safety.FT_IsFault THEN 
                        THIS.CallTimers(FALSE);
                        _progress := 310;
                    END_IF;

                    IF Inputs.Inputs.Robot.PW_IsPowerOn THEN
                         Outputs.MotorOn:=FALSE;
                         THIS.CallTimers(FALSE);
                         _progress := 320;
                    END_IF;
                END_IF;		

                IF _progress = 320 THEN	
                    TaskMessenger.ActivateOnCondition(ULINT#520, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        RobotStatus.Error.Id := UINT#520;
                    END_IF;

                    Outputs.MotorOn:=_blink.output;	

                    IF Inputs.Inputs.Safety.FT_IsFault THEN 
                        THIS.CallTimers(FALSE);
                        _progress := 310;
                    END_IF;

                    IF Inputs.Inputs.Robot.PW_IsPowerOn THEN
                         Outputs.MotorOn:=FALSE;
                         THIS.CallTimers(FALSE);
                         _progress := 321;
                    END_IF;
                END_IF;		

                IF _progress = 321 THEN	
                    TaskMessenger.ActivateOnCondition(ULINT#521, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        RobotStatus.Error.Id := UINT#521;
                    END_IF;

                    Outputs.Start:=_blink.output;	

                    IF Inputs.Inputs.Safety.FT_IsFault THEN 
                        THIS.CallTimers(FALSE);
                        _progress := 310;
                    END_IF;

                    IF Inputs.Inputs.Robot.PR_IsProgramRunning AND NOT Inputs.Inputs.Safety.FT_IsFault THEN
                         Outputs.Start:=FALSE;
                         THIS.CallTimers(FALSE);
                         _progress := 322;
                    END_IF;
                END_IF;		
              
                IF _progress = 322 THEN	
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
            IF StartMotorsAndProgramTask.RestoreTriggered() AND _progress >= 310 AND _progress <= 329  THEN
                RobotStatus.Action.Id :=  UINT#112;
                _progress := 0;
            END_IF;   
            //*******************************************
                        
            //***********StartMotorsProgramAndMovementsTask*******
            StartMotorsProgramAndMovementsTask.IsDisabled := _stopTasksAreActive OR StartProgramTask.IsBusy() OR StartMotorsTask.IsBusy() OR StartMovementsTask.IsBusy();
            IF StartMotorsProgramAndMovementsTask.StartTriggered() THEN
                RobotStatus.Action.Id :=  UINT#130;
            END_IF;
            Messenger.ActivateOnCondition(ULINT#130,StartMotorsProgramAndMovementsTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#131,StartMotorsProgramAndMovementsTask.IsDone(), eAxoMessageCategory#Info);
            IF StartMotorsProgramAndMovementsTask.Execute() THEN
                _blink.Blink(Context := _context, inOnTime:=T#500MS,inOffTime:=T#500MS);

                IF _progress = 0 THEN
                    RobotStatus.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 330;
                END_IF;
              
                IF _progress = 330 THEN  
                    TaskMessenger.ActivateOnCondition(ULINT#530, _infoTimer.output AND NOT Inputs.Inputs.Safety.NO_IsNormalMode, eAxoMessageCategory#Warning);
                    TaskMessenger.ActivateOnCondition(ULINT#531, _infoTimer.output AND NOT Inputs.Inputs.Safety.RD_IsReducedMode, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        IF NOT Inputs.Inputs.Safety.NO_IsNormalMode THEN
                            RobotStatus.Error.Id := UINT#530;
                        END_IF;
                        IF NOT Inputs.Inputs.Safety.RD_IsReducedMode THEN
                            RobotStatus.Error.Id := UINT#531;
                        END_IF;      
                    END_IF;

                    IF Inputs.Inputs.Safety.NO_IsNormalMode OR Inputs.Inputs.Safety.RD_IsReducedMode THEN
                        THIS.CallTimers(FALSE);
                        _progress:=332;                    
                    END_IF;
                END_IF;

                IF _progress = 332 THEN	//Reseting error
                    TaskMessenger.ActivateOnCondition(ULINT#632, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        RobotStatus.Error.Id := UINT#632;
                    END_IF;

                    IF NOT Inputs.Inputs.Safety.FT_IsFault THEN
                        THIS.CallTimers(FALSE);
                        _progress := 333;
                    END_IF;
                END_IF;
              
                IF _progress = 333 THEN	//Reseting emergency stop error
                    TaskMessenger.ActivateOnCondition(ULINT#533, _infoTimer.output AND Inputs.Inputs.Safety.ES_IsEmergencyStopped , eAxoMessageCategory#Warning);
                    TaskMessenger.ActivateOnCondition(ULINT#534, _infoTimer.output AND Inputs.Inputs.Safety.PS_IsProtectiveStopped , eAxoMessageCategory#Warning);
                    TaskMessenger.ActivateOnCondition(ULINT#535, _infoTimer.output AND Inputs.Inputs.Safety.SS_IsSafeguardStopped , eAxoMessageCategory#Warning);
                    TaskMessenger.ActivateOnCondition(ULINT#536, _infoTimer.output AND Inputs.Inputs.Safety.RC_IsRecoveryMode , eAxoMessageCategory#Warning);
                    TaskMessenger.ActivateOnCondition(ULINT#537, _infoTimer.output AND Inputs.Inputs.Safety.ST_IsStoppedDueSafety , eAxoMessageCategory#Warning);
                    TaskMessenger.ActivateOnCondition(ULINT#538, _infoTimer.output AND Inputs.Inputs.Safety.VL_IsViolation , eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        IF Inputs.Inputs.Safety.ES_IsEmergencyStopped  THEN
                            RobotStatus.Error.Id := UINT#533;
                        END_IF;
                        IF Inputs.Inputs.Safety.PS_IsProtectiveStopped  THEN
                            RobotStatus.Error.Id := UINT#534;
                        END_IF;
                        IF Inputs.Inputs.Safety.SS_IsSafeguardStopped  THEN
                            RobotStatus.Error.Id := UINT#535;
                        END_IF;
                        IF Inputs.Inputs.Safety.RC_IsRecoveryMode  THEN
                            RobotStatus.Error.Id := UINT#536;
                        END_IF;
                        IF Inputs.Inputs.Safety.ST_IsStoppedDueSafety  THEN
                            RobotStatus.Error.Id := UINT#537;
                        END_IF;
                        IF Inputs.Inputs.Safety.VL_IsViolation  THEN
                            RobotStatus.Error.Id := UINT#538;
                        END_IF;
                    END_IF;

                    IF NOT Inputs.Inputs.Safety.ES_IsEmergencyStopped 
                        AND NOT Inputs.Inputs.Safety.PS_IsProtectiveStopped  
                        AND NOT Inputs.Inputs.Safety.SS_IsSafeguardStopped  
                        AND NOT Inputs.Inputs.Safety.RC_IsRecoveryMode 
                        AND NOT Inputs.Inputs.Safety.ST_IsStoppedDueSafety 
                        AND NOT Inputs.Inputs.Safety.VL_IsViolation THEN
                        THIS.CallTimers(FALSE);
                        _progress := 339;
                    END_IF;
                END_IF;
              
                IF _progress = 339 THEN	//Starting the motors
                    TaskMessenger.ActivateOnCondition(ULINT#539, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        RobotStatus.Error.Id := UINT#539;
                    END_IF;
                    
                    Outputs.MotorOn:=_blink.output;	

                    IF Inputs.Inputs.Safety.FT_IsFault THEN 
                        THIS.CallTimers(FALSE);
                        _progress := 330;
                    END_IF;

                    IF Inputs.Inputs.Robot.PW_IsPowerOn AND NOT Inputs.Inputs.Safety.FT_IsFault THEN
                         Outputs.MotorOn:=FALSE;
                         THIS.CallTimers(FALSE);
                         _progress := 340;
                    END_IF;
                END_IF;		

                IF _progress = 340 THEN	// Starting the program
                    TaskMessenger.ActivateOnCondition(ULINT#540, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        RobotStatus.Error.Id := UINT#540;
                    END_IF;
                    
                    Outputs.Start:=_blink.output;	

                    IF Inputs.Inputs.Safety.FT_IsFault THEN 
                        THIS.CallTimers(FALSE);
                        _progress := 330;
                    END_IF;

                    IF Inputs.Inputs.Robot.PR_IsProgramRunning AND NOT Inputs.Inputs.Safety.FT_IsFault THEN
                         Outputs.Start:=FALSE;
                         THIS.CallTimers(FALSE);
                         _progress := 341;
                    END_IF;
                END_IF;		
	
                IF _progress = 341 THEN // Setting the  movement parameters
                    TaskMessenger.ActivateOnCondition(ULINT#541, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        RobotStatus.Error.Id := UINT#541;
                    END_IF;
                    Outputs.GlobalSpeed     := TO_DINT(RobotStatus.CurrentMovementParameters.GlobalSpeed);
                    Outputs.ToolNo          := TO_DINT(RobotStatus.CurrentMovementParameters.ToolNo);
                    Outputs.WorkobjectNo    := TO_DINT(RobotStatus.CurrentMovementParameters.WorkobjectNo);
                    Outputs.PointNo         := TO_DINT(RobotStatus.CurrentMovementParameters.PointNo);
                    Outputs.UserSpecSpeed1  := RobotStatus.CurrentMovementParameters.UserSpecSpeed1;
                    Outputs.UserSpecSpeed2  := RobotStatus.CurrentMovementParameters.UserSpecSpeed2;
                    Outputs.Coordinates     := RobotStatus.CurrentMovementParameters.Coordinates; 		
                
                    Outputs.ActionNo := DINT#254;

                    IF Outputs.ActionNo = Inputs.ActionNo THEN
                        THIS.CallTimers(FALSE);
                        _progress := 342;
                    END_IF;
                END_IF;
                
                IF _progress = 342 THEN //Comparing the movement parameters.
                    TaskMessenger.ActivateOnCondition(ULINT#542, _infoTimer.output AND Inputs.GlobalSpeed <> TO_DINT(RobotStatus.CurrentMovementParameters.GlobalSpeed), eAxoMessageCategory#Warning);
                    TaskMessenger.ActivateOnCondition(ULINT#543, _infoTimer.output AND Inputs.ToolNo <> TO_DINT(RobotStatus.CurrentMovementParameters.ToolNo), eAxoMessageCategory#Warning);
                    TaskMessenger.ActivateOnCondition(ULINT#544, _infoTimer.output AND Inputs.WorkobjectNo <> TO_DINT(RobotStatus.CurrentMovementParameters.WorkobjectNo), eAxoMessageCategory#Warning);
                    TaskMessenger.ActivateOnCondition(ULINT#545, _infoTimer.output AND Inputs.PointNo <> TO_DINT(RobotStatus.CurrentMovementParameters.PointNo), eAxoMessageCategory#Warning);
                    TaskMessenger.ActivateOnCondition(ULINT#546, _infoTimer.output AND Inputs.UserSpecSpeed1 <> RobotStatus.CurrentMovementParameters.UserSpecSpeed1, eAxoMessageCategory#Warning);
                    TaskMessenger.ActivateOnCondition(ULINT#547, _infoTimer.output AND Inputs.UserSpecSpeed2 <> RobotStatus.CurrentMovementParameters.UserSpecSpeed2, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        IF Inputs.GlobalSpeed <> TO_DINT(RobotStatus.CurrentMovementParameters.GlobalSpeed) THEN
                            RobotStatus.Error.Id := UINT#542;//<#Waiting for Inputs.GlobalSpeed to be equal to MovementParameters.GlobalSpeed!
                        END_IF;
                        IF Inputs.ToolNo <> TO_DINT(RobotStatus.CurrentMovementParameters.ToolNo) THEN
                            RobotStatus.Error.Id := UINT#543;//<#Waiting for Inputs.ToolNo to be equal to MovementParameters.ToolNo!
                        END_IF;
                        IF Inputs.WorkobjectNo <> TO_DINT(RobotStatus.CurrentMovementParameters.WorkobjectNo) THEN
                            RobotStatus.Error.Id := UINT#544;//<#Waiting for Inputs.WorkobjectNo to be equal to MovementParameters.WorkobjectNo!
                        END_IF;
                        IF Inputs.PointNo <> TO_DINT(RobotStatus.CurrentMovementParameters.PointNo) THEN
                            RobotStatus.Error.Id := UINT#545;//<#Waiting for Inputs.PointNo to be equal to MovementParameters.PointNo!
                        END_IF;
                        IF Inputs.UserSpecSpeed1 <> RobotStatus.CurrentMovementParameters.UserSpecSpeed1 THEN
                            RobotStatus.Error.Id := UINT#546;//<#Waiting for Inputs.UserSpecSpeed1 to be equal to MovementParameters.UserSpecSpeed1!
                        END_IF;
                        IF Inputs.UserSpecSpeed2 <> RobotStatus.CurrentMovementParameters.UserSpecSpeed2 THEN
                            RobotStatus.Error.Id := UINT#547;//<#Waiting for Inputs.UserSpecSpeed2 to be equal to MovementParameters.UserSpecSpeed2!
                        END_IF;
                    END_IF;

                    IF 	Inputs.GlobalSpeed      = TO_DINT(RobotStatus.CurrentMovementParameters.GlobalSpeed) AND
                        Inputs.ToolNo           = TO_DINT(RobotStatus.CurrentMovementParameters.ToolNo) AND
                        Inputs.WorkobjectNo     = TO_DINT(RobotStatus.CurrentMovementParameters.WorkobjectNo) AND
                        Inputs.PointNo          = TO_DINT(RobotStatus.CurrentMovementParameters.PointNo) AND
                        Inputs.UserSpecSpeed1   = RobotStatus.CurrentMovementParameters.UserSpecSpeed1 AND
                        Inputs.UserSpecSpeed2   = RobotStatus.CurrentMovementParameters.UserSpecSpeed2 AND
                        AXOpen.Components.Robotics.CoordinatesAreNearlyEqual(Inputs.Coordinates,RobotStatus.CurrentMovementParameters.Coordinates,REAL#0.01,REAL#0.01,REAL#0.01,REAL#0.01,REAL#0.01,REAL#0.01) THEN
                        THIS.CallTimers(FALSE);
                        _progress:=348;
                    END_IF;
                END_IF;		

                IF _progress = 348 THEN //Acknowledging the movement parameters 
                    TaskMessenger.ActivateOnCondition(ULINT#548, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        RobotStatus.Error.Id := UINT#548;
                    END_IF;

                    Outputs.ActionNo := DINT#255;

                    IF Outputs.ActionNo = Inputs.ActionNo THEN
                        THIS.CallTimers(FALSE);
                        _progress:=349;
                    END_IF;
                END_IF;	
                
                IF _progress = 349 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#549, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        RobotStatus.Error.Id := UINT#549;
                    END_IF;
                    
                    Outputs.ActionNo := TO_DINT(RobotStatus.CurrentMovementParameters.ActionNo);

                    IF Outputs.ActionNo = Inputs.ActionNo THEN
                        THIS.CallTimers(FALSE);
                        _progress:=350;
                    END_IF;
                END_IF;	

                IF _progress = 350 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#550, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        RobotStatus.Error.Id := UINT#550;
                    END_IF;

                    Outputs.ActionNo := DINT#255;
	
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
                RobotStatus.Action.Id :=  UINT#131;
                RobotStatus.Error.Id :=  UINT#0;
            ELSIF StartMotorsProgramAndMovementsTask.ErrorOccured() THEN
                RobotStatus.Action.Id :=  UINT#830;
                RobotStatus.Error.Id  :=  UINT#830;
            ELSIF StartMotorsProgramAndMovementsTask.AbortTriggered() THEN
                RobotStatus.Action.Id :=  UINT#831;
                RobotStatus.Error.Id  :=  UINT#831;
            END_IF;    
            Messenger.ActivateOnCondition(ULINT#830,StartMotorsProgramAndMovementsTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#831,StartMotorsProgramAndMovementsTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#132,StartMotorsProgramAndMovementsTask.RestoreTriggered() , eAxoMessageCategory#Error);
            IF StartMotorsProgramAndMovementsTask.RestoreTriggered() AND _progress >= 330 AND _progress <= 359 THEN
                RobotStatus.Action.Id :=  UINT#132;
                _progress := 0;
            END_IF;  
            //*******************************************
                        
            //***********StartMotorsTask*****************
            StartMotorsTask.IsDisabled := _stopTasksAreActive OR StartMotorsProgramAndMovementsTask.IsBusy() OR StartMotorsAndProgramTask.IsBusy();
            IF StartMotorsTask.StartTriggered() THEN
                RobotStatus.Action.Id :=  UINT#160;
            END_IF;
            Messenger.ActivateOnCondition(ULINT#160,StartMotorsTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#161,StartMotorsTask.IsDone(), eAxoMessageCategory#Info);
            IF StartMotorsTask.Execute() THEN
                _blink.Blink(Context := _context, inOnTime:=T#500MS,inOffTime:=T#500MS);

                IF _progress = 0 THEN
                    RobotStatus.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 360;
                END_IF;
              
                IF _progress = 360 THEN  
                    TaskMessenger.ActivateOnCondition(ULINT#560, _infoTimer.output AND NOT Inputs.Inputs.Safety.NO_IsNormalMode, eAxoMessageCategory#Warning);
                    TaskMessenger.ActivateOnCondition(ULINT#561, _infoTimer.output AND NOT Inputs.Inputs.Safety.RD_IsReducedMode, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        IF NOT Inputs.Inputs.Safety.NO_IsNormalMode THEN
                            RobotStatus.Error.Id := UINT#560;
                        END_IF;
                        IF NOT Inputs.Inputs.Safety.RD_IsReducedMode THEN
                            RobotStatus.Error.Id := UINT#561;
                        END_IF;      
                    END_IF;

                    IF Inputs.Inputs.Safety.NO_IsNormalMode OR Inputs.Inputs.Safety.RD_IsReducedMode THEN
                        THIS.CallTimers(FALSE);
                        _progress:=362;                    
                    END_IF;

                END_IF;

                IF _progress = 362 THEN	//Reseting error
                    TaskMessenger.ActivateOnCondition(ULINT#562, _infoTimer.output, eAxoMessageCategory#Warning);

                    IF _infoTimer.output THEN
                        RobotStatus.Error.Id := UINT#562;
                    END_IF;

                    IF NOT Inputs.Inputs.Safety.FT_IsFault THEN
                        THIS.CallTimers(FALSE);
                        _progress := 363;
                    END_IF;
                END_IF;
              
                IF _progress = 363 THEN	//Reseting emergency stop error

                    TaskMessenger.ActivateOnCondition(ULINT#563, _infoTimer.output AND Inputs.Inputs.Safety.ES_IsEmergencyStopped , eAxoMessageCategory#Warning);
                    TaskMessenger.ActivateOnCondition(ULINT#564, _infoTimer.output AND Inputs.Inputs.Safety.PS_IsProtectiveStopped , eAxoMessageCategory#Warning);
                    TaskMessenger.ActivateOnCondition(ULINT#565, _infoTimer.output AND Inputs.Inputs.Safety.SS_IsSafeguardStopped , eAxoMessageCategory#Warning);
                    TaskMessenger.ActivateOnCondition(ULINT#566, _infoTimer.output AND Inputs.Inputs.Safety.RC_IsRecoveryMode , eAxoMessageCategory#Warning);
                    TaskMessenger.ActivateOnCondition(ULINT#567, _infoTimer.output AND Inputs.Inputs.Safety.ST_IsStoppedDueSafety , eAxoMessageCategory#Warning);
                    TaskMessenger.ActivateOnCondition(ULINT#568, _infoTimer.output AND Inputs.Inputs.Safety.VL_IsViolation , eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        IF Inputs.Inputs.Safety.ES_IsEmergencyStopped  THEN
                            RobotStatus.Error.Id := UINT#563;
                        END_IF;
                        IF Inputs.Inputs.Safety.PS_IsProtectiveStopped  THEN
                            RobotStatus.Error.Id := UINT#564;
                        END_IF;
                        IF Inputs.Inputs.Safety.SS_IsSafeguardStopped  THEN
                            RobotStatus.Error.Id := UINT#565;
                        END_IF;
                        IF Inputs.Inputs.Safety.RC_IsRecoveryMode  THEN
                            RobotStatus.Error.Id := UINT#566;
                        END_IF;
                        IF Inputs.Inputs.Safety.ST_IsStoppedDueSafety  THEN
                            RobotStatus.Error.Id := UINT#567;
                        END_IF;
                        IF Inputs.Inputs.Safety.VL_IsViolation  THEN
                            RobotStatus.Error.Id := UINT#568;
                        END_IF;
                    END_IF;

                    IF NOT Inputs.Inputs.Safety.ES_IsEmergencyStopped 
                        AND NOT Inputs.Inputs.Safety.PS_IsProtectiveStopped  
                        AND NOT Inputs.Inputs.Safety.SS_IsSafeguardStopped  
                        AND NOT Inputs.Inputs.Safety.RC_IsRecoveryMode 
                        AND NOT Inputs.Inputs.Safety.ST_IsStoppedDueSafety 
                        AND NOT Inputs.Inputs.Safety.VL_IsViolation THEN
                        THIS.CallTimers(FALSE);
                        _progress := 369;
                    END_IF;
                END_IF;
              
                IF _progress = 369 THEN	
                    TaskMessenger.ActivateOnCondition(ULINT#569, _infoTimer.output AND NOT Inputs.Inputs.Robot.PW_IsPowerOn, eAxoMessageCategory#Warning);
                    TaskMessenger.ActivateOnCondition(ULINT#570, _infoTimer.output AND Inputs.Inputs.Safety.FT_IsFault, eAxoMessageCategory#Warning);
                    TaskMessenger.ActivateOnCondition(ULINT#571, _infoTimer.output AND Inputs.Inputs.Joints.JointMode_0 <> 253 , eAxoMessageCategory#Warning);
                    TaskMessenger.ActivateOnCondition(ULINT#572, _infoTimer.output AND Inputs.Inputs.Joints.JointMode_1 <> 253 , eAxoMessageCategory#Warning);
                    TaskMessenger.ActivateOnCondition(ULINT#573, _infoTimer.output AND Inputs.Inputs.Joints.JointMode_2 <> 253 , eAxoMessageCategory#Warning);
                    TaskMessenger.ActivateOnCondition(ULINT#574, _infoTimer.output AND Inputs.Inputs.Joints.JointMode_3 <> 253 , eAxoMessageCategory#Warning);
                    TaskMessenger.ActivateOnCondition(ULINT#575, _infoTimer.output AND Inputs.Inputs.Joints.JointMode_4 <> 253 , eAxoMessageCategory#Warning);
                    TaskMessenger.ActivateOnCondition(ULINT#576, _infoTimer.output AND Inputs.Inputs.Joints.JointMode_5 <> 253 , eAxoMessageCategory#Warning);

                    IF _infoTimer.output THEN
                        IF NOT Inputs.Inputs.Robot.PW_IsPowerOn THEN
                            RobotStatus.Error.Id := UINT#569;
                        END_IF;
                        IF Inputs.Inputs.Safety.FT_IsFault  THEN
                            RobotStatus.Error.Id := UINT#570;
                        END_IF;
                        IF Inputs.Inputs.Joints.JointMode_0 <> 253  THEN
                            RobotStatus.Error.Id := UINT#571;
                        END_IF;
                        IF Inputs.Inputs.Joints.JointMode_1 <> 253  THEN
                            RobotStatus.Error.Id := UINT#572;
                        END_IF;
                        IF Inputs.Inputs.Joints.JointMode_2 <> 253  THEN
                            RobotStatus.Error.Id := UINT#573;
                        END_IF;
                        IF Inputs.Inputs.Joints.JointMode_3 <> 253  THEN
                            RobotStatus.Error.Id := UINT#574;
                        END_IF;
                        IF Inputs.Inputs.Joints.JointMode_4 <> 253  THEN
                            RobotStatus.Error.Id := UINT#575;
                        END_IF;
                        IF Inputs.Inputs.Joints.JointMode_5 <> 253  THEN
                            RobotStatus.Error.Id := UINT#576;
                        END_IF;
                    END_IF;

                    Outputs.MotorOn:=_blink.output;	

                    IF Inputs.Inputs.Safety.FT_IsFault THEN 
                        THIS.CallTimers(FALSE);
                        _progress := 360;
                    END_IF;

                    IF Inputs.Inputs.Robot.PW_IsPowerOn AND NOT Inputs.Inputs.Safety.FT_IsFault  AND
                        Inputs.Inputs.Joints.JointMode_0 = 253 AND
                        Inputs.Inputs.Joints.JointMode_1 = 253 AND
                        Inputs.Inputs.Joints.JointMode_2 = 253 AND
                        Inputs.Inputs.Joints.JointMode_3 = 253 AND
                        Inputs.Inputs.Joints.JointMode_4 = 253 AND
                        Inputs.Inputs.Joints.JointMode_5 = 253 THEN
                         Outputs.MotorOn:=FALSE;
                         THIS.CallTimers(FALSE);
                         _progress := 377;
                    END_IF;
                END_IF;		

                IF _progress = 377 THEN	
                    StartMotorsTask.DoneWhen(TRUE);
                    THIS.CallTimers(FALSE);
                    _progress := 0;
                END_IF;	              

                THIS.CallTimers(TRUE);
                StartMotorsTask.ThrowWhen(_errorTimer.output);
                RobotStatus.Action.Id := TO_UINT(_progress);
            END_IF;
            IF StartMotorsTask.IsFirstExecutionCycle() THEN
                MovementParameters := RobotStatus.CurrentMovementParameters;
            END_IF;
            IF StartMotorsTask.DoneReached() THEN
                RobotStatus.Action.Id :=  UINT#161;
                RobotStatus.Error.Id :=  UINT#0;
            ELSIF StartMotorsTask.ErrorOccured() THEN
                RobotStatus.Action.Id :=  UINT#860;
                RobotStatus.Error.Id  :=  UINT#860;
            ELSIF StartMotorsTask.AbortTriggered() THEN
                RobotStatus.Action.Id :=  UINT#861;
                RobotStatus.Error.Id  :=  UINT#861;
            END_IF;    
            Messenger.ActivateOnCondition(ULINT#860,StartMotorsTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#861,StartMotorsTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#162,StartMotorsTask.RestoreTriggered() , eAxoMessageCategory#Error);
            IF StartMotorsTask.RestoreTriggered() AND _progress >= 360 AND _progress <= 379 THEN
                RobotStatus.Action.Id :=  UINT#162;
                _progress := 0;
            END_IF;  

            //*******************************************
               
            //***********StartMovementsTask**************
            StartMovementsTask.IsDisabled := _stopTasksAreActive OR StartMotorsProgramAndMovementsTask.IsBusy();
            IF StartMovementsTask.StartTriggered() THEN
                RobotStatus.Action.Id :=  UINT#180;
            END_IF;
            Messenger.ActivateOnCondition(ULINT#180,StartMovementsTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#181,StartMovementsTask.IsDone(), eAxoMessageCategory#Info);
            IF StartMovementsTask.Execute() THEN
                IF _progress = 0 THEN
                    RobotStatus.Error.Id :=  UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 380;
                END_IF;
                
                IF _progress = 380 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#580, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        RobotStatus.Error.Id := UINT#580;
                    END_IF;

                    IF Inputs.Inputs.Robot.PR_IsProgramRunning THEN
                        THIS.CallTimers(FALSE);
                        _progress := 381;
                    END_IF;
                END_IF;
                
                IF _progress = 381 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#581, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        RobotStatus.Error.Id := UINT#581;
                    END_IF;

                    IF Inputs.Inputs.Robot.PW_IsPowerOn THEN
                        THIS.CallTimers(FALSE);
                        _progress := 382;
                    END_IF;
                END_IF;
                
                IF _progress = 382 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#582, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        RobotStatus.Error.Id := UINT#582;
                    END_IF;

                    IF NOT Inputs.Inputs.Safety.FT_IsFault THEN
                        THIS.CallTimers(FALSE);
                        _progress := 383;
                    END_IF;
                END_IF;
                
                IF _progress = 383 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#583, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        RobotStatus.Error.Id := UINT#583;
                    END_IF;

                    Outputs.GlobalSpeed     := TO_DINT(RobotStatus.CurrentMovementParameters.GlobalSpeed);
                    Outputs.ToolNo          := TO_DINT(RobotStatus.CurrentMovementParameters.ToolNo);
                    Outputs.WorkobjectNo    := TO_DINT(RobotStatus.CurrentMovementParameters.WorkobjectNo);
                    Outputs.PointNo         := TO_DINT(RobotStatus.CurrentMovementParameters.PointNo);
                    Outputs.UserSpecSpeed1  := RobotStatus.CurrentMovementParameters.UserSpecSpeed1;
                    Outputs.UserSpecSpeed2  := RobotStatus.CurrentMovementParameters.UserSpecSpeed2;
                    Outputs.Coordinates     := RobotStatus.CurrentMovementParameters.Coordinates; 		
                
                    Outputs.ActionNo := DINT#254;

                    IF Outputs.ActionNo = Inputs.ActionNo THEN
                        THIS.CallTimers(FALSE);
                        _progress := 384;
                    END_IF;
                END_IF;
                
                IF _progress = 384 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#584, _infoTimer.output AND Inputs.GlobalSpeed <> TO_DINT(RobotStatus.CurrentMovementParameters.GlobalSpeed), eAxoMessageCategory#Warning);
                    TaskMessenger.ActivateOnCondition(ULINT#585, _infoTimer.output AND Inputs.ToolNo <> TO_DINT(RobotStatus.CurrentMovementParameters.ToolNo), eAxoMessageCategory#Warning);
                    TaskMessenger.ActivateOnCondition(ULINT#586, _infoTimer.output AND Inputs.WorkobjectNo <> TO_DINT(RobotStatus.CurrentMovementParameters.WorkobjectNo) , eAxoMessageCategory#Warning);
                    TaskMessenger.ActivateOnCondition(ULINT#587, _infoTimer.output AND Inputs.PointNo <> TO_DINT(RobotStatus.CurrentMovementParameters.PointNo) , eAxoMessageCategory#Warning);
                    TaskMessenger.ActivateOnCondition(ULINT#588, _infoTimer.output AND Inputs.UserSpecSpeed1 <> RobotStatus.CurrentMovementParameters.UserSpecSpeed1 , eAxoMessageCategory#Warning);
                    TaskMessenger.ActivateOnCondition(ULINT#589, _infoTimer.output AND Inputs.UserSpecSpeed2 <> RobotStatus.CurrentMovementParameters.UserSpecSpeed2, eAxoMessageCategory#Warning);

                    IF _infoTimer.output THEN
                        IF Inputs.GlobalSpeed <> TO_DINT(RobotStatus.CurrentMovementParameters.GlobalSpeed) THEN
                            RobotStatus.Error.Id := UINT#584;//<#Waiting for Inputs.GlobalSpeed to be equal to MovementParameters.GlobalSpeed!
                        END_IF;
                        IF Inputs.ToolNo <> TO_DINT(RobotStatus.CurrentMovementParameters.ToolNo) THEN
                            RobotStatus.Error.Id := UINT#585;//<#Waiting for Inputs.ToolNo to be equal to MovementParameters.ToolNo!
                        END_IF;
                        IF Inputs.WorkobjectNo <> TO_DINT(RobotStatus.CurrentMovementParameters.WorkobjectNo) THEN
                            RobotStatus.Error.Id := UINT#586;//<#Waiting for Inputs.WorkobjectNo to be equal to MovementParameters.WorkobjectNo!
                        END_IF;
                        IF Inputs.PointNo <> TO_DINT(RobotStatus.CurrentMovementParameters.PointNo) THEN
                            RobotStatus.Error.Id := UINT#587;//<#Waiting for Inputs.PointNo to be equal to MovementParameters.PointNo!
                        END_IF;
                        IF Inputs.UserSpecSpeed1 <> RobotStatus.CurrentMovementParameters.UserSpecSpeed1 THEN
                            RobotStatus.Error.Id := UINT#588;//<#Waiting for Inputs.UserSpecSpeed1 to be equal to MovementParameters.UserSpecSpeed1!
                        END_IF;
                        IF Inputs.UserSpecSpeed2 <> RobotStatus.CurrentMovementParameters.UserSpecSpeed2 THEN
                            RobotStatus.Error.Id := UINT#589;//<#Waiting for Inputs.UserSpecSpeed2 to be equal to MovementParameters.UserSpecSpeed2!
                        END_IF;
                    END_IF;

                    IF 	Inputs.GlobalSpeed      = TO_DINT(RobotStatus.CurrentMovementParameters.GlobalSpeed) AND
                        Inputs.ToolNo           = TO_DINT(RobotStatus.CurrentMovementParameters.ToolNo) AND
                        Inputs.WorkobjectNo     = TO_DINT(RobotStatus.CurrentMovementParameters.WorkobjectNo) AND
                        Inputs.PointNo          = TO_DINT(RobotStatus.CurrentMovementParameters.PointNo) AND
                        Inputs.UserSpecSpeed1   = RobotStatus.CurrentMovementParameters.UserSpecSpeed1 AND
                        Inputs.UserSpecSpeed2   = RobotStatus.CurrentMovementParameters.UserSpecSpeed2 AND
                        AXOpen.Components.Robotics.CoordinatesAreNearlyEqual(Inputs.Coordinates,RobotStatus.CurrentMovementParameters.Coordinates,REAL#0.01,REAL#0.01,REAL#0.01,REAL#0.01,REAL#0.01,REAL#0.01) THEN
                        THIS.CallTimers(FALSE);
                        _progress:=390;
                    END_IF;
                END_IF;		

                IF _progress = 390 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#590, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        RobotStatus.Error.Id := UINT#590;
                    END_IF;

                    Outputs.ActionNo := DINT#255;

                    IF Outputs.ActionNo = Inputs.ActionNo THEN
                        THIS.CallTimers(FALSE);
                        _progress:=391;
                    END_IF;
                END_IF;	
                
                IF _progress = 391 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#591, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        RobotStatus.Error.Id := UINT#591;
                    END_IF;

                    Outputs.ActionNo := TO_DINT(RobotStatus.CurrentMovementParameters.ActionNo);

                    IF Outputs.ActionNo = Inputs.ActionNo THEN
                        THIS.CallTimers(FALSE);
                        _progress:=392;
                    END_IF;
                END_IF;	

                IF _progress = 392 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#692, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        RobotStatus.Error.Id := UINT#692;
                    END_IF;

                    Outputs.ActionNo := DINT#255;
	
                    IF Outputs.ActionNo = Inputs.ActionNo THEN
                        _progress := 0;
                        StartMovementsTask.DoneWhen(TRUE);
                    END_IF;
                END_IF;	
                
	            THIS.CallTimers(TRUE);
                
                StartMovementsTask.ThrowWhen(_errorTimer.output);

                RobotStatus.Action.Id := TO_UINT(_progress);
            END_IF;
            IF StartMovementsTask.DoneReached() THEN
                RobotStatus.Action.Id :=  UINT#181;
                RobotStatus.Error.Id :=  UINT#0;
            ELSIF StartMovementsTask.ErrorOccured() THEN
                RobotStatus.Action.Id :=  UINT#880;
                RobotStatus.Error.Id  :=  UINT#880;
            ELSIF StartMovementsTask.AbortTriggered()THEN
                RobotStatus.Action.Id :=  UINT#881;
                RobotStatus.Error.Id  :=  UINT#881;
            END_IF;     
            Messenger.ActivateOnCondition(ULINT#880,StartMovementsTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#881,StartMovementsTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#182,StartMovementsTask.RestoreTriggered() , eAxoMessageCategory#Error);
            IF StartMovementsTask.RestoreTriggered() AND _progress >= 380 AND _progress <= 399  THEN
                RobotStatus.Action.Id :=  UINT#182;
                _progress := 0;
            END_IF;

            //*******************************************

            //***********StartProgramTask*******
            StartProgramTask.IsDisabled := _stopTasksAreActive;
            IF StartProgramTask.StartTriggered() THEN
                RobotStatus.Action.Id :=  UINT#200;
            END_IF;
            Messenger.ActivateOnCondition(ULINT#200,StartProgramTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#201,StartProgramTask.IsDone(), eAxoMessageCategory#Info);
             IF StartProgramTask.Execute() THEN
                _blink.Blink(Context := _context, inOnTime:=T#500MS,inOffTime:=T#500MS);

                IF _progress = 0 THEN
                    RobotStatus.Error.Id :=  UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 400;
                END_IF;
              
                IF _progress = 400 THEN  
                    TaskMessenger.ActivateOnCondition(ULINT#600, _infoTimer.output AND NOT Inputs.Inputs.Safety.NO_IsNormalMode, eAxoMessageCategory#Warning);
                    TaskMessenger.ActivateOnCondition(ULINT#601, _infoTimer.output AND NOT Inputs.Inputs.Safety.RD_IsReducedMode, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        IF NOT Inputs.Inputs.Safety.NO_IsNormalMode THEN
                            RobotStatus.Error.Id := UINT#600;
                        END_IF;
                        IF NOT Inputs.Inputs.Safety.RD_IsReducedMode THEN
                            RobotStatus.Error.Id := UINT#601;
                        END_IF;      
                    END_IF;

                    IF Inputs.Inputs.Safety.NO_IsNormalMode OR Inputs.Inputs.Safety.RD_IsReducedMode THEN
                        THIS.CallTimers(FALSE);
                        _progress:=402;                    
                    END_IF;
                END_IF;

                IF _progress = 402 THEN	
                    TaskMessenger.ActivateOnCondition(ULINT#602, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        RobotStatus.Error.Id := UINT#602;
                    END_IF;
                    
                    Outputs.MotorOn:=_blink.output;	

                    IF Inputs.Inputs.Robot.PW_IsPowerOn THEN
                         Outputs.MotorOn:=FALSE;
                         THIS.CallTimers(FALSE);
                         _progress := 403;
                    END_IF;
                END_IF;		

                IF _progress = 403 THEN	
                    StartMotorsAndProgramTask.DoneWhen(TRUE);
                    THIS.CallTimers(FALSE);
                    _progress := 0;
                END_IF;	              

                THIS.CallTimers(TRUE);
                StartMotorsAndProgramTask.ThrowWhen(_errorTimer.output);
                RobotStatus.Action.Id := TO_UINT(_progress);
            END_IF;
            IF StopMovementsAndProgramTask.DoneReached() THEN
                RobotStatus.Action.Id :=  UINT#201;
                RobotStatus.Error.Id :=  UINT#0;
            ELSIF StopMovementsAndProgramTask.ErrorOccured() THEN
                RobotStatus.Action.Id :=  UINT#900;
                RobotStatus.Error.Id  :=  UINT#900;
            ELSIF StopMovementsAndProgramTask.AbortTriggered()THEN
                RobotStatus.Action.Id :=  UINT#901;
                RobotStatus.Error.Id  :=  UINT#901;
            END_IF;     
            Messenger.ActivateOnCondition(ULINT#900,StopMovementsAndProgramTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#901,StopMovementsAndProgramTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#202,StopMovementsAndProgramTask.RestoreTriggered() , eAxoMessageCategory#Error);
            IF StopMovementsAndProgramTask.RestoreTriggered() AND _progress >= 400 AND _progress <= 409  THEN
                RobotStatus.Action.Id :=  UINT#202;
                _progress := 0;
            END_IF;
            //*******************************************

            //***********StopMovementsAndProgramTask*****
            StopMovementsAndProgramTask.IsDisabled := FALSE;
            IF StopMovementsAndProgramTask.StartTriggered() THEN
                RobotStatus.Action.Id :=  UINT#210;
            END_IF;
            Messenger.ActivateOnCondition(ULINT#210,StopMovementsAndProgramTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#211,StopMovementsAndProgramTask.IsDone(), eAxoMessageCategory#Info);
            IF StopMovementsAndProgramTask.Execute() THEN
                IF _progress = 0 THEN
                    RobotStatus.Error.Id :=  UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 410;
                END_IF;
                
                IF _progress = 410 THEN  
                    TaskMessenger.ActivateOnCondition(ULINT#610, _infoTimer.output AND NOT Inputs.Inputs.Safety.NO_IsNormalMode, eAxoMessageCategory#Warning);
                    TaskMessenger.ActivateOnCondition(ULINT#611, _infoTimer.output AND NOT Inputs.Inputs.Safety.RD_IsReducedMode, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        IF NOT Inputs.Inputs.Safety.NO_IsNormalMode THEN
                            RobotStatus.Error.Id := UINT#610;
                        END_IF;
                        IF NOT Inputs.Inputs.Safety.RD_IsReducedMode THEN
                            RobotStatus.Error.Id := UINT#611;
                        END_IF;      
                    END_IF;

                    IF Inputs.Inputs.Safety.NO_IsNormalMode OR Inputs.Inputs.Safety.RD_IsReducedMode THEN
                        THIS.CallTimers(FALSE);
                        _progress:=412;                    
                    END_IF;
                END_IF;

                IF _progress = 412 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#612, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        RobotStatus.Error.Id := UINT#612;
                    END_IF;

                    Outputs.Stop := TRUE;

                    IF NOT Inputs.Inputs.Robot.PR_IsProgramRunning THEN
                        Outputs.Stop := FALSE ;
                        THIS.CallTimers(FALSE);
                        _progress:=413;                    
                    END_IF;                    
                END_IF;                    

                IF _progress = 413 THEN
                    Outputs.Pause := FALSE ;
                    StopMovementsAndProgramTask.DoneWhen(TRUE);
                    _progress := 0;
                END_IF;		

                THIS.CallTimers(TRUE);
                
                StopMovementsAndProgramTask.ThrowWhen(_errorTimer.output);

                RobotStatus.Action.Id := TO_UINT(_progress);
            END_IF;
            IF StopMovementsAndProgramTask.DoneReached() THEN
                RobotStatus.Action.Id :=  UINT#211;
                RobotStatus.Error.Id :=  UINT#0;
            ELSIF StopMovementsAndProgramTask.ErrorOccured() THEN
                RobotStatus.Action.Id :=  UINT#910;
                RobotStatus.Error.Id  :=  UINT#910;
            ELSIF StopMovementsAndProgramTask.AbortTriggered()THEN
                RobotStatus.Action.Id :=  UINT#911;
                RobotStatus.Error.Id  :=  UINT#911;
            END_IF;     
            Messenger.ActivateOnCondition(ULINT#910,StopMovementsAndProgramTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#911,StopMovementsAndProgramTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#212,StopMovementsAndProgramTask.RestoreTriggered() , eAxoMessageCategory#Error);
            IF StopMovementsAndProgramTask.RestoreTriggered() AND _progress >= 410 AND _progress <= 419  THEN
                RobotStatus.Action.Id :=  UINT#212;
                _progress := 0;
            END_IF;
            //*******************************************
            
            //***********StopMovementsTask***************
            StopMovementsTask.IsDisabled := FALSE;
            IF StopMovementsAndProgramTask.StartTriggered() THEN
                RobotStatus.Action.Id :=  UINT#220;
            END_IF;
            Messenger.ActivateOnCondition(ULINT#220,StopMovementsAndProgramTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#221,StopMovementsAndProgramTask.IsDone(), eAxoMessageCategory#Info);
            IF StopMovementsTask.Execute() THEN
                IF _progress = 0 THEN
                    RobotStatus.Error.Id :=  UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 420;
                END_IF;
               
                IF _progress = 420 THEN  
                    TaskMessenger.ActivateOnCondition(ULINT#620, _infoTimer.output AND NOT Inputs.Inputs.Safety.NO_IsNormalMode, eAxoMessageCategory#Warning);
                    TaskMessenger.ActivateOnCondition(ULINT#621, _infoTimer.output AND NOT Inputs.Inputs.Safety.RD_IsReducedMode, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        IF NOT Inputs.Inputs.Safety.NO_IsNormalMode THEN
                            RobotStatus.Error.Id := UINT#620;
                        END_IF;
                        IF NOT Inputs.Inputs.Safety.RD_IsReducedMode THEN
                            RobotStatus.Error.Id := UINT#621;
                        END_IF;      
                    END_IF;

                    IF Inputs.Inputs.Safety.NO_IsNormalMode OR Inputs.Inputs.Safety.RD_IsReducedMode THEN
                        THIS.CallTimers(FALSE);
                        _progress:=422;                    
                    END_IF;
                END_IF;
                IF _progress = 422 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#622, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        RobotStatus.Error.Id := UINT#622;
                    END_IF;

                    Outputs.Pause := TRUE;

                    IF NOT Inputs.Inputs.Robot.PR_IsProgramRunning THEN
                        Outputs.Pause := FALSE ;
                        THIS.CallTimers(FALSE);
                        _progress:=423;                    
                    END_IF;                    
                END_IF;                    

                IF _progress = 423 THEN
                    Outputs.Pause := FALSE ;
                    StopMovementsTask.DoneWhen(TRUE);
                    _progress := 0;
                END_IF;		
                THIS.CallTimers(TRUE);
                
                StopMovementsTask.ThrowWhen(_errorTimer.output);

                RobotStatus.Action.Id := TO_UINT(_progress);
            END_IF;
            IF StopMovementsTask.DoneReached() THEN
                RobotStatus.Action.Id :=  UINT#221;
                RobotStatus.Error.Id :=  UINT#0;
            ELSIF StopMovementsTask.ErrorOccured() THEN
                RobotStatus.Action.Id :=  UINT#920;
                RobotStatus.Error.Id  :=  UINT#920;
            ELSIF StopMovementsTask.AbortTriggered()THEN
                RobotStatus.Action.Id :=  UINT#921;
                RobotStatus.Error.Id  :=  UINT#921;
            END_IF;     
            Messenger.ActivateOnCondition(ULINT#920,StopMovementsTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#921,StopMovementsTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#222,StopMovementsTask.RestoreTriggered() , eAxoMessageCategory#Error);
            IF StopMovementsTask.RestoreTriggered() AND _progress >= 420 AND _progress <= 429  THEN
                RobotStatus.Action.Id :=  UINT#222;
                _progress := 0;
            END_IF;
            //*******************************************

            //***********StopProgramTask*****************
            StopProgramTask.IsDisabled := FALSE;
            IF StopProgramTask.StartTriggered() THEN
                RobotStatus.Action.Id :=  UINT#230;
            END_IF;
            Messenger.ActivateOnCondition(ULINT#230,StopProgramTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#231,StopProgramTask.IsDone(), eAxoMessageCategory#Info);
            IF StopProgramTask.Execute() THEN
                IF _progress = 0 THEN
                    RobotStatus.Error.Id :=  UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 430;
                END_IF;

                IF _progress = 430 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#630, _infoTimer.output AND NOT Inputs.Inputs.Safety.NO_IsNormalMode, eAxoMessageCategory#Warning);
                    TaskMessenger.ActivateOnCondition(ULINT#631, _infoTimer.output AND NOT Inputs.Inputs.Safety.RD_IsReducedMode, eAxoMessageCategory#Warning);

                    IF _infoTimer.output THEN
                        IF NOT Inputs.Inputs.Safety.NO_IsNormalMode THEN
                            RobotStatus.Error.Id := UINT#630;
                        END_IF;
                        IF NOT Inputs.Inputs.Safety.RD_IsReducedMode THEN
                            RobotStatus.Error.Id := UINT#631;
                        END_IF;      
                    END_IF;

                    IF Inputs.Inputs.Safety.NO_IsNormalMode OR Inputs.Inputs.Safety.RD_IsReducedMode THEN
                        THIS.CallTimers(FALSE);
                        _progress:=432;                    
                    END_IF;
                END_IF;

                IF _progress = 432 THEN
                    TaskMessenger.ActivateOnCondition(ULINT#632, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        RobotStatus.Error.Id := UINT#632;
                    END_IF;

                    Outputs.Stop := TRUE;

                    IF NOT Inputs.Inputs.Robot.PR_IsProgramRunning THEN
                        Outputs.Stop := FALSE ;
                        THIS.CallTimers(FALSE);
                        _progress:=433;                    
                    END_IF;                    
                END_IF;                    

                IF _progress = 433 THEN
                    Outputs.Pause := FALSE ;
                    StopProgramTask.DoneWhen(TRUE);
                    _progress := 0;
                END_IF;		

                THIS.CallTimers(TRUE);
                
                StopProgramTask.ThrowWhen(_errorTimer.output);

                RobotStatus.Action.Id := TO_UINT(_progress);
            END_IF;
            IF StopProgramTask.DoneReached() THEN
                RobotStatus.Action.Id :=  UINT#231;
                RobotStatus.Error.Id :=  UINT#0;
            ELSIF StopProgramTask.ErrorOccured() THEN
                RobotStatus.Action.Id :=  UINT#930;
                RobotStatus.Error.Id  :=  UINT#930;
            ELSIF StopProgramTask.AbortTriggered()THEN
                RobotStatus.Action.Id :=  UINT#931;
                RobotStatus.Error.Id  :=  UINT#931;
            END_IF;     
            Messenger.ActivateOnCondition(ULINT#930,StopProgramTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#931,StopProgramTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#232,StopProgramTask.RestoreTriggered() , eAxoMessageCategory#Error);
            IF StopProgramTask.RestoreTriggered() AND _progress >= 430 AND _progress <= 439  THEN
                RobotStatus.Action.Id :=  UINT#232;
                _progress := 0;
            END_IF;

            //*******************************************

            //*************POWER ON********************
            PowerOnTask.IsDisabled := NOT(Inputs.RobotMode=eAxoUrRoboticsRobotMode#DISCONNECTED AND Config.RemotePowerOnEnabled);
            IF PowerOnTask.Execute() THEN
                refPowerOnPulse^ :=TRUE;
                RobotStatus.Action.Id :=  UINT#420;//('<#POWER ON PULSE WAS SEND TO CONTROLER#>');
                PowerOnTask.DoneWhen(PowerOnTask.Duration > Config.RemotePowerOnPulse);
            END_IF;

            IF refPowerOnPulse^ AND PowerOnTask.IsDone()  OR NOT Config.RemotePowerOnEnabled THEN
                refPowerOnPulse^ :=FALSE;
            END_IF;

            //****************************************

            _someTaskIsActive := StartAtMainTask.IsBusy()
                                OR StartMotorsAndProgramTask.IsBusy()
                                OR StartMovementsTask.IsBusy()
                                OR StartMovementsTask.IsBusy()
                                OR StopMovementsTask.IsBusy()
                                OR StopMovementsAndProgramTask.IsBusy()
                                OR StopProgramTask.IsBusy();
            
            Messenger.ActivateOnCondition(ULINT#719,_someTaskIsActive AND Inputs.Inputs.Safety.ES_IsEmergencyStopped, eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#720,_someTaskIsActive AND Inputs.Inputs.Safety.ST_IsStoppedDueSafety, eAxoMessageCategory#Error);

            IF _someTaskIsActive THEN
                IF(Inputs.Inputs.Safety.ES_IsEmergencyStopped) THEN
                    RobotStatus.Error.Id := UINT#719;
                END_IF;
                IF(Inputs.Inputs.Safety.ST_IsStoppedDueSafety) THEN
                    RobotStatus.Error.Id := UINT#720;
                END_IF;
            END_IF;
            //***********UPDATE**OUTPUTS*****************
            //SYSTEM OUTPUTS
            Outputs.Outputs.Reg1.Bit_0 := Outputs.Start;
            Outputs.outputs.Reg1.Bit_1 := Outputs.Stop;
            Outputs.outputs.Reg1.Bit_2 := Outputs.Pause;
            Outputs.outputs.Reg1.Bit_3 := Outputs.MotorOn;
            //Outputs.outputs.Reg1.Bit_4 := Outputs.RunAction;

            //Tool signals
            Outputs.Outputs.Reg1.Bit_8 := Outputs.Tool_1_Retract;
            Outputs.outputs.Reg1.Bit_9 := Outputs.Tool_1_Extend;
            Outputs.outputs.Reg1.Bit_10 := Outputs.Tool_2_Retract;
            Outputs.outputs.Reg1.Bit_11 := Outputs.Tool_2_Extend;
            Outputs.outputs.Reg1.Bit_12 := Outputs.Tool_3_Retract;
            Outputs.outputs.Reg1.Bit_13 := Outputs.Tool_3_Extend;
            Outputs.outputs.Reg1.Bit_14 := Outputs.Tool_4_Retract;
            Outputs.outputs.Reg1.Bit_15 := Outputs.Tool_4_Extend;


            //zone
            Outputs.Outputs.Reg1.Int_0 := Outputs.Zone;
            //position
            Outputs.Outputs.Reg1.Int_1 := Outputs.InPosition;

            //Movement parameters
            Outputs.Outputs.Reg1.Int_2 := Outputs.ActionNo;
            Outputs.Outputs.Reg1.Int_3 := Outputs.GlobalSpeed;
            Outputs.Outputs.Reg1.Int_4 := Outputs.ToolNo;
            Outputs.Outputs.Reg1.Int_5 := Outputs.WorkobjectNo;
            Outputs.Outputs.Reg1.Int_6 := Outputs.PointNo;
            //master mode  such as manual/auto ....
            Outputs.Outputs.Reg1.Int_7 := TO_DINT(Outputs.MasterMode);

            Outputs.Outputs.Reg1.Float_0 := Outputs.UserSpecSpeed1;
            Outputs.Outputs.Reg1.Float_1 := Outputs.UserSpecSpeed2;

            ////Coordinates
            Outputs.Outputs.Reg1.Float_2 := Outputs.Coordinates.X ;
            Outputs.Outputs.Reg1.Float_3 := Outputs.Coordinates.Y;
            Outputs.Outputs.Reg1.Float_4 := Outputs.Coordinates.Z ;
            Outputs.Outputs.Reg1.Float_5 := (Outputs.Coordinates.Rx);
            Outputs.Outputs.Reg1.Float_6 := (Outputs.Coordinates.Ry);
            Outputs.Outputs.Reg1.Float_7 := (Outputs.Coordinates.Rz);

            //st_URO_CB3_O2TSpeedData => 8_O2T Robot IO
            _data24[0].%X0 := Outputs.Outputs.Speed.SSM_SpeedSliderFractionMask;

            _dword := TO_DWORD(Outputs.Outputs.Speed.SpeedSliderFraction * REAL#0.01);
            _data24[4] := _dword.%B3;
            _data24[5] := _dword.%B2;
            _data24[6] := _dword.%B1;
            _data24[7] := _dword.%B0;

            //st_URO_CB3_O2TIoData => 8_O2T Robot IO
            _data24[8]  := TO_BYTE(Outputs.Outputs.IO.StandardDigitalOutputMask);
            _data24[9]  := TO_BYTE(Outputs.Outputs.IO.ConfigurableDigitalOutputMask);
            _data24[10] := TO_BYTE(Outputs.Outputs.IO.StandardDigitalOutputs);
            _data24[11] := TO_BYTE(Outputs.Outputs.IO.ConfigurableDdigitalOutputs);
            _data24[12] := TO_BYTE(Outputs.Outputs.IO.AOM_AnalogOutputMask);
            _data24[13] := TO_BYTE(Outputs.Outputs.IO.AOT_AnalogOutputTypes);
            _data24[14] := TO_BYTE(Outputs.Outputs.IO.TDOM_ToolDigitalOutputMask);
            _data24[15] := TO_BYTE(Outputs.Outputs.IO.TDO_ToolDigitalOutput);

            _dword := TO_DWORD(Outputs.Outputs.IO.StandardAnalogOutput_0);
            _data24[16] := _dword.%B3;
            _data24[17] := _dword.%B2;
            _data24[18] := _dword.%B1;
            _data24[19] := _dword.%B0;

            _dword := TO_DWORD(Outputs.Outputs.IO.StandardAnalogOutput_1);
            _data24[20] := _dword.%B3;
            _data24[21] := _dword.%B2;
            _data24[22] := _dword.%B1;
            _data24[23] := _dword.%B0;

            returnValue := Siemens.Simatic.S71500.DistributedIO.WriteData(_hwIdAxoUrRobotics_O2T_Robot_IO,_data24);
            Messenger.ActivateOnCondition(ULINT#721,returnValue > WORD#0, eAxoMessageCategory#ProgrammingError);
            IF returnValue > WORD#0 THEN
                RobotStatus.Error.Id := UINT#721;
                RETURN;
            END_IF;

            //st_URO_CB3_O2TRegData => 9_O2T General Purpose Registers 1
            _data100[0].%X0 :=  Outputs.Outputs.Reg1.Bit_0;
            _data100[0].%X1 :=  Outputs.Outputs.Reg1.Bit_1;
            _data100[0].%X2 :=  Outputs.Outputs.Reg1.Bit_2;
            _data100[0].%X3 :=  Outputs.Outputs.Reg1.Bit_3;
            _data100[0].%X4 :=  Outputs.Outputs.Reg1.Bit_4;
            _data100[0].%X5 :=  Outputs.Outputs.Reg1.Bit_5;
            _data100[0].%X6 :=  Outputs.Outputs.Reg1.Bit_6;
            _data100[0].%X7 :=  Outputs.Outputs.Reg1.Bit_7;

            _data100[1].%X0 :=  Outputs.Outputs.Reg1.Bit_8;
            _data100[1].%X1 :=  Outputs.Outputs.Reg1.Bit_9;
            _data100[1].%X2 :=  Outputs.Outputs.Reg1.Bit_10;
            _data100[1].%X3 :=  Outputs.Outputs.Reg1.Bit_11;
            _data100[1].%X4 :=  Outputs.Outputs.Reg1.Bit_12;
            _data100[1].%X5 :=  Outputs.Outputs.Reg1.Bit_13;
            _data100[1].%X6 :=  Outputs.Outputs.Reg1.Bit_14;
            _data100[1].%X7 :=  Outputs.Outputs.Reg1.Bit_15;

            _data100[2].%X0 :=  Outputs.Outputs.Reg1.Bit_16;
            _data100[2].%X1 :=  Outputs.Outputs.Reg1.Bit_17;
            _data100[2].%X2 :=  Outputs.Outputs.Reg1.Bit_18;
            _data100[2].%X3 :=  Outputs.Outputs.Reg1.Bit_19;
            _data100[2].%X4 :=  Outputs.Outputs.Reg1.Bit_20;
            _data100[2].%X5 :=  Outputs.Outputs.Reg1.Bit_21;
            _data100[2].%X6 :=  Outputs.Outputs.Reg1.Bit_22;
            _data100[2].%X7 :=  Outputs.Outputs.Reg1.Bit_23;

            _data100[3].%X0 :=  Outputs.Outputs.Reg1.Bit_24;
            _data100[3].%X1 :=  Outputs.Outputs.Reg1.Bit_25;
            _data100[3].%X2 :=  Outputs.Outputs.Reg1.Bit_26;
            _data100[3].%X3 :=  Outputs.Outputs.Reg1.Bit_27;
            _data100[3].%X4 :=  Outputs.Outputs.Reg1.Bit_28;
            _data100[3].%X5 :=  Outputs.Outputs.Reg1.Bit_29;
            _data100[3].%X6 :=  Outputs.Outputs.Reg1.Bit_30;
            _data100[3].%X7 :=  Outputs.Outputs.Reg1.Bit_31;

            _dword          := TO_DWORD( Outputs.Outputs.Reg1.Int_0);
            _data100[4]     := _dword.%B3;
            _data100[5]     := _dword.%B2;
            _data100[6]     := _dword.%B1;
            _data100[7]     := _dword.%B0;

            _dword          := TO_DWORD( Outputs.Outputs.Reg1.Int_1);
            _data100[8]     := _dword.%B3;
            _data100[9]     := _dword.%B2;
            _data100[10]    := _dword.%B1;
            _data100[11]    := _dword.%B0;

            _dword          := TO_DWORD( Outputs.Outputs.Reg1.Int_2);
            _data100[12]    := _dword.%B3;
            _data100[13]    := _dword.%B2;
            _data100[14]    := _dword.%B1;
            _data100[15]    := _dword.%B0;

            _dword          := TO_DWORD( Outputs.Outputs.Reg1.Int_3);
            _data100[16]    := _dword.%B3;
            _data100[17]    := _dword.%B2;
            _data100[18]    := _dword.%B1;
            _data100[19]    := _dword.%B0;

            _dword          := TO_DWORD( Outputs.Outputs.Reg1.Int_4);
            _data100[20]    := _dword.%B3;
            _data100[21]    := _dword.%B2;
            _data100[22]    := _dword.%B1;
            _data100[23]    := _dword.%B0;

            _dword          := TO_DWORD( Outputs.Outputs.Reg1.Int_5);
            _data100[24]    := _dword.%B3;
            _data100[25]    := _dword.%B2;
            _data100[26]    := _dword.%B1;
            _data100[27]    := _dword.%B0;

            _dword          := TO_DWORD( Outputs.Outputs.Reg1.Int_6);
            _data100[28]    := _dword.%B3;
            _data100[29]    := _dword.%B2;
            _data100[30]    := _dword.%B1;
            _data100[31]    := _dword.%B0;

            _dword          := TO_DWORD( Outputs.Outputs.Reg1.Int_7);
            _data100[32]    := _dword.%B3;
            _data100[33]    := _dword.%B2;
            _data100[34]    := _dword.%B1;
            _data100[35]    := _dword.%B0;

            _dword          := TO_DWORD( Outputs.Outputs.Reg1.Int_8);
            _data100[36]    := _dword.%B3;
            _data100[37]    := _dword.%B2;
            _data100[38]    := _dword.%B1;
            _data100[39]    := _dword.%B0;

            _dword          := TO_DWORD( Outputs.Outputs.Reg1.Int_9);
            _data100[40]    := _dword.%B3;
            _data100[41]    := _dword.%B2;
            _data100[42]    := _dword.%B1;
            _data100[43]    := _dword.%B0;

            _dword          := TO_DWORD( Outputs.Outputs.Reg1.Int_10);
            _data100[44]    := _dword.%B3;
            _data100[45]    := _dword.%B2;
            _data100[46]    := _dword.%B1;
            _data100[47]    := _dword.%B0;

            _dword          := TO_DWORD( Outputs.Outputs.Reg1.Int_11);
            _data100[48]    := _dword.%B3;
            _data100[49]    := _dword.%B2;
            _data100[50]    := _dword.%B1;
            _data100[51]    := _dword.%B0;

            _dword          := TO_DWORD( Outputs.Outputs.Reg1.Float_0);
            _data100[52]    := _dword.%B3;
            _data100[53]    := _dword.%B2;
            _data100[54]    := _dword.%B1;
            _data100[55]    := _dword.%B0;

            _dword          := TO_DWORD( Outputs.Outputs.Reg1.Float_1);
            _data100[56]    := _dword.%B3;
            _data100[58]    := _dword.%B2;
            _data100[58]    := _dword.%B1;
            _data100[59]    := _dword.%B0;

            _dword          := TO_DWORD( Outputs.Outputs.Reg1.Float_2);
            _data100[60]    := _dword.%B3;
            _data100[61]    := _dword.%B2;
            _data100[62]    := _dword.%B1;
            _data100[63]    := _dword.%B0;

            _dword          := TO_DWORD( Outputs.Outputs.Reg1.Float_3);
            _data100[64]    := _dword.%B3;
            _data100[65]    := _dword.%B2;
            _data100[66]    := _dword.%B1;
            _data100[67]    := _dword.%B0;

            _dword          := TO_DWORD( Outputs.Outputs.Reg1.Float_4);
            _data100[68]    := _dword.%B3;
            _data100[69]    := _dword.%B2;
            _data100[70]    := _dword.%B1;
            _data100[71]    := _dword.%B0;

            _dword          := TO_DWORD( Outputs.Outputs.Reg1.Float_5);
            _data100[72]    := _dword.%B3;
            _data100[73]    := _dword.%B2;
            _data100[74]    := _dword.%B1;
            _data100[75]    := _dword.%B0;

            _dword          := TO_DWORD( Outputs.Outputs.Reg1.Float_6);
            _data100[76]    := _dword.%B3;
            _data100[77]    := _dword.%B2;
            _data100[78]    := _dword.%B1;
            _data100[79]    := _dword.%B0;

            _dword          := TO_DWORD( Outputs.Outputs.Reg1.Float_7);
            _data100[80]    := _dword.%B3;
            _data100[81]    := _dword.%B2;
            _data100[82]    := _dword.%B1;
            _data100[83]    := _dword.%B0;

            _dword          := TO_DWORD( Outputs.Outputs.Reg1.Float_8);
            _data100[84]    := _dword.%B3;
            _data100[85]    := _dword.%B2;
            _data100[86]    := _dword.%B1;
            _data100[87]    := _dword.%B0;

            _dword          := TO_DWORD( Outputs.Outputs.Reg1.Float_9);
            _data100[88]    := _dword.%B3;
            _data100[89]    := _dword.%B2;
            _data100[90]    := _dword.%B1;
            _data100[91]    := _dword.%B0;

            _dword          := TO_DWORD( Outputs.Outputs.Reg1.Float_10);
            _data100[92]    := _dword.%B3;
            _data100[93]    := _dword.%B2;
            _data100[94]    := _dword.%B1;
            _data100[95]    := _dword.%B0;

            _dword          := TO_DWORD( Outputs.Outputs.Reg1.Float_11);
            _data100[96]    := _dword.%B3;
            _data100[97]    := _dword.%B2;
            _data100[98]    := _dword.%B1;
            _data100[99]    := _dword.%B0;

            returnValue := Siemens.Simatic.S71500.DistributedIO.WriteData(_hwIdAxoUrRobotics_O2T_General_Purpose_Registers_1,_data100);
            Messenger.ActivateOnCondition(ULINT#722,returnValue > WORD#0, eAxoMessageCategory#ProgrammingError);
            IF returnValue > WORD#0 THEN
                RobotStatus.Error.Id := UINT#722;
                RETURN;
            END_IF;

            //st_URO_CB3_O2TRegData => 10_O2T General Purpose Registers 2
            _data100[0].%X0 :=  Outputs.Outputs.Reg2.Bit_0;
            _data100[0].%X1 :=  Outputs.Outputs.Reg2.Bit_1;
            _data100[0].%X2 :=  Outputs.Outputs.Reg2.Bit_2;
            _data100[0].%X3 :=  Outputs.Outputs.Reg2.Bit_3;
            _data100[0].%X4 :=  Outputs.Outputs.Reg2.Bit_4;
            _data100[0].%X5 :=  Outputs.Outputs.Reg2.Bit_5;
            _data100[0].%X6 :=  Outputs.Outputs.Reg2.Bit_6;
            _data100[0].%X7 :=  Outputs.Outputs.Reg2.Bit_7;

            _data100[1].%X0 :=  Outputs.Outputs.Reg2.Bit_8;
            _data100[1].%X1 :=  Outputs.Outputs.Reg2.Bit_9;
            _data100[1].%X2 :=  Outputs.Outputs.Reg2.Bit_10;
            _data100[1].%X3 :=  Outputs.Outputs.Reg2.Bit_11;
            _data100[1].%X4 :=  Outputs.Outputs.Reg2.Bit_12;
            _data100[1].%X5 :=  Outputs.Outputs.Reg2.Bit_13;
            _data100[1].%X6 :=  Outputs.Outputs.Reg2.Bit_14;
            _data100[1].%X7 :=  Outputs.Outputs.Reg2.Bit_15;

            _data100[2].%X0 :=  Outputs.Outputs.Reg2.Bit_16;
            _data100[2].%X1 :=  Outputs.Outputs.Reg2.Bit_17;
            _data100[2].%X2 :=  Outputs.Outputs.Reg2.Bit_18;
            _data100[2].%X3 :=  Outputs.Outputs.Reg2.Bit_19;
            _data100[2].%X4 :=  Outputs.Outputs.Reg2.Bit_20;
            _data100[2].%X5 :=  Outputs.Outputs.Reg2.Bit_21;
            _data100[2].%X6 :=  Outputs.Outputs.Reg2.Bit_22;
            _data100[2].%X7 :=  Outputs.Outputs.Reg2.Bit_23;

            _data100[3].%X0 :=  Outputs.Outputs.Reg2.Bit_24;
            _data100[3].%X1 :=  Outputs.Outputs.Reg2.Bit_25;
            _data100[3].%X2 :=  Outputs.Outputs.Reg2.Bit_26;
            _data100[3].%X3 :=  Outputs.Outputs.Reg2.Bit_27;
            _data100[3].%X4 :=  Outputs.Outputs.Reg2.Bit_28;
            _data100[3].%X5 :=  Outputs.Outputs.Reg2.Bit_29;
            _data100[3].%X6 :=  Outputs.Outputs.Reg2.Bit_30;
            _data100[3].%X7 :=  Outputs.Outputs.Reg2.Bit_31;

            _dword          := TO_DWORD( Outputs.Outputs.Reg2.Int_0);
            _data100[4]     := _dword.%B3;
            _data100[5]     := _dword.%B2;
            _data100[6]     := _dword.%B1;
            _data100[7]     := _dword.%B0;

            _dword          := TO_DWORD( Outputs.Outputs.Reg2.Int_1);
            _data100[8]     := _dword.%B3;
            _data100[9]     := _dword.%B2;
            _data100[10]    := _dword.%B1;
            _data100[11]    := _dword.%B0;

            _dword          := TO_DWORD( Outputs.Outputs.Reg2.Int_2);
            _data100[12]    := _dword.%B3;
            _data100[13]    := _dword.%B2;
            _data100[14]    := _dword.%B1;
            _data100[15]    := _dword.%B0;

            _dword          := TO_DWORD( Outputs.Outputs.Reg2.Int_3);
            _data100[16]    := _dword.%B3;
            _data100[17]    := _dword.%B2;
            _data100[18]    := _dword.%B1;
            _data100[19]    := _dword.%B0;

            _dword          := TO_DWORD( Outputs.Outputs.Reg2.Int_4);
            _data100[20]    := _dword.%B3;
            _data100[21]    := _dword.%B2;
            _data100[22]    := _dword.%B1;
            _data100[23]    := _dword.%B0;

            _dword          := TO_DWORD( Outputs.Outputs.Reg2.Int_5);
            _data100[24]    := _dword.%B3;
            _data100[25]    := _dword.%B2;
            _data100[26]    := _dword.%B1;
            _data100[27]    := _dword.%B0;

            _dword          := TO_DWORD( Outputs.Outputs.Reg2.Int_6);
            _data100[28]    := _dword.%B3;
            _data100[29]    := _dword.%B2;
            _data100[30]    := _dword.%B1;
            _data100[31]    := _dword.%B0;

            _dword          := TO_DWORD( Outputs.Outputs.Reg2.Int_7);
            _data100[32]    := _dword.%B3;
            _data100[33]    := _dword.%B2;
            _data100[34]    := _dword.%B1;
            _data100[35]    := _dword.%B0;

            _dword          := TO_DWORD( Outputs.Outputs.Reg2.Int_8);
            _data100[36]    := _dword.%B3;
            _data100[37]    := _dword.%B2;
            _data100[38]    := _dword.%B1;
            _data100[39]    := _dword.%B0;

            _dword          := TO_DWORD( Outputs.Outputs.Reg2.Int_9);
            _data100[40]    := _dword.%B3;
            _data100[41]    := _dword.%B2;
            _data100[42]    := _dword.%B1;
            _data100[43]    := _dword.%B0;

            _dword          := TO_DWORD( Outputs.Outputs.Reg2.Int_10);
            _data100[44]    := _dword.%B3;
            _data100[45]    := _dword.%B2;
            _data100[46]    := _dword.%B1;
            _data100[47]    := _dword.%B0;

            _dword          := TO_DWORD( Outputs.Outputs.Reg2.Int_11);
            _data100[48]    := _dword.%B3;
            _data100[49]    := _dword.%B2;
            _data100[50]    := _dword.%B1;
            _data100[51]    := _dword.%B0;

            _dword          := TO_DWORD( Outputs.Outputs.Reg2.Float_0);
            _data100[52]    := _dword.%B3;
            _data100[53]    := _dword.%B2;
            _data100[54]    := _dword.%B1;
            _data100[55]    := _dword.%B0;

            _dword          := TO_DWORD( Outputs.Outputs.Reg2.Float_1);
            _data100[56]    := _dword.%B3;
            _data100[58]    := _dword.%B2;
            _data100[58]    := _dword.%B1;
            _data100[59]    := _dword.%B0;

            _dword          := TO_DWORD( Outputs.Outputs.Reg2.Float_2);
            _data100[60]    := _dword.%B3;
            _data100[61]    := _dword.%B2;
            _data100[62]    := _dword.%B1;
            _data100[63]    := _dword.%B0;

            _dword          := TO_DWORD( Outputs.Outputs.Reg2.Float_3);
            _data100[64]    := _dword.%B3;
            _data100[65]    := _dword.%B2;
            _data100[66]    := _dword.%B1;
            _data100[67]    := _dword.%B0;

            _dword          := TO_DWORD( Outputs.Outputs.Reg2.Float_4);
            _data100[68]    := _dword.%B3;
            _data100[69]    := _dword.%B2;
            _data100[70]    := _dword.%B1;
            _data100[71]    := _dword.%B0;

            _dword          := TO_DWORD( Outputs.Outputs.Reg2.Float_5);
            _data100[72]    := _dword.%B3;
            _data100[73]    := _dword.%B2;
            _data100[74]    := _dword.%B1;
            _data100[75]    := _dword.%B0;

            _dword          := TO_DWORD( Outputs.Outputs.Reg2.Float_6);
            _data100[76]    := _dword.%B3;
            _data100[77]    := _dword.%B2;
            _data100[78]    := _dword.%B1;
            _data100[79]    := _dword.%B0;

            _dword          := TO_DWORD( Outputs.Outputs.Reg2.Float_7);
            _data100[80]    := _dword.%B3;
            _data100[81]    := _dword.%B2;
            _data100[82]    := _dword.%B1;
            _data100[83]    := _dword.%B0;

            _dword          := TO_DWORD( Outputs.Outputs.Reg2.Float_8);
            _data100[84]    := _dword.%B3;
            _data100[85]    := _dword.%B2;
            _data100[86]    := _dword.%B1;
            _data100[87]    := _dword.%B0;

            _dword          := TO_DWORD( Outputs.Outputs.Reg2.Float_9);
            _data100[88]    := _dword.%B3;
            _data100[89]    := _dword.%B2;
            _data100[90]    := _dword.%B1;
            _data100[91]    := _dword.%B0;

            _dword          := TO_DWORD( Outputs.Outputs.Reg2.Float_10);
            _data100[92]    := _dword.%B3;
            _data100[93]    := _dword.%B2;
            _data100[94]    := _dword.%B1;
            _data100[95]    := _dword.%B0;

            _dword          := TO_DWORD( Outputs.Outputs.Reg2.Float_11);
            _data100[96]    := _dword.%B3;
            _data100[97]    := _dword.%B2;
            _data100[98]    := _dword.%B1;
            _data100[99]    := _dword.%B0;

            returnValue := Siemens.Simatic.S71500.DistributedIO.WriteData(_hwIdAxoUrRobotics_O2T_General_Purpose_Registers_2,_data100);
            Messenger.ActivateOnCondition(ULINT#723,returnValue > WORD#0, eAxoMessageCategory#ProgrammingError);
            IF returnValue > WORD#0 THEN
                RobotStatus.Error.Id := UINT#723;
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
            PowerOnTask.Restore();
            StopMovementsTask.Restore();
            StopMovementsAndProgramTask.Restore();
            StopProgramTask.Restore();
            // StopMotorsTask.Restore();
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

        METHOD PUBLIC StartMotors : IAxoTaskState
            StartMotors := StartMotorsTask.Invoke();
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
            

        METHOD PUBLIC StopMovements : IAxoTaskState
            VAR_INPUT
                inStopType : eAxoRoboticsStopType;
            END_VAR
            _stopType := inStopType;
            StopMovements := StopMovementsTask.Invoke();           
        END_METHOD

        METHOD PUBLIC StopMovementsAndProgram : IAxoTaskState
            VAR_INPUT
                inStopType : eAxoRoboticsStopType;
            END_VAR
            _stopType := inStopType;
            StopMovementsAndProgram := StopMovementsAndProgramTask.Invoke();
        END_METHOD
        
        METHOD PUBLIC StopProgram : IAxoTaskState
            StopProgram := StopProgramTask.Invoke();           
        END_METHOD

        // METHOD PUBLIC StopMotors : IAxoTaskState
        //     StopMotors := StopMotorsTask.Invoke();           
        // END_METHOD

        METHOD PRIVATE CallTimers
            VAR_INPUT
                signal : BOOL;
            END_VAR
            
            _infoTimer.OnDelay(THIS, signal , _infoTime);
            _errorTimer.OnDelay(THIS, signal , _errorTime );
        END_METHOD

        METHOD PRIVATE GetRobotModeDescription : eAxoUrRoboticsRobotMode
            VAR_INPUT
                inMode:USINT;
            END_VAR
            CASE inMode OF
                USINT#0: GetRobotModeDescription := eAxoUrRoboticsRobotMode#DISCONNECTED;
                USINT#1: GetRobotModeDescription := eAxoUrRoboticsRobotMode#SAFETY;
                USINT#2: GetRobotModeDescription := eAxoUrRoboticsRobotMode#BOOTING;
                USINT#3: GetRobotModeDescription := eAxoUrRoboticsRobotMode#POWER_OFF;
                USINT#4: GetRobotModeDescription := eAxoUrRoboticsRobotMode#POWER_ON;
                USINT#5: GetRobotModeDescription := eAxoUrRoboticsRobotMode#IDLE;
                USINT#6: GetRobotModeDescription := eAxoUrRoboticsRobotMode#BACKDRIVE;
                USINT#7: GetRobotModeDescription := eAxoUrRoboticsRobotMode#RUNNING;
                USINT#8: GetRobotModeDescription := eAxoUrRoboticsRobotMode#UPDATING_FIRMWARE;
            END_CASE;
        END_METHOD
    END_CLASS
END_NAMESPACE
