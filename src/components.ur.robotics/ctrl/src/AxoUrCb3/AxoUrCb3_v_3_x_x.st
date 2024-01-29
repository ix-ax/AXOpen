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
                refAxoUrRobotics_T2O_State                              : REF_TO ARRAY[0..31] OF BYTE;
                refAxoUrRobotics_T2O_IO                                 : REF_TO ARRAY[0..67] OF BYTE;
                refAxoUrRobotics_T2O_Joints                             : REF_TO ARRAY[0..103] OF BYTE;
                refAxoUrRobotics_T2O_TCP                                : REF_TO ARRAY[0..75] OF BYTE;
                refAxoUrRobotics_T2O_General_Purpose_Bit_Registers      : REF_TO ARRAY[0..7] OF BYTE;
                refAxoUrRobotics_T2O_General_Purpose_Int_Registers      : REF_TO ARRAY[0..95] OF BYTE;
                refAxoUrRobotics_T2O_General_Purpose_Float_Registers    : REF_TO ARRAY[0..95] OF BYTE;
                refAxoUrRobotics_O2T_Robot_IO                           : REF_TO ARRAY[0..23] OF BYTE;
                refAxoUrRobotics_O2T_General_Purpose_Registers_1        : REF_TO ARRAY[0..99] OF BYTE;
                refAxoUrRobotics_O2T_General_Purpose_Registers_2        : REF_TO ARRAY[0..99] OF BYTE;
                refPowerOnPulse                                         : REF_TO BOOL;
            END_VAR

            Messenger.ActivateOnCondition(ULINT#700,parent = NULL, eAxoMessageCategory#ProgrammingError);

            IF parent = NULL THEN
                RobotStatus.Error.Id := UINT#700;
                RETURN;
            END_IF;

            THIS.Initialize(parent);
            THIS.Execute(hwID,
                        refAxoUrRobotics_T2O_State,
                        refAxoUrRobotics_T2O_IO,
                        refAxoUrRobotics_T2O_Joints,
                        refAxoUrRobotics_T2O_TCP,                           
                        refAxoUrRobotics_T2O_General_Purpose_Bit_Registers, 
                        refAxoUrRobotics_T2O_General_Purpose_Int_Registers, 
                        refAxoUrRobotics_T2O_General_Purpose_Float_Registers,
                        refAxoUrRobotics_O2T_Robot_IO,                      
                        refAxoUrRobotics_O2T_General_Purpose_Registers_1,   
                        refAxoUrRobotics_O2T_General_Purpose_Registers_2,
                        refPowerOnPulse );
        END_METHOD

        ///<summary>
        /// Runs tasks and logic of this component.
        /// >[!IMPORTANT] This method must or one of its overloads be called cyclically.
        ///</summary>
        METHOD PUBLIC Run 
            VAR_INPUT
                parent                                                  : IAxoContext;
                hwID                                                    : WORD;
                refAxoUrRobotics_T2O_State                              : REF_TO ARRAY[0..31] OF BYTE;
                refAxoUrRobotics_T2O_IO                                 : REF_TO ARRAY[0..67] OF BYTE;
                refAxoUrRobotics_T2O_Joints                             : REF_TO ARRAY[0..103] OF BYTE;
                refAxoUrRobotics_T2O_TCP                                : REF_TO ARRAY[0..75] OF BYTE;
                refAxoUrRobotics_T2O_General_Purpose_Bit_Registers      : REF_TO ARRAY[0..7] OF BYTE;
                refAxoUrRobotics_T2O_General_Purpose_Int_Registers      : REF_TO ARRAY[0..95] OF BYTE;
                refAxoUrRobotics_T2O_General_Purpose_Float_Registers    : REF_TO ARRAY[0..95] OF BYTE;
                refAxoUrRobotics_O2T_Robot_IO                           : REF_TO ARRAY[0..23] OF BYTE;
                refAxoUrRobotics_O2T_General_Purpose_Registers_1        : REF_TO ARRAY[0..99] OF BYTE;
                refAxoUrRobotics_O2T_General_Purpose_Registers_2        : REF_TO ARRAY[0..99] OF BYTE;
                refPowerOnPulse                                         : REF_TO BOOL;
            END_VAR

            Messenger.ActivateOnCondition(ULINT#700,parent = NULL, eAxoMessageCategory#ProgrammingError);

            IF parent = NULL THEN
                RobotStatus.Error.Id := UINT#700;
                RETURN;
            END_IF;

            THIS.Initialize(parent);
            THIS.Execute(hwID,
                        refAxoUrRobotics_T2O_State,
                        refAxoUrRobotics_T2O_IO,
                        refAxoUrRobotics_T2O_Joints,
                        refAxoUrRobotics_T2O_TCP,                           
                        refAxoUrRobotics_T2O_General_Purpose_Bit_Registers, 
                        refAxoUrRobotics_T2O_General_Purpose_Int_Registers, 
                        refAxoUrRobotics_T2O_General_Purpose_Float_Registers,
                        refAxoUrRobotics_O2T_Robot_IO,                      
                        refAxoUrRobotics_O2T_General_Purpose_Registers_1,   
                        refAxoUrRobotics_O2T_General_Purpose_Registers_2,
                        refPowerOnPulse );

        END_METHOD

        METHOD PRIVATE Execute 
            VAR_INPUT
                hwID                                                    : WORD;
                refAxoUrRobotics_T2O_State                              : REF_TO ARRAY[0..31] OF BYTE;
                refAxoUrRobotics_T2O_IO                                 : REF_TO ARRAY[0..67] OF BYTE;
                refAxoUrRobotics_T2O_Joints                             : REF_TO ARRAY[0..103] OF BYTE;
                refAxoUrRobotics_T2O_TCP                                : REF_TO ARRAY[0..75] OF BYTE;
                refAxoUrRobotics_T2O_General_Purpose_Bit_Registers      : REF_TO ARRAY[0..7] OF BYTE;
                refAxoUrRobotics_T2O_General_Purpose_Int_Registers      : REF_TO ARRAY[0..95] OF BYTE;
                refAxoUrRobotics_T2O_General_Purpose_Float_Registers    : REF_TO ARRAY[0..95] OF BYTE;
                refAxoUrRobotics_O2T_Robot_IO                           : REF_TO ARRAY[0..23] OF BYTE;
                refAxoUrRobotics_O2T_General_Purpose_Registers_1        : REF_TO ARRAY[0..99] OF BYTE;
                refAxoUrRobotics_O2T_General_Purpose_Registers_2        : REF_TO ARRAY[0..99] OF BYTE;
                refPowerOnPulse                                         : REF_TO BOOL;
            END_VAR
            VAR 
                _word : WORD;
                _dword: DWORD;
            END_VAR

            Messenger.ActivateOnCondition(ULINT#701, refAxoUrRobotics_T2O_State = NULL, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#702, refAxoUrRobotics_T2O_IO = NULL, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#703, refAxoUrRobotics_T2O_Joints = NULL, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#704, refAxoUrRobotics_T2O_TCP = NULL, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#705, refAxoUrRobotics_T2O_General_Purpose_Bit_Registers = NULL, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#706, refAxoUrRobotics_T2O_General_Purpose_Int_Registers = NULL, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#707, refAxoUrRobotics_T2O_General_Purpose_Float_Registers = NULL, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#708, refAxoUrRobotics_O2T_Robot_IO = NULL, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#709, refAxoUrRobotics_O2T_General_Purpose_Registers_1 = NULL, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#710, refAxoUrRobotics_O2T_General_Purpose_Registers_2 = NULL, eAxoMessageCategory#ProgrammingError);

            IF refAxoUrRobotics_T2O_State        = NULL THEN
                RobotStatus.Error.Id := UINT#701;
                RETURN;
            ELSIF refAxoUrRobotics_T2O_IO        = NULL THEN
                RobotStatus.Error.Id := UINT#702;
                RETURN;
            ELSIF refAxoUrRobotics_T2O_Joints        = NULL THEN
                RobotStatus.Error.Id := UINT#703;
                RETURN;
            ELSIF refAxoUrRobotics_T2O_TCP        = NULL THEN
                RobotStatus.Error.Id := UINT#704;
                RETURN;
            ELSIF refAxoUrRobotics_T2O_General_Purpose_Bit_Registers        = NULL THEN
                RobotStatus.Error.Id := UINT#705;
                RETURN;
            ELSIF refAxoUrRobotics_T2O_General_Purpose_Int_Registers        = NULL THEN
                RobotStatus.Error.Id := UINT#706;
                RETURN;
            ELSIF refAxoUrRobotics_T2O_General_Purpose_Float_Registers        = NULL THEN
                RobotStatus.Error.Id := UINT#707;
                RETURN;
            ELSIF refAxoUrRobotics_O2T_Robot_IO        = NULL THEN
                RobotStatus.Error.Id := UINT#708;
                RETURN;
            ELSIF refAxoUrRobotics_O2T_General_Purpose_Registers_1        = NULL THEN
                RobotStatus.Error.Id := UINT#709;
                RETURN;
            ELSIF refAxoUrRobotics_O2T_General_Purpose_Registers_2        = NULL THEN
                RobotStatus.Error.Id := UINT#710;
                RETURN;
            END_IF;

            THIS.Open();
            //***********UPDATE**INPUTS******************
            //Inputs Low level
            //INPUTS T2O STATE ROBOT => st_URO_CB3_T2OInfoData
            Inputs.Inputs.Robot.ControllerMajorVersion := TO_USINT(refAxoUrRobotics_T2O_State^[0]);
            Inputs.Inputs.Robot.ControllerMinorVersion := TO_USINT(refAxoUrRobotics_T2O_State^[1]);
            Inputs.Inputs.Robot.RobotMode := TO_USINT(refAxoUrRobotics_T2O_State^[4]);
            Inputs.Inputs.Robot.RealtimeMachineSeconds := TO_USINT(refAxoUrRobotics_T2O_State^[5]);
            _word.%B1 := refAxoUrRobotics_T2O_State^[6];
            _word.%B0 := refAxoUrRobotics_T2O_State^[7];
            Inputs.Inputs.Robot.RealtimeMachineMilliseconds := TO_UINT(_word);
            Inputs.Inputs.Robot.RealtimeMachineMinutes := TO_USINT(refAxoUrRobotics_T2O_State^[8]);
            Inputs.Inputs.Robot.RealtimeMachineHours := TO_USINT(refAxoUrRobotics_T2O_State^[9]);
            _word.%B1 := refAxoUrRobotics_T2O_State^[10];
            _word.%B0 := refAxoUrRobotics_T2O_State^[11];
            Inputs.Inputs.Robot.RealtimeMachineDays := TO_UINT(_word);
            _dword.%B3 := refAxoUrRobotics_T2O_State^[12];
            _dword.%B2 := refAxoUrRobotics_T2O_State^[13];
            _dword.%B1 := refAxoUrRobotics_T2O_State^[14];
            _dword.%B0 := refAxoUrRobotics_T2O_State^[15];
            Inputs.Inputs.Robot.RobotCurrent := TO_REAL(_dword);
            //INPUTS T2O STATE ROBOT => st_URO_CB3_T2OStateData
            Inputs.Inputs.Robot.PW_IsPowerOn            := refAxoUrRobotics_T2O_State^[16].%X0;
            Inputs.Inputs.Robot.PR_IsProgramRunning     := refAxoUrRobotics_T2O_State^[16].%X1;
            Inputs.Inputs.Robot.TB_IsTeachButtonPressed := refAxoUrRobotics_T2O_State^[16].%X2;
            Inputs.Inputs.Robot.PB_IsPowerButtonPressed := refAxoUrRobotics_T2O_State^[16].%X3;
            _dword.%B3 := refAxoUrRobotics_T2O_State^[20];
            _dword.%B2 := refAxoUrRobotics_T2O_State^[21];
            _dword.%B1 := refAxoUrRobotics_T2O_State^[22];
            _dword.%B0 := refAxoUrRobotics_T2O_State^[23];
            Inputs.Inputs.Robot.SpeedSliderFraction :=REAL#100.0 * TO_REAL(_dword);
            Inputs.Inputs.Safety.SafetyMode := TO_USINT(refAxoUrRobotics_T2O_State^[24]);
            Inputs.Inputs.Safety.NO_IsNormalMode := refAxoUrRobotics_T2O_State^[28].%X0;
            Inputs.Inputs.Safety.RD_IsReducedMode := refAxoUrRobotics_T2O_State^[28].%X1;
            Inputs.Inputs.Safety.PS_IsProtectiveStopped := refAxoUrRobotics_T2O_State^[28].%X2;
            Inputs.Inputs.Safety.RC_IsRecoveryMode := refAxoUrRobotics_T2O_State^[28].%X3;
            Inputs.Inputs.Safety.SS_IsSafeguardStopped := refAxoUrRobotics_T2O_State^[28].%X4;
            Inputs.Inputs.Safety.SES_IsSystemEmergencyStopped := refAxoUrRobotics_T2O_State^[28].%X5;
            Inputs.Inputs.Safety.RES_IsRobotEmergencyStopped := refAxoUrRobotics_T2O_State^[28].%X6;
            Inputs.Inputs.Safety.ES_IsEmergencyStopped := refAxoUrRobotics_T2O_State^[28].%X7;
            Inputs.Inputs.Safety.VL_IsViolation := refAxoUrRobotics_T2O_State^[29].%X0;
            Inputs.Inputs.Safety.FT_IsFault := refAxoUrRobotics_T2O_State^[29].%X1;
            Inputs.Inputs.Safety.ST_IsStoppedDueSafety := refAxoUrRobotics_T2O_State^[29].%X2;

            //INPUTS T20 IO => st_URO_CB3_T2OIoStateData
            Inputs.Inputs.IO.StandardDigitalInputs := TO_USINT(refAxoUrRobotics_T2O_IO^[0]);
            Inputs.Inputs.IO.ConfigurableDigitalInputs := TO_USINT(refAxoUrRobotics_T2O_IO^[1]);
            Inputs.Inputs.IO.StandardDigitalOutputs := TO_USINT(refAxoUrRobotics_T2O_IO^[2]);
            Inputs.Inputs.IO.ConfigurableDigitalOutputs := TO_USINT(refAxoUrRobotics_T2O_IO^[3]);
            Inputs.Inputs.IO.AnalogIoTypes := TO_USINT(refAxoUrRobotics_T2O_IO^[4]);
            _dword.%B3 := refAxoUrRobotics_T2O_IO^[8];
            _dword.%B2 := refAxoUrRobotics_T2O_IO^[9];
            _dword.%B1 := refAxoUrRobotics_T2O_IO^[10];
            _dword.%B0 := refAxoUrRobotics_T2O_IO^[11];
            Inputs.Inputs.IO.StandardAnalogInput_0 := TO_REAL(_dword);
            _dword.%B3 := refAxoUrRobotics_T2O_IO^[12];
            _dword.%B2 := refAxoUrRobotics_T2O_IO^[13];
            _dword.%B1 := refAxoUrRobotics_T2O_IO^[14];
            _dword.%B0 := refAxoUrRobotics_T2O_IO^[15];
            Inputs.Inputs.IO.StandardAnalogInput_1 := TO_REAL(_dword);            
            _dword.%B3 := refAxoUrRobotics_T2O_IO^[16];
            _dword.%B2 := refAxoUrRobotics_T2O_IO^[17];
            _dword.%B1 := refAxoUrRobotics_T2O_IO^[18];
            _dword.%B0 := refAxoUrRobotics_T2O_IO^[19];
            Inputs.Inputs.IO.StandardAnalogOutput_0 := TO_REAL(_dword);
            _dword.%B3 := refAxoUrRobotics_T2O_IO^[20];
            _dword.%B2 := refAxoUrRobotics_T2O_IO^[21];
            _dword.%B1 := refAxoUrRobotics_T2O_IO^[22];
            _dword.%B0 := refAxoUrRobotics_T2O_IO^[23];
            Inputs.Inputs.IO.StandardAnalogOutput_1 := TO_REAL(_dword);            
            _dword.%B3 := refAxoUrRobotics_T2O_IO^[24];
            _dword.%B2 := refAxoUrRobotics_T2O_IO^[25];
            _dword.%B1 := refAxoUrRobotics_T2O_IO^[26];
            _dword.%B0 := refAxoUrRobotics_T2O_IO^[27];
            Inputs.Inputs.IO.Current := TO_REAL(_dword);            

            Inputs.Inputs.IO.Euromap67InputBit_0  := refAxoUrRobotics_T2O_IO^[28].%X0;
            Inputs.Inputs.IO.Euromap67InputBit_1  := refAxoUrRobotics_T2O_IO^[28].%X1;
            Inputs.Inputs.IO.Euromap67InputBit_2  := refAxoUrRobotics_T2O_IO^[28].%X2;
            Inputs.Inputs.IO.Euromap67InputBit_3  := refAxoUrRobotics_T2O_IO^[28].%X3;
            Inputs.Inputs.IO.Euromap67InputBit_4  := refAxoUrRobotics_T2O_IO^[28].%X4;
            Inputs.Inputs.IO.Euromap67InputBit_5  := refAxoUrRobotics_T2O_IO^[28].%X5;
            Inputs.Inputs.IO.Euromap67InputBit_6  := refAxoUrRobotics_T2O_IO^[28].%X6;
            Inputs.Inputs.IO.Euromap67InputBit_7  := refAxoUrRobotics_T2O_IO^[28].%X7;
            Inputs.Inputs.IO.Euromap67InputBit_8  := refAxoUrRobotics_T2O_IO^[29].%X0;
            Inputs.Inputs.IO.Euromap67InputBit_9  := refAxoUrRobotics_T2O_IO^[29].%X1;
            Inputs.Inputs.IO.Euromap67InputBit_10 := refAxoUrRobotics_T2O_IO^[29].%X2;
            Inputs.Inputs.IO.Euromap67InputBit_11 := refAxoUrRobotics_T2O_IO^[29].%X3;
            Inputs.Inputs.IO.Euromap67InputBit_12 := refAxoUrRobotics_T2O_IO^[29].%X4;
            Inputs.Inputs.IO.Euromap67InputBit_13 := refAxoUrRobotics_T2O_IO^[29].%X5;
            Inputs.Inputs.IO.Euromap67InputBit_14 := refAxoUrRobotics_T2O_IO^[29].%X6;
            Inputs.Inputs.IO.Euromap67InputBit_15 := refAxoUrRobotics_T2O_IO^[29].%X7;
            Inputs.Inputs.IO.Euromap67InputBit_16 := refAxoUrRobotics_T2O_IO^[30].%X0;
            Inputs.Inputs.IO.Euromap67InputBit_17 := refAxoUrRobotics_T2O_IO^[30].%X1;
            Inputs.Inputs.IO.Euromap67InputBit_18 := refAxoUrRobotics_T2O_IO^[30].%X2;
            Inputs.Inputs.IO.Euromap67InputBit_19 := refAxoUrRobotics_T2O_IO^[30].%X3;
            Inputs.Inputs.IO.Euromap67InputBit_20 := refAxoUrRobotics_T2O_IO^[30].%X4;
            Inputs.Inputs.IO.Euromap67InputBit_21 := refAxoUrRobotics_T2O_IO^[30].%X5;
            Inputs.Inputs.IO.Euromap67InputBit_22 := refAxoUrRobotics_T2O_IO^[30].%X6;
            Inputs.Inputs.IO.Euromap67InputBit_23 := refAxoUrRobotics_T2O_IO^[30].%X7;
            Inputs.Inputs.IO.Euromap67InputBit_24 := refAxoUrRobotics_T2O_IO^[31].%X0;
            Inputs.Inputs.IO.Euromap67InputBit_25 := refAxoUrRobotics_T2O_IO^[31].%X1;
            Inputs.Inputs.IO.Euromap67InputBit_26 := refAxoUrRobotics_T2O_IO^[31].%X2;
            Inputs.Inputs.IO.Euromap67InputBit_27 := refAxoUrRobotics_T2O_IO^[31].%X3;
            Inputs.Inputs.IO.Euromap67InputBit_28 := refAxoUrRobotics_T2O_IO^[31].%X4;
            Inputs.Inputs.IO.Euromap67InputBit_29 := refAxoUrRobotics_T2O_IO^[31].%X5;
            Inputs.Inputs.IO.Euromap67InputBit_30 := refAxoUrRobotics_T2O_IO^[31].%X6;
            Inputs.Inputs.IO.Euromap67InputBit_31 := refAxoUrRobotics_T2O_IO^[31].%X7;

            Inputs.Inputs.IO.Euromap67OutputBit_0  := refAxoUrRobotics_T2O_IO^[32].%X0;
            Inputs.Inputs.IO.Euromap67OutputBit_1  := refAxoUrRobotics_T2O_IO^[32].%X1;
            Inputs.Inputs.IO.Euromap67OutputBit_2  := refAxoUrRobotics_T2O_IO^[32].%X2;
            Inputs.Inputs.IO.Euromap67OutputBit_3  := refAxoUrRobotics_T2O_IO^[32].%X3;
            Inputs.Inputs.IO.Euromap67OutputBit_4  := refAxoUrRobotics_T2O_IO^[32].%X4;
            Inputs.Inputs.IO.Euromap67OutputBit_5  := refAxoUrRobotics_T2O_IO^[32].%X5;
            Inputs.Inputs.IO.Euromap67OutputBit_6  := refAxoUrRobotics_T2O_IO^[32].%X6;
            Inputs.Inputs.IO.Euromap67OutputBit_7  := refAxoUrRobotics_T2O_IO^[32].%X7;
            Inputs.Inputs.IO.Euromap67OutputBit_8  := refAxoUrRobotics_T2O_IO^[33].%X0;
            Inputs.Inputs.IO.Euromap67OutputBit_9  := refAxoUrRobotics_T2O_IO^[33].%X1;
            Inputs.Inputs.IO.Euromap67OutputBit_10 := refAxoUrRobotics_T2O_IO^[33].%X2;
            Inputs.Inputs.IO.Euromap67OutputBit_11 := refAxoUrRobotics_T2O_IO^[33].%X3;
            Inputs.Inputs.IO.Euromap67OutputBit_12 := refAxoUrRobotics_T2O_IO^[33].%X4;
            Inputs.Inputs.IO.Euromap67OutputBit_13 := refAxoUrRobotics_T2O_IO^[33].%X5;
            Inputs.Inputs.IO.Euromap67OutputBit_14 := refAxoUrRobotics_T2O_IO^[33].%X6;
            Inputs.Inputs.IO.Euromap67OutputBit_15 := refAxoUrRobotics_T2O_IO^[33].%X7;
            Inputs.Inputs.IO.Euromap67OutputBit_16 := refAxoUrRobotics_T2O_IO^[34].%X0;
            Inputs.Inputs.IO.Euromap67OutputBit_17 := refAxoUrRobotics_T2O_IO^[34].%X1;
            Inputs.Inputs.IO.Euromap67OutputBit_18 := refAxoUrRobotics_T2O_IO^[34].%X2;
            Inputs.Inputs.IO.Euromap67OutputBit_19 := refAxoUrRobotics_T2O_IO^[34].%X3;
            Inputs.Inputs.IO.Euromap67OutputBit_20 := refAxoUrRobotics_T2O_IO^[34].%X4;
            Inputs.Inputs.IO.Euromap67OutputBit_21 := refAxoUrRobotics_T2O_IO^[34].%X5;
            Inputs.Inputs.IO.Euromap67OutputBit_22 := refAxoUrRobotics_T2O_IO^[34].%X6;
            Inputs.Inputs.IO.Euromap67OutputBit_23 := refAxoUrRobotics_T2O_IO^[34].%X7;
            Inputs.Inputs.IO.Euromap67OutputBit_24 := refAxoUrRobotics_T2O_IO^[35].%X0;
            Inputs.Inputs.IO.Euromap67OutputBit_25 := refAxoUrRobotics_T2O_IO^[35].%X1;
            Inputs.Inputs.IO.Euromap67OutputBit_26 := refAxoUrRobotics_T2O_IO^[35].%X2;
            Inputs.Inputs.IO.Euromap67OutputBit_27 := refAxoUrRobotics_T2O_IO^[35].%X3;
            Inputs.Inputs.IO.Euromap67OutputBit_28 := refAxoUrRobotics_T2O_IO^[35].%X4;
            Inputs.Inputs.IO.Euromap67OutputBit_29 := refAxoUrRobotics_T2O_IO^[35].%X5;
            Inputs.Inputs.IO.Euromap67OutputBit_30 := refAxoUrRobotics_T2O_IO^[35].%X6;
            Inputs.Inputs.IO.Euromap67OutputBit_31 := refAxoUrRobotics_T2O_IO^[35].%X7;

            _dword.%B3 := refAxoUrRobotics_T2O_IO^[36];
            _dword.%B2 := refAxoUrRobotics_T2O_IO^[37];
            _dword.%B1 := refAxoUrRobotics_T2O_IO^[38];
            _dword.%B0 := refAxoUrRobotics_T2O_IO^[39];
            Inputs.Inputs.IO.Euromap6724Voltage := TO_REAL(_dword);            

            _dword.%B3 := refAxoUrRobotics_T2O_IO^[40];
            _dword.%B2 := refAxoUrRobotics_T2O_IO^[41];
            _dword.%B1 := refAxoUrRobotics_T2O_IO^[42];
            _dword.%B0 := refAxoUrRobotics_T2O_IO^[43];
            Inputs.Inputs.IO.Euromap6724VCurrent := TO_REAL(_dword);  

            //INPUTS T20 IO => st_URO_CB3_T2OToolStateData
            Inputs.Inputs.Tool.ToolMode := TO_USINT(refAxoUrRobotics_T2O_IO^[44]);
            Inputs.Inputs.Tool.TDI_ToolDigitalInputs := TO_USINT(refAxoUrRobotics_T2O_IO^[45]);
            Inputs.Inputs.Tool.TDO_ToolDigitalOutputs := TO_USINT(refAxoUrRobotics_T2O_IO^[46]);
            Inputs.Inputs.Tool.TAIT_ToolAnalogInputTypes := TO_USINT(refAxoUrRobotics_T2O_IO^[47]);

            _dword.%B3 := refAxoUrRobotics_T2O_IO^[48];
            _dword.%B2 := refAxoUrRobotics_T2O_IO^[49];
            _dword.%B1 := refAxoUrRobotics_T2O_IO^[50];
            _dword.%B0 := refAxoUrRobotics_T2O_IO^[51];
            Inputs.Inputs.Tool.ToolAnalogInput_0 := TO_REAL(_dword);    

            _dword.%B3 := refAxoUrRobotics_T2O_IO^[52];
            _dword.%B2 := refAxoUrRobotics_T2O_IO^[53];
            _dword.%B1 := refAxoUrRobotics_T2O_IO^[54];
            _dword.%B0 := refAxoUrRobotics_T2O_IO^[55];
            Inputs.Inputs.Tool.ToolAnalogInput_1 := TO_REAL(_dword);    

            _dword.%B3 := refAxoUrRobotics_T2O_IO^[56];
            _dword.%B2 := refAxoUrRobotics_T2O_IO^[57];
            _dword.%B1 := refAxoUrRobotics_T2O_IO^[58];
            _dword.%B0 := refAxoUrRobotics_T2O_IO^[59];
            Inputs.Inputs.Tool.ToolOutputVoltage := TO_REAL(_dword);    

            _dword.%B3 := refAxoUrRobotics_T2O_IO^[60];
            _dword.%B2 := refAxoUrRobotics_T2O_IO^[61];
            _dword.%B1 := refAxoUrRobotics_T2O_IO^[62];
            _dword.%B0 := refAxoUrRobotics_T2O_IO^[63];
            Inputs.Inputs.Tool.ToolCurrent := TO_REAL(_dword);    

            // //INPUTS T20 JOINT => st_URO_CB3_T2OJointsData
            _dword.%B3 := refAxoUrRobotics_T2O_Joints^[0];
            _dword.%B2 := refAxoUrRobotics_T2O_Joints^[1];
            _dword.%B1 := refAxoUrRobotics_T2O_Joints^[2];
            _dword.%B0 := refAxoUrRobotics_T2O_Joints^[3];
            Inputs.Inputs.Joints.JointPosition_0 := REAL#57.2957795 * TO_REAL(_dword);    

            _dword.%B3 := refAxoUrRobotics_T2O_Joints^[4];
            _dword.%B2 := refAxoUrRobotics_T2O_Joints^[5];
            _dword.%B1 := refAxoUrRobotics_T2O_Joints^[6];
            _dword.%B0 := refAxoUrRobotics_T2O_Joints^[7];
            Inputs.Inputs.Joints.JointPosition_1 := REAL#57.2957795 * TO_REAL(_dword);    

            _dword.%B3 := refAxoUrRobotics_T2O_Joints^[8];
            _dword.%B2 := refAxoUrRobotics_T2O_Joints^[9];
            _dword.%B1 := refAxoUrRobotics_T2O_Joints^[10];
            _dword.%B0 := refAxoUrRobotics_T2O_Joints^[11];
            Inputs.Inputs.Joints.JointPosition_2 := REAL#57.2957795 * TO_REAL(_dword);    

            _dword.%B3 := refAxoUrRobotics_T2O_Joints^[12];
            _dword.%B2 := refAxoUrRobotics_T2O_Joints^[13];
            _dword.%B1 := refAxoUrRobotics_T2O_Joints^[14];
            _dword.%B0 := refAxoUrRobotics_T2O_Joints^[15];
            Inputs.Inputs.Joints.JointPosition_3 := REAL#57.2957795 * TO_REAL(_dword);    

            _dword.%B3 := refAxoUrRobotics_T2O_Joints^[16];
            _dword.%B2 := refAxoUrRobotics_T2O_Joints^[17];
            _dword.%B1 := refAxoUrRobotics_T2O_Joints^[18];
            _dword.%B0 := refAxoUrRobotics_T2O_Joints^[19];
            Inputs.Inputs.Joints.JointPosition_4 := REAL#57.2957795 * TO_REAL(_dword);    

            _dword.%B3 := refAxoUrRobotics_T2O_Joints^[20];
            _dword.%B2 := refAxoUrRobotics_T2O_Joints^[21];
            _dword.%B1 := refAxoUrRobotics_T2O_Joints^[22];
            _dword.%B0 := refAxoUrRobotics_T2O_Joints^[23];
            Inputs.Inputs.Joints.JointPosition_5 := REAL#57.2957795 * TO_REAL(_dword);    

            _dword.%B3 := refAxoUrRobotics_T2O_Joints^[24];
            _dword.%B2 := refAxoUrRobotics_T2O_Joints^[25];
            _dword.%B1 := refAxoUrRobotics_T2O_Joints^[26];
            _dword.%B0 := refAxoUrRobotics_T2O_Joints^[27];
            Inputs.Inputs.Joints.JointVelocity_0 :=  TO_REAL(_dword);    

            _dword.%B3 := refAxoUrRobotics_T2O_Joints^[28];
            _dword.%B2 := refAxoUrRobotics_T2O_Joints^[29];
            _dword.%B1 := refAxoUrRobotics_T2O_Joints^[30];
            _dword.%B0 := refAxoUrRobotics_T2O_Joints^[31];
            Inputs.Inputs.Joints.JointVelocity_1 :=  TO_REAL(_dword);    

            _dword.%B3 := refAxoUrRobotics_T2O_Joints^[32];
            _dword.%B2 := refAxoUrRobotics_T2O_Joints^[33];
            _dword.%B1 := refAxoUrRobotics_T2O_Joints^[34];
            _dword.%B0 := refAxoUrRobotics_T2O_Joints^[35];
            Inputs.Inputs.Joints.JointVelocity_2 :=  TO_REAL(_dword);    

            _dword.%B3 := refAxoUrRobotics_T2O_Joints^[36];
            _dword.%B2 := refAxoUrRobotics_T2O_Joints^[37];
            _dword.%B1 := refAxoUrRobotics_T2O_Joints^[38];
            _dword.%B0 := refAxoUrRobotics_T2O_Joints^[39];
            Inputs.Inputs.Joints.JointVelocity_3 :=  TO_REAL(_dword);    

            _dword.%B3 := refAxoUrRobotics_T2O_Joints^[40];
            _dword.%B2 := refAxoUrRobotics_T2O_Joints^[41];
            _dword.%B1 := refAxoUrRobotics_T2O_Joints^[42];
            _dword.%B0 := refAxoUrRobotics_T2O_Joints^[43];
            Inputs.Inputs.Joints.JointVelocity_4 :=  TO_REAL(_dword);    

            _dword.%B3 := refAxoUrRobotics_T2O_Joints^[44];
            _dword.%B2 := refAxoUrRobotics_T2O_Joints^[45];
            _dword.%B1 := refAxoUrRobotics_T2O_Joints^[46];
            _dword.%B0 := refAxoUrRobotics_T2O_Joints^[47];
            Inputs.Inputs.Joints.JointVelocity_5 :=  TO_REAL(_dword);    

            _dword.%B3 := refAxoUrRobotics_T2O_Joints^[48];
            _dword.%B2 := refAxoUrRobotics_T2O_Joints^[49];
            _dword.%B1 := refAxoUrRobotics_T2O_Joints^[50];
            _dword.%B0 := refAxoUrRobotics_T2O_Joints^[51];
            Inputs.Inputs.Joints.JointCurrent_0 :=  TO_REAL(_dword);    

            _dword.%B3 := refAxoUrRobotics_T2O_Joints^[52];
            _dword.%B2 := refAxoUrRobotics_T2O_Joints^[53];
            _dword.%B1 := refAxoUrRobotics_T2O_Joints^[54];
            _dword.%B0 := refAxoUrRobotics_T2O_Joints^[55];
            Inputs.Inputs.Joints.JointCurrent_1 :=  TO_REAL(_dword);    

            _dword.%B3 := refAxoUrRobotics_T2O_Joints^[56];
            _dword.%B2 := refAxoUrRobotics_T2O_Joints^[57];
            _dword.%B1 := refAxoUrRobotics_T2O_Joints^[58];
            _dword.%B0 := refAxoUrRobotics_T2O_Joints^[59];
            Inputs.Inputs.Joints.JointCurrent_2 :=  TO_REAL(_dword);    

            _dword.%B3 := refAxoUrRobotics_T2O_Joints^[60];
            _dword.%B2 := refAxoUrRobotics_T2O_Joints^[61];
            _dword.%B1 := refAxoUrRobotics_T2O_Joints^[62];
            _dword.%B0 := refAxoUrRobotics_T2O_Joints^[63];
            Inputs.Inputs.Joints.JointCurrent_3 :=  TO_REAL(_dword);    

            _dword.%B3 := refAxoUrRobotics_T2O_Joints^[64];
            _dword.%B2 := refAxoUrRobotics_T2O_Joints^[65];
            _dword.%B1 := refAxoUrRobotics_T2O_Joints^[66];
            _dword.%B0 := refAxoUrRobotics_T2O_Joints^[67];
            Inputs.Inputs.Joints.JointCurrent_4 :=  TO_REAL(_dword);    

            _dword.%B3 := refAxoUrRobotics_T2O_Joints^[68];
            _dword.%B2 := refAxoUrRobotics_T2O_Joints^[69];
            _dword.%B1 := refAxoUrRobotics_T2O_Joints^[70];
            _dword.%B0 := refAxoUrRobotics_T2O_Joints^[71];
            Inputs.Inputs.Joints.JointCurrent_5 :=  TO_REAL(_dword);    

            _dword.%B3 := refAxoUrRobotics_T2O_Joints^[72];
            _dword.%B2 := refAxoUrRobotics_T2O_Joints^[73];
            _dword.%B1 := refAxoUrRobotics_T2O_Joints^[74];
            _dword.%B0 := refAxoUrRobotics_T2O_Joints^[75];
            Inputs.Inputs.Joints.JointTemperature_0 :=  TO_REAL(_dword);    

            _dword.%B3 := refAxoUrRobotics_T2O_Joints^[76];
            _dword.%B2 := refAxoUrRobotics_T2O_Joints^[77];
            _dword.%B1 := refAxoUrRobotics_T2O_Joints^[78];
            _dword.%B0 := refAxoUrRobotics_T2O_Joints^[79];
            Inputs.Inputs.Joints.JointTemperature_1 :=  TO_REAL(_dword);    

            _dword.%B3 := refAxoUrRobotics_T2O_Joints^[80];
            _dword.%B2 := refAxoUrRobotics_T2O_Joints^[81];
            _dword.%B1 := refAxoUrRobotics_T2O_Joints^[82];
            _dword.%B0 := refAxoUrRobotics_T2O_Joints^[83];
            Inputs.Inputs.Joints.JointTemperature_2 :=  TO_REAL(_dword);    

            _dword.%B3 := refAxoUrRobotics_T2O_Joints^[84];
            _dword.%B2 := refAxoUrRobotics_T2O_Joints^[85];
            _dword.%B1 := refAxoUrRobotics_T2O_Joints^[86];
            _dword.%B0 := refAxoUrRobotics_T2O_Joints^[87];
            Inputs.Inputs.Joints.JointTemperature_3 :=  TO_REAL(_dword);    

            _dword.%B3 := refAxoUrRobotics_T2O_Joints^[88];
            _dword.%B2 := refAxoUrRobotics_T2O_Joints^[89];
            _dword.%B1 := refAxoUrRobotics_T2O_Joints^[90];
            _dword.%B0 := refAxoUrRobotics_T2O_Joints^[91];
            Inputs.Inputs.Joints.JointTemperature_4 :=  TO_REAL(_dword);    

            _dword.%B3 := refAxoUrRobotics_T2O_Joints^[92];
            _dword.%B2 := refAxoUrRobotics_T2O_Joints^[93];
            _dword.%B1 := refAxoUrRobotics_T2O_Joints^[94];
            _dword.%B0 := refAxoUrRobotics_T2O_Joints^[95];
            Inputs.Inputs.Joints.JointTemperature_5 :=  TO_REAL(_dword);    

            Inputs.Inputs.Joints.JointMode_0 := TO_USINT(refAxoUrRobotics_T2O_Joints^[96]);
            Inputs.Inputs.Joints.JointMode_1 := TO_USINT(refAxoUrRobotics_T2O_Joints^[97]);
            Inputs.Inputs.Joints.JointMode_2 := TO_USINT(refAxoUrRobotics_T2O_Joints^[98]);
            Inputs.Inputs.Joints.JointMode_3 := TO_USINT(refAxoUrRobotics_T2O_Joints^[99]);
            Inputs.Inputs.Joints.JointMode_4 := TO_USINT(refAxoUrRobotics_T2O_Joints^[100]);
            Inputs.Inputs.Joints.JointMode_5 := TO_USINT(refAxoUrRobotics_T2O_Joints^[101]);

            //INPUTS T20 TCP => st_URO_CB3_T2OTcpData
            _dword.%B3 := refAxoUrRobotics_T2O_TCP^[0];
            _dword.%B2 := refAxoUrRobotics_T2O_TCP^[1];
            _dword.%B1 := refAxoUrRobotics_T2O_TCP^[2];
            _dword.%B0 := refAxoUrRobotics_T2O_TCP^[3];
            Inputs.Inputs.TCP.Postition.X := REAL#1000.0 * TO_REAL(_dword);  

            _dword.%B3 := refAxoUrRobotics_T2O_TCP^[4];
            _dword.%B2 := refAxoUrRobotics_T2O_TCP^[5];
            _dword.%B1 := refAxoUrRobotics_T2O_TCP^[6];
            _dword.%B0 := refAxoUrRobotics_T2O_TCP^[7];
            Inputs.Inputs.TCP.Postition.Y := REAL#1000.0 * TO_REAL(_dword);  

            _dword.%B3 := refAxoUrRobotics_T2O_TCP^[8];
            _dword.%B2 := refAxoUrRobotics_T2O_TCP^[9];
            _dword.%B1 := refAxoUrRobotics_T2O_TCP^[10];
            _dword.%B0 := refAxoUrRobotics_T2O_TCP^[11];
            Inputs.Inputs.TCP.Postition.Z := REAL#1000.0 * TO_REAL(_dword);  

            _dword.%B3 := refAxoUrRobotics_T2O_TCP^[12];
            _dword.%B2 := refAxoUrRobotics_T2O_TCP^[13];
            _dword.%B1 := refAxoUrRobotics_T2O_TCP^[14];
            _dword.%B0 := refAxoUrRobotics_T2O_TCP^[15];
            Inputs.Inputs.TCP.Postition.Rx := TO_REAL(_dword);  

            _dword.%B3 := refAxoUrRobotics_T2O_TCP^[16];
            _dword.%B2 := refAxoUrRobotics_T2O_TCP^[17];
            _dword.%B1 := refAxoUrRobotics_T2O_TCP^[18];
            _dword.%B0 := refAxoUrRobotics_T2O_TCP^[19];
            Inputs.Inputs.TCP.Postition.Ry := TO_REAL(_dword);  

            _dword.%B3 := refAxoUrRobotics_T2O_TCP^[20];
            _dword.%B2 := refAxoUrRobotics_T2O_TCP^[21];
            _dword.%B1 := refAxoUrRobotics_T2O_TCP^[22];
            _dword.%B0 := refAxoUrRobotics_T2O_TCP^[23];
            Inputs.Inputs.TCP.Postition.Rz := TO_REAL(_dword);  

            _dword.%B3 := refAxoUrRobotics_T2O_TCP^[24];
            _dword.%B2 := refAxoUrRobotics_T2O_TCP^[25];
            _dword.%B1 := refAxoUrRobotics_T2O_TCP^[26];
            _dword.%B0 := refAxoUrRobotics_T2O_TCP^[27];
            Inputs.Inputs.TCP.Velocity.X := REAL#1000.0 * TO_REAL(_dword);  

            _dword.%B3 := refAxoUrRobotics_T2O_TCP^[28];
            _dword.%B2 := refAxoUrRobotics_T2O_TCP^[29];
            _dword.%B1 := refAxoUrRobotics_T2O_TCP^[30];
            _dword.%B0 := refAxoUrRobotics_T2O_TCP^[31];
            Inputs.Inputs.TCP.Velocity.Y := REAL#1000.0 * TO_REAL(_dword);  

            _dword.%B3 := refAxoUrRobotics_T2O_TCP^[32];
            _dword.%B2 := refAxoUrRobotics_T2O_TCP^[33];
            _dword.%B1 := refAxoUrRobotics_T2O_TCP^[34];
            _dword.%B0 := refAxoUrRobotics_T2O_TCP^[35];
            Inputs.Inputs.TCP.Velocity.Z := REAL#1000.0 * TO_REAL(_dword);  

            _dword.%B3 := refAxoUrRobotics_T2O_TCP^[36];
            _dword.%B2 := refAxoUrRobotics_T2O_TCP^[37];
            _dword.%B1 := refAxoUrRobotics_T2O_TCP^[38];
            _dword.%B0 := refAxoUrRobotics_T2O_TCP^[39];
            Inputs.Inputs.TCP.Velocity.Rx := TO_REAL(_dword);  

            _dword.%B3 := refAxoUrRobotics_T2O_TCP^[40];
            _dword.%B2 := refAxoUrRobotics_T2O_TCP^[41];
            _dword.%B1 := refAxoUrRobotics_T2O_TCP^[42];
            _dword.%B0 := refAxoUrRobotics_T2O_TCP^[43];
            Inputs.Inputs.TCP.Velocity.Ry := TO_REAL(_dword);  

            _dword.%B3 := refAxoUrRobotics_T2O_TCP^[44];
            _dword.%B2 := refAxoUrRobotics_T2O_TCP^[45];
            _dword.%B1 := refAxoUrRobotics_T2O_TCP^[46];
            _dword.%B0 := refAxoUrRobotics_T2O_TCP^[47];
            Inputs.Inputs.TCP.Velocity.Rz := TO_REAL(_dword);  

            _dword.%B3 := refAxoUrRobotics_T2O_TCP^[48];
            _dword.%B2 := refAxoUrRobotics_T2O_TCP^[49];
            _dword.%B1 := refAxoUrRobotics_T2O_TCP^[50];
            _dword.%B0 := refAxoUrRobotics_T2O_TCP^[51];
            Inputs.Inputs.TCP.Force.X := TO_REAL(_dword);  

            _dword.%B3 := refAxoUrRobotics_T2O_TCP^[52];
            _dword.%B2 := refAxoUrRobotics_T2O_TCP^[53];
            _dword.%B1 := refAxoUrRobotics_T2O_TCP^[54];
            _dword.%B0 := refAxoUrRobotics_T2O_TCP^[55];
            Inputs.Inputs.TCP.Force.Y := TO_REAL(_dword);  

            _dword.%B3 := refAxoUrRobotics_T2O_TCP^[56];
            _dword.%B2 := refAxoUrRobotics_T2O_TCP^[57];
            _dword.%B1 := refAxoUrRobotics_T2O_TCP^[58];
            _dword.%B0 := refAxoUrRobotics_T2O_TCP^[59];
            Inputs.Inputs.TCP.Force.Z := TO_REAL(_dword);  

            _dword.%B3 := refAxoUrRobotics_T2O_TCP^[60];
            _dword.%B2 := refAxoUrRobotics_T2O_TCP^[61];
            _dword.%B1 := refAxoUrRobotics_T2O_TCP^[62];
            _dword.%B0 := refAxoUrRobotics_T2O_TCP^[63];
            Inputs.Inputs.TCP.Torque.X := TO_REAL(_dword);  

            _dword.%B3 := refAxoUrRobotics_T2O_TCP^[64];
            _dword.%B2 := refAxoUrRobotics_T2O_TCP^[65];
            _dword.%B1 := refAxoUrRobotics_T2O_TCP^[66];
            _dword.%B0 := refAxoUrRobotics_T2O_TCP^[67];
            Inputs.Inputs.TCP.Torque.Y := TO_REAL(_dword);  

            _dword.%B3 := refAxoUrRobotics_T2O_TCP^[68];
            _dword.%B2 := refAxoUrRobotics_T2O_TCP^[69];
            _dword.%B1 := refAxoUrRobotics_T2O_TCP^[70];
            _dword.%B0 := refAxoUrRobotics_T2O_TCP^[71];
            Inputs.Inputs.TCP.Torque.Z := TO_REAL(_dword);  

            _dword.%B3 := refAxoUrRobotics_T2O_TCP^[72];
            _dword.%B2 := refAxoUrRobotics_T2O_TCP^[73];
            _dword.%B1 := refAxoUrRobotics_T2O_TCP^[74];
            _dword.%B0 := refAxoUrRobotics_T2O_TCP^[75];
            Inputs.Inputs.TCP.TCP_ForceScalar := TO_REAL(_dword);  

            //INPUTS T20 BITS => st_URO_CB3_T2OBitRegsData
            Inputs.Inputs.Bits.Register_0  := refAxoUrRobotics_T2O_General_Purpose_Bit_Registers^[0].%X0;
            Inputs.Inputs.Bits.Register_1  := refAxoUrRobotics_T2O_General_Purpose_Bit_Registers^[0].%X1;
            Inputs.Inputs.Bits.Register_2  := refAxoUrRobotics_T2O_General_Purpose_Bit_Registers^[0].%X2;
            Inputs.Inputs.Bits.Register_3  := refAxoUrRobotics_T2O_General_Purpose_Bit_Registers^[0].%X3;
            Inputs.Inputs.Bits.Register_4  := refAxoUrRobotics_T2O_General_Purpose_Bit_Registers^[0].%X4;
            Inputs.Inputs.Bits.Register_5  := refAxoUrRobotics_T2O_General_Purpose_Bit_Registers^[0].%X5;
            Inputs.Inputs.Bits.Register_6  := refAxoUrRobotics_T2O_General_Purpose_Bit_Registers^[0].%X6;
            Inputs.Inputs.Bits.Register_7  := refAxoUrRobotics_T2O_General_Purpose_Bit_Registers^[0].%X7;

            Inputs.Inputs.Bits.Register_8  := refAxoUrRobotics_T2O_General_Purpose_Bit_Registers^[1].%X0;
            Inputs.Inputs.Bits.Register_9  := refAxoUrRobotics_T2O_General_Purpose_Bit_Registers^[1].%X1;
            Inputs.Inputs.Bits.Register_10 := refAxoUrRobotics_T2O_General_Purpose_Bit_Registers^[1].%X2;
            Inputs.Inputs.Bits.Register_11 := refAxoUrRobotics_T2O_General_Purpose_Bit_Registers^[1].%X3;
            Inputs.Inputs.Bits.Register_12 := refAxoUrRobotics_T2O_General_Purpose_Bit_Registers^[1].%X4;
            Inputs.Inputs.Bits.Register_13 := refAxoUrRobotics_T2O_General_Purpose_Bit_Registers^[1].%X5;
            Inputs.Inputs.Bits.Register_14 := refAxoUrRobotics_T2O_General_Purpose_Bit_Registers^[1].%X6;
            Inputs.Inputs.Bits.Register_15 := refAxoUrRobotics_T2O_General_Purpose_Bit_Registers^[1].%X7;

            Inputs.Inputs.Bits.Register_16 := refAxoUrRobotics_T2O_General_Purpose_Bit_Registers^[2].%X0;
            Inputs.Inputs.Bits.Register_17 := refAxoUrRobotics_T2O_General_Purpose_Bit_Registers^[2].%X1;
            Inputs.Inputs.Bits.Register_18 := refAxoUrRobotics_T2O_General_Purpose_Bit_Registers^[2].%X2;
            Inputs.Inputs.Bits.Register_19 := refAxoUrRobotics_T2O_General_Purpose_Bit_Registers^[2].%X3;
            Inputs.Inputs.Bits.Register_20 := refAxoUrRobotics_T2O_General_Purpose_Bit_Registers^[2].%X4;
            Inputs.Inputs.Bits.Register_21 := refAxoUrRobotics_T2O_General_Purpose_Bit_Registers^[2].%X5;
            Inputs.Inputs.Bits.Register_22 := refAxoUrRobotics_T2O_General_Purpose_Bit_Registers^[2].%X6;
            Inputs.Inputs.Bits.Register_23 := refAxoUrRobotics_T2O_General_Purpose_Bit_Registers^[2].%X7;

            Inputs.Inputs.Bits.Register_24 := refAxoUrRobotics_T2O_General_Purpose_Bit_Registers^[3].%X0;
            Inputs.Inputs.Bits.Register_25 := refAxoUrRobotics_T2O_General_Purpose_Bit_Registers^[3].%X1;
            Inputs.Inputs.Bits.Register_26 := refAxoUrRobotics_T2O_General_Purpose_Bit_Registers^[3].%X2;
            Inputs.Inputs.Bits.Register_27 := refAxoUrRobotics_T2O_General_Purpose_Bit_Registers^[3].%X3;
            Inputs.Inputs.Bits.Register_28 := refAxoUrRobotics_T2O_General_Purpose_Bit_Registers^[3].%X4;
            Inputs.Inputs.Bits.Register_29 := refAxoUrRobotics_T2O_General_Purpose_Bit_Registers^[3].%X5;
            Inputs.Inputs.Bits.Register_30 := refAxoUrRobotics_T2O_General_Purpose_Bit_Registers^[3].%X6;
            Inputs.Inputs.Bits.Register_31 := refAxoUrRobotics_T2O_General_Purpose_Bit_Registers^[3].%X7;
            
            Inputs.Inputs.Bits.Register_32 := refAxoUrRobotics_T2O_General_Purpose_Bit_Registers^[4].%X0;
            Inputs.Inputs.Bits.Register_33 := refAxoUrRobotics_T2O_General_Purpose_Bit_Registers^[4].%X1;
            Inputs.Inputs.Bits.Register_34 := refAxoUrRobotics_T2O_General_Purpose_Bit_Registers^[4].%X2;
            Inputs.Inputs.Bits.Register_35 := refAxoUrRobotics_T2O_General_Purpose_Bit_Registers^[4].%X3;
            Inputs.Inputs.Bits.Register_36 := refAxoUrRobotics_T2O_General_Purpose_Bit_Registers^[4].%X4;
            Inputs.Inputs.Bits.Register_37 := refAxoUrRobotics_T2O_General_Purpose_Bit_Registers^[4].%X5;
            Inputs.Inputs.Bits.Register_38 := refAxoUrRobotics_T2O_General_Purpose_Bit_Registers^[4].%X6;
            Inputs.Inputs.Bits.Register_39 := refAxoUrRobotics_T2O_General_Purpose_Bit_Registers^[4].%X7;

            Inputs.Inputs.Bits.Register_40 := refAxoUrRobotics_T2O_General_Purpose_Bit_Registers^[5].%X0;
            Inputs.Inputs.Bits.Register_41 := refAxoUrRobotics_T2O_General_Purpose_Bit_Registers^[5].%X1;
            Inputs.Inputs.Bits.Register_42 := refAxoUrRobotics_T2O_General_Purpose_Bit_Registers^[5].%X2;
            Inputs.Inputs.Bits.Register_43 := refAxoUrRobotics_T2O_General_Purpose_Bit_Registers^[5].%X3;
            Inputs.Inputs.Bits.Register_44 := refAxoUrRobotics_T2O_General_Purpose_Bit_Registers^[5].%X4;
            Inputs.Inputs.Bits.Register_45 := refAxoUrRobotics_T2O_General_Purpose_Bit_Registers^[5].%X5;
            Inputs.Inputs.Bits.Register_46 := refAxoUrRobotics_T2O_General_Purpose_Bit_Registers^[5].%X6;
            Inputs.Inputs.Bits.Register_47 := refAxoUrRobotics_T2O_General_Purpose_Bit_Registers^[5].%X7;

            Inputs.Inputs.Bits.Register_48 := refAxoUrRobotics_T2O_General_Purpose_Bit_Registers^[6].%X0;
            Inputs.Inputs.Bits.Register_49 := refAxoUrRobotics_T2O_General_Purpose_Bit_Registers^[6].%X1;
            Inputs.Inputs.Bits.Register_50 := refAxoUrRobotics_T2O_General_Purpose_Bit_Registers^[6].%X2;
            Inputs.Inputs.Bits.Register_51 := refAxoUrRobotics_T2O_General_Purpose_Bit_Registers^[6].%X3;
            Inputs.Inputs.Bits.Register_52 := refAxoUrRobotics_T2O_General_Purpose_Bit_Registers^[6].%X4;
            Inputs.Inputs.Bits.Register_53 := refAxoUrRobotics_T2O_General_Purpose_Bit_Registers^[6].%X5;
            Inputs.Inputs.Bits.Register_54 := refAxoUrRobotics_T2O_General_Purpose_Bit_Registers^[6].%X6;
            Inputs.Inputs.Bits.Register_55 := refAxoUrRobotics_T2O_General_Purpose_Bit_Registers^[6].%X7;

            Inputs.Inputs.Bits.Register_56 := refAxoUrRobotics_T2O_General_Purpose_Bit_Registers^[7].%X0;
            Inputs.Inputs.Bits.Register_57 := refAxoUrRobotics_T2O_General_Purpose_Bit_Registers^[7].%X1;
            Inputs.Inputs.Bits.Register_58 := refAxoUrRobotics_T2O_General_Purpose_Bit_Registers^[7].%X2;
            Inputs.Inputs.Bits.Register_59 := refAxoUrRobotics_T2O_General_Purpose_Bit_Registers^[7].%X3;
            Inputs.Inputs.Bits.Register_60 := refAxoUrRobotics_T2O_General_Purpose_Bit_Registers^[7].%X4;
            Inputs.Inputs.Bits.Register_61 := refAxoUrRobotics_T2O_General_Purpose_Bit_Registers^[7].%X5;
            Inputs.Inputs.Bits.Register_62 := refAxoUrRobotics_T2O_General_Purpose_Bit_Registers^[7].%X6;
            Inputs.Inputs.Bits.Register_63 := refAxoUrRobotics_T2O_General_Purpose_Bit_Registers^[7].%X7;

            //INPUTS T20 BITS => st_URO_CB3_T2OIntRegsData
            _dword.%B3 := refAxoUrRobotics_T2O_General_Purpose_Int_Registers^[0];
            _dword.%B2 := refAxoUrRobotics_T2O_General_Purpose_Int_Registers^[1];
            _dword.%B1 := refAxoUrRobotics_T2O_General_Purpose_Int_Registers^[2];
            _dword.%B0 := refAxoUrRobotics_T2O_General_Purpose_Int_Registers^[3];
            Inputs.Inputs.Ints.Register_0 := TO_DINT(_dword);

            _dword.%B3 := refAxoUrRobotics_T2O_General_Purpose_Int_Registers^[4];
            _dword.%B2 := refAxoUrRobotics_T2O_General_Purpose_Int_Registers^[5];
            _dword.%B1 := refAxoUrRobotics_T2O_General_Purpose_Int_Registers^[6];
            _dword.%B0 := refAxoUrRobotics_T2O_General_Purpose_Int_Registers^[7];
            Inputs.Inputs.Ints.Register_1 := TO_DINT(_dword);

            _dword.%B3 := refAxoUrRobotics_T2O_General_Purpose_Int_Registers^[8];
            _dword.%B2 := refAxoUrRobotics_T2O_General_Purpose_Int_Registers^[9];
            _dword.%B1 := refAxoUrRobotics_T2O_General_Purpose_Int_Registers^[10];
            _dword.%B0 := refAxoUrRobotics_T2O_General_Purpose_Int_Registers^[11];
            Inputs.Inputs.Ints.Register_2 := TO_DINT(_dword);

            _dword.%B3 := refAxoUrRobotics_T2O_General_Purpose_Int_Registers^[12];
            _dword.%B2 := refAxoUrRobotics_T2O_General_Purpose_Int_Registers^[13];
            _dword.%B1 := refAxoUrRobotics_T2O_General_Purpose_Int_Registers^[14];
            _dword.%B0 := refAxoUrRobotics_T2O_General_Purpose_Int_Registers^[15];
            Inputs.Inputs.Ints.Register_3 := TO_DINT(_dword);

            _dword.%B3 := refAxoUrRobotics_T2O_General_Purpose_Int_Registers^[16];
            _dword.%B2 := refAxoUrRobotics_T2O_General_Purpose_Int_Registers^[17];
            _dword.%B1 := refAxoUrRobotics_T2O_General_Purpose_Int_Registers^[18];
            _dword.%B0 := refAxoUrRobotics_T2O_General_Purpose_Int_Registers^[19];
            Inputs.Inputs.Ints.Register_4 := TO_DINT(_dword);

            _dword.%B3 := refAxoUrRobotics_T2O_General_Purpose_Int_Registers^[20];
            _dword.%B2 := refAxoUrRobotics_T2O_General_Purpose_Int_Registers^[21];
            _dword.%B1 := refAxoUrRobotics_T2O_General_Purpose_Int_Registers^[22];
            _dword.%B0 := refAxoUrRobotics_T2O_General_Purpose_Int_Registers^[23];
            Inputs.Inputs.Ints.Register_5 := TO_DINT(_dword);

            _dword.%B3 := refAxoUrRobotics_T2O_General_Purpose_Int_Registers^[24];
            _dword.%B2 := refAxoUrRobotics_T2O_General_Purpose_Int_Registers^[25];
            _dword.%B1 := refAxoUrRobotics_T2O_General_Purpose_Int_Registers^[26];
            _dword.%B0 := refAxoUrRobotics_T2O_General_Purpose_Int_Registers^[27];
            Inputs.Inputs.Ints.Register_6 := TO_DINT(_dword);

            _dword.%B3 := refAxoUrRobotics_T2O_General_Purpose_Int_Registers^[28];
            _dword.%B2 := refAxoUrRobotics_T2O_General_Purpose_Int_Registers^[29];
            _dword.%B1 := refAxoUrRobotics_T2O_General_Purpose_Int_Registers^[30];
            _dword.%B0 := refAxoUrRobotics_T2O_General_Purpose_Int_Registers^[31];
            Inputs.Inputs.Ints.Register_7 := TO_DINT(_dword);

            _dword.%B3 := refAxoUrRobotics_T2O_General_Purpose_Int_Registers^[32];
            _dword.%B2 := refAxoUrRobotics_T2O_General_Purpose_Int_Registers^[33];
            _dword.%B1 := refAxoUrRobotics_T2O_General_Purpose_Int_Registers^[34];
            _dword.%B0 := refAxoUrRobotics_T2O_General_Purpose_Int_Registers^[35];
            Inputs.Inputs.Ints.Register_8 := TO_DINT(_dword);

            _dword.%B3 := refAxoUrRobotics_T2O_General_Purpose_Int_Registers^[36];
            _dword.%B2 := refAxoUrRobotics_T2O_General_Purpose_Int_Registers^[37];
            _dword.%B1 := refAxoUrRobotics_T2O_General_Purpose_Int_Registers^[38];
            _dword.%B0 := refAxoUrRobotics_T2O_General_Purpose_Int_Registers^[39];
            Inputs.Inputs.Ints.Register_9 := TO_DINT(_dword);

            _dword.%B3 := refAxoUrRobotics_T2O_General_Purpose_Int_Registers^[40];
            _dword.%B2 := refAxoUrRobotics_T2O_General_Purpose_Int_Registers^[41];
            _dword.%B1 := refAxoUrRobotics_T2O_General_Purpose_Int_Registers^[42];
            _dword.%B0 := refAxoUrRobotics_T2O_General_Purpose_Int_Registers^[43];
            Inputs.Inputs.Ints.Register_10 := TO_DINT(_dword);

            _dword.%B3 := refAxoUrRobotics_T2O_General_Purpose_Int_Registers^[44];
            _dword.%B2 := refAxoUrRobotics_T2O_General_Purpose_Int_Registers^[45];
            _dword.%B1 := refAxoUrRobotics_T2O_General_Purpose_Int_Registers^[46];
            _dword.%B0 := refAxoUrRobotics_T2O_General_Purpose_Int_Registers^[47];
            Inputs.Inputs.Ints.Register_11 := TO_DINT(_dword);

            _dword.%B3 := refAxoUrRobotics_T2O_General_Purpose_Int_Registers^[48];
            _dword.%B2 := refAxoUrRobotics_T2O_General_Purpose_Int_Registers^[49];
            _dword.%B1 := refAxoUrRobotics_T2O_General_Purpose_Int_Registers^[50];
            _dword.%B0 := refAxoUrRobotics_T2O_General_Purpose_Int_Registers^[51];
            Inputs.Inputs.Ints.Register_12 := TO_DINT(_dword);

            _dword.%B3 := refAxoUrRobotics_T2O_General_Purpose_Int_Registers^[52];
            _dword.%B2 := refAxoUrRobotics_T2O_General_Purpose_Int_Registers^[53];
            _dword.%B1 := refAxoUrRobotics_T2O_General_Purpose_Int_Registers^[54];
            _dword.%B0 := refAxoUrRobotics_T2O_General_Purpose_Int_Registers^[55];
            Inputs.Inputs.Ints.Register_13 := TO_DINT(_dword);

            _dword.%B3 := refAxoUrRobotics_T2O_General_Purpose_Int_Registers^[56];
            _dword.%B2 := refAxoUrRobotics_T2O_General_Purpose_Int_Registers^[57];
            _dword.%B1 := refAxoUrRobotics_T2O_General_Purpose_Int_Registers^[58];
            _dword.%B0 := refAxoUrRobotics_T2O_General_Purpose_Int_Registers^[59];
            Inputs.Inputs.Ints.Register_14 := TO_DINT(_dword);

            _dword.%B3 := refAxoUrRobotics_T2O_General_Purpose_Int_Registers^[60];
            _dword.%B2 := refAxoUrRobotics_T2O_General_Purpose_Int_Registers^[61];
            _dword.%B1 := refAxoUrRobotics_T2O_General_Purpose_Int_Registers^[62];
            _dword.%B0 := refAxoUrRobotics_T2O_General_Purpose_Int_Registers^[63];
            Inputs.Inputs.Ints.Register_15 := TO_DINT(_dword);

            _dword.%B3 := refAxoUrRobotics_T2O_General_Purpose_Int_Registers^[64];
            _dword.%B2 := refAxoUrRobotics_T2O_General_Purpose_Int_Registers^[65];
            _dword.%B1 := refAxoUrRobotics_T2O_General_Purpose_Int_Registers^[66];
            _dword.%B0 := refAxoUrRobotics_T2O_General_Purpose_Int_Registers^[67];
            Inputs.Inputs.Ints.Register_16 := TO_DINT(_dword);

            _dword.%B3 := refAxoUrRobotics_T2O_General_Purpose_Int_Registers^[68];
            _dword.%B2 := refAxoUrRobotics_T2O_General_Purpose_Int_Registers^[69];
            _dword.%B1 := refAxoUrRobotics_T2O_General_Purpose_Int_Registers^[70];
            _dword.%B0 := refAxoUrRobotics_T2O_General_Purpose_Int_Registers^[71];
            Inputs.Inputs.Ints.Register_17 := TO_DINT(_dword);

            _dword.%B3 := refAxoUrRobotics_T2O_General_Purpose_Int_Registers^[72];
            _dword.%B2 := refAxoUrRobotics_T2O_General_Purpose_Int_Registers^[73];
            _dword.%B1 := refAxoUrRobotics_T2O_General_Purpose_Int_Registers^[74];
            _dword.%B0 := refAxoUrRobotics_T2O_General_Purpose_Int_Registers^[75];
            Inputs.Inputs.Ints.Register_18 := TO_DINT(_dword);

            _dword.%B3 := refAxoUrRobotics_T2O_General_Purpose_Int_Registers^[76];
            _dword.%B2 := refAxoUrRobotics_T2O_General_Purpose_Int_Registers^[77];
            _dword.%B1 := refAxoUrRobotics_T2O_General_Purpose_Int_Registers^[78];
            _dword.%B0 := refAxoUrRobotics_T2O_General_Purpose_Int_Registers^[79];
            Inputs.Inputs.Ints.Register_19 := TO_DINT(_dword);

            _dword.%B3 := refAxoUrRobotics_T2O_General_Purpose_Int_Registers^[80];
            _dword.%B2 := refAxoUrRobotics_T2O_General_Purpose_Int_Registers^[81];
            _dword.%B1 := refAxoUrRobotics_T2O_General_Purpose_Int_Registers^[82];
            _dword.%B0 := refAxoUrRobotics_T2O_General_Purpose_Int_Registers^[83];
            Inputs.Inputs.Ints.Register_20 := TO_DINT(_dword);

            _dword.%B3 := refAxoUrRobotics_T2O_General_Purpose_Int_Registers^[84];
            _dword.%B2 := refAxoUrRobotics_T2O_General_Purpose_Int_Registers^[85];
            _dword.%B1 := refAxoUrRobotics_T2O_General_Purpose_Int_Registers^[86];
            _dword.%B0 := refAxoUrRobotics_T2O_General_Purpose_Int_Registers^[87];
            Inputs.Inputs.Ints.Register_21 := TO_DINT(_dword);

            _dword.%B3 := refAxoUrRobotics_T2O_General_Purpose_Int_Registers^[88];
            _dword.%B2 := refAxoUrRobotics_T2O_General_Purpose_Int_Registers^[89];
            _dword.%B1 := refAxoUrRobotics_T2O_General_Purpose_Int_Registers^[90];
            _dword.%B0 := refAxoUrRobotics_T2O_General_Purpose_Int_Registers^[91];
            Inputs.Inputs.Ints.Register_22 := TO_DINT(_dword);

            _dword.%B3 := refAxoUrRobotics_T2O_General_Purpose_Int_Registers^[92];
            _dword.%B2 := refAxoUrRobotics_T2O_General_Purpose_Int_Registers^[93];
            _dword.%B1 := refAxoUrRobotics_T2O_General_Purpose_Int_Registers^[94];
            _dword.%B0 := refAxoUrRobotics_T2O_General_Purpose_Int_Registers^[95];
            Inputs.Inputs.Ints.Register_23 := TO_DINT(_dword);

            //INPUTS T20 BITS => st_URO_CB3_T2OFloatRegsData
            _dword.%B3 := refAxoUrRobotics_T2O_General_Purpose_Float_Registers^[0];
            _dword.%B2 := refAxoUrRobotics_T2O_General_Purpose_Float_Registers^[1];
            _dword.%B1 := refAxoUrRobotics_T2O_General_Purpose_Float_Registers^[2];
            _dword.%B0 := refAxoUrRobotics_T2O_General_Purpose_Float_Registers^[3];
            Inputs.Inputs.Floats.Register_0 := TO_REAL(_dword);

            _dword.%B3 := refAxoUrRobotics_T2O_General_Purpose_Float_Registers^[4];
            _dword.%B2 := refAxoUrRobotics_T2O_General_Purpose_Float_Registers^[5];
            _dword.%B1 := refAxoUrRobotics_T2O_General_Purpose_Float_Registers^[6];
            _dword.%B0 := refAxoUrRobotics_T2O_General_Purpose_Float_Registers^[7];
            Inputs.Inputs.Floats.Register_1 := TO_REAL(_dword);

            _dword.%B3 := refAxoUrRobotics_T2O_General_Purpose_Float_Registers^[8];
            _dword.%B2 := refAxoUrRobotics_T2O_General_Purpose_Float_Registers^[9];
            _dword.%B1 := refAxoUrRobotics_T2O_General_Purpose_Float_Registers^[10];
            _dword.%B0 := refAxoUrRobotics_T2O_General_Purpose_Float_Registers^[11];
            Inputs.Inputs.Floats.Register_2 := TO_REAL(_dword);

            _dword.%B3 := refAxoUrRobotics_T2O_General_Purpose_Float_Registers^[12];
            _dword.%B2 := refAxoUrRobotics_T2O_General_Purpose_Float_Registers^[13];
            _dword.%B1 := refAxoUrRobotics_T2O_General_Purpose_Float_Registers^[14];
            _dword.%B0 := refAxoUrRobotics_T2O_General_Purpose_Float_Registers^[15];
            Inputs.Inputs.Floats.Register_3 := TO_REAL(_dword);

            _dword.%B3 := refAxoUrRobotics_T2O_General_Purpose_Float_Registers^[16];
            _dword.%B2 := refAxoUrRobotics_T2O_General_Purpose_Float_Registers^[17];
            _dword.%B1 := refAxoUrRobotics_T2O_General_Purpose_Float_Registers^[18];
            _dword.%B0 := refAxoUrRobotics_T2O_General_Purpose_Float_Registers^[19];
            Inputs.Inputs.Floats.Register_4 := TO_REAL(_dword);

            _dword.%B3 := refAxoUrRobotics_T2O_General_Purpose_Float_Registers^[20];
            _dword.%B2 := refAxoUrRobotics_T2O_General_Purpose_Float_Registers^[21];
            _dword.%B1 := refAxoUrRobotics_T2O_General_Purpose_Float_Registers^[22];
            _dword.%B0 := refAxoUrRobotics_T2O_General_Purpose_Float_Registers^[23];
            Inputs.Inputs.Floats.Register_5 := TO_REAL(_dword);

            _dword.%B3 := refAxoUrRobotics_T2O_General_Purpose_Float_Registers^[24];
            _dword.%B2 := refAxoUrRobotics_T2O_General_Purpose_Float_Registers^[25];
            _dword.%B1 := refAxoUrRobotics_T2O_General_Purpose_Float_Registers^[26];
            _dword.%B0 := refAxoUrRobotics_T2O_General_Purpose_Float_Registers^[27];
            Inputs.Inputs.Floats.Register_6 := TO_REAL(_dword);

            _dword.%B3 := refAxoUrRobotics_T2O_General_Purpose_Float_Registers^[28];
            _dword.%B2 := refAxoUrRobotics_T2O_General_Purpose_Float_Registers^[29];
            _dword.%B1 := refAxoUrRobotics_T2O_General_Purpose_Float_Registers^[30];
            _dword.%B0 := refAxoUrRobotics_T2O_General_Purpose_Float_Registers^[31];
            Inputs.Inputs.Floats.Register_7 := TO_REAL(_dword);

            _dword.%B3 := refAxoUrRobotics_T2O_General_Purpose_Float_Registers^[32];
            _dword.%B2 := refAxoUrRobotics_T2O_General_Purpose_Float_Registers^[33];
            _dword.%B1 := refAxoUrRobotics_T2O_General_Purpose_Float_Registers^[34];
            _dword.%B0 := refAxoUrRobotics_T2O_General_Purpose_Float_Registers^[35];
            Inputs.Inputs.Floats.Register_8 := TO_REAL(_dword);

            _dword.%B3 := refAxoUrRobotics_T2O_General_Purpose_Float_Registers^[36];
            _dword.%B2 := refAxoUrRobotics_T2O_General_Purpose_Float_Registers^[37];
            _dword.%B1 := refAxoUrRobotics_T2O_General_Purpose_Float_Registers^[38];
            _dword.%B0 := refAxoUrRobotics_T2O_General_Purpose_Float_Registers^[39];
            Inputs.Inputs.Floats.Register_9 := TO_REAL(_dword);

            _dword.%B3 := refAxoUrRobotics_T2O_General_Purpose_Float_Registers^[40];
            _dword.%B2 := refAxoUrRobotics_T2O_General_Purpose_Float_Registers^[41];
            _dword.%B1 := refAxoUrRobotics_T2O_General_Purpose_Float_Registers^[42];
            _dword.%B0 := refAxoUrRobotics_T2O_General_Purpose_Float_Registers^[43];
            Inputs.Inputs.Floats.Register_10 := TO_REAL(_dword);

            _dword.%B3 := refAxoUrRobotics_T2O_General_Purpose_Float_Registers^[44];
            _dword.%B2 := refAxoUrRobotics_T2O_General_Purpose_Float_Registers^[45];
            _dword.%B1 := refAxoUrRobotics_T2O_General_Purpose_Float_Registers^[46];
            _dword.%B0 := refAxoUrRobotics_T2O_General_Purpose_Float_Registers^[47];
            Inputs.Inputs.Floats.Register_11 := TO_REAL(_dword);

            _dword.%B3 := refAxoUrRobotics_T2O_General_Purpose_Float_Registers^[48];
            _dword.%B2 := refAxoUrRobotics_T2O_General_Purpose_Float_Registers^[49];
            _dword.%B1 := refAxoUrRobotics_T2O_General_Purpose_Float_Registers^[50];
            _dword.%B0 := refAxoUrRobotics_T2O_General_Purpose_Float_Registers^[51];
            Inputs.Inputs.Floats.Register_12 := TO_REAL(_dword);

            _dword.%B3 := refAxoUrRobotics_T2O_General_Purpose_Float_Registers^[52];
            _dword.%B2 := refAxoUrRobotics_T2O_General_Purpose_Float_Registers^[53];
            _dword.%B1 := refAxoUrRobotics_T2O_General_Purpose_Float_Registers^[54];
            _dword.%B0 := refAxoUrRobotics_T2O_General_Purpose_Float_Registers^[55];
            Inputs.Inputs.Floats.Register_13 := TO_REAL(_dword);

            _dword.%B3 := refAxoUrRobotics_T2O_General_Purpose_Float_Registers^[56];
            _dword.%B2 := refAxoUrRobotics_T2O_General_Purpose_Float_Registers^[57];
            _dword.%B1 := refAxoUrRobotics_T2O_General_Purpose_Float_Registers^[58];
            _dword.%B0 := refAxoUrRobotics_T2O_General_Purpose_Float_Registers^[59];
            Inputs.Inputs.Floats.Register_14 := TO_REAL(_dword);

            _dword.%B3 := refAxoUrRobotics_T2O_General_Purpose_Float_Registers^[60];
            _dword.%B2 := refAxoUrRobotics_T2O_General_Purpose_Float_Registers^[61];
            _dword.%B1 := refAxoUrRobotics_T2O_General_Purpose_Float_Registers^[62];
            _dword.%B0 := refAxoUrRobotics_T2O_General_Purpose_Float_Registers^[63];
            Inputs.Inputs.Floats.Register_15 := TO_REAL(_dword);

            _dword.%B3 := refAxoUrRobotics_T2O_General_Purpose_Float_Registers^[64];
            _dword.%B2 := refAxoUrRobotics_T2O_General_Purpose_Float_Registers^[65];
            _dword.%B1 := refAxoUrRobotics_T2O_General_Purpose_Float_Registers^[66];
            _dword.%B0 := refAxoUrRobotics_T2O_General_Purpose_Float_Registers^[67];
            Inputs.Inputs.Floats.Register_16 := TO_REAL(_dword);

            _dword.%B3 := refAxoUrRobotics_T2O_General_Purpose_Float_Registers^[68];
            _dword.%B2 := refAxoUrRobotics_T2O_General_Purpose_Float_Registers^[69];
            _dword.%B1 := refAxoUrRobotics_T2O_General_Purpose_Float_Registers^[70];
            _dword.%B0 := refAxoUrRobotics_T2O_General_Purpose_Float_Registers^[71];
            Inputs.Inputs.Floats.Register_17 := TO_REAL(_dword);

            _dword.%B3 := refAxoUrRobotics_T2O_General_Purpose_Float_Registers^[72];
            _dword.%B2 := refAxoUrRobotics_T2O_General_Purpose_Float_Registers^[73];
            _dword.%B1 := refAxoUrRobotics_T2O_General_Purpose_Float_Registers^[74];
            _dword.%B0 := refAxoUrRobotics_T2O_General_Purpose_Float_Registers^[75];
            Inputs.Inputs.Floats.Register_18 := TO_REAL(_dword);

            _dword.%B3 := refAxoUrRobotics_T2O_General_Purpose_Float_Registers^[76];
            _dword.%B2 := refAxoUrRobotics_T2O_General_Purpose_Float_Registers^[77];
            _dword.%B1 := refAxoUrRobotics_T2O_General_Purpose_Float_Registers^[78];
            _dword.%B0 := refAxoUrRobotics_T2O_General_Purpose_Float_Registers^[79];
            Inputs.Inputs.Floats.Register_19 := TO_REAL(_dword);

            _dword.%B3 := refAxoUrRobotics_T2O_General_Purpose_Float_Registers^[80];
            _dword.%B2 := refAxoUrRobotics_T2O_General_Purpose_Float_Registers^[81];
            _dword.%B1 := refAxoUrRobotics_T2O_General_Purpose_Float_Registers^[82];
            _dword.%B0 := refAxoUrRobotics_T2O_General_Purpose_Float_Registers^[83];
            Inputs.Inputs.Floats.Register_20 := TO_REAL(_dword);

            _dword.%B3 := refAxoUrRobotics_T2O_General_Purpose_Float_Registers^[84];
            _dword.%B2 := refAxoUrRobotics_T2O_General_Purpose_Float_Registers^[85];
            _dword.%B1 := refAxoUrRobotics_T2O_General_Purpose_Float_Registers^[86];
            _dword.%B0 := refAxoUrRobotics_T2O_General_Purpose_Float_Registers^[87];
            Inputs.Inputs.Floats.Register_21 := TO_REAL(_dword);

            _dword.%B3 := refAxoUrRobotics_T2O_General_Purpose_Float_Registers^[88];
            _dword.%B2 := refAxoUrRobotics_T2O_General_Purpose_Float_Registers^[89];
            _dword.%B1 := refAxoUrRobotics_T2O_General_Purpose_Float_Registers^[90];
            _dword.%B0 := refAxoUrRobotics_T2O_General_Purpose_Float_Registers^[91];
            Inputs.Inputs.Floats.Register_22 := TO_REAL(_dword);

            _dword.%B3 := refAxoUrRobotics_T2O_General_Purpose_Float_Registers^[92];
            _dword.%B2 := refAxoUrRobotics_T2O_General_Purpose_Float_Registers^[93];
            _dword.%B1 := refAxoUrRobotics_T2O_General_Purpose_Float_Registers^[94];
            _dword.%B0 := refAxoUrRobotics_T2O_General_Purpose_Float_Registers^[95];
            Inputs.Inputs.Floats.Register_23 := TO_REAL(_dword);


             Inputs.RobotMode := THIS.GetRobotModeDescription(Inputs.Inputs.Robot.RobotMode);
            //SYSTEM INPUTS
            //Area/positions flags this  should be obsolete because Zones and InPosition is used as byte below
            Inputs.InArea_1     := Inputs.Inputs.Bits.Register_0;
            Inputs.InArea_2     := Inputs.Inputs.Bits.Register_1;
            Inputs.InArea_3     := Inputs.Inputs.Bits.Register_2;
            Inputs.InArea_4     := Inputs.Inputs.Bits.Register_3;
            Inputs.InPosition_1 := Inputs.Inputs.Bits.Register_4;
            Inputs.InPosition_2 := Inputs.Inputs.Bits.Register_5;
            Inputs.InPosition_3 := Inputs.Inputs.Bits.Register_6;
            Inputs.InPosition_4 := Inputs.Inputs.Bits.Register_7;
            
            //Tool signals

            Inputs.Tool_1_Retract   := Inputs.Inputs.Bits.Register_8;
            Inputs.Tool_1_Extend    := Inputs.Inputs.Bits.Register_9;
            Inputs.Tool_2_Retract   := Inputs.Inputs.Bits.Register_10;
            Inputs.Tool_2_Extend    := Inputs.Inputs.Bits.Register_11;
            Inputs.Tool_3_Retract   := Inputs.Inputs.Bits.Register_12;
            Inputs.Tool_3_Extend    := Inputs.Inputs.Bits.Register_13;
            Inputs.Tool_4_Retract   := Inputs.Inputs.Bits.Register_14;
            Inputs.Tool_4_Extend    := Inputs.Inputs.Bits.Register_15;

            Inputs.Zone := Inputs.Inputs.Ints.Register_0;
            Inputs.InPosition := Inputs.Inputs.Ints.Register_1;

           //Movement parameters
            Inputs.ActionNo := Inputs.Inputs.Ints.Register_2;;
            Inputs.GlobalSpeed := Inputs.Inputs.Ints.Register_3;
            Inputs.ToolNo := Inputs.Inputs.Ints.Register_4;
            Inputs.WorkobjectNo := Inputs.Inputs.Ints.Register_5;
            Inputs.PointNo := Inputs.Inputs.Ints.Register_6;

            Inputs.UserSpecSpeed1 := Inputs.Inputs.Floats.Register_0;
            Inputs.UserSpecSpeed2 := Inputs.Inputs.Floats.Register_1;
            Inputs.Coordinates.X  := Inputs.Inputs.Floats.Register_2;
            Inputs.Coordinates.Y  := Inputs.Inputs.Floats.Register_3;
            Inputs.Coordinates.Z  := Inputs.Inputs.Floats.Register_4;
            Inputs.Coordinates.Rx := Inputs.Inputs.Floats.Register_5;
            Inputs.Coordinates.Ry := Inputs.Inputs.Floats.Register_6;
            Inputs.Coordinates.Rz := Inputs.Inputs.Floats.Register_7;

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
                        _progress:=301;                    
                    END_IF;
                END_IF;

                IF _progress = 301 THEN  
                    Outputs.Start :=   _blink.output;     

                    IF _infoTimer.output THEN
                        IF NOT Inputs.Inputs.Robot.PR_IsProgramRunning THEN
                            RobotStatus.Error.Id := UINT#602;
                        END_IF;
                    END_IF;

                    IF Inputs.Inputs.Robot.PR_IsProgramRunning THEN
                        THIS.CallTimers(FALSE);
                        _progress:=302;                    
                    END_IF;
                END_IF;


                IF _progress = 302 THEN  
                    StartAtMainTask.DoneWhen(TRUE);
                    THIS.CallTimers(FALSE);
                    _progress := 0;
                END_IF;

                THIS.CallTimers(TRUE);
                StartAtMainTask.ThrowWhen(_errorTimer.output );
                RobotStatus.Action.Id := TO_UINT(_progress);
            END_IF;
            IF StartAtMainTask.DoneReached() THEN
                RobotStatus.Action.Id :=  UINT#303;
                RobotStatus.Error.Id :=  UINT#0;
            ELSIF StartAtMainTask.ErrorOccured() THEN
                RobotStatus.Action.Id :=  UINT#711;
                RobotStatus.Error.Id  :=  UINT#711;
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
              
                IF _progress = 310 THEN  

                    IF _infoTimer.output THEN
                        IF NOT Inputs.Inputs.Safety.NO_IsNormalMode THEN
                            RobotStatus.Error.Id := UINT#605;
                        END_IF;
                        IF NOT Inputs.Inputs.Safety.RD_IsReducedMode THEN
                            RobotStatus.Error.Id := UINT#606;
                        END_IF;                        
                    END_IF;

                    IF Inputs.Inputs.Safety.NO_IsNormalMode OR Inputs.Inputs.Safety.RD_IsReducedMode THEN
                        THIS.CallTimers(FALSE);
                        _progress:=311;                    
                    END_IF;
                END_IF;

                IF _progress = 311 THEN	//Reseting error
                    IF _infoTimer.output THEN
                        IF Inputs.Inputs.Safety.FT_IsFault THEN
                            RobotStatus.Error.Id := UINT#607;
                        END_IF;
                    END_IF;

                    IF NOT Inputs.Inputs.Safety.FT_IsFault THEN
                        THIS.CallTimers(FALSE);
                        _progress := 312;
                    END_IF;
                END_IF;
              
                IF _progress = 312 THEN	//Reseting emergency stop error
                    IF _infoTimer.output THEN
                        IF Inputs.Inputs.Safety.ES_IsEmergencyStopped  THEN
                            RobotStatus.Error.Id := UINT#608;
                        END_IF;
                        IF Inputs.Inputs.Safety.PS_IsProtectiveStopped  THEN
                            RobotStatus.Error.Id := UINT#609;
                        END_IF;
                        IF Inputs.Inputs.Safety.SS_IsSafeguardStopped  THEN
                            RobotStatus.Error.Id := UINT#610;
                        END_IF;
                        IF Inputs.Inputs.Safety.RC_IsRecoveryMode  THEN
                            RobotStatus.Error.Id := UINT#611;
                        END_IF;
                        IF Inputs.Inputs.Safety.ST_IsStoppedDueSafety  THEN
                            RobotStatus.Error.Id := UINT#612;
                        END_IF;
                        IF Inputs.Inputs.Safety.VL_IsViolation  THEN
                            RobotStatus.Error.Id := UINT#613;
                        END_IF;
                    END_IF;

                    IF NOT Inputs.Inputs.Safety.ES_IsEmergencyStopped 
                        AND NOT Inputs.Inputs.Safety.PS_IsProtectiveStopped  
                        AND NOT Inputs.Inputs.Safety.SS_IsSafeguardStopped  
                        AND NOT Inputs.Inputs.Safety.RC_IsRecoveryMode 
                        AND NOT Inputs.Inputs.Safety.ST_IsStoppedDueSafety 
                        AND NOT Inputs.Inputs.Safety.VL_IsViolation THEN
                        THIS.CallTimers(FALSE);
                        _progress := 313;
                    END_IF;
                END_IF;
              
                IF _progress = 313 THEN	
                    Outputs.MotorOn:=_blink.output;	

                    IF Inputs.Inputs.Safety.FT_IsFault THEN 
                        THIS.CallTimers(FALSE);
                        _progress := 310;
                    END_IF;

                    IF _infoTimer.output THEN
                        IF NOT Inputs.Inputs.Robot.PW_IsPowerOn THEN
                            RobotStatus.Error.Id := UINT#614;
                        END_IF;
                        IF Inputs.Inputs.Safety.FT_IsFault THEN
                            RobotStatus.Error.Id := UINT#615;
                        END_IF;
                    END_IF;

                    IF Inputs.Inputs.Robot.PW_IsPowerOn AND NOT Inputs.Inputs.Safety.FT_IsFault THEN
                         Outputs.MotorOn:=FALSE;
                         THIS.CallTimers(FALSE);
                         _progress := 314;
                    END_IF;
                END_IF;		

                IF _progress = 314 THEN	
                    Outputs.Start:=_blink.output;	

                    IF Inputs.Inputs.Safety.FT_IsFault THEN 
                        THIS.CallTimers(FALSE);
                        _progress := 310;
                    END_IF;

                    IF _infoTimer.output THEN
                        IF NOT Inputs.Inputs.Robot.PR_IsProgramRunning THEN
                            RobotStatus.Error.Id := UINT#616;
                        END_IF;
                        IF Inputs.Inputs.Safety.FT_IsFault THEN
                            RobotStatus.Error.Id := UINT#617;
                        END_IF;
                    END_IF;

                    IF Inputs.Inputs.Robot.PR_IsProgramRunning AND NOT Inputs.Inputs.Safety.FT_IsFault THEN
                         Outputs.Start:=FALSE;
                         THIS.CallTimers(FALSE);
                         _progress := 315;
                    END_IF;
                END_IF;		
              
                IF _progress = 315 THEN	
                    StartMotorsAndProgramTask.DoneWhen(TRUE);
                    THIS.CallTimers(FALSE);
                    _progress := 0;
                END_IF;	              

                THIS.CallTimers(TRUE);
                StartMotorsAndProgramTask.ThrowWhen(_errorTimer.output);
                RobotStatus.Action.Id := TO_UINT(_progress);
            END_IF;
            IF StartMotorsAndProgramTask.DoneReached() THEN
                RobotStatus.Action.Id :=  UINT#316;
                RobotStatus.Error.Id :=  UINT#0;
            ELSIF StartMotorsAndProgramTask.ErrorOccured() THEN
                RobotStatus.Action.Id :=  UINT#712;
                RobotStatus.Error.Id  :=  UINT#712;
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
              
                IF _progress = 320 THEN  

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
                        _progress:=321;                    
                    END_IF;
                END_IF;

                IF _progress = 321 THEN	//Reseting error
                    IF _infoTimer.output THEN
                        IF Inputs.Inputs.Safety.FT_IsFault THEN
                            RobotStatus.Error.Id := UINT#622;
                        END_IF;
                    END_IF;

                    IF NOT Inputs.Inputs.Safety.FT_IsFault THEN
                        THIS.CallTimers(FALSE);
                        _progress := 322;
                    END_IF;
                END_IF;
              
                IF _progress = 322 THEN	//Reseting emergency stop error
                    IF _infoTimer.output THEN
                        IF Inputs.Inputs.Safety.ES_IsEmergencyStopped  THEN
                            RobotStatus.Error.Id := UINT#623;
                        END_IF;
                        IF Inputs.Inputs.Safety.PS_IsProtectiveStopped  THEN
                            RobotStatus.Error.Id := UINT#624;
                        END_IF;
                        IF Inputs.Inputs.Safety.SS_IsSafeguardStopped  THEN
                            RobotStatus.Error.Id := UINT#625;
                        END_IF;
                        IF Inputs.Inputs.Safety.RC_IsRecoveryMode  THEN
                            RobotStatus.Error.Id := UINT#626;
                        END_IF;
                        IF Inputs.Inputs.Safety.ST_IsStoppedDueSafety  THEN
                            RobotStatus.Error.Id := UINT#627;
                        END_IF;
                        IF Inputs.Inputs.Safety.VL_IsViolation  THEN
                            RobotStatus.Error.Id := UINT#628;
                        END_IF;
                    END_IF;

                    IF NOT Inputs.Inputs.Safety.ES_IsEmergencyStopped 
                        AND NOT Inputs.Inputs.Safety.PS_IsProtectiveStopped  
                        AND NOT Inputs.Inputs.Safety.SS_IsSafeguardStopped  
                        AND NOT Inputs.Inputs.Safety.RC_IsRecoveryMode 
                        AND NOT Inputs.Inputs.Safety.ST_IsStoppedDueSafety 
                        AND NOT Inputs.Inputs.Safety.VL_IsViolation THEN
                        THIS.CallTimers(FALSE);
                        _progress := 32;
                    END_IF;
                END_IF;
              
                IF _progress = 323 THEN	//Starting the motors
                    Outputs.MotorOn:=_blink.output;	

                    IF Inputs.Inputs.Safety.FT_IsFault THEN 
                        THIS.CallTimers(FALSE);
                        _progress := 320;
                    END_IF;

                    IF _infoTimer.output THEN
                        IF NOT Inputs.Inputs.Robot.PW_IsPowerOn THEN
                            RobotStatus.Error.Id := UINT#629;
                        END_IF;
                        IF Inputs.Inputs.Safety.FT_IsFault THEN
                            RobotStatus.Error.Id := UINT#630;
                        END_IF;
                    END_IF;

                    IF Inputs.Inputs.Robot.PW_IsPowerOn AND NOT Inputs.Inputs.Safety.FT_IsFault THEN
                         Outputs.MotorOn:=FALSE;
                         THIS.CallTimers(FALSE);
                         _progress := 324;
                    END_IF;
                END_IF;		

                IF _progress = 324 THEN	// Starting the program
                    Outputs.Start:=_blink.output;	

                    IF Inputs.Inputs.Safety.FT_IsFault THEN 
                        THIS.CallTimers(FALSE);
                        _progress := 320;
                    END_IF;

                    IF _infoTimer.output THEN
                        IF NOT Inputs.Inputs.Robot.PR_IsProgramRunning THEN
                            RobotStatus.Error.Id := UINT#631;
                        END_IF;
                        IF Inputs.Inputs.Safety.FT_IsFault THEN
                            RobotStatus.Error.Id := UINT#632;
                        END_IF;
                    END_IF;

                    IF Inputs.Inputs.Robot.PR_IsProgramRunning AND NOT Inputs.Inputs.Safety.FT_IsFault THEN
                         Outputs.Start:=FALSE;
                         THIS.CallTimers(FALSE);
                         _progress := 325;
                    END_IF;
                END_IF;		
	
                IF _progress = 325 THEN // Setting the  movement parameters
                    Outputs.GlobalSpeed     := TO_DINT(RobotStatus.CurrentMovementParameters.GlobalSpeed);
                    Outputs.ToolNo          := TO_DINT(RobotStatus.CurrentMovementParameters.ToolNo);
                    Outputs.WorkobjectNo    := TO_DINT(RobotStatus.CurrentMovementParameters.WorkobjectNo);
                    Outputs.PointNo         := TO_DINT(RobotStatus.CurrentMovementParameters.PointNo);
                    Outputs.UserSpecSpeed1  := RobotStatus.CurrentMovementParameters.UserSpecSpeed1;
                    Outputs.UserSpecSpeed2  := RobotStatus.CurrentMovementParameters.UserSpecSpeed2;
                    Outputs.Coordinates     := RobotStatus.CurrentMovementParameters.Coordinates; 		
                
                    Outputs.ActionNo := DINT#254;
                    IF _infoTimer.output THEN
                        IF Outputs.ActionNo <> Inputs.ActionNo THEN
                            RobotStatus.Error.Id := UINT#633;//<#Waiting for Inputs.ActionNo to be equal to Outputs.ActionNo!
                        END_IF;
                    END_IF;

                    IF Outputs.ActionNo = Inputs.ActionNo THEN
                        THIS.CallTimers(FALSE);
                        _progress := 326;
                    END_IF;
                END_IF;
                
                IF _progress = 326 THEN //Comparing the movement parameters.
                    IF _infoTimer.output THEN
                        IF Inputs.GlobalSpeed <> TO_DINT(RobotStatus.CurrentMovementParameters.GlobalSpeed) THEN
                            RobotStatus.Error.Id := UINT#634;//<#Waiting for Inputs.GlobalSpeed to be equal to MovementParameters.GlobalSpeed!
                        END_IF;
                        IF Inputs.ToolNo <> TO_DINT(RobotStatus.CurrentMovementParameters.ToolNo) THEN
                            RobotStatus.Error.Id := UINT#635;//<#Waiting for Inputs.ToolNo to be equal to MovementParameters.ToolNo!
                        END_IF;
                        IF Inputs.WorkobjectNo <> TO_DINT(RobotStatus.CurrentMovementParameters.WorkobjectNo) THEN
                            RobotStatus.Error.Id := UINT#636;//<#Waiting for Inputs.WorkobjectNo to be equal to MovementParameters.WorkobjectNo!
                        END_IF;
                        IF Inputs.PointNo <> TO_DINT(RobotStatus.CurrentMovementParameters.PointNo) THEN
                            RobotStatus.Error.Id := UINT#637;//<#Waiting for Inputs.PointNo to be equal to MovementParameters.PointNo!
                        END_IF;
                        IF Inputs.UserSpecSpeed1 <> RobotStatus.CurrentMovementParameters.UserSpecSpeed1 THEN
                            RobotStatus.Error.Id := UINT#638;//<#Waiting for Inputs.UserSpecSpeed1 to be equal to MovementParameters.UserSpecSpeed1!
                        END_IF;
                        IF Inputs.UserSpecSpeed2 <> RobotStatus.CurrentMovementParameters.UserSpecSpeed2 THEN
                            RobotStatus.Error.Id := UINT#639;//<#Waiting for Inputs.UserSpecSpeed2 to be equal to MovementParameters.UserSpecSpeed2!
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
                        _progress:=327;
                    END_IF;
                END_IF;		

                IF _progress = 327 THEN //Acknowledging the movement parameters 
                    Outputs.ActionNo := DINT#255;
                    IF _infoTimer.output THEN
                        IF Outputs.ActionNo <> Inputs.ActionNo THEN
                            RobotStatus.Error.Id := UINT#640;//<#Waiting for Inputs.ActionNo to be equal to Outputs.ActionNo!
                        END_IF;
                    END_IF;

                    IF Outputs.ActionNo = Inputs.ActionNo THEN
                        THIS.CallTimers(FALSE);
                        _progress:=328;
                    END_IF;
                END_IF;	
                
                IF _progress = 328 THEN
                    Outputs.ActionNo := TO_DINT(RobotStatus.CurrentMovementParameters.ActionNo);

                    IF _infoTimer.output THEN
                        IF Outputs.ActionNo <> Inputs.ActionNo THEN
                            RobotStatus.Error.Id := UINT#641;//<#Waiting for Inputs.ActionNo to be equal to Outputs.ActionNo!
                        END_IF;
                    END_IF;
	
                    IF Outputs.ActionNo = Inputs.ActionNo THEN
                        THIS.CallTimers(FALSE);
                        Outputs.ActionNo := DINT#255;
                        _progress:=329;
                    END_IF;
                END_IF;	

                IF _progress = 329 THEN
                    Outputs.ActionNo := DINT#255;

                    IF _infoTimer.output THEN
                        IF Outputs.ActionNo <> Inputs.ActionNo THEN
                            RobotStatus.Error.Id := UINT#642;//<#Waiting for Inputs.ActionNo to be equal to Outputs.ActionNo!
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
                RobotStatus.Action.Id :=  UINT#330;
                RobotStatus.Error.Id :=  UINT#0;
            ELSIF StartMotorsProgramAndMovementsTask.ErrorOccured() THEN
                RobotStatus.Action.Id :=  UINT#713;
                RobotStatus.Error.Id  :=  UINT#713;
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
              
                IF _progress = 340 THEN  

                    IF _infoTimer.output THEN
                        IF NOT Inputs.Inputs.Safety.NO_IsNormalMode THEN
                            RobotStatus.Error.Id := UINT#643;
                        END_IF;
                        IF NOT Inputs.Inputs.Safety.RD_IsReducedMode THEN
                            RobotStatus.Error.Id := UINT#644;
                        END_IF;                        
                    END_IF;

                    IF Inputs.Inputs.Safety.NO_IsNormalMode OR Inputs.Inputs.Safety.RD_IsReducedMode THEN
                        THIS.CallTimers(FALSE);
                        _progress:=341;                    
                    END_IF;
                END_IF;

                IF _progress = 341 THEN	//Reseting error
                    IF _infoTimer.output THEN
                        IF Inputs.Inputs.Safety.FT_IsFault THEN
                            RobotStatus.Error.Id := UINT#645;
                        END_IF;
                    END_IF;

                    IF NOT Inputs.Inputs.Safety.FT_IsFault THEN
                        THIS.CallTimers(FALSE);
                        _progress := 342;
                    END_IF;
                END_IF;
              
                IF _progress = 342 THEN	//Reseting emergency stop error
                    IF _infoTimer.output THEN
                        IF Inputs.Inputs.Safety.ES_IsEmergencyStopped  THEN
                            RobotStatus.Error.Id := UINT#646;
                        END_IF;
                        IF Inputs.Inputs.Safety.PS_IsProtectiveStopped  THEN
                            RobotStatus.Error.Id := UINT#647;
                        END_IF;
                        IF Inputs.Inputs.Safety.SS_IsSafeguardStopped  THEN
                            RobotStatus.Error.Id := UINT#648;
                        END_IF;
                        IF Inputs.Inputs.Safety.RC_IsRecoveryMode  THEN
                            RobotStatus.Error.Id := UINT#649;
                        END_IF;
                        IF Inputs.Inputs.Safety.ST_IsStoppedDueSafety  THEN
                            RobotStatus.Error.Id := UINT#650;
                        END_IF;
                        IF Inputs.Inputs.Safety.VL_IsViolation  THEN
                            RobotStatus.Error.Id := UINT#651;
                        END_IF;
                    END_IF;

                    IF NOT Inputs.Inputs.Safety.ES_IsEmergencyStopped 
                        AND NOT Inputs.Inputs.Safety.PS_IsProtectiveStopped  
                        AND NOT Inputs.Inputs.Safety.SS_IsSafeguardStopped  
                        AND NOT Inputs.Inputs.Safety.RC_IsRecoveryMode 
                        AND NOT Inputs.Inputs.Safety.ST_IsStoppedDueSafety 
                        AND NOT Inputs.Inputs.Safety.VL_IsViolation THEN
                        THIS.CallTimers(FALSE);
                        _progress := 343;
                    END_IF;
                END_IF;
              
                IF _progress = 343 THEN	
                    Outputs.MotorOn:=_blink.output;	

                    IF Inputs.Inputs.Safety.FT_IsFault THEN 
                        THIS.CallTimers(FALSE);
                        _progress := 340;
                    END_IF;

                    IF _infoTimer.output THEN
                        IF NOT Inputs.Inputs.Robot.PW_IsPowerOn THEN
                            RobotStatus.Error.Id := UINT#652;
                        END_IF;
                        IF Inputs.Inputs.Safety.FT_IsFault THEN
                            RobotStatus.Error.Id := UINT#653;
                        END_IF;
                        IF Inputs.Inputs.Joints.JointMode_0 <> 253 THEN
                            RobotStatus.Error.Id := UINT#654;
                        END_IF;
                        IF Inputs.Inputs.Joints.JointMode_1 <> 253 THEN
                            RobotStatus.Error.Id := UINT#655;
                        END_IF;
                        IF Inputs.Inputs.Joints.JointMode_2 <> 253 THEN
                            RobotStatus.Error.Id := UINT#656;
                        END_IF;
                        IF Inputs.Inputs.Joints.JointMode_3 <> 253 THEN
                            RobotStatus.Error.Id := UINT#657;
                        END_IF;
                        IF Inputs.Inputs.Joints.JointMode_4 <> 253 THEN
                            RobotStatus.Error.Id := UINT#658;
                        END_IF;
                        IF Inputs.Inputs.Joints.JointMode_5 <> 253 THEN
                            RobotStatus.Error.Id := UINT#659;
                        END_IF;
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
                         _progress := 344;
                    END_IF;
                END_IF;		

                IF _progress = 344 THEN	
                    StartMotorsAndProgramTask.DoneWhen(TRUE);
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
                RobotStatus.Action.Id :=  UINT#714;
                RobotStatus.Error.Id  :=  UINT#714;
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
                        IF NOT Inputs.Inputs.Robot.PR_IsProgramRunning THEN
                            RobotStatus.Error.Id := UINT#650;//<#Waiting for PR_IsProgramRunning!
                        END_IF;
                        IF NOT Inputs.Inputs.Robot.PW_IsPowerOn THEN
                            RobotStatus.Error.Id := UINT#651;//<#Waiting for PW_IsPowerOn!
                        END_IF;
                        IF Inputs.Inputs.Safety.FT_IsFault THEN
                            RobotStatus.Error.Id := UINT#652;//<#Waiting for FT_IsFault!
                        END_IF;
                    END_IF;

                    IF Inputs.Inputs.Robot.PR_IsProgramRunning AND Inputs.Inputs.Robot.PW_IsPowerOn AND NOT Inputs.Inputs.Safety.FT_IsFault THEN
                        THIS.CallTimers(FALSE);
                        _progress := 351;
                    END_IF;
                END_IF;
                
                IF _progress = 351 THEN

                    Outputs.GlobalSpeed     := TO_DINT(RobotStatus.CurrentMovementParameters.GlobalSpeed);
                    Outputs.ToolNo          := TO_DINT(RobotStatus.CurrentMovementParameters.ToolNo);
                    Outputs.WorkobjectNo    := TO_DINT(RobotStatus.CurrentMovementParameters.WorkobjectNo);
                    Outputs.PointNo         := TO_DINT(RobotStatus.CurrentMovementParameters.PointNo);
                    Outputs.UserSpecSpeed1  := RobotStatus.CurrentMovementParameters.UserSpecSpeed1;
                    Outputs.UserSpecSpeed2  := RobotStatus.CurrentMovementParameters.UserSpecSpeed2;
                    Outputs.Coordinates     := RobotStatus.CurrentMovementParameters.Coordinates; 		
                
                    Outputs.ActionNo := DINT#254;
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
                        IF Inputs.GlobalSpeed <> TO_DINT(RobotStatus.CurrentMovementParameters.GlobalSpeed) THEN
                            RobotStatus.Error.Id := UINT#655;//<#Waiting for Inputs.GlobalSpeed to be equal to MovementParameters.GlobalSpeed!
                        END_IF;
                        IF Inputs.ToolNo <> TO_DINT(RobotStatus.CurrentMovementParameters.ToolNo) THEN
                            RobotStatus.Error.Id := UINT#656;//<#Waiting for Inputs.ToolNo to be equal to MovementParameters.ToolNo!
                        END_IF;
                        IF Inputs.WorkobjectNo <> TO_DINT(RobotStatus.CurrentMovementParameters.WorkobjectNo) THEN
                            RobotStatus.Error.Id := UINT#657;//<#Waiting for Inputs.WorkobjectNo to be equal to MovementParameters.WorkobjectNo!
                        END_IF;
                        IF Inputs.PointNo <> TO_DINT(RobotStatus.CurrentMovementParameters.PointNo) THEN
                            RobotStatus.Error.Id := UINT#658;//<#Waiting for Inputs.PointNo to be equal to MovementParameters.PointNo!
                        END_IF;
                        IF Inputs.UserSpecSpeed1 <> RobotStatus.CurrentMovementParameters.UserSpecSpeed1 THEN
                            RobotStatus.Error.Id := UINT#659;//<#Waiting for Inputs.UserSpecSpeed1 to be equal to MovementParameters.UserSpecSpeed1!
                        END_IF;
                        IF Inputs.UserSpecSpeed2 <> RobotStatus.CurrentMovementParameters.UserSpecSpeed2 THEN
                            RobotStatus.Error.Id := UINT#660;//<#Waiting for Inputs.UserSpecSpeed2 to be equal to MovementParameters.UserSpecSpeed2!
                        END_IF;
                    END_IF;

                    IF 	Inputs.GlobalSpeed      = TO_DINT(RobotStatus.CurrentMovementParameters.GlobalSpeed) AND
                        Inputs.ToolNo           = TO_DINT(RobotStatus.CurrentMovementParameters.ToolNo) AND
                        Inputs.WorkobjectNo     = TO_DINT(RobotStatus.CurrentMovementParameters.WorkobjectNo) AND
                        Inputs.PointNo          = TO_DINT(RobotStatus.CurrentMovementParameters.PointNo) AND
                        Inputs.UserSpecSpeed1   = RobotStatus.CurrentMovementParameters.UserSpecSpeed1 AND
                        Inputs.UserSpecSpeed2   = RobotStatus.CurrentMovementParameters.UserSpecSpeed2 AND
                        AXOpen.Components.Robotics.CoordinatesAreNearlyEqual(Inputs.Coordinates,RobotStatus.CurrentMovementParameters.Coordinates,REAL#0.01,REAL#0.01,REAL#0.01,REAL#0.01,REAL#0.01,REAL#0.01) THEN
                        Outputs.ActionNo := DINT#255;
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
                    Outputs.ActionNo := TO_DINT(RobotStatus.CurrentMovementParameters.ActionNo);

                    IF _infoTimer.output THEN
                        IF Outputs.ActionNo <> Inputs.ActionNo THEN
                            RobotStatus.Error.Id := UINT#662;//<#Waiting for Inputs.ActionNo to be equal to Outputs.ActionNo!
                        END_IF;
                    END_IF;
	
                    IF Outputs.ActionNo = Inputs.ActionNo THEN
                        THIS.CallTimers(FALSE);
                        Outputs.ActionNo := DINT#255;
                        _progress:=355;
                    END_IF;
                END_IF;	

                IF _progress = 355 THEN
                    Outputs.ActionNo := DINT#255;

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
                RobotStatus.Action.Id :=  UINT#715;
                RobotStatus.Error.Id  :=  UINT#715;
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
              
                IF _progress = 370 THEN  

                    IF _infoTimer.output THEN
                        IF NOT Inputs.Inputs.Safety.NO_IsNormalMode THEN
                            RobotStatus.Error.Id := UINT#670;
                        END_IF;
                        IF NOT Inputs.Inputs.Safety.RD_IsReducedMode THEN
                            RobotStatus.Error.Id := UINT#671;
                        END_IF;                        
                    END_IF;

                    IF Inputs.Inputs.Safety.NO_IsNormalMode OR Inputs.Inputs.Safety.RD_IsReducedMode THEN
                        THIS.CallTimers(FALSE);
                        _progress:=371;                    
                    END_IF;
                END_IF;

                IF _progress = 371 THEN	
                    Outputs.MotorOn:=_blink.output;	

                    IF _infoTimer.output THEN
                        IF NOT Inputs.Inputs.Robot.PW_IsPowerOn THEN
                            RobotStatus.Error.Id := UINT#672;
                        END_IF;
                    END_IF;

                    IF Inputs.Inputs.Robot.PW_IsPowerOn THEN
                         Outputs.MotorOn:=FALSE;
                         THIS.CallTimers(FALSE);
                         _progress := 372;
                    END_IF;
                END_IF;		

                IF _progress = 372 THEN	
                    StartMotorsAndProgramTask.DoneWhen(TRUE);
                    THIS.CallTimers(FALSE);
                    _progress := 0;
                END_IF;	              

                THIS.CallTimers(TRUE);
                StartMotorsAndProgramTask.ThrowWhen(_errorTimer.output);
                RobotStatus.Action.Id := TO_UINT(_progress);
            END_IF;
            IF StartProgramTask.DoneReached() THEN
                RobotStatus.Action.Id :=  UINT#373;
                RobotStatus.Error.Id :=  UINT#0;
            ELSIF StartProgramTask.ErrorOccured() THEN
                RobotStatus.Action.Id :=  UINT#716;
                RobotStatus.Error.Id  :=  UINT#716;
            END_IF;
            //*******************************************

            // //***********StopMotorsTask***************
            // StopMotorsTask.IsDisabled := FALSE;
            // IF StopMotorsTask.Execute() THEN
            //     _blink.Blink(Context := _context, inOnTime:=T#500MS,inOffTime:=T#500MS);

            //     IF _progress = 0 THEN
            //         THIS.CallTimers(FALSE);
            //         _progress := 380;
            //     END_IF;
              
            //     IF _progress = 380 THEN 
            //         Outputs.MotorOff := TRUE;

            //         IF _infoTimer.output THEN
            //             IF NOT Inputs.MotorOffState THEN
            //                 RobotStatus.Error.Id := UINT#680; 
            //             END_IF;
            //             IF Inputs.SystemInputBusy THEN
            //                 RobotStatus.Error.Id := UINT#681; 
            //             END_IF;
            //         END_IF;
                    
            //         IF  Inputs.MotorOffState AND NOT Inputs.SystemInputBusy THEN
            //             Outputs.MotorOff:=FALSE;
            //             THIS.CallTimers(FALSE);
            //             _progress := 381;
            //         END_IF;
            //     END_IF;

            //     IF _progress = 381 THEN	
            //         StopMotorsTask.DoneWhen(TRUE);
            //         THIS.CallTimers(FALSE);
            //         _progress := 0;
            //     END_IF;	              

            //     THIS.CallTimers(TRUE);
            //     StopMotorsTask.ThrowWhen(_errorTimer.output);
            //     RobotStatus.Action.Id := TO_UINT(_progress);
            // END_IF;
            // IF StopMotorsTask.DoneReached() THEN
            //     RobotStatus.Action.Id :=  UINT#382;
            //     RobotStatus.Error.Id :=  UINT#0;
            // ELSIF StopMotorsTask.ErrorOccured() THEN
            //     RobotStatus.Action.Id :=  UINT#717;
            //     RobotStatus.Error.Id  :=  UINT#717;
            // END_IF;
            // //*******************************************

            //***********StopMovementsAndProgramTask*****
            StopMovementsAndProgramTask.IsDisabled := FALSE;
            IF StopMovementsAndProgramTask.Execute() THEN
                IF _progress = 0 THEN
                    THIS.CallTimers(FALSE);
                    _progress := 390;
                END_IF;
                
                IF _progress = 390 THEN  
                    IF _infoTimer.output THEN
                        IF NOT Inputs.Inputs.Safety.NO_IsNormalMode THEN
                            RobotStatus.Error.Id := UINT#690;
                        END_IF;
                        IF NOT Inputs.Inputs.Safety.RD_IsReducedMode THEN
                            RobotStatus.Error.Id := UINT#691;
                        END_IF;                        
                    END_IF;

                    IF Inputs.Inputs.Safety.NO_IsNormalMode OR Inputs.Inputs.Safety.RD_IsReducedMode THEN
                        THIS.CallTimers(FALSE);
                        _progress:=391;                    
                    END_IF;
                END_IF;

                IF _progress = 391 THEN
                    Outputs.Stop := TRUE;
                    
                    IF _infoTimer.output THEN
                        IF NOT Inputs.Inputs.Robot.PR_IsProgramRunning THEN
                            RobotStatus.Error.Id := UINT#692;//<#Waiting for PR_IsProgramRunning!
                        END_IF;
                    END_IF;

                    IF NOT Inputs.Inputs.Robot.PR_IsProgramRunning THEN
                        Outputs.Stop := FALSE ;
                        THIS.CallTimers(FALSE);
                        _progress:=392;                    
                    END_IF;                    
                END_IF;                    

                IF _progress = 392 THEN
                    Outputs.Pause := FALSE ;
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
                RobotStatus.Action.Id :=  UINT#718;
                RobotStatus.Error.Id  :=  UINT#718;
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
                    IF _infoTimer.output THEN
                        IF NOT Inputs.Inputs.Safety.NO_IsNormalMode THEN
                            RobotStatus.Error.Id := UINT#693;
                        END_IF;
                        IF NOT Inputs.Inputs.Safety.RD_IsReducedMode THEN
                            RobotStatus.Error.Id := UINT#694;
                        END_IF;                        
                    END_IF;

                    IF Inputs.Inputs.Safety.NO_IsNormalMode OR Inputs.Inputs.Safety.RD_IsReducedMode THEN
                        THIS.CallTimers(FALSE);
                        _progress:=401;                    
                    END_IF;
                END_IF;

                IF _progress = 401 THEN
                    Outputs.Pause := TRUE;
                    
                    IF _infoTimer.output THEN
                        IF NOT Inputs.Inputs.Robot.PR_IsProgramRunning THEN
                            RobotStatus.Error.Id := UINT#695;//<#Waiting for PR_IsProgramRunning!
                        END_IF;
                    END_IF;

                    IF NOT Inputs.Inputs.Robot.PR_IsProgramRunning THEN
                        Outputs.Pause := FALSE ;
                        THIS.CallTimers(FALSE);
                        _progress:=402;                    
                    END_IF;                    
                END_IF;                    

                IF _progress = 402 THEN
                    Outputs.Pause := FALSE ;
                    StopMovementsTask.DoneWhen(TRUE);
                    _progress := 0;
                END_IF;		
                THIS.CallTimers(TRUE);
                
                StopMovementsTask.ThrowWhen(_errorTimer.output);

                RobotStatus.Action.Id := TO_UINT(_progress);
            END_IF;
            IF StopMovementsTask.DoneReached() THEN
                RobotStatus.Action.Id :=  UINT#403;
                RobotStatus.Error.Id :=  UINT#0;
            ELSIF StopMovementsTask.ErrorOccured() THEN
                RobotStatus.Action.Id :=  UINT#719;
                RobotStatus.Error.Id  :=  UINT#719;
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
                    IF _infoTimer.output THEN
                        IF NOT Inputs.Inputs.Safety.NO_IsNormalMode THEN
                            RobotStatus.Error.Id := UINT#696;
                        END_IF;
                        IF NOT Inputs.Inputs.Safety.RD_IsReducedMode THEN
                            RobotStatus.Error.Id := UINT#697;
                        END_IF;                        
                    END_IF;

                    IF Inputs.Inputs.Safety.NO_IsNormalMode OR Inputs.Inputs.Safety.RD_IsReducedMode THEN
                        THIS.CallTimers(FALSE);
                        _progress:=411;                    
                    END_IF;
                END_IF;

                IF _progress = 411 THEN
                    Outputs.Stop := TRUE;
                    
                    IF _infoTimer.output THEN
                        IF NOT Inputs.Inputs.Robot.PR_IsProgramRunning THEN
                            RobotStatus.Error.Id := UINT#698;//<#Waiting for PR_IsProgramRunning!
                        END_IF;
                    END_IF;

                    IF NOT Inputs.Inputs.Robot.PR_IsProgramRunning THEN
                        Outputs.Stop := FALSE ;
                        THIS.CallTimers(FALSE);
                        _progress:=412;                    
                    END_IF;                    
                END_IF;                    

                IF _progress = 412 THEN
                    Outputs.Pause := FALSE ;
                    StopProgramTask.DoneWhen(TRUE);
                    _progress := 0;
                END_IF;		

                THIS.CallTimers(TRUE);
                
                StopProgramTask.ThrowWhen(_errorTimer.output);

                RobotStatus.Action.Id := TO_UINT(_progress);
            END_IF;
            IF StopProgramTask.DoneReached() THEN
                RobotStatus.Action.Id :=  UINT#413;
                RobotStatus.Error.Id :=  UINT#0;
            ELSIF StopProgramTask.ErrorOccured() THEN
                RobotStatus.Action.Id :=  UINT#720;
                RobotStatus.Error.Id  :=  UINT#720;
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
            
            Messenger.ActivateOnCondition(ULINT#721,_someTaskIsActive AND Inputs.Inputs.Safety.ES_IsEmergencyStopped, eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#722,_someTaskIsActive AND Inputs.Inputs.Safety.ST_IsStoppedDueSafety, eAxoMessageCategory#Error);

            IF _someTaskIsActive THEN
                IF(Inputs.Inputs.Safety.ES_IsEmergencyStopped) THEN
                    RobotStatus.Error.Id := UINT#713;
                END_IF;
                IF(Inputs.Inputs.Safety.ST_IsStoppedDueSafety) THEN
                    RobotStatus.Error.Id := UINT#714;
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
            refAxoUrRobotics_O2T_Robot_IO^[0].%X0 := Outputs.Outputs.Speed.SSM_SpeedSliderFractionMask;

            _dword := TO_DWORD(Outputs.Outputs.Speed.SpeedSliderFraction * REAL#0.01);
            refAxoUrRobotics_O2T_Robot_IO^[4] := _dword.%B3;
            refAxoUrRobotics_O2T_Robot_IO^[5] := _dword.%B2;
            refAxoUrRobotics_O2T_Robot_IO^[6] := _dword.%B1;
            refAxoUrRobotics_O2T_Robot_IO^[7] := _dword.%B0;

            //st_URO_CB3_O2TIoData => 8_O2T Robot IO
            refAxoUrRobotics_O2T_Robot_IO^[8]  := TO_BYTE(Outputs.Outputs.IO.StandardDigitalOutputMask);
            refAxoUrRobotics_O2T_Robot_IO^[9]  := TO_BYTE(Outputs.Outputs.IO.ConfigurableDigitalOutputMask);
            refAxoUrRobotics_O2T_Robot_IO^[10] := TO_BYTE(Outputs.Outputs.IO.StandardDigitalOutputs);
            refAxoUrRobotics_O2T_Robot_IO^[11] := TO_BYTE(Outputs.Outputs.IO.ConfigurableDdigitalOutputs);
            refAxoUrRobotics_O2T_Robot_IO^[12] := TO_BYTE(Outputs.Outputs.IO.AOM_AnalogOutputMask);
            refAxoUrRobotics_O2T_Robot_IO^[13] := TO_BYTE(Outputs.Outputs.IO.AOT_AnalogOutputTypes);
            refAxoUrRobotics_O2T_Robot_IO^[14] := TO_BYTE(Outputs.Outputs.IO.TDOM_ToolDigitalOutputMask);
            refAxoUrRobotics_O2T_Robot_IO^[15] := TO_BYTE(Outputs.Outputs.IO.TDO_ToolDigitalOutput);

            _dword := TO_DWORD(Outputs.Outputs.IO.StandardAnalogOutput_0);
            refAxoUrRobotics_O2T_Robot_IO^[16] := _dword.%B3;
            refAxoUrRobotics_O2T_Robot_IO^[17] := _dword.%B2;
            refAxoUrRobotics_O2T_Robot_IO^[18] := _dword.%B1;
            refAxoUrRobotics_O2T_Robot_IO^[19] := _dword.%B0;

            _dword := TO_DWORD(Outputs.Outputs.IO.StandardAnalogOutput_1);
            refAxoUrRobotics_O2T_Robot_IO^[20] := _dword.%B3;
            refAxoUrRobotics_O2T_Robot_IO^[21] := _dword.%B2;
            refAxoUrRobotics_O2T_Robot_IO^[22] := _dword.%B1;
            refAxoUrRobotics_O2T_Robot_IO^[23] := _dword.%B0;

            //st_URO_CB3_O2TRegData => 9_O2T General Purpose Registers 1
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[0].%X0 :=  Outputs.Outputs.Reg1.Bit_0;
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[0].%X1 :=  Outputs.Outputs.Reg1.Bit_1;
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[0].%X2 :=  Outputs.Outputs.Reg1.Bit_2;
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[0].%X3 :=  Outputs.Outputs.Reg1.Bit_3;
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[0].%X4 :=  Outputs.Outputs.Reg1.Bit_4;
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[0].%X5 :=  Outputs.Outputs.Reg1.Bit_5;
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[0].%X6 :=  Outputs.Outputs.Reg1.Bit_6;
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[0].%X7 :=  Outputs.Outputs.Reg1.Bit_7;

            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[1].%X0 :=  Outputs.Outputs.Reg1.Bit_8;
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[1].%X1 :=  Outputs.Outputs.Reg1.Bit_9;
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[1].%X2 :=  Outputs.Outputs.Reg1.Bit_10;
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[1].%X3 :=  Outputs.Outputs.Reg1.Bit_11;
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[1].%X4 :=  Outputs.Outputs.Reg1.Bit_12;
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[1].%X5 :=  Outputs.Outputs.Reg1.Bit_13;
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[1].%X6 :=  Outputs.Outputs.Reg1.Bit_14;
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[1].%X7 :=  Outputs.Outputs.Reg1.Bit_15;

            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[2].%X0 :=  Outputs.Outputs.Reg1.Bit_16;
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[2].%X1 :=  Outputs.Outputs.Reg1.Bit_17;
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[2].%X2 :=  Outputs.Outputs.Reg1.Bit_18;
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[2].%X3 :=  Outputs.Outputs.Reg1.Bit_19;
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[2].%X4 :=  Outputs.Outputs.Reg1.Bit_20;
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[2].%X5 :=  Outputs.Outputs.Reg1.Bit_21;
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[2].%X6 :=  Outputs.Outputs.Reg1.Bit_22;
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[2].%X7 :=  Outputs.Outputs.Reg1.Bit_23;

            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[3].%X0 :=  Outputs.Outputs.Reg1.Bit_24;
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[3].%X1 :=  Outputs.Outputs.Reg1.Bit_25;
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[3].%X2 :=  Outputs.Outputs.Reg1.Bit_26;
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[3].%X3 :=  Outputs.Outputs.Reg1.Bit_27;
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[3].%X4 :=  Outputs.Outputs.Reg1.Bit_28;
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[3].%X5 :=  Outputs.Outputs.Reg1.Bit_29;
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[3].%X6 :=  Outputs.Outputs.Reg1.Bit_30;
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[3].%X7 :=  Outputs.Outputs.Reg1.Bit_31;

            _dword := TO_DWORD( Outputs.Outputs.Reg1.Int_0);
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[4] := _dword.%B3;
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[5] := _dword.%B2;
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[6] := _dword.%B1;
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[7] := _dword.%B0;

            _dword := TO_DWORD( Outputs.Outputs.Reg1.Int_1);
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[8] := _dword.%B3;
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[9] := _dword.%B2;
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[10] := _dword.%B1;
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[11] := _dword.%B0;

            _dword := TO_DWORD( Outputs.Outputs.Reg1.Int_2);
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[12] := _dword.%B3;
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[13] := _dword.%B2;
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[14] := _dword.%B1;
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[15] := _dword.%B0;

            _dword := TO_DWORD( Outputs.Outputs.Reg1.Int_3);
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[16] := _dword.%B3;
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[17] := _dword.%B2;
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[18] := _dword.%B1;
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[19] := _dword.%B0;

            _dword := TO_DWORD( Outputs.Outputs.Reg1.Int_4);
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[20] := _dword.%B3;
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[21] := _dword.%B2;
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[22] := _dword.%B1;
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[23] := _dword.%B0;

            _dword := TO_DWORD( Outputs.Outputs.Reg1.Int_5);
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[24] := _dword.%B3;
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[25] := _dword.%B2;
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[26] := _dword.%B1;
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[27] := _dword.%B0;

            _dword := TO_DWORD( Outputs.Outputs.Reg1.Int_6);
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[28] := _dword.%B3;
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[29] := _dword.%B2;
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[30] := _dword.%B1;
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[31] := _dword.%B0;

            _dword := TO_DWORD( Outputs.Outputs.Reg1.Int_7);
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[32] := _dword.%B3;
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[33] := _dword.%B2;
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[34] := _dword.%B1;
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[35] := _dword.%B0;

            _dword := TO_DWORD( Outputs.Outputs.Reg1.Int_8);
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[36] := _dword.%B3;
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[37] := _dword.%B2;
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[38] := _dword.%B1;
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[39] := _dword.%B0;

            _dword := TO_DWORD( Outputs.Outputs.Reg1.Int_9);
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[40] := _dword.%B3;
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[41] := _dword.%B2;
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[42] := _dword.%B1;
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[43] := _dword.%B0;

            _dword := TO_DWORD( Outputs.Outputs.Reg1.Int_10);
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[44] := _dword.%B3;
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[45] := _dword.%B2;
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[46] := _dword.%B1;
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[47] := _dword.%B0;

            _dword := TO_DWORD( Outputs.Outputs.Reg1.Int_11);
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[48] := _dword.%B3;
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[49] := _dword.%B2;
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[50] := _dword.%B1;
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[51] := _dword.%B0;


            _dword := TO_DWORD( Outputs.Outputs.Reg1.Float_0);
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[52] := _dword.%B3;
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[53] := _dword.%B2;
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[54] := _dword.%B1;
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[55] := _dword.%B0;

            _dword := TO_DWORD( Outputs.Outputs.Reg1.Float_1);
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[56] := _dword.%B3;
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[58] := _dword.%B2;
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[58] := _dword.%B1;
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[59] := _dword.%B0;

            _dword := TO_DWORD( Outputs.Outputs.Reg1.Float_2);
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[60] := _dword.%B3;
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[61] := _dword.%B2;
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[62] := _dword.%B1;
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[63] := _dword.%B0;

            _dword := TO_DWORD( Outputs.Outputs.Reg1.Float_3);
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[64] := _dword.%B3;
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[65] := _dword.%B2;
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[66] := _dword.%B1;
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[67] := _dword.%B0;

            _dword := TO_DWORD( Outputs.Outputs.Reg1.Float_4);
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[68] := _dword.%B3;
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[69] := _dword.%B2;
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[70] := _dword.%B1;
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[71] := _dword.%B0;

            _dword := TO_DWORD( Outputs.Outputs.Reg1.Float_5);
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[72] := _dword.%B3;
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[73] := _dword.%B2;
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[74] := _dword.%B1;
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[75] := _dword.%B0;

            _dword := TO_DWORD( Outputs.Outputs.Reg1.Float_6);
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[76] := _dword.%B3;
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[77] := _dword.%B2;
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[78] := _dword.%B1;
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[79] := _dword.%B0;

            _dword := TO_DWORD( Outputs.Outputs.Reg1.Float_7);
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[80] := _dword.%B3;
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[81] := _dword.%B2;
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[82] := _dword.%B1;
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[83] := _dword.%B0;

            _dword := TO_DWORD( Outputs.Outputs.Reg1.Float_8);
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[84] := _dword.%B3;
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[85] := _dword.%B2;
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[86] := _dword.%B1;
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[87] := _dword.%B0;

            _dword := TO_DWORD( Outputs.Outputs.Reg1.Float_9);
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[88] := _dword.%B3;
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[89] := _dword.%B2;
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[90] := _dword.%B1;
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[91] := _dword.%B0;

            _dword := TO_DWORD( Outputs.Outputs.Reg1.Float_10);
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[92] := _dword.%B3;
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[93] := _dword.%B2;
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[94] := _dword.%B1;
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[95] := _dword.%B0;

            _dword := TO_DWORD( Outputs.Outputs.Reg1.Float_11);
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[96] := _dword.%B3;
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[97] := _dword.%B2;
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[98] := _dword.%B1;
            refAxoUrRobotics_O2T_General_Purpose_Registers_1^[99] := _dword.%B0;

            //st_URO_CB3_O2TRegData => 10_O2T General Purpose Registers 2
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[0].%X0 :=  Outputs.Outputs.Reg2.Bit_0;
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[0].%X1 :=  Outputs.Outputs.Reg2.Bit_1;
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[0].%X2 :=  Outputs.Outputs.Reg2.Bit_2;
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[0].%X3 :=  Outputs.Outputs.Reg2.Bit_3;
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[0].%X4 :=  Outputs.Outputs.Reg2.Bit_4;
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[0].%X5 :=  Outputs.Outputs.Reg2.Bit_5;
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[0].%X6 :=  Outputs.Outputs.Reg2.Bit_6;
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[0].%X7 :=  Outputs.Outputs.Reg2.Bit_7;

            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[1].%X0 :=  Outputs.Outputs.Reg2.Bit_8;
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[1].%X1 :=  Outputs.Outputs.Reg2.Bit_9;
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[1].%X2 :=  Outputs.Outputs.Reg2.Bit_10;
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[1].%X3 :=  Outputs.Outputs.Reg2.Bit_11;
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[1].%X4 :=  Outputs.Outputs.Reg2.Bit_12;
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[1].%X5 :=  Outputs.Outputs.Reg2.Bit_13;
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[1].%X6 :=  Outputs.Outputs.Reg2.Bit_14;
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[1].%X7 :=  Outputs.Outputs.Reg2.Bit_15;

            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[2].%X0 :=  Outputs.Outputs.Reg2.Bit_16;
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[2].%X1 :=  Outputs.Outputs.Reg2.Bit_17;
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[2].%X2 :=  Outputs.Outputs.Reg2.Bit_18;
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[2].%X3 :=  Outputs.Outputs.Reg2.Bit_19;
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[2].%X4 :=  Outputs.Outputs.Reg2.Bit_20;
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[2].%X5 :=  Outputs.Outputs.Reg2.Bit_21;
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[2].%X6 :=  Outputs.Outputs.Reg2.Bit_22;
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[2].%X7 :=  Outputs.Outputs.Reg2.Bit_23;

            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[3].%X0 :=  Outputs.Outputs.Reg2.Bit_24;
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[3].%X1 :=  Outputs.Outputs.Reg2.Bit_25;
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[3].%X2 :=  Outputs.Outputs.Reg2.Bit_26;
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[3].%X3 :=  Outputs.Outputs.Reg2.Bit_27;
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[3].%X4 :=  Outputs.Outputs.Reg2.Bit_28;
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[3].%X5 :=  Outputs.Outputs.Reg2.Bit_29;
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[3].%X6 :=  Outputs.Outputs.Reg2.Bit_30;
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[3].%X7 :=  Outputs.Outputs.Reg2.Bit_31;

            _dword := TO_DWORD( Outputs.Outputs.Reg2.Int_0);
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[4] := _dword.%B3;
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[5] := _dword.%B2;
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[6] := _dword.%B1;
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[7] := _dword.%B0;

            _dword := TO_DWORD( Outputs.Outputs.Reg2.Int_1);
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[8] := _dword.%B3;
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[9] := _dword.%B2;
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[10] := _dword.%B1;
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[11] := _dword.%B0;

            _dword := TO_DWORD( Outputs.Outputs.Reg2.Int_2);
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[12] := _dword.%B3;
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[13] := _dword.%B2;
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[14] := _dword.%B1;
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[15] := _dword.%B0;

            _dword := TO_DWORD( Outputs.Outputs.Reg2.Int_3);
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[16] := _dword.%B3;
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[17] := _dword.%B2;
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[18] := _dword.%B1;
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[19] := _dword.%B0;

            _dword := TO_DWORD( Outputs.Outputs.Reg2.Int_4);
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[20] := _dword.%B3;
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[21] := _dword.%B2;
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[22] := _dword.%B1;
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[23] := _dword.%B0;

            _dword := TO_DWORD( Outputs.Outputs.Reg2.Int_5);
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[24] := _dword.%B3;
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[25] := _dword.%B2;
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[26] := _dword.%B1;
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[27] := _dword.%B0;

            _dword := TO_DWORD( Outputs.Outputs.Reg2.Int_6);
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[28] := _dword.%B3;
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[29] := _dword.%B2;
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[30] := _dword.%B1;
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[31] := _dword.%B0;

            _dword := TO_DWORD( Outputs.Outputs.Reg2.Int_7);
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[32] := _dword.%B3;
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[33] := _dword.%B2;
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[34] := _dword.%B1;
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[35] := _dword.%B0;

            _dword := TO_DWORD( Outputs.Outputs.Reg2.Int_8);
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[36] := _dword.%B3;
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[37] := _dword.%B2;
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[38] := _dword.%B1;
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[39] := _dword.%B0;

            _dword := TO_DWORD( Outputs.Outputs.Reg2.Int_9);
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[40] := _dword.%B3;
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[41] := _dword.%B2;
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[42] := _dword.%B1;
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[43] := _dword.%B0;

            _dword := TO_DWORD( Outputs.Outputs.Reg2.Int_10);
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[44] := _dword.%B3;
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[45] := _dword.%B2;
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[46] := _dword.%B1;
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[47] := _dword.%B0;

            _dword := TO_DWORD( Outputs.Outputs.Reg2.Int_11);
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[48] := _dword.%B3;
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[49] := _dword.%B2;
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[50] := _dword.%B1;
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[51] := _dword.%B0;


            _dword := TO_DWORD( Outputs.Outputs.Reg2.Float_0);
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[52] := _dword.%B3;
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[53] := _dword.%B2;
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[54] := _dword.%B1;
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[55] := _dword.%B0;

            _dword := TO_DWORD( Outputs.Outputs.Reg2.Float_1);
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[56] := _dword.%B3;
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[58] := _dword.%B2;
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[58] := _dword.%B1;
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[59] := _dword.%B0;

            _dword := TO_DWORD( Outputs.Outputs.Reg2.Float_2);
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[60] := _dword.%B3;
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[61] := _dword.%B2;
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[62] := _dword.%B1;
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[63] := _dword.%B0;

            _dword := TO_DWORD( Outputs.Outputs.Reg2.Float_3);
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[64] := _dword.%B3;
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[65] := _dword.%B2;
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[66] := _dword.%B1;
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[67] := _dword.%B0;

            _dword := TO_DWORD( Outputs.Outputs.Reg2.Float_4);
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[68] := _dword.%B3;
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[69] := _dword.%B2;
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[70] := _dword.%B1;
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[71] := _dword.%B0;

            _dword := TO_DWORD( Outputs.Outputs.Reg2.Float_5);
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[72] := _dword.%B3;
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[73] := _dword.%B2;
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[74] := _dword.%B1;
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[75] := _dword.%B0;

            _dword := TO_DWORD( Outputs.Outputs.Reg2.Float_6);
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[76] := _dword.%B3;
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[77] := _dword.%B2;
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[78] := _dword.%B1;
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[79] := _dword.%B0;

            _dword := TO_DWORD( Outputs.Outputs.Reg2.Float_7);
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[80] := _dword.%B3;
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[81] := _dword.%B2;
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[82] := _dword.%B1;
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[83] := _dword.%B0;

            _dword := TO_DWORD( Outputs.Outputs.Reg2.Float_8);
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[84] := _dword.%B3;
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[85] := _dword.%B2;
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[86] := _dword.%B1;
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[87] := _dword.%B0;

            _dword := TO_DWORD( Outputs.Outputs.Reg2.Float_9);
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[88] := _dword.%B3;
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[89] := _dword.%B2;
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[90] := _dword.%B1;
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[91] := _dword.%B0;

            _dword := TO_DWORD( Outputs.Outputs.Reg2.Float_10);
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[92] := _dword.%B3;
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[93] := _dword.%B2;
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[94] := _dword.%B1;
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[95] := _dword.%B0;

            _dword := TO_DWORD( Outputs.Outputs.Reg2.Float_11);
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[96] := _dword.%B3;
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[97] := _dword.%B2;
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[98] := _dword.%B1;
            refAxoUrRobotics_O2T_General_Purpose_Registers_2^[99] := _dword.%B0;
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
