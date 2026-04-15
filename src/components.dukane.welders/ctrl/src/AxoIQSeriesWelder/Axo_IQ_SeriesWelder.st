USING AXOpen.Core;
USING AXOpen.Messaging;
USING AXOpen.Messaging.Static;
USING AXOpen.Components.Abstractions;
USING Siemens.Simatic.Hardware.Utilities;
USING Siemens.Simatic.DistributedIO;
USING System.Timer;
USING System.Serialization;

NAMESPACE AXOpen.Components.Dukane.Welders
    {S7.extern=ReadWrite}
    CLASS Axo_IQ_SeriesWelder EXTENDS AXOpen.Core.AxoComponent
        VAR PUBLIC // HEADER
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentHeader()]}
            {#ix-set:AttributeName = "<#Run welding with time#>"}
            RunWeldingWithTimeTask : AXOpen.Core.AxoTask;
            {#ix-attr:[ComponentHeader()]}
            {#ix-set:AttributeName = "<#Required setup number#>"}
            RequiredSetupNumber : UINT := UINT#1;
            {#ix-attr:[ComponentHeader()]}
            {#ix-set:AttributeName = "<#Required probe number#>"}
            RequiredProbeNumber : UINT:= UINT#1;
            {#ix-attr:[ComponentHeader()]}
            {#ix-set:AttributeName = "<#Required welding time#>"}
            RequiredWeldingTime : LTIME :=  LTIME#2s;
            {#ix-attr:[ComponentHeader()]}
            {#ix-set:AttributeName = "<#Progress#>"}
            {#ix-attr:[ReadOnly()]}
            Progress       :   INT;
        END_VAR

        VAR PUBLIC // TASKS
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#Restore#>"}
            RestoreTask : AXOpen.Core.AxoTask;

            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#Change setup#>"}
            ChangeWeldingSetupTask : AXOpen.Core.AxoTask;

            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#Clear error#>"}
            ClearErrorTask : AXOpen.Core.AxoTask;

            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#Change probe#>"}
            ChangeWeldingProbeTask : AXOpen.Core.AxoTask;

            
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#CycleStopTask#>"}
            CycleStopTask : AXOpen.Core.AxoTask;

        END_VAR

        VAR PUBLIC // CONFIG
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("Config")]}
            {#ix-attr:[ReadOnly()]}
            {#ix-set:AttributeName = "<#Config#>"}
            Config  :   Axo_IQ_SeriesWelder_Config;
        END_VAR
       
        VAR PUBLIC // STATUS
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("Status")]}
            {#ix-attr:[ReadOnly()]}
            Status              :   Axo_IQ_SeriesWelder_Component_Status;
            Messenger           :   AXOpen.Messaging.Static.AxoMessenger;
            TaskMessenger       :   AXOpen.Messaging.Static.AxoMessenger;
        END_VAR    

        VAR PUBLIC // HARDWARE SIGNALS
            {#ix-attr:[ComponentDetails("HARDWARE SIGNALS")]}
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Inputs#>"}
            {#ix-attr:[ReadOnly()]}
            Inputs              :  Axo_IQ_SeriesWelder_SystemInputs;
            {#ix-attr:[ComponentDetails("HARDWARE SIGNALS")]}
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Outputs#>"}
            {#ix-attr:[ReadOnly()]}
            Outputs              :   Axo_IQ_SeriesWelder_SystemOutputs;
        END_VAR    

        VAR PUBLIC // HARDWARE DIAGNOSTICS TASK
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("Hardware diagnostics")]}
            {#ix-set:AttributeName = "<#Update diagnostics#>"}
            HardwareDiagnosticsTask :   AXOpen.Io.AxoHardwareDiagnostics;
        END_VAR

        VAR PRIVATE
            _progress       :   INT;
            _infoTimer      :   AXOpen.Timers.OnDelayTimer;
            _errorTimer     :   AXOpen.Timers.OnDelayTimer;
            _data_in        :   ARRAY[0..139] OF BYTE;
            _data_out       :   ARRAY[0..19] OF BYTE;
            _word           :   WORD;
            _dword          :   DWORD;

            _initHwCheckDone        :   BOOL;
            _retval                 :   WORD;
            _geoAddr                :   GeoAddr;
            _outHwid                :   UINT;
            _blink                  :   AXOpen.Timers.AxoBlinker;   
            _inputsAddress          :   UDINT;   
            _inputsCount            :   UINT;
            _outputsAddress         :   UDINT;  
            _outputsCount           :   UINT; 

            _setupNumber            :   UINT;
            _probeNumber            :   UINT;
            _weldingTime            :   LTIME;

            _weldingTimer           :    AXOpen.Timers.OnDelayTimer;
        END_VAR

        ///<summary>
        /// Runs tasks and logic of this component.
        /// >[!IMPORTANT] This method must or one of its overloads be called cyclically.
        ///</summary>
        METHOD PUBLIC Run
            VAR_INPUT
                inParent      :   IAxoObject;
                hwID        :   UINT;
            END_VAR

            VAR_TEMP 
                index : UINT;
            END_VAR
    
            // IQ ULTRASONIC GENERATOR CONTROL - over profinet - mode "Profinet with Distance"
            
            // ============================================================================
            // NOTE:  use the IQ Commander software (connected over USB TO the Generator)
            // TO set the comunicatiom mode TO "Profinet with Distance" -
            // otherwise the communication will NOT work.
            // ============================================================================

            SUPER.Run(inParent);

            Messenger.Serve(THIS);
            
            Progress := _progress;

            IF NOT _initHwCheckDone THEN
                IF inParent = NULL THEN
                    Messenger.Activate(UINT#700, eAxoMessageCategory#ProgrammingError);
                    Status.Error.Id := UINT#700;
                    RETURN;
                END_IF;
                IF hwID = UINT#0 THEN
                    Messenger.Activate(UINT#701, eAxoMessageCategory#ProgrammingError);
                    Status.Error.Id := UINT#701;
                    RETURN;
                END_IF;
    
                Config.HWIDs.HW_Device := hwID;                                                      
                _retval := ReadSlotFromHardwareID(hardwareID := Config.HWIDs.HW_Device, geoAddr :=_geoAddr);   
                IF _retval = WORD#8090 THEN
                    Messenger.Activate(UINT#702,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#702;
                    RETURN;
                END_IF;

                //******************Slot 1*****************//
                _geoAddr.Slot   :=  UINT#1;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_iQ_to_PLC_Inputs);        
                IF Config.HWIDs.HwID_iQ_to_PLC_Inputs = UINT#0 THEN
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
                ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HwID_iQ_to_PLC_Inputs) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#140 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#716,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#716;
                    RETURN;
                END_IF;
                //******************Slot 2*****************//
                _geoAddr.Slot   :=  UINT#2;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_PLC_to_iQ_Outputs);        
                IF Config.HWIDs.HwID_PLC_to_iQ_Outputs = UINT#0 THEN
                    Messenger.Activate(UINT#910,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#910;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#911,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#911;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#912,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#912;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#913,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#913;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#914,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#914;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#715,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#715;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HwID_PLC_to_iQ_Outputs) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _outputsCount <> UINT#20 OR _inputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#916,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#916;
                    RETURN;
                END_IF;
 
                IF inParent = NULL THEN
                    Messenger.Activate(UINT#1130,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1130;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HW_Device  = UINT#0 THEN
                    Messenger.Activate(UINT#1131,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1131;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_iQ_to_PLC_Inputs  = UINT#0 THEN
                    Messenger.Activate(UINT#1132,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1132;
                    RETURN;
                END_IF;

                IF Config.HWIDs.HwID_PLC_to_iQ_Outputs  = UINT#0 THEN
                    Messenger.Activate(UINT#1152,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1152;
                    RETURN;
                END_IF;

                _initHwCheckDone    := TRUE;
            END_IF;            

            //***********Update inputs **************
            _retval := ReadData(Config.HWIDs.HwID_iQ_to_PLC_Inputs, _data_in);
            IF _retval > WORD#0 THEN
                Messenger.Activate(UINT#1201, eAxoMessageCategory#Error);
                Status.Error.Id := UINT#1201;
                RETURN;
            END_IF;
            Inputs.SystemErrorStatus.Frequency_Overload_3                    := _data_in[0].%X0;
            // Inputs.SystemErrorStatus._1                                      := _data_in[0].%X1;
            // Inputs.SystemErrorStatus._2                                      := _data_in[0].%X2;
            // Inputs.SystemErrorStatus._3                                      := _data_in[0].%X3;
            Inputs.SystemErrorStatus.Under_Voltage_1                         := _data_in[0].%X4;
            // Inputs.SystemErrorStatus._5                                      := _data_in[0].%X5;
            // Inputs.SystemErrorStatus._6                                      := _data_in[0].%X6;
            // Inputs.SystemErrorStatus._7                                      := _data_in[0].%X7;
            Inputs.SystemErrorStatus.Over_Amplitude_Fault                    := _data_in[1].%X0;
            Inputs.SystemErrorStatus.InternalError_5                         := _data_in[1].%X1;
            Inputs.SystemErrorStatus.US_Voltage_Overload                     := _data_in[1].%X2;
            // Inputs.SystemErrorStatus._11                                     := _data_in[1].%X3;
            // Inputs.SystemErrorStatus._12                                     := _data_in[1].%X4;
            // Inputs.SystemErrorStatus._13                                     := _data_in[1].%X5;
            // Inputs.SystemErrorStatus._14                                     := _data_in[1].%X6;
            // Inputs.SystemErrorStatus._15                                     := _data_in[1].%X7;
            Inputs.SystemErrorStatus.Average_Overload                        := _data_in[2].%X0;
            Inputs.SystemErrorStatus.Current_Loop                            := _data_in[2].%X1;
            Inputs.SystemErrorStatus.Power_Not_OK                            := _data_in[2].%X2;
            Inputs.SystemErrorStatus.Over_Temperature                        := _data_in[2].%X3;
            // Inputs.SystemErrorStatus._20                                     := _data_in[2].%X4;
            // Inputs.SystemErrorStatus._21                                     := _data_in[2].%X5;
            // Inputs.SystemErrorStatus._22                                     := _data_in[2].%X6;
            // Inputs.SystemErrorStatus._23                                     := _data_in[2].%X7;
            Inputs.SystemErrorStatus.InternalError_1                         := _data_in[3].%X0;
            Inputs.SystemErrorStatus.InternalError_2                         := _data_in[3].%X1;
            Inputs.SystemErrorStatus.InternalError_3                         := _data_in[3].%X2;
            Inputs.SystemErrorStatus.InternalError_4                         := _data_in[3].%X3;
            Inputs.SystemErrorStatus.FrequencyOverload_1                     := _data_in[3].%X4;
            Inputs.SystemErrorStatus.Frequency_Overload_2                    := _data_in[3].%X5;
            Inputs.SystemErrorStatus.Peak_Overload_Positive                  := _data_in[3].%X6;
            Inputs.SystemErrorStatus.Peak_Overload_Negative                  := _data_in[3].%X7;

            _dword.%B3                                                          := _data_in[4];
            _dword.%B2                                                          := _data_in[5];
            _dword.%B1                                                          := _data_in[6];
            _dword.%B0                                                          := _data_in[7];
            Inputs.SystemInitiateError := TO_DINT(_dword);

            // Inputs.SystemProcessError._0                                     := _data_in[8].%X0;
            // Inputs.SystemProcessError._1                                     := _data_in[8].%X1;
            // Inputs.SystemProcessError._2                                     := _data_in[8].%X2;
            // Inputs.SystemProcessError._3                                     := _data_in[8].%X3;
            // Inputs.SystemProcessError._4                                     := _data_in[8].%X4;
            // Inputs.SystemProcessError._5                                     := _data_in[8].%X5;
            // Inputs.SystemProcessError._6                                     := _data_in[8].%X6;
            // Inputs.SystemProcessError._7                                     := _data_in[8].%X7;
            // Inputs.SystemProcessError._8                                     := _data_in[9].%X0;
            // Inputs.SystemProcessError._9                                     := _data_in[9].%X1;
            // Inputs.SystemProcessError._10                                    := _data_in[9].%X2;
            // Inputs.SystemProcessError._11                                    := _data_in[9].%X3;
            // Inputs.SystemProcessError._12                                    := _data_in[9].%X4;
            // Inputs.SystemProcessError._13                                    := _data_in[9].%X5;
            // Inputs.SystemProcessError._14                                    := _data_in[9].%X6;
            // Inputs.SystemProcessError._15                                    := _data_in[9].%X7;
            Inputs.SystemProcessError.Trigger_Delay                          := _data_in[10].%X0;
            Inputs.SystemProcessError.Servo_DN_Limit                         := _data_in[10].%X1;
            Inputs.SystemProcessError.Servo_TOS_Position                     := _data_in[10].%X2;
            // Inputs.SystemProcessError._19                                    := _data_in[10].%X3;
            // Inputs.SystemProcessError._20                                    := _data_in[10].%X4;
            // Inputs.SystemProcessError._21                                    := _data_in[10].%X5;
            // Inputs.SystemProcessError._22                                    := _data_in[10].%X6;
            // Inputs.SystemProcessError._23                                    := _data_in[10].%X7;
            Inputs.SystemProcessError.Forced_ShutDown                        := _data_in[11].%X0;
            Inputs.SystemProcessError.Trigger_Lost_Early                     := _data_in[11].%X1;
            Inputs.SystemProcessError.Trigger_Lost_Weld                      := _data_in[11].%X2;
            Inputs.SystemProcessError.Latched_Bad_Part                       := _data_in[11].%X3;
            Inputs.SystemProcessError.PreTrigger_OverTravel                  := _data_in[11].%X4;
            Inputs.SystemProcessError.Part_Detected                          := _data_in[11].%X5;
            Inputs.SystemProcessError.PreTrigger_Time                        := _data_in[11].%X6;
            Inputs.SystemProcessError.Trigger_Time                           := _data_in[11].%X7;

            _dword.%B3                                                          := _data_in[12];
            _dword.%B2                                                          := _data_in[13];
            _dword.%B1                                                          := _data_in[14];
            _dword.%B0                                                          := _data_in[15];
            Inputs.GeneratorState := TO_DINT(_dword);

            _dword.%B3                                                          := _data_in[16];
            _dword.%B2                                                          := _data_in[17];
            _dword.%B1                                                          := _data_in[18];
            _dword.%B0                                                          := _data_in[19];
            Inputs.RealTimeAmplitude := TO_DINT(_dword);

            _dword.%B3                                                          := _data_in[20];
            _dword.%B2                                                          := _data_in[21];
            _dword.%B1                                                          := _data_in[22];
            _dword.%B0                                                          := _data_in[23];
            Inputs.RealTimeFrequency := TO_DINT(_dword);

            _dword.%B3                                                          := _data_in[24];
            _dword.%B2                                                          := _data_in[25];
            _dword.%B1                                                          := _data_in[26];
            _dword.%B0                                                          := _data_in[27];
            Inputs.RealTimePower := TO_DINT(_dword);


            // Inputs.SystemStatus.res_bit24                                    := _data_in[28].%X0;
            // Inputs.SystemStatus.res_bit25                                    := _data_in[28].%X1;
            // Inputs.SystemStatus.res_bit26                                    := _data_in[28].%X2;
            // Inputs.SystemStatus.res_bit27                                    := _data_in[28].%X3;
            // Inputs.SystemStatus.res_bit28                                    := _data_in[28].%X4;
            // Inputs.SystemStatus.res_bit29                                    := _data_in[28].%X5;
            // Inputs.SystemStatus.res_bit30                                    := _data_in[28].%X6;
            Inputs.SystemStatus.SetupChanged                                 := _data_in[28].%X7;
            Inputs.SystemStatus.InCycle                                      := _data_in[29].%X0;
            Inputs.SystemStatus.InCycle_No_AB                                := _data_in[29].%X1;
            Inputs.SystemStatus.OverTemp                                     := _data_in[29].%X2;
            Inputs.SystemStatus.In_AfterBurst                                := _data_in[29].%X3;
            Inputs.SystemStatus.In_Test                                      := _data_in[29].%X4;
            Inputs.SystemStatus.In_TestScan                                  := _data_in[29].%X5;
            Inputs.SystemStatus.MPC_Present                                  := _data_in[29].%X6;
            // Inputs.SystemStatus.res_bit23                                    := _data_in[29].%X7;
            Inputs.SystemStatus.PowerOK                                      := _data_in[30].%X0;
            Inputs.SystemStatus.MPC_Ready                                    := _data_in[30].%X1;
            Inputs.SystemStatus.Ready                                        := _data_in[30].%X2;
            Inputs.SystemStatus.Any_Fault                                    := _data_in[30].%X3;
            Inputs.SystemStatus.Overload                                     := _data_in[30].%X4;
            Inputs.SystemStatus.Estop                                        := _data_in[30].%X5;
            Inputs.SystemStatus.Online                                       := _data_in[30].%X6;
            Inputs.SystemStatus.In_Hold                                      := _data_in[30].%X7;
            Inputs.SystemStatus.Good_Part                                    := _data_in[31].%X0;
            Inputs.SystemStatus.Bad_Part                                     := _data_in[31].%X1;
            Inputs.SystemStatus.Suspect_Part                                 := _data_in[31].%X2;
            Inputs.SystemStatus.CycleStartReject                             := _data_in[31].%X3;
            Inputs.SystemStatus.Amplitude_Regulation                         := _data_in[31].%X4;
            Inputs.SystemStatus.Power_Regulation                             := _data_in[31].%X5;
            Inputs.SystemStatus.Trigger_Status                               := _data_in[31].%X6;
            Inputs.SystemStatus.US_Status                                    := _data_in[31].%X7;

            _dword.%B3                                                          := _data_in[32];
            _dword.%B2                                                          := _data_in[33];
            _dword.%B1                                                          := _data_in[34];
            _dword.%B0                                                          := _data_in[35];
            Inputs.Temperature := TO_DINT(_dword);

            _dword.%B3                                                          := _data_in[36];
            _dword.%B2                                                          := _data_in[37];
            _dword.%B1                                                          := _data_in[38];
            _dword.%B0                                                          := _data_in[39];
            Inputs.CycleCount := TO_DINT(_dword);

            _dword.%B3                                                          := _data_in[40];
            _dword.%B2                                                          := _data_in[41];
            _dword.%B1                                                          := _data_in[42];
            _dword.%B0                                                          := _data_in[43];
            Inputs.GoodPartCount := TO_DINT(_dword);

            _dword.%B3                                                          := _data_in[44];
            _dword.%B2                                                          := _data_in[45];
            _dword.%B1                                                          := _data_in[46];
            _dword.%B0                                                          := _data_in[47];
            Inputs.BadPartCount := TO_DINT(_dword);

            _dword.%B3                                                          := _data_in[48];
            _dword.%B2                                                          := _data_in[49];
            _dword.%B1                                                          := _data_in[50];
            _dword.%B0                                                          := _data_in[51];
            Inputs.SuspectPartCount := TO_DINT(_dword);

            _dword.%B3                                                          := _data_in[52];
            _dword.%B2                                                          := _data_in[53];
            _dword.%B1                                                          := _data_in[54];
            _dword.%B0                                                          := _data_in[55];
            Inputs.AbortedPartCount := TO_DINT(_dword);

            Inputs.CyclePartStatus.LowerBadEnergyLimit                       := _data_in[56].%X0;
            Inputs.CyclePartStatus.LowerSuspectEnergyLimit                   := _data_in[56].%X1;
            Inputs.CyclePartStatus.UpperSuspectEnergyLimit                   := _data_in[56].%X2;
            Inputs.CyclePartStatus.UpperBadEnergyLimit                       := _data_in[56].%X3;
            // Inputs.CyclePartStatus._4                                        := _data_in[56].%X4;
            // Inputs.CyclePartStatus._5                                        := _data_in[56].%X5;
            // Inputs.CyclePartStatus._6                                        := _data_in[56].%X6;
            // Inputs.CyclePartStatus._7                                        := _data_in[56].%X7;
            Inputs.CyclePartStatus.LowerBadPowerLimit                        := _data_in[57].%X0;
            Inputs.CyclePartStatus.LowerSuspectPowerLimit                    := _data_in[57].%X1;
            Inputs.CyclePartStatus.UpperSuspectPowerLimit                    := _data_in[57].%X2;
            Inputs.CyclePartStatus.UpperBadPowerLimit                        := _data_in[57].%X3;
            // Inputs.CyclePartStatus._12                                       := _data_in[57].%X4;
            // Inputs.CyclePartStatus._13                                       := _data_in[57].%X5;
            // Inputs.CyclePartStatus._14                                       := _data_in[57].%X6;
            // Inputs.CyclePartStatus._15                                       := _data_in[57].%X7;
            Inputs.CyclePartStatus.LowerBadTimeLimit                         := _data_in[58].%X0;
            Inputs.CyclePartStatus.LowerSuspectTimeLimit                     := _data_in[58].%X1;
            Inputs.CyclePartStatus.UpperSuspectTimeLimit                     := _data_in[58].%X2;
            Inputs.CyclePartStatus.UpperBadTimeLimit                         := _data_in[58].%X3;
            // Inputs.CyclePartStatus._20                                       := _data_in[58].%X4;
            // Inputs.CyclePartStatus._21                                       := _data_in[58].%X5;
            // Inputs.CyclePartStatus._22                                       := _data_in[58].%X6;
            // Inputs.CyclePartStatus._23                                       := _data_in[58].%X7;
            Inputs.CyclePartStatus.GoodPart                                  := _data_in[59].%X0;
            Inputs.CyclePartStatus.BadPart                                   := _data_in[59].%X1;
            Inputs.CyclePartStatus.SuspectPart                               := _data_in[59].%X2;
            // Inputs.CyclePartStatus._27                                       := _data_in[59].%X3;
            // Inputs.CyclePartStatus._28                                       := _data_in[59].%X4;
            // Inputs.CyclePartStatus._29                                       := _data_in[59].%X5;
            // Inputs.CyclePartStatus._30                                       := _data_in[59].%X6;
            // Inputs.CyclePartStatus._31                                       := _data_in[59].%X7;

            _dword.%B3                                                          := _data_in[60];
            _dword.%B2                                                          := _data_in[61];
            _dword.%B1                                                          := _data_in[62];
            _dword.%B0                                                          := _data_in[63];
            Inputs.CycleWeldTime := TO_DINT(_dword);

            _dword.%B3                                                          := _data_in[64];
            _dword.%B2                                                          := _data_in[65];
            _dword.%B1                                                          := _data_in[66];
            _dword.%B0                                                          := _data_in[67];
            Inputs.CycleWeldPeakPower := TO_DINT(_dword);

            _dword.%B3                                                          := _data_in[68];
            _dword.%B2                                                          := _data_in[69];
            _dword.%B1                                                          := _data_in[70];
            _dword.%B0                                                          := _data_in[71];
            Inputs.CycleWeldEnergy := TO_DINT(_dword);

            _dword.%B3                                                          := _data_in[72];
            _dword.%B2                                                          := _data_in[73];
            _dword.%B1                                                          := _data_in[74];
            _dword.%B0                                                          := _data_in[75];
            Inputs.ActiveSetup := TO_DINT(_dword);

            _dword.%B3                                                          := _data_in[76];
            _dword.%B2                                                          := _data_in[77];
            _dword.%B1                                                          := _data_in[78];
            _dword.%B0                                                          := _data_in[79];
            Inputs.RunningSetup := TO_DINT(_dword);

            _dword.%B3                                                          := _data_in[80];
            _dword.%B2                                                          := _data_in[81];
            _dword.%B1                                                          := _data_in[82];
            _dword.%B0                                                          := _data_in[83];
            Inputs.RunningMPCProbe := TO_DINT(_dword);

            _dword.%B3                                                          := _data_in[84];
            _dword.%B2                                                          := _data_in[85];
            _dword.%B1                                                          := _data_in[86];
            _dword.%B0                                                          := _data_in[87];
            Inputs.SelectedInputVoltage := TO_DINT(_dword);

            _dword.%B3                                                          := _data_in[88];
            _dword.%B2                                                          := _data_in[89];
            _dword.%B1                                                          := _data_in[90];
            _dword.%B0                                                          := _data_in[91];
            Inputs.RealTimePosition := TO_DINT(_dword);

            _dword.%B3                                                          := _data_in[92];
            _dword.%B2                                                          := _data_in[93];
            _dword.%B1                                                          := _data_in[94];
            _dword.%B0                                                          := _data_in[95];
            Inputs.RealTimeVelocity := TO_DINT(_dword);

            Inputs.PressPartStatus_Bad_lo.Weld1Position                      := _data_in[96].%X0;
            Inputs.PressPartStatus_Bad_lo.ErrorStatus                        := _data_in[96].%X1;
            // Inputs.PressPartStatus_Bad_lo._26                                := _data_in[96].%X2;
            // Inputs.PressPartStatus_Bad_lo._27                                := _data_in[96].%X3;
            // Inputs.PressPartStatus_Bad_lo._28                                := _data_in[96].%X4;
            // Inputs.PressPartStatus_Bad_lo._29                                := _data_in[96].%X5;
            // Inputs.PressPartStatus_Bad_lo._30                                := _data_in[96].%X6;
            // Inputs.PressPartStatus_Bad_lo._31                                := _data_in[96].%X7;
            Inputs.PressPartStatus_Bad_lo.TotalWeldTime                      := _data_in[97].%X0;
            Inputs.PressPartStatus_Bad_lo.TotalWeldDistance                  := _data_in[97].%X1;
            Inputs.PressPartStatus_Bad_lo.TotalWeldEnergy                    := _data_in[97].%X2;
            Inputs.PressPartStatus_Bad_lo.HoldTime                           := _data_in[97].%X3;
            Inputs.PressPartStatus_Bad_lo.HoldDistance                       := _data_in[97].%X4;
            Inputs.PressPartStatus_Bad_lo.TotalCycleTime                     := _data_in[97].%X5;
            Inputs.PressPartStatus_Bad_lo.FinalHoldPosition                  := _data_in[97].%X6;
            Inputs.PressPartStatus_Bad_lo.Weld1PeakForce                     := _data_in[97].%X7;
            Inputs.PressPartStatus_Bad_lo.Weld1Distance                      := _data_in[98].%X0;
            Inputs.PressPartStatus_Bad_lo.Weld1Energy                        := _data_in[98].%X1;
            Inputs.PressPartStatus_Bad_lo.Weld1Power                         := _data_in[98].%X2;
            Inputs.PressPartStatus_Bad_lo.Weld2Time                          := _data_in[98].%X3;
            Inputs.PressPartStatus_Bad_lo.Weld2Distance                      := _data_in[98].%X4;
            Inputs.PressPartStatus_Bad_lo.Weld2Energy                        := _data_in[98].%X5;
            Inputs.PressPartStatus_Bad_lo.Weld2Power                         := _data_in[98].%X6;
            Inputs.PressPartStatus_Bad_lo.Weld2Position                      := _data_in[98].%X7;
            Inputs.PressPartStatus_Bad_lo.TriggerTime                        := _data_in[99].%X0;
            Inputs.PressPartStatus_Bad_lo.TriggerPosition                    := _data_in[99].%X1;
            Inputs.PressPartStatus_Bad_lo.AverageSensingVelocity             := _data_in[99].%X2;
            Inputs.PressPartStatus_Bad_lo.TriggerPressure                    := _data_in[99].%X3;
            Inputs.PressPartStatus_Bad_lo.TriggerForce                       := _data_in[99].%X4;
            Inputs.PressPartStatus_Bad_lo.TriggerDelayTime                   := _data_in[99].%X5;
            Inputs.PressPartStatus_Bad_lo.TriggerDelayDistance               := _data_in[99].%X6;
            Inputs.PressPartStatus_Bad_lo.Weld1Time                          := _data_in[99].%X7;

            Inputs.PressPartStatus_Sus_lo.Weld1Position                      := _data_in[100].%X0;
            Inputs.PressPartStatus_Sus_lo.ErrorStatus                        := _data_in[100].%X1;
            // Inputs.PressPartStatus_Sus_lo._26                                := _data_in[100].%X2;
            // Inputs.PressPartStatus_Sus_lo._27                                := _data_in[100].%X3;
            // Inputs.PressPartStatus_Sus_lo._28                                := _data_in[100].%X4;
            // Inputs.PressPartStatus_Sus_lo._29                                := _data_in[100].%X5;
            // Inputs.PressPartStatus_Sus_lo._30                                := _data_in[100].%X6;
            // Inputs.PressPartStatus_Sus_lo._31                                := _data_in[100].%X7;
            Inputs.PressPartStatus_Sus_lo.TotalWeldTime                      := _data_in[101].%X0;
            Inputs.PressPartStatus_Sus_lo.TotalWeldDistance                  := _data_in[101].%X1;
            Inputs.PressPartStatus_Sus_lo.TotalWeldEnergy                    := _data_in[101].%X2;
            Inputs.PressPartStatus_Sus_lo.HoldTime                           := _data_in[101].%X3;
            Inputs.PressPartStatus_Sus_lo.HoldDistance                       := _data_in[101].%X4;
            Inputs.PressPartStatus_Sus_lo.TotalCycleTime                     := _data_in[101].%X5;
            Inputs.PressPartStatus_Sus_lo.FinalHoldPosition                  := _data_in[101].%X6;
            Inputs.PressPartStatus_Sus_lo.Weld1PeakForce                     := _data_in[101].%X7;
            Inputs.PressPartStatus_Sus_lo.Weld1Distance                      := _data_in[102].%X0;
            Inputs.PressPartStatus_Sus_lo.Weld1Energy                        := _data_in[102].%X1;
            Inputs.PressPartStatus_Sus_lo.Weld1Power                         := _data_in[102].%X2;
            Inputs.PressPartStatus_Sus_lo.Weld2Time                          := _data_in[102].%X3;
            Inputs.PressPartStatus_Sus_lo.Weld2Distance                      := _data_in[102].%X4;
            Inputs.PressPartStatus_Sus_lo.Weld2Energy                        := _data_in[102].%X5;
            Inputs.PressPartStatus_Sus_lo.Weld2Power                         := _data_in[102].%X6;
            Inputs.PressPartStatus_Sus_lo.Weld2Position                      := _data_in[102].%X7;
            Inputs.PressPartStatus_Sus_lo.TriggerTime                        := _data_in[103].%X0;
            Inputs.PressPartStatus_Sus_lo.TriggerPosition                    := _data_in[103].%X1;
            Inputs.PressPartStatus_Sus_lo.AverageSensingVelocity             := _data_in[103].%X2;
            Inputs.PressPartStatus_Sus_lo.TriggerPressure                    := _data_in[103].%X3;
            Inputs.PressPartStatus_Sus_lo.TriggerForce                       := _data_in[103].%X4;
            Inputs.PressPartStatus_Sus_lo.TriggerDelayTime                   := _data_in[103].%X5;
            Inputs.PressPartStatus_Sus_lo.TriggerDelayDistance               := _data_in[103].%X6;
            Inputs.PressPartStatus_Sus_lo.Weld1Time                          := _data_in[103].%X7;

            Inputs.PressPartStatus_Sus_hi.Weld1Position                      := _data_in[104].%X0;
            Inputs.PressPartStatus_Sus_hi.ErrorStatus                        := _data_in[104].%X1;
            // Inputs.PressPartStatus_Sus_hi._26                                := _data_in[104].%X2;
            // Inputs.PressPartStatus_Sus_hi._27                                := _data_in[104].%X3;
            // Inputs.PressPartStatus_Sus_hi._28                                := _data_in[104].%X4;
            // Inputs.PressPartStatus_Sus_hi._29                                := _data_in[104].%X5;
            // Inputs.PressPartStatus_Sus_hi._30                                := _data_in[104].%X6;
            // Inputs.PressPartStatus_Sus_hi._31                                := _data_in[104].%X7;
            Inputs.PressPartStatus_Sus_hi.TotalWeldTime                      := _data_in[105].%X0;
            Inputs.PressPartStatus_Sus_hi.TotalWeldDistance                  := _data_in[105].%X1;
            Inputs.PressPartStatus_Sus_hi.TotalWeldEnergy                    := _data_in[105].%X2;
            Inputs.PressPartStatus_Sus_hi.HoldTime                           := _data_in[105].%X3;
            Inputs.PressPartStatus_Sus_hi.HoldDistance                       := _data_in[105].%X4;
            Inputs.PressPartStatus_Sus_hi.TotalCycleTime                     := _data_in[105].%X5;
            Inputs.PressPartStatus_Sus_hi.FinalHoldPosition                  := _data_in[105].%X6;
            Inputs.PressPartStatus_Sus_hi.Weld1PeakForce                     := _data_in[105].%X7;
            Inputs.PressPartStatus_Sus_hi.Weld1Distance                      := _data_in[106].%X0;
            Inputs.PressPartStatus_Sus_hi.Weld1Energy                        := _data_in[106].%X1;
            Inputs.PressPartStatus_Sus_hi.Weld1Power                         := _data_in[106].%X2;
            Inputs.PressPartStatus_Sus_hi.Weld2Time                          := _data_in[106].%X3;
            Inputs.PressPartStatus_Sus_hi.Weld2Distance                      := _data_in[106].%X4;
            Inputs.PressPartStatus_Sus_hi.Weld2Energy                        := _data_in[106].%X5;
            Inputs.PressPartStatus_Sus_hi.Weld2Power                         := _data_in[106].%X6;
            Inputs.PressPartStatus_Sus_hi.Weld2Position                      := _data_in[106].%X7;
            Inputs.PressPartStatus_Sus_hi.TriggerTime                        := _data_in[107].%X0;
            Inputs.PressPartStatus_Sus_hi.TriggerPosition                    := _data_in[107].%X1;
            Inputs.PressPartStatus_Sus_hi.AverageSensingVelocity             := _data_in[107].%X2;
            Inputs.PressPartStatus_Sus_hi.TriggerPressure                    := _data_in[107].%X3;
            Inputs.PressPartStatus_Sus_hi.TriggerForce                       := _data_in[107].%X4;
            Inputs.PressPartStatus_Sus_hi.TriggerDelayTime                   := _data_in[107].%X5;
            Inputs.PressPartStatus_Sus_hi.TriggerDelayDistance               := _data_in[107].%X6;
            Inputs.PressPartStatus_Sus_hi.Weld1Time                          := _data_in[107].%X7;

            Inputs.PressPartStatus_Bad_hi.Weld1Position                      := _data_in[108].%X0;
            Inputs.PressPartStatus_Bad_hi.ErrorStatus                        := _data_in[108].%X1;
            // Inputs.PressPartStatus_Bad_hi._26                                := _data_in[108].%X2;
            // Inputs.PressPartStatus_Bad_hi._27                                := _data_in[108].%X3;
            // Inputs.PressPartStatus_Bad_hi._28                                := _data_in[108].%X4;
            // Inputs.PressPartStatus_Bad_hi._29                                := _data_in[108].%X5;
            // Inputs.PressPartStatus_Bad_hi._30                                := _data_in[108].%X6;
            // Inputs.PressPartStatus_Bad_hi._31                                := _data_in[108].%X7;
            Inputs.PressPartStatus_Bad_hi.TotalWeldTime                      := _data_in[109].%X0;
            Inputs.PressPartStatus_Bad_hi.TotalWeldDistance                  := _data_in[109].%X1;
            Inputs.PressPartStatus_Bad_hi.TotalWeldEnergy                    := _data_in[109].%X2;
            Inputs.PressPartStatus_Bad_hi.HoldTime                           := _data_in[109].%X3;
            Inputs.PressPartStatus_Bad_hi.HoldDistance                       := _data_in[109].%X4;
            Inputs.PressPartStatus_Bad_hi.TotalCycleTime                     := _data_in[109].%X5;
            Inputs.PressPartStatus_Bad_hi.FinalHoldPosition                  := _data_in[109].%X6;
            Inputs.PressPartStatus_Bad_hi.Weld1PeakForce                     := _data_in[109].%X7;
            Inputs.PressPartStatus_Bad_hi.Weld1Distance                      := _data_in[110].%X0;
            Inputs.PressPartStatus_Bad_hi.Weld1Energy                        := _data_in[110].%X1;
            Inputs.PressPartStatus_Bad_hi.Weld1Power                         := _data_in[110].%X2;
            Inputs.PressPartStatus_Bad_hi.Weld2Time                          := _data_in[110].%X3;
            Inputs.PressPartStatus_Bad_hi.Weld2Distance                      := _data_in[110].%X4;
            Inputs.PressPartStatus_Bad_hi.Weld2Energy                        := _data_in[110].%X5;
            Inputs.PressPartStatus_Bad_hi.Weld2Power                         := _data_in[110].%X6;
            Inputs.PressPartStatus_Bad_hi.Weld2Position                      := _data_in[110].%X7;
            Inputs.PressPartStatus_Bad_hi.TriggerTime                        := _data_in[111].%X0;
            Inputs.PressPartStatus_Bad_hi.TriggerPosition                    := _data_in[111].%X1;
            Inputs.PressPartStatus_Bad_hi.AverageSensingVelocity             := _data_in[111].%X2;
            Inputs.PressPartStatus_Bad_hi.TriggerPressure                    := _data_in[111].%X3;
            Inputs.PressPartStatus_Bad_hi.TriggerForce                       := _data_in[111].%X4;
            Inputs.PressPartStatus_Bad_hi.TriggerDelayTime                   := _data_in[111].%X5;
            Inputs.PressPartStatus_Bad_hi.TriggerDelayDistance               := _data_in[111].%X6;
            Inputs.PressPartStatus_Bad_hi.Weld1Time                          := _data_in[111].%X7;


            _dword.%B3                                                          := _data_in[112];
            _dword.%B2                                                          := _data_in[113];
            _dword.%B1                                                          := _data_in[114];
            _dword.%B0                                                          := _data_in[115];
            Inputs.CycleTriggerTime := TO_DINT(_dword);

            _dword.%B3                                                          := _data_in[116];
            _dword.%B2                                                          := _data_in[117];
            _dword.%B1                                                          := _data_in[118];
            _dword.%B0                                                          := _data_in[119];
            Inputs.CycleTriggerPosition := TO_DINT(_dword);

            _dword.%B3                                                          := _data_in[120];
            _dword.%B2                                                          := _data_in[121];
            _dword.%B1                                                          := _data_in[122];
            _dword.%B0                                                          := _data_in[123];
            Inputs.CycleTriggerDelayTime := TO_DINT(_dword);

            _dword.%B3                                                          := _data_in[124];
            _dword.%B2                                                          := _data_in[125];
            _dword.%B1                                                          := _data_in[126];
            _dword.%B0                                                          := _data_in[127];
            Inputs.CycleTriggerDelayDistance := TO_DINT(_dword);

            _dword.%B3                                                          := _data_in[128];
            _dword.%B2                                                          := _data_in[129];
            _dword.%B1                                                          := _data_in[130];
            _dword.%B0                                                          := _data_in[131];
            Inputs.CycleWeld1Distance := TO_DINT(_dword);

            _dword.%B3                                                          := _data_in[132];
            _dword.%B2                                                          := _data_in[133];
            _dword.%B1                                                          := _data_in[134];
            _dword.%B0                                                          := _data_in[135];
            Inputs.CycleWeld1Position := TO_DINT(_dword);

            _dword.%B3                                                          := _data_in[136];
            _dword.%B2                                                          := _data_in[137];
            _dword.%B1                                                          := _data_in[138];
            _dword.%B0                                                          := _data_in[139];
            Inputs.CycleTotalTime := TO_DINT(_dword);


            //*************INITIALIZATION*************
            RestoreTask.Run(THIS);
            ClearErrorTask.Run(THIS);
            ChangeWeldingSetupTask.Run(THIS);
            ChangeWeldingProbeTask.Run(THIS);
            CycleStopTask.Run(THIS);
            RunWeldingWithTimeTask.Run(THIS);
    
            //****************************************

            //********************Diagnostics*********        
            HardwareDiagnosticsTask.Run(THIS,Config.HWIDs.HW_Device);
            //****************************************
            _blink.Blink(THIS,T#500MS,T#500MS);
            //*************RESTORE********************
            RestoreTask.SetIsDisabled(FALSE);
            IF RestoreTask.Execute(THIS) THEN
                THIS.Restore();
            END_IF;
            //****************************************
    
            //*************ClearErrorTask**************
            ClearErrorTask.SetIsDisabled(FALSE);
            IF ClearErrorTask.StartTriggered() THEN
                Status.Action.Id :=  UINT#100;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#100,ClearErrorTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#101,ClearErrorTask.IsDone(), eAxoMessageCategory#Info);
            IF ClearErrorTask.Execute(THIS) THEN
                IF _progress = 0 THEN
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 300;
                END_IF;
                // ClearErrorTask running: waiting for the error flag is reseted.
                IF _progress = 300 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#500, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#500;
                    END_IF;
                    Outputs.ClearError := _blink.output;
                    IF NOT Inputs.SystemStatus.Any_Fault THEN
                        Outputs.ClearError := FALSE;                    
                        THIS.CallTimers(FALSE);
                        _progress := 301;
                    END_IF;
                END_IF;
                // ClearErrorTask finished.
                IF _progress = 301 THEN         
                    ClearErrorTask.DoneWhen(TRUE);
                    _progress := 0;
                END_IF;
    
                THIS.CallTimers(TRUE);
                
                ClearErrorTask.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);  
                ClearErrorTask.ThrowWhen(ClearErrorTask.Duration >= Config.TaskTimeout AND Config.TaskTimeout > T#0s ,'<#ClearErrorTask timeout.#>');                
            END_IF;
            IF ClearErrorTask.DoneReached() THEN
                Status.Action.Id :=  UINT#101;
                Status.Error.Id :=  UINT#0;
            ELSIF ClearErrorTask.ErrorOccured() THEN
                Status.Action.Id :=  UINT#10000;
                Status.Error.Id  :=  UINT#10000;
            ELSIF ClearErrorTask.AbortTriggered()THEN
                Status.Action.Id :=  UINT#10001;
                Status.Error.Id  :=  UINT#10001;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#10000,ClearErrorTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#10001,ClearErrorTask.IsAborted(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#102,ClearErrorTask.RestoreTriggered() , eAxoMessageCategory#Info);
            IF ClearErrorTask.RestoreTriggered() AND _progress >= 300 AND _progress <= 309  THEN
                Status.Action.Id :=  UINT#102;
                _progress := 0;
            END_IF;
            //**************************************************
    
            //*************ChangeWeldingSetupTask***************
            ChangeWeldingSetupTask.SetIsDisabled(FALSE);
            IF ChangeWeldingSetupTask.StartTriggered() THEN
                Status.Action.Id :=  UINT#110;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#110,ChangeWeldingSetupTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#111,ChangeWeldingSetupTask.IsDone(), eAxoMessageCategory#Info);
            IF ChangeWeldingSetupTask.Execute(THIS) THEN
                IF _progress = 0 THEN
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 310;
                END_IF;
                // ChangeWeldingSetupTask running: validating required setup number.
                IF _progress = 310 THEN
                    IF _setupNumber >= UINT#1 AND _setupNumber<= UINT#16 THEN
                        THIS.CallTimers(FALSE);
                        _progress := 311;
                    ELSE
                        TaskMessenger.Activate( UINT#510, eAxoMessageCategory#Error);
                        Status.Error.Id :=      UINT#510;
                    END_IF;
                END_IF;
                // ChangeWeldingSetupTask running: changing active setup selected.
                IF _progress = 311 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#511, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#511;
                    END_IF;

                    THIS.Outputs.ActiveSetupSelection := _setupNumber;
                    THIS.Outputs.RunningSetupSelection := _setupNumber;

                    IF THIS.Outputs.ActiveSetupSelection = THIS.Inputs.ActiveSetup THEN
                        THIS.CallTimers(FALSE);
                        _progress := 312;
                    END_IF;
                END_IF;
                // ChangeWeldingSetupTask running: changing running setup selected.
                IF _progress = 312 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#512, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#512;
                    END_IF;

                    THIS.Outputs.ActiveSetupSelection := _setupNumber;
                    THIS.Outputs.RunningSetupSelection := _setupNumber;

                    IF THIS.Outputs.RunningSetupSelection = THIS.Inputs.RunningSetup THEN
                        THIS.CallTimers(FALSE);
                        _progress := 313;
                    END_IF;
                END_IF;
                // ChangeWeldingSetupTask finished.
                IF _progress = 313 THEN
                    ChangeWeldingSetupTask.DoneWhen(TRUE);
                    _progress := 0;
                END_IF;
    
                THIS.CallTimers(TRUE);
                
                ChangeWeldingSetupTask.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);  
                ChangeWeldingSetupTask.ThrowWhen(ChangeWeldingSetupTask.Duration >= Config.TaskTimeout AND Config.TaskTimeout > T#0s ,'<#ChangeWeldingSetupTask timeout.#>');                
            END_IF;
            IF ChangeWeldingSetupTask.DoneReached() THEN
                Status.Action.Id :=  UINT#111;
                Status.Error.Id :=  UINT#0;
            ELSIF ChangeWeldingSetupTask.ErrorOccured() THEN
                Status.Action.Id :=  UINT#10010;
                Status.Error.Id  :=  UINT#10010;
            ELSIF ChangeWeldingSetupTask.AbortTriggered()THEN
                Status.Action.Id :=  UINT#10011;
                Status.Error.Id  :=  UINT#10011;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#10010,ChangeWeldingSetupTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#10011,ChangeWeldingSetupTask.IsAborted(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#112,ChangeWeldingSetupTask.RestoreTriggered() , eAxoMessageCategory#Info);
            IF ChangeWeldingSetupTask.RestoreTriggered() AND _progress >= 310 AND _progress <= 319  THEN
                Status.Action.Id :=  UINT#112;
                _progress := 0;
            END_IF;
            //**************************************************
    
            //*************ChangeWeldingProbeTask***************
            ChangeWeldingProbeTask.SetIsDisabled(FALSE);
            IF ChangeWeldingProbeTask.StartTriggered() THEN
                Status.Action.Id :=  UINT#120;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#120,ChangeWeldingProbeTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#121,ChangeWeldingProbeTask.IsDone(), eAxoMessageCategory#Info);
            IF ChangeWeldingProbeTask.Execute(THIS) THEN
                IF _progress = 0 THEN
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 320;
                END_IF;
                // ChangeWeldingProbeTask running: validating required probe number.
                IF _progress = 320 THEN
                    IF _probeNumber >= UINT#1 AND _probeNumber<= UINT#16 THEN
                        THIS.CallTimers(FALSE);
                        _progress := 321;
                    ELSE
                        TaskMessenger.Activate( UINT#520, eAxoMessageCategory#Error);
                        Status.Error.Id :=      UINT#520;
                    END_IF;
                END_IF;
                // ChangeWeldingProbeTask running: changing running probe selected..
                IF _progress = 321 THEN   
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#521, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#521;
                    END_IF;

                    THIS.Outputs.RunningMPCProbeSelection  := _probeNumber;

                    IF THIS.Outputs.RunningMPCProbeSelection = THIS.Inputs.RunningMPCProbe THEN
                        THIS.CallTimers(FALSE);
                        _progress := 322;
                    END_IF;
                END_IF;
                // ChangeWeldingProbeTask finished.
                IF _progress = 322 THEN
                    ChangeWeldingProbeTask.DoneWhen(TRUE);
                    _progress := 0;
                END_IF;
    
                THIS.CallTimers(TRUE);
                
                ChangeWeldingProbeTask.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);  
                ChangeWeldingProbeTask.ThrowWhen(ChangeWeldingProbeTask.Duration >= Config.TaskTimeout AND Config.TaskTimeout > T#0s ,'<#ChangeWeldingProbeTask timeout.#>');                
            END_IF;
            IF ChangeWeldingProbeTask.DoneReached() THEN
                Status.Action.Id :=  UINT#121;
                Status.Error.Id :=  UINT#0;
            ELSIF ChangeWeldingProbeTask.ErrorOccured() THEN
                Status.Action.Id :=  UINT#10020;
                Status.Error.Id  :=  UINT#10020;
            ELSIF ChangeWeldingProbeTask.AbortTriggered()THEN
                Status.Action.Id :=  UINT#10021;
                Status.Error.Id  :=  UINT#10021;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#10020,ChangeWeldingProbeTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#10021,ChangeWeldingProbeTask.IsAborted(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#122,ChangeWeldingProbeTask.RestoreTriggered() , eAxoMessageCategory#Info);
            IF ChangeWeldingProbeTask.RestoreTriggered() AND _progress >= 320 AND _progress <= 329  THEN
                Status.Action.Id :=  UINT#122;
                _progress := 0;
            END_IF;
            //**************************************************
    
            //*************CycleStopTask***************
            CycleStopTask.SetIsDisabled(FALSE);
            IF CycleStopTask.StartTriggered() THEN
                Status.Action.Id :=  UINT#130;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#130,CycleStopTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#131,CycleStopTask.IsDone(), eAxoMessageCategory#Info);
            IF CycleStopTask.Execute(THIS) THEN
                IF _progress = 0 THEN
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 330;
                END_IF;
                // CycleStopTask running: waiting for the cycle is finished.
                IF _progress = 330 THEN 
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#530, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#530;
                    END_IF;
    
                    Outputs.CycleStop := TRUE;

                    IF NOT Inputs.SystemStatus.InCycle THEN
                        Outputs.CycleStop := FALSE;
                        THIS.CallTimers(FALSE);
                        _progress := 331;
                    END_IF;
                END_IF;
                // CycleStopTask finished.
                IF _progress = 331 THEN
                    CycleStopTask.DoneWhen(TRUE);
                    _progress := 0;
                END_IF;
    
                THIS.CallTimers(TRUE);
                
                CycleStopTask.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);  
                CycleStopTask.ThrowWhen(CycleStopTask.Duration >= Config.TaskTimeout AND Config.TaskTimeout > T#0s ,'<#CycleStopTask timeout.#>');                
            END_IF;
            IF CycleStopTask.DoneReached() THEN
                Status.Action.Id :=  UINT#131;
                Status.Error.Id :=  UINT#0;
            ELSIF CycleStopTask.ErrorOccured() THEN
                Status.Action.Id :=  UINT#10030;
                Status.Error.Id  :=  UINT#10030;
            ELSIF CycleStopTask.AbortTriggered()THEN
                Status.Action.Id :=  UINT#10031;
                Status.Error.Id  :=  UINT#10031;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#10030,CycleStopTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#10031,CycleStopTask.IsAborted(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#132,CycleStopTask.RestoreTriggered() , eAxoMessageCategory#Info);
            IF CycleStopTask.RestoreTriggered() AND _progress >= 330 AND _progress <= 339  THEN
                Status.Action.Id :=  UINT#132;
                _progress := 0;
            END_IF;
            //**************************************************
    
            //*************RunWeldingWithTimeTask***************
            RunWeldingWithTimeTask.SetIsDisabled(FALSE);
            IF RunWeldingWithTimeTask.StartTriggered() THEN
                Status.Action.Id :=  UINT#140;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#140,RunWeldingWithTimeTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#141,RunWeldingWithTimeTask.IsDone(), eAxoMessageCategory#Info);
            IF RunWeldingWithTimeTask.Execute(THIS) THEN
                IF _progress = 0 THEN
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 340;
                END_IF;
                // RunWeldingWithTimeTask running: reseting the error.
                IF _progress = 340 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#540, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#540;
                    END_IF;

                    Outputs.ClearError := _blink.output;

                    IF NOT Inputs.SystemStatus.Any_Fault THEN
                        Outputs.ClearError := FALSE;                    
                        THIS.CallTimers(FALSE);
                        _progress := 341;
                    END_IF;
                END_IF;
                // RunWeldingWithTimeTask running: waiting for the system to be ready.
                IF _progress = 341 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#541, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#541;
                    END_IF;

                    IF Inputs.SystemStatus.Ready THEN
                        THIS.CallTimers(FALSE);
                        _progress := 342;
                    END_IF;
                END_IF;
                // RunWeldingWithTimeTask running: validating required setup number.
                IF _progress = 342 THEN
                    IF _setupNumber >= UINT#1 AND _setupNumber<= UINT#16 THEN
                        THIS.CallTimers(FALSE);
                        _progress := 343;
                    ELSE
                        TaskMessenger.Activate( UINT#542, eAxoMessageCategory#Error);
                        Status.Error.Id :=      UINT#542;
                    END_IF;
                END_IF;
                // RunWeldingWithTimeTask running: changing active setup selected.
                IF _progress = 343 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#543, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#543;
                    END_IF;

                    THIS.Outputs.ActiveSetupSelection := _setupNumber;
                    THIS.Outputs.RunningSetupSelection := _setupNumber;

                    IF THIS.Outputs.ActiveSetupSelection = THIS.Inputs.ActiveSetup THEN
                        THIS.CallTimers(FALSE);
                        _progress := 344;
                    END_IF;
                END_IF;
                // RunWeldingWithTimeTask running: changing running setup selected.
                IF _progress = 344 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#544, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#544;
                    END_IF;

                    THIS.Outputs.ActiveSetupSelection := _setupNumber;
                    THIS.Outputs.RunningSetupSelection := _setupNumber;

                    IF THIS.Outputs.RunningSetupSelection = THIS.Inputs.RunningSetup THEN
                        THIS.CallTimers(FALSE);
                        _progress := 345;
                    END_IF;
                END_IF;
                // RunWeldingWithTimeTask running: changing running probe selected.
                IF _progress = 345 THEN     
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#545, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#545;
                    END_IF;
                    
                    THIS.Outputs.RunningMPCProbeSelection  := _probeNumber;

                    IF THIS.Outputs.RunningMPCProbeSelection = THIS.Inputs.RunningMPCProbe THEN
                        THIS.CallTimers(FALSE);
                        _progress := 346;
                    END_IF;
                END_IF;
                // RunWeldingWithTimeTask running: starting the welding cycle.
                IF _progress = 346 THEN 
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#546, eAxoMessageCategory#Potential);
                        Status.Error.Id :=      UINT#546;
                    END_IF;
                    
                    _weldingTimer.OnDelay(THIS,FALSE,T#0S);

                    Outputs.RunContinuously := TRUE;
                    
                    IF Inputs.SystemStatus.InCycle THEN
                        THIS.CallTimers(FALSE);
                        _progress := 347;
                    END_IF;
                END_IF;
                // RunWeldingWithTimeTask running: welding cycle running.
                IF _progress = 347 THEN  
                    _weldingTimer.OnDelay(THIS,TRUE,_weldingTime);

                    IF _weldingTimer.output THEN
                        _weldingTimer.OnDelay(THIS,FALSE,T#0S);
                        THIS.CallTimers(FALSE);
                        _progress := 348;
                    END_IF;
                END_IF;
                // RunWeldingWithTimeTask running: stopping the welding cycle.
                IF _progress = 348 THEN 
                    IF _infoTimer.output THEN
                        IF Inputs.SystemStatus.InCycle THEN
                            TaskMessenger.Activate( UINT#548, eAxoMessageCategory#Potential);
                            Status.Error.Id :=      UINT#548;
                        ELSIF NOT Inputs.SystemStatus.Ready THEN
                            TaskMessenger.Activate( UINT#549, eAxoMessageCategory#Potential);
                            Status.Error.Id :=      UINT#549;
                        END_IF;
                    END_IF;
    
                    Outputs.RunContinuously := FALSE;
                    Outputs.CycleStop := TRUE;
                    IF NOT Inputs.SystemStatus.InCycle AND Inputs.SystemStatus.Ready THEN
                        Outputs.CycleStop := FALSE;
                        THIS.CallTimers(FALSE);
                        _progress := 349;
                    END_IF;
                END_IF;
                // RunWeldingWithTimeTask finished
                IF _progress = 349 THEN 
                    RunWeldingWithTimeTask.DoneWhen(TRUE);
                    _progress := 0;
                END_IF;
    
                THIS.CallTimers(TRUE);
                
                RunWeldingWithTimeTask.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);  
                RunWeldingWithTimeTask.ThrowWhen(RunWeldingWithTimeTask.Duration >= Config.TaskTimeout AND Config.TaskTimeout > T#0s ,'<#RunWeldingWithTimeTask timeout.#>');                
            END_IF;
            IF RunWeldingWithTimeTask.DoneReached() THEN
                Status.Action.Id :=  UINT#141;
                Status.Error.Id :=  UINT#0;
            ELSIF RunWeldingWithTimeTask.ErrorOccured() THEN
                Status.Action.Id :=  UINT#10040;
                Status.Error.Id  :=  UINT#10040;
            ELSIF RunWeldingWithTimeTask.AbortTriggered()THEN
                Status.Action.Id :=  UINT#10041;
                Status.Error.Id  :=  UINT#10041;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#10040,RunWeldingWithTimeTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#10041,RunWeldingWithTimeTask.IsAborted(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#142,RunWeldingWithTimeTask.RestoreTriggered() , eAxoMessageCategory#Info);
            IF RunWeldingWithTimeTask.RestoreTriggered() AND _progress >= 340 AND _progress <= 349  THEN
                Status.Action.Id :=  UINT#142;
                _progress := 0;
            END_IF;
            //**************************************************

            //***********Update outputs ****************
            // _data_out[0].%X0    :=  Outputs.N0;
            // _data_out[0].%X1    :=  Outputs.N01;
            // _data_out[0].%X2    :=  Outputs.N02;
            // _data_out[0].%X3    :=  Outputs.N03;
            // _data_out[0].%X4    :=  Outputs.N04;
            // _data_out[0].%X5    :=  Outputs.N05;
            // _data_out[0].%X6    :=  Outputs.N06;
            _data_out[0].%X7    :=  Outputs.ClearSetup;
            // _data_out[1].%X0    :=  Outputs.N2;
            // _data_out[1].%X1    :=  Outputs.N3;
            // _data_out[1].%X2    :=  Outputs.N4;
            // _data_out[1].%X3    :=  Outputs.N5;
            // _data_out[1].%X4    :=  Outputs.N6;
            // _data_out[1].%X5    :=  Outputs.N7;
            // _data_out[1].%X6    :=  Outputs.N8;
            // _data_out[1].%X7    :=  Outputs.N9;
            _data_out[2].%X0    :=  Outputs.RunScan;
            // _data_out[2].%X1    :=  Outputs.N11;
            // _data_out[2].%X2    :=  Outputs.N12;
            // _data_out[2].%X3    :=  Outputs.N13;
            // _data_out[2].%X4    :=  Outputs.N14;
            // _data_out[2].%X5    :=  Outputs.N15;
            // _data_out[2].%X6    :=  Outputs.N16;
            // _data_out[2].%X7    :=  Outputs.N17;
            _data_out[3].%X0    :=  Outputs.RunContinuously;
            _data_out[3].%X1    :=  Outputs.RunWeld;
            _data_out[3].%X2    :=  Outputs.RunTest;
            _data_out[3].%X3    :=  Outputs.ClearError;
            _data_out[3].%X4    :=  Outputs.OTF_AmplitudeEnable;
            _data_out[3].%X5    :=  Outputs.CycleStop;
            _data_out[3].%X6    :=  Outputs.FrontPanelLockout_0;
            _data_out[3].%X7    :=  Outputs.FrontPanelLockout_1;

            _dword              :=  TO_DWORD(Outputs.OTF_Amp_Setpoint); 
            _data_out[4]        :=  _dword.%B3;
            _data_out[5]        :=  _dword.%B2;
            _data_out[6]        :=  _dword.%B1;
            _data_out[7]        :=  _dword.%B0;

            _dword              :=  TO_DWORD(Outputs.ActiveSetupSelection); 
            _data_out[8]        :=  _dword.%B3;
            _data_out[9]        :=  _dword.%B2;
            _data_out[10]       :=  _dword.%B1;
            _data_out[11]       :=  _dword.%B0;

            _dword              :=  TO_DWORD(Outputs.RunningSetupSelection); 
            _data_out[12]       :=  _dword.%B3;
            _data_out[13]       :=  _dword.%B2;
            _data_out[14]       :=  _dword.%B1;
            _data_out[15]       :=  _dword.%B0;

            _dword              :=  TO_DWORD(Outputs.RunningMPCProbeSelection); 
            _data_out[16]       :=  _dword.%B3;
            _data_out[17]       :=  _dword.%B2;
            _data_out[18]       :=  _dword.%B1;
            _data_out[19]       :=  _dword.%B0;

            _retval := WriteData(Config.HWIDs.HwID_PLC_to_iQ_Outputs,_data_out);
            IF _retval > WORD#0 THEN
                Messenger.Activate(UINT#1231, eAxoMessageCategory#Error);
                Status.Error.Id := UINT#1231;
                RETURN;
            END_IF;            
        END_METHOD

        METHOD PUBLIC ClearError : IAxoTaskState
            ClearError := ClearErrorTask.Invoke(THIS);
        END_METHOD

        METHOD PUBLIC ChangeWeldingSetup : IAxoTaskState
            VAR_INPUT
                SetupNumber : UINT;
            END_VAR
            _setupNumber := SetupNumber;
            ChangeWeldingSetup := ChangeWeldingSetupTask.Invoke(THIS);
        END_METHOD

        METHOD PUBLIC ChangeWeldingProbe : IAxoTaskState
            VAR_INPUT
                ProbeNumber : UINT;
            END_VAR
            _probeNumber := ProbeNumber;            
            ChangeWeldingProbe := ChangeWeldingProbeTask.Invoke(THIS);
        END_METHOD

        METHOD PUBLIC CycleStop : IAxoTaskState
            CycleStop := CycleStopTask.Invoke(THIS);
        END_METHOD

        METHOD PUBLIC RunWeldingWithTime : IAxoTaskState
            VAR_INPUT
                SetupNumber : UINT;
                ProbeNumber : UINT;
                WeldingTime : LTIME;
            END_VAR
            _setupNumber := SetupNumber;
            _probeNumber := ProbeNumber;   
            _weldingTime := WeldingTime;
            RunWeldingWithTime := RunWeldingWithTimeTask.Invoke(THIS);
        END_METHOD

        METHOD PROTECTED OVERRIDE ManualControl
            _setupNumber := RequiredSetupNumber;
            _probeNumber := RequiredProbeNumber;
            _weldingTime := RequiredWeldingTime;
            THIS._isManuallyControllable := true;
        END_METHOD
        
        ///<summary>
        /// Restores this component into intial state.        
        ///</summary>
        METHOD PUBLIC OVERRIDE Restore
            VAR
                _index : INT;
            END_VAR
            Status.Action.Id := UINT#0;
            Status.Error.Id  := UINT#0;

            _progress       :=   INT#0;
            _retVal    :=   WORD#0;


            FOR _index := 0 TO 19 DO
                _data_in[_index]    := BYTE#0;
                _data_out[_index]   := BYTE#0;
            END_FOR;

            FOR _index := 20 TO 139 DO
                _data_in[_index] := BYTE#0;
            END_FOR;

            _word           :=   WORD#0;
            _dword          :=   DWORD#0;

            _weldingTimer.OnDelay(THIS,FALSE,T#0S);

            ClearErrorTask.Restore();
            ChangeWeldingSetupTask.Restore();
            ChangeWeldingProbeTask.Restore();
            CycleStopTask.Restore();
            RunWeldingWithTimeTask.Restore();
            HardwareDiagnosticsTask.Restore();


            Outputs.ClearSetup := FALSE;
            Outputs.RunScan := FALSE;
            Outputs.RunContinuously := FALSE;
            Outputs.RunWeld := FALSE;
            Outputs.RunTest := FALSE;
            Outputs.ClearError := FALSE;
            Outputs.OTF_AmplitudeEnable := FALSE;
            Outputs.CycleStop := FALSE;
            Outputs.FrontPanelLockout_0 := FALSE;
            Outputs.FrontPanelLockout_1 := FALSE;
            // Outputs.OTF_Amp_Setpoint := DINT#0;
            // Outputs.ActiveSetupSelection := DINT#0;
            // Outputs.RunningSetupSelection := DINT#0;
            // Outputs.RunningMPCProbeSelection := DINT#0;


            Status.Action.Id := UINT#50;
            RestoreTask.DoneWhen(TRUE);

        END_METHOD        

        METHOD PRIVATE CallTimers
            VAR_INPUT
                signal : BOOL;
            END_VAR
            
            _infoTimer.OnDelay(THIS, signal AND Config.InfoTime > T#0S ,Config.InfoTime);
            _errorTimer.OnDelay(THIS, signal AND Config.ErrorTime > T#0S , Config.ErrorTime);

        END_METHOD
    END_CLASS
END_NAMESPACE



