USING AXOpen.Core;
USING AXOpen.Messaging;
USING AXOpen.Messaging.Static;
USING AXOpen.Components.Abstractions;
USING Siemens.Simatic.S71500.Hardware.Utilities;
USING Siemens.Simatic.S71500.DistributedIO;
USING System.Timer;
USING System.Serialization;

NAMESPACE AXOpen.Components.Dukane.Welders
    {S7.extern=ReadWrite}
    CLASS Axo_IQ_SeriesWelder EXTENDS AXOpen.Core.AxoComponent
        VAR PUBLIC // HEADER
            {#ix-attr:[ReadOnly()]}
            Progress       :   INT;
        END_VAR

        VAR PUBLIC // TASKS
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#Restore#>"}
            RestoreTask : AXOpen.Core.AxoTask;
        END_VAR

        VAR PUBLIC // TEMPLATE TASKS
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Template tasks")]}
            {#ix-set:AttributeName = "<#TemplateTask_10steps_1#>"}
            TemplateTask_10steps_1 : AXOpen.Core.AxoTask;
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Template tasks")]}
            {#ix-set:AttributeName = "<#TemplateTask_10steps_2#>"}
            TemplateTask_10steps_2 : AXOpen.Core.AxoTask;
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Template tasks")]}
            {#ix-set:AttributeName = "<#TemplateTask_10steps_3#>"}
            TemplateTask_10steps_3 : AXOpen.Core.AxoTask;
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Template tasks")]}
            {#ix-set:AttributeName = "<#TemplateTask_10steps_4#>"}
            TemplateTask_10steps_4 : AXOpen.Core.AxoTask;
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Template tasks")]}
            {#ix-set:AttributeName = "<#TemplateTask_10steps_5#>"}
            TemplateTask_10steps_5 : AXOpen.Core.AxoTask;
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Template tasks")]}
            {#ix-set:AttributeName = "<#TemplateTask_10steps_6#>"}
            TemplateTask_10steps_6 : AXOpen.Core.AxoTask;

            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Template tasks")]}
            {#ix-set:AttributeName = "<#TemplateTask_20steps_1#>"}
            TemplateTask_20steps_1 : AXOpen.Core.AxoTask;
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Template tasks")]}
            {#ix-set:AttributeName = "<#TemplateTask_20steps_2#>"}
            TemplateTask_20steps_2 : AXOpen.Core.AxoTask;
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Template tasks")]}
            {#ix-set:AttributeName = "<#TemplateTask_20steps_3#>"}
            TemplateTask_20steps_3 : AXOpen.Core.AxoTask;
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Template tasks")]}
            {#ix-set:AttributeName = "<#TemplateTask_20steps_4#>"}
            TemplateTask_20steps_4 : AXOpen.Core.AxoTask;
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Template tasks")]}
            {#ix-set:AttributeName = "<#TemplateTask_20steps_5#>"}
            TemplateTask_20steps_5 : AXOpen.Core.AxoTask;
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Template tasks")]}
            {#ix-set:AttributeName = "<#TemplateTask_20steps_6#>"}
            TemplateTask_20steps_6 : AXOpen.Core.AxoTask;
            
        END_VAR
        
        VAR PUBLIC // CONFIG
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("Config")]}
            {#ix-attr:[ReadOnly()]}
            {#ix-set:AttributeName = "<#Config#>"}
            Config  :   Axo_IQ_SeriesWelder_Config;
        END_VAR

        VAR PUBLIC // Hmi
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("Hmi")]}
            {#ix-attr:[ReadOnly()]}
            {#ix-set:AttributeName = "<#Hmi#>"}
            Hmi                     : Axo_IQ_SeriesWelder_HMI;              // HMI control bits and values (apart from parameters)
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
            _data_in        :   ARRAY[0..254] OF BYTE;
            _data_out_1     :   ARRAY[0..0] OF BYTE;
            _data_out_2     :   ARRAY[0..1] OF BYTE;
            _data_out_4     :   ARRAY[0..3] OF BYTE;
            _data_out_8     :   ARRAY[0..7] OF BYTE;
            _data_out_255   :   ARRAY[0..254] OF BYTE;
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
        END_VAR

        VAR PUBLIC
            Config_reset_on_coms_fault : BOOL := TRUE;
            coms_read_ok : BOOL := FALSE;                     // DPRD_DAT ok in this cycle
            coms_stable : BOOL := FALSE;                      // after TON qualification
            p_coms_stable : BOOL := FALSE;                    // edge helper
            coms_just_restored : BOOL := FALSE;               // ====== Async comms state ======
            rd_req : BOOL := FALSE;
            wr_req : BOOL := FALSE;                           // ====== Rising-edge helpers for triggers ======
            p_setup_changed : BOOL := FALSE;
            p_testscan : BOOL := FALSE;
            pTriggerSourcePosition : BOOL := FALSE;
            pTriggerSourcePower : BOOL := FALSE;
            pEnableWeld : BOOL := FALSE;
            ReadRecord : ReadRecord;
            ReadRecord2 : ReadRecord;
            ReadRecord2req : BOOL;
            ReadRecord2maxLen : UINT;
            WriteRecord : WriteRecord;                        // ====== Indications (HMI) ======
            ton_coms_stable : OnDelay; // TON_TIME;
            tof_async_read_ind : OffDelay; // TOF_TIME;
            tof_async_write_ind : OffDelay; // TOF_TIME;      // ====== String read buffer for model/fw versions ======
            str_read_buffer_254 : ARRAY[0..253] OF BYTE;           
            write_buffer_254 : ARRAY[0..253] OF BYTE;           
            // buf_test_scan_result : Axo_IQ_SeriesWelder_TestScanResults;
            async_read_no : INT := INT#0;                     // -16..-11 (model/fw), 1..5 (params), 17.. (on-demand)
            async_write_no : INT := INT#0;                    // 1..5 (params), 17.. (on-demand) ====== Bitmaps ======
            model_read_map : WORD := WORD#16#0000;            // model string read requests
            on_demand_read_map : WORD := WORD#16#0000;        // on-demand reads
            par_read_map : WORD := WORD#16#0000;              // parameter readout requests
            on_demand_write_map : WORD := WORD#16#0000;       // on-demand writes
            par_write_map : WORD := WORD#16#0000;             // parameter write requests ====== Comparison load spreader ======
            comp_opt_cycler : INT := INT#0;                   // ====== General helpers ======
        END_VAR

        VAR CONSTANT 
            index_async_data1 : DINT := DINT#16#2100;         // index 0x2100 - starting with regulation amplitude
            index_async_data2 : DINT := DINT#16#2129;         // index 0x2129 (8489) - starting with power regulation enable
            index_async_data3 : DINT := DINT#16#214B;         // index 0x214B (8523)
            index_async_data4 : DINT := DINT#16#2178;
            index_async_data5 : DINT := DINT#16#21AA;
            index_async_model_no : DINT := DINT#16#2080;      // model no - string
            index_async_serial_no : DINT := DINT#16#2081;     // serial no (DINT)
            index_async_mb_firmware_ver : DINT := DINT#16#2082;   // motherboard firmware version - string
            index_async_fp_firmware_ver : DINT := DINT#16#2083;   // front panel firmware version - string
            index_async_mb_bootloader_no : DINT := DINT#16#2084;   // motherboard bootloader version - string
            index_async_fp_bootloader_no : DINT := DINT#16#2085;   // front panel bootloader version - string
            index_async_test_scan_result : DINT := DINT#16#2128;
            index_asycn_copyrec : DINT := DINT#16#2127;
            initial_parameter_refresh   : WORD := WORD#2#0000000000011111;
            initial_model_refresh       : WORD := WORD#2#0000000000111111;
        END_VAR
        ///<summary>
        /// Runs tasks and logic of this component.
        /// >[!IMPORTANT] This method must or one of its overloads be called cyclically.
        ///</summary>
        METHOD PUBLIC Run
            VAR_INPUT
                parent      :   IAxoObject;
                hwID        :   UINT;
            END_VAR

            VAR_TEMP 
                prev_rd_req : Bool;
                rd_any_response : Bool;
                tmp_bit : Bool;
                prev_wr_req : Bool;
                wr_any_response : Bool;
                mask : Word;
                tmp_W : Word;
                tmp_DW : DWord;   
                _data_in      :   ARRAY[0..139] OF BYTE;
                _data_out     :   ARRAY[0..19] OF BYTE;
                _data_255 : ARRAY[0..254] OF BYTE;        
                index : UINT;
            END_VAR
    
            // IQ ULTRASONIC GENERATOR CONTROL - over profinet - mode "Profinet with Distance"
            // Created by: Vaclav Fiala (fiala@gfm.cz)
            // Rewrited 1-to-1 to SCL by Tomas Kovac
            
            // ============================================================================
            // Adapted from original example code BY Dukane TO make the multi
            // INSTANCE use easier TO deploy AND less error prone.
            // NOTE:  use the IQ Commander software (connected over USB TO the Generator)
            // TO set the comunicatiom mode TO "Profinet with Distance" -
            // otherwise the communication will NOT work.
            
            // ============================================================================

            SUPER.Run(parent);

            Messenger.Serve(THIS);
            
            Progress := _progress;

            IF NOT _initHwCheckDone THEN
                IF parent = NULL THEN
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
                ReadHardwareIOAddress(hardwareIdentifier :=  TO_WORD(Config.HWIDs.HwID_iQ_to_PLC_Inputs) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
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
                ReadHardwareIOAddress(hardwareIdentifier :=  TO_WORD(Config.HWIDs.HwID_PLC_to_iQ_Outputs) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _outputsCount <> UINT#20 OR _inputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#916,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#916;
                    RETURN;
                END_IF;
 
                IF parent = NULL THEN
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

            // ============================================================================
            // Network 1: Read synchronous data from the module (inputs)
            // ============================================================================
            // This is new inputs reading =>
            _retval := ReadData(LADDR := TO_WORD(Config.HWIDs.HwID_iQ_to_PLC_Inputs),RECORD => _data_in);
            coms_read_ok := (_retval = WORD#0);
            IF _retval > WORD#0 THEN
                Messenger.Activate(UINT#1201, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1201;
                RETURN;
            END_IF;
            Inputs.SystemErrorStatus.Frequency_Overload_3                    := _data_in[0].%X0;
            Inputs.SystemErrorStatus._1                                      := _data_in[0].%X1;
            Inputs.SystemErrorStatus._2                                      := _data_in[0].%X2;
            Inputs.SystemErrorStatus._3                                      := _data_in[0].%X3;
            Inputs.SystemErrorStatus.Under_Voltage_1                         := _data_in[0].%X4;
            Inputs.SystemErrorStatus._5                                      := _data_in[0].%X5;
            Inputs.SystemErrorStatus._6                                      := _data_in[0].%X6;
            Inputs.SystemErrorStatus._7                                      := _data_in[0].%X7;
            Inputs.SystemErrorStatus.Over_Amplitude_Fault                    := _data_in[1].%X0;
            Inputs.SystemErrorStatus.InternalError_5                         := _data_in[1].%X1;
            Inputs.SystemErrorStatus.US_Voltage_Overload                     := _data_in[1].%X2;
            Inputs.SystemErrorStatus._11                                     := _data_in[1].%X3;
            Inputs.SystemErrorStatus._12                                     := _data_in[1].%X4;
            Inputs.SystemErrorStatus._13                                     := _data_in[1].%X5;
            Inputs.SystemErrorStatus._14                                     := _data_in[1].%X6;
            Inputs.SystemErrorStatus._15                                     := _data_in[1].%X7;
            Inputs.SystemErrorStatus.Average_Overload                        := _data_in[2].%X0;
            Inputs.SystemErrorStatus.Current_Loop                            := _data_in[2].%X1;
            Inputs.SystemErrorStatus.Power_Not_OK                            := _data_in[2].%X2;
            Inputs.SystemErrorStatus.Over_Temperature                        := _data_in[2].%X3;
            Inputs.SystemErrorStatus._20                                     := _data_in[2].%X4;
            Inputs.SystemErrorStatus._21                                     := _data_in[2].%X5;
            Inputs.SystemErrorStatus._22                                     := _data_in[2].%X6;
            Inputs.SystemErrorStatus._23                                     := _data_in[2].%X7;
            Inputs.SystemErrorStatus.InternalError_1                         := _data_in[3].%X0;
            Inputs.SystemErrorStatus.InternalError_2                         := _data_in[3].%X1;
            Inputs.SystemErrorStatus.InternalError_3                         := _data_in[3].%X2;
            Inputs.SystemErrorStatus.InternalError_4                         := _data_in[3].%X3;
            Inputs.SystemErrorStatus.FrequencyOverload_1                     := _data_in[3].%X4;
            Inputs.SystemErrorStatus.Frequency_Overload_2                    := _data_in[3].%X5;
            Inputs.SystemErrorStatus.Peak_Overload_Positive                  := _data_in[3].%X6;
            Inputs.SystemErrorStatus.Peak_Overload_Negative                  := _data_in[3].%X7;

            tmp_DW.%B3                                                          := _data_in[4];
            tmp_DW.%B2                                                          := _data_in[5];
            tmp_DW.%B1                                                          := _data_in[6];
            tmp_DW.%B0                                                          := _data_in[7];
            Inputs.SystemInitiateError := TO_DINT(tmp_DW);

            // Inputs.SystemInitiateError := TO_DINT( SHL(TO_DWORD(_data_in[4]), UINT#24) OR SHL(TO_DWORD(_data_in[5]), UINT#16) OR SHL(TO_DWORD(_data_in[6]),  UINT#8) OR TO_DWORD(_data_in[7]));

            Inputs.SystemProcessError._0                                     := _data_in[8].%X0;
            Inputs.SystemProcessError._1                                     := _data_in[8].%X1;
            Inputs.SystemProcessError._2                                     := _data_in[8].%X2;
            Inputs.SystemProcessError._3                                     := _data_in[8].%X3;
            Inputs.SystemProcessError._4                                     := _data_in[8].%X4;
            Inputs.SystemProcessError._5                                     := _data_in[8].%X5;
            Inputs.SystemProcessError._6                                     := _data_in[8].%X6;
            Inputs.SystemProcessError._7                                     := _data_in[8].%X7;
            Inputs.SystemProcessError._8                                     := _data_in[9].%X0;
            Inputs.SystemProcessError._9                                     := _data_in[9].%X1;
            Inputs.SystemProcessError._10                                    := _data_in[9].%X2;
            Inputs.SystemProcessError._11                                    := _data_in[9].%X3;
            Inputs.SystemProcessError._12                                    := _data_in[9].%X4;
            Inputs.SystemProcessError._13                                    := _data_in[9].%X5;
            Inputs.SystemProcessError._14                                    := _data_in[9].%X6;
            Inputs.SystemProcessError._15                                    := _data_in[9].%X7;
            Inputs.SystemProcessError.Trigger_Delay                          := _data_in[10].%X0;
            Inputs.SystemProcessError.Servo_DN_Limit                         := _data_in[10].%X1;
            Inputs.SystemProcessError.Servo_TOS_Position                     := _data_in[10].%X2;
            Inputs.SystemProcessError._19                                    := _data_in[10].%X3;
            Inputs.SystemProcessError._20                                    := _data_in[10].%X4;
            Inputs.SystemProcessError._21                                    := _data_in[10].%X5;
            Inputs.SystemProcessError._22                                    := _data_in[10].%X6;
            Inputs.SystemProcessError._23                                    := _data_in[10].%X7;
            Inputs.SystemProcessError.Forced_ShutDown                        := _data_in[11].%X0;
            Inputs.SystemProcessError.Trigger_Lost_Early                     := _data_in[11].%X1;
            Inputs.SystemProcessError.Trigger_Lost_Weld                      := _data_in[11].%X2;
            Inputs.SystemProcessError.Latched_Bad_Part                       := _data_in[11].%X3;
            Inputs.SystemProcessError.PreTrigger_OverTravel                  := _data_in[11].%X4;
            Inputs.SystemProcessError.Part_Detected                          := _data_in[11].%X5;
            Inputs.SystemProcessError.PreTrigger_Time                        := _data_in[11].%X6;
            Inputs.SystemProcessError.Trigger_Time                           := _data_in[11].%X7;

            tmp_DW.%B3                                                          := _data_in[12];
            tmp_DW.%B2                                                          := _data_in[13];
            tmp_DW.%B1                                                          := _data_in[14];
            tmp_DW.%B0                                                          := _data_in[15];
            Inputs.GeneratorState := TO_DINT(tmp_DW);

            tmp_DW.%B3                                                          := _data_in[16];
            tmp_DW.%B2                                                          := _data_in[17];
            tmp_DW.%B1                                                          := _data_in[18];
            tmp_DW.%B0                                                          := _data_in[19];
            Inputs.RealTimeAmplitude := TO_DINT(tmp_DW);

            tmp_DW.%B3                                                          := _data_in[20];
            tmp_DW.%B2                                                          := _data_in[21];
            tmp_DW.%B1                                                          := _data_in[22];
            tmp_DW.%B0                                                          := _data_in[23];
            Inputs.RealTimeFrequency := TO_DINT(tmp_DW);

            tmp_DW.%B3                                                          := _data_in[24];
            tmp_DW.%B2                                                          := _data_in[25];
            tmp_DW.%B1                                                          := _data_in[26];
            tmp_DW.%B0                                                          := _data_in[27];
            Inputs.RealTimePower := TO_DINT(tmp_DW);


            Inputs.SystemStatus.res_bit24                                    := _data_in[28].%X0;
            Inputs.SystemStatus.res_bit25                                    := _data_in[28].%X1;
            Inputs.SystemStatus.res_bit26                                    := _data_in[28].%X2;
            Inputs.SystemStatus.res_bit27                                    := _data_in[28].%X3;
            Inputs.SystemStatus.res_bit28                                    := _data_in[28].%X4;
            Inputs.SystemStatus.res_bit29                                    := _data_in[28].%X5;
            Inputs.SystemStatus.res_bit30                                    := _data_in[28].%X6;
            Inputs.SystemStatus.SetupChanged                                 := _data_in[28].%X7;
            Inputs.SystemStatus.InCycle                                      := _data_in[29].%X0;
            Inputs.SystemStatus.InCycle_No_AB                                := _data_in[29].%X1;
            Inputs.SystemStatus.OverTemp                                     := _data_in[29].%X2;
            Inputs.SystemStatus.In_AfterBurst                                := _data_in[29].%X3;
            Inputs.SystemStatus.In_Test                                      := _data_in[29].%X4;
            Inputs.SystemStatus.In_TestScan                                  := _data_in[29].%X5;
            Inputs.SystemStatus.MPC_Present                                  := _data_in[29].%X6;
            Inputs.SystemStatus.res_bit23                                    := _data_in[29].%X7;
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

            tmp_DW.%B3                                                          := _data_in[32];
            tmp_DW.%B2                                                          := _data_in[33];
            tmp_DW.%B1                                                          := _data_in[34];
            tmp_DW.%B0                                                          := _data_in[35];
            Inputs.Temperature := TO_DINT(tmp_DW);

            tmp_DW.%B3                                                          := _data_in[36];
            tmp_DW.%B2                                                          := _data_in[37];
            tmp_DW.%B1                                                          := _data_in[38];
            tmp_DW.%B0                                                          := _data_in[39];
            Inputs.CycleCount := TO_DINT(tmp_DW);

            tmp_DW.%B3                                                          := _data_in[40];
            tmp_DW.%B2                                                          := _data_in[41];
            tmp_DW.%B1                                                          := _data_in[42];
            tmp_DW.%B0                                                          := _data_in[43];
            Inputs.GoodPartCount := TO_DINT(tmp_DW);

            tmp_DW.%B3                                                          := _data_in[44];
            tmp_DW.%B2                                                          := _data_in[45];
            tmp_DW.%B1                                                          := _data_in[46];
            tmp_DW.%B0                                                          := _data_in[47];
            Inputs.BadPartCount := TO_DINT(tmp_DW);

            tmp_DW.%B3                                                          := _data_in[48];
            tmp_DW.%B2                                                          := _data_in[49];
            tmp_DW.%B1                                                          := _data_in[50];
            tmp_DW.%B0                                                          := _data_in[51];
            Inputs.SuspectPartCount := TO_DINT(tmp_DW);

            tmp_DW.%B3                                                          := _data_in[52];
            tmp_DW.%B2                                                          := _data_in[53];
            tmp_DW.%B1                                                          := _data_in[54];
            tmp_DW.%B0                                                          := _data_in[55];
            Inputs.AbortedPartCount := TO_DINT(tmp_DW);

            Inputs.CyclePartStatus.LowerBadEnergyLimit                       := _data_in[56].%X0;
            Inputs.CyclePartStatus.LowerSuspectEnergyLimit                   := _data_in[56].%X1;
            Inputs.CyclePartStatus.UpperSuspectEnergyLimit                   := _data_in[56].%X2;
            Inputs.CyclePartStatus.UpperBadEnergyLimit                       := _data_in[56].%X3;
            Inputs.CyclePartStatus._4                                        := _data_in[56].%X4;
            Inputs.CyclePartStatus._5                                        := _data_in[56].%X5;
            Inputs.CyclePartStatus._6                                        := _data_in[56].%X6;
            Inputs.CyclePartStatus._7                                        := _data_in[56].%X7;
            Inputs.CyclePartStatus.LowerBadPowerLimit                        := _data_in[57].%X0;
            Inputs.CyclePartStatus.LowerSuspectPowerLimit                    := _data_in[57].%X1;
            Inputs.CyclePartStatus.UpperSuspectPowerLimit                    := _data_in[57].%X2;
            Inputs.CyclePartStatus.UpperBadPowerLimit                        := _data_in[57].%X3;
            Inputs.CyclePartStatus._12                                       := _data_in[57].%X4;
            Inputs.CyclePartStatus._13                                       := _data_in[57].%X5;
            Inputs.CyclePartStatus._14                                       := _data_in[57].%X6;
            Inputs.CyclePartStatus._15                                       := _data_in[57].%X7;
            Inputs.CyclePartStatus.LowerBadTimeLimit                         := _data_in[58].%X0;
            Inputs.CyclePartStatus.LowerSuspectTimeLimit                     := _data_in[58].%X1;
            Inputs.CyclePartStatus.UpperSuspectTimeLimit                     := _data_in[58].%X2;
            Inputs.CyclePartStatus.UpperBadTimeLimit                         := _data_in[58].%X3;
            Inputs.CyclePartStatus._20                                       := _data_in[58].%X4;
            Inputs.CyclePartStatus._21                                       := _data_in[58].%X5;
            Inputs.CyclePartStatus._22                                       := _data_in[58].%X6;
            Inputs.CyclePartStatus._23                                       := _data_in[58].%X7;
            Inputs.CyclePartStatus.GoodPart                                  := _data_in[59].%X0;
            Inputs.CyclePartStatus.BadPart                                   := _data_in[59].%X1;
            Inputs.CyclePartStatus.SuspectPart                               := _data_in[59].%X2;
            Inputs.CyclePartStatus._27                                       := _data_in[59].%X3;
            Inputs.CyclePartStatus._28                                       := _data_in[59].%X4;
            Inputs.CyclePartStatus._29                                       := _data_in[59].%X5;
            Inputs.CyclePartStatus._30                                       := _data_in[59].%X6;
            Inputs.CyclePartStatus._31                                       := _data_in[59].%X7;

            tmp_DW.%B3                                                          := _data_in[60];
            tmp_DW.%B2                                                          := _data_in[61];
            tmp_DW.%B1                                                          := _data_in[62];
            tmp_DW.%B0                                                          := _data_in[63];
            Inputs.CycleWeldTime := TO_DINT(tmp_DW);

            tmp_DW.%B3                                                          := _data_in[64];
            tmp_DW.%B2                                                          := _data_in[65];
            tmp_DW.%B1                                                          := _data_in[66];
            tmp_DW.%B0                                                          := _data_in[67];
            Inputs.CycleWeldPeakPower := TO_DINT(tmp_DW);

            tmp_DW.%B3                                                          := _data_in[68];
            tmp_DW.%B2                                                          := _data_in[69];
            tmp_DW.%B1                                                          := _data_in[70];
            tmp_DW.%B0                                                          := _data_in[71];
            Inputs.CycleWeldEnergy := TO_DINT(tmp_DW);

            tmp_DW.%B3                                                          := _data_in[72];
            tmp_DW.%B2                                                          := _data_in[73];
            tmp_DW.%B1                                                          := _data_in[74];
            tmp_DW.%B0                                                          := _data_in[75];
            Inputs.ActiveSetup := TO_DINT(tmp_DW);

            tmp_DW.%B3                                                          := _data_in[76];
            tmp_DW.%B2                                                          := _data_in[77];
            tmp_DW.%B1                                                          := _data_in[78];
            tmp_DW.%B0                                                          := _data_in[79];
            Inputs.RunningSetup := TO_DINT(tmp_DW);

            tmp_DW.%B3                                                          := _data_in[80];
            tmp_DW.%B2                                                          := _data_in[81];
            tmp_DW.%B1                                                          := _data_in[82];
            tmp_DW.%B0                                                          := _data_in[83];
            Inputs.RunningMPCProbe := TO_DINT(tmp_DW);

            tmp_DW.%B3                                                          := _data_in[84];
            tmp_DW.%B2                                                          := _data_in[85];
            tmp_DW.%B1                                                          := _data_in[86];
            tmp_DW.%B0                                                          := _data_in[87];
            Inputs.SelectedInputVoltage := TO_DINT(tmp_DW);

            tmp_DW.%B3                                                          := _data_in[88];
            tmp_DW.%B2                                                          := _data_in[89];
            tmp_DW.%B1                                                          := _data_in[90];
            tmp_DW.%B0                                                          := _data_in[91];
            Inputs.RealTimePosition := TO_DINT(tmp_DW);

            tmp_DW.%B3                                                          := _data_in[92];
            tmp_DW.%B2                                                          := _data_in[93];
            tmp_DW.%B1                                                          := _data_in[94];
            tmp_DW.%B0                                                          := _data_in[95];
            Inputs.RealTimeVelocity := TO_DINT(tmp_DW);

            Inputs.PressPartStatus_Bad_lo.Weld1Position                      := _data_in[96].%X0;
            Inputs.PressPartStatus_Bad_lo.ErrorStatus                        := _data_in[96].%X1;
            Inputs.PressPartStatus_Bad_lo._26                                := _data_in[96].%X2;
            Inputs.PressPartStatus_Bad_lo._27                                := _data_in[96].%X3;
            Inputs.PressPartStatus_Bad_lo._28                                := _data_in[96].%X4;
            Inputs.PressPartStatus_Bad_lo._29                                := _data_in[96].%X5;
            Inputs.PressPartStatus_Bad_lo._30                                := _data_in[96].%X6;
            Inputs.PressPartStatus_Bad_lo._31                                := _data_in[96].%X7;
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
            Inputs.PressPartStatus_Sus_lo._26                                := _data_in[100].%X2;
            Inputs.PressPartStatus_Sus_lo._27                                := _data_in[100].%X3;
            Inputs.PressPartStatus_Sus_lo._28                                := _data_in[100].%X4;
            Inputs.PressPartStatus_Sus_lo._29                                := _data_in[100].%X5;
            Inputs.PressPartStatus_Sus_lo._30                                := _data_in[100].%X6;
            Inputs.PressPartStatus_Sus_lo._31                                := _data_in[100].%X7;
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
            Inputs.PressPartStatus_Sus_hi._26                                := _data_in[104].%X2;
            Inputs.PressPartStatus_Sus_hi._27                                := _data_in[104].%X3;
            Inputs.PressPartStatus_Sus_hi._28                                := _data_in[104].%X4;
            Inputs.PressPartStatus_Sus_hi._29                                := _data_in[104].%X5;
            Inputs.PressPartStatus_Sus_hi._30                                := _data_in[104].%X6;
            Inputs.PressPartStatus_Sus_hi._31                                := _data_in[104].%X7;
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
            Inputs.PressPartStatus_Bad_hi._26                                := _data_in[108].%X2;
            Inputs.PressPartStatus_Bad_hi._27                                := _data_in[108].%X3;
            Inputs.PressPartStatus_Bad_hi._28                                := _data_in[108].%X4;
            Inputs.PressPartStatus_Bad_hi._29                                := _data_in[108].%X5;
            Inputs.PressPartStatus_Bad_hi._30                                := _data_in[108].%X6;
            Inputs.PressPartStatus_Bad_hi._31                                := _data_in[108].%X7;
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


            tmp_DW.%B3                                                          := _data_in[112];
            tmp_DW.%B2                                                          := _data_in[113];
            tmp_DW.%B1                                                          := _data_in[114];
            tmp_DW.%B0                                                          := _data_in[115];
            Inputs.CycleTriggerTime := TO_DINT(tmp_DW);

            tmp_DW.%B3                                                          := _data_in[116];
            tmp_DW.%B2                                                          := _data_in[117];
            tmp_DW.%B1                                                          := _data_in[118];
            tmp_DW.%B0                                                          := _data_in[119];
            Inputs.CycleTriggerPosition := TO_DINT(tmp_DW);

            tmp_DW.%B3                                                          := _data_in[120];
            tmp_DW.%B2                                                          := _data_in[121];
            tmp_DW.%B1                                                          := _data_in[122];
            tmp_DW.%B0                                                          := _data_in[123];
            Inputs.CycleTriggerDelayTime := TO_DINT(tmp_DW);

            tmp_DW.%B3                                                          := _data_in[124];
            tmp_DW.%B2                                                          := _data_in[125];
            tmp_DW.%B1                                                          := _data_in[126];
            tmp_DW.%B0                                                          := _data_in[127];
            Inputs.CycleTriggerDelayDistance := TO_DINT(tmp_DW);

            tmp_DW.%B3                                                          := _data_in[128];
            tmp_DW.%B2                                                          := _data_in[129];
            tmp_DW.%B1                                                          := _data_in[130];
            tmp_DW.%B0                                                          := _data_in[131];
            Inputs.CycleWeld1Distance := TO_DINT(tmp_DW);

            tmp_DW.%B3                                                          := _data_in[132];
            tmp_DW.%B2                                                          := _data_in[133];
            tmp_DW.%B1                                                          := _data_in[134];
            tmp_DW.%B0                                                          := _data_in[135];
            Inputs.CycleWeld1Position := TO_DINT(tmp_DW);

            tmp_DW.%B3                                                          := _data_in[136];
            tmp_DW.%B2                                                          := _data_in[137];
            tmp_DW.%B1                                                          := _data_in[138];
            tmp_DW.%B0                                                          := _data_in[139];
            Inputs.CycleTotalTime := TO_DINT(tmp_DW);
            // <= This is new inputs reading

            //*****************************************
            // HMI sync OK flag
            Hmi.s.ComsSyncReadOK := coms_stable;
            
            // qualify stable comms (no sync errors for 1s)
            // ton_coms_stable(IN := coms_read_ok, PT := T#1s);
            // coms_stable := ton_coms_stable.Q;
            ton_coms_stable(signal := coms_read_ok, duration := T#1s);
            coms_stable := ton_coms_stable.output;
            
            // rising edge of comms restored
            coms_just_restored := coms_stable AND (NOT p_coms_stable);
            p_coms_stable := coms_stable;


            
            // ============================================================================
            // Network 4: Process synchronous data into HMI status
            // ============================================================================
            
            Hmi.s.RunningAndActiveSetupNotSame := (Inputs.ActiveSetup <> Inputs.RunningSetup);
            
            // ============================================================================
            // Network 10: Trigger read on HMI req 
            // ============================================================================
            IF Hmi.c.read_active_setup AND (Outputs.ActiveSetupSelection = Inputs.ActiveSetup) THEN
                par_read_map := par_read_map OR TO_WORD(2#0000000000000001);
            END_IF;
            
            // ============================================================================
            // Network 11: Trigger re-read on setup change indication
            // ============================================================================
            Outputs.ClearSetup := coms_read_ok AND Inputs.SystemStatus.SetupChanged;
            
            IF (NOT Inputs.SystemStatus.SetupChanged AND p_setup_changed) AND coms_read_ok THEN
                par_read_map := par_read_map OR initial_parameter_refresh;
            END_IF;
            p_setup_changed := Inputs.SystemStatus.SetupChanged;
            
            // ============================================================================
            // Network 12: Trigger test scan data read when scan finished
            // ============================================================================
            IF (NOT Inputs.SystemStatus.In_TestScan) AND p_testscan AND coms_read_ok THEN
                on_demand_read_map := on_demand_read_map OR TO_WORD(2#0000000000000001); // -> async_read_no 17
            END_IF;
            p_testscan := Inputs.SystemStatus.In_TestScan;
            
            // ============================================================================
            // Network 13: If Comms faulted to Generator write zeros to Generator Output.
            // ============================================================================
            // 
            IF Config_reset_on_coms_fault AND NOT coms_read_ok THEN
                Outputs.RunContinuously := FALSE;
                Outputs.RunWeld := FALSE;
                Outputs.RunTest := FALSE;
                Outputs.ClearError := FALSE;
                Outputs.OTF_AmplitudeEnable := FALSE;
                Outputs.CycleStop := FALSE;
                Outputs.FrontPanelLockout_0 := FALSE;
                Outputs.FrontPanelLockout_1 := FALSE;
                Outputs.RunScan := FALSE;
                Outputs.ClearSetup := FALSE;
            END_IF;



            //*************INITIALIZATION*************
            RestoreTask.Run(THIS);
            TemplateTask_10steps_1.Run(THIS);
            TemplateTask_10steps_2.Run(THIS);
            TemplateTask_10steps_3.Run(THIS);
            TemplateTask_10steps_4.Run(THIS);
            TemplateTask_10steps_5.Run(THIS);
            TemplateTask_10steps_6.Run(THIS);
            TemplateTask_20steps_1.Run(THIS);
            TemplateTask_20steps_2.Run(THIS);
            TemplateTask_20steps_3.Run(THIS);
            TemplateTask_20steps_4.Run(THIS);
            TemplateTask_20steps_5.Run(THIS);
            TemplateTask_20steps_6.Run(THIS);
    
            //****************************************
    
            //********************Diagnostics*********        
            HardwareDiagnosticsTask.Run(THIS,Config.HWIDs.HW_Device);
            //****************************************
    
            //*************RESTORE********************
            RestoreTask.SetIsDisabled(FALSE);
            IF RestoreTask.Execute(THIS) THEN
                THIS.Restore();
            END_IF;
            //****************************************
            
    
            //*************TemplateTask_10steps_1**************
            TemplateTask_10steps_1.SetIsDisabled(FALSE);
            IF TemplateTask_10steps_1.StartTriggered() THEN
                Status.Action.Id :=  UINT#100;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#100,TemplateTask_10steps_1.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#101,TemplateTask_10steps_1.IsDone(), eAxoMessageCategory#Info);
            IF TemplateTask_10steps_1.Execute(THIS) THEN
                IF _progress = 0 THEN
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 300;
                END_IF;
    
                IF _progress = 300 THEN                                                                                     // TemplateTask_10steps_1 running: , <add the detailed description of the current action 1>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#500, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#500;
                    END_IF;
                    ReadRecord2req := FALSE;
                    ReadRecord2( request := FALSE,record := str_read_buffer_254);
                    IF NOT ReadRecord2.busy AND NOT ReadRecord2.error AND NOT ReadRecord2.valid THEN
                        THIS.CallTimers(FALSE);
                        _progress := 301;
                    END_IF;
                END_IF;
    
                IF _progress = 301 THEN                                                                                     // TemplateTask_10steps_1 running: , <add the detailed description of the current action 2>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#501, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#501;
                    END_IF;
                    ReadRecord2maxLen := UINT#64;
                    ReadRecord2req := TRUE;
                    IF ReadRecord2.busy THEN
                        THIS.CallTimers(FALSE);
                        _progress := 302;
                    END_IF;
                END_IF;
                
                IF _progress = 302 THEN                                                                                     // TemplateTask_10steps_1 running: , <add the detailed description of the current action 3>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#502, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#502;
                    END_IF;

                    IF NOT ReadRecord2.busy AND ReadRecord2.valid AND NOT ReadRecord2.error THEN
                        THIS.CallTimers(FALSE);
                        _progress := 303;
                    END_IF;
                END_IF;
                
                IF _progress = 303 THEN                                                                                     // TemplateTask_10steps_1 running: , <add the detailed description of the current action 4>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#503, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#503;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 304;
                    END_IF;
                END_IF;
                
                IF _progress = 304 THEN                                                                                     // TemplateTask_10steps_1 running: , <add the detailed description of the current action 5>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#504, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#504;
                    END_IF;

                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 305;
                    END_IF;
                END_IF;
                
                IF _progress = 305 THEN                                                                                     // TemplateTask_10steps_1 running: , <add the detailed description of the current action 6>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#505, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#505;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 306;
                    END_IF;
                END_IF;
                
                IF _progress = 306 THEN                                                                                     // TemplateTask_10steps_1 running: , <add the detailed description of the current action 7>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#506, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#506;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 307;
                    END_IF;
                END_IF;
                
                IF _progress = 307 THEN                                                                                     // TemplateTask_10steps_1 running: , <add the detailed description of the current action 8>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#507, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#507;
                    END_IF;

                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 308;
                    END_IF;
                END_IF;
                
                IF _progress = 308 THEN                                                                                     // TemplateTask_10steps_1 running: , <add the detailed description of the current action 9>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#508, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#508;
                    END_IF;

                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 309;
                    END_IF;
                END_IF;
                
                IF _progress = 309 THEN         
                    ReadRecord2req := FALSE;                                                                            // TemplateTask_10steps_1 running: , <add the detailed description of the current action 10>
                    TemplateTask_10steps_1.DoneWhen(TRUE);
                    _progress := 0;
                END_IF;

                ReadRecord2( request := ReadRecord2req, 
                    id := TO_WORD(Config.HWIDs.HwID_iQ_to_PLC_Inputs),
                    index := index_async_model_no,
                    maxLength := ReadRecord2maxLen,
                    record := str_read_buffer_254);

    
                THIS.CallTimers(TRUE);
                
                TemplateTask_10steps_1.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);  
                TemplateTask_10steps_1.ThrowWhen(TemplateTask_10steps_1.Duration >= Config.TaskTimeout AND Config.TaskTimeout > T#0s ,'TemplateTask_10steps_1 timeout.');                
            END_IF;
            IF TemplateTask_10steps_1.DoneReached() THEN
                Status.Action.Id :=  UINT#101;
                Status.Error.Id :=  UINT#0;
            ELSIF TemplateTask_10steps_1.ErrorOccured() THEN
                Status.Action.Id :=  UINT#10000;
                Status.Error.Id  :=  UINT#10000;
            ELSIF TemplateTask_10steps_1.AbortTriggered()THEN
                Status.Action.Id :=  UINT#10001;
                Status.Error.Id  :=  UINT#10001;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#10000,TemplateTask_10steps_1.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#10001,TemplateTask_10steps_1.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#102,TemplateTask_10steps_1.RestoreTriggered() , eAxoMessageCategory#Error);
            IF TemplateTask_10steps_1.RestoreTriggered() AND _progress >= 300 AND _progress <= 309  THEN
                Status.Action.Id :=  UINT#102;
                _progress := 0;
            END_IF;
            //**************************************************
    
            //*************TemplateTask_10steps_2***************
            TemplateTask_10steps_2.SetIsDisabled(FALSE);
            IF TemplateTask_10steps_2.StartTriggered() THEN
                Status.Action.Id :=  UINT#110;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#110,TemplateTask_10steps_2.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#111,TemplateTask_10steps_2.IsDone(), eAxoMessageCategory#Info);
            IF TemplateTask_10steps_2.Execute(THIS) THEN
                IF _progress = 0 THEN
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 310;
                END_IF;
    
                IF _progress = 310 THEN                                                                                     // TemplateTask_10steps_2 running: , <add the detailed description of the current action 1>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#510, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#510;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 311;
                    END_IF;
                END_IF;
    
                IF _progress = 311 THEN                                                                                     // TemplateTask_10steps_2 running: , <add the detailed description of the current action 2>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#511, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#511;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 312;
                    END_IF;
                END_IF;
                
                IF _progress = 312 THEN                                                                                     // TemplateTask_10steps_2 running: , <add the detailed description of the current action 3>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#512, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#512;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 313;
                    END_IF;
                END_IF;
                
                IF _progress = 313 THEN                                                                                     // TemplateTask_10steps_2 running: , <add the detailed description of the current action 4>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#513, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#513;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 314;
                    END_IF;
                END_IF;
                
                IF _progress = 314 THEN                                                                                     // TemplateTask_10steps_2 running: , <add the detailed description of the current action 5>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#514, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#514;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 315;
                    END_IF;
                END_IF;
                
                IF _progress = 315 THEN                                                                                     // TemplateTask_10steps_2 running: , <add the detailed description of the current action 6>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#515, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#515;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 316;
                    END_IF;
                END_IF;
                
                IF _progress = 316 THEN                                                                                     // TemplateTask_10steps_2 running: , <add the detailed description of the current action 7>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#516, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#516;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 317;
                    END_IF;
                END_IF;
                
                IF _progress = 317 THEN                                                                                     // TemplateTask_10steps_2 running: , <add the detailed description of the current action 8>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#517, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#517;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 318;
                    END_IF;
                END_IF;
                
                IF _progress = 318 THEN                                                                                     // TemplateTask_10steps_2 running: , <add the detailed description of the current action 9>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#518, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#518;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 319;
                    END_IF;
                END_IF;
                
                IF _progress = 319 THEN                                                                                     // TemplateTask_10steps_2 running: , <add the detailed description of the current action 10>
                    TemplateTask_10steps_2.DoneWhen(TRUE);
                    _progress := 0;
                END_IF;
    
                THIS.CallTimers(TRUE);
                
                TemplateTask_10steps_2.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);  
                TemplateTask_10steps_2.ThrowWhen(TemplateTask_10steps_2.Duration >= Config.TaskTimeout AND Config.TaskTimeout > T#0s ,'TemplateTask_10steps_2 timeout.');                
            END_IF;
            IF TemplateTask_10steps_2.DoneReached() THEN
                Status.Action.Id :=  UINT#111;
                Status.Error.Id :=  UINT#0;
            ELSIF TemplateTask_10steps_2.ErrorOccured() THEN
                Status.Action.Id :=  UINT#10010;
                Status.Error.Id  :=  UINT#10010;
            ELSIF TemplateTask_10steps_2.AbortTriggered()THEN
                Status.Action.Id :=  UINT#10011;
                Status.Error.Id  :=  UINT#10011;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#10010,TemplateTask_10steps_2.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#10011,TemplateTask_10steps_2.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#112,TemplateTask_10steps_2.RestoreTriggered() , eAxoMessageCategory#Error);
            IF TemplateTask_10steps_2.RestoreTriggered() AND _progress >= 310 AND _progress <= 319  THEN
                Status.Action.Id :=  UINT#112;
                _progress := 0;
            END_IF;
            //**************************************************
    
            //*************TemplateTask_10steps_3***************
            TemplateTask_10steps_3.SetIsDisabled(FALSE);
            IF TemplateTask_10steps_3.StartTriggered() THEN
                Status.Action.Id :=  UINT#120;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#120,TemplateTask_10steps_3.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#121,TemplateTask_10steps_3.IsDone(), eAxoMessageCategory#Info);
            IF TemplateTask_10steps_3.Execute(THIS) THEN
                IF _progress = 0 THEN
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 320;
                END_IF;
    
                IF _progress = 320 THEN                                                                                     // TemplateTask_10steps_3 running: , <add the detailed description of the current action 1>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#520, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#520;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 321;
                    END_IF;
                END_IF;
    
                IF _progress = 321 THEN                                                                                     // TemplateTask_10steps_3 running: , <add the detailed description of the current action 2>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#521, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#521;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 322;
                    END_IF;
                END_IF;
                
                IF _progress = 322 THEN                                                                                     // TemplateTask_10steps_3 running: , <add the detailed description of the current action 3>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#522, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#522;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 323;
                    END_IF;
                END_IF;
                
                IF _progress = 323 THEN                                                                                     // TemplateTask_10steps_3 running: , <add the detailed description of the current action 4>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#523, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#523;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 324;
                    END_IF;
                END_IF;
                
                IF _progress = 324 THEN                                                                                     // TemplateTask_10steps_3 running: , <add the detailed description of the current action 5>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#524, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#524;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 325;
                    END_IF;
                END_IF;
                
                IF _progress = 325 THEN                                                                                     // TemplateTask_10steps_3 running: , <add the detailed description of the current action 6>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#525, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#525;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 326;
                    END_IF;
                END_IF;
                
                IF _progress = 326 THEN                                                                                     // TemplateTask_10steps_3 running: , <add the detailed description of the current action 7>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#526, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#526;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 327;
                    END_IF;
                END_IF;
                
                IF _progress = 327 THEN                                                                                     // TemplateTask_10steps_3 running: , <add the detailed description of the current action 8>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#527, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#527;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 328;
                    END_IF;
                END_IF;
                
                IF _progress = 328 THEN                                                                                     // TemplateTask_10steps_3 running: , <add the detailed description of the current action 9>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#528, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#528;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 329;
                    END_IF;
                END_IF;
                
                IF _progress = 329 THEN                                                                                     // TemplateTask_10steps_3 running: , <add the detailed description of the current action 10>
                    TemplateTask_10steps_3.DoneWhen(TRUE);
                    _progress := 0;
                END_IF;
    
                THIS.CallTimers(TRUE);
                
                TemplateTask_10steps_3.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);  
                TemplateTask_10steps_3.ThrowWhen(TemplateTask_10steps_3.Duration >= Config.TaskTimeout AND Config.TaskTimeout > T#0s ,'TemplateTask_10steps_3 timeout.');                
            END_IF;
            IF TemplateTask_10steps_3.DoneReached() THEN
                Status.Action.Id :=  UINT#121;
                Status.Error.Id :=  UINT#0;
            ELSIF TemplateTask_10steps_3.ErrorOccured() THEN
                Status.Action.Id :=  UINT#10020;
                Status.Error.Id  :=  UINT#10020;
            ELSIF TemplateTask_10steps_3.AbortTriggered()THEN
                Status.Action.Id :=  UINT#10021;
                Status.Error.Id  :=  UINT#10021;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#10020,TemplateTask_10steps_3.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#10021,TemplateTask_10steps_3.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#122,TemplateTask_10steps_3.RestoreTriggered() , eAxoMessageCategory#Error);
            IF TemplateTask_10steps_3.RestoreTriggered() AND _progress >= 320 AND _progress <= 329  THEN
                Status.Action.Id :=  UINT#122;
                _progress := 0;
            END_IF;
            //**************************************************
    
            //*************TemplateTask_10steps_4***************
            TemplateTask_10steps_4.SetIsDisabled(FALSE);
            IF TemplateTask_10steps_4.StartTriggered() THEN
                Status.Action.Id :=  UINT#130;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#130,TemplateTask_10steps_4.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#131,TemplateTask_10steps_4.IsDone(), eAxoMessageCategory#Info);
            IF TemplateTask_10steps_4.Execute(THIS) THEN
                IF _progress = 0 THEN
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 330;
                END_IF;
    
                IF _progress = 330 THEN                                                                                     // TemplateTask_10steps_4 running: , <add the detailed description of the current action 1>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#530, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#530;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 331;
                    END_IF;
                END_IF;
    
                IF _progress = 331 THEN                                                                                     // TemplateTask_10steps_4 running: , <add the detailed description of the current action 2>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#531, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#531;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 332;
                    END_IF;
                END_IF;
                
                IF _progress = 332 THEN                                                                                     // TemplateTask_10steps_4 running: , <add the detailed description of the current action 3>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#532, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#532;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 333;
                    END_IF;
                END_IF;
                
                IF _progress = 333 THEN                                                                                     // TemplateTask_10steps_4 running: , <add the detailed description of the current action 4>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#533, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#533;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 334;
                    END_IF;
                END_IF;
                
                IF _progress = 334 THEN                                                                                     // TemplateTask_10steps_4 running: , <add the detailed description of the current action 5>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#534, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#534;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 335;
                    END_IF;
                END_IF;
                
                IF _progress = 335 THEN                                                                                     // TemplateTask_10steps_4 running: , <add the detailed description of the current action 6>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#535, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#535;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 336;
                    END_IF;
                END_IF;
                
                IF _progress = 336 THEN                                                                                     // TemplateTask_10steps_4 running: , <add the detailed description of the current action 7>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#536, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#536;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 337;
                    END_IF;
                END_IF;
                
                IF _progress = 337 THEN                                                                                     // TemplateTask_10steps_4 running: , <add the detailed description of the current action 8>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#537, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#537;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 338;
                    END_IF;
                END_IF;
                
                IF _progress = 338 THEN                                                                                     // TemplateTask_10steps_4 running: , <add the detailed description of the current action 9>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#538, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#538;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 339;
                    END_IF;
                END_IF;
                
                IF _progress = 339 THEN                                                                                     // TemplateTask_10steps_4 running: , <add the detailed description of the current action 10>
                    TemplateTask_10steps_4.DoneWhen(TRUE);
                    _progress := 0;
                END_IF;
    
                THIS.CallTimers(TRUE);
                
                TemplateTask_10steps_4.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);  
                TemplateTask_10steps_4.ThrowWhen(TemplateTask_10steps_4.Duration >= Config.TaskTimeout AND Config.TaskTimeout > T#0s ,'TemplateTask_10steps_4 timeout.');                
            END_IF;
            IF TemplateTask_10steps_4.DoneReached() THEN
                Status.Action.Id :=  UINT#131;
                Status.Error.Id :=  UINT#0;
            ELSIF TemplateTask_10steps_4.ErrorOccured() THEN
                Status.Action.Id :=  UINT#10030;
                Status.Error.Id  :=  UINT#10030;
            ELSIF TemplateTask_10steps_4.AbortTriggered()THEN
                Status.Action.Id :=  UINT#10031;
                Status.Error.Id  :=  UINT#10031;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#10030,TemplateTask_10steps_4.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#10031,TemplateTask_10steps_4.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#132,TemplateTask_10steps_4.RestoreTriggered() , eAxoMessageCategory#Error);
            IF TemplateTask_10steps_4.RestoreTriggered() AND _progress >= 330 AND _progress <= 339  THEN
                Status.Action.Id :=  UINT#132;
                _progress := 0;
            END_IF;
            //**************************************************
    
            //*************TemplateTask_10steps_5***************
            TemplateTask_10steps_5.SetIsDisabled(FALSE);
            IF TemplateTask_10steps_5.StartTriggered() THEN
                Status.Action.Id :=  UINT#140;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#140,TemplateTask_10steps_5.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#141,TemplateTask_10steps_5.IsDone(), eAxoMessageCategory#Info);
            IF TemplateTask_10steps_5.Execute(THIS) THEN
                IF _progress = 0 THEN
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 340;
                END_IF;
    
                IF _progress = 340 THEN                                                                                     // TemplateTask_10steps_5 running: , <add the detailed description of the current action 1>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#540, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#540;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 341;
                    END_IF;
                END_IF;
    
                IF _progress = 341 THEN                                                                                     // TemplateTask_10steps_5 running: , <add the detailed description of the current action 2>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#541, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#541;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 342;
                    END_IF;
                END_IF;
                
                IF _progress = 342 THEN                                                                                     // TemplateTask_10steps_5 running: , <add the detailed description of the current action 3>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#542, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#542;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 343;
                    END_IF;
                END_IF;
                
                IF _progress = 343 THEN                                                                                     // TemplateTask_10steps_5 running: , <add the detailed description of the current action 4>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#543, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#543;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 344;
                    END_IF;
                END_IF;
                
                IF _progress = 344 THEN                                                                                     // TemplateTask_10steps_5 running: , <add the detailed description of the current action 5>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#544, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#544;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 345;
                    END_IF;
                END_IF;
                
                IF _progress = 345 THEN                                                                                     // TemplateTask_10steps_5 running: , <add the detailed description of the current action 6>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#545, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#545;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 346;
                    END_IF;
                END_IF;
                
                IF _progress = 346 THEN                                                                                     // TemplateTask_10steps_5 running: , <add the detailed description of the current action 7>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#546, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#546;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 347;
                    END_IF;
                END_IF;
                
                IF _progress = 347 THEN                                                                                     // TemplateTask_10steps_5 running: , <add the detailed description of the current action 8>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#547, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#547;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 348;
                    END_IF;
                END_IF;
                
                IF _progress = 348 THEN                                                                                     // TemplateTask_10steps_5 running: , <add the detailed description of the current action 9>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#548, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#548;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 349;
                    END_IF;
                END_IF;
                
                IF _progress = 349 THEN                                                                                     // TemplateTask_10steps_5 running: , <add the detailed description of the current action 10>
                    TemplateTask_10steps_5.DoneWhen(TRUE);
                    _progress := 0;
                END_IF;
    
                THIS.CallTimers(TRUE);
                
                TemplateTask_10steps_5.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);  
                TemplateTask_10steps_5.ThrowWhen(TemplateTask_10steps_5.Duration >= Config.TaskTimeout AND Config.TaskTimeout > T#0s ,'TemplateTask_10steps_5 timeout.');                
            END_IF;
            IF TemplateTask_10steps_5.DoneReached() THEN
                Status.Action.Id :=  UINT#141;
                Status.Error.Id :=  UINT#0;
            ELSIF TemplateTask_10steps_5.ErrorOccured() THEN
                Status.Action.Id :=  UINT#10040;
                Status.Error.Id  :=  UINT#10040;
            ELSIF TemplateTask_10steps_5.AbortTriggered()THEN
                Status.Action.Id :=  UINT#10041;
                Status.Error.Id  :=  UINT#10041;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#10040,TemplateTask_10steps_5.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#10041,TemplateTask_10steps_5.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#142,TemplateTask_10steps_5.RestoreTriggered() , eAxoMessageCategory#Error);
            IF TemplateTask_10steps_5.RestoreTriggered() AND _progress >= 340 AND _progress <= 349  THEN
                Status.Action.Id :=  UINT#142;
                _progress := 0;
            END_IF;
            //**************************************************
    
            //*************TemplateTask_10steps_6***************
            TemplateTask_10steps_6.SetIsDisabled(FALSE);
            IF TemplateTask_10steps_6.StartTriggered() THEN
                Status.Action.Id :=  UINT#150;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#150,TemplateTask_10steps_6.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#151,TemplateTask_10steps_6.IsDone(), eAxoMessageCategory#Info);
            IF TemplateTask_10steps_6.Execute(THIS) THEN
                IF _progress = 0 THEN
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 350;
                END_IF;
    
                IF _progress = 350 THEN                                                                                     // TemplateTask_10steps_6 running: , <add the detailed description of the current action 1>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#550, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#550;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 351;
                    END_IF;
                END_IF;
    
                IF _progress = 351 THEN                                                                                     // TemplateTask_10steps_6 running: , <add the detailed description of the current action 2>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#551, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#551;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 352;
                    END_IF;
                END_IF;
                
                IF _progress = 352 THEN                                                                                     // TemplateTask_10steps_6 running: , <add the detailed description of the current action 3>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#552, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#552;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 353;
                    END_IF;
                END_IF;
                
                IF _progress = 353 THEN                                                                                     // TemplateTask_10steps_6 running: , <add the detailed description of the current action 4>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#553, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#553;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 354;
                    END_IF;
                END_IF;
                
                IF _progress = 354 THEN                                                                                     // TemplateTask_10steps_6 running: , <add the detailed description of the current action 5>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#554, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#554;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 355;
                    END_IF;
                END_IF;
                
                IF _progress = 355 THEN                                                                                     // TemplateTask_10steps_6 running: , <add the detailed description of the current action 6>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#555, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#555;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 356;
                    END_IF;
                END_IF;
                
                IF _progress = 356 THEN                                                                                     // TemplateTask_10steps_6 running: , <add the detailed description of the current action 7>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#556, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#556;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 357;
                    END_IF;
                END_IF;
                
                IF _progress = 357 THEN                                                                                     // TemplateTask_10steps_6 running: , <add the detailed description of the current action 8>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#557, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#557;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 358;
                    END_IF;
                END_IF;
                
                IF _progress = 358 THEN                                                                                     // TemplateTask_10steps_6 running: , <add the detailed description of the current action 9>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#558, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#558;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 359;
                    END_IF;
                END_IF;
                
                IF _progress = 359 THEN                                                                                     // TemplateTask_10steps_6 running: , <add the detailed description of the current action 10>
                    TemplateTask_10steps_6.DoneWhen(TRUE);
                    _progress := 0;
                END_IF;
    
                THIS.CallTimers(TRUE);
                
                TemplateTask_10steps_6.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);  
                TemplateTask_10steps_6.ThrowWhen(TemplateTask_10steps_6.Duration >= Config.TaskTimeout AND Config.TaskTimeout > T#0s ,'TemplateTask_10steps_6 timeout.');                
            END_IF;
            IF TemplateTask_10steps_6.DoneReached() THEN
                Status.Action.Id :=  UINT#151;
                Status.Error.Id :=  UINT#0;
            ELSIF TemplateTask_10steps_6.ErrorOccured() THEN
                Status.Action.Id :=  UINT#10050;
                Status.Error.Id  :=  UINT#10050;
            ELSIF TemplateTask_10steps_6.AbortTriggered()THEN
                Status.Action.Id :=  UINT#10051;
                Status.Error.Id  :=  UINT#10051;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#10050,TemplateTask_10steps_6.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#10051,TemplateTask_10steps_6.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#152,TemplateTask_10steps_6.RestoreTriggered() , eAxoMessageCategory#Error);
            IF TemplateTask_10steps_6.RestoreTriggered() AND _progress >= 350 AND _progress <= 359  THEN
                Status.Action.Id :=  UINT#152;
                _progress := 0;
            END_IF;
            //**************************************************

    
            //*************TemplateTask_20steps_1***************
            TemplateTask_20steps_1.SetIsDisabled(FALSE);
            IF TemplateTask_20steps_1.StartTriggered() THEN
                Status.Action.Id :=  UINT#160;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#160,TemplateTask_20steps_1.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#161,TemplateTask_20steps_1.IsDone(), eAxoMessageCategory#Info);
            IF TemplateTask_20steps_1.Execute(THIS) THEN
                IF _progress = 0 THEN
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 360;
                END_IF;
    
                IF _progress = 360 THEN                                                                                     // TemplateTask_20steps_1 running: , <add the detailed description of the current action 1>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#560, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#560;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 361;
                    END_IF;
                END_IF;
    
                IF _progress = 361 THEN                                                                                     // TemplateTask_20steps_1 running: , <add the detailed description of the current action 2>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#561, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#561;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 362;
                    END_IF;
                END_IF;
                
                IF _progress = 362 THEN                                                                                     // TemplateTask_20steps_1 running: , <add the detailed description of the current action 3>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#562, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#562;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 363;
                    END_IF;
                END_IF;
                
                IF _progress = 363 THEN                                                                                     // TemplateTask_20steps_1 running: , <add the detailed description of the current action 4>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#563, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#563;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 364;
                    END_IF;
                END_IF;
                
                IF _progress = 364 THEN                                                                                     // TemplateTask_20steps_1 running: , <add the detailed description of the current action 5>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#564, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#564;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 365;
                    END_IF;
                END_IF;
                
                IF _progress = 365 THEN                                                                                     // TemplateTask_20steps_1 running: , <add the detailed description of the current action 6>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#565, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#565;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 366;
                    END_IF;
                END_IF;
                
                IF _progress = 366 THEN                                                                                     // TemplateTask_20steps_1 running: , <add the detailed description of the current action 7>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#566, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#566;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 367;
                    END_IF;
                END_IF;
                
                IF _progress = 367 THEN                                                                                     // TemplateTask_20steps_1 running: , <add the detailed description of the current action 8>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#567, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#567;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 368;
                    END_IF;
                END_IF;
                
                IF _progress = 368 THEN                                                                                     // TemplateTask_20steps_1 running: , <add the detailed description of the current action 9>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#568, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#568;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 369;
                    END_IF;
                END_IF;
                
                IF _progress = 369 THEN                                                                                     // TemplateTask_20steps_1 running: , <add the detailed description of the current action 10>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#569, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#569;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 370;
                    END_IF;
                END_IF;
    
                IF _progress = 370 THEN                                                                                     // TemplateTask_20steps_1 running: , <add the detailed description of the current action 11>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#570, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#570;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 371;
                    END_IF;
                END_IF;
    
                IF _progress = 371 THEN                                                                                     // TemplateTask_20steps_1 running: , <add the detailed description of the current action 12>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#571, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#571;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 372;
                    END_IF;
                END_IF;
                
                IF _progress = 372 THEN                                                                                     // TemplateTask_20steps_1 running: , <add the detailed description of the current action 13>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#572, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#572;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 373;
                    END_IF;
                END_IF;
                
                IF _progress = 373 THEN                                                                                     // TemplateTask_20steps_1 running: , <add the detailed description of the current action 14>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#573, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#573;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 374;
                    END_IF;
                END_IF;
                
                IF _progress = 374 THEN                                                                                     // TemplateTask_20steps_1 running: , <add the detailed description of the current action 15>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#574, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#574;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 375;
                    END_IF;
                END_IF;
                
                IF _progress = 375 THEN                                                                                     // TemplateTask_20steps_1 running: , <add the detailed description of the current action 16>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#575, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#575;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 376;
                    END_IF;
                END_IF;
                
                IF _progress = 376 THEN                                                                                     // TemplateTask_20steps_1 running: , <add the detailed description of the current action 17>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#576, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#576;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 377;
                    END_IF;
                END_IF;
                
                IF _progress = 377 THEN                                                                                     // TemplateTask_20steps_1 running: , <add the detailed description of the current action 18>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#577, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#577;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 378;
                    END_IF;
                END_IF;
                
                IF _progress = 378 THEN                                                                                     // TemplateTask_20steps_1 running: , <add the detailed description of the current action 19>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#578, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#578;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 379;
                    END_IF;
                END_IF;
                
                IF _progress = 379 THEN                                                                                     // TemplateTask_20steps_1 running: , <add the detailed description of the current action 20>
                    TemplateTask_20steps_1.DoneWhen(TRUE);
                    _progress := 0;
                END_IF;
    
                THIS.CallTimers(TRUE);
                
                TemplateTask_20steps_1.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);  
                TemplateTask_20steps_1.ThrowWhen(TemplateTask_20steps_1.Duration >= Config.TaskTimeout AND Config.TaskTimeout > T#0s ,'TemplateTask_20steps_1 timeout.');                
            END_IF;
            IF TemplateTask_20steps_1.DoneReached() THEN
                Status.Action.Id :=  UINT#161;
                Status.Error.Id :=  UINT#0;
            ELSIF TemplateTask_20steps_1.ErrorOccured() THEN
                Status.Action.Id :=  UINT#10060;
                Status.Error.Id  :=  UINT#10060;
            ELSIF TemplateTask_20steps_1.AbortTriggered()THEN
                Status.Action.Id :=  UINT#10061;
                Status.Error.Id  :=  UINT#10061;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#10060,TemplateTask_20steps_1.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#10061,TemplateTask_20steps_1.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#162,TemplateTask_20steps_1.RestoreTriggered() , eAxoMessageCategory#Error);
            IF TemplateTask_20steps_1.RestoreTriggered() AND _progress >= 360 AND _progress <= 379  THEN
                Status.Action.Id :=  UINT#162;
                _progress := 0;
            END_IF;
            //**************************************************            
    
            //*************TemplateTask_20steps_2***************
            TemplateTask_20steps_2.SetIsDisabled(FALSE);
            IF TemplateTask_20steps_2.StartTriggered() THEN
                Status.Action.Id :=  UINT#180;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#180,TemplateTask_20steps_2.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#181,TemplateTask_20steps_2.IsDone(), eAxoMessageCategory#Info);
            IF TemplateTask_20steps_2.Execute(THIS) THEN
                IF _progress = 0 THEN
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 380;
                END_IF;
    
                IF _progress = 380 THEN                                                                                     // TemplateTask_20steps_2 running: , <add the detailed description of the current action 1>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#580, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#580;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 381;
                    END_IF;
                END_IF;
    
                IF _progress = 381 THEN                                                                                     // TemplateTask_20steps_2 running: , <add the detailed description of the current action 2>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#581, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#581;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 382;
                    END_IF;
                END_IF;
                
                IF _progress = 382 THEN                                                                                     // TemplateTask_20steps_2 running: , <add the detailed description of the current action 3>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#582, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#582;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 383;
                    END_IF;
                END_IF;
                
                IF _progress = 383 THEN                                                                                     // TemplateTask_20steps_2 running: , <add the detailed description of the current action 4>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#583, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#583;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 384;
                    END_IF;
                END_IF;
                
                IF _progress = 384 THEN                                                                                     // TemplateTask_20steps_2 running: , <add the detailed description of the current action 5>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#584, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#584;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 385;
                    END_IF;
                END_IF;
                
                IF _progress = 385 THEN                                                                                     // TemplateTask_20steps_2 running: , <add the detailed description of the current action 6>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#585, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#585;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 386;
                    END_IF;
                END_IF;
                
                IF _progress = 386 THEN                                                                                     // TemplateTask_20steps_2 running: , <add the detailed description of the current action 7>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#586, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#586;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 387;
                    END_IF;
                END_IF;
                
                IF _progress = 387 THEN                                                                                     // TemplateTask_20steps_2 running: , <add the detailed description of the current action 8>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#587, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#587;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 388;
                    END_IF;
                END_IF;
                
                IF _progress = 388 THEN                                                                                     // TemplateTask_20steps_2 running: , <add the detailed description of the current action 9>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#588, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#588;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 389;
                    END_IF;
                END_IF;
                
                IF _progress = 389 THEN                                                                                     // TemplateTask_20steps_2 running: , <add the detailed description of the current action 10>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#589, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#589;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 390;
                    END_IF;
                END_IF;
    
                IF _progress = 390 THEN                                                                                     // TemplateTask_20steps_2 running: , <add the detailed description of the current action 11>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#590, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#590;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 391;
                    END_IF;
                END_IF;
    
                IF _progress = 391 THEN                                                                                     // TemplateTask_20steps_2 running: , <add the detailed description of the current action 12>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#591, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#591;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 392;
                    END_IF;
                END_IF;
                
                IF _progress = 392 THEN                                                                                     // TemplateTask_20steps_2 running: , <add the detailed description of the current action 13>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#592, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#592;
                    END_IF;;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 393;
                    END_IF;
                END_IF;
                
                IF _progress = 393 THEN                                                                                     // TemplateTask_20steps_2 running: , <add the detailed description of the current action 14>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#593, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#593;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 394;
                    END_IF;
                END_IF;
                
                IF _progress = 394 THEN                                                                                     // TemplateTask_20steps_2 running: , <add the detailed description of the current action 15>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#594, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#594;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 395;
                    END_IF;
                END_IF;
                
                IF _progress = 395 THEN                                                                                     // TemplateTask_20steps_2 running: , <add the detailed description of the current action 16>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#595, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#595;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 396;
                    END_IF;
                END_IF;
                
                IF _progress = 396 THEN                                                                                     // TemplateTask_20steps_2 running: , <add the detailed description of the current action 17>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#596, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#596;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 397;
                    END_IF;
                END_IF;
                
                IF _progress = 397 THEN                                                                                     // TemplateTask_20steps_2 running: , <add the detailed description of the current action 18>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#597, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#597;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 398;
                    END_IF;
                END_IF;
                
                IF _progress = 398 THEN                                                                                     // TemplateTask_20steps_2 running: , <add the detailed description of the current action 19>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#598, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#598;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 399;
                    END_IF;
                END_IF;
                
                IF _progress = 399 THEN                                                                                     // TemplateTask_20steps_2 running: , <add the detailed description of the current action 20>
                    TemplateTask_20steps_2.DoneWhen(TRUE);
                    _progress := 0;
                END_IF;
    
                THIS.CallTimers(TRUE);
                TemplateTask_20steps_2.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);  
                TemplateTask_20steps_2.ThrowWhen(TemplateTask_20steps_2.Duration >= Config.TaskTimeout AND Config.TaskTimeout > T#0s ,'TemplateTask_20steps_2 timeout.');                
            END_IF;
            IF TemplateTask_20steps_2.DoneReached() THEN
                Status.Action.Id :=  UINT#181;
                Status.Error.Id :=  UINT#0;
            ELSIF TemplateTask_20steps_2.ErrorOccured() THEN
                Status.Action.Id :=  UINT#10080;
                Status.Error.Id  :=  UINT#10080;
            ELSIF TemplateTask_20steps_2.AbortTriggered()THEN
                Status.Action.Id :=  UINT#10081;
                Status.Error.Id  :=  UINT#10081;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#10080,TemplateTask_20steps_2.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#10081,TemplateTask_20steps_2.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#182,TemplateTask_20steps_2.RestoreTriggered() , eAxoMessageCategory#Error);
            IF TemplateTask_20steps_2.RestoreTriggered() AND _progress >= 380 AND _progress <= 399  THEN
                Status.Action.Id :=  UINT#182;
                _progress := 0;
            END_IF;
            //**************************************************
    
            //*************TemplateTask_20steps_3***************
            TemplateTask_20steps_3.SetIsDisabled(FALSE);
            IF TemplateTask_20steps_3.StartTriggered() THEN
                Status.Action.Id :=  UINT#200;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#200,TemplateTask_20steps_3.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#201,TemplateTask_20steps_3.IsDone(), eAxoMessageCategory#Info);
            IF TemplateTask_20steps_3.Execute(THIS) THEN
                IF _progress = 0 THEN
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 400;
                END_IF;
    
                IF _progress = 400 THEN                                                                                     // TemplateTask_20steps_3 running: , <add the detailed description of the current action 1>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#600, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#600;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 401;
                    END_IF;
                END_IF;
    
                IF _progress = 401 THEN                                                                                     // TemplateTask_20steps_3 running: , <add the detailed description of the current action 2>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#601, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#601;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 402;
                    END_IF;
                END_IF;
                
                IF _progress = 402 THEN                                                                                     // TemplateTask_20steps_3 running: , <add the detailed description of the current action 3>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#602, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#602;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 403;
                    END_IF;
                END_IF;
                
                IF _progress = 403 THEN                                                                                     // TemplateTask_20steps_3 running: , <add the detailed description of the current action 4>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#603, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#603;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 404;
                    END_IF;
                END_IF;
                
                IF _progress = 404 THEN                                                                                     // TemplateTask_20steps_3 running: , <add the detailed description of the current action 5>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#604, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#604;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 405;
                    END_IF;
                END_IF;
                
                IF _progress = 405 THEN                                                                                     // TemplateTask_20steps_3 running: , <add the detailed description of the current action 6>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#605, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#605;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 406;
                    END_IF;
                END_IF;
                
                IF _progress = 406 THEN                                                                                     // TemplateTask_20steps_3 running: , <add the detailed description of the current action 7>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#606, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#606;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 407;
                    END_IF;
                END_IF;
                
                IF _progress = 407 THEN                                                                                     // TemplateTask_20steps_3 running: , <add the detailed description of the current action 8>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#607, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#607;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 408;
                    END_IF;
                END_IF;
                
                IF _progress = 408 THEN                                                                                     // TemplateTask_20steps_3 running: , <add the detailed description of the current action 9>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#608, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#608;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 409;
                    END_IF;
                END_IF;
                
                IF _progress = 409 THEN                                                                                     // TemplateTask_20steps_3 running: , <add the detailed description of the current action 10>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#609, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#609;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 410;
                    END_IF;
                END_IF;
    
                IF _progress = 410 THEN                                                                                     // TemplateTask_20steps_3 running: , <add the detailed description of the current action 11>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#610, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#610;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 411;
                    END_IF;
                END_IF;
    
                IF _progress = 411 THEN                                                                                     // TemplateTask_20steps_3 running: , <add the detailed description of the current action 12>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#611, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#611;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 412;
                    END_IF;
                END_IF;
                
                IF _progress = 412 THEN                                                                                     // TemplateTask_20steps_3 running: , <add the detailed description of the current action 13>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#612, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#612;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 413;
                    END_IF;
                END_IF;
                
                IF _progress = 413 THEN                                                                                     // TemplateTask_20steps_3 running: , <add the detailed description of the current action 14>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#613, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#613;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 414;
                    END_IF;
                END_IF;
                
                IF _progress = 414 THEN                                                                                     // TemplateTask_20steps_3 running: , <add the detailed description of the current action 15>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#614, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#614;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 415;
                    END_IF;
                END_IF;
                
                IF _progress = 415 THEN                                                                                     // TemplateTask_20steps_3 running: , <add the detailed description of the current action 16>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#615, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#615;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 416;
                    END_IF;
                END_IF;
                
                IF _progress = 416 THEN                                                                                     // TemplateTask_20steps_3 running: , <add the detailed description of the current action 17>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#616, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#616;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 417;
                    END_IF;
                END_IF;
                
                IF _progress = 417 THEN                                                                                     // TemplateTask_20steps_3 running: , <add the detailed description of the current action 18>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#617, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#617;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 418;
                    END_IF;
                END_IF;
                
                IF _progress = 418 THEN                                                                                     // TemplateTask_20steps_3 running: , <add the detailed description of the current action 19>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#618, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#618;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 419;
                    END_IF;
                END_IF;
                
                IF _progress = 419 THEN                                                                                     // TemplateTask_20steps_3 running: , <add the detailed description of the current action 20>
                    TemplateTask_20steps_3.DoneWhen(TRUE);
                    _progress := 0;
                END_IF;
    
                THIS.CallTimers(TRUE);
                
                TemplateTask_20steps_3.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);  
                TemplateTask_20steps_3.ThrowWhen(TemplateTask_20steps_3.Duration >= Config.TaskTimeout AND Config.TaskTimeout > T#0s ,'TemplateTask_20steps_3 timeout.');                
            END_IF;
            IF TemplateTask_20steps_3.DoneReached() THEN
                Status.Action.Id :=  UINT#201;
                Status.Error.Id :=  UINT#0;
            ELSIF TemplateTask_20steps_3.ErrorOccured() THEN
                Status.Action.Id :=  UINT#10100;
                Status.Error.Id  :=  UINT#10100;
            ELSIF TemplateTask_20steps_3.AbortTriggered()THEN
                Status.Action.Id :=  UINT#10101;
                Status.Error.Id  :=  UINT#10101;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#10100,TemplateTask_20steps_3.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#10101,TemplateTask_20steps_3.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#202,TemplateTask_20steps_3.RestoreTriggered() , eAxoMessageCategory#Error);
            IF TemplateTask_20steps_3.RestoreTriggered() AND _progress >= 400 AND _progress <= 419  THEN
                Status.Action.Id :=  UINT#202;
                _progress := 0;
            END_IF;
            //**************************************************
    
            //*************TemplateTask_20steps_4***************
            TemplateTask_20steps_4.SetIsDisabled(FALSE);
            IF TemplateTask_20steps_4.StartTriggered() THEN
                Status.Action.Id :=  UINT#220;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#220,TemplateTask_20steps_4.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#221,TemplateTask_20steps_4.IsDone(), eAxoMessageCategory#Info);
            IF TemplateTask_20steps_4.Execute(THIS) THEN
                IF _progress = 0 THEN
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 420;
                END_IF;
    
                IF _progress = 420 THEN                                                                                     // TemplateTask_20steps_4 running: , <add the detailed description of the current action 1>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#620, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#620;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 421;
                    END_IF;
                END_IF;
    
                IF _progress = 421 THEN                                                                                     // TemplateTask_20steps_4 running: , <add the detailed description of the current action 2>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#621, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#621;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 422;
                    END_IF;
                END_IF;
                
                IF _progress = 422 THEN                                                                                     // TemplateTask_20steps_4 running: , <add the detailed description of the current action 3>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#622, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#622;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 423;
                    END_IF;
                END_IF;
                
                IF _progress = 423 THEN                                                                                     // TemplateTask_20steps_4 running: , <add the detailed description of the current action 4>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#623, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#623;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 424;
                    END_IF;
                END_IF;
                
                IF _progress = 424 THEN                                                                                     // TemplateTask_20steps_4 running: , <add the detailed description of the current action 5>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#624, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#624;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 425;
                    END_IF;
                END_IF;
                
                IF _progress = 425 THEN                                                                                     // TemplateTask_20steps_4 running: , <add the detailed description of the current action 6>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#625, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#625;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 426;
                    END_IF;
                END_IF;
                
                IF _progress = 426 THEN                                                                                     // TemplateTask_20steps_4 running: , <add the detailed description of the current action 7>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#626, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#626;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 427;
                    END_IF;
                END_IF;
                
                IF _progress = 427 THEN                                                                                     // TemplateTask_20steps_4 running: , <add the detailed description of the current action 8>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#627, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#627;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 428;
                    END_IF;
                END_IF;
                
                IF _progress = 428 THEN                                                                                     // TemplateTask_20steps_4 running: , <add the detailed description of the current action 9>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#628, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#628;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 429;
                    END_IF;
                END_IF;
                
                IF _progress = 429 THEN                                                                                     // TemplateTask_20steps_4 running: , <add the detailed description of the current action 10>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#629, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#629;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 430;
                    END_IF;
                END_IF;
    
                IF _progress = 430 THEN                                                                                     // TemplateTask_20steps_4 running: , <add the detailed description of the current action 11>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#630, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#630;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 431;
                    END_IF;
                END_IF;
    
                IF _progress = 431 THEN                                                                                     // TemplateTask_20steps_4 running: , <add the detailed description of the current action 12>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#631, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#631;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 432;
                    END_IF;
                END_IF;
                
                IF _progress = 432 THEN                                                                                     // TemplateTask_20steps_4 running: , <add the detailed description of the current action 13>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#632, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#632;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 433;
                    END_IF;
                END_IF;
                
                IF _progress = 433 THEN                                                                                     // TemplateTask_20steps_4 running: , <add the detailed description of the current action 14>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#633, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#633;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 434;
                    END_IF;
                END_IF;
                
                IF _progress = 434 THEN                                                                                     // TemplateTask_20steps_4 running: , <add the detailed description of the current action 15>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#634, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#634;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 435;
                    END_IF;
                END_IF;
                
                IF _progress = 435 THEN                                                                                     // TemplateTask_20steps_4 running: , <add the detailed description of the current action 16>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#635, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#635;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 436;
                    END_IF;
                END_IF;
                
                IF _progress = 436 THEN                                                                                     // TemplateTask_20steps_4 running: , <add the detailed description of the current action 17>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#636, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#636;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 437;
                    END_IF;
                END_IF;
                
                IF _progress = 437 THEN                                                                                     // TemplateTask_20steps_4 running: , <add the detailed description of the current action 18>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#637, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#637;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 438;
                    END_IF;
                END_IF;
                
                IF _progress = 438 THEN                                                                                     // TemplateTask_20steps_4 running: , <add the detailed description of the current action 19>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#638, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#638;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 439;
                    END_IF;
                END_IF;
                
                IF _progress = 439 THEN                                                                                     // TemplateTask_20steps_4 running: , <add the detailed description of the current action 20>
                    TemplateTask_20steps_4.DoneWhen(TRUE);
                    _progress := 0;
                END_IF;
    
                THIS.CallTimers(TRUE);
                
                TemplateTask_20steps_4.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);  
                TemplateTask_20steps_4.ThrowWhen(TemplateTask_20steps_4.Duration >= Config.TaskTimeout AND Config.TaskTimeout > T#0s ,'TemplateTask_20steps_4 timeout.');                
            END_IF;
            IF TemplateTask_20steps_4.DoneReached() THEN
                Status.Action.Id :=  UINT#221;
                Status.Error.Id :=  UINT#0;
            ELSIF TemplateTask_20steps_4.ErrorOccured() THEN
                Status.Action.Id :=  UINT#10120;
                Status.Error.Id  :=  UINT#10120;
            ELSIF TemplateTask_20steps_4.AbortTriggered()THEN
                Status.Action.Id :=  UINT#10121;
                Status.Error.Id  :=  UINT#10121;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#10120,TemplateTask_20steps_4.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#10121,TemplateTask_20steps_4.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#222,TemplateTask_20steps_4.RestoreTriggered() , eAxoMessageCategory#Error);
            IF TemplateTask_20steps_4.RestoreTriggered() AND _progress >= 420 AND _progress <= 439  THEN
                Status.Action.Id :=  UINT#222;
                _progress := 0;
            END_IF;
            //**************************************************       
            
            //*************TemplateTask_20steps_5***************
            TemplateTask_20steps_5.SetIsDisabled(FALSE);
            IF TemplateTask_20steps_5.StartTriggered() THEN
                Status.Action.Id :=  UINT#240;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#240,TemplateTask_20steps_5.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#241,TemplateTask_20steps_5.IsDone(), eAxoMessageCategory#Info);
            IF TemplateTask_20steps_5.Execute(THIS) THEN
                IF _progress = 0 THEN
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 440;
                END_IF;
    
                IF _progress = 440 THEN                                                                                     // TemplateTask_20steps_5 running: , <add the detailed description of the current action 1>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#640, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#640;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 441;
                    END_IF;
                END_IF;
    
                IF _progress = 441 THEN                                                                                     // TemplateTask_20steps_5 running , <add the detailed description of the current action 2>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#641, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#641;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 442;
                    END_IF;
                END_IF;
                
                IF _progress = 442 THEN                                                                                     // TemplateTask_20steps_5 running: , <add the detailed description of the current action 3>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#642, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#642;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 443;
                    END_IF;
                END_IF;
                
                IF _progress = 443 THEN                                                                                     // TemplateTask_20steps_5 running: , <add the detailed description of the current action 4>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#643, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#643;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 444;
                    END_IF;
                END_IF;
                
                IF _progress = 444 THEN                                                                                     // TemplateTask_20steps_5 running: , <add the detailed description of the current action 5>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#644, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#644;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 445;
                    END_IF;
                END_IF;
                
                IF _progress = 445 THEN                                                                                     // TemplateTask_20steps_5 running: , <add the detailed description of the current action 6>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#645, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#645;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 446;
                    END_IF;
                END_IF;
                
                IF _progress = 446 THEN                                                                                     // TemplateTask_20steps_5 running: , <add the detailed description of the current action 7>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#646, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#646;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 447;
                    END_IF;
                END_IF;
                
                IF _progress = 447 THEN                                                                                     // TemplateTask_20steps_5 running: , <add the detailed description of the current action 8>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#647, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#647;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 448;
                    END_IF;
                END_IF;
                
                IF _progress = 448 THEN                                                                                     // TemplateTask_20steps_5 running: , <add the detailed description of the current action 9>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#648, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#648;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 449;
                    END_IF;
                END_IF;
                
                IF _progress = 449 THEN                                                                                     // TemplateTask_20steps_5 running: , <add the detailed description of the current action 10>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#649, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#649;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 450;
                    END_IF;
                END_IF;
    
                IF _progress = 450 THEN                                                                                     // TemplateTask_20steps_5 running: , <add the detailed description of the current action 11>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#650, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#650;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 451;
                    END_IF;
                END_IF;
    
                IF _progress = 451 THEN                                                                                     // TemplateTask_20steps_5 running: , <add the detailed description of the current action 12>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#651, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#651;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 452;
                    END_IF;
                END_IF;
                
                IF _progress = 452 THEN                                                                                     // TemplateTask_20steps_5 running: , <add the detailed description of the current action 13>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#652, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#652;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 453;
                    END_IF;
                END_IF;
                
                IF _progress = 453 THEN                                                                                     // TemplateTask_20steps_5 running: , <add the detailed description of the current action 14>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#653, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#653;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 454;
                    END_IF;
                END_IF;
                
                IF _progress = 454 THEN                                                                                     // TemplateTask_20steps_5 running: , <add the detailed description of the current action 15>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#654, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#654;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 455;
                    END_IF;
                END_IF;
                
                IF _progress = 455 THEN                                                                                     // TemplateTask_20steps_5 running: , <add the detailed description of the current action 16>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#655, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#655;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 456;
                    END_IF;
                END_IF;
                
                IF _progress = 456 THEN                                                                                     // TemplateTask_20steps_5 running: , <add the detailed description of the current action 17>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#656, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#656;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 457;
                    END_IF;
                END_IF;
                
                IF _progress = 457 THEN                                                                                     // TemplateTask_20steps_5 running: , <add the detailed description of the current action 18>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#657, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#657;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 458;
                    END_IF;
                END_IF;
                
                IF _progress = 458 THEN                                                                                     // TemplateTask_20steps_5 running: , <add the detailed description of the current action 19>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#658, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#658;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 459;
                    END_IF;
                END_IF;
                
                IF _progress = 459 THEN                                                                                     // TemplateTask_20steps_5 running: , <add the detailed description of the current action 20>
                    TemplateTask_20steps_5.DoneWhen(TRUE);
                    _progress := 0;
                END_IF;
    
                THIS.CallTimers(TRUE);
                
                TemplateTask_20steps_5.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);  
                TemplateTask_20steps_5.ThrowWhen(TemplateTask_20steps_5.Duration >= Config.TaskTimeout AND Config.TaskTimeout > T#0s ,'TemplateTask_20steps_5 timeout.');                
            END_IF;
            IF TemplateTask_20steps_5.DoneReached() THEN
                Status.Action.Id :=  UINT#241;
                Status.Error.Id :=  UINT#0;
            ELSIF TemplateTask_20steps_5.ErrorOccured() THEN
                Status.Action.Id :=  UINT#10140;
                Status.Error.Id  :=  UINT#10140;
            ELSIF TemplateTask_20steps_5.AbortTriggered()THEN
                Status.Action.Id :=  UINT#10141;
                Status.Error.Id  :=  UINT#10141;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#10140,TemplateTask_20steps_5.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#10141,TemplateTask_20steps_5.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#242,TemplateTask_20steps_5.RestoreTriggered() , eAxoMessageCategory#Error);
            IF TemplateTask_20steps_5.RestoreTriggered() AND _progress >= 440 AND _progress <= 459  THEN
                Status.Action.Id :=  UINT#242;
                _progress := 0;
            END_IF;
            //**************************************************
            
            //*************TemplateTask_20steps_6***************
            TemplateTask_20steps_6.SetIsDisabled(FALSE);
            IF TemplateTask_20steps_6.StartTriggered() THEN
                Status.Action.Id :=  UINT#260;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#260,TemplateTask_20steps_6.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#261,TemplateTask_20steps_6.IsDone(), eAxoMessageCategory#Info);
            IF TemplateTask_20steps_6.Execute(THIS) THEN
                IF _progress = 0 THEN
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 460;
                END_IF;
    
                IF _progress = 460 THEN                                                                                     // TemplateTask_20steps_6 running: , <add the detailed description of the current action 1>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#660, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#660;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 461;
                    END_IF;
                END_IF;
    
                IF _progress = 461 THEN                                                                                     // TemplateTask_20steps_6 running: , <add the detailed description of the current action 2>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#661, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#661;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 462;
                    END_IF;
                END_IF;
                
                IF _progress = 462 THEN                                                                                     // TemplateTask_20steps_6 running: , <add the detailed description of the current action 3>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#662, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#662;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 463;
                    END_IF;
                END_IF;
                
                IF _progress = 463 THEN                                                                                     // TemplateTask_20steps_6 running: , <add the detailed description of the current action 4>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#663, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#663;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 464;
                    END_IF;
                END_IF;
                
                IF _progress = 464 THEN                                                                                     // TemplateTask_20steps_6 running: , <add the detailed description of the current action 5>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#664, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#664;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 465;
                    END_IF;
                END_IF;
                
                IF _progress = 465 THEN                                                                                     // TemplateTask_20steps_6 running: , <add the detailed description of the current action 6>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#665, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#665;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 466;
                    END_IF;
                END_IF;
                
                IF _progress = 466 THEN                                                                                     // TemplateTask_20steps_6 running: , <add the detailed description of the current action 7>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#666, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#666;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 467;
                    END_IF;
                END_IF;
                
                IF _progress = 467 THEN                                                                                     // TemplateTask_20steps_6 running: , <add the detailed description of the current action 8>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#667, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#667;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 468;
                    END_IF;
                END_IF;
                
                IF _progress = 468 THEN                                                                                     // TemplateTask_20steps_6 running: , <add the detailed description of the current action 9>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#668, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#668;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 469;
                    END_IF;
                END_IF;
                
                IF _progress = 469 THEN                                                                                     // TemplateTask_20steps_6 running: , <add the detailed description of the current action 10>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#669, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#669;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 470;
                    END_IF;
                END_IF;
    
                IF _progress = 470 THEN                                                                                     // TemplateTask_20steps_6 running: , <add the detailed description of the current action 11>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#670, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#670;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 471;
                    END_IF;
                END_IF;
    
                IF _progress = 471 THEN                                                                                     // TemplateTask_20steps_6 running: , <add the detailed description of the current action 12>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#671, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#671;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 472;
                    END_IF;
                END_IF;
                
                IF _progress = 472 THEN                                                                                     // TemplateTask_20steps_6 running: , <add the detailed description of the current action 13>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#672, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#672;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 473;
                    END_IF;
                END_IF;
                
                IF _progress = 473 THEN                                                                                     // TemplateTask_20steps_6 running: , <add the detailed description of the current action 14>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#673, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#673;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 474;
                    END_IF;
                END_IF;
                
                IF _progress = 474 THEN                                                                                     // TemplateTask_20steps_6 running: , <add the detailed description of the current action 15>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#674, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#674;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 475;
                    END_IF;
                END_IF;
                
                IF _progress = 475 THEN                                                                                     // TemplateTask_20steps_6 running: , <add the detailed description of the current action 16>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#675, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#675;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 476;
                    END_IF;
                END_IF;
                
                IF _progress = 476 THEN                                                                                     // TemplateTask_20steps_6 running: , <add the detailed description of the current action 17>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#676, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#676;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 477;
                    END_IF;
                END_IF;
                
                IF _progress = 477 THEN                                                                                     // TemplateTask_20steps_6 running: , <add the detailed description of the current action 18>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#677, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#677;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 478;
                    END_IF;
                END_IF;
                
                IF _progress = 478 THEN                                                                                     // TemplateTask_20steps_6 running: , <add the detailed description of the current action 19>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#678, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#678;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 479;
                    END_IF;
                END_IF;
                
                IF _progress = 479 THEN                                                                                     // TemplateTask_20steps_6 running: , <add the detailed description of the current action 20>
                    TemplateTask_20steps_6.DoneWhen(TRUE);
                    _progress := 0;
                END_IF;
    
                THIS.CallTimers(TRUE);
                
                TemplateTask_20steps_6.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);  
                TemplateTask_20steps_6.ThrowWhen(TemplateTask_20steps_6.Duration >= Config.TaskTimeout AND Config.TaskTimeout > T#0s ,'TemplateTask_20steps_6 timeout.');                
            END_IF;
            IF TemplateTask_20steps_6.DoneReached() THEN
                Status.Action.Id :=  UINT#261;
                Status.Error.Id :=  UINT#0;
            ELSIF TemplateTask_20steps_6.ErrorOccured() THEN
                Status.Action.Id :=  UINT#10160;
                Status.Error.Id  :=  UINT#10160;
            ELSIF TemplateTask_20steps_6.AbortTriggered()THEN
                Status.Action.Id :=  UINT#10161;
                Status.Error.Id  :=  UINT#10161;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#10160,TemplateTask_20steps_6.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#10161,TemplateTask_20steps_6.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#262,TemplateTask_20steps_6.RestoreTriggered() , eAxoMessageCategory#Error);
            IF TemplateTask_20steps_6.RestoreTriggered() AND _progress >= 460 AND _progress <= 479  THEN
                Status.Action.Id :=  UINT#262;
                _progress := 0;
            END_IF;
            //******************************************      

            //***********Update outputs ****************
            // ============================================================================
            // Network 14: Write synchronous data to the module (outputs)
            // ============================================================================

            // This is new outputs writing =>
            _data_out[0].%X0    :=  Outputs.N0;
            _data_out[0].%X1    :=  Outputs.N01;
            _data_out[0].%X2    :=  Outputs.N02;
            _data_out[0].%X3    :=  Outputs.N03;
            _data_out[0].%X4    :=  Outputs.N04;
            _data_out[0].%X5    :=  Outputs.N05;
            _data_out[0].%X6    :=  Outputs.N06;
            _data_out[0].%X7    :=  Outputs.ClearSetup;
            _data_out[1].%X0    :=  Outputs.N2;
            _data_out[1].%X1    :=  Outputs.N3;
            _data_out[1].%X2    :=  Outputs.N4;
            _data_out[1].%X3    :=  Outputs.N5;
            _data_out[1].%X4    :=  Outputs.N6;
            _data_out[1].%X5    :=  Outputs.N7;
            _data_out[1].%X6    :=  Outputs.N8;
            _data_out[1].%X7    :=  Outputs.N9;
            _data_out[2].%X0    :=  Outputs.RunScan;
            _data_out[2].%X1    :=  Outputs.N11;
            _data_out[2].%X2    :=  Outputs.N12;
            _data_out[2].%X3    :=  Outputs.N13;
            _data_out[2].%X4    :=  Outputs.N14;
            _data_out[2].%X5    :=  Outputs.N15;
            _data_out[2].%X6    :=  Outputs.N16;
            _data_out[2].%X7    :=  Outputs.N17;
            _data_out[3].%X0    :=  Outputs.RunContinuously;
            _data_out[3].%X1    :=  Outputs.RunWeld;
            _data_out[3].%X2    :=  Outputs.RunTest;
            _data_out[3].%X3    :=  Outputs.ClearError;
            _data_out[3].%X4    :=  Outputs.OTF_AmplitudeEnable;
            _data_out[3].%X5    :=  Outputs.CycleStop;
            _data_out[3].%X6    :=  Outputs.FrontPanelLockout_0;
            _data_out[3].%X7    :=  Outputs.FrontPanelLockout_1;

            tmp_DW              :=  TO_DWORD(Outputs.OTF_Amp_Setpoint); 
            _data_out[4]        :=  tmp_DW.%B3;
            _data_out[5]        :=  tmp_DW.%B2;
            _data_out[6]        :=  tmp_DW.%B1;
            _data_out[7]        :=  tmp_DW.%B0;

            tmp_DW              :=  TO_DWORD(Outputs.ActiveSetupSelection); 
            _data_out[8]        :=  tmp_DW.%B3;
            _data_out[9]        :=  tmp_DW.%B2;
            _data_out[10]       :=  tmp_DW.%B1;
            _data_out[11]       :=  tmp_DW.%B0;

            tmp_DW              :=  TO_DWORD(Outputs.RunningSetupSelection); 
            _data_out[12]       :=  tmp_DW.%B3;
            _data_out[13]       :=  tmp_DW.%B2;
            _data_out[14]       :=  tmp_DW.%B1;
            _data_out[15]       :=  tmp_DW.%B0;

            tmp_DW              :=  TO_DWORD(Outputs.RunningMPCProbeSelection); 
            _data_out[16]       :=  tmp_DW.%B3;
            _data_out[17]       :=  tmp_DW.%B2;
            _data_out[18]       :=  tmp_DW.%B1;
            _data_out[19]       :=  tmp_DW.%B0;

            _retval := WriteData(LADDR := TO_WORD(Config.HWIDs.HwID_PLC_to_iQ_Outputs),RECORD := _data_out);
            IF _retval > WORD#0 THEN
                Messenger.Activate(UINT#1231, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1231;
                RETURN;
            END_IF;            
            // <= This is new outputs writing 

            // ============================================================================
            // Network 15: Read req - HMI export (indicators)
            // ============================================================================
            // tof_async_read_ind(IN := (par_read_map <> 0) OR (on_demand_read_map <> 0) OR (model_read_map <> 0),PT := T#500ms);
            // Hmi.s.AsyncReadIndicator := tof_async_read_ind.Q;
            tof_async_read_ind(signal := (par_read_map <> WORD#0) OR (on_demand_read_map <> WORD#0) OR (model_read_map <> WORD#0) , duration := T#500ms);
            Hmi.s.AsyncReadIndicator := tof_async_read_ind.output;
            
            
            // ============================================================================
            // Network 19: Write req - HMI export (indicators) + response handling
            // ============================================================================
            
            tof_async_write_ind(signal := (par_write_map <> WORD#0) OR (on_demand_write_map <> WORD#0), duration := T#500ms);
            Hmi.s.AsyncWriteIndicator := tof_async_write_ind.output;
            
        END_METHOD

        METHOD PUBLIC TemplateMethod_10steps_1 : IAxoTaskState
            TemplateMethod_10steps_1 := TemplateTask_10steps_1.Invoke(THIS);
        END_METHOD

        METHOD PUBLIC TemplateMethod_10steps_2 : IAxoTaskState
            TemplateMethod_10steps_2 := TemplateTask_10steps_2.Invoke(THIS);
        END_METHOD

        METHOD PUBLIC TemplateMethod_10steps_3 : IAxoTaskState
            TemplateMethod_10steps_3 := TemplateTask_10steps_3.Invoke(THIS);
        END_METHOD

        METHOD PUBLIC TemplateMethod_10steps_4 : IAxoTaskState
            TemplateMethod_10steps_4 := TemplateTask_10steps_4.Invoke(THIS);
        END_METHOD

        METHOD PUBLIC TemplateMethod_10steps_5 : IAxoTaskState
            TemplateMethod_10steps_5 := TemplateTask_10steps_5.Invoke(THIS);
        END_METHOD

        METHOD PUBLIC TemplateMethod_10steps_6 : IAxoTaskState
            TemplateMethod_10steps_6 := TemplateTask_10steps_6.Invoke(THIS);
        END_METHOD

        METHOD PUBLIC TemplateMethod_20steps_1 : IAxoTaskState
            TemplateMethod_20steps_1 := TemplateTask_20steps_1.Invoke(THIS);
        END_METHOD

        METHOD PUBLIC TemplateMethod_20steps_2 : IAxoTaskState
            TemplateMethod_20steps_2 := TemplateTask_20steps_2.Invoke(THIS);
        END_METHOD

        METHOD PUBLIC TemplateMethod_20steps_3 : IAxoTaskState
            TemplateMethod_20steps_3 := TemplateTask_20steps_3.Invoke(THIS);
        END_METHOD

        METHOD PUBLIC TemplateMethod_20steps_4 : IAxoTaskState
            TemplateMethod_20steps_4 := TemplateTask_20steps_4.Invoke(THIS);
        END_METHOD

        METHOD PUBLIC TemplateMethod_20steps_5 : IAxoTaskState
            TemplateMethod_20steps_5 := TemplateTask_20steps_5.Invoke(THIS);
        END_METHOD

        METHOD PUBLIC TemplateMethod_20steps_6 : IAxoTaskState
            TemplateMethod_20steps_6 := TemplateTask_20steps_6.Invoke(THIS);
        END_METHOD


        METHOD PROTECTED OVERRIDE ManualControl
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

            _data_out_1[0] := BYTE#0;
            _data_out_2[0] := BYTE#0;
            _data_out_2[1] := BYTE#0;

            FOR _index := 0 TO 3 DO
                _data_in[_index] := BYTE#0;
                _data_out_4[_index] := BYTE#0;
                _data_out_8[_index] := BYTE#0;
                _data_out_255[_index] := BYTE#0;
            END_FOR;

            FOR _index := 4 TO 7 DO
                _data_in[_index] := BYTE#0;
                _data_out_8[_index] := BYTE#0;
                _data_out_255[_index] := BYTE#0;
            END_FOR;

            FOR _index := 8 TO 254 DO
                _data_in[_index] := BYTE#0;
                _data_out_255[_index] := BYTE#0;
            END_FOR;

            _word           :=   WORD#0;
            _dword          :=   DWORD#0;


            TemplateTask_10steps_1.Restore();
            TemplateTask_10steps_2.Restore();
            TemplateTask_10steps_3.Restore();
            TemplateTask_10steps_4.Restore();
            TemplateTask_10steps_5.Restore();
            TemplateTask_10steps_6.Restore();
            TemplateTask_20steps_1.Restore();
            TemplateTask_20steps_2.Restore();
            TemplateTask_20steps_3.Restore();
            TemplateTask_20steps_4.Restore();
            TemplateTask_20steps_5.Restore();
            TemplateTask_20steps_6.Restore();
            HardwareDiagnosticsTask.Restore();

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



