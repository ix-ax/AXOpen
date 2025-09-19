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

        VAR PUBLIC // Parameters
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("Parameters")]}
            {#ix-attr:[ReadOnly()]}
            {#ix-set:AttributeName = "<#Parameters#>"}
            Parameters : Axo_IQ_SeriesWelder_Parameters;       // Parameters (to be potentialy edited by user)
        END_VAR

        VAR PUBLIC // Buffers
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("Buffers")]}
            {#ix-attr:[ReadOnly()]}
            {#ix-set:AttributeName = "<#ReadBuffers#>"}
            ReadBuffers : Axo_IQ_SeriesWelder_Buffers;          // Read buffers for parameter data transfer and user change detection
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("Buffers")]}
            {#ix-attr:[ReadOnly()]}
            {#ix-set:AttributeName = "<#WriteBuffers#>"}
            WriteBuffers : Axo_IQ_SeriesWelder_Buffers;         // Write buffers for parameter transfer to the iQ (also to prevent inconsistent changes during transfer)
        END_VAR

        VAR PUBLIC // ModelInfo
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("ModelInfo")]}
            {#ix-attr:[ReadOnly()]}
            {#ix-set:AttributeName = "<#ModelInfo#>"}
            ModelInfo   : Axo_IQ_SeriesWelder_ModelInfo;        // Information on HW / SW versions etc.
        END_VAR

        VAR PUBLIC // Hmi
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("Hmi")]}
            {#ix-attr:[ReadOnly()]}
            {#ix-set:AttributeName = "<#Hmi#>"}
            Hmi                     : Axo_IQ_SeriesWelder_HMI;              // HMI control bits and values (apart from parameters)
        END_VAR

        VAR PUBLIC // TestScanResults
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("TestScanResults")]}
            {#ix-attr:[ReadOnly()]}
            {#ix-set:AttributeName = "<#TestScanResults#>"}
            TestScanResults       : Axo_IQ_SeriesWelder_TestScanResults;
        END_VAR

        VAR PUBLIC // CopySetup
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("CopySetup")]}
            {#ix-attr:[ReadOnly()]}
            {#ix-set:AttributeName = "<#CopySetup#>"}
            CopySetup             : Axo_IQ_SeriesWelder_CopySetup;
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
            iq_if : Axo_IQ_SeriesWelder_Interface;            // Main interface UDT (parameters, buffers, HMI)
            Config_reset_on_coms_fault : BOOL := TRUE;
            Config_async_write_permited : BOOL := TRUE;
            AxoTaskCompareThisCycle : BOOL := TRUE;
            AxoTaskRefresh : BOOL := FALSE;
            synchronous_read_retval : INT := INT#0;           // DPRD_DAT RET_VAL
            synchronous_write_retval : INT := INT#0;          // DPWR_DAT RET_VAL
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
            WriteRecord : WriteRecord;                        // ====== Indications (HMI) ======
            ton_coms_stable : OnDelay; // TON_TIME;
            tof_async_read_ind : OffDelay; // TOF_TIME;
            tof_async_write_ind : OffDelay; // TOF_TIME;      // ====== String read buffer for model/fw versions ======
            str_read_buffer_254 : ARRAY[0..253] OF BYTE;           
            write_buffer_254 : ARRAY[0..253] OF BYTE;           
            buf_test_scan_result : Axo_IQ_SeriesWelder_TestScanResults;
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
            initial_parameter_refresh : WORD := WORD#2#0000000000011111;
            initial_model_refresh : WORD := WORD#2#0000000000111111;
        END_VAR


        METHOD PRIVATE ENCO : INT
            VAR_INPUT
                Input : WORD;
            END_VAR
            VAR 
                tmpWord : WORD;
                pos : INT := 0;
            END_VAR
            IF Input = WORD#0 THEN
                ENCO := 0;
                RETURN;
            END_IF;
            
            tmpWord := Input;
            WHILE (tmpWord AND WORD#1) = WORD#0 DO
                pos := pos + 1;
                tmpWord := SHR(tmpWord,UINT#1);
            END_WHILE;
            
            ENCO := pos;  
        END_METHOD

        METHOD PRIVATE DECO_WORD : WORD
            VAR_INPUT
                Input : UINT;
            END_VAR
            IF (Input >= UINT#0) AND (Input < UINT#16) THEN
                DECO_WORD := SHL(WORD#1, Input);
            ELSE
                DECO_WORD:= WORD#0;
            END_IF;
        END_METHOD

        METHOD PRIVATE AnalogSensorDiffers : BOOL
            VAR_INPUT
                Value1    :   REF_TO    Axo_IQ_SeriesWelder_AnalogSensor;
                Value2    :   REF_TO    Axo_IQ_SeriesWelder_AnalogSensor;
            END_VAR

            AnalogSensorDiffers :=  Value1^.Enable    <>  Value2^.Enable    ||
                                    Value1^.MIN_VOLT  <>  Value2^.MIN_VOLT  ||
                                    Value1^.MAX_VOLT  <>  Value2^.MAX_VOLT  ||
                                    Value1^.MIN_VAL   <>  Value2^.MIN_VAL   ||
                                    Value1^.MAX_VAL   <>  Value2^.MAX_VAL;
        END_METHOD

        METHOD PRIVATE ProcCtrlDiffers : BOOL
            VAR_INPUT
                Value1    :   REF_TO    Axo_IQ_SeriesWelder_ProcessControl;
                Value2    :   REF_TO    Axo_IQ_SeriesWelder_ProcessControl;
            END_VAR

            ProcCtrlDiffers :=  Value1^.RegulationAmplitude                               <>  Value2^.RegulationAmplitude                               ||
                                Value1^.RampUpTime                                        <>  Value2^.RampUpTime                                        ||
                                Value1^.RampDownTime                                      <>  Value2^.RampDownTime                                      ||
                                Value1^.OBSOLETE_ProcessControlEnable.HoldTime_Enable     <>  Value2^.OBSOLETE_ProcessControlEnable.HoldTime_Enable     ||
                                Value1^.OBSOLETE_ProcessControlEnable.Afterburst_Enable   <>  Value2^.OBSOLETE_ProcessControlEnable.Afterburst_Enable   ||
                                Value1^.OBSOLETE_ProcessControlEnable.WeldTime_Enable     <>  Value2^.OBSOLETE_ProcessControlEnable.WeldTime_Enable     ||
                                Value1^.OBSOLETE_ProcessControlEnable.WeldPower_Enable    <>  Value2^.OBSOLETE_ProcessControlEnable.WeldPower_Enable    ||
                                Value1^.OBSOLETE_ProcessControlEnable.WeldEnergy_Enable   <>  Value2^.OBSOLETE_ProcessControlEnable.WeldEnergy_Enable   ||
                                Value1^.OBSOLETE_ProcessControlEnable.WeldDistance_Enable <>  Value2^.OBSOLETE_ProcessControlEnable.WeldDistance_Enable ||
                                Value1^.OBSOLETE_ProcessControlEnable.WeldPosition_Enable <>  Value2^.OBSOLETE_ProcessControlEnable.WeldPosition_Enable ||
                                Value1^.WeldTime                                          <>  Value2^.WeldTime                                          ||
                                Value1^.WeldPower                                         <>  Value2^.WeldPower                                         ||
                                Value1^.WeldEnergy                                        <>  Value2^.WeldEnergy                                        ||
                                Value1^.HoldTime                                          <>  Value2^.HoldTime                                          ||
                                Value1^.AfterBurstDelay                                   <>  Value2^.AfterBurstDelay                                   ||
                                Value1^.AfterBurstDuration                                <>  Value2^.AfterBurstDuration                                ;

        END_METHOD        

        METHOD PRIVATE ProcLimitsDiffers : BOOL
            VAR_INPUT
                Value1    :   REF_TO    Axo_IQ_SeriesWelder_ProcessLimits;
                Value2    :   REF_TO    Axo_IQ_SeriesWelder_ProcessLimits;
            END_VAR

            ProcLimitsDiffers   :=  Value1^.Enable.LowerBadEnergy       <>  Value1^.Enable.LowerBadEnergy       ||
                                    Value1^.Enable.LowerSuspectEnergy   <>  Value1^.Enable.LowerSuspectEnergy   ||
                                    Value1^.Enable.UpperSuspectEnergy   <>  Value1^.Enable.UpperSuspectEnergy   ||
                                    Value1^.Enable.UpperBadEnergy       <>  Value1^.Enable.UpperBadEnergy       ||
                                    Value1^.Enable.DisplayEnergy        <>  Value1^.Enable.DisplayEnergy        ||
                                    Value1^.Enable.LowerBadPower        <>  Value1^.Enable.LowerBadPower        ||
                                    Value1^.Enable.LowerSuspectPower    <>  Value1^.Enable.LowerSuspectPower    ||
                                    Value1^.Enable.UpperSuspectPower    <>  Value1^.Enable.UpperSuspectPower    ||
                                    Value1^.Enable.UpperBadPower        <>  Value1^.Enable.UpperBadPower        ||
                                    Value1^.Enable.DisplayPower         <>  Value1^.Enable.DisplayPower         ||
                                    Value1^.Enable.LowerBadTime         <>  Value1^.Enable.LowerBadTime         ||
                                    Value1^.Enable.LowerSuspectTime     <>  Value1^.Enable.LowerSuspectTime     ||
                                    Value1^.Enable.UpperSuspectTime     <>  Value1^.Enable.UpperSuspectTime     ||
                                    Value1^.Enable.UpperBadTIme         <>  Value1^.Enable.UpperBadTIme         ||
                                    Value1^.Enable.DisplayTime          <>  Value1^.Enable.DisplayTime          ||
                                    Value1^.WeldTimeLowerBad            <>  Value1^.WeldTimeLowerBad            ||
                                    Value1^.WeldTimeLowerSuspect        <>  Value1^.WeldTimeLowerSuspect        ||
                                    Value1^.WeldTimeUpperSuspect        <>  Value1^.WeldTimeUpperSuspect        ||
                                    Value1^.WeldTimeUpperBad            <>  Value1^.WeldTimeUpperBad            ||
                                    Value1^.WeldPowerLowerBad           <>  Value1^.WeldPowerLowerBad           ||
                                    Value1^.WeldPwrLowerSuspect         <>  Value1^.WeldPwrLowerSuspect         ||
                                    Value1^.WeldPwrUpperSuspect         <>  Value1^.WeldPwrUpperSuspect         ||
                                    Value1^.WeldPowerUpperBad           <>  Value1^.WeldPowerUpperBad           ||
                                    Value1^.WeldEnergyLowerBad          <>  Value1^.WeldEnergyLowerBad          ||
                                    Value1^.WeldEnergyLowerSuspect      <>  Value1^.WeldEnergyLowerSuspect      ||
                                    Value1^.WeldEnergyUpperSuspect      <>  Value1^.WeldEnergyUpperSuspect      ||
                                    Value1^.WeldEnergyUpperBad          <>  Value1^.WeldEnergyUpperBad          ;
        END_METHOD

        METHOD PRIVATE FreqCtrlDiffers : BOOL
            VAR_INPUT
                Value1    :   REF_TO    Axo_IQ_SeriesWelder_FreqCtrl;
                Value2    :   REF_TO    Axo_IQ_SeriesWelder_FreqCtrl;
            END_VAR

            FreqCtrlDiffers     :=      Value1^.FreerunFrequency        <>  Value2^.FreerunFrequency        ||
                                        Value1^.LowerFrequencyBound     <>  Value2^.LowerFrequencyBound     ||
                                        Value1^.UpperFrequencyBound     <>  Value2^.UpperFrequencyBound     ||
                                        Value1^.LockandHoldModeEnable   <>  Value2^.LockandHoldModeEnable   ||
                                        Value1^.USPhaseAdjustment       <>  Value2^.USPhaseAdjustment       ;
        END_METHOD
        
        METHOD PRIVATE TriggerByPowerDiffers : BOOL
            VAR_INPUT
                Value1    :   REF_TO    Axo_IQ_SeriesWelder_TriggerByPower;
                Value2    :   REF_TO    Axo_IQ_SeriesWelder_TriggerByPower;
            END_VAR

            TriggerByPowerDiffers :=    Value1^.Enable                  <>  Value2^.Enable                  ||
                                        Value1^.Trigger_Timout          <>  Value2^.Trigger_Timout          ||
                                        Value1^.Trigger_Level           <>  Value2^.Trigger_Level           ||
                                        Value1^.PreTrigger_Amplitude    <>  Value2^.PreTrigger_Amplitude    ;
        END_METHOD        

        METHOD PRIVATE PowerRegDiffers : BOOL
            VAR_INPUT
                Value1    :   REF_TO    Axo_IQ_SeriesWelder_PowerRegulation;
                Value2    :   REF_TO    Axo_IQ_SeriesWelder_PowerRegulation;
            END_VAR
            PowerRegDiffers :=      Value1^.PowerRegulationEnable   <>  Value2^.PowerRegulationEnable   ||
                                    Value1^.PowerRegulationSetpoINT <>  Value2^.PowerRegulationSetpoINT ;
        END_METHOD        

        METHOD PRIVATE PressPretriggerDiffers : BOOL
            VAR_INPUT
                Value1    :   REF_TO    Axo_IQ_SeriesWelder_PressPreTrigger;
                Value2    :   REF_TO    Axo_IQ_SeriesWelder_PressPreTrigger;
            END_VAR

            PressPretriggerDiffers :=   Value1^.PreTriggerSource.AutoIn             <>  Value2^.PreTriggerSource.AutoIn             ||
                                        Value1^.PreTriggerSource.Position_Switch    <>  Value2^.PreTriggerSource.Position_Switch    ||
                                        Value1^.PreTriggerSource._Time              <>  Value2^.PreTriggerSource._Time              ||
                                        Value1^.PreTriggerSource.Position           <>  Value2^.PreTriggerSource.Position           ||
                                        Value1^.PreTriggerSource.Enable_Trigger     <>  Value2^.PreTriggerSource.Enable_Trigger     ||
                                        Value1^.Ignore1                             <>  Value2^.Ignore1                             ||
                                        Value1^.Ignore2                             <>  Value2^.Ignore2                             ||
                                        Value1^.PreTriggerTime                      <>  Value2^.PreTriggerTime                      ||
                                        Value1^.PreTriggerPosition                  <>  Value2^.PreTriggerPosition                  ;
        END_METHOD        

        METHOD PRIVATE TriggerSourceDiffers : BOOL
            VAR_INPUT
                Value1    :   REF_TO    Axo_IQ_SeriesWelder_TriggerSource;
                Value2    :   REF_TO    Axo_IQ_SeriesWelder_TriggerSource;
            END_VAR

            TriggerSourceDiffers :=     Value1^.Enable_Trigger  <>  Value2^.Enable_Trigger  ||
                                        Value1^.AutoIn          <>  Value2^.AutoIn          ||
                                        Value1^.Position_Switch <>  Value2^.Position_Switch ||
                                        Value1^.Position        <>  Value2^.Position        ||
                                        Value1^.Power           <>  Value2^.Power           ;
        END_METHOD        

        METHOD PRIVATE PressTriggerDiffers : BOOL
            VAR_INPUT
                Value1    :   REF_TO    Axo_IQ_SeriesWelder_PressTrigger;
                Value2    :   REF_TO    Axo_IQ_SeriesWelder_PressTrigger;
            END_VAR

            PressTriggerDiffers :=  THIS.TriggerSourceDiffers(REF(  Value1^.TriggerSource)      ,   REF(Value2^.TriggerSource)) ||
                                                                    Value1^.TriggerByPositionLevel  <>  Value2^.TriggerByPositionLevel;
        END_METHOD        

        METHOD PRIVATE PressTriggerDelayDiffers : BOOL
            VAR_INPUT
                Value1    :   REF_TO    Axo_IQ_SeriesWelder_PressTriggerDelay;
                Value2    :   REF_TO    Axo_IQ_SeriesWelder_PressTriggerDelay;
            END_VAR

            PressTriggerDelayDiffers := Value1^.TriggerDelaySource      <>  Value2^.TriggerDelaySource      ||
                                        Value1^.TriggerDelayTimeout     <>  Value2^.TriggerDelayTimeout     ||
                                        Value1^.TriggerDelayTime        <>  Value2^.TriggerDelayTime        ||
                                        Value1^.TriggerDelayDistance    <>  Value2^.TriggerDelayDistance    ;
        END_METHOD        

        METHOD PRIVATE WeldSourceDiffers : BOOL
            VAR_INPUT
                Value1    :   REF_TO    Axo_IQ_SeriesWelder_WeldSource;
                Value2    :   REF_TO    Axo_IQ_SeriesWelder_WeldSource;
            END_VAR
            WeldSourceDiffers :=    Value1^.Enable_Weld_1   <>  Value2^.Enable_Weld_1   ||
                                    Value1^._Time           <>  Value2^._Time           ||
                                    Value1^.Power           <>  Value2^.Power           ||
                                    Value1^.Energy          <>  Value2^.Energy          ||
                                    Value1^.Distance        <>  Value2^.Distance        ||
                                    Value1^.Position        <>  Value2^.Position        ||
                                    Value1^.Ground_Detect   <>  Value2^.Ground_Detect   ||
                                    Value1^.Force           <>  Value2^.Force           ;
        END_METHOD        

        METHOD PRIVATE PressWeldDiffers : BOOL
            VAR_INPUT
                Value1    :   REF_TO    Axo_IQ_SeriesWelder_PressWeld;
                Value2    :   REF_TO    Axo_IQ_SeriesWelder_PressWeld;
            END_VAR

            PressWeldDiffers := THIS.WeldSourceDiffers(REF( Value1^.Weld1Source)          , REF(Value2^.Weld1Source))           ||
                                                            Value1^.Weld1Timeout            <>  Value2^.Weld1Timeout            ||
                                                            Value1^.Weld1Distance           <>  Value2^.Weld1Distance           ||
                                                            Value1^.Weld1Position           <>  Value2^.Weld1Position           ||
                                THIS.WeldSourceDiffers(REF( Value1^.Weld2Source)          , REF(Value2^.Weld2Source))           ||
                                                            Value1^.Weld2SecondarySource    <>  Value2^.Weld2SecondarySource    ||
                                                            Value1^.Weld2Timeout            <>  Value2^.Weld2Timeout            ||
                                                            Value1^.Weld2Time               <>  Value2^.Weld2Time               ||
                                                            Value1^.Weld2Energy             <>  Value2^.Weld2Energy             ||
                                                            Value1^.Weld2Power              <>  Value2^.Weld2Power              ||
                                                            Value1^.Weld2Distance           <>  Value2^.Weld2Distance           ||
                                                            Value1^.Weld2Position           <>  Value2^.Weld2Position           ;
                                                
                                        
                                        
        END_METHOD        

        METHOD PRIVATE PressWeldScrubDiffers : BOOL
            VAR_INPUT
                Value1    :   REF_TO    Axo_IQ_SeriesWelder_PressWeldScrub;
                Value2    :   REF_TO    Axo_IQ_SeriesWelder_PressWeldScrub;
            END_VAR

            PressWeldScrubDiffers :=    Value1^.ScrubMode   <>  Value2^.ScrubMode  ||
                                        Value1^.ScrubTime   <>  Value2^.ScrubTime  ;
        END_METHOD        

        METHOD PRIVATE PressPostWeldDiffers : BOOL
            VAR_INPUT
                Value1    :   REF_TO    Axo_IQ_SeriesWelder_PressPostWeld;
                Value2    :   REF_TO    Axo_IQ_SeriesWelder_PressPostWeld;
            END_VAR

            PressPostWeldDiffers := Value1^.DynamicHoldMode._Time       <>  Value2^.DynamicHoldMode._Time       ||
                                    Value1^.DynamicHoldMode.Distance    <>  Value2^.DynamicHoldMode.Distance    ||
                                    Value1^.DynamicHoldMode.Force       <>  Value2^.DynamicHoldMode.Force       ||
                                    Value1^.DynamicHoldMode.AutoIn      <>  Value2^.DynamicHoldMode.AutoIn      ||
                                    Value1^.DynamicHoldMode.Velocity    <>  Value2^.DynamicHoldMode.Velocity    ||
                                    Value1^.DynamicHoldTimeout          <>  Value2^.DynamicHoldTimeout          ||
                                    Value1^.DynamicHoldDistance         <>  Value2^.DynamicHoldDistance         ||
                                    Value1^.DynamicHoldForce            <>  Value2^.DynamicHoldForce            ||
                                    Value1^.StaticHoldMode              <>  Value2^.StaticHoldMode              ||
                                    Value1^.StaticHoldTime              <>  Value2^.StaticHoldTime              ||
                                    Value1^.AfterburstAmplitude         <>  Value2^.AfterburstAmplitude         ;
        END_METHOD        

        METHOD PRIVATE PressLimitEnableDiffers : BOOL
            VAR_INPUT
                Value1    :   REF_TO    Axo_IQ_SeriesWelder_PressLimitEnable;
                Value2    :   REF_TO    Axo_IQ_SeriesWelder_PressLimitEnable;
            END_VAR
            PressLimitEnableDiffers :=  Value1^.LowerBad_1      <>  Value1^.LowerBad_1      || 
                                        Value1^.LowerSuspect_1  <>  Value1^.LowerSuspect_1  || 
                                        Value1^.UpperSuspect_1  <>  Value1^.UpperSuspect_1  || 
                                        Value1^.UpperBad_1      <>  Value1^.UpperBad_1      || 
                                        Value1^.Display_1       <>  Value1^.Display_1       ; 
        
        END_METHOD        
        
        METHOD PRIVATE PressLimitDiffers : BOOL
            VAR_INPUT
                Value1    :   REF_TO    Axo_IQ_SeriesWelder_PressLimit;
                Value2    :   REF_TO    Axo_IQ_SeriesWelder_PressLimit;
            END_VAR
            PressLimitDiffers := THIS.PressLimitEnableDiffers(REF(  Value1^.Enable)       , REF(Value2^.Enable))        ||
                                                                    Value1^.LowerBad        <>  Value2^.LowerBad        ||
                                                                    Value1^.LowerSuspect    <>  Value2^.LowerSuspect    ||
                                                                    Value1^.UpperSuspect    <>  Value2^.UpperSuspect    ||
                                                                    Value1^.UpperBad        <>  Value2^.UpperBad        ;
        END_METHOD        
        
        // METHOD PRIVATE TriggerPositionDiffers : BOOL
        //     VAR_INPUT
        //         Value1    :   REF_TO    Axo_IQ_SeriesWelder_PressPostWeld;
        //         Value2    :   REF_TO    Axo_IQ_SeriesWelder_PressPostWeld;
        //     END_VAR

        //     TriggerPositionDiffers := FALSE;
        // END_METHOD        
        
        // METHOD PRIVATE TriggerDelayTimeDiffers : BOOL
        //     VAR_INPUT
        //         Value1    :   REF_TO    Axo_IQ_SeriesWelder_PressPostWeld;
        //         Value2    :   REF_TO    Axo_IQ_SeriesWelder_PressPostWeld;
        //     END_VAR

        //     TriggerDelayTimeDiffers := FALSE;
        // END_METHOD        
        
        // METHOD PRIVATE TriggerDelayDistanceDiffers : BOOL
        //     VAR_INPUT
        //         Value1    :   REF_TO    Axo_IQ_SeriesWelder_PressPostWeld;
        //         Value2    :   REF_TO    Axo_IQ_SeriesWelder_PressPostWeld;
        //     END_VAR

        //     TriggerDelayDistanceDiffers := FALSE;
        // END_METHOD        
        
        // METHOD PRIVATE Weld1DistanceDiffers : BOOL
        //     VAR_INPUT
        //         Value1    :   REF_TO    Axo_IQ_SeriesWelder_PressPostWeld;
        //         Value2    :   REF_TO    Axo_IQ_SeriesWelder_PressPostWeld;
        //     END_VAR

        //     Weld1DistanceDiffers := FALSE;
        // END_METHOD        
        
        // METHOD PRIVATE Weld1PositionDiffers : BOOL
        //     VAR_INPUT
        //         Value1    :   REF_TO    Axo_IQ_SeriesWelder_PressPostWeld;
        //         Value2    :   REF_TO    Axo_IQ_SeriesWelder_PressPostWeld;
        //     END_VAR

        //     Weld1PositionDiffers := FALSE;
        // END_METHOD        
        
        // METHOD PRIVATE Weld2TimeDiffers : BOOL
        //     VAR_INPUT
        //         Value1    :   REF_TO    Axo_IQ_SeriesWelder_PressPostWeld;
        //         Value2    :   REF_TO    Axo_IQ_SeriesWelder_PressPostWeld;
        //     END_VAR

        //     Weld2TimeDiffers := FALSE;
        // END_METHOD        
        
        // METHOD PRIVATE Weld2EnergyDiffers : BOOL
        //     VAR_INPUT
        //         Value1    :   REF_TO    Axo_IQ_SeriesWelder_PressPostWeld;
        //         Value2    :   REF_TO    Axo_IQ_SeriesWelder_PressPostWeld;
        //     END_VAR

        //     Weld2EnergyDiffers := FALSE;
        // END_METHOD        
        
        // METHOD PRIVATE Weld2PowerDiffers : BOOL
        //     VAR_INPUT
        //         Value1    :   REF_TO    Axo_IQ_SeriesWelder_PressPostWeld;
        //         Value2    :   REF_TO    Axo_IQ_SeriesWelder_PressPostWeld;
        //     END_VAR

        //     Weld2PowerDiffers := FALSE;
        // END_METHOD        
        
        METHOD PRIVATE AnalogSensorSpecDiffers : BOOL
            VAR_INPUT
                Value1    :   REF_TO    Axo_IQ_SeriesWelder_AnalogSensorSpec;
                Value2    :   REF_TO    Axo_IQ_SeriesWelder_AnalogSensorSpec;
            END_VAR
            AnalogSensorSpecDiffers :=  THIS.AnalogSensorDiffers(REF(Value1^.Sensor[1]) ,    REF(Value2^.Sensor[1])) ||
                                        THIS.AnalogSensorDiffers(REF(Value1^.Sensor[2]) ,    REF(Value2^.Sensor[2])) ||
                                        THIS.AnalogSensorDiffers(REF(Value1^.Sensor[3]) ,    REF(Value2^.Sensor[3])) ||
                                        THIS.AnalogSensorDiffers(REF(Value1^.Sensor[4]) ,    REF(Value2^.Sensor[4])) ||
                                        THIS.AnalogSensorDiffers(REF(Value1^.Sensor[5]) ,    REF(Value2^.Sensor[5])) ||
                                        THIS.AnalogSensorDiffers(REF(Value1^.Sensor[6]) ,    REF(Value2^.Sensor[6])) ||
                                        THIS.AnalogSensorDiffers(REF(Value1^.Sensor[7]) ,    REF(Value2^.Sensor[7])) ||
                                        THIS.AnalogSensorDiffers(REF(Value1^.Sensor[8]) ,    REF(Value2^.Sensor[8])) ;
        END_METHOD        
        
        METHOD PRIVATE ByteArray_TO_buf1 
            VAR_INPUT
                array_buffer : ARRAY[0..253] OF BYTE;
            END_VAR
            VAR_IN_OUT
                buf1 : Axo_IQ_SeriesWelder_data1_132bytes;
            END_VAR
            buf1.ProcCtrl.RegulationAmplitude :=           TO_DINT(SHL(TO_DWORD(array_buffer[  0]), UINT#24) OR
                                                                   SHL(TO_DWORD(array_buffer[  1]), UINT#16) OR
                                                                   SHL(TO_DWORD(array_buffer[  2]),  UINT#8) OR
                                                                       TO_DWORD(array_buffer[  3]));                                             
            buf1.ProcCtrl.RampUpTime  :=                   TO_DINT(SHL(TO_DWORD(array_buffer[  4]), UINT#24) OR
                                                                   SHL(TO_DWORD(array_buffer[  5]), UINT#16) OR
                                                                   SHL(TO_DWORD(array_buffer[  6]),  UINT#8) OR
                                                                       TO_DWORD(array_buffer[  7])); 
            buf1.ProcCtrl.RampDownTime  :=                 TO_DINT(SHL(TO_DWORD(array_buffer[  8]), UINT#24) OR
                                                                   SHL(TO_DWORD(array_buffer[  9]), UINT#16) OR
                                                                   SHL(TO_DWORD(array_buffer[ 10]),  UINT#8) OR
                                                                       TO_DWORD(array_buffer[ 11])); 
            buf1.ProcCtrl.OBSOLETE_ProcessControlEnable._0:=                    array_buffer[ 12].%X0;
            buf1.ProcCtrl.OBSOLETE_ProcessControlEnable._1:=                    array_buffer[ 12].%X1;
            buf1.ProcCtrl.OBSOLETE_ProcessControlEnable._2:=                    array_buffer[ 12].%X2;
            buf1.ProcCtrl.OBSOLETE_ProcessControlEnable._3:=                    array_buffer[ 12].%X3;
            buf1.ProcCtrl.OBSOLETE_ProcessControlEnable._4:=                    array_buffer[ 12].%X4;
            buf1.ProcCtrl.OBSOLETE_ProcessControlEnable._5:=                    array_buffer[ 12].%X5;
            buf1.ProcCtrl.OBSOLETE_ProcessControlEnable._6:=                    array_buffer[ 12].%X6;
            buf1.ProcCtrl.OBSOLETE_ProcessControlEnable._7:=                    array_buffer[ 12].%X7;
            buf1.ProcCtrl.OBSOLETE_ProcessControlEnable.HoldTime_Enable:=       array_buffer[ 13].%X0;
            buf1.ProcCtrl.OBSOLETE_ProcessControlEnable.Afterburst_Enable:=     array_buffer[ 13].%X1;
            buf1.ProcCtrl.OBSOLETE_ProcessControlEnable._10 :=                  array_buffer[ 13].%X2;
            buf1.ProcCtrl.OBSOLETE_ProcessControlEnable._11 :=                  array_buffer[ 13].%X3;
            buf1.ProcCtrl.OBSOLETE_ProcessControlEnable._12 :=                  array_buffer[ 13].%X4;
            buf1.ProcCtrl.OBSOLETE_ProcessControlEnable._13 :=                  array_buffer[ 13].%X5;
            buf1.ProcCtrl.OBSOLETE_ProcessControlEnable._14 :=                  array_buffer[ 13].%X6;
            buf1.ProcCtrl.OBSOLETE_ProcessControlEnable._15 :=                  array_buffer[ 13].%X7;
            buf1.ProcCtrl.OBSOLETE_ProcessControlEnable._16 :=                  array_buffer[ 14].%X0;
            buf1.ProcCtrl.OBSOLETE_ProcessControlEnable._17 :=                  array_buffer[ 14].%X1;
            buf1.ProcCtrl.OBSOLETE_ProcessControlEnable._18 :=                  array_buffer[ 14].%X2;
            buf1.ProcCtrl.OBSOLETE_ProcessControlEnable._19 :=                  array_buffer[ 14].%X3;
            buf1.ProcCtrl.OBSOLETE_ProcessControlEnable._20 :=                  array_buffer[ 14].%X4;
            buf1.ProcCtrl.OBSOLETE_ProcessControlEnable._21 :=                  array_buffer[ 14].%X5;
            buf1.ProcCtrl.OBSOLETE_ProcessControlEnable._22 :=                  array_buffer[ 14].%X6;
            buf1.ProcCtrl.OBSOLETE_ProcessControlEnable._23 :=                  array_buffer[ 14].%X7;
            buf1.ProcCtrl.OBSOLETE_ProcessControlEnable.WeldTime_Enable:=       array_buffer[ 15].%X0;
            buf1.ProcCtrl.OBSOLETE_ProcessControlEnable.WeldPower_Enable:=      array_buffer[ 15].%X1;
            buf1.ProcCtrl.OBSOLETE_ProcessControlEnable.WeldEnergy_Enable:=     array_buffer[ 15].%X2;
            buf1.ProcCtrl.OBSOLETE_ProcessControlEnable.WeldDistance_Enable:=   array_buffer[ 15].%X3;
            buf1.ProcCtrl.OBSOLETE_ProcessControlEnable.WeldPosition_Enable:=   array_buffer[ 15].%X4;
            buf1.ProcCtrl.OBSOLETE_ProcessControlEnable._29 :=                  array_buffer[ 15].%X5;
            buf1.ProcCtrl.OBSOLETE_ProcessControlEnable._30 :=                  array_buffer[ 15].%X6;
            buf1.ProcCtrl.OBSOLETE_ProcessControlEnable._31 :=                  array_buffer[ 15].%X7;  
            buf1.ProcCtrl.WeldTime  :=                     TO_DINT(SHL(TO_DWORD(array_buffer[ 16]), UINT#24) OR
                                                                   SHL(TO_DWORD(array_buffer[ 17]), UINT#16) OR
                                                                   SHL(TO_DWORD(array_buffer[ 18]),  UINT#8) OR
                                                                       TO_DWORD(array_buffer[ 19])); 
            buf1.ProcCtrl.WeldPower :=                     TO_DINT(SHL(TO_DWORD(array_buffer[ 20]), UINT#24) OR
                                                                   SHL(TO_DWORD(array_buffer[ 21]), UINT#16) OR
                                                                   SHL(TO_DWORD(array_buffer[ 22]),  UINT#8) OR
                                                                       TO_DWORD(array_buffer[ 23])); 
            buf1.ProcCtrl.WeldEnergy :=                    TO_DINT(SHL(TO_DWORD(array_buffer[ 24]), UINT#24) OR
                                                                   SHL(TO_DWORD(array_buffer[ 25]), UINT#16) OR
                                                                   SHL(TO_DWORD(array_buffer[ 26]),  UINT#8) OR
                                                                       TO_DWORD(array_buffer[ 27])); 
            buf1.ProcCtrl.HoldTime :=                      TO_DINT(SHL(TO_DWORD(array_buffer[ 28]), UINT#24) OR
                                                                   SHL(TO_DWORD(array_buffer[ 29]), UINT#16) OR
                                                                   SHL(TO_DWORD(array_buffer[ 30]),  UINT#8) OR
                                                                       TO_DWORD(array_buffer[ 31])); 
            buf1.ProcCtrl.AfterBurstDelay :=               TO_DINT(SHL(TO_DWORD(array_buffer[ 32]), UINT#24) OR
                                                                   SHL(TO_DWORD(array_buffer[ 33]), UINT#16) OR
                                                                   SHL(TO_DWORD(array_buffer[ 34]),  UINT#8) OR
                                                                       TO_DWORD(array_buffer[ 35])); 
            buf1.ProcCtrl.AfterBurstDuration :=            TO_DINT(SHL(TO_DWORD(array_buffer[ 36]), UINT#24) OR
                                                                   SHL(TO_DWORD(array_buffer[ 37]), UINT#16) OR
                                                                   SHL(TO_DWORD(array_buffer[ 38]),  UINT#8) OR
                                                                       TO_DWORD(array_buffer[ 39])); 
            buf1.ProcLimits.Enable.LowerBadEnergy                   :=          array_buffer[ 40].%X0;
            buf1.ProcLimits.Enable.LowerSuspectEnergy               :=          array_buffer[ 40].%X1;
            buf1.ProcLimits.Enable.UpperSuspectEnergy               :=          array_buffer[ 40].%X2;
            buf1.ProcLimits.Enable.UpperBadEnergy                   :=          array_buffer[ 40].%X3;
            buf1.ProcLimits.Enable.DisplayEnergy                    :=          array_buffer[ 40].%X4;
            buf1.ProcLimits.Enable._5                               :=          array_buffer[ 40].%X5;
            buf1.ProcLimits.Enable._6                               :=          array_buffer[ 40].%X6;
            buf1.ProcLimits.Enable._7                               :=          array_buffer[ 40].%X7;
            buf1.ProcLimits.Enable.LowerBadPower                    :=          array_buffer[ 41].%X0;
            buf1.ProcLimits.Enable.LowerSuspectPower                :=          array_buffer[ 41].%X1;
            buf1.ProcLimits.Enable.UpperSuspectPower                :=          array_buffer[ 41].%X2;
            buf1.ProcLimits.Enable.UpperBadPower                    :=          array_buffer[ 41].%X3;
            buf1.ProcLimits.Enable.DisplayPower                     :=          array_buffer[ 41].%X4;
            buf1.ProcLimits.Enable._13                              :=          array_buffer[ 41].%X5;
            buf1.ProcLimits.Enable._14                              :=          array_buffer[ 41].%X6;
            buf1.ProcLimits.Enable._15                              :=          array_buffer[ 41].%X7;
            buf1.ProcLimits.Enable.LowerBadTime                     :=          array_buffer[ 42].%X0;
            buf1.ProcLimits.Enable.LowerSuspectTime                 :=          array_buffer[ 42].%X1;
            buf1.ProcLimits.Enable.UpperSuspectTime                 :=          array_buffer[ 42].%X2;
            buf1.ProcLimits.Enable.UpperBadTIme                     :=          array_buffer[ 42].%X3;
            buf1.ProcLimits.Enable.DisplayTime                      :=          array_buffer[ 42].%X4;
            buf1.ProcLimits.Enable._21                              :=          array_buffer[ 42].%X5;
            buf1.ProcLimits.Enable._22                              :=          array_buffer[ 42].%X6;
            buf1.ProcLimits.Enable._23                              :=          array_buffer[ 42].%X7;
            buf1.ProcLimits.Enable._24                              :=          array_buffer[ 43].%X0;
            buf1.ProcLimits.Enable._25                              :=          array_buffer[ 43].%X1;
            buf1.ProcLimits.Enable._26                              :=          array_buffer[ 43].%X2;
            buf1.ProcLimits.Enable._27                              :=          array_buffer[ 43].%X3;
            buf1.ProcLimits.Enable._28                              :=          array_buffer[ 43].%X4;
            buf1.ProcLimits.Enable._29                              :=          array_buffer[ 43].%X5;
            buf1.ProcLimits.Enable._30                              :=          array_buffer[ 43].%X6;
            buf1.ProcLimits.Enable._31                              :=          array_buffer[ 43].%X7;
            buf1.ProcLimits.WeldTimeLowerBad    :=         TO_DINT(SHL(TO_DWORD(array_buffer[ 44]), UINT#24) OR
                                                                   SHL(TO_DWORD(array_buffer[ 45]), UINT#16) OR
                                                                   SHL(TO_DWORD(array_buffer[ 46]),  UINT#8) OR
                                                                       TO_DWORD(array_buffer[ 47])); 
            buf1.ProcLimits.WeldTimeLowerSuspect:=         TO_DINT(SHL(TO_DWORD(array_buffer[ 48]), UINT#24) OR
                                                                   SHL(TO_DWORD(array_buffer[ 49]), UINT#16) OR
                                                                   SHL(TO_DWORD(array_buffer[ 50]),  UINT#8) OR
                                                                       TO_DWORD(array_buffer[ 51])); 
            buf1.ProcLimits.WeldTimeUpperSuspect:=         TO_DINT(SHL(TO_DWORD(array_buffer[ 52]), UINT#24) OR
                                                                   SHL(TO_DWORD(array_buffer[ 53]), UINT#16) OR
                                                                   SHL(TO_DWORD(array_buffer[ 54]),  UINT#8) OR
                                                                       TO_DWORD(array_buffer[ 55])); 
            buf1.ProcLimits.WeldTimeUpperBad:=             TO_DINT(SHL(TO_DWORD(array_buffer[ 56]), UINT#24) OR
                                                                   SHL(TO_DWORD(array_buffer[ 57]), UINT#16) OR
                                                                   SHL(TO_DWORD(array_buffer[ 58]),  UINT#8) OR
                                                                       TO_DWORD(array_buffer[ 59])); 
            buf1.ProcLimits.WeldPowerLowerBad:=            TO_DINT(SHL(TO_DWORD(array_buffer[ 60]), UINT#24) OR
                                                                   SHL(TO_DWORD(array_buffer[ 61]), UINT#16) OR
                                                                   SHL(TO_DWORD(array_buffer[ 62]),  UINT#8) OR
                                                                       TO_DWORD(array_buffer[ 63])); 
            buf1.ProcLimits.WeldPwrLowerSuspect:=          TO_DINT(SHL(TO_DWORD(array_buffer[ 64]), UINT#24) OR
                                                                   SHL(TO_DWORD(array_buffer[ 65]), UINT#16) OR
                                                                   SHL(TO_DWORD(array_buffer[ 66]),  UINT#8) OR
                                                                       TO_DWORD(array_buffer[ 67])); 
            buf1.ProcLimits.WeldPwrUpperSuspect:=          TO_DINT(SHL(TO_DWORD(array_buffer[ 68]), UINT#24) OR
                                                                   SHL(TO_DWORD(array_buffer[ 69]), UINT#16) OR
                                                                   SHL(TO_DWORD(array_buffer[ 70]),  UINT#8) OR
                                                                       TO_DWORD(array_buffer[ 71])); 
            buf1.ProcLimits.WeldPowerUpperBad:=            TO_DINT(SHL(TO_DWORD(array_buffer[ 72]), UINT#24) OR
                                                                   SHL(TO_DWORD(array_buffer[ 73]), UINT#16) OR
                                                                   SHL(TO_DWORD(array_buffer[ 74]),  UINT#8) OR
                                                                       TO_DWORD(array_buffer[ 75])); 
            buf1.ProcLimits.WeldEnergyLowerBad:=           TO_DINT(SHL(TO_DWORD(array_buffer[ 76]), UINT#24) OR
                                                                   SHL(TO_DWORD(array_buffer[ 77]), UINT#16) OR
                                                                   SHL(TO_DWORD(array_buffer[ 78]),  UINT#8) OR
                                                                       TO_DWORD(array_buffer[ 79])); 
            buf1.ProcLimits.WeldEnergyLowerSuspect:=       TO_DINT(SHL(TO_DWORD(array_buffer[ 80]), UINT#24) OR
                                                                   SHL(TO_DWORD(array_buffer[ 81]), UINT#16) OR
                                                                   SHL(TO_DWORD(array_buffer[ 82]),  UINT#8) OR
                                                                       TO_DWORD(array_buffer[ 83]));
            buf1.ProcLimits.WeldEnergyUpperSuspect:=       TO_DINT(SHL(TO_DWORD(array_buffer[ 84]), UINT#24) OR
                                                                   SHL(TO_DWORD(array_buffer[ 85]), UINT#16) OR
                                                                   SHL(TO_DWORD(array_buffer[ 86]),  UINT#8) OR
                                                                       TO_DWORD(array_buffer[ 87])); 
            buf1.ProcLimits.WeldEnergyUpperBad:=           TO_DINT(SHL(TO_DWORD(array_buffer[ 88]), UINT#24) OR
                                                                   SHL(TO_DWORD(array_buffer[ 89]), UINT#16) OR
                                                                   SHL(TO_DWORD(array_buffer[ 90]),  UINT#8) OR
                                                                       TO_DWORD(array_buffer[ 91])); 
            buf1.FreqCtrl.FreerunFrequency:=               TO_DINT(SHL(TO_DWORD(array_buffer[ 92]), UINT#24) OR
                                                                   SHL(TO_DWORD(array_buffer[ 93]), UINT#16) OR
                                                                   SHL(TO_DWORD(array_buffer[ 94]),  UINT#8) OR
                                                                       TO_DWORD(array_buffer[ 95])); 
            buf1.FreqCtrl.LowerFrequencyBound:=            TO_DINT(SHL(TO_DWORD(array_buffer[ 96]), UINT#24) OR
                                                                   SHL(TO_DWORD(array_buffer[ 97]), UINT#16) OR
                                                                   SHL(TO_DWORD(array_buffer[ 98]),  UINT#8) OR
                                                                       TO_DWORD(array_buffer[ 99])); 
            buf1.FreqCtrl.UpperFrequencyBound:=            TO_DINT(SHL(TO_DWORD(array_buffer[100]), UINT#24) OR
                                                                   SHL(TO_DWORD(array_buffer[101]), UINT#16) OR
                                                                   SHL(TO_DWORD(array_buffer[102]),  UINT#8) OR
                                                                       TO_DWORD(array_buffer[103]));
            buf1.FreqCtrl.LockandHoldModeEnable:=          TO_DINT(SHL(TO_DWORD(array_buffer[104]), UINT#24) OR
                                                                   SHL(TO_DWORD(array_buffer[105]), UINT#16) OR
                                                                   SHL(TO_DWORD(array_buffer[106]),  UINT#8) OR
                                                                       TO_DWORD(array_buffer[107])); 
            buf1.FreqCtrl.USPhaseAdjustment:=              TO_DINT(SHL(TO_DWORD(array_buffer[108]), UINT#24) OR
                                                                   SHL(TO_DWORD(array_buffer[109]), UINT#16) OR
                                                                   SHL(TO_DWORD(array_buffer[110]),  UINT#8) OR
                                                                       TO_DWORD(array_buffer[111])); 
            buf1.TriggerByPower.Enable:=                   TO_DINT(SHL(TO_DWORD(array_buffer[112]), UINT#24) OR
                                                                   SHL(TO_DWORD(array_buffer[113]), UINT#16) OR
                                                                   SHL(TO_DWORD(array_buffer[114]),  UINT#8) OR
                                                                       TO_DWORD(array_buffer[115])); 
            buf1.TriggerByPower.Trigger_Timout:=           TO_DINT(SHL(TO_DWORD(array_buffer[116]), UINT#24) OR
                                                                   SHL(TO_DWORD(array_buffer[117]), UINT#16) OR
                                                                   SHL(TO_DWORD(array_buffer[118]),  UINT#8) OR
                                                                       TO_DWORD(array_buffer[119]));
            buf1.TriggerByPower.Trigger_Level:=            TO_DINT(SHL(TO_DWORD(array_buffer[120]), UINT#24) OR
                                                                   SHL(TO_DWORD(array_buffer[121]), UINT#16) OR
                                                                   SHL(TO_DWORD(array_buffer[122]),  UINT#8) OR
                                                                       TO_DWORD(array_buffer[123]));
            buf1.TriggerByPower.PreTrigger_Amplitude:=     TO_DINT(SHL(TO_DWORD(array_buffer[124]), UINT#24) OR
                                                                   SHL(TO_DWORD(array_buffer[125]), UINT#16) OR
                                                                   SHL(TO_DWORD(array_buffer[126]),  UINT#8) OR
                                                                       TO_DWORD(array_buffer[127])); 
            buf1.FreqCtrlMode:=                            TO_DINT(SHL(TO_DWORD(array_buffer[128]), UINT#24) OR
                                                                   SHL(TO_DWORD(array_buffer[129]), UINT#16) OR
                                                                   SHL(TO_DWORD(array_buffer[130]),  UINT#8) OR
                                                                       TO_DWORD(array_buffer[131])); 
        END_METHOD

        METHOD PRIVATE ByteArray_TO_buf2 
            VAR_INPUT
                array_buffer : ARRAY[0..253] OF BYTE;
            END_VAR
            VAR_IN_OUT
                buf2 : Axo_IQ_SeriesWelder_data2_136bytes;
            END_VAR
			buf2.PowerReg.PowerRegulationEnable:=           TO_DINT(SHL(TO_DWORD(array_buffer[  0]), UINT#24) OR
																	SHL(TO_DWORD(array_buffer[  1]), UINT#16) OR
																	SHL(TO_DWORD(array_buffer[  2]),  UINT#8) OR
																		TO_DWORD(array_buffer[  3])); 
			buf2.PowerReg.PowerRegulationSetpoINT:=         TO_DINT(SHL(TO_DWORD(array_buffer[  4]), UINT#24) OR
																	SHL(TO_DWORD(array_buffer[  5]), UINT#16) OR
																	SHL(TO_DWORD(array_buffer[  6]),  UINT#8) OR
																		TO_DWORD(array_buffer[  7])); 
			buf2.PressPretrigger.PreTriggerSource.bit24                     :=   array_buffer[  8].%X0;
			buf2.PressPretrigger.PreTriggerSource.bit25                     :=   array_buffer[  8].%X1;
			buf2.PressPretrigger.PreTriggerSource.bit26                     :=   array_buffer[  8].%X2;
			buf2.PressPretrigger.PreTriggerSource.bit27                     :=   array_buffer[  8].%X3;
			buf2.PressPretrigger.PreTriggerSource.bit28                     :=   array_buffer[  8].%X4;
			buf2.PressPretrigger.PreTriggerSource.bit29                     :=   array_buffer[  8].%X5;
			buf2.PressPretrigger.PreTriggerSource.bit30                     :=   array_buffer[  8].%X6;
			buf2.PressPretrigger.PreTriggerSource.bit31                     :=   array_buffer[  8].%X7;
			buf2.PressPretrigger.PreTriggerSource.bit16 			        :=   array_buffer[  9].%X0;
			buf2.PressPretrigger.PreTriggerSource.bit17 			        :=   array_buffer[  9].%X1;
			buf2.PressPretrigger.PreTriggerSource.bit18 			        :=   array_buffer[  9].%X2;
			buf2.PressPretrigger.PreTriggerSource.bit19 			        :=   array_buffer[  9].%X3;
			buf2.PressPretrigger.PreTriggerSource.bit20 			        :=   array_buffer[  9].%X4;
			buf2.PressPretrigger.PreTriggerSource.bit21 			        :=   array_buffer[  9].%X5;
			buf2.PressPretrigger.PreTriggerSource.bit22 			        :=   array_buffer[  9].%X6;
			buf2.PressPretrigger.PreTriggerSource.bit23 			        :=   array_buffer[  9].%X7;
			buf2.PressPretrigger.PreTriggerSource.bit8 				        :=   array_buffer[ 10].%X0;
			buf2.PressPretrigger.PreTriggerSource.bit9 				        :=   array_buffer[ 10].%X1;
			buf2.PressPretrigger.PreTriggerSource.bit10 			        :=   array_buffer[ 10].%X2;
			buf2.PressPretrigger.PreTriggerSource.bit11 			        :=   array_buffer[ 10].%X3;
			buf2.PressPretrigger.PreTriggerSource.bit12 			        :=   array_buffer[ 10].%X4;
			buf2.PressPretrigger.PreTriggerSource.bit13 			        :=   array_buffer[ 10].%X5;
			buf2.PressPretrigger.PreTriggerSource.bit14 			        :=   array_buffer[ 10].%X6;
			buf2.PressPretrigger.PreTriggerSource.bit15 			        :=   array_buffer[ 10].%X7;
			buf2.PressPretrigger.PreTriggerSource.AutoIn 			        :=   array_buffer[ 11].%X0;
			buf2.PressPretrigger.PreTriggerSource.Position_Switch 	        :=   array_buffer[ 11].%X1;
			buf2.PressPretrigger.PreTriggerSource._Time 			        :=   array_buffer[ 11].%X2;
			buf2.PressPretrigger.PreTriggerSource.Position 			        :=   array_buffer[ 11].%X3;
			buf2.PressPretrigger.PreTriggerSource.bit4 				        :=   array_buffer[ 11].%X4;
			buf2.PressPretrigger.PreTriggerSource.bit5 				        :=   array_buffer[ 11].%X5;
			buf2.PressPretrigger.PreTriggerSource.bit6 				        :=   array_buffer[ 11].%X6;
			buf2.PressPretrigger.PreTriggerSource.Enable_Trigger 	        :=   array_buffer[ 11].%X7;
			buf2.PressPretrigger.Ignore1:=                  TO_DINT(SHL(TO_DWORD(array_buffer[ 12]), UINT#24) OR
																	SHL(TO_DWORD(array_buffer[ 13]), UINT#16) OR
																	SHL(TO_DWORD(array_buffer[ 14]),  UINT#8) OR
																		TO_DWORD(array_buffer[ 15])); 
			buf2.PressPretrigger.Ignore2:=                  TO_DINT(SHL(TO_DWORD(array_buffer[ 16]), UINT#24) OR
																	SHL(TO_DWORD(array_buffer[ 17]), UINT#16) OR
																	SHL(TO_DWORD(array_buffer[ 18]),  UINT#8) OR
																		TO_DWORD(array_buffer[ 19])); 
			buf2.PressPretrigger.PreTriggerTime:=           TO_DINT(SHL(TO_DWORD(array_buffer[ 20]), UINT#24) OR
																	SHL(TO_DWORD(array_buffer[ 21]), UINT#16) OR
																	SHL(TO_DWORD(array_buffer[ 22]),  UINT#8) OR
																		TO_DWORD(array_buffer[ 23])); 
			buf2.PressPretrigger.PreTriggerPosition:=       TO_DINT(SHL(TO_DWORD(array_buffer[ 24]), UINT#24) OR
																    SHL(TO_DWORD(array_buffer[ 25]), UINT#16) OR
																    SHL(TO_DWORD(array_buffer[ 26]),  UINT#8) OR
																    	TO_DWORD(array_buffer[ 27])); 
			buf2.PressTrigger.TriggerSource.res_bit24 				        :=   array_buffer[ 28].%X0;
			buf2.PressTrigger.TriggerSource.res_bit25 				        :=   array_buffer[ 28].%X1;
			buf2.PressTrigger.TriggerSource.res_bit26 				        :=   array_buffer[ 28].%X2;
			buf2.PressTrigger.TriggerSource.res_bit27 				        :=   array_buffer[ 28].%X3;
			buf2.PressTrigger.TriggerSource.res_bit28 				        :=   array_buffer[ 28].%X4;
			buf2.PressTrigger.TriggerSource.res_bit29 				        :=   array_buffer[ 28].%X5;
			buf2.PressTrigger.TriggerSource.res_bit30 				        :=   array_buffer[ 28].%X6;
			buf2.PressTrigger.TriggerSource.res_bit31 				        :=   array_buffer[ 28].%X7;
			buf2.PressTrigger.TriggerSource.res_bit16 				        :=   array_buffer[ 29].%X0;
			buf2.PressTrigger.TriggerSource.res_bit17 				        :=   array_buffer[ 29].%X1;
			buf2.PressTrigger.TriggerSource.res_bit18 				        :=   array_buffer[ 29].%X2;
			buf2.PressTrigger.TriggerSource.res_bit19 				        :=   array_buffer[ 29].%X3;
			buf2.PressTrigger.TriggerSource.res_bit20 				        :=   array_buffer[ 29].%X4;
			buf2.PressTrigger.TriggerSource.res_bit21 				        :=   array_buffer[ 29].%X5;
			buf2.PressTrigger.TriggerSource.res_bit22 				        :=   array_buffer[ 29].%X6;
			buf2.PressTrigger.TriggerSource.res_bit23 				        :=   array_buffer[ 29].%X7;
			buf2.PressTrigger.TriggerSource.res_bit8 				        :=   array_buffer[ 30].%X0;
			buf2.PressTrigger.TriggerSource.res_bit9 				        :=   array_buffer[ 30].%X1;
			buf2.PressTrigger.TriggerSource.res_bit10 				        :=   array_buffer[ 30].%X2;
			buf2.PressTrigger.TriggerSource.res_bit11 				        :=   array_buffer[ 30].%X3;
			buf2.PressTrigger.TriggerSource.res_bit12 				        :=   array_buffer[ 30].%X4;
			buf2.PressTrigger.TriggerSource.res_bit13 				        :=   array_buffer[ 30].%X5;
			buf2.PressTrigger.TriggerSource.res_bit14 				        :=   array_buffer[ 30].%X6;
			buf2.PressTrigger.TriggerSource.Enable_Trigger 			        :=   array_buffer[ 30].%X7;
			buf2.PressTrigger.TriggerSource.AutoIn 					        :=   array_buffer[ 31].%X0;
			buf2.PressTrigger.TriggerSource.Position_Switch 		        :=   array_buffer[ 31].%X1;
			buf2.PressTrigger.TriggerSource.res_bit2 				        :=   array_buffer[ 31].%X2;
			buf2.PressTrigger.TriggerSource.Position 				        :=   array_buffer[ 31].%X3;
			buf2.PressTrigger.TriggerSource.res_bit4 				        :=   array_buffer[ 31].%X4;
			buf2.PressTrigger.TriggerSource.Power 					        :=   array_buffer[ 31].%X5;
			buf2.PressTrigger.TriggerSource.res_bit6 				        :=   array_buffer[ 31].%X6;
			buf2.PressTrigger.TriggerSource.res_bit7 				        :=   array_buffer[ 31].%X7;
			buf2.PressTrigger.TriggerByPositionLevel:=      TO_DINT(SHL(TO_DWORD(array_buffer[ 32]), UINT#24) OR
																    SHL(TO_DWORD(array_buffer[ 33]), UINT#16) OR
																    SHL(TO_DWORD(array_buffer[ 34]),  UINT#8) OR
																    	TO_DWORD(array_buffer[ 35])); 
			buf2.PressTriggerDelay.TriggerDelaySource:=     TO_DINT(SHL(TO_DWORD(array_buffer[ 36]), UINT#24) OR
																    SHL(TO_DWORD(array_buffer[ 37]), UINT#16) OR
																    SHL(TO_DWORD(array_buffer[ 38]),  UINT#8) OR
																    	TO_DWORD(array_buffer[ 39])); 
			buf2.PressTriggerDelay.TriggerDelayTimeout:=    TO_DINT(SHL(TO_DWORD(array_buffer[ 40]), UINT#24) OR
																    SHL(TO_DWORD(array_buffer[ 41]), UINT#16) OR
																    SHL(TO_DWORD(array_buffer[ 42]),  UINT#8) OR
																    	TO_DWORD(array_buffer[ 43])); 
			buf2.PressTriggerDelay.TriggerDelayTime:=       TO_DINT(SHL(TO_DWORD(array_buffer[ 44]), UINT#24) OR
																    SHL(TO_DWORD(array_buffer[ 45]), UINT#16) OR
																    SHL(TO_DWORD(array_buffer[ 46]),  UINT#8) OR
																    	TO_DWORD(array_buffer[ 47])); 
			buf2.PressTriggerDelay.TriggerDelayDistance:=   TO_DINT(SHL(TO_DWORD(array_buffer[ 48]), UINT#24) OR
															        SHL(TO_DWORD(array_buffer[ 49]), UINT#16) OR
															        SHL(TO_DWORD(array_buffer[ 50]),  UINT#8) OR
															        	TO_DWORD(array_buffer[ 51])); 
			buf2.PressWeld.Weld1Source.bit24 						        :=   array_buffer[ 52].%X0;
			buf2.PressWeld.Weld1Source.bit25 						        :=   array_buffer[ 52].%X1;
			buf2.PressWeld.Weld1Source.bit26 						        :=   array_buffer[ 52].%X2;
			buf2.PressWeld.Weld1Source.bit27 						        :=   array_buffer[ 52].%X3;
			buf2.PressWeld.Weld1Source.bit28 						        :=   array_buffer[ 52].%X4;
			buf2.PressWeld.Weld1Source.bit29 						        :=   array_buffer[ 52].%X5;
			buf2.PressWeld.Weld1Source.bit30 						        :=   array_buffer[ 52].%X6;
			buf2.PressWeld.Weld1Source.bit31 						        :=   array_buffer[ 52].%X7;
			buf2.PressWeld.Weld1Source.bit16 						        :=   array_buffer[ 53].%X0;
			buf2.PressWeld.Weld1Source.bit17 						        :=   array_buffer[ 53].%X1;
			buf2.PressWeld.Weld1Source.bit18 						        :=   array_buffer[ 53].%X2;
			buf2.PressWeld.Weld1Source.bit19 						        :=   array_buffer[ 53].%X3;
			buf2.PressWeld.Weld1Source.bit20 						        :=   array_buffer[ 53].%X4;
			buf2.PressWeld.Weld1Source.bit21 						        :=   array_buffer[ 53].%X5;
			buf2.PressWeld.Weld1Source.bit22 						        :=   array_buffer[ 53].%X6;
			buf2.PressWeld.Weld1Source.bit23 						        :=   array_buffer[ 53].%X7;
			buf2.PressWeld.Weld1Source.bit8 						        :=   array_buffer[ 54].%X0;
			buf2.PressWeld.Weld1Source.bit9 						        :=   array_buffer[ 54].%X1;
			buf2.PressWeld.Weld1Source.bit10 						        :=   array_buffer[ 54].%X2;
			buf2.PressWeld.Weld1Source.bit11 						        :=   array_buffer[ 54].%X3;
			buf2.PressWeld.Weld1Source.bit12 						        :=   array_buffer[ 54].%X4;
			buf2.PressWeld.Weld1Source.bit13 						        :=   array_buffer[ 54].%X5;
			buf2.PressWeld.Weld1Source.bit14 						        :=   array_buffer[ 54].%X6;
			buf2.PressWeld.Weld1Source.Enable_Weld_1 				        :=   array_buffer[ 54].%X7;
			buf2.PressWeld.Weld1Source._Time 						        :=   array_buffer[ 55].%X0;
			buf2.PressWeld.Weld1Source.Power 						        :=   array_buffer[ 55].%X1;
			buf2.PressWeld.Weld1Source.Energy 						        :=   array_buffer[ 55].%X2;
			buf2.PressWeld.Weld1Source.Distance 					        :=   array_buffer[ 55].%X3;
			buf2.PressWeld.Weld1Source.Position 					        :=   array_buffer[ 55].%X4;
			buf2.PressWeld.Weld1Source.Ground_Detect 				        :=   array_buffer[ 55].%X5;
			buf2.PressWeld.Weld1Source.Force 						        :=   array_buffer[ 55].%X6;
			buf2.PressWeld.Weld1Source.bit7 						        :=   array_buffer[ 55].%X7;
			buf2.PressWeld.Weld1Timeout:=                   TO_DINT(SHL(TO_DWORD(array_buffer[ 56]), UINT#24) OR
																	SHL(TO_DWORD(array_buffer[ 57]), UINT#16) OR
																	SHL(TO_DWORD(array_buffer[ 58]),  UINT#8) OR
																		TO_DWORD(array_buffer[ 59])); 
			buf2.PressWeld.Weld1Distance:=                  TO_DINT(SHL(TO_DWORD(array_buffer[ 60]), UINT#24) OR
																	SHL(TO_DWORD(array_buffer[ 61]), UINT#16) OR
																	SHL(TO_DWORD(array_buffer[ 62]),  UINT#8) OR
																		TO_DWORD(array_buffer[ 63])); 
			buf2.PressWeld.Weld1Position:=                  TO_DINT(SHL(TO_DWORD(array_buffer[ 64]), UINT#24) OR
																	SHL(TO_DWORD(array_buffer[ 65]), UINT#16) OR
																	SHL(TO_DWORD(array_buffer[ 66]),  UINT#8) OR
																		TO_DWORD(array_buffer[ 67])); 
			buf2.PressWeld.Weld2Source.bit24						        :=   array_buffer[ 68].%X0;
			buf2.PressWeld.Weld2Source.bit25						        :=   array_buffer[ 68].%X1;
			buf2.PressWeld.Weld2Source.bit26						        :=   array_buffer[ 68].%X2;
			buf2.PressWeld.Weld2Source.bit27						        :=   array_buffer[ 68].%X3;
			buf2.PressWeld.Weld2Source.bit28						        :=   array_buffer[ 68].%X4;
			buf2.PressWeld.Weld2Source.bit29						        :=   array_buffer[ 68].%X5;
			buf2.PressWeld.Weld2Source.bit30						        :=   array_buffer[ 68].%X6;
			buf2.PressWeld.Weld2Source.bit31						        :=   array_buffer[ 68].%X7;
			buf2.PressWeld.Weld2Source.bit16						        :=   array_buffer[ 69].%X0;
			buf2.PressWeld.Weld2Source.bit17						        :=   array_buffer[ 69].%X1;
			buf2.PressWeld.Weld2Source.bit18						        :=   array_buffer[ 69].%X2;
			buf2.PressWeld.Weld2Source.bit19						        :=   array_buffer[ 69].%X3;
			buf2.PressWeld.Weld2Source.bit20						        :=   array_buffer[ 69].%X4;
			buf2.PressWeld.Weld2Source.bit21						        :=   array_buffer[ 69].%X5;
			buf2.PressWeld.Weld2Source.bit22						        :=   array_buffer[ 69].%X6;
			buf2.PressWeld.Weld2Source.bit23						        :=   array_buffer[ 69].%X7;
			buf2.PressWeld.Weld2Source.bit8 						        :=   array_buffer[ 70].%X0;
			buf2.PressWeld.Weld2Source.bit9 						        :=   array_buffer[ 70].%X1;
			buf2.PressWeld.Weld2Source.bit10 					            :=   array_buffer[ 70].%X2;
			buf2.PressWeld.Weld2Source.bit11 					            :=   array_buffer[ 70].%X3;
			buf2.PressWeld.Weld2Source.bit12 					            :=   array_buffer[ 70].%X4;
			buf2.PressWeld.Weld2Source.bit13 					            :=   array_buffer[ 70].%X5;
			buf2.PressWeld.Weld2Source.bit14 					            :=   array_buffer[ 70].%X6;
			buf2.PressWeld.Weld2Source.Enable_Weld_1 			            :=   array_buffer[ 70].%X7;
			buf2.PressWeld.Weld2Source._Time 					            :=   array_buffer[ 71].%X0;
			buf2.PressWeld.Weld2Source.Power 					            :=   array_buffer[ 71].%X1;
			buf2.PressWeld.Weld2Source.Energy 					            :=   array_buffer[ 71].%X2;
			buf2.PressWeld.Weld2Source.Distance 					        :=   array_buffer[ 71].%X3;
			buf2.PressWeld.Weld2Source.Position 					        :=   array_buffer[ 71].%X4;
			buf2.PressWeld.Weld2Source.Ground_Detect 			            :=   array_buffer[ 71].%X5;
			buf2.PressWeld.Weld2Source.Force 					            :=   array_buffer[ 71].%X6;
			buf2.PressWeld.Weld2Source.bit7 						        :=   array_buffer[ 71].%X7;
			buf2.PressWeld.Weld2SecondarySource:=           TO_DINT(SHL(TO_DWORD(array_buffer[ 72]), UINT#24) OR
																	SHL(TO_DWORD(array_buffer[ 73]), UINT#16) OR
																	SHL(TO_DWORD(array_buffer[ 74]),  UINT#8) OR
																		TO_DWORD(array_buffer[ 75])); 
			buf2.PressWeld.Weld2Timeout:=                   TO_DINT(SHL(TO_DWORD(array_buffer[ 76]), UINT#24) OR
																	SHL(TO_DWORD(array_buffer[ 77]), UINT#16) OR
																	SHL(TO_DWORD(array_buffer[ 78]),  UINT#8) OR
																		TO_DWORD(array_buffer[ 79])); 
			buf2.PressWeld.Weld2Time:=                      TO_DINT(SHL(TO_DWORD(array_buffer[ 80]), UINT#24) OR
																	SHL(TO_DWORD(array_buffer[ 81]), UINT#16) OR
																	SHL(TO_DWORD(array_buffer[ 82]),  UINT#8) OR
																		TO_DWORD(array_buffer[ 83])); 
			buf2.PressWeld.Weld2Energy:=                    TO_DINT(SHL(TO_DWORD(array_buffer[ 84]), UINT#24) OR
																	SHL(TO_DWORD(array_buffer[ 85]), UINT#16) OR
																	SHL(TO_DWORD(array_buffer[ 86]),  UINT#8) OR
																		TO_DWORD(array_buffer[ 87])); 
			buf2.PressWeld.Weld2Power:=                     TO_DINT(SHL(TO_DWORD(array_buffer[ 88]), UINT#24) OR
																	SHL(TO_DWORD(array_buffer[ 89]), UINT#16) OR
																	SHL(TO_DWORD(array_buffer[ 90]),  UINT#8) OR
																		TO_DWORD(array_buffer[ 91])); 
			buf2.PressWeld.Weld2Distance:=                  TO_DINT(SHL(TO_DWORD(array_buffer[ 92]), UINT#24) OR
																	SHL(TO_DWORD(array_buffer[ 93]), UINT#16) OR
																	SHL(TO_DWORD(array_buffer[ 94]),  UINT#8) OR
																		TO_DWORD(array_buffer[ 95])); 
			buf2.PressWeld.Weld2Position:=                  TO_DINT(SHL(TO_DWORD(array_buffer[ 96]), UINT#24) OR
																	SHL(TO_DWORD(array_buffer[ 97]), UINT#16) OR
																	SHL(TO_DWORD(array_buffer[ 98]),  UINT#8) OR
																		TO_DWORD(array_buffer[ 99])); 
			buf2.PressWeldScrub.ScrubMode:=                 TO_DINT(SHL(TO_DWORD(array_buffer[100]), UINT#24) OR
																	SHL(TO_DWORD(array_buffer[101]), UINT#16) OR
																	SHL(TO_DWORD(array_buffer[102]),  UINT#8) OR
																		TO_DWORD(array_buffer[103])); 
			buf2.PressWeldScrub.ScrubTime:=                 TO_DINT(SHL(TO_DWORD(array_buffer[104]), UINT#24) OR
																	SHL(TO_DWORD(array_buffer[105]), UINT#16) OR
																	SHL(TO_DWORD(array_buffer[106]),  UINT#8) OR
																		TO_DWORD(array_buffer[107])); 
			buf2.PressPostWeld.DynamicHoldMode.bit24 				        :=   array_buffer[108].%X0;
			buf2.PressPostWeld.DynamicHoldMode.bit25 				        :=   array_buffer[108].%X1;
			buf2.PressPostWeld.DynamicHoldMode.bit26 				        :=   array_buffer[108].%X2;
			buf2.PressPostWeld.DynamicHoldMode.bit27 				        :=   array_buffer[108].%X3;
			buf2.PressPostWeld.DynamicHoldMode.bit28 				        :=   array_buffer[108].%X4;
			buf2.PressPostWeld.DynamicHoldMode.bit29 				        :=   array_buffer[108].%X5;
			buf2.PressPostWeld.DynamicHoldMode.bit30 				        :=   array_buffer[108].%X6;
			buf2.PressPostWeld.DynamicHoldMode.bit31 				        :=   array_buffer[108].%X7;
			buf2.PressPostWeld.DynamicHoldMode.bit16 				        :=   array_buffer[109].%X0;
			buf2.PressPostWeld.DynamicHoldMode.bit17 				        :=   array_buffer[109].%X1;
			buf2.PressPostWeld.DynamicHoldMode.bit18 				        :=   array_buffer[109].%X2;
			buf2.PressPostWeld.DynamicHoldMode.bit19 				        :=   array_buffer[109].%X3;
			buf2.PressPostWeld.DynamicHoldMode.bit20 				        :=   array_buffer[109].%X4;
			buf2.PressPostWeld.DynamicHoldMode.bit21 				        :=   array_buffer[109].%X5;
			buf2.PressPostWeld.DynamicHoldMode.bit22 				        :=   array_buffer[109].%X6;
			buf2.PressPostWeld.DynamicHoldMode.bit23 				        :=   array_buffer[109].%X7;
			buf2.PressPostWeld.DynamicHoldMode.bit8 				        :=   array_buffer[110].%X0;
			buf2.PressPostWeld.DynamicHoldMode.bit9 				        :=   array_buffer[110].%X1;
			buf2.PressPostWeld.DynamicHoldMode.bit10 				        :=   array_buffer[110].%X2;
			buf2.PressPostWeld.DynamicHoldMode.bit11 				        :=   array_buffer[110].%X3;
			buf2.PressPostWeld.DynamicHoldMode.bit12 				        :=   array_buffer[110].%X4;
			buf2.PressPostWeld.DynamicHoldMode.bit13 				        :=   array_buffer[110].%X5;
			buf2.PressPostWeld.DynamicHoldMode.bit14 				        :=   array_buffer[110].%X6;
			buf2.PressPostWeld.DynamicHoldMode.bit15 				        :=   array_buffer[110].%X7;
			buf2.PressPostWeld.DynamicHoldMode._Time 				        :=   array_buffer[111].%X0;
			buf2.PressPostWeld.DynamicHoldMode.Distance 			        :=   array_buffer[111].%X1;
			buf2.PressPostWeld.DynamicHoldMode.Force 				        :=   array_buffer[111].%X2;
			buf2.PressPostWeld.DynamicHoldMode.AutoIn 				        :=   array_buffer[111].%X3;
			buf2.PressPostWeld.DynamicHoldMode.Velocity 			        :=   array_buffer[111].%X4;
			buf2.PressPostWeld.DynamicHoldMode.bit5 				        :=   array_buffer[111].%X5;
			buf2.PressPostWeld.DynamicHoldMode.bit6 				        :=   array_buffer[111].%X6;
			buf2.PressPostWeld.DynamicHoldMode.bit7 				        :=   array_buffer[111].%X7;
			buf2.PressPostWeld.DynamicHoldTimeout:=         TO_DINT(SHL(TO_DWORD(array_buffer[112]), UINT#24) OR
																	SHL(TO_DWORD(array_buffer[113]), UINT#16) OR
																	SHL(TO_DWORD(array_buffer[114]),  UINT#8) OR
																		TO_DWORD(array_buffer[115])); 
			buf2.PressPostWeld.DynamicHoldDistance:=        TO_DINT(SHL(TO_DWORD(array_buffer[116]), UINT#24) OR
																	SHL(TO_DWORD(array_buffer[117]), UINT#16) OR
																	SHL(TO_DWORD(array_buffer[118]),  UINT#8) OR
																		TO_DWORD(array_buffer[119])); 
			buf2.PressPostWeld.DynamicHoldForce:=           TO_DINT(SHL(TO_DWORD(array_buffer[120]), UINT#24) OR
																	SHL(TO_DWORD(array_buffer[121]), UINT#16) OR
																	SHL(TO_DWORD(array_buffer[122]),  UINT#8) OR
																		TO_DWORD(array_buffer[123])); 
			buf2.PressPostWeld.StaticHoldMode:=             TO_DINT(SHL(TO_DWORD(array_buffer[124]), UINT#24) OR
																	SHL(TO_DWORD(array_buffer[125]), UINT#16) OR
																	SHL(TO_DWORD(array_buffer[126]),  UINT#8) OR
																		TO_DWORD(array_buffer[127])); 
			buf2.PressPostWeld.StaticHoldTime:=             TO_DINT(SHL(TO_DWORD(array_buffer[128]), UINT#24) OR
																	SHL(TO_DWORD(array_buffer[129]), UINT#16) OR
																	SHL(TO_DWORD(array_buffer[130]),  UINT#8) OR
																		TO_DWORD(array_buffer[131])); 
			buf2.PressPostWeld.AfterburstAmplitude:=        TO_DINT(SHL(TO_DWORD(array_buffer[132]), UINT#24) OR
																	SHL(TO_DWORD(array_buffer[133]), UINT#16) OR
																	SHL(TO_DWORD(array_buffer[134]),  UINT#8) OR
																		TO_DWORD(array_buffer[135])); 
        END_METHOD

        METHOD PRIVATE ByteArray_TO_buf3 
            VAR_INPUT
                array_buffer : ARRAY[0..253] OF BYTE;
            END_VAR
            VAR_IN_OUT
                buf3 : Axo_IQ_SeriesWelder_data3_180bytes;
            END_VAR
			buf3.TriggerTime.Enable._0 						        :=   array_buffer[  0].%X0;
			buf3.TriggerTime.Enable._1 						        :=   array_buffer[  0].%X1;
			buf3.TriggerTime.Enable._2 						        :=   array_buffer[  0].%X2;
			buf3.TriggerTime.Enable._3 						        :=   array_buffer[  0].%X3;
			buf3.TriggerTime.Enable._4 						        :=   array_buffer[  0].%X4;
			buf3.TriggerTime.Enable._5 						        :=   array_buffer[  0].%X5;
			buf3.TriggerTime.Enable._6 						        :=   array_buffer[  0].%X6;
			buf3.TriggerTime.Enable._7 						        :=   array_buffer[  0].%X7;
			buf3.TriggerTime.Enable._8 						        :=   array_buffer[  1].%X0;
			buf3.TriggerTime.Enable._9 						        :=   array_buffer[  1].%X1;
			buf3.TriggerTime.Enable._10 					        :=   array_buffer[  1].%X2;
			buf3.TriggerTime.Enable._11 					        :=   array_buffer[  1].%X3;
			buf3.TriggerTime.Enable._12 					        :=   array_buffer[  1].%X4;
			buf3.TriggerTime.Enable._13 					        :=   array_buffer[  1].%X5;
			buf3.TriggerTime.Enable._14 					        :=   array_buffer[  1].%X6;
			buf3.TriggerTime.Enable._15 					        :=   array_buffer[  1].%X7;
			buf3.TriggerTime.Enable._16 					        :=   array_buffer[  2].%X0;
			buf3.TriggerTime.Enable._17 					        :=   array_buffer[  2].%X1;
			buf3.TriggerTime.Enable._18 					        :=   array_buffer[  2].%X2;
			buf3.TriggerTime.Enable._19 					        :=   array_buffer[  2].%X3;
			buf3.TriggerTime.Enable._20 					        :=   array_buffer[  2].%X4;
			buf3.TriggerTime.Enable._21 					        :=   array_buffer[  2].%X5;
			buf3.TriggerTime.Enable._22 					        :=   array_buffer[  2].%X6;
			buf3.TriggerTime.Enable._23 					        :=   array_buffer[  2].%X7;
			buf3.TriggerTime.Enable.LowerBad_1 				        :=   array_buffer[  3].%X0;
			buf3.TriggerTime.Enable.LowerSuspect_1 			        :=   array_buffer[  3].%X1;
			buf3.TriggerTime.Enable.UpperSuspect_1			        :=   array_buffer[  3].%X2;
			buf3.TriggerTime.Enable.UpperBad_1 				        :=   array_buffer[  3].%X3;
			buf3.TriggerTime.Enable.Display_1 				        :=   array_buffer[  3].%X4;
			buf3.TriggerTime.Enable._29 					        :=   array_buffer[  3].%X5;
			buf3.TriggerTime.Enable._30 					        :=   array_buffer[  3].%X6;
			buf3.TriggerTime.Enable._31 					        :=   array_buffer[  3].%X7;
			buf3.TriggerTime.LowerBad:=             TO_DINT(SHL(TO_DWORD(array_buffer[  4]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[  5]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[  6]),  UINT#8) OR
																TO_DWORD(array_buffer[  7])); 
			buf3.TriggerTime.LowerSuspect:=         TO_DINT(SHL(TO_DWORD(array_buffer[  8]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[  9]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[ 10]),  UINT#8) OR
																TO_DWORD(array_buffer[ 11])); 
			buf3.TriggerTime.UpperSuspect:=         TO_DINT(SHL(TO_DWORD(array_buffer[ 12]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[ 13]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[ 14]),  UINT#8) OR
																TO_DWORD(array_buffer[ 15])); 
			buf3.TriggerTime.UpperBad:=             TO_DINT(SHL(TO_DWORD(array_buffer[ 16]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[ 17]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[ 18]),  UINT#8) OR
																TO_DWORD(array_buffer[ 19])); 
			buf3.TriggerPosition.Enable._0 					        :=   array_buffer[ 20].%X0;
			buf3.TriggerPosition.Enable._1 					        :=   array_buffer[ 20].%X1;
			buf3.TriggerPosition.Enable._2 					        :=   array_buffer[ 20].%X2;
			buf3.TriggerPosition.Enable._3 					        :=   array_buffer[ 20].%X3;
			buf3.TriggerPosition.Enable._4 					        :=   array_buffer[ 20].%X4;
			buf3.TriggerPosition.Enable._5 					        :=   array_buffer[ 20].%X5;
			buf3.TriggerPosition.Enable._6 					        :=   array_buffer[ 20].%X6;
			buf3.TriggerPosition.Enable._7 					        :=   array_buffer[ 20].%X7;
			buf3.TriggerPosition.Enable._8 					        :=   array_buffer[ 21].%X0;
			buf3.TriggerPosition.Enable._9 					        :=   array_buffer[ 21].%X1;
			buf3.TriggerPosition.Enable._10 				        :=   array_buffer[ 21].%X2;
			buf3.TriggerPosition.Enable._11 				        :=   array_buffer[ 21].%X3;
			buf3.TriggerPosition.Enable._12 				        :=   array_buffer[ 21].%X4;
			buf3.TriggerPosition.Enable._13 				        :=   array_buffer[ 21].%X5;
			buf3.TriggerPosition.Enable._14 				        :=   array_buffer[ 21].%X6;
			buf3.TriggerPosition.Enable._15 				        :=   array_buffer[ 21].%X7;
			buf3.TriggerPosition.Enable._16 				        :=   array_buffer[ 22].%X0;
			buf3.TriggerPosition.Enable._17 				        :=   array_buffer[ 22].%X1;
			buf3.TriggerPosition.Enable._18 				        :=   array_buffer[ 22].%X2;
			buf3.TriggerPosition.Enable._19 				        :=   array_buffer[ 22].%X3;
			buf3.TriggerPosition.Enable._20 				        :=   array_buffer[ 22].%X4;
			buf3.TriggerPosition.Enable._21 				        :=   array_buffer[ 22].%X5;
			buf3.TriggerPosition.Enable._22 				        :=   array_buffer[ 22].%X6;
			buf3.TriggerPosition.Enable._23 				        :=   array_buffer[ 22].%X7;
			buf3.TriggerPosition.Enable.LowerBad_1 			        :=   array_buffer[ 23].%X0;
			buf3.TriggerPosition.Enable.LowerSuspect_1 		        :=   array_buffer[ 23].%X1;
			buf3.TriggerPosition.Enable.UpperSuspect_1		        :=   array_buffer[ 23].%X2;
			buf3.TriggerPosition.Enable.UpperBad_1 				    :=   array_buffer[ 23].%X3;
			buf3.TriggerPosition.Enable.Display_1 				    :=   array_buffer[ 23].%X4;
			buf3.TriggerPosition.Enable._29 					    :=   array_buffer[ 23].%X5;
			buf3.TriggerPosition.Enable._30 					    :=   array_buffer[ 23].%X6;
			buf3.TriggerPosition.Enable._31 					    :=   array_buffer[ 23].%X7;
			buf3.TriggerPosition.LowerBad:=         TO_DINT(SHL(TO_DWORD(array_buffer[ 24]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[ 25]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[ 26]),  UINT#8) OR
																TO_DWORD(array_buffer[ 27])); 
			buf3.TriggerPosition.LowerSuspect:=     TO_DINT(SHL(TO_DWORD(array_buffer[ 28]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[ 29]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[ 30]),  UINT#8) OR
																TO_DWORD(array_buffer[ 31])); 
			buf3.TriggerPosition.UpperSuspect:=     TO_DINT(SHL(TO_DWORD(array_buffer[ 32]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[ 33]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[ 34]),  UINT#8) OR
																TO_DWORD(array_buffer[ 35])); 
			buf3.TriggerPosition.UpperBad:=         TO_DINT(SHL(TO_DWORD(array_buffer[ 36]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[ 37]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[ 38]),  UINT#8) OR
																TO_DWORD(array_buffer[ 39])); 
			buf3.TriggerDelayTime.Enable._0 					    :=   array_buffer[ 40].%X0;
			buf3.TriggerDelayTime.Enable._1 					    :=   array_buffer[ 40].%X1;
			buf3.TriggerDelayTime.Enable._2 					    :=   array_buffer[ 40].%X2;
			buf3.TriggerDelayTime.Enable._3 					    :=   array_buffer[ 40].%X3;
			buf3.TriggerDelayTime.Enable._4 					    :=   array_buffer[ 40].%X4;
			buf3.TriggerDelayTime.Enable._5 					    :=   array_buffer[ 40].%X5;
			buf3.TriggerDelayTime.Enable._6 					    :=   array_buffer[ 40].%X6;
			buf3.TriggerDelayTime.Enable._7 					    :=   array_buffer[ 40].%X7;
			buf3.TriggerDelayTime.Enable._8 					    :=   array_buffer[ 41].%X0;
			buf3.TriggerDelayTime.Enable._9 					    :=   array_buffer[ 41].%X1;
			buf3.TriggerDelayTime.Enable._10 				        :=   array_buffer[ 41].%X2;
			buf3.TriggerDelayTime.Enable._11 				        :=   array_buffer[ 41].%X3;
			buf3.TriggerDelayTime.Enable._12 				        :=   array_buffer[ 41].%X4;
			buf3.TriggerDelayTime.Enable._13 				        :=   array_buffer[ 41].%X5;
			buf3.TriggerDelayTime.Enable._14 				        :=   array_buffer[ 41].%X6;
			buf3.TriggerDelayTime.Enable._15 				        :=   array_buffer[ 41].%X7;
			buf3.TriggerDelayTime.Enable._16 				        :=   array_buffer[ 42].%X0;
			buf3.TriggerDelayTime.Enable._17 				        :=   array_buffer[ 42].%X1;
			buf3.TriggerDelayTime.Enable._18 				        :=   array_buffer[ 42].%X2;
			buf3.TriggerDelayTime.Enable._19 				        :=   array_buffer[ 42].%X3;
			buf3.TriggerDelayTime.Enable._20 				        :=   array_buffer[ 42].%X4;
			buf3.TriggerDelayTime.Enable._21 				        :=   array_buffer[ 42].%X5;
			buf3.TriggerDelayTime.Enable._22 				        :=   array_buffer[ 42].%X6;
			buf3.TriggerDelayTime.Enable._23 				        :=   array_buffer[ 42].%X7;
			buf3.TriggerDelayTime.Enable.LowerBad_1 			    :=   array_buffer[ 43].%X0;
			buf3.TriggerDelayTime.Enable.LowerSuspect_1 		    :=   array_buffer[ 43].%X1;
			buf3.TriggerDelayTime.Enable.UpperSuspect_1		        :=   array_buffer[ 43].%X2;
			buf3.TriggerDelayTime.Enable.UpperBad_1 			    :=   array_buffer[ 43].%X3;
			buf3.TriggerDelayTime.Enable.Display_1 				    :=   array_buffer[ 43].%X4;
			buf3.TriggerDelayTime.Enable._29 					    :=   array_buffer[ 43].%X5;
			buf3.TriggerDelayTime.Enable._30 					    :=   array_buffer[ 43].%X6;
			buf3.TriggerDelayTime.Enable._31 					    :=   array_buffer[ 43].%X7;
			buf3.TriggerDelayTime.LowerBad:=        TO_DINT(SHL(TO_DWORD(array_buffer[ 44]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[ 45]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[ 46]),  UINT#8) OR
																TO_DWORD(array_buffer[ 47])); 
			buf3.TriggerDelayTime.LowerSuspect:=    TO_DINT(SHL(TO_DWORD(array_buffer[ 48]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[ 49]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[ 50]),  UINT#8) OR
																TO_DWORD(array_buffer[ 51])); 
			buf3.TriggerDelayTime.UpperSuspect:=    TO_DINT(SHL(TO_DWORD(array_buffer[ 52]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[ 53]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[ 54]),  UINT#8) OR
																TO_DWORD(array_buffer[ 55])); 
			buf3.TriggerDelayTime.UpperBad:=        TO_DINT(SHL(TO_DWORD(array_buffer[ 56]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[ 57]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[ 58]),  UINT#8) OR
																TO_DWORD(array_buffer[ 59]));                                                                                             
			buf3.TriggerDelayDistance.Enable._0 				    :=   array_buffer[ 60].%X0;
			buf3.TriggerDelayDistance.Enable._1 				    :=   array_buffer[ 60].%X1;
			buf3.TriggerDelayDistance.Enable._2 				    :=   array_buffer[ 60].%X2;
			buf3.TriggerDelayDistance.Enable._3 				    :=   array_buffer[ 60].%X3;
			buf3.TriggerDelayDistance.Enable._4 				    :=   array_buffer[ 60].%X4;
			buf3.TriggerDelayDistance.Enable._5 				    :=   array_buffer[ 60].%X5;
			buf3.TriggerDelayDistance.Enable._6 				    :=   array_buffer[ 60].%X6;
			buf3.TriggerDelayDistance.Enable._7 				    :=   array_buffer[ 60].%X7;
			buf3.TriggerDelayDistance.Enable._8 				    :=   array_buffer[ 61].%X0;
			buf3.TriggerDelayDistance.Enable._9 				    :=   array_buffer[ 61].%X1;
			buf3.TriggerDelayDistance.Enable._10 				    :=   array_buffer[ 61].%X2;
			buf3.TriggerDelayDistance.Enable._11 				    :=   array_buffer[ 61].%X3;
			buf3.TriggerDelayDistance.Enable._12 				    :=   array_buffer[ 61].%X4;
			buf3.TriggerDelayDistance.Enable._13 				    :=   array_buffer[ 61].%X5;
			buf3.TriggerDelayDistance.Enable._14 				    :=   array_buffer[ 61].%X6;
			buf3.TriggerDelayDistance.Enable._15 				    :=   array_buffer[ 61].%X7;
			buf3.TriggerDelayDistance.Enable._16 				    :=   array_buffer[ 62].%X0;
			buf3.TriggerDelayDistance.Enable._17 				    :=   array_buffer[ 62].%X1;
			buf3.TriggerDelayDistance.Enable._18 				    :=   array_buffer[ 62].%X2;
			buf3.TriggerDelayDistance.Enable._19 				    :=   array_buffer[ 62].%X3;
			buf3.TriggerDelayDistance.Enable._20 				    :=   array_buffer[ 62].%X4;
			buf3.TriggerDelayDistance.Enable._21 				    :=   array_buffer[ 62].%X5;
			buf3.TriggerDelayDistance.Enable._22 				    :=   array_buffer[ 62].%X6;
			buf3.TriggerDelayDistance.Enable._23 				    :=   array_buffer[ 62].%X7;
			buf3.TriggerDelayDistance.Enable.LowerBad_1 		    :=   array_buffer[ 63].%X0;
			buf3.TriggerDelayDistance.Enable.LowerSuspect_1 	    :=   array_buffer[ 63].%X1;
			buf3.TriggerDelayDistance.Enable.UpperSuspect_1		    :=   array_buffer[ 63].%X2;
			buf3.TriggerDelayDistance.Enable.UpperBad_1 		    :=   array_buffer[ 63].%X3;
			buf3.TriggerDelayDistance.Enable.Display_1 			    :=   array_buffer[ 63].%X4;
			buf3.TriggerDelayDistance.Enable._29 				    :=   array_buffer[ 63].%X5;
			buf3.TriggerDelayDistance.Enable._30 				    :=   array_buffer[ 63].%X6;
			buf3.TriggerDelayDistance.Enable._31 				    :=   array_buffer[ 63].%X7;
			buf3.TriggerDelayDistance.LowerBad:=    TO_DINT(SHL(TO_DWORD(array_buffer[ 64]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[ 65]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[ 66]),  UINT#8) OR
																TO_DWORD(array_buffer[ 67])); 
			buf3.TriggerDelayDistance.LowerSuspect:=TO_DINT(SHL(TO_DWORD(array_buffer[ 68]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[ 69]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[ 70]),  UINT#8) OR
																TO_DWORD(array_buffer[ 71])); 
			buf3.TriggerDelayDistance.UpperSuspect:=TO_DINT(SHL(TO_DWORD(array_buffer[ 72]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[ 73]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[ 74]),  UINT#8) OR
																TO_DWORD(array_buffer[ 75])); 
			buf3.TriggerDelayDistance.UpperBad:=    TO_DINT(SHL(TO_DWORD(array_buffer[ 76]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[ 77]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[ 78]),  UINT#8) OR
																TO_DWORD(array_buffer[ 79]));                                                                                             
			buf3.Weld1Distance.Enable._0 				            :=   array_buffer[ 80].%X0;
			buf3.Weld1Distance.Enable._1 				            :=   array_buffer[ 80].%X1;
			buf3.Weld1Distance.Enable._2 				            :=   array_buffer[ 80].%X2;
			buf3.Weld1Distance.Enable._3 				            :=   array_buffer[ 80].%X3;
			buf3.Weld1Distance.Enable._4 				            :=   array_buffer[ 80].%X4;
			buf3.Weld1Distance.Enable._5 				            :=   array_buffer[ 80].%X5;
			buf3.Weld1Distance.Enable._6 				            :=   array_buffer[ 80].%X6;
			buf3.Weld1Distance.Enable._7 				            :=   array_buffer[ 80].%X7;
			buf3.Weld1Distance.Enable._8 				            :=   array_buffer[ 81].%X0;
			buf3.Weld1Distance.Enable._9 				            :=   array_buffer[ 81].%X1;
			buf3.Weld1Distance.Enable._10 				            :=   array_buffer[ 81].%X2;
			buf3.Weld1Distance.Enable._11 				            :=   array_buffer[ 81].%X3;
			buf3.Weld1Distance.Enable._12 				            :=   array_buffer[ 81].%X4;
			buf3.Weld1Distance.Enable._13 				            :=   array_buffer[ 81].%X5;
			buf3.Weld1Distance.Enable._14 				            :=   array_buffer[ 81].%X6;
			buf3.Weld1Distance.Enable._15 				            :=   array_buffer[ 81].%X7;
			buf3.Weld1Distance.Enable._16 				            :=   array_buffer[ 82].%X0;
			buf3.Weld1Distance.Enable._17 				            :=   array_buffer[ 82].%X1;
			buf3.Weld1Distance.Enable._18 				            :=   array_buffer[ 82].%X2;
			buf3.Weld1Distance.Enable._19 				            :=   array_buffer[ 82].%X3;
			buf3.Weld1Distance.Enable._20 				            :=   array_buffer[ 82].%X4;
			buf3.Weld1Distance.Enable._21 				            :=   array_buffer[ 82].%X5;
			buf3.Weld1Distance.Enable._22 				            :=   array_buffer[ 82].%X6;
			buf3.Weld1Distance.Enable._23 				            :=   array_buffer[ 82].%X7;
			buf3.Weld1Distance.Enable.LowerBad_1 		            :=   array_buffer[ 83].%X0;
			buf3.Weld1Distance.Enable.LowerSuspect_1 	            :=   array_buffer[ 83].%X1;
			buf3.Weld1Distance.Enable.UpperSuspect_1		        :=   array_buffer[ 83].%X2;
			buf3.Weld1Distance.Enable.UpperBad_1 		            :=   array_buffer[ 83].%X3;
			buf3.Weld1Distance.Enable.Display_1 			        :=   array_buffer[ 83].%X4;
			buf3.Weld1Distance.Enable._29 				            :=   array_buffer[ 83].%X5;
			buf3.Weld1Distance.Enable._30 				            :=   array_buffer[ 83].%X6;
			buf3.Weld1Distance.Enable._31 				            :=   array_buffer[ 83].%X7;
			buf3.Weld1Distance.LowerBad:=           TO_DINT(SHL(TO_DWORD(array_buffer[ 84]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[ 85]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[ 86]),  UINT#8) OR
																TO_DWORD(array_buffer[ 87])); 
			buf3.Weld1Distance.LowerSuspect:=       TO_DINT(SHL(TO_DWORD(array_buffer[ 88]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[ 89]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[ 90]),  UINT#8) OR
																TO_DWORD(array_buffer[ 91])); 
			buf3.Weld1Distance.UpperSuspect:=       TO_DINT(SHL(TO_DWORD(array_buffer[ 92]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[ 93]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[ 94]),  UINT#8) OR
																TO_DWORD(array_buffer[ 95])); 
			buf3.Weld1Distance.UpperBad:=           TO_DINT(SHL(TO_DWORD(array_buffer[ 96]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[ 97]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[ 98]),  UINT#8) OR
																TO_DWORD(array_buffer[ 99]));                                                                                             
			buf3.Weld1Position.Enable._0 				            :=   array_buffer[100].%X0;
			buf3.Weld1Position.Enable._1 				            :=   array_buffer[100].%X1;
			buf3.Weld1Position.Enable._2 				            :=   array_buffer[100].%X2;
			buf3.Weld1Position.Enable._3 				            :=   array_buffer[100].%X3;
			buf3.Weld1Position.Enable._4 				            :=   array_buffer[100].%X4;
			buf3.Weld1Position.Enable._5 				            :=   array_buffer[100].%X5;
			buf3.Weld1Position.Enable._6 				            :=   array_buffer[100].%X6;
			buf3.Weld1Position.Enable._7 				            :=   array_buffer[100].%X7;
			buf3.Weld1Position.Enable._8 				            :=   array_buffer[101].%X0;
			buf3.Weld1Position.Enable._9 				            :=   array_buffer[101].%X1;
			buf3.Weld1Position.Enable._10 				            :=   array_buffer[101].%X2;
			buf3.Weld1Position.Enable._11 				            :=   array_buffer[101].%X3;
			buf3.Weld1Position.Enable._12 				            :=   array_buffer[101].%X4;
			buf3.Weld1Position.Enable._13 				            :=   array_buffer[101].%X5;
			buf3.Weld1Position.Enable._14 				            :=   array_buffer[101].%X6;
			buf3.Weld1Position.Enable._15 				            :=   array_buffer[101].%X7;
			buf3.Weld1Position.Enable._16 				            :=   array_buffer[102].%X0;
			buf3.Weld1Position.Enable._17 				            :=   array_buffer[102].%X1;
			buf3.Weld1Position.Enable._18 				            :=   array_buffer[102].%X2;
			buf3.Weld1Position.Enable._19 				            :=   array_buffer[102].%X3;
			buf3.Weld1Position.Enable._20 				            :=   array_buffer[102].%X4;
			buf3.Weld1Position.Enable._21 				            :=   array_buffer[102].%X5;
			buf3.Weld1Position.Enable._22 				            :=   array_buffer[102].%X6;
			buf3.Weld1Position.Enable._23 				            :=   array_buffer[102].%X7;
			buf3.Weld1Position.Enable.LowerBad_1 		            :=   array_buffer[103].%X0;
			buf3.Weld1Position.Enable.LowerSuspect_1 	            :=   array_buffer[103].%X1;
			buf3.Weld1Position.Enable.UpperSuspect_1		        :=   array_buffer[103].%X2;
			buf3.Weld1Position.Enable.UpperBad_1 		            :=   array_buffer[103].%X3;
			buf3.Weld1Position.Enable.Display_1 			        :=   array_buffer[103].%X4;
			buf3.Weld1Position.Enable._29 				            :=   array_buffer[103].%X5;
			buf3.Weld1Position.Enable._30 				            :=   array_buffer[103].%X6;
			buf3.Weld1Position.Enable._31 				            :=   array_buffer[103].%X7;
			buf3.Weld1Position.LowerBad:=           TO_DINT(SHL(TO_DWORD(array_buffer[104]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[105]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[106]),  UINT#8) OR
																TO_DWORD(array_buffer[107])); 
			buf3.Weld1Position.LowerSuspect:=       TO_DINT(SHL(TO_DWORD(array_buffer[108]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[109]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[110]),  UINT#8) OR
																TO_DWORD(array_buffer[111])); 
			buf3.Weld1Position.UpperSuspect:=       TO_DINT(SHL(TO_DWORD(array_buffer[112]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[113]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[114]),  UINT#8) OR
																TO_DWORD(array_buffer[115])); 
			buf3.Weld1Position.UpperBad:=           TO_DINT(SHL(TO_DWORD(array_buffer[116]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[117]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[118]),  UINT#8) OR
																TO_DWORD(array_buffer[119]));                                                                                             
			buf3.Weld2Time.Enable._0 				                :=   array_buffer[120].%X0;
			buf3.Weld2Time.Enable._1 				                :=   array_buffer[120].%X1;
			buf3.Weld2Time.Enable._2 				                :=   array_buffer[120].%X2;
			buf3.Weld2Time.Enable._3 				                :=   array_buffer[120].%X3;
			buf3.Weld2Time.Enable._4 				                :=   array_buffer[120].%X4;
			buf3.Weld2Time.Enable._5 				                :=   array_buffer[120].%X5;
			buf3.Weld2Time.Enable._6 				                :=   array_buffer[120].%X6;
			buf3.Weld2Time.Enable._7 				                :=   array_buffer[120].%X7;
			buf3.Weld2Time.Enable._8 				                :=   array_buffer[121].%X0;
			buf3.Weld2Time.Enable._9 				                :=   array_buffer[121].%X1;
			buf3.Weld2Time.Enable._10 				                :=   array_buffer[121].%X2;
			buf3.Weld2Time.Enable._11 				                :=   array_buffer[121].%X3;
			buf3.Weld2Time.Enable._12 				                :=   array_buffer[121].%X4;
			buf3.Weld2Time.Enable._13 				                :=   array_buffer[121].%X5;
			buf3.Weld2Time.Enable._14 				                :=   array_buffer[121].%X6;
			buf3.Weld2Time.Enable._15 				                :=   array_buffer[121].%X7;
			buf3.Weld2Time.Enable._16 				                :=   array_buffer[122].%X0;
			buf3.Weld2Time.Enable._17 				                :=   array_buffer[122].%X1;
			buf3.Weld2Time.Enable._18 				                :=   array_buffer[122].%X2;
			buf3.Weld2Time.Enable._19 				                :=   array_buffer[122].%X3;
			buf3.Weld2Time.Enable._20 				                :=   array_buffer[122].%X4;
			buf3.Weld2Time.Enable._21 				                :=   array_buffer[122].%X5;
			buf3.Weld2Time.Enable._22 				                :=   array_buffer[122].%X6;
			buf3.Weld2Time.Enable._23 				                :=   array_buffer[122].%X7;
			buf3.Weld2Time.Enable.LowerBad_1 		                :=   array_buffer[123].%X0;
			buf3.Weld2Time.Enable.LowerSuspect_1 	                :=   array_buffer[123].%X1;
			buf3.Weld2Time.Enable.UpperSuspect_1		            :=   array_buffer[123].%X2;
			buf3.Weld2Time.Enable.UpperBad_1 		                :=   array_buffer[123].%X3;
			buf3.Weld2Time.Enable.Display_1 			            :=   array_buffer[123].%X4;
			buf3.Weld2Time.Enable._29 				                :=   array_buffer[123].%X5;
			buf3.Weld2Time.Enable._30 				                :=   array_buffer[123].%X6;
			buf3.Weld2Time.Enable._31 				                :=   array_buffer[123].%X7;
			buf3.Weld2Time.LowerBad:=               TO_DINT(SHL(TO_DWORD(array_buffer[124]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[125]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[126]),  UINT#8) OR
																TO_DWORD(array_buffer[127])); 
			buf3.Weld2Time.LowerSuspect:=           TO_DINT(SHL(TO_DWORD(array_buffer[128]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[129]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[130]),  UINT#8) OR
																TO_DWORD(array_buffer[131])); 
			buf3.Weld2Time.UpperSuspect:=           TO_DINT(SHL(TO_DWORD(array_buffer[132]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[133]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[134]),  UINT#8) OR
																TO_DWORD(array_buffer[135])); 
			buf3.Weld2Time.UpperBad:=               TO_DINT(SHL(TO_DWORD(array_buffer[136]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[137]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[138]),  UINT#8) OR
																TO_DWORD(array_buffer[139]));                                                                                             
			buf3.Weld2Energy.Enable._0 				                :=   array_buffer[140].%X0;
			buf3.Weld2Energy.Enable._1 				                :=   array_buffer[140].%X1;
			buf3.Weld2Energy.Enable._2 				                :=   array_buffer[140].%X2;
			buf3.Weld2Energy.Enable._3 				                :=   array_buffer[140].%X3;
			buf3.Weld2Energy.Enable._4 				                :=   array_buffer[140].%X4;
			buf3.Weld2Energy.Enable._5 				                :=   array_buffer[140].%X5;
			buf3.Weld2Energy.Enable._6 				                :=   array_buffer[140].%X6;
			buf3.Weld2Energy.Enable._7 				                :=   array_buffer[140].%X7;
			buf3.Weld2Energy.Enable._8 				                :=   array_buffer[141].%X0;
			buf3.Weld2Energy.Enable._9 				                :=   array_buffer[141].%X1;
			buf3.Weld2Energy.Enable._10 				            :=   array_buffer[141].%X2;
			buf3.Weld2Energy.Enable._11 				            :=   array_buffer[141].%X3;
			buf3.Weld2Energy.Enable._12 				            :=   array_buffer[141].%X4;
			buf3.Weld2Energy.Enable._13 				            :=   array_buffer[141].%X5;
			buf3.Weld2Energy.Enable._14 				            :=   array_buffer[141].%X6;
			buf3.Weld2Energy.Enable._15 				            :=   array_buffer[141].%X7;
			buf3.Weld2Energy.Enable._16 				            :=   array_buffer[142].%X0;
			buf3.Weld2Energy.Enable._17 				            :=   array_buffer[142].%X1;
			buf3.Weld2Energy.Enable._18 				            :=   array_buffer[142].%X2;
			buf3.Weld2Energy.Enable._19 				            :=   array_buffer[142].%X3;
			buf3.Weld2Energy.Enable._20 				            :=   array_buffer[142].%X4;
			buf3.Weld2Energy.Enable._21 				            :=   array_buffer[142].%X5;
			buf3.Weld2Energy.Enable._22 				            :=   array_buffer[142].%X6;
			buf3.Weld2Energy.Enable._23 				            :=   array_buffer[142].%X7;
			buf3.Weld2Energy.Enable.LowerBad_1 		                :=   array_buffer[143].%X0;
			buf3.Weld2Energy.Enable.LowerSuspect_1 	                :=   array_buffer[143].%X1;
			buf3.Weld2Energy.Enable.UpperSuspect_1		            :=   array_buffer[143].%X2;
			buf3.Weld2Energy.Enable.UpperBad_1 		                :=   array_buffer[143].%X3;
			buf3.Weld2Energy.Enable.Display_1 			            :=   array_buffer[143].%X4;
			buf3.Weld2Energy.Enable._29 				            :=   array_buffer[143].%X5;
			buf3.Weld2Energy.Enable._30 				            :=   array_buffer[143].%X6;
			buf3.Weld2Energy.Enable._31 				            :=   array_buffer[143].%X7;
			buf3.Weld2Energy.LowerBad:=             TO_DINT(SHL(TO_DWORD(array_buffer[144]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[145]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[146]),  UINT#8) OR
																TO_DWORD(array_buffer[147])); 
			buf3.Weld2Energy.LowerSuspect:=         TO_DINT(SHL(TO_DWORD(array_buffer[148]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[149]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[150]),  UINT#8) OR
																TO_DWORD(array_buffer[151])); 
			buf3.Weld2Energy.UpperSuspect:=         TO_DINT(SHL(TO_DWORD(array_buffer[152]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[153]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[154]),  UINT#8) OR
																TO_DWORD(array_buffer[155])); 
			buf3.Weld2Energy.UpperBad:=             TO_DINT(SHL(TO_DWORD(array_buffer[156]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[157]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[158]),  UINT#8) OR
																TO_DWORD(array_buffer[159]));                                                                                             
			buf3.Weld2Power.Enable._0 				                :=   array_buffer[160].%X0;
			buf3.Weld2Power.Enable._1 				                :=   array_buffer[160].%X1;
			buf3.Weld2Power.Enable._2 				                :=   array_buffer[160].%X2;
			buf3.Weld2Power.Enable._3 				                :=   array_buffer[160].%X3;
			buf3.Weld2Power.Enable._4 				                :=   array_buffer[160].%X4;
			buf3.Weld2Power.Enable._5 				                :=   array_buffer[160].%X5;
			buf3.Weld2Power.Enable._6 				                :=   array_buffer[160].%X6;
			buf3.Weld2Power.Enable._7 				                :=   array_buffer[160].%X7;
			buf3.Weld2Power.Enable._8 				                :=   array_buffer[161].%X0;
			buf3.Weld2Power.Enable._9 				                :=   array_buffer[161].%X1;
			buf3.Weld2Power.Enable._10 				                :=   array_buffer[161].%X2;
			buf3.Weld2Power.Enable._11 				                :=   array_buffer[161].%X3;
			buf3.Weld2Power.Enable._12 				                :=   array_buffer[161].%X4;
			buf3.Weld2Power.Enable._13 				                :=   array_buffer[161].%X5;
			buf3.Weld2Power.Enable._14 				                :=   array_buffer[161].%X6;
			buf3.Weld2Power.Enable._15 				                :=   array_buffer[161].%X7;
			buf3.Weld2Power.Enable._16 				                :=   array_buffer[162].%X0;
			buf3.Weld2Power.Enable._17 				                :=   array_buffer[162].%X1;
			buf3.Weld2Power.Enable._18 				                :=   array_buffer[162].%X2;
			buf3.Weld2Power.Enable._19 				                :=   array_buffer[162].%X3;
			buf3.Weld2Power.Enable._20 				                :=   array_buffer[162].%X4;
			buf3.Weld2Power.Enable._21 				                :=   array_buffer[162].%X5;
			buf3.Weld2Power.Enable._22 				                :=   array_buffer[162].%X6;
			buf3.Weld2Power.Enable._23 				                :=   array_buffer[162].%X7;
			buf3.Weld2Power.Enable.LowerBad_1 		                :=   array_buffer[163].%X0;
			buf3.Weld2Power.Enable.LowerSuspect_1 	                :=   array_buffer[163].%X1;
			buf3.Weld2Power.Enable.UpperSuspect_1		            :=   array_buffer[163].%X2;
			buf3.Weld2Power.Enable.UpperBad_1 		                :=   array_buffer[163].%X3;
			buf3.Weld2Power.Enable.Display_1 			            :=   array_buffer[163].%X4;
			buf3.Weld2Power.Enable._29 				                :=   array_buffer[163].%X5;
			buf3.Weld2Power.Enable._30 				                :=   array_buffer[163].%X6;
			buf3.Weld2Power.Enable._31 				                :=   array_buffer[163].%X7;
			buf3.Weld2Power.LowerBad:=              TO_DINT(SHL(TO_DWORD(array_buffer[164]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[165]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[166]),  UINT#8) OR
																TO_DWORD(array_buffer[167])); 
			buf3.Weld2Power.LowerSuspect:=          TO_DINT(SHL(TO_DWORD(array_buffer[168]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[169]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[170]),  UINT#8) OR
																TO_DWORD(array_buffer[171])); 
			buf3.Weld2Power.UpperSuspect:=          TO_DINT(SHL(TO_DWORD(array_buffer[172]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[173]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[174]),  UINT#8) OR
																TO_DWORD(array_buffer[175])); 
			buf3.Weld2Power.UpperBad:=              TO_DINT(SHL(TO_DWORD(array_buffer[176]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[177]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[178]),  UINT#8) OR
																TO_DWORD(array_buffer[179]));                                                                                             
        END_METHOD

        METHOD PRIVATE ByteArray_TO_buf4 
            VAR_INPUT
                array_buffer : ARRAY[0..253] OF BYTE;
            END_VAR
            VAR_IN_OUT
                buf4 : Axo_IQ_SeriesWelder_data4_200bytes;
            END_VAR
			buf4.Weld2Distance.Enable._0 						    :=   array_buffer[  0].%X0;
			buf4.Weld2Distance.Enable._1 						    :=   array_buffer[  0].%X1;
			buf4.Weld2Distance.Enable._2 						    :=   array_buffer[  0].%X2;
			buf4.Weld2Distance.Enable._3 						    :=   array_buffer[  0].%X3;
			buf4.Weld2Distance.Enable._4 						    :=   array_buffer[  0].%X4;
			buf4.Weld2Distance.Enable._5 						    :=   array_buffer[  0].%X5;
			buf4.Weld2Distance.Enable._6 						    :=   array_buffer[  0].%X6;
			buf4.Weld2Distance.Enable._7 						    :=   array_buffer[  0].%X7;
			buf4.Weld2Distance.Enable._8 						    :=   array_buffer[  1].%X0;
			buf4.Weld2Distance.Enable._9 						    :=   array_buffer[  1].%X1;
			buf4.Weld2Distance.Enable._10 					        :=   array_buffer[  1].%X2;
			buf4.Weld2Distance.Enable._11 					        :=   array_buffer[  1].%X3;
			buf4.Weld2Distance.Enable._12 					        :=   array_buffer[  1].%X4;
			buf4.Weld2Distance.Enable._13 					        :=   array_buffer[  1].%X5;
			buf4.Weld2Distance.Enable._14 					        :=   array_buffer[  1].%X6;
			buf4.Weld2Distance.Enable._15 					        :=   array_buffer[  1].%X7;
			buf4.Weld2Distance.Enable._16 					        :=   array_buffer[  2].%X0;
			buf4.Weld2Distance.Enable._17 					        :=   array_buffer[  2].%X1;
			buf4.Weld2Distance.Enable._18 					        :=   array_buffer[  2].%X2;
			buf4.Weld2Distance.Enable._19 					        :=   array_buffer[  2].%X3;
			buf4.Weld2Distance.Enable._20 					        :=   array_buffer[  2].%X4;
			buf4.Weld2Distance.Enable._21 					        :=   array_buffer[  2].%X5;
			buf4.Weld2Distance.Enable._22 					        :=   array_buffer[  2].%X6;
			buf4.Weld2Distance.Enable._23 					        :=   array_buffer[  2].%X7;
			buf4.Weld2Distance.Enable.LowerBad_1 				    :=   array_buffer[  3].%X0;
			buf4.Weld2Distance.Enable.LowerSuspect_1 			    :=   array_buffer[  3].%X1;
			buf4.Weld2Distance.Enable.UpperSuspect_1			    :=   array_buffer[  3].%X2;
			buf4.Weld2Distance.Enable.UpperBad_1 				    :=   array_buffer[  3].%X3;
			buf4.Weld2Distance.Enable.Display_1 				    :=   array_buffer[  3].%X4;
			buf4.Weld2Distance.Enable._29 					        :=   array_buffer[  3].%X5;
			buf4.Weld2Distance.Enable._30 					        :=   array_buffer[  3].%X6;
			buf4.Weld2Distance.Enable._31 					        :=   array_buffer[  3].%X7;
			buf4.Weld2Distance.LowerBad:=           TO_DINT(SHL(TO_DWORD(array_buffer[  4]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[  5]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[  6]),  UINT#8) OR
																TO_DWORD(array_buffer[  7])); 
			buf4.Weld2Distance.LowerSuspect:=       TO_DINT(SHL(TO_DWORD(array_buffer[  8]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[  9]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[ 10]),  UINT#8) OR
																TO_DWORD(array_buffer[ 11])); 
			buf4.Weld2Distance.UpperSuspect:=       TO_DINT(SHL(TO_DWORD(array_buffer[ 12]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[ 13]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[ 14]),  UINT#8) OR
																TO_DWORD(array_buffer[ 15])); 
			buf4.Weld2Distance.UpperBad:=           TO_DINT(SHL(TO_DWORD(array_buffer[ 16]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[ 17]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[ 18]),  UINT#8) OR
																TO_DWORD(array_buffer[ 19])); 
			buf4.Weld2Position.Enable._0 					        :=   array_buffer[ 20].%X0;
			buf4.Weld2Position.Enable._1 					        :=   array_buffer[ 20].%X1;
			buf4.Weld2Position.Enable._2 					        :=   array_buffer[ 20].%X2;
			buf4.Weld2Position.Enable._3 					        :=   array_buffer[ 20].%X3;
			buf4.Weld2Position.Enable._4 					        :=   array_buffer[ 20].%X4;
			buf4.Weld2Position.Enable._5 					        :=   array_buffer[ 20].%X5;
			buf4.Weld2Position.Enable._6 					        :=   array_buffer[ 20].%X6;
			buf4.Weld2Position.Enable._7 					        :=   array_buffer[ 20].%X7;
			buf4.Weld2Position.Enable._8 					        :=   array_buffer[ 21].%X0;
			buf4.Weld2Position.Enable._9 					        :=   array_buffer[ 21].%X1;
			buf4.Weld2Position.Enable._10 				            :=   array_buffer[ 21].%X2;
			buf4.Weld2Position.Enable._11 				            :=   array_buffer[ 21].%X3;
			buf4.Weld2Position.Enable._12 				            :=   array_buffer[ 21].%X4;
			buf4.Weld2Position.Enable._13 				            :=   array_buffer[ 21].%X5;
			buf4.Weld2Position.Enable._14 				            :=   array_buffer[ 21].%X6;
			buf4.Weld2Position.Enable._15 				            :=   array_buffer[ 21].%X7;
			buf4.Weld2Position.Enable._16 				            :=   array_buffer[ 22].%X0;
			buf4.Weld2Position.Enable._17 				            :=   array_buffer[ 22].%X1;
			buf4.Weld2Position.Enable._18 				            :=   array_buffer[ 22].%X2;
			buf4.Weld2Position.Enable._19 				            :=   array_buffer[ 22].%X3;
			buf4.Weld2Position.Enable._20 				            :=   array_buffer[ 22].%X4;
			buf4.Weld2Position.Enable._21 				            :=   array_buffer[ 22].%X5;
			buf4.Weld2Position.Enable._22 				            :=   array_buffer[ 22].%X6;
			buf4.Weld2Position.Enable._23 				            :=   array_buffer[ 22].%X7;
			buf4.Weld2Position.Enable.LowerBad_1 			        :=   array_buffer[ 23].%X0;
			buf4.Weld2Position.Enable.LowerSuspect_1 		        :=   array_buffer[ 23].%X1;
			buf4.Weld2Position.Enable.UpperSuspect_1		        :=   array_buffer[ 23].%X2;
			buf4.Weld2Position.Enable.UpperBad_1 				    :=   array_buffer[ 23].%X3;
			buf4.Weld2Position.Enable.Display_1 				    :=   array_buffer[ 23].%X4;
			buf4.Weld2Position.Enable._29 					        :=   array_buffer[ 23].%X5;
			buf4.Weld2Position.Enable._30 					        :=   array_buffer[ 23].%X6;
			buf4.Weld2Position.Enable._31 					        :=   array_buffer[ 23].%X7;
			buf4.Weld2Position.LowerBad:=           TO_DINT(SHL(TO_DWORD(array_buffer[ 24]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[ 25]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[ 26]),  UINT#8) OR
																TO_DWORD(array_buffer[ 27])); 
			buf4.Weld2Position.LowerSuspect:=       TO_DINT(SHL(TO_DWORD(array_buffer[ 28]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[ 29]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[ 30]),  UINT#8) OR
																TO_DWORD(array_buffer[ 31])); 
			buf4.Weld2Position.UpperSuspect:=       TO_DINT(SHL(TO_DWORD(array_buffer[ 32]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[ 33]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[ 34]),  UINT#8) OR
																TO_DWORD(array_buffer[ 35])); 
			buf4.Weld2Position.UpperBad:=           TO_DINT(SHL(TO_DWORD(array_buffer[ 36]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[ 37]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[ 38]),  UINT#8) OR
																TO_DWORD(array_buffer[ 39])); 
			buf4.TotalWeldTime.Enable._0 					        :=   array_buffer[ 40].%X0;
			buf4.TotalWeldTime.Enable._1 					        :=   array_buffer[ 40].%X1;
			buf4.TotalWeldTime.Enable._2 					        :=   array_buffer[ 40].%X2;
			buf4.TotalWeldTime.Enable._3 					        :=   array_buffer[ 40].%X3;
			buf4.TotalWeldTime.Enable._4 					        :=   array_buffer[ 40].%X4;
			buf4.TotalWeldTime.Enable._5 					        :=   array_buffer[ 40].%X5;
			buf4.TotalWeldTime.Enable._6 					        :=   array_buffer[ 40].%X6;
			buf4.TotalWeldTime.Enable._7 					        :=   array_buffer[ 40].%X7;
			buf4.TotalWeldTime.Enable._8 					        :=   array_buffer[ 41].%X0;
			buf4.TotalWeldTime.Enable._9 					        :=   array_buffer[ 41].%X1;
			buf4.TotalWeldTime.Enable._10 				            :=   array_buffer[ 41].%X2;
			buf4.TotalWeldTime.Enable._11 				            :=   array_buffer[ 41].%X3;
			buf4.TotalWeldTime.Enable._12 				            :=   array_buffer[ 41].%X4;
			buf4.TotalWeldTime.Enable._13 				            :=   array_buffer[ 41].%X5;
			buf4.TotalWeldTime.Enable._14 				            :=   array_buffer[ 41].%X6;
			buf4.TotalWeldTime.Enable._15 				            :=   array_buffer[ 41].%X7;
			buf4.TotalWeldTime.Enable._16 				            :=   array_buffer[ 42].%X0;
			buf4.TotalWeldTime.Enable._17 				            :=   array_buffer[ 42].%X1;
			buf4.TotalWeldTime.Enable._18 				            :=   array_buffer[ 42].%X2;
			buf4.TotalWeldTime.Enable._19 				            :=   array_buffer[ 42].%X3;
			buf4.TotalWeldTime.Enable._20 				            :=   array_buffer[ 42].%X4;
			buf4.TotalWeldTime.Enable._21 				            :=   array_buffer[ 42].%X5;
			buf4.TotalWeldTime.Enable._22 				            :=   array_buffer[ 42].%X6;
			buf4.TotalWeldTime.Enable._23 				            :=   array_buffer[ 42].%X7;
			buf4.TotalWeldTime.Enable.LowerBad_1 			        :=   array_buffer[ 43].%X0;
			buf4.TotalWeldTime.Enable.LowerSuspect_1 		        :=   array_buffer[ 43].%X1;
			buf4.TotalWeldTime.Enable.UpperSuspect_1		        :=   array_buffer[ 43].%X2;
			buf4.TotalWeldTime.Enable.UpperBad_1 			        :=   array_buffer[ 43].%X3;
			buf4.TotalWeldTime.Enable.Display_1 				    :=   array_buffer[ 43].%X4;
			buf4.TotalWeldTime.Enable._29 					        :=   array_buffer[ 43].%X5;
			buf4.TotalWeldTime.Enable._30 					        :=   array_buffer[ 43].%X6;
			buf4.TotalWeldTime.Enable._31 					        :=   array_buffer[ 43].%X7;
			buf4.TotalWeldTime.LowerBad:=           TO_DINT(SHL(TO_DWORD(array_buffer[ 44]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[ 45]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[ 46]),  UINT#8) OR
																TO_DWORD(array_buffer[ 47])); 
			buf4.TotalWeldTime.LowerSuspect:=       TO_DINT(SHL(TO_DWORD(array_buffer[ 48]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[ 49]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[ 50]),  UINT#8) OR
																TO_DWORD(array_buffer[ 51])); 
			buf4.TotalWeldTime.UpperSuspect:=       TO_DINT(SHL(TO_DWORD(array_buffer[ 52]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[ 53]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[ 54]),  UINT#8) OR
																TO_DWORD(array_buffer[ 55])); 
			buf4.TotalWeldTime.UpperBad:=           TO_DINT(SHL(TO_DWORD(array_buffer[ 56]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[ 57]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[ 58]),  UINT#8) OR
																TO_DWORD(array_buffer[ 59]));                                                                                             
			buf4.TotalWeldEnergy.Enable._0 				            :=   array_buffer[ 60].%X0;
			buf4.TotalWeldEnergy.Enable._1 				            :=   array_buffer[ 60].%X1;
			buf4.TotalWeldEnergy.Enable._2 				            :=   array_buffer[ 60].%X2;
			buf4.TotalWeldEnergy.Enable._3 				            :=   array_buffer[ 60].%X3;
			buf4.TotalWeldEnergy.Enable._4 				            :=   array_buffer[ 60].%X4;
			buf4.TotalWeldEnergy.Enable._5 				            :=   array_buffer[ 60].%X5;
			buf4.TotalWeldEnergy.Enable._6 				            :=   array_buffer[ 60].%X6;
			buf4.TotalWeldEnergy.Enable._7 				            :=   array_buffer[ 60].%X7;
			buf4.TotalWeldEnergy.Enable._8 				            :=   array_buffer[ 61].%X0;
			buf4.TotalWeldEnergy.Enable._9 				            :=   array_buffer[ 61].%X1;
			buf4.TotalWeldEnergy.Enable._10 				        :=   array_buffer[ 61].%X2;
			buf4.TotalWeldEnergy.Enable._11 				        :=   array_buffer[ 61].%X3;
			buf4.TotalWeldEnergy.Enable._12 				        :=   array_buffer[ 61].%X4;
			buf4.TotalWeldEnergy.Enable._13 				        :=   array_buffer[ 61].%X5;
			buf4.TotalWeldEnergy.Enable._14 				        :=   array_buffer[ 61].%X6;
			buf4.TotalWeldEnergy.Enable._15 				        :=   array_buffer[ 61].%X7;
			buf4.TotalWeldEnergy.Enable._16 				        :=   array_buffer[ 62].%X0;
			buf4.TotalWeldEnergy.Enable._17 				        :=   array_buffer[ 62].%X1;
			buf4.TotalWeldEnergy.Enable._18 				        :=   array_buffer[ 62].%X2;
			buf4.TotalWeldEnergy.Enable._19 				        :=   array_buffer[ 62].%X3;
			buf4.TotalWeldEnergy.Enable._20 				        :=   array_buffer[ 62].%X4;
			buf4.TotalWeldEnergy.Enable._21 				        :=   array_buffer[ 62].%X5;
			buf4.TotalWeldEnergy.Enable._22 				        :=   array_buffer[ 62].%X6;
			buf4.TotalWeldEnergy.Enable._23 				        :=   array_buffer[ 62].%X7;
			buf4.TotalWeldEnergy.Enable.LowerBad_1 		            :=   array_buffer[ 63].%X0;
			buf4.TotalWeldEnergy.Enable.LowerSuspect_1 	            :=   array_buffer[ 63].%X1;
			buf4.TotalWeldEnergy.Enable.UpperSuspect_1		        :=   array_buffer[ 63].%X2;
			buf4.TotalWeldEnergy.Enable.UpperBad_1 		            :=   array_buffer[ 63].%X3;
			buf4.TotalWeldEnergy.Enable.Display_1 			        :=   array_buffer[ 63].%X4;
			buf4.TotalWeldEnergy.Enable._29 				        :=   array_buffer[ 63].%X5;
			buf4.TotalWeldEnergy.Enable._30 				        :=   array_buffer[ 63].%X6;
			buf4.TotalWeldEnergy.Enable._31 				        :=   array_buffer[ 63].%X7;
			buf4.TotalWeldEnergy.LowerBad:=         TO_DINT(SHL(TO_DWORD(array_buffer[ 64]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[ 65]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[ 66]),  UINT#8) OR
																TO_DWORD(array_buffer[ 67])); 
			buf4.TotalWeldEnergy.LowerSuspect:=     TO_DINT(SHL(TO_DWORD(array_buffer[ 68]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[ 69]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[ 70]),  UINT#8) OR
																TO_DWORD(array_buffer[ 71])); 
			buf4.TotalWeldEnergy.UpperSuspect:=     TO_DINT(SHL(TO_DWORD(array_buffer[ 72]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[ 73]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[ 74]),  UINT#8) OR
																TO_DWORD(array_buffer[ 75])); 
			buf4.TotalWeldEnergy.UpperBad:=         TO_DINT(SHL(TO_DWORD(array_buffer[ 76]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[ 77]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[ 78]),  UINT#8) OR
																TO_DWORD(array_buffer[ 79]));                                                                                             
			buf4.TotalWeldDistance.Enable._0 				        :=   array_buffer[ 80].%X0;
			buf4.TotalWeldDistance.Enable._1 				        :=   array_buffer[ 80].%X1;
			buf4.TotalWeldDistance.Enable._2 				        :=   array_buffer[ 80].%X2;
			buf4.TotalWeldDistance.Enable._3 				        :=   array_buffer[ 80].%X3;
			buf4.TotalWeldDistance.Enable._4 				        :=   array_buffer[ 80].%X4;
			buf4.TotalWeldDistance.Enable._5 				        :=   array_buffer[ 80].%X5;
			buf4.TotalWeldDistance.Enable._6 				        :=   array_buffer[ 80].%X6;
			buf4.TotalWeldDistance.Enable._7 				        :=   array_buffer[ 80].%X7;
			buf4.TotalWeldDistance.Enable._8 				        :=   array_buffer[ 81].%X0;
			buf4.TotalWeldDistance.Enable._9 				        :=   array_buffer[ 81].%X1;
			buf4.TotalWeldDistance.Enable._10 				        :=   array_buffer[ 81].%X2;
			buf4.TotalWeldDistance.Enable._11 				        :=   array_buffer[ 81].%X3;
			buf4.TotalWeldDistance.Enable._12 				        :=   array_buffer[ 81].%X4;
			buf4.TotalWeldDistance.Enable._13 				        :=   array_buffer[ 81].%X5;
			buf4.TotalWeldDistance.Enable._14 				        :=   array_buffer[ 81].%X6;
			buf4.TotalWeldDistance.Enable._15 				        :=   array_buffer[ 81].%X7;
			buf4.TotalWeldDistance.Enable._16 				        :=   array_buffer[ 82].%X0;
			buf4.TotalWeldDistance.Enable._17 				        :=   array_buffer[ 82].%X1;
			buf4.TotalWeldDistance.Enable._18 				        :=   array_buffer[ 82].%X2;
			buf4.TotalWeldDistance.Enable._19 				        :=   array_buffer[ 82].%X3;
			buf4.TotalWeldDistance.Enable._20 				        :=   array_buffer[ 82].%X4;
			buf4.TotalWeldDistance.Enable._21 				        :=   array_buffer[ 82].%X5;
			buf4.TotalWeldDistance.Enable._22 				        :=   array_buffer[ 82].%X6;
			buf4.TotalWeldDistance.Enable._23 				        :=   array_buffer[ 82].%X7;
			buf4.TotalWeldDistance.Enable.LowerBad_1 		        :=   array_buffer[ 83].%X0;
			buf4.TotalWeldDistance.Enable.LowerSuspect_1 	        :=   array_buffer[ 83].%X1;
			buf4.TotalWeldDistance.Enable.UpperSuspect_1		    :=   array_buffer[ 83].%X2;
			buf4.TotalWeldDistance.Enable.UpperBad_1 		        :=   array_buffer[ 83].%X3;
			buf4.TotalWeldDistance.Enable.Display_1 			    :=   array_buffer[ 83].%X4;
			buf4.TotalWeldDistance.Enable._29 				        :=   array_buffer[ 83].%X5;
			buf4.TotalWeldDistance.Enable._30 				        :=   array_buffer[ 83].%X6;
			buf4.TotalWeldDistance.Enable._31 				        :=   array_buffer[ 83].%X7;
			buf4.TotalWeldDistance.LowerBad:=       TO_DINT(SHL(TO_DWORD(array_buffer[ 84]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[ 85]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[ 86]),  UINT#8) OR
																TO_DWORD(array_buffer[ 87])); 
			buf4.TotalWeldDistance.LowerSuspect:=   TO_DINT(SHL(TO_DWORD(array_buffer[ 88]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[ 89]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[ 90]),  UINT#8) OR
																TO_DWORD(array_buffer[ 91])); 
			buf4.TotalWeldDistance.UpperSuspect:=   TO_DINT(SHL(TO_DWORD(array_buffer[ 92]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[ 93]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[ 94]),  UINT#8) OR
																TO_DWORD(array_buffer[ 95])); 
			buf4.TotalWeldDistance.UpperBad:=       TO_DINT(SHL(TO_DWORD(array_buffer[ 96]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[ 97]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[ 98]),  UINT#8) OR
																TO_DWORD(array_buffer[ 99]));                                                                                             
			buf4.DynamicHoldTime.Enable._0 				            :=   array_buffer[100].%X0;
			buf4.DynamicHoldTime.Enable._1 				            :=   array_buffer[100].%X1;
			buf4.DynamicHoldTime.Enable._2 				            :=   array_buffer[100].%X2;
			buf4.DynamicHoldTime.Enable._3 				            :=   array_buffer[100].%X3;
			buf4.DynamicHoldTime.Enable._4 				            :=   array_buffer[100].%X4;
			buf4.DynamicHoldTime.Enable._5 				            :=   array_buffer[100].%X5;
			buf4.DynamicHoldTime.Enable._6 				            :=   array_buffer[100].%X6;
			buf4.DynamicHoldTime.Enable._7 				            :=   array_buffer[100].%X7;
			buf4.DynamicHoldTime.Enable._8 				            :=   array_buffer[101].%X0;
			buf4.DynamicHoldTime.Enable._9 				            :=   array_buffer[101].%X1;
			buf4.DynamicHoldTime.Enable._10 				        :=   array_buffer[101].%X2;
			buf4.DynamicHoldTime.Enable._11 				        :=   array_buffer[101].%X3;
			buf4.DynamicHoldTime.Enable._12 				        :=   array_buffer[101].%X4;
			buf4.DynamicHoldTime.Enable._13 				        :=   array_buffer[101].%X5;
			buf4.DynamicHoldTime.Enable._14 				        :=   array_buffer[101].%X6;
			buf4.DynamicHoldTime.Enable._15 				        :=   array_buffer[101].%X7;
			buf4.DynamicHoldTime.Enable._16 				        :=   array_buffer[102].%X0;
			buf4.DynamicHoldTime.Enable._17 				        :=   array_buffer[102].%X1;
			buf4.DynamicHoldTime.Enable._18 				        :=   array_buffer[102].%X2;
			buf4.DynamicHoldTime.Enable._19 				        :=   array_buffer[102].%X3;
			buf4.DynamicHoldTime.Enable._20 				        :=   array_buffer[102].%X4;
			buf4.DynamicHoldTime.Enable._21 				        :=   array_buffer[102].%X5;
			buf4.DynamicHoldTime.Enable._22 				        :=   array_buffer[102].%X6;
			buf4.DynamicHoldTime.Enable._23 				        :=   array_buffer[102].%X7;
			buf4.DynamicHoldTime.Enable.LowerBad_1 		            :=   array_buffer[103].%X0;
			buf4.DynamicHoldTime.Enable.LowerSuspect_1 	            :=   array_buffer[103].%X1;
			buf4.DynamicHoldTime.Enable.UpperSuspect_1		        :=   array_buffer[103].%X2;
			buf4.DynamicHoldTime.Enable.UpperBad_1 		            :=   array_buffer[103].%X3;
			buf4.DynamicHoldTime.Enable.Display_1 			        :=   array_buffer[103].%X4;
			buf4.DynamicHoldTime.Enable._29 				        :=   array_buffer[103].%X5;
			buf4.DynamicHoldTime.Enable._30 				        :=   array_buffer[103].%X6;
			buf4.DynamicHoldTime.Enable._31 				        :=   array_buffer[103].%X7;
			buf4.DynamicHoldTime.LowerBad:=         TO_DINT(SHL(TO_DWORD(array_buffer[104]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[105]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[106]),  UINT#8) OR
																TO_DWORD(array_buffer[107])); 
			buf4.DynamicHoldTime.LowerSuspect:=     TO_DINT(SHL(TO_DWORD(array_buffer[108]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[109]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[110]),  UINT#8) OR
																TO_DWORD(array_buffer[111])); 
			buf4.DynamicHoldTime.UpperSuspect:=     TO_DINT(SHL(TO_DWORD(array_buffer[112]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[113]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[114]),  UINT#8) OR
																TO_DWORD(array_buffer[115])); 
			buf4.DynamicHoldTime.UpperBad:=         TO_DINT(SHL(TO_DWORD(array_buffer[116]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[117]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[118]),  UINT#8) OR
																TO_DWORD(array_buffer[119]));                                                                                             
			buf4.DynamicHoldDistance.Enable._0 				        :=   array_buffer[120].%X0;
			buf4.DynamicHoldDistance.Enable._1 				        :=   array_buffer[120].%X1;
			buf4.DynamicHoldDistance.Enable._2 				        :=   array_buffer[120].%X2;
			buf4.DynamicHoldDistance.Enable._3 				        :=   array_buffer[120].%X3;
			buf4.DynamicHoldDistance.Enable._4 				        :=   array_buffer[120].%X4;
			buf4.DynamicHoldDistance.Enable._5 				        :=   array_buffer[120].%X5;
			buf4.DynamicHoldDistance.Enable._6 				        :=   array_buffer[120].%X6;
			buf4.DynamicHoldDistance.Enable._7 				        :=   array_buffer[120].%X7;
			buf4.DynamicHoldDistance.Enable._8 				        :=   array_buffer[121].%X0;
			buf4.DynamicHoldDistance.Enable._9 				        :=   array_buffer[121].%X1;
			buf4.DynamicHoldDistance.Enable._10 				    :=   array_buffer[121].%X2;
			buf4.DynamicHoldDistance.Enable._11 				    :=   array_buffer[121].%X3;
			buf4.DynamicHoldDistance.Enable._12 				    :=   array_buffer[121].%X4;
			buf4.DynamicHoldDistance.Enable._13 				    :=   array_buffer[121].%X5;
			buf4.DynamicHoldDistance.Enable._14 				    :=   array_buffer[121].%X6;
			buf4.DynamicHoldDistance.Enable._15 				    :=   array_buffer[121].%X7;
			buf4.DynamicHoldDistance.Enable._16 				    :=   array_buffer[122].%X0;
			buf4.DynamicHoldDistance.Enable._17 				    :=   array_buffer[122].%X1;
			buf4.DynamicHoldDistance.Enable._18 				    :=   array_buffer[122].%X2;
			buf4.DynamicHoldDistance.Enable._19 				    :=   array_buffer[122].%X3;
			buf4.DynamicHoldDistance.Enable._20 				    :=   array_buffer[122].%X4;
			buf4.DynamicHoldDistance.Enable._21 				    :=   array_buffer[122].%X5;
			buf4.DynamicHoldDistance.Enable._22 				    :=   array_buffer[122].%X6;
			buf4.DynamicHoldDistance.Enable._23 				    :=   array_buffer[122].%X7;
			buf4.DynamicHoldDistance.Enable.LowerBad_1 		        :=   array_buffer[123].%X0;
			buf4.DynamicHoldDistance.Enable.LowerSuspect_1 	        :=   array_buffer[123].%X1;
			buf4.DynamicHoldDistance.Enable.UpperSuspect_1		    :=   array_buffer[123].%X2;
			buf4.DynamicHoldDistance.Enable.UpperBad_1 		        :=   array_buffer[123].%X3;
			buf4.DynamicHoldDistance.Enable.Display_1 			    :=   array_buffer[123].%X4;
			buf4.DynamicHoldDistance.Enable._29 				    :=   array_buffer[123].%X5;
			buf4.DynamicHoldDistance.Enable._30 				    :=   array_buffer[123].%X6;
			buf4.DynamicHoldDistance.Enable._31 				    :=   array_buffer[123].%X7;
			buf4.DynamicHoldDistance.LowerBad:=     TO_DINT(SHL(TO_DWORD(array_buffer[124]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[125]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[126]),  UINT#8) OR
																TO_DWORD(array_buffer[127])); 
			buf4.DynamicHoldDistance.LowerSuspect:= TO_DINT(SHL(TO_DWORD(array_buffer[128]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[129]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[130]),  UINT#8) OR
																TO_DWORD(array_buffer[131])); 
			buf4.DynamicHoldDistance.UpperSuspect:= TO_DINT(SHL(TO_DWORD(array_buffer[132]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[133]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[134]),  UINT#8) OR
																TO_DWORD(array_buffer[135])); 
			buf4.DynamicHoldDistance.UpperBad:=     TO_DINT(SHL(TO_DWORD(array_buffer[136]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[137]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[138]),  UINT#8) OR
																TO_DWORD(array_buffer[139]));                                                                                             
			buf4.TotalCycleTime.Enable._0 				            :=   array_buffer[140].%X0;
			buf4.TotalCycleTime.Enable._1 				            :=   array_buffer[140].%X1;
			buf4.TotalCycleTime.Enable._2 				            :=   array_buffer[140].%X2;
			buf4.TotalCycleTime.Enable._3 				            :=   array_buffer[140].%X3;
			buf4.TotalCycleTime.Enable._4 				            :=   array_buffer[140].%X4;
			buf4.TotalCycleTime.Enable._5 				            :=   array_buffer[140].%X5;
			buf4.TotalCycleTime.Enable._6 				            :=   array_buffer[140].%X6;
			buf4.TotalCycleTime.Enable._7 				            :=   array_buffer[140].%X7;
			buf4.TotalCycleTime.Enable._8 				            :=   array_buffer[141].%X0;
			buf4.TotalCycleTime.Enable._9 				            :=   array_buffer[141].%X1;
			buf4.TotalCycleTime.Enable._10 				            :=   array_buffer[141].%X2;
			buf4.TotalCycleTime.Enable._11 				            :=   array_buffer[141].%X3;
			buf4.TotalCycleTime.Enable._12 				            :=   array_buffer[141].%X4;
			buf4.TotalCycleTime.Enable._13 				            :=   array_buffer[141].%X5;
			buf4.TotalCycleTime.Enable._14 				            :=   array_buffer[141].%X6;
			buf4.TotalCycleTime.Enable._15 				            :=   array_buffer[141].%X7;
			buf4.TotalCycleTime.Enable._16 				            :=   array_buffer[142].%X0;
			buf4.TotalCycleTime.Enable._17 				            :=   array_buffer[142].%X1;
			buf4.TotalCycleTime.Enable._18 				            :=   array_buffer[142].%X2;
			buf4.TotalCycleTime.Enable._19 				            :=   array_buffer[142].%X3;
			buf4.TotalCycleTime.Enable._20 				            :=   array_buffer[142].%X4;
			buf4.TotalCycleTime.Enable._21 				            :=   array_buffer[142].%X5;
			buf4.TotalCycleTime.Enable._22 				            :=   array_buffer[142].%X6;
			buf4.TotalCycleTime.Enable._23 				            :=   array_buffer[142].%X7;
			buf4.TotalCycleTime.Enable.LowerBad_1 		            :=   array_buffer[143].%X0;
			buf4.TotalCycleTime.Enable.LowerSuspect_1 	            :=   array_buffer[143].%X1;
			buf4.TotalCycleTime.Enable.UpperSuspect_1		        :=   array_buffer[143].%X2;
			buf4.TotalCycleTime.Enable.UpperBad_1 		            :=   array_buffer[143].%X3;
			buf4.TotalCycleTime.Enable.Display_1 			        :=   array_buffer[143].%X4;
			buf4.TotalCycleTime.Enable._29 				            :=   array_buffer[143].%X5;
			buf4.TotalCycleTime.Enable._30 				            :=   array_buffer[143].%X6;
			buf4.TotalCycleTime.Enable._31 				            :=   array_buffer[143].%X7;
			buf4.TotalCycleTime.LowerBad:=          TO_DINT(SHL(TO_DWORD(array_buffer[144]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[145]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[146]),  UINT#8) OR
																TO_DWORD(array_buffer[147])); 
			buf4.TotalCycleTime.LowerSuspect:=      TO_DINT(SHL(TO_DWORD(array_buffer[148]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[149]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[150]),  UINT#8) OR
																TO_DWORD(array_buffer[151])); 
			buf4.TotalCycleTime.UpperSuspect:=      TO_DINT(SHL(TO_DWORD(array_buffer[152]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[153]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[154]),  UINT#8) OR
																TO_DWORD(array_buffer[155])); 
			buf4.TotalCycleTime.UpperBad:=          TO_DINT(SHL(TO_DWORD(array_buffer[156]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[157]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[158]),  UINT#8) OR
																TO_DWORD(array_buffer[159]));                                                                                             
			buf4.FinalHoldPosition.Enable._0 				        :=   array_buffer[160].%X0;
			buf4.FinalHoldPosition.Enable._1 				        :=   array_buffer[160].%X1;
			buf4.FinalHoldPosition.Enable._2 				        :=   array_buffer[160].%X2;
			buf4.FinalHoldPosition.Enable._3 				        :=   array_buffer[160].%X3;
			buf4.FinalHoldPosition.Enable._4 				        :=   array_buffer[160].%X4;
			buf4.FinalHoldPosition.Enable._5 				        :=   array_buffer[160].%X5;
			buf4.FinalHoldPosition.Enable._6 				        :=   array_buffer[160].%X6;
			buf4.FinalHoldPosition.Enable._7 				        :=   array_buffer[160].%X7;
			buf4.FinalHoldPosition.Enable._8 				        :=   array_buffer[161].%X0;
			buf4.FinalHoldPosition.Enable._9 				        :=   array_buffer[161].%X1;
			buf4.FinalHoldPosition.Enable._10 				        :=   array_buffer[161].%X2;
			buf4.FinalHoldPosition.Enable._11 				        :=   array_buffer[161].%X3;
			buf4.FinalHoldPosition.Enable._12 				        :=   array_buffer[161].%X4;
			buf4.FinalHoldPosition.Enable._13 				        :=   array_buffer[161].%X5;
			buf4.FinalHoldPosition.Enable._14 				        :=   array_buffer[161].%X6;
			buf4.FinalHoldPosition.Enable._15 				        :=   array_buffer[161].%X7;
			buf4.FinalHoldPosition.Enable._16 				        :=   array_buffer[162].%X0;
			buf4.FinalHoldPosition.Enable._17 				        :=   array_buffer[162].%X1;
			buf4.FinalHoldPosition.Enable._18 				        :=   array_buffer[162].%X2;
			buf4.FinalHoldPosition.Enable._19 				        :=   array_buffer[162].%X3;
			buf4.FinalHoldPosition.Enable._20 				        :=   array_buffer[162].%X4;
			buf4.FinalHoldPosition.Enable._21 				        :=   array_buffer[162].%X5;
			buf4.FinalHoldPosition.Enable._22 				        :=   array_buffer[162].%X6;
			buf4.FinalHoldPosition.Enable._23 				        :=   array_buffer[162].%X7;
			buf4.FinalHoldPosition.Enable.LowerBad_1 		        :=   array_buffer[163].%X0;
			buf4.FinalHoldPosition.Enable.LowerSuspect_1 	        :=   array_buffer[163].%X1;
			buf4.FinalHoldPosition.Enable.UpperSuspect_1		    :=   array_buffer[163].%X2;
			buf4.FinalHoldPosition.Enable.UpperBad_1 		        :=   array_buffer[163].%X3;
			buf4.FinalHoldPosition.Enable.Display_1 			    :=   array_buffer[163].%X4;
			buf4.FinalHoldPosition.Enable._29 				        :=   array_buffer[163].%X5;
			buf4.FinalHoldPosition.Enable._30 				        :=   array_buffer[163].%X6;
			buf4.FinalHoldPosition.Enable._31 				        :=   array_buffer[163].%X7;
			buf4.FinalHoldPosition.LowerBad:=       TO_DINT(SHL(TO_DWORD(array_buffer[164]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[165]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[166]),  UINT#8) OR
																TO_DWORD(array_buffer[167])); 
			buf4.FinalHoldPosition.LowerSuspect:=   TO_DINT(SHL(TO_DWORD(array_buffer[168]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[169]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[170]),  UINT#8) OR
																TO_DWORD(array_buffer[171])); 
			buf4.FinalHoldPosition.UpperSuspect:=   TO_DINT(SHL(TO_DWORD(array_buffer[172]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[173]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[174]),  UINT#8) OR
																TO_DWORD(array_buffer[175])); 
			buf4.FinalHoldPosition.UpperBad:=       TO_DINT(SHL(TO_DWORD(array_buffer[176]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[177]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[178]),  UINT#8) OR
																TO_DWORD(array_buffer[179]));                                                                                             
			buf4.ErrorStatus.Enable._0 				                :=   array_buffer[180].%X0;
			buf4.ErrorStatus.Enable._1 				                :=   array_buffer[180].%X1;
			buf4.ErrorStatus.Enable._2 				                :=   array_buffer[180].%X2;
			buf4.ErrorStatus.Enable._3 				                :=   array_buffer[180].%X3;
			buf4.ErrorStatus.Enable._4 				                :=   array_buffer[180].%X4;
			buf4.ErrorStatus.Enable._5 				                :=   array_buffer[180].%X5;
			buf4.ErrorStatus.Enable._6 				                :=   array_buffer[180].%X6;
			buf4.ErrorStatus.Enable._7 				                :=   array_buffer[180].%X7;
			buf4.ErrorStatus.Enable._8 				                :=   array_buffer[181].%X0;
			buf4.ErrorStatus.Enable._9 				                :=   array_buffer[181].%X1;
			buf4.ErrorStatus.Enable._10 				            :=   array_buffer[181].%X2;
			buf4.ErrorStatus.Enable._11 				            :=   array_buffer[181].%X3;
			buf4.ErrorStatus.Enable._12 				            :=   array_buffer[181].%X4;
			buf4.ErrorStatus.Enable._13 				            :=   array_buffer[181].%X5;
			buf4.ErrorStatus.Enable._14 				            :=   array_buffer[181].%X6;
			buf4.ErrorStatus.Enable._15 				            :=   array_buffer[181].%X7;
			buf4.ErrorStatus.Enable._16 				            :=   array_buffer[182].%X0;
			buf4.ErrorStatus.Enable._17 				            :=   array_buffer[182].%X1;
			buf4.ErrorStatus.Enable._18 				            :=   array_buffer[182].%X2;
			buf4.ErrorStatus.Enable._19 				            :=   array_buffer[182].%X3;
			buf4.ErrorStatus.Enable._20 				            :=   array_buffer[182].%X4;
			buf4.ErrorStatus.Enable._21 				            :=   array_buffer[182].%X5;
			buf4.ErrorStatus.Enable._22 				            :=   array_buffer[182].%X6;
			buf4.ErrorStatus.Enable._23 				            :=   array_buffer[182].%X7;
			buf4.ErrorStatus.Enable.LowerBad_1 		                :=   array_buffer[183].%X0;
			buf4.ErrorStatus.Enable.LowerSuspect_1 	                :=   array_buffer[183].%X1;
			buf4.ErrorStatus.Enable.UpperSuspect_1		            :=   array_buffer[183].%X2;
			buf4.ErrorStatus.Enable.UpperBad_1 		                :=   array_buffer[183].%X3;
			buf4.ErrorStatus.Enable.Display_1 			            :=   array_buffer[183].%X4;
			buf4.ErrorStatus.Enable._29 				            :=   array_buffer[183].%X5;
			buf4.ErrorStatus.Enable._30 				            :=   array_buffer[183].%X6;
			buf4.ErrorStatus.Enable._31 				            :=   array_buffer[183].%X7;
			buf4.ErrorStatus.LowerBad:=             TO_DINT(SHL(TO_DWORD(array_buffer[184]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[185]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[186]),  UINT#8) OR
																TO_DWORD(array_buffer[187])); 
			buf4.ErrorStatus.LowerSuspect:=         TO_DINT(SHL(TO_DWORD(array_buffer[188]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[189]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[190]),  UINT#8) OR
																TO_DWORD(array_buffer[191])); 
			buf4.ErrorStatus.UpperSuspect:=         TO_DINT(SHL(TO_DWORD(array_buffer[192]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[193]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[194]),  UINT#8) OR
																TO_DWORD(array_buffer[195])); 
			buf4.ErrorStatus.UpperBad:=             TO_DINT(SHL(TO_DWORD(array_buffer[196]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[197]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[198]),  UINT#8) OR
																TO_DWORD(array_buffer[199]));                                                                                             
        END_METHOD

        METHOD PRIVATE ByteArray_TO_buf5 
            VAR_INPUT
                array_buffer : ARRAY[0..253] OF BYTE;
            END_VAR
            VAR_IN_OUT
                buf5 : Axo_IQ_SeriesWelder_data5_176bytes;
            END_VAR
			buf5.AnalogSensor.Sensor[1].Enable:=    TO_DINT(SHL(TO_DWORD(array_buffer[  0]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[  1]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[  2]),  UINT#8) OR
																TO_DWORD(array_buffer[  3]));                            
			buf5.AnalogSensor.Sensor[1].MIN_VOLT:=  TO_DINT(SHL(TO_DWORD(array_buffer[  4]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[  5]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[  6]),  UINT#8) OR
																TO_DWORD(array_buffer[  7]));              
			buf5.AnalogSensor.Sensor[1].MAX_VOLT:=  TO_DINT(SHL(TO_DWORD(array_buffer[  8]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[  9]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[ 10]),  UINT#8) OR
																TO_DWORD(array_buffer[ 11]));              
			buf5.AnalogSensor.Sensor[1].MIN_VAL:=   TO_DINT(SHL(TO_DWORD(array_buffer[ 12]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[ 13]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[ 14]),  UINT#8) OR
																TO_DWORD(array_buffer[ 15]));              
			buf5.AnalogSensor.Sensor[1].MAX_VAL:=   TO_DINT(SHL(TO_DWORD(array_buffer[ 16]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[ 17]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[ 18]),  UINT#8) OR
																TO_DWORD(array_buffer[ 19]));              
			buf5.AnalogSensor.Sensor[2].Enable:=    TO_DINT(SHL(TO_DWORD(array_buffer[ 20]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[ 21]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[ 22]),  UINT#8) OR
																TO_DWORD(array_buffer[ 23]));                            
			buf5.AnalogSensor.Sensor[2].MIN_VOLT:=  TO_DINT(SHL(TO_DWORD(array_buffer[ 24]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[ 25]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[ 26]),  UINT#8) OR
																TO_DWORD(array_buffer[ 27]));              
			buf5.AnalogSensor.Sensor[2].MAX_VOLT:=  TO_DINT(SHL(TO_DWORD(array_buffer[ 28]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[ 29]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[ 30]),  UINT#8) OR
																TO_DWORD(array_buffer[ 31]));              
			buf5.AnalogSensor.Sensor[2].MIN_VAL:=   TO_DINT(SHL(TO_DWORD(array_buffer[ 32]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[ 33]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[ 34]),  UINT#8) OR
																TO_DWORD(array_buffer[ 35]));              
			buf5.AnalogSensor.Sensor[2].MAX_VAL:=   TO_DINT(SHL(TO_DWORD(array_buffer[ 36]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[ 37]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[ 38]),  UINT#8) OR
																TO_DWORD(array_buffer[ 39]));     
			buf5.AnalogSensor.Sensor[3].Enable:=    TO_DINT(SHL(TO_DWORD(array_buffer[ 40]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[ 41]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[ 42]),  UINT#8) OR
																TO_DWORD(array_buffer[ 43]));                            
			buf5.AnalogSensor.Sensor[3].MIN_VOLT:=  TO_DINT(SHL(TO_DWORD(array_buffer[ 44]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[ 45]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[ 46]),  UINT#8) OR
																TO_DWORD(array_buffer[ 47]));              
			buf5.AnalogSensor.Sensor[3].MAX_VOLT:=  TO_DINT(SHL(TO_DWORD(array_buffer[ 48]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[ 49]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[ 50]),  UINT#8) OR
																TO_DWORD(array_buffer[ 51]));              
			buf5.AnalogSensor.Sensor[3].MIN_VAL:=   TO_DINT(SHL(TO_DWORD(array_buffer[ 52]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[ 53]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[ 54]),  UINT#8) OR
																TO_DWORD(array_buffer[ 55]));              
			buf5.AnalogSensor.Sensor[3].MAX_VAL:=   TO_DINT(SHL(TO_DWORD(array_buffer[ 56]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[ 57]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[ 58]),  UINT#8) OR
																TO_DWORD(array_buffer[ 59])); 
			buf5.AnalogSensor.Sensor[4].Enable:=    TO_DINT(SHL(TO_DWORD(array_buffer[ 60]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[ 61]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[ 62]),  UINT#8) OR
																TO_DWORD(array_buffer[ 63]));                            
			buf5.AnalogSensor.Sensor[4].MIN_VOLT:=  TO_DINT(SHL(TO_DWORD(array_buffer[ 64]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[ 65]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[ 66]),  UINT#8) OR
																TO_DWORD(array_buffer[ 67]));              
			buf5.AnalogSensor.Sensor[4].MAX_VOLT:=  TO_DINT(SHL(TO_DWORD(array_buffer[ 68]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[ 69]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[ 70]),  UINT#8) OR
																TO_DWORD(array_buffer[ 71]));              
			buf5.AnalogSensor.Sensor[4].MIN_VAL:=   TO_DINT(SHL(TO_DWORD(array_buffer[ 72]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[ 73]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[ 74]),  UINT#8) OR
																TO_DWORD(array_buffer[ 75]));              
			buf5.AnalogSensor.Sensor[4].MAX_VAL:=   TO_DINT(SHL(TO_DWORD(array_buffer[ 76]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[ 77]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[ 78]),  UINT#8) OR
																TO_DWORD(array_buffer[ 79]));     
			buf5.AnalogSensor.Sensor[5].Enable:=    TO_DINT(SHL(TO_DWORD(array_buffer[ 80]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[ 81]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[ 82]),  UINT#8) OR
																TO_DWORD(array_buffer[ 83]));                            
			buf5.AnalogSensor.Sensor[5].MIN_VOLT:=  TO_DINT(SHL(TO_DWORD(array_buffer[ 84]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[ 85]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[ 86]),  UINT#8) OR
																TO_DWORD(array_buffer[ 87]));              
			buf5.AnalogSensor.Sensor[5].MAX_VOLT:=  TO_DINT(SHL(TO_DWORD(array_buffer[ 88]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[ 89]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[ 90]),  UINT#8) OR
																TO_DWORD(array_buffer[ 91]));              
			buf5.AnalogSensor.Sensor[5].MIN_VAL:=   TO_DINT(SHL(TO_DWORD(array_buffer[ 92]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[ 93]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[ 94]),  UINT#8) OR
																TO_DWORD(array_buffer[ 95]));              
			buf5.AnalogSensor.Sensor[5].MAX_VAL:=   TO_DINT(SHL(TO_DWORD(array_buffer[ 96]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[ 97]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[ 98]),  UINT#8) OR
																TO_DWORD(array_buffer[ 99]));              
			buf5.AnalogSensor.Sensor[6].Enable:=    TO_DINT(SHL(TO_DWORD(array_buffer[100]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[101]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[102]),  UINT#8) OR
																TO_DWORD(array_buffer[103]));                            
			buf5.AnalogSensor.Sensor[6].MIN_VOLT:=  TO_DINT(SHL(TO_DWORD(array_buffer[104]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[105]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[106]),  UINT#8) OR
																TO_DWORD(array_buffer[107]));              
			buf5.AnalogSensor.Sensor[6].MAX_VOLT:=  TO_DINT(SHL(TO_DWORD(array_buffer[108]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[109]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[110]),  UINT#8) OR
																TO_DWORD(array_buffer[111]));              
			buf5.AnalogSensor.Sensor[6].MIN_VAL:=   TO_DINT(SHL(TO_DWORD(array_buffer[112]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[113]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[114]),  UINT#8) OR
																TO_DWORD(array_buffer[115]));              
			buf5.AnalogSensor.Sensor[6].MAX_VAL:=   TO_DINT(SHL(TO_DWORD(array_buffer[116]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[117]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[118]),  UINT#8) OR
																TO_DWORD(array_buffer[119]));     
			buf5.AnalogSensor.Sensor[7].Enable:=    TO_DINT(SHL(TO_DWORD(array_buffer[120]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[121]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[122]),  UINT#8) OR
																TO_DWORD(array_buffer[123]));                            
			buf5.AnalogSensor.Sensor[7].MIN_VOLT:=  TO_DINT(SHL(TO_DWORD(array_buffer[124]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[125]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[126]),  UINT#8) OR
																TO_DWORD(array_buffer[127]));              
			buf5.AnalogSensor.Sensor[7].MAX_VOLT:=  TO_DINT(SHL(TO_DWORD(array_buffer[128]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[129]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[130]),  UINT#8) OR
																TO_DWORD(array_buffer[131]));              
			buf5.AnalogSensor.Sensor[7].MIN_VAL:=   TO_DINT(SHL(TO_DWORD(array_buffer[132]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[133]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[134]),  UINT#8) OR
																TO_DWORD(array_buffer[135]));              
			buf5.AnalogSensor.Sensor[7].MAX_VAL:=   TO_DINT(SHL(TO_DWORD(array_buffer[136]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[137]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[138]),  UINT#8) OR
																TO_DWORD(array_buffer[139]));              
			buf5.AnalogSensor.Sensor[8].Enable:=    TO_DINT(SHL(TO_DWORD(array_buffer[140]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[141]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[142]),  UINT#8) OR
																TO_DWORD(array_buffer[143]));                            
			buf5.AnalogSensor.Sensor[8].MIN_VOLT:=  TO_DINT(SHL(TO_DWORD(array_buffer[144]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[145]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[146]),  UINT#8) OR
																TO_DWORD(array_buffer[147]));              
			buf5.AnalogSensor.Sensor[8].MAX_VOLT:=  TO_DINT(SHL(TO_DWORD(array_buffer[148]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[149]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[150]),  UINT#8) OR
																TO_DWORD(array_buffer[151]));              
			buf5.AnalogSensor.Sensor[8].MIN_VAL:=   TO_DINT(SHL(TO_DWORD(array_buffer[152]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[153]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[154]),  UINT#8) OR
																TO_DWORD(array_buffer[155]));              
			buf5.AnalogSensor.Sensor[8].MAX_VAL:=   TO_DINT(SHL(TO_DWORD(array_buffer[156]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[157]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[158]),  UINT#8) OR
																TO_DWORD(array_buffer[159]));   
			buf5.AfterburstEnable:=                 TO_DINT(SHL(TO_DWORD(array_buffer[160]), UINT#24) OR
															SHL(TO_DWORD(array_buffer[161]), UINT#16) OR
															SHL(TO_DWORD(array_buffer[162]),  UINT#8) OR
																TO_DWORD(array_buffer[163]));   
			buf5.LimitWeld1TimeEnable._0 				:=               array_buffer[164].%X0;
			buf5.LimitWeld1TimeEnable._1 				:=               array_buffer[164].%X1;
			buf5.LimitWeld1TimeEnable._2 				:=               array_buffer[164].%X2;
			buf5.LimitWeld1TimeEnable._3 				:=               array_buffer[164].%X3;
			buf5.LimitWeld1TimeEnable._4 				:=               array_buffer[164].%X4;
			buf5.LimitWeld1TimeEnable._5 				:=               array_buffer[164].%X5;
			buf5.LimitWeld1TimeEnable._6 				:=               array_buffer[164].%X6;
			buf5.LimitWeld1TimeEnable._7 				:=               array_buffer[164].%X7;
			buf5.LimitWeld1TimeEnable._8 				:=               array_buffer[165].%X0;
			buf5.LimitWeld1TimeEnable._9 				:=               array_buffer[165].%X1;
			buf5.LimitWeld1TimeEnable._10 				:=               array_buffer[165].%X2;
			buf5.LimitWeld1TimeEnable._11 				:=               array_buffer[165].%X3;
			buf5.LimitWeld1TimeEnable._12 				:=               array_buffer[165].%X4;
			buf5.LimitWeld1TimeEnable._13 				:=               array_buffer[165].%X5;
			buf5.LimitWeld1TimeEnable._14 				:=               array_buffer[165].%X6;
			buf5.LimitWeld1TimeEnable._15 				:=               array_buffer[165].%X7;
			buf5.LimitWeld1TimeEnable._16 				:=               array_buffer[166].%X0;
			buf5.LimitWeld1TimeEnable._17 				:=               array_buffer[166].%X1;
			buf5.LimitWeld1TimeEnable._18 				:=               array_buffer[166].%X2;
			buf5.LimitWeld1TimeEnable._19 				:=               array_buffer[166].%X3;
			buf5.LimitWeld1TimeEnable._20 				:=               array_buffer[166].%X4;
			buf5.LimitWeld1TimeEnable._21 				:=               array_buffer[166].%X5;
			buf5.LimitWeld1TimeEnable._22 				:=               array_buffer[166].%X6;
			buf5.LimitWeld1TimeEnable._23 				:=               array_buffer[166].%X7;
			buf5.LimitWeld1TimeEnable.LowerBad_1 		:=               array_buffer[167].%X0;
			buf5.LimitWeld1TimeEnable.LowerSuspect_1	:=               array_buffer[167].%X1;
			buf5.LimitWeld1TimeEnable.UpperSuspect_1	:=               array_buffer[167].%X2;
			buf5.LimitWeld1TimeEnable.UpperBad_1 		:=               array_buffer[167].%X3;
			buf5.LimitWeld1TimeEnable.Display_1 		:=               array_buffer[167].%X4;
			buf5.LimitWeld1TimeEnable._29 				:=               array_buffer[167].%X5;
			buf5.LimitWeld1TimeEnable._30 				:=               array_buffer[167].%X6;
			buf5.LimitWeld1TimeEnable._31 				:=               array_buffer[167].%X7;
			buf5.LimitWeld1EnergyEnable._0 				:=               array_buffer[168].%X0;
			buf5.LimitWeld1EnergyEnable._1 				:=               array_buffer[168].%X1;
			buf5.LimitWeld1EnergyEnable._2 				:=               array_buffer[168].%X2;
			buf5.LimitWeld1EnergyEnable._3 				:=               array_buffer[168].%X3;
			buf5.LimitWeld1EnergyEnable._4 				:=               array_buffer[168].%X4;
			buf5.LimitWeld1EnergyEnable._5 				:=               array_buffer[168].%X5;
			buf5.LimitWeld1EnergyEnable._6 				:=               array_buffer[168].%X6;
			buf5.LimitWeld1EnergyEnable._7 				:=               array_buffer[168].%X7;
			buf5.LimitWeld1EnergyEnable._8 				:=               array_buffer[169].%X0;
			buf5.LimitWeld1EnergyEnable._9 				:=               array_buffer[169].%X1;
			buf5.LimitWeld1EnergyEnable._10 		    :=               array_buffer[169].%X2;
			buf5.LimitWeld1EnergyEnable._11 		    :=               array_buffer[169].%X3;
			buf5.LimitWeld1EnergyEnable._12 		    :=               array_buffer[169].%X4;
			buf5.LimitWeld1EnergyEnable._13 		    :=               array_buffer[169].%X5;
			buf5.LimitWeld1EnergyEnable._14 		    :=               array_buffer[169].%X6;
			buf5.LimitWeld1EnergyEnable._15 		    :=               array_buffer[169].%X7;
			buf5.LimitWeld1EnergyEnable._16 		    :=               array_buffer[170].%X0;
			buf5.LimitWeld1EnergyEnable._17 		    :=               array_buffer[170].%X1;
			buf5.LimitWeld1EnergyEnable._18 		    :=               array_buffer[170].%X2;
			buf5.LimitWeld1EnergyEnable._19 		    :=               array_buffer[170].%X3;
			buf5.LimitWeld1EnergyEnable._20 		    :=               array_buffer[170].%X4;
			buf5.LimitWeld1EnergyEnable._21 		    :=               array_buffer[170].%X5;
			buf5.LimitWeld1EnergyEnable._22 		    :=               array_buffer[170].%X6;
			buf5.LimitWeld1EnergyEnable._23 		    :=               array_buffer[170].%X7;
			buf5.LimitWeld1EnergyEnable.LowerBad_1 		:=               array_buffer[171].%X0;
			buf5.LimitWeld1EnergyEnable.LowerSuspect_1	:=               array_buffer[171].%X1;
			buf5.LimitWeld1EnergyEnable.UpperSuspect_1	:=               array_buffer[171].%X2;
			buf5.LimitWeld1EnergyEnable.UpperBad_1 		:=               array_buffer[171].%X3;
			buf5.LimitWeld1EnergyEnable.Display_1 		:=               array_buffer[171].%X4;
			buf5.LimitWeld1EnergyEnable._29 			:=               array_buffer[171].%X5;
			buf5.LimitWeld1EnergyEnable._30 			:=               array_buffer[171].%X6;
			buf5.LimitWeld1EnergyEnable._31 			:=               array_buffer[171].%X7;
			buf5.LimitWeld1PowerEnable._0 				:=               array_buffer[172].%X0;
			buf5.LimitWeld1PowerEnable._1 				:=               array_buffer[172].%X1;
			buf5.LimitWeld1PowerEnable._2 				:=               array_buffer[172].%X2;
			buf5.LimitWeld1PowerEnable._3 				:=               array_buffer[172].%X3;
			buf5.LimitWeld1PowerEnable._4 				:=               array_buffer[172].%X4;
			buf5.LimitWeld1PowerEnable._5 				:=               array_buffer[172].%X5;
			buf5.LimitWeld1PowerEnable._6 				:=               array_buffer[172].%X6;
			buf5.LimitWeld1PowerEnable._7 				:=               array_buffer[172].%X7;
			buf5.LimitWeld1PowerEnable._8 				:=               array_buffer[173].%X0;
			buf5.LimitWeld1PowerEnable._9 				:=               array_buffer[173].%X1;
			buf5.LimitWeld1PowerEnable._10 				:=               array_buffer[173].%X2;
			buf5.LimitWeld1PowerEnable._11 				:=               array_buffer[173].%X3;
			buf5.LimitWeld1PowerEnable._12 				:=               array_buffer[173].%X4;
			buf5.LimitWeld1PowerEnable._13 				:=               array_buffer[173].%X5;
			buf5.LimitWeld1PowerEnable._14 				:=               array_buffer[173].%X6;
			buf5.LimitWeld1PowerEnable._15 				:=               array_buffer[173].%X7;
			buf5.LimitWeld1PowerEnable._16 				:=               array_buffer[174].%X0;
			buf5.LimitWeld1PowerEnable._17 				:=               array_buffer[174].%X1;
			buf5.LimitWeld1PowerEnable._18 				:=               array_buffer[174].%X2;
			buf5.LimitWeld1PowerEnable._19 				:=               array_buffer[174].%X3;
			buf5.LimitWeld1PowerEnable._20 				:=               array_buffer[174].%X4;
			buf5.LimitWeld1PowerEnable._21 				:=               array_buffer[174].%X5;
			buf5.LimitWeld1PowerEnable._22 				:=               array_buffer[174].%X6;
			buf5.LimitWeld1PowerEnable._23 				:=               array_buffer[174].%X7;
			buf5.LimitWeld1PowerEnable.LowerBad_1 		:=               array_buffer[175].%X0;
			buf5.LimitWeld1PowerEnable.LowerSuspect_1	:=               array_buffer[175].%X1;
			buf5.LimitWeld1PowerEnable.UpperSuspect_1	:=               array_buffer[175].%X2;
			buf5.LimitWeld1PowerEnable.UpperBad_1 		:=               array_buffer[175].%X3;
			buf5.LimitWeld1PowerEnable.Display_1 		:=               array_buffer[175].%X4;
			buf5.LimitWeld1PowerEnable._29 				:=               array_buffer[175].%X5;
			buf5.LimitWeld1PowerEnable._30 				:=               array_buffer[175].%X6;
			buf5.LimitWeld1PowerEnable._31 				:=               array_buffer[175].%X7;
		END_METHOD

        METHOD PRIVATE buf1_TO_ByteArray
            VAR_IN_OUT
                buf1 : Axo_IQ_SeriesWelder_data1_132bytes;
                array_buffer : ARRAY[0..253] OF BYTE;
            END_VAR
            
            // ---- ProcCtrl: DINT fields → bytes ----
            array_buffer[  0] := TO_BYTE(SHR(TO_DWORD(buf1.ProcCtrl.RegulationAmplitude), UINT#24));
            array_buffer[  1] := TO_BYTE(SHR(TO_DWORD(buf1.ProcCtrl.RegulationAmplitude), UINT#16));
            array_buffer[  2] := TO_BYTE(SHR(TO_DWORD(buf1.ProcCtrl.RegulationAmplitude),  UINT#8));
            array_buffer[  3] := TO_BYTE(     TO_DWORD(buf1.ProcCtrl.RegulationAmplitude));
            
            array_buffer[  4] := TO_BYTE(SHR(TO_DWORD(buf1.ProcCtrl.RampUpTime), UINT#24));
            array_buffer[  5] := TO_BYTE(SHR(TO_DWORD(buf1.ProcCtrl.RampUpTime), UINT#16));
            array_buffer[  6] := TO_BYTE(SHR(TO_DWORD(buf1.ProcCtrl.RampUpTime),  UINT#8));
            array_buffer[  7] := TO_BYTE(     TO_DWORD(buf1.ProcCtrl.RampUpTime));
            
            array_buffer[  8] := TO_BYTE(SHR(TO_DWORD(buf1.ProcCtrl.RampDownTime), UINT#24));
            array_buffer[  9] := TO_BYTE(SHR(TO_DWORD(buf1.ProcCtrl.RampDownTime), UINT#16));
            array_buffer[ 10] := TO_BYTE(SHR(TO_DWORD(buf1.ProcCtrl.RampDownTime),  UINT#8));
            array_buffer[ 11] := TO_BYTE(     TO_DWORD(buf1.ProcCtrl.RampDownTime));
            
            // ---- ProcCtrl: OBSOLETE_ProcessControlEnable bits → bytes 12..15 ----
            array_buffer[12].%X0 := buf1.ProcCtrl.OBSOLETE_ProcessControlEnable._0;
            array_buffer[12].%X1 := buf1.ProcCtrl.OBSOLETE_ProcessControlEnable._1;
            array_buffer[12].%X2 := buf1.ProcCtrl.OBSOLETE_ProcessControlEnable._2;
            array_buffer[12].%X3 := buf1.ProcCtrl.OBSOLETE_ProcessControlEnable._3;
            array_buffer[12].%X4 := buf1.ProcCtrl.OBSOLETE_ProcessControlEnable._4;
            array_buffer[12].%X5 := buf1.ProcCtrl.OBSOLETE_ProcessControlEnable._5;
            array_buffer[12].%X6 := buf1.ProcCtrl.OBSOLETE_ProcessControlEnable._6;
            array_buffer[12].%X7 := buf1.ProcCtrl.OBSOLETE_ProcessControlEnable._7;
            
            array_buffer[13].%X0 := buf1.ProcCtrl.OBSOLETE_ProcessControlEnable.HoldTime_Enable;
            array_buffer[13].%X1 := buf1.ProcCtrl.OBSOLETE_ProcessControlEnable.Afterburst_Enable;
            array_buffer[13].%X2 := buf1.ProcCtrl.OBSOLETE_ProcessControlEnable._10;
            array_buffer[13].%X3 := buf1.ProcCtrl.OBSOLETE_ProcessControlEnable._11;
            array_buffer[13].%X4 := buf1.ProcCtrl.OBSOLETE_ProcessControlEnable._12;
            array_buffer[13].%X5 := buf1.ProcCtrl.OBSOLETE_ProcessControlEnable._13;
            array_buffer[13].%X6 := buf1.ProcCtrl.OBSOLETE_ProcessControlEnable._14;
            array_buffer[13].%X7 := buf1.ProcCtrl.OBSOLETE_ProcessControlEnable._15;
            
            array_buffer[14].%X0 := buf1.ProcCtrl.OBSOLETE_ProcessControlEnable._16;
            array_buffer[14].%X1 := buf1.ProcCtrl.OBSOLETE_ProcessControlEnable._17;
            array_buffer[14].%X2 := buf1.ProcCtrl.OBSOLETE_ProcessControlEnable._18;
            array_buffer[14].%X3 := buf1.ProcCtrl.OBSOLETE_ProcessControlEnable._19;
            array_buffer[14].%X4 := buf1.ProcCtrl.OBSOLETE_ProcessControlEnable._20;
            array_buffer[14].%X5 := buf1.ProcCtrl.OBSOLETE_ProcessControlEnable._21;
            array_buffer[14].%X6 := buf1.ProcCtrl.OBSOLETE_ProcessControlEnable._22;
            array_buffer[14].%X7 := buf1.ProcCtrl.OBSOLETE_ProcessControlEnable._23;
            
            array_buffer[15].%X0 := buf1.ProcCtrl.OBSOLETE_ProcessControlEnable.WeldTime_Enable;
            array_buffer[15].%X1 := buf1.ProcCtrl.OBSOLETE_ProcessControlEnable.WeldPower_Enable;
            array_buffer[15].%X2 := buf1.ProcCtrl.OBSOLETE_ProcessControlEnable.WeldEnergy_Enable;
            array_buffer[15].%X3 := buf1.ProcCtrl.OBSOLETE_ProcessControlEnable.WeldDistance_Enable;
            array_buffer[15].%X4 := buf1.ProcCtrl.OBSOLETE_ProcessControlEnable.WeldPosition_Enable;
            array_buffer[15].%X5 := buf1.ProcCtrl.OBSOLETE_ProcessControlEnable._29;
            array_buffer[15].%X6 := buf1.ProcCtrl.OBSOLETE_ProcessControlEnable._30;
            array_buffer[15].%X7 := buf1.ProcCtrl.OBSOLETE_ProcessControlEnable._31;
            
            // ---- ProcCtrl: more DINTs ----
            array_buffer[16] := TO_BYTE(SHR(TO_DWORD(buf1.ProcCtrl.WeldTime), UINT#24));
            array_buffer[17] := TO_BYTE(SHR(TO_DWORD(buf1.ProcCtrl.WeldTime), UINT#16));
            array_buffer[18] := TO_BYTE(SHR(TO_DWORD(buf1.ProcCtrl.WeldTime),  UINT#8));
            array_buffer[19] := TO_BYTE(     TO_DWORD(buf1.ProcCtrl.WeldTime));
            
            array_buffer[20] := TO_BYTE(SHR(TO_DWORD(buf1.ProcCtrl.WeldPower), UINT#24));
            array_buffer[21] := TO_BYTE(SHR(TO_DWORD(buf1.ProcCtrl.WeldPower), UINT#16));
            array_buffer[22] := TO_BYTE(SHR(TO_DWORD(buf1.ProcCtrl.WeldPower),  UINT#8));
            array_buffer[23] := TO_BYTE(     TO_DWORD(buf1.ProcCtrl.WeldPower));
            
            array_buffer[24] := TO_BYTE(SHR(TO_DWORD(buf1.ProcCtrl.WeldEnergy), UINT#24));
            array_buffer[25] := TO_BYTE(SHR(TO_DWORD(buf1.ProcCtrl.WeldEnergy), UINT#16));
            array_buffer[26] := TO_BYTE(SHR(TO_DWORD(buf1.ProcCtrl.WeldEnergy),  UINT#8));
            array_buffer[27] := TO_BYTE(     TO_DWORD(buf1.ProcCtrl.WeldEnergy));
            
            array_buffer[28] := TO_BYTE(SHR(TO_DWORD(buf1.ProcCtrl.HoldTime), UINT#24));
            array_buffer[29] := TO_BYTE(SHR(TO_DWORD(buf1.ProcCtrl.HoldTime), UINT#16));
            array_buffer[30] := TO_BYTE(SHR(TO_DWORD(buf1.ProcCtrl.HoldTime),  UINT#8));
            array_buffer[31] := TO_BYTE(     TO_DWORD(buf1.ProcCtrl.HoldTime));
            
            array_buffer[32] := TO_BYTE(SHR(TO_DWORD(buf1.ProcCtrl.AfterBurstDelay), UINT#24));
            array_buffer[33] := TO_BYTE(SHR(TO_DWORD(buf1.ProcCtrl.AfterBurstDelay), UINT#16));
            array_buffer[34] := TO_BYTE(SHR(TO_DWORD(buf1.ProcCtrl.AfterBurstDelay),  UINT#8));
            array_buffer[35] := TO_BYTE(     TO_DWORD(buf1.ProcCtrl.AfterBurstDelay));
            
            array_buffer[36] := TO_BYTE(SHR(TO_DWORD(buf1.ProcCtrl.AfterBurstDuration), UINT#24));
            array_buffer[37] := TO_BYTE(SHR(TO_DWORD(buf1.ProcCtrl.AfterBurstDuration), UINT#16));
            array_buffer[38] := TO_BYTE(SHR(TO_DWORD(buf1.ProcCtrl.AfterBurstDuration),  UINT#8));
            array_buffer[39] := TO_BYTE(     TO_DWORD(buf1.ProcCtrl.AfterBurstDuration));
            
            // ---- ProcLimits.Enable bits → bytes 40..43 ----
            array_buffer[40].%X0 := buf1.ProcLimits.Enable.LowerBadEnergy;
            array_buffer[40].%X1 := buf1.ProcLimits.Enable.LowerSuspectEnergy;
            array_buffer[40].%X2 := buf1.ProcLimits.Enable.UpperSuspectEnergy;
            array_buffer[40].%X3 := buf1.ProcLimits.Enable.UpperBadEnergy;
            array_buffer[40].%X4 := buf1.ProcLimits.Enable.DisplayEnergy;
            array_buffer[40].%X5 := buf1.ProcLimits.Enable._5;
            array_buffer[40].%X6 := buf1.ProcLimits.Enable._6;
            array_buffer[40].%X7 := buf1.ProcLimits.Enable._7;
            
            array_buffer[41].%X0 := buf1.ProcLimits.Enable.LowerBadPower;
            array_buffer[41].%X1 := buf1.ProcLimits.Enable.LowerSuspectPower;
            array_buffer[41].%X2 := buf1.ProcLimits.Enable.UpperSuspectPower;
            array_buffer[41].%X3 := buf1.ProcLimits.Enable.UpperBadPower;
            array_buffer[41].%X4 := buf1.ProcLimits.Enable.DisplayPower;
            array_buffer[41].%X5 := buf1.ProcLimits.Enable._13;
            array_buffer[41].%X6 := buf1.ProcLimits.Enable._14;
            array_buffer[41].%X7 := buf1.ProcLimits.Enable._15;
            
            array_buffer[42].%X0 := buf1.ProcLimits.Enable.LowerBadTime;
            array_buffer[42].%X1 := buf1.ProcLimits.Enable.LowerSuspectTime;
            array_buffer[42].%X2 := buf1.ProcLimits.Enable.UpperSuspectTime;
            array_buffer[42].%X3 := buf1.ProcLimits.Enable.UpperBadTIme; // note: name as in source
            array_buffer[42].%X4 := buf1.ProcLimits.Enable.DisplayTime;
            array_buffer[42].%X5 := buf1.ProcLimits.Enable._21;
            array_buffer[42].%X6 := buf1.ProcLimits.Enable._22;
            array_buffer[42].%X7 := buf1.ProcLimits.Enable._23;
            
            array_buffer[43].%X0 := buf1.ProcLimits.Enable._24;
            array_buffer[43].%X1 := buf1.ProcLimits.Enable._25;
            array_buffer[43].%X2 := buf1.ProcLimits.Enable._26;
            array_buffer[43].%X3 := buf1.ProcLimits.Enable._27;
            array_buffer[43].%X4 := buf1.ProcLimits.Enable._28;
            array_buffer[43].%X5 := buf1.ProcLimits.Enable._29;
            array_buffer[43].%X6 := buf1.ProcLimits.Enable._30;
            array_buffer[43].%X7 := buf1.ProcLimits.Enable._31;
            
            // ---- ProcLimits: DINTs ----
            array_buffer[44] := TO_BYTE(SHR(TO_DWORD(buf1.ProcLimits.WeldTimeLowerBad), UINT#24));
            array_buffer[45] := TO_BYTE(SHR(TO_DWORD(buf1.ProcLimits.WeldTimeLowerBad), UINT#16));
            array_buffer[46] := TO_BYTE(SHR(TO_DWORD(buf1.ProcLimits.WeldTimeLowerBad),  UINT#8));
            array_buffer[47] := TO_BYTE(     TO_DWORD(buf1.ProcLimits.WeldTimeLowerBad));
            
            array_buffer[48] := TO_BYTE(SHR(TO_DWORD(buf1.ProcLimits.WeldTimeLowerSuspect), UINT#24));
            array_buffer[49] := TO_BYTE(SHR(TO_DWORD(buf1.ProcLimits.WeldTimeLowerSuspect), UINT#16));
            array_buffer[50] := TO_BYTE(SHR(TO_DWORD(buf1.ProcLimits.WeldTimeLowerSuspect),  UINT#8));
            array_buffer[51] := TO_BYTE(     TO_DWORD(buf1.ProcLimits.WeldTimeLowerSuspect));
            
            array_buffer[52] := TO_BYTE(SHR(TO_DWORD(buf1.ProcLimits.WeldTimeUpperSuspect), UINT#24));
            array_buffer[53] := TO_BYTE(SHR(TO_DWORD(buf1.ProcLimits.WeldTimeUpperSuspect), UINT#16));
            array_buffer[54] := TO_BYTE(SHR(TO_DWORD(buf1.ProcLimits.WeldTimeUpperSuspect),  UINT#8));
            array_buffer[55] := TO_BYTE(     TO_DWORD(buf1.ProcLimits.WeldTimeUpperSuspect));
            
            array_buffer[56] := TO_BYTE(SHR(TO_DWORD(buf1.ProcLimits.WeldTimeUpperBad), UINT#24));
            array_buffer[57] := TO_BYTE(SHR(TO_DWORD(buf1.ProcLimits.WeldTimeUpperBad), UINT#16));
            array_buffer[58] := TO_BYTE(SHR(TO_DWORD(buf1.ProcLimits.WeldTimeUpperBad),  UINT#8));
            array_buffer[59] := TO_BYTE(     TO_DWORD(buf1.ProcLimits.WeldTimeUpperBad));
            
            array_buffer[60] := TO_BYTE(SHR(TO_DWORD(buf1.ProcLimits.WeldPowerLowerBad), UINT#24));
            array_buffer[61] := TO_BYTE(SHR(TO_DWORD(buf1.ProcLimits.WeldPowerLowerBad), UINT#16));
            array_buffer[62] := TO_BYTE(SHR(TO_DWORD(buf1.ProcLimits.WeldPowerLowerBad),  UINT#8));
            array_buffer[63] := TO_BYTE(     TO_DWORD(buf1.ProcLimits.WeldPowerLowerBad));
            
            array_buffer[64] := TO_BYTE(SHR(TO_DWORD(buf1.ProcLimits.WeldPwrLowerSuspect), UINT#24));
            array_buffer[65] := TO_BYTE(SHR(TO_DWORD(buf1.ProcLimits.WeldPwrLowerSuspect), UINT#16));
            array_buffer[66] := TO_BYTE(SHR(TO_DWORD(buf1.ProcLimits.WeldPwrLowerSuspect),  UINT#8));
            array_buffer[67] := TO_BYTE(     TO_DWORD(buf1.ProcLimits.WeldPwrLowerSuspect));
            
            array_buffer[68] := TO_BYTE(SHR(TO_DWORD(buf1.ProcLimits.WeldPwrUpperSuspect), UINT#24));
            array_buffer[69] := TO_BYTE(SHR(TO_DWORD(buf1.ProcLimits.WeldPwrUpperSuspect), UINT#16));
            array_buffer[70] := TO_BYTE(SHR(TO_DWORD(buf1.ProcLimits.WeldPwrUpperSuspect),  UINT#8));
            array_buffer[71] := TO_BYTE(     TO_DWORD(buf1.ProcLimits.WeldPwrUpperSuspect));
            
            array_buffer[72] := TO_BYTE(SHR(TO_DWORD(buf1.ProcLimits.WeldPowerUpperBad), UINT#24));
            array_buffer[73] := TO_BYTE(SHR(TO_DWORD(buf1.ProcLimits.WeldPowerUpperBad), UINT#16));
            array_buffer[74] := TO_BYTE(SHR(TO_DWORD(buf1.ProcLimits.WeldPowerUpperBad),  UINT#8));
            array_buffer[75] := TO_BYTE(     TO_DWORD(buf1.ProcLimits.WeldPowerUpperBad));
            
            array_buffer[76] := TO_BYTE(SHR(TO_DWORD(buf1.ProcLimits.WeldEnergyLowerBad), UINT#24));
            array_buffer[77] := TO_BYTE(SHR(TO_DWORD(buf1.ProcLimits.WeldEnergyLowerBad), UINT#16));
            array_buffer[78] := TO_BYTE(SHR(TO_DWORD(buf1.ProcLimits.WeldEnergyLowerBad),  UINT#8));
            array_buffer[79] := TO_BYTE(     TO_DWORD(buf1.ProcLimits.WeldEnergyLowerBad));
            
            array_buffer[80] := TO_BYTE(SHR(TO_DWORD(buf1.ProcLimits.WeldEnergyLowerSuspect), UINT#24));
            array_buffer[81] := TO_BYTE(SHR(TO_DWORD(buf1.ProcLimits.WeldEnergyLowerSuspect), UINT#16));
            array_buffer[82] := TO_BYTE(SHR(TO_DWORD(buf1.ProcLimits.WeldEnergyLowerSuspect),  UINT#8));
            array_buffer[83] := TO_BYTE(     TO_DWORD(buf1.ProcLimits.WeldEnergyLowerSuspect));
            
            array_buffer[84] := TO_BYTE(SHR(TO_DWORD(buf1.ProcLimits.WeldEnergyUpperSuspect), UINT#24));
            array_buffer[85] := TO_BYTE(SHR(TO_DWORD(buf1.ProcLimits.WeldEnergyUpperSuspect), UINT#16));
            array_buffer[86] := TO_BYTE(SHR(TO_DWORD(buf1.ProcLimits.WeldEnergyUpperSuspect),  UINT#8));
            array_buffer[87] := TO_BYTE(     TO_DWORD(buf1.ProcLimits.WeldEnergyUpperSuspect));
            
            array_buffer[88] := TO_BYTE(SHR(TO_DWORD(buf1.ProcLimits.WeldEnergyUpperBad), UINT#24));
            array_buffer[89] := TO_BYTE(SHR(TO_DWORD(buf1.ProcLimits.WeldEnergyUpperBad), UINT#16));
            array_buffer[90] := TO_BYTE(SHR(TO_DWORD(buf1.ProcLimits.WeldEnergyUpperBad),  UINT#8));
            array_buffer[91] := TO_BYTE(     TO_DWORD(buf1.ProcLimits.WeldEnergyUpperBad));
            
            // ---- FreqCtrl: DINTs ----
            array_buffer[92] := TO_BYTE(SHR(TO_DWORD(buf1.FreqCtrl.FreerunFrequency), UINT#24));
            array_buffer[93] := TO_BYTE(SHR(TO_DWORD(buf1.FreqCtrl.FreerunFrequency), UINT#16));
            array_buffer[94] := TO_BYTE(SHR(TO_DWORD(buf1.FreqCtrl.FreerunFrequency),  UINT#8));
            array_buffer[95] := TO_BYTE(     TO_DWORD(buf1.FreqCtrl.FreerunFrequency));
            
            array_buffer[96] := TO_BYTE(SHR(TO_DWORD(buf1.FreqCtrl.LowerFrequencyBound), UINT#24));
            array_buffer[97] := TO_BYTE(SHR(TO_DWORD(buf1.FreqCtrl.LowerFrequencyBound), UINT#16));
            array_buffer[98] := TO_BYTE(SHR(TO_DWORD(buf1.FreqCtrl.LowerFrequencyBound),  UINT#8));
            array_buffer[99] := TO_BYTE(     TO_DWORD(buf1.FreqCtrl.LowerFrequencyBound));
            
            array_buffer[100] := TO_BYTE(SHR(TO_DWORD(buf1.FreqCtrl.UpperFrequencyBound), UINT#24));
            array_buffer[101] := TO_BYTE(SHR(TO_DWORD(buf1.FreqCtrl.UpperFrequencyBound), UINT#16));
            array_buffer[102] := TO_BYTE(SHR(TO_DWORD(buf1.FreqCtrl.UpperFrequencyBound),  UINT#8));
            array_buffer[103] := TO_BYTE(     TO_DWORD(buf1.FreqCtrl.UpperFrequencyBound));
            
            array_buffer[104] := TO_BYTE(SHR(TO_DWORD(buf1.FreqCtrl.LockandHoldModeEnable), UINT#24));
            array_buffer[105] := TO_BYTE(SHR(TO_DWORD(buf1.FreqCtrl.LockandHoldModeEnable), UINT#16));
            array_buffer[106] := TO_BYTE(SHR(TO_DWORD(buf1.FreqCtrl.LockandHoldModeEnable),  UINT#8));
            array_buffer[107] := TO_BYTE(     TO_DWORD(buf1.FreqCtrl.LockandHoldModeEnable));
            
            array_buffer[108] := TO_BYTE(SHR(TO_DWORD(buf1.FreqCtrl.USPhaseAdjustment), UINT#24));
            array_buffer[109] := TO_BYTE(SHR(TO_DWORD(buf1.FreqCtrl.USPhaseAdjustment), UINT#16));
            array_buffer[110] := TO_BYTE(SHR(TO_DWORD(buf1.FreqCtrl.USPhaseAdjustment),  UINT#8));
            array_buffer[111] := TO_BYTE(     TO_DWORD(buf1.FreqCtrl.USPhaseAdjustment));
            
            // ---- TriggerByPower: DINTs ----
            array_buffer[112] := TO_BYTE(SHR(TO_DWORD(buf1.TriggerByPower.Enable), UINT#24));
            array_buffer[113] := TO_BYTE(SHR(TO_DWORD(buf1.TriggerByPower.Enable), UINT#16));
            array_buffer[114] := TO_BYTE(SHR(TO_DWORD(buf1.TriggerByPower.Enable),  UINT#8));
            array_buffer[115] := TO_BYTE(     TO_DWORD(buf1.TriggerByPower.Enable));
            
            array_buffer[116] := TO_BYTE(SHR(TO_DWORD(buf1.TriggerByPower.Trigger_Timout), UINT#24));
            array_buffer[117] := TO_BYTE(SHR(TO_DWORD(buf1.TriggerByPower.Trigger_Timout), UINT#16));
            array_buffer[118] := TO_BYTE(SHR(TO_DWORD(buf1.TriggerByPower.Trigger_Timout),  UINT#8));
            array_buffer[119] := TO_BYTE(     TO_DWORD(buf1.TriggerByPower.Trigger_Timout));
            
            array_buffer[120] := TO_BYTE(SHR(TO_DWORD(buf1.TriggerByPower.Trigger_Level), UINT#24));
            array_buffer[121] := TO_BYTE(SHR(TO_DWORD(buf1.TriggerByPower.Trigger_Level), UINT#16));
            array_buffer[122] := TO_BYTE(SHR(TO_DWORD(buf1.TriggerByPower.Trigger_Level),  UINT#8));
            array_buffer[123] := TO_BYTE(     TO_DWORD(buf1.TriggerByPower.Trigger_Level));
            
            array_buffer[124] := TO_BYTE(SHR(TO_DWORD(buf1.TriggerByPower.PreTrigger_Amplitude), UINT#24));
            array_buffer[125] := TO_BYTE(SHR(TO_DWORD(buf1.TriggerByPower.PreTrigger_Amplitude), UINT#16));
            array_buffer[126] := TO_BYTE(SHR(TO_DWORD(buf1.TriggerByPower.PreTrigger_Amplitude),  UINT#8));
            array_buffer[127] := TO_BYTE(     TO_DWORD(buf1.TriggerByPower.PreTrigger_Amplitude));
            
            // ---- Misc: DINT ----
            array_buffer[128] := TO_BYTE(SHR(TO_DWORD(buf1.FreqCtrlMode), UINT#24));
            array_buffer[129] := TO_BYTE(SHR(TO_DWORD(buf1.FreqCtrlMode), UINT#16));
            array_buffer[130] := TO_BYTE(SHR(TO_DWORD(buf1.FreqCtrlMode),  UINT#8));
            array_buffer[131] := TO_BYTE(     TO_DWORD(buf1.FreqCtrlMode));
            
        END_METHOD

        METHOD PRIVATE buf2_TO_ByteArray
            VAR_IN_OUT
                buf2 : Axo_IQ_SeriesWelder_data2_136bytes;
                array_buffer : ARRAY[0..253] OF BYTE;
            END_VAR
            
            // ---- PowerReg (DINT → bytes 0..7) ----
            array_buffer[ 0] := TO_BYTE(SHR(TO_DWORD(buf2.PowerReg.PowerRegulationEnable), UINT#24));
            array_buffer[ 1] := TO_BYTE(SHR(TO_DWORD(buf2.PowerReg.PowerRegulationEnable), UINT#16));
            array_buffer[ 2] := TO_BYTE(SHR(TO_DWORD(buf2.PowerReg.PowerRegulationEnable),  UINT#8));
            array_buffer[ 3] := TO_BYTE(     TO_DWORD(buf2.PowerReg.PowerRegulationEnable));
            
            array_buffer[ 4] := TO_BYTE(SHR(TO_DWORD(buf2.PowerReg.PowerRegulationSetpoINT), UINT#24));
            array_buffer[ 5] := TO_BYTE(SHR(TO_DWORD(buf2.PowerReg.PowerRegulationSetpoINT), UINT#16));
            array_buffer[ 6] := TO_BYTE(SHR(TO_DWORD(buf2.PowerReg.PowerRegulationSetpoINT),  UINT#8));
            array_buffer[ 7] := TO_BYTE(     TO_DWORD(buf2.PowerReg.PowerRegulationSetpoINT));
            
            // ---- PressPretrigger.PreTriggerSource bits → bytes 8..11 ----
            array_buffer[ 8].%X0 := buf2.PressPretrigger.PreTriggerSource.bit24;
            array_buffer[ 8].%X1 := buf2.PressPretrigger.PreTriggerSource.bit25;
            array_buffer[ 8].%X2 := buf2.PressPretrigger.PreTriggerSource.bit26;
            array_buffer[ 8].%X3 := buf2.PressPretrigger.PreTriggerSource.bit27;
            array_buffer[ 8].%X4 := buf2.PressPretrigger.PreTriggerSource.bit28;
            array_buffer[ 8].%X5 := buf2.PressPretrigger.PreTriggerSource.bit29;
            array_buffer[ 8].%X6 := buf2.PressPretrigger.PreTriggerSource.bit30;
            array_buffer[ 8].%X7 := buf2.PressPretrigger.PreTriggerSource.bit31;
            
            array_buffer[ 9].%X0 := buf2.PressPretrigger.PreTriggerSource.bit16;
            array_buffer[ 9].%X1 := buf2.PressPretrigger.PreTriggerSource.bit17;
            array_buffer[ 9].%X2 := buf2.PressPretrigger.PreTriggerSource.bit18;
            array_buffer[ 9].%X3 := buf2.PressPretrigger.PreTriggerSource.bit19;
            array_buffer[ 9].%X4 := buf2.PressPretrigger.PreTriggerSource.bit20;
            array_buffer[ 9].%X5 := buf2.PressPretrigger.PreTriggerSource.bit21;
            array_buffer[ 9].%X6 := buf2.PressPretrigger.PreTriggerSource.bit22;
            array_buffer[ 9].%X7 := buf2.PressPretrigger.PreTriggerSource.bit23;
            
            array_buffer[10].%X0 := buf2.PressPretrigger.PreTriggerSource.bit8;
            array_buffer[10].%X1 := buf2.PressPretrigger.PreTriggerSource.bit9;
            array_buffer[10].%X2 := buf2.PressPretrigger.PreTriggerSource.bit10;
            array_buffer[10].%X3 := buf2.PressPretrigger.PreTriggerSource.bit11;
            array_buffer[10].%X4 := buf2.PressPretrigger.PreTriggerSource.bit12;
            array_buffer[10].%X5 := buf2.PressPretrigger.PreTriggerSource.bit13;
            array_buffer[10].%X6 := buf2.PressPretrigger.PreTriggerSource.bit14;
            array_buffer[10].%X7 := buf2.PressPretrigger.PreTriggerSource.bit15;
            
            array_buffer[11].%X0 := buf2.PressPretrigger.PreTriggerSource.AutoIn;
            array_buffer[11].%X1 := buf2.PressPretrigger.PreTriggerSource.Position_Switch;
            array_buffer[11].%X2 := buf2.PressPretrigger.PreTriggerSource._Time;
            array_buffer[11].%X3 := buf2.PressPretrigger.PreTriggerSource.Position;
            array_buffer[11].%X4 := buf2.PressPretrigger.PreTriggerSource.bit4;
            array_buffer[11].%X5 := buf2.PressPretrigger.PreTriggerSource.bit5;
            array_buffer[11].%X6 := buf2.PressPretrigger.PreTriggerSource.bit6;
            array_buffer[11].%X7 := buf2.PressPretrigger.PreTriggerSource.Enable_Trigger;
            
            // ---- PressPretrigger (DINTs → bytes 12..27) ----
            array_buffer[12] := TO_BYTE(SHR(TO_DWORD(buf2.PressPretrigger.Ignore1), UINT#24));
            array_buffer[13] := TO_BYTE(SHR(TO_DWORD(buf2.PressPretrigger.Ignore1), UINT#16));
            array_buffer[14] := TO_BYTE(SHR(TO_DWORD(buf2.PressPretrigger.Ignore1),  UINT#8));
            array_buffer[15] := TO_BYTE(     TO_DWORD(buf2.PressPretrigger.Ignore1));
            
            array_buffer[16] := TO_BYTE(SHR(TO_DWORD(buf2.PressPretrigger.Ignore2), UINT#24));
            array_buffer[17] := TO_BYTE(SHR(TO_DWORD(buf2.PressPretrigger.Ignore2), UINT#16));
            array_buffer[18] := TO_BYTE(SHR(TO_DWORD(buf2.PressPretrigger.Ignore2),  UINT#8));
            array_buffer[19] := TO_BYTE(     TO_DWORD(buf2.PressPretrigger.Ignore2));
            
            array_buffer[20] := TO_BYTE(SHR(TO_DWORD(buf2.PressPretrigger.PreTriggerTime), UINT#24));
            array_buffer[21] := TO_BYTE(SHR(TO_DWORD(buf2.PressPretrigger.PreTriggerTime), UINT#16));
            array_buffer[22] := TO_BYTE(SHR(TO_DWORD(buf2.PressPretrigger.PreTriggerTime),  UINT#8));
            array_buffer[23] := TO_BYTE(     TO_DWORD(buf2.PressPretrigger.PreTriggerTime));
            
            array_buffer[24] := TO_BYTE(SHR(TO_DWORD(buf2.PressPretrigger.PreTriggerPosition), UINT#24));
            array_buffer[25] := TO_BYTE(SHR(TO_DWORD(buf2.PressPretrigger.PreTriggerPosition), UINT#16));
            array_buffer[26] := TO_BYTE(SHR(TO_DWORD(buf2.PressPretrigger.PreTriggerPosition),  UINT#8));
            array_buffer[27] := TO_BYTE(     TO_DWORD(buf2.PressPretrigger.PreTriggerPosition));
            
            // ---- PressTrigger.TriggerSource bits → bytes 28..31 ----
            array_buffer[28].%X0 := buf2.PressTrigger.TriggerSource.res_bit24;
            array_buffer[28].%X1 := buf2.PressTrigger.TriggerSource.res_bit25;
            array_buffer[28].%X2 := buf2.PressTrigger.TriggerSource.res_bit26;
            array_buffer[28].%X3 := buf2.PressTrigger.TriggerSource.res_bit27;
            array_buffer[28].%X4 := buf2.PressTrigger.TriggerSource.res_bit28;
            array_buffer[28].%X5 := buf2.PressTrigger.TriggerSource.res_bit29;
            array_buffer[28].%X6 := buf2.PressTrigger.TriggerSource.res_bit30;
            array_buffer[28].%X7 := buf2.PressTrigger.TriggerSource.res_bit31;
            
            array_buffer[29].%X0 := buf2.PressTrigger.TriggerSource.res_bit16;
            array_buffer[29].%X1 := buf2.PressTrigger.TriggerSource.res_bit17;
            array_buffer[29].%X2 := buf2.PressTrigger.TriggerSource.res_bit18;
            array_buffer[29].%X3 := buf2.PressTrigger.TriggerSource.res_bit19;
            array_buffer[29].%X4 := buf2.PressTrigger.TriggerSource.res_bit20;
            array_buffer[29].%X5 := buf2.PressTrigger.TriggerSource.res_bit21;
            array_buffer[29].%X6 := buf2.PressTrigger.TriggerSource.res_bit22;
            array_buffer[29].%X7 := buf2.PressTrigger.TriggerSource.res_bit23;
            
            array_buffer[30].%X0 := buf2.PressTrigger.TriggerSource.res_bit8;
            array_buffer[30].%X1 := buf2.PressTrigger.TriggerSource.res_bit9;
            array_buffer[30].%X2 := buf2.PressTrigger.TriggerSource.res_bit10;
            array_buffer[30].%X3 := buf2.PressTrigger.TriggerSource.res_bit11;
            array_buffer[30].%X4 := buf2.PressTrigger.TriggerSource.res_bit12;
            array_buffer[30].%X5 := buf2.PressTrigger.TriggerSource.res_bit13;
            array_buffer[30].%X6 := buf2.PressTrigger.TriggerSource.res_bit14;
            array_buffer[30].%X7 := buf2.PressTrigger.TriggerSource.Enable_Trigger;
            
            array_buffer[31].%X0 := buf2.PressTrigger.TriggerSource.AutoIn;
            array_buffer[31].%X1 := buf2.PressTrigger.TriggerSource.Position_Switch;
            array_buffer[31].%X2 := buf2.PressTrigger.TriggerSource.res_bit2;
            array_buffer[31].%X3 := buf2.PressTrigger.TriggerSource.Position;
            array_buffer[31].%X4 := buf2.PressTrigger.TriggerSource.res_bit4;
            array_buffer[31].%X5 := buf2.PressTrigger.TriggerSource.Power;
            array_buffer[31].%X6 := buf2.PressTrigger.TriggerSource.res_bit6;
            array_buffer[31].%X7 := buf2.PressTrigger.TriggerSource.res_bit7;
            
            // ---- PressTrigger / Delay (DINTs → bytes 32..51) ----
            array_buffer[32] := TO_BYTE(SHR(TO_DWORD(buf2.PressTrigger.TriggerByPositionLevel), UINT#24));
            array_buffer[33] := TO_BYTE(SHR(TO_DWORD(buf2.PressTrigger.TriggerByPositionLevel), UINT#16));
            array_buffer[34] := TO_BYTE(SHR(TO_DWORD(buf2.PressTrigger.TriggerByPositionLevel),  UINT#8));
            array_buffer[35] := TO_BYTE(     TO_DWORD(buf2.PressTrigger.TriggerByPositionLevel));
            
            array_buffer[36] := TO_BYTE(SHR(TO_DWORD(buf2.PressTriggerDelay.TriggerDelaySource), UINT#24));
            array_buffer[37] := TO_BYTE(SHR(TO_DWORD(buf2.PressTriggerDelay.TriggerDelaySource), UINT#16));
            array_buffer[38] := TO_BYTE(SHR(TO_DWORD(buf2.PressTriggerDelay.TriggerDelaySource),  UINT#8));
            array_buffer[39] := TO_BYTE(     TO_DWORD(buf2.PressTriggerDelay.TriggerDelaySource));
            
            array_buffer[40] := TO_BYTE(SHR(TO_DWORD(buf2.PressTriggerDelay.TriggerDelayTimeout), UINT#24));
            array_buffer[41] := TO_BYTE(SHR(TO_DWORD(buf2.PressTriggerDelay.TriggerDelayTimeout), UINT#16));
            array_buffer[42] := TO_BYTE(SHR(TO_DWORD(buf2.PressTriggerDelay.TriggerDelayTimeout),  UINT#8));
            array_buffer[43] := TO_BYTE(     TO_DWORD(buf2.PressTriggerDelay.TriggerDelayTimeout));
            
            array_buffer[44] := TO_BYTE(SHR(TO_DWORD(buf2.PressTriggerDelay.TriggerDelayTime), UINT#24));
            array_buffer[45] := TO_BYTE(SHR(TO_DWORD(buf2.PressTriggerDelay.TriggerDelayTime), UINT#16));
            array_buffer[46] := TO_BYTE(SHR(TO_DWORD(buf2.PressTriggerDelay.TriggerDelayTime),  UINT#8));
            array_buffer[47] := TO_BYTE(     TO_DWORD(buf2.PressTriggerDelay.TriggerDelayTime));
            
            array_buffer[48] := TO_BYTE(SHR(TO_DWORD(buf2.PressTriggerDelay.TriggerDelayDistance), UINT#24));
            array_buffer[49] := TO_BYTE(SHR(TO_DWORD(buf2.PressTriggerDelay.TriggerDelayDistance), UINT#16));
            array_buffer[50] := TO_BYTE(SHR(TO_DWORD(buf2.PressTriggerDelay.TriggerDelayDistance),  UINT#8));
            array_buffer[51] := TO_BYTE(     TO_DWORD(buf2.PressTriggerDelay.TriggerDelayDistance));
            
            // ---- PressWeld.Weld1Source bits → bytes 52..55 ----
            array_buffer[52].%X0 := buf2.PressWeld.Weld1Source.bit24;
            array_buffer[52].%X1 := buf2.PressWeld.Weld1Source.bit25;
            array_buffer[52].%X2 := buf2.PressWeld.Weld1Source.bit26;
            array_buffer[52].%X3 := buf2.PressWeld.Weld1Source.bit27;
            array_buffer[52].%X4 := buf2.PressWeld.Weld1Source.bit28;
            array_buffer[52].%X5 := buf2.PressWeld.Weld1Source.bit29;
            array_buffer[52].%X6 := buf2.PressWeld.Weld1Source.bit30;
            array_buffer[52].%X7 := buf2.PressWeld.Weld1Source.bit31;
            
            array_buffer[53].%X0 := buf2.PressWeld.Weld1Source.bit16;
            array_buffer[53].%X1 := buf2.PressWeld.Weld1Source.bit17;
            array_buffer[53].%X2 := buf2.PressWeld.Weld1Source.bit18;
            array_buffer[53].%X3 := buf2.PressWeld.Weld1Source.bit19;
            array_buffer[53].%X4 := buf2.PressWeld.Weld1Source.bit20;
            array_buffer[53].%X5 := buf2.PressWeld.Weld1Source.bit21;
            array_buffer[53].%X6 := buf2.PressWeld.Weld1Source.bit22;
            array_buffer[53].%X7 := buf2.PressWeld.Weld1Source.bit23;
            
            array_buffer[54].%X0 := buf2.PressWeld.Weld1Source.bit8;
            array_buffer[54].%X1 := buf2.PressWeld.Weld1Source.bit9;
            array_buffer[54].%X2 := buf2.PressWeld.Weld1Source.bit10;
            array_buffer[54].%X3 := buf2.PressWeld.Weld1Source.bit11;
            array_buffer[54].%X4 := buf2.PressWeld.Weld1Source.bit12;
            array_buffer[54].%X5 := buf2.PressWeld.Weld1Source.bit13;
            array_buffer[54].%X6 := buf2.PressWeld.Weld1Source.bit14;
            array_buffer[54].%X7 := buf2.PressWeld.Weld1Source.Enable_Weld_1;
            
            array_buffer[55].%X0 := buf2.PressWeld.Weld1Source._Time;
            array_buffer[55].%X1 := buf2.PressWeld.Weld1Source.Power;
            array_buffer[55].%X2 := buf2.PressWeld.Weld1Source.Energy;
            array_buffer[55].%X3 := buf2.PressWeld.Weld1Source.Distance;
            array_buffer[55].%X4 := buf2.PressWeld.Weld1Source.Position;
            array_buffer[55].%X5 := buf2.PressWeld.Weld1Source.Ground_Detect;
            array_buffer[55].%X6 := buf2.PressWeld.Weld1Source.Force;
            array_buffer[55].%X7 := buf2.PressWeld.Weld1Source.bit7;
            
            // ---- PressWeld (DINTs → bytes 56..67) ----
            array_buffer[56] := TO_BYTE(SHR(TO_DWORD(buf2.PressWeld.Weld1Timeout), UINT#24));
            array_buffer[57] := TO_BYTE(SHR(TO_DWORD(buf2.PressWeld.Weld1Timeout), UINT#16));
            array_buffer[58] := TO_BYTE(SHR(TO_DWORD(buf2.PressWeld.Weld1Timeout),  UINT#8));
            array_buffer[59] := TO_BYTE(     TO_DWORD(buf2.PressWeld.Weld1Timeout));
            
            array_buffer[60] := TO_BYTE(SHR(TO_DWORD(buf2.PressWeld.Weld1Distance), UINT#24));
            array_buffer[61] := TO_BYTE(SHR(TO_DWORD(buf2.PressWeld.Weld1Distance), UINT#16));
            array_buffer[62] := TO_BYTE(SHR(TO_DWORD(buf2.PressWeld.Weld1Distance),  UINT#8));
            array_buffer[63] := TO_BYTE(     TO_DWORD(buf2.PressWeld.Weld1Distance));
            
            array_buffer[64] := TO_BYTE(SHR(TO_DWORD(buf2.PressWeld.Weld1Position), UINT#24));
            array_buffer[65] := TO_BYTE(SHR(TO_DWORD(buf2.PressWeld.Weld1Position), UINT#16));
            array_buffer[66] := TO_BYTE(SHR(TO_DWORD(buf2.PressWeld.Weld1Position),  UINT#8));
            array_buffer[67] := TO_BYTE(     TO_DWORD(buf2.PressWeld.Weld1Position));
            
            // ---- PressWeld.Weld2Source bits → bytes 68..71 ----
            array_buffer[68].%X0 := buf2.PressWeld.Weld2Source.bit24;
            array_buffer[68].%X1 := buf2.PressWeld.Weld2Source.bit25;
            array_buffer[68].%X2 := buf2.PressWeld.Weld2Source.bit26;
            array_buffer[68].%X3 := buf2.PressWeld.Weld2Source.bit27;
            array_buffer[68].%X4 := buf2.PressWeld.Weld2Source.bit28;
            array_buffer[68].%X5 := buf2.PressWeld.Weld2Source.bit29;
            array_buffer[68].%X6 := buf2.PressWeld.Weld2Source.bit30;
            array_buffer[68].%X7 := buf2.PressWeld.Weld2Source.bit31;
            
            array_buffer[69].%X0 := buf2.PressWeld.Weld2Source.bit16;
            array_buffer[69].%X1 := buf2.PressWeld.Weld2Source.bit17;
            array_buffer[69].%X2 := buf2.PressWeld.Weld2Source.bit18;
            array_buffer[69].%X3 := buf2.PressWeld.Weld2Source.bit19;
            array_buffer[69].%X4 := buf2.PressWeld.Weld2Source.bit20;
            array_buffer[69].%X5 := buf2.PressWeld.Weld2Source.bit21;
            array_buffer[69].%X6 := buf2.PressWeld.Weld2Source.bit22;
            array_buffer[69].%X7 := buf2.PressWeld.Weld2Source.bit23;
            
            array_buffer[70].%X0 := buf2.PressWeld.Weld2Source.bit8;
            array_buffer[70].%X1 := buf2.PressWeld.Weld2Source.bit9;
            array_buffer[70].%X2 := buf2.PressWeld.Weld2Source.bit10;
            array_buffer[70].%X3 := buf2.PressWeld.Weld2Source.bit11;
            array_buffer[70].%X4 := buf2.PressWeld.Weld2Source.bit12;
            array_buffer[70].%X5 := buf2.PressWeld.Weld2Source.bit13;
            array_buffer[70].%X6 := buf2.PressWeld.Weld2Source.bit14;
            array_buffer[70].%X7 := buf2.PressWeld.Weld2Source.Enable_Weld_1;
            
            array_buffer[71].%X0 := buf2.PressWeld.Weld2Source._Time;
            array_buffer[71].%X1 := buf2.PressWeld.Weld2Source.Power;
            array_buffer[71].%X2 := buf2.PressWeld.Weld2Source.Energy;
            array_buffer[71].%X3 := buf2.PressWeld.Weld2Source.Distance;
            array_buffer[71].%X4 := buf2.PressWeld.Weld2Source.Position;
            array_buffer[71].%X5 := buf2.PressWeld.Weld2Source.Ground_Detect;
            array_buffer[71].%X6 := buf2.PressWeld.Weld2Source.Force;
            array_buffer[71].%X7 := buf2.PressWeld.Weld2Source.bit7;
            
            // ---- PressWeld (DINTs → bytes 72..99) ----
            array_buffer[72] := TO_BYTE(SHR(TO_DWORD(buf2.PressWeld.Weld2SecondarySource), UINT#24));
            array_buffer[73] := TO_BYTE(SHR(TO_DWORD(buf2.PressWeld.Weld2SecondarySource), UINT#16));
            array_buffer[74] := TO_BYTE(SHR(TO_DWORD(buf2.PressWeld.Weld2SecondarySource),  UINT#8));
            array_buffer[75] := TO_BYTE(     TO_DWORD(buf2.PressWeld.Weld2SecondarySource));
            
            array_buffer[76] := TO_BYTE(SHR(TO_DWORD(buf2.PressWeld.Weld2Timeout), UINT#24));
            array_buffer[77] := TO_BYTE(SHR(TO_DWORD(buf2.PressWeld.Weld2Timeout), UINT#16));
            array_buffer[78] := TO_BYTE(SHR(TO_DWORD(buf2.PressWeld.Weld2Timeout),  UINT#8));
            array_buffer[79] := TO_BYTE(     TO_DWORD(buf2.PressWeld.Weld2Timeout));
            
            array_buffer[80] := TO_BYTE(SHR(TO_DWORD(buf2.PressWeld.Weld2Time), UINT#24));
            array_buffer[81] := TO_BYTE(SHR(TO_DWORD(buf2.PressWeld.Weld2Time), UINT#16));
            array_buffer[82] := TO_BYTE(SHR(TO_DWORD(buf2.PressWeld.Weld2Time),  UINT#8));
            array_buffer[83] := TO_BYTE(     TO_DWORD(buf2.PressWeld.Weld2Time));
            
            array_buffer[84] := TO_BYTE(SHR(TO_DWORD(buf2.PressWeld.Weld2Energy), UINT#24));
            array_buffer[85] := TO_BYTE(SHR(TO_DWORD(buf2.PressWeld.Weld2Energy), UINT#16));
            array_buffer[86] := TO_BYTE(SHR(TO_DWORD(buf2.PressWeld.Weld2Energy),  UINT#8));
            array_buffer[87] := TO_BYTE(     TO_DWORD(buf2.PressWeld.Weld2Energy));
            
            array_buffer[88] := TO_BYTE(SHR(TO_DWORD(buf2.PressWeld.Weld2Power), UINT#24));
            array_buffer[89] := TO_BYTE(SHR(TO_DWORD(buf2.PressWeld.Weld2Power), UINT#16));
            array_buffer[90] := TO_BYTE(SHR(TO_DWORD(buf2.PressWeld.Weld2Power),  UINT#8));
            array_buffer[91] := TO_BYTE(     TO_DWORD(buf2.PressWeld.Weld2Power));
            
            array_buffer[92] := TO_BYTE(SHR(TO_DWORD(buf2.PressWeld.Weld2Distance), UINT#24));
            array_buffer[93] := TO_BYTE(SHR(TO_DWORD(buf2.PressWeld.Weld2Distance), UINT#16));
            array_buffer[94] := TO_BYTE(SHR(TO_DWORD(buf2.PressWeld.Weld2Distance),  UINT#8));
            array_buffer[95] := TO_BYTE(     TO_DWORD(buf2.PressWeld.Weld2Distance));
            
            array_buffer[96] := TO_BYTE(SHR(TO_DWORD(buf2.PressWeld.Weld2Position), UINT#24));
            array_buffer[97] := TO_BYTE(SHR(TO_DWORD(buf2.PressWeld.Weld2Position), UINT#16));
            array_buffer[98] := TO_BYTE(SHR(TO_DWORD(buf2.PressWeld.Weld2Position),  UINT#8));
            array_buffer[99] := TO_BYTE(     TO_DWORD(buf2.PressWeld.Weld2Position));
            
            // ---- PressWeldScrub (DINTs → bytes 100..107) ----
            array_buffer[100] := TO_BYTE(SHR(TO_DWORD(buf2.PressWeldScrub.ScrubMode), UINT#24));
            array_buffer[101] := TO_BYTE(SHR(TO_DWORD(buf2.PressWeldScrub.ScrubMode), UINT#16));
            array_buffer[102] := TO_BYTE(SHR(TO_DWORD(buf2.PressWeldScrub.ScrubMode),  UINT#8));
            array_buffer[103] := TO_BYTE(     TO_DWORD(buf2.PressWeldScrub.ScrubMode));
            
            array_buffer[104] := TO_BYTE(SHR(TO_DWORD(buf2.PressWeldScrub.ScrubTime), UINT#24));
            array_buffer[105] := TO_BYTE(SHR(TO_DWORD(buf2.PressWeldScrub.ScrubTime), UINT#16));
            array_buffer[106] := TO_BYTE(SHR(TO_DWORD(buf2.PressWeldScrub.ScrubTime),  UINT#8));
            array_buffer[107] := TO_BYTE(     TO_DWORD(buf2.PressWeldScrub.ScrubTime));
            
            // ---- PressPostWeld.DynamicHoldMode bits → bytes 108..111 ----
            array_buffer[108].%X0 := buf2.PressPostWeld.DynamicHoldMode.bit24;
            array_buffer[108].%X1 := buf2.PressPostWeld.DynamicHoldMode.bit25;
            array_buffer[108].%X2 := buf2.PressPostWeld.DynamicHoldMode.bit26;
            array_buffer[108].%X3 := buf2.PressPostWeld.DynamicHoldMode.bit27;
            array_buffer[108].%X4 := buf2.PressPostWeld.DynamicHoldMode.bit28;
            array_buffer[108].%X5 := buf2.PressPostWeld.DynamicHoldMode.bit29;
            array_buffer[108].%X6 := buf2.PressPostWeld.DynamicHoldMode.bit30;
            array_buffer[108].%X7 := buf2.PressPostWeld.DynamicHoldMode.bit31;
            
            array_buffer[109].%X0 := buf2.PressPostWeld.DynamicHoldMode.bit16;
            array_buffer[109].%X1 := buf2.PressPostWeld.DynamicHoldMode.bit17;
            array_buffer[109].%X2 := buf2.PressPostWeld.DynamicHoldMode.bit18;
            array_buffer[109].%X3 := buf2.PressPostWeld.DynamicHoldMode.bit19;
            array_buffer[109].%X4 := buf2.PressPostWeld.DynamicHoldMode.bit20;
            array_buffer[109].%X5 := buf2.PressPostWeld.DynamicHoldMode.bit21;
            array_buffer[109].%X6 := buf2.PressPostWeld.DynamicHoldMode.bit22;
            array_buffer[109].%X7 := buf2.PressPostWeld.DynamicHoldMode.bit23;
            
            array_buffer[110].%X0 := buf2.PressPostWeld.DynamicHoldMode.bit8;
            array_buffer[110].%X1 := buf2.PressPostWeld.DynamicHoldMode.bit9;
            array_buffer[110].%X2 := buf2.PressPostWeld.DynamicHoldMode.bit10;
            array_buffer[110].%X3 := buf2.PressPostWeld.DynamicHoldMode.bit11;
            array_buffer[110].%X4 := buf2.PressPostWeld.DynamicHoldMode.bit12;
            array_buffer[110].%X5 := buf2.PressPostWeld.DynamicHoldMode.bit13;
            array_buffer[110].%X6 := buf2.PressPostWeld.DynamicHoldMode.bit14;
            array_buffer[110].%X7 := buf2.PressPostWeld.DynamicHoldMode.bit15;
            
            array_buffer[111].%X0 := buf2.PressPostWeld.DynamicHoldMode._Time;
            array_buffer[111].%X1 := buf2.PressPostWeld.DynamicHoldMode.Distance;
            array_buffer[111].%X2 := buf2.PressPostWeld.DynamicHoldMode.Force;
            array_buffer[111].%X3 := buf2.PressPostWeld.DynamicHoldMode.AutoIn;
            array_buffer[111].%X4 := buf2.PressPostWeld.DynamicHoldMode.Velocity;
            array_buffer[111].%X5 := buf2.PressPostWeld.DynamicHoldMode.bit5;
            array_buffer[111].%X6 := buf2.PressPostWeld.DynamicHoldMode.bit6;
            array_buffer[111].%X7 := buf2.PressPostWeld.DynamicHoldMode.bit7;
            
            // ---- PressPostWeld (DINTs → bytes 112..135) ----
            array_buffer[112] := TO_BYTE(SHR(TO_DWORD(buf2.PressPostWeld.DynamicHoldTimeout), UINT#24));
            array_buffer[113] := TO_BYTE(SHR(TO_DWORD(buf2.PressPostWeld.DynamicHoldTimeout), UINT#16));
            array_buffer[114] := TO_BYTE(SHR(TO_DWORD(buf2.PressPostWeld.DynamicHoldTimeout),  UINT#8));
            array_buffer[115] := TO_BYTE(     TO_DWORD(buf2.PressPostWeld.DynamicHoldTimeout));
            
            array_buffer[116] := TO_BYTE(SHR(TO_DWORD(buf2.PressPostWeld.DynamicHoldDistance), UINT#24));
            array_buffer[117] := TO_BYTE(SHR(TO_DWORD(buf2.PressPostWeld.DynamicHoldDistance), UINT#16));
            array_buffer[118] := TO_BYTE(SHR(TO_DWORD(buf2.PressPostWeld.DynamicHoldDistance),  UINT#8));
            array_buffer[119] := TO_BYTE(     TO_DWORD(buf2.PressPostWeld.DynamicHoldDistance));
            
            array_buffer[120] := TO_BYTE(SHR(TO_DWORD(buf2.PressPostWeld.DynamicHoldForce), UINT#24));
            array_buffer[121] := TO_BYTE(SHR(TO_DWORD(buf2.PressPostWeld.DynamicHoldForce), UINT#16));
            array_buffer[122] := TO_BYTE(SHR(TO_DWORD(buf2.PressPostWeld.DynamicHoldForce),  UINT#8));
            array_buffer[123] := TO_BYTE(     TO_DWORD(buf2.PressPostWeld.DynamicHoldForce));
            
            array_buffer[124] := TO_BYTE(SHR(TO_DWORD(buf2.PressPostWeld.StaticHoldMode), UINT#24));
            array_buffer[125] := TO_BYTE(SHR(TO_DWORD(buf2.PressPostWeld.StaticHoldMode), UINT#16));
            array_buffer[126] := TO_BYTE(SHR(TO_DWORD(buf2.PressPostWeld.StaticHoldMode),  UINT#8));
            array_buffer[127] := TO_BYTE(     TO_DWORD(buf2.PressPostWeld.StaticHoldMode));
            
            array_buffer[128] := TO_BYTE(SHR(TO_DWORD(buf2.PressPostWeld.StaticHoldTime), UINT#24));
            array_buffer[129] := TO_BYTE(SHR(TO_DWORD(buf2.PressPostWeld.StaticHoldTime), UINT#16));
            array_buffer[130] := TO_BYTE(SHR(TO_DWORD(buf2.PressPostWeld.StaticHoldTime),  UINT#8));
            array_buffer[131] := TO_BYTE(     TO_DWORD(buf2.PressPostWeld.StaticHoldTime));
            
            array_buffer[132] := TO_BYTE(SHR(TO_DWORD(buf2.PressPostWeld.AfterburstAmplitude), UINT#24));
            array_buffer[133] := TO_BYTE(SHR(TO_DWORD(buf2.PressPostWeld.AfterburstAmplitude), UINT#16));
            array_buffer[134] := TO_BYTE(SHR(TO_DWORD(buf2.PressPostWeld.AfterburstAmplitude),  UINT#8));
            array_buffer[135] := TO_BYTE(     TO_DWORD(buf2.PressPostWeld.AfterburstAmplitude));
            
        END_METHOD
            
        METHOD PRIVATE buf3_TO_ByteArray
            VAR_IN_OUT
                buf3 : Axo_IQ_SeriesWelder_data3_180bytes;
                array_buffer : ARRAY[0..253] OF BYTE;
            END_VAR
            
            // ---- TriggerTime.Enable bits → bytes 0..3 ----
            array_buffer[ 0].%X0 := buf3.TriggerTime.Enable._0;
            array_buffer[ 0].%X1 := buf3.TriggerTime.Enable._1;
            array_buffer[ 0].%X2 := buf3.TriggerTime.Enable._2;
            array_buffer[ 0].%X3 := buf3.TriggerTime.Enable._3;
            array_buffer[ 0].%X4 := buf3.TriggerTime.Enable._4;
            array_buffer[ 0].%X5 := buf3.TriggerTime.Enable._5;
            array_buffer[ 0].%X6 := buf3.TriggerTime.Enable._6;
            array_buffer[ 0].%X7 := buf3.TriggerTime.Enable._7;
            
            array_buffer[ 1].%X0 := buf3.TriggerTime.Enable._8;
            array_buffer[ 1].%X1 := buf3.TriggerTime.Enable._9;
            array_buffer[ 1].%X2 := buf3.TriggerTime.Enable._10;
            array_buffer[ 1].%X3 := buf3.TriggerTime.Enable._11;
            array_buffer[ 1].%X4 := buf3.TriggerTime.Enable._12;
            array_buffer[ 1].%X5 := buf3.TriggerTime.Enable._13;
            array_buffer[ 1].%X6 := buf3.TriggerTime.Enable._14;
            array_buffer[ 1].%X7 := buf3.TriggerTime.Enable._15;
            
            array_buffer[ 2].%X0 := buf3.TriggerTime.Enable._16;
            array_buffer[ 2].%X1 := buf3.TriggerTime.Enable._17;
            array_buffer[ 2].%X2 := buf3.TriggerTime.Enable._18;
            array_buffer[ 2].%X3 := buf3.TriggerTime.Enable._19;
            array_buffer[ 2].%X4 := buf3.TriggerTime.Enable._20;
            array_buffer[ 2].%X5 := buf3.TriggerTime.Enable._21;
            array_buffer[ 2].%X6 := buf3.TriggerTime.Enable._22;
            array_buffer[ 2].%X7 := buf3.TriggerTime.Enable._23;
            
            array_buffer[ 3].%X0 := buf3.TriggerTime.Enable.LowerBad_1;
            array_buffer[ 3].%X1 := buf3.TriggerTime.Enable.LowerSuspect_1;
            array_buffer[ 3].%X2 := buf3.TriggerTime.Enable.UpperSuspect_1;
            array_buffer[ 3].%X3 := buf3.TriggerTime.Enable.UpperBad_1;
            array_buffer[ 3].%X4 := buf3.TriggerTime.Enable.Display_1;
            array_buffer[ 3].%X5 := buf3.TriggerTime.Enable._29;
            array_buffer[ 3].%X6 := buf3.TriggerTime.Enable._30;
            array_buffer[ 3].%X7 := buf3.TriggerTime.Enable._31;
            
            // ---- TriggerTime (DINTs) → bytes 4..19 ----
            array_buffer[ 4] := TO_BYTE(SHR(TO_DWORD(buf3.TriggerTime.LowerBad), UINT#24));
            array_buffer[ 5] := TO_BYTE(SHR(TO_DWORD(buf3.TriggerTime.LowerBad), UINT#16));
            array_buffer[ 6] := TO_BYTE(SHR(TO_DWORD(buf3.TriggerTime.LowerBad),  UINT#8));
            array_buffer[ 7] := TO_BYTE(     TO_DWORD(buf3.TriggerTime.LowerBad));
            
            array_buffer[ 8] := TO_BYTE(SHR(TO_DWORD(buf3.TriggerTime.LowerSuspect), UINT#24));
            array_buffer[ 9] := TO_BYTE(SHR(TO_DWORD(buf3.TriggerTime.LowerSuspect), UINT#16));
            array_buffer[10] := TO_BYTE(SHR(TO_DWORD(buf3.TriggerTime.LowerSuspect),  UINT#8));
            array_buffer[11] := TO_BYTE(     TO_DWORD(buf3.TriggerTime.LowerSuspect));
            
            array_buffer[12] := TO_BYTE(SHR(TO_DWORD(buf3.TriggerTime.UpperSuspect), UINT#24));
            array_buffer[13] := TO_BYTE(SHR(TO_DWORD(buf3.TriggerTime.UpperSuspect), UINT#16));
            array_buffer[14] := TO_BYTE(SHR(TO_DWORD(buf3.TriggerTime.UpperSuspect),  UINT#8));
            array_buffer[15] := TO_BYTE(     TO_DWORD(buf3.TriggerTime.UpperSuspect));
            
            array_buffer[16] := TO_BYTE(SHR(TO_DWORD(buf3.TriggerTime.UpperBad), UINT#24));
            array_buffer[17] := TO_BYTE(SHR(TO_DWORD(buf3.TriggerTime.UpperBad), UINT#16));
            array_buffer[18] := TO_BYTE(SHR(TO_DWORD(buf3.TriggerTime.UpperBad),  UINT#8));
            array_buffer[19] := TO_BYTE(     TO_DWORD(buf3.TriggerTime.UpperBad));
            
            // ---- TriggerPosition.Enable bits → bytes 20..23 ----
            array_buffer[20].%X0 := buf3.TriggerPosition.Enable._0;
            array_buffer[20].%X1 := buf3.TriggerPosition.Enable._1;
            array_buffer[20].%X2 := buf3.TriggerPosition.Enable._2;
            array_buffer[20].%X3 := buf3.TriggerPosition.Enable._3;
            array_buffer[20].%X4 := buf3.TriggerPosition.Enable._4;
            array_buffer[20].%X5 := buf3.TriggerPosition.Enable._5;
            array_buffer[20].%X6 := buf3.TriggerPosition.Enable._6;
            array_buffer[20].%X7 := buf3.TriggerPosition.Enable._7;
            
            array_buffer[21].%X0 := buf3.TriggerPosition.Enable._8;
            array_buffer[21].%X1 := buf3.TriggerPosition.Enable._9;
            array_buffer[21].%X2 := buf3.TriggerPosition.Enable._10;
            array_buffer[21].%X3 := buf3.TriggerPosition.Enable._11;
            array_buffer[21].%X4 := buf3.TriggerPosition.Enable._12;
            array_buffer[21].%X5 := buf3.TriggerPosition.Enable._13;
            array_buffer[21].%X6 := buf3.TriggerPosition.Enable._14;
            array_buffer[21].%X7 := buf3.TriggerPosition.Enable._15;
            
            array_buffer[22].%X0 := buf3.TriggerPosition.Enable._16;
            array_buffer[22].%X1 := buf3.TriggerPosition.Enable._17;
            array_buffer[22].%X2 := buf3.TriggerPosition.Enable._18;
            array_buffer[22].%X3 := buf3.TriggerPosition.Enable._19;
            array_buffer[22].%X4 := buf3.TriggerPosition.Enable._20;
            array_buffer[22].%X5 := buf3.TriggerPosition.Enable._21;
            array_buffer[22].%X6 := buf3.TriggerPosition.Enable._22;
            array_buffer[22].%X7 := buf3.TriggerPosition.Enable._23;
            
            array_buffer[23].%X0 := buf3.TriggerPosition.Enable.LowerBad_1;
            array_buffer[23].%X1 := buf3.TriggerPosition.Enable.LowerSuspect_1;
            array_buffer[23].%X2 := buf3.TriggerPosition.Enable.UpperSuspect_1;
            array_buffer[23].%X3 := buf3.TriggerPosition.Enable.UpperBad_1;
            array_buffer[23].%X4 := buf3.TriggerPosition.Enable.Display_1;
            array_buffer[23].%X5 := buf3.TriggerPosition.Enable._29;
            array_buffer[23].%X6 := buf3.TriggerPosition.Enable._30;
            array_buffer[23].%X7 := buf3.TriggerPosition.Enable._31;
            
            // ---- TriggerPosition (DINTs) → bytes 24..39 ----
            array_buffer[24] := TO_BYTE(SHR(TO_DWORD(buf3.TriggerPosition.LowerBad), UINT#24));
            array_buffer[25] := TO_BYTE(SHR(TO_DWORD(buf3.TriggerPosition.LowerBad), UINT#16));
            array_buffer[26] := TO_BYTE(SHR(TO_DWORD(buf3.TriggerPosition.LowerBad),  UINT#8));
            array_buffer[27] := TO_BYTE(     TO_DWORD(buf3.TriggerPosition.LowerBad));
            
            array_buffer[28] := TO_BYTE(SHR(TO_DWORD(buf3.TriggerPosition.LowerSuspect), UINT#24));
            array_buffer[29] := TO_BYTE(SHR(TO_DWORD(buf3.TriggerPosition.LowerSuspect), UINT#16));
            array_buffer[30] := TO_BYTE(SHR(TO_DWORD(buf3.TriggerPosition.LowerSuspect),  UINT#8));
            array_buffer[31] := TO_BYTE(     TO_DWORD(buf3.TriggerPosition.LowerSuspect));
            
            array_buffer[32] := TO_BYTE(SHR(TO_DWORD(buf3.TriggerPosition.UpperSuspect), UINT#24));
            array_buffer[33] := TO_BYTE(SHR(TO_DWORD(buf3.TriggerPosition.UpperSuspect), UINT#16));
            array_buffer[34] := TO_BYTE(SHR(TO_DWORD(buf3.TriggerPosition.UpperSuspect),  UINT#8));
            array_buffer[35] := TO_BYTE(     TO_DWORD(buf3.TriggerPosition.UpperSuspect));
            
            array_buffer[36] := TO_BYTE(SHR(TO_DWORD(buf3.TriggerPosition.UpperBad), UINT#24));
            array_buffer[37] := TO_BYTE(SHR(TO_DWORD(buf3.TriggerPosition.UpperBad), UINT#16));
            array_buffer[38] := TO_BYTE(SHR(TO_DWORD(buf3.TriggerPosition.UpperBad),  UINT#8));
            array_buffer[39] := TO_BYTE(     TO_DWORD(buf3.TriggerPosition.UpperBad));
            
            // ---- TriggerDelayTime.Enable bits → bytes 40..43 ----
            array_buffer[40].%X0 := buf3.TriggerDelayTime.Enable._0;
            array_buffer[40].%X1 := buf3.TriggerDelayTime.Enable._1;
            array_buffer[40].%X2 := buf3.TriggerDelayTime.Enable._2;
            array_buffer[40].%X3 := buf3.TriggerDelayTime.Enable._3;
            array_buffer[40].%X4 := buf3.TriggerDelayTime.Enable._4;
            array_buffer[40].%X5 := buf3.TriggerDelayTime.Enable._5;
            array_buffer[40].%X6 := buf3.TriggerDelayTime.Enable._6;
            array_buffer[40].%X7 := buf3.TriggerDelayTime.Enable._7;
            
            array_buffer[41].%X0 := buf3.TriggerDelayTime.Enable._8;
            array_buffer[41].%X1 := buf3.TriggerDelayTime.Enable._9;
            array_buffer[41].%X2 := buf3.TriggerDelayTime.Enable._10;
            array_buffer[41].%X3 := buf3.TriggerDelayTime.Enable._11;
            array_buffer[41].%X4 := buf3.TriggerDelayTime.Enable._12;
            array_buffer[41].%X5 := buf3.TriggerDelayTime.Enable._13;
            array_buffer[41].%X6 := buf3.TriggerDelayTime.Enable._14;
            array_buffer[41].%X7 := buf3.TriggerDelayTime.Enable._15;
            
            array_buffer[42].%X0 := buf3.TriggerDelayTime.Enable._16;
            array_buffer[42].%X1 := buf3.TriggerDelayTime.Enable._17;
            array_buffer[42].%X2 := buf3.TriggerDelayTime.Enable._18;
            array_buffer[42].%X3 := buf3.TriggerDelayTime.Enable._19;
            array_buffer[42].%X4 := buf3.TriggerDelayTime.Enable._20;
            array_buffer[42].%X5 := buf3.TriggerDelayTime.Enable._21;
            array_buffer[42].%X6 := buf3.TriggerDelayTime.Enable._22;
            array_buffer[42].%X7 := buf3.TriggerDelayTime.Enable._23;
            
            array_buffer[43].%X0 := buf3.TriggerDelayTime.Enable.LowerBad_1;
            array_buffer[43].%X1 := buf3.TriggerDelayTime.Enable.LowerSuspect_1;
            array_buffer[43].%X2 := buf3.TriggerDelayTime.Enable.UpperSuspect_1;
            array_buffer[43].%X3 := buf3.TriggerDelayTime.Enable.UpperBad_1;
            array_buffer[43].%X4 := buf3.TriggerDelayTime.Enable.Display_1;
            array_buffer[43].%X5 := buf3.TriggerDelayTime.Enable._29;
            array_buffer[43].%X6 := buf3.TriggerDelayTime.Enable._30;
            array_buffer[43].%X7 := buf3.TriggerDelayTime.Enable._31;
            
            // ---- TriggerDelayTime (DINTs) → bytes 44..59 ----
            array_buffer[44] := TO_BYTE(SHR(TO_DWORD(buf3.TriggerDelayTime.LowerBad), UINT#24));
            array_buffer[45] := TO_BYTE(SHR(TO_DWORD(buf3.TriggerDelayTime.LowerBad), UINT#16));
            array_buffer[46] := TO_BYTE(SHR(TO_DWORD(buf3.TriggerDelayTime.LowerBad),  UINT#8));
            array_buffer[47] := TO_BYTE(     TO_DWORD(buf3.TriggerDelayTime.LowerBad));
            
            array_buffer[48] := TO_BYTE(SHR(TO_DWORD(buf3.TriggerDelayTime.LowerSuspect), UINT#24));
            array_buffer[49] := TO_BYTE(SHR(TO_DWORD(buf3.TriggerDelayTime.LowerSuspect), UINT#16));
            array_buffer[50] := TO_BYTE(SHR(TO_DWORD(buf3.TriggerDelayTime.LowerSuspect),  UINT#8));
            array_buffer[51] := TO_BYTE(     TO_DWORD(buf3.TriggerDelayTime.LowerSuspect));
            
            array_buffer[52] := TO_BYTE(SHR(TO_DWORD(buf3.TriggerDelayTime.UpperSuspect), UINT#24));
            array_buffer[53] := TO_BYTE(SHR(TO_DWORD(buf3.TriggerDelayTime.UpperSuspect), UINT#16));
            array_buffer[54] := TO_BYTE(SHR(TO_DWORD(buf3.TriggerDelayTime.UpperSuspect),  UINT#8));
            array_buffer[55] := TO_BYTE(     TO_DWORD(buf3.TriggerDelayTime.UpperSuspect));
            
            array_buffer[56] := TO_BYTE(SHR(TO_DWORD(buf3.TriggerDelayTime.UpperBad), UINT#24));
            array_buffer[57] := TO_BYTE(SHR(TO_DWORD(buf3.TriggerDelayTime.UpperBad), UINT#16));
            array_buffer[58] := TO_BYTE(SHR(TO_DWORD(buf3.TriggerDelayTime.UpperBad),  UINT#8));
            array_buffer[59] := TO_BYTE(     TO_DWORD(buf3.TriggerDelayTime.UpperBad));
            
            // ---- TriggerDelayDistance.Enable bits → bytes 60..63 ----
            array_buffer[60].%X0 := buf3.TriggerDelayDistance.Enable._0;
            array_buffer[60].%X1 := buf3.TriggerDelayDistance.Enable._1;
            array_buffer[60].%X2 := buf3.TriggerDelayDistance.Enable._2;
            array_buffer[60].%X3 := buf3.TriggerDelayDistance.Enable._3;
            array_buffer[60].%X4 := buf3.TriggerDelayDistance.Enable._4;
            array_buffer[60].%X5 := buf3.TriggerDelayDistance.Enable._5;
            array_buffer[60].%X6 := buf3.TriggerDelayDistance.Enable._6;
            array_buffer[60].%X7 := buf3.TriggerDelayDistance.Enable._7;
            
            array_buffer[61].%X0 := buf3.TriggerDelayDistance.Enable._8;
            array_buffer[61].%X1 := buf3.TriggerDelayDistance.Enable._9;
            array_buffer[61].%X2 := buf3.TriggerDelayDistance.Enable._10;
            array_buffer[61].%X3 := buf3.TriggerDelayDistance.Enable._11;
            array_buffer[61].%X4 := buf3.TriggerDelayDistance.Enable._12;
            array_buffer[61].%X5 := buf3.TriggerDelayDistance.Enable._13;
            array_buffer[61].%X6 := buf3.TriggerDelayDistance.Enable._14;
            array_buffer[61].%X7 := buf3.TriggerDelayDistance.Enable._15;
            
            array_buffer[62].%X0 := buf3.TriggerDelayDistance.Enable._16;
            array_buffer[62].%X1 := buf3.TriggerDelayDistance.Enable._17;
            array_buffer[62].%X2 := buf3.TriggerDelayDistance.Enable._18;
            array_buffer[62].%X3 := buf3.TriggerDelayDistance.Enable._19;
            array_buffer[62].%X4 := buf3.TriggerDelayDistance.Enable._20;
            array_buffer[62].%X5 := buf3.TriggerDelayDistance.Enable._21;
            array_buffer[62].%X6 := buf3.TriggerDelayDistance.Enable._22;
            array_buffer[62].%X7 := buf3.TriggerDelayDistance.Enable._23;
            
            array_buffer[63].%X0 := buf3.TriggerDelayDistance.Enable.LowerBad_1;
            array_buffer[63].%X1 := buf3.TriggerDelayDistance.Enable.LowerSuspect_1;
            array_buffer[63].%X2 := buf3.TriggerDelayDistance.Enable.UpperSuspect_1;
            array_buffer[63].%X3 := buf3.TriggerDelayDistance.Enable.UpperBad_1;
            array_buffer[63].%X4 := buf3.TriggerDelayDistance.Enable.Display_1;
            array_buffer[63].%X5 := buf3.TriggerDelayDistance.Enable._29;
            array_buffer[63].%X6 := buf3.TriggerDelayDistance.Enable._30;
            array_buffer[63].%X7 := buf3.TriggerDelayDistance.Enable._31;
            
            // ---- TriggerDelayDistance (DINTs) → bytes 64..79 ----
            array_buffer[64] := TO_BYTE(SHR(TO_DWORD(buf3.TriggerDelayDistance.LowerBad), UINT#24));
            array_buffer[65] := TO_BYTE(SHR(TO_DWORD(buf3.TriggerDelayDistance.LowerBad), UINT#16));
            array_buffer[66] := TO_BYTE(SHR(TO_DWORD(buf3.TriggerDelayDistance.LowerBad),  UINT#8));
            array_buffer[67] := TO_BYTE(     TO_DWORD(buf3.TriggerDelayDistance.LowerBad));
            
            array_buffer[68] := TO_BYTE(SHR(TO_DWORD(buf3.TriggerDelayDistance.LowerSuspect), UINT#24));
            array_buffer[69] := TO_BYTE(SHR(TO_DWORD(buf3.TriggerDelayDistance.LowerSuspect), UINT#16));
            array_buffer[70] := TO_BYTE(SHR(TO_DWORD(buf3.TriggerDelayDistance.LowerSuspect),  UINT#8));
            array_buffer[71] := TO_BYTE(     TO_DWORD(buf3.TriggerDelayDistance.LowerSuspect));
            
            array_buffer[72] := TO_BYTE(SHR(TO_DWORD(buf3.TriggerDelayDistance.UpperSuspect), UINT#24));
            array_buffer[73] := TO_BYTE(SHR(TO_DWORD(buf3.TriggerDelayDistance.UpperSuspect), UINT#16));
            array_buffer[74] := TO_BYTE(SHR(TO_DWORD(buf3.TriggerDelayDistance.UpperSuspect),  UINT#8));
            array_buffer[75] := TO_BYTE(     TO_DWORD(buf3.TriggerDelayDistance.UpperSuspect));
            
            array_buffer[76] := TO_BYTE(SHR(TO_DWORD(buf3.TriggerDelayDistance.UpperBad), UINT#24));
            array_buffer[77] := TO_BYTE(SHR(TO_DWORD(buf3.TriggerDelayDistance.UpperBad), UINT#16));
            array_buffer[78] := TO_BYTE(SHR(TO_DWORD(buf3.TriggerDelayDistance.UpperBad),  UINT#8));
            array_buffer[79] := TO_BYTE(     TO_DWORD(buf3.TriggerDelayDistance.UpperBad));
            
            // ---- Weld1Distance.Enable bits → bytes 80..83 ----
            array_buffer[80].%X0 := buf3.Weld1Distance.Enable._0;
            array_buffer[80].%X1 := buf3.Weld1Distance.Enable._1;
            array_buffer[80].%X2 := buf3.Weld1Distance.Enable._2;
            array_buffer[80].%X3 := buf3.Weld1Distance.Enable._3;
            array_buffer[80].%X4 := buf3.Weld1Distance.Enable._4;
            array_buffer[80].%X5 := buf3.Weld1Distance.Enable._5;
            array_buffer[80].%X6 := buf3.Weld1Distance.Enable._6;
            array_buffer[80].%X7 := buf3.Weld1Distance.Enable._7;
            
            array_buffer[81].%X0 := buf3.Weld1Distance.Enable._8;
            array_buffer[81].%X1 := buf3.Weld1Distance.Enable._9;
            array_buffer[81].%X2 := buf3.Weld1Distance.Enable._10;
            array_buffer[81].%X3 := buf3.Weld1Distance.Enable._11;
            array_buffer[81].%X4 := buf3.Weld1Distance.Enable._12;
            array_buffer[81].%X5 := buf3.Weld1Distance.Enable._13;
            array_buffer[81].%X6 := buf3.Weld1Distance.Enable._14;
            array_buffer[81].%X7 := buf3.Weld1Distance.Enable._15;
            
            array_buffer[82].%X0 := buf3.Weld1Distance.Enable._16;
            array_buffer[82].%X1 := buf3.Weld1Distance.Enable._17;
            array_buffer[82].%X2 := buf3.Weld1Distance.Enable._18;
            array_buffer[82].%X3 := buf3.Weld1Distance.Enable._19;
            array_buffer[82].%X4 := buf3.Weld1Distance.Enable._20;
            array_buffer[82].%X5 := buf3.Weld1Distance.Enable._21;
            array_buffer[82].%X6 := buf3.Weld1Distance.Enable._22;
            array_buffer[82].%X7 := buf3.Weld1Distance.Enable._23;
            
            array_buffer[83].%X0 := buf3.Weld1Distance.Enable.LowerBad_1;
            array_buffer[83].%X1 := buf3.Weld1Distance.Enable.LowerSuspect_1;
            array_buffer[83].%X2 := buf3.Weld1Distance.Enable.UpperSuspect_1;
            array_buffer[83].%X3 := buf3.Weld1Distance.Enable.UpperBad_1;
            array_buffer[83].%X4 := buf3.Weld1Distance.Enable.Display_1;
            array_buffer[83].%X5 := buf3.Weld1Distance.Enable._29;
            array_buffer[83].%X6 := buf3.Weld1Distance.Enable._30;
            array_buffer[83].%X7 := buf3.Weld1Distance.Enable._31;
            
            // ---- Weld1Distance (DINTs) → bytes 84..99 ----
            array_buffer[84] := TO_BYTE(SHR(TO_DWORD(buf3.Weld1Distance.LowerBad), UINT#24));
            array_buffer[85] := TO_BYTE(SHR(TO_DWORD(buf3.Weld1Distance.LowerBad), UINT#16));
            array_buffer[86] := TO_BYTE(SHR(TO_DWORD(buf3.Weld1Distance.LowerBad),  UINT#8));
            array_buffer[87] := TO_BYTE(     TO_DWORD(buf3.Weld1Distance.LowerBad));
            
            array_buffer[88] := TO_BYTE(SHR(TO_DWORD(buf3.Weld1Distance.LowerSuspect), UINT#24));
            array_buffer[89] := TO_BYTE(SHR(TO_DWORD(buf3.Weld1Distance.LowerSuspect), UINT#16));
            array_buffer[90] := TO_BYTE(SHR(TO_DWORD(buf3.Weld1Distance.LowerSuspect),  UINT#8));
            array_buffer[91] := TO_BYTE(     TO_DWORD(buf3.Weld1Distance.LowerSuspect));
            
            array_buffer[92] := TO_BYTE(SHR(TO_DWORD(buf3.Weld1Distance.UpperSuspect), UINT#24));
            array_buffer[93] := TO_BYTE(SHR(TO_DWORD(buf3.Weld1Distance.UpperSuspect), UINT#16));
            array_buffer[94] := TO_BYTE(SHR(TO_DWORD(buf3.Weld1Distance.UpperSuspect),  UINT#8));
            array_buffer[95] := TO_BYTE(     TO_DWORD(buf3.Weld1Distance.UpperSuspect));
            
            array_buffer[96] := TO_BYTE(SHR(TO_DWORD(buf3.Weld1Distance.UpperBad), UINT#24));
            array_buffer[97] := TO_BYTE(SHR(TO_DWORD(buf3.Weld1Distance.UpperBad), UINT#16));
            array_buffer[98] := TO_BYTE(SHR(TO_DWORD(buf3.Weld1Distance.UpperBad),  UINT#8));
            array_buffer[99] := TO_BYTE(     TO_DWORD(buf3.Weld1Distance.UpperBad));
            
            // ---- Weld1Position.Enable bits → bytes 100..103 ----
            array_buffer[100].%X0 := buf3.Weld1Position.Enable._0;
            array_buffer[100].%X1 := buf3.Weld1Position.Enable._1;
            array_buffer[100].%X2 := buf3.Weld1Position.Enable._2;
            array_buffer[100].%X3 := buf3.Weld1Position.Enable._3;
            array_buffer[100].%X4 := buf3.Weld1Position.Enable._4;
            array_buffer[100].%X5 := buf3.Weld1Position.Enable._5;
            array_buffer[100].%X6 := buf3.Weld1Position.Enable._6;
            array_buffer[100].%X7 := buf3.Weld1Position.Enable._7;
            
            array_buffer[101].%X0 := buf3.Weld1Position.Enable._8;
            array_buffer[101].%X1 := buf3.Weld1Position.Enable._9;
            array_buffer[101].%X2 := buf3.Weld1Position.Enable._10;
            array_buffer[101].%X3 := buf3.Weld1Position.Enable._11;
            array_buffer[101].%X4 := buf3.Weld1Position.Enable._12;
            array_buffer[101].%X5 := buf3.Weld1Position.Enable._13;
            array_buffer[101].%X6 := buf3.Weld1Position.Enable._14;
            array_buffer[101].%X7 := buf3.Weld1Position.Enable._15;
            
            array_buffer[102].%X0 := buf3.Weld1Position.Enable._16;
            array_buffer[102].%X1 := buf3.Weld1Position.Enable._17;
            array_buffer[102].%X2 := buf3.Weld1Position.Enable._18;
            array_buffer[102].%X3 := buf3.Weld1Position.Enable._19;
            array_buffer[102].%X4 := buf3.Weld1Position.Enable._20;
            array_buffer[102].%X5 := buf3.Weld1Position.Enable._21;
            array_buffer[102].%X6 := buf3.Weld1Position.Enable._22;
            array_buffer[102].%X7 := buf3.Weld1Position.Enable._23;
            
            array_buffer[103].%X0 := buf3.Weld1Position.Enable.LowerBad_1;
            array_buffer[103].%X1 := buf3.Weld1Position.Enable.LowerSuspect_1;
            array_buffer[103].%X2 := buf3.Weld1Position.Enable.UpperSuspect_1;
            array_buffer[103].%X3 := buf3.Weld1Position.Enable.UpperBad_1;
            array_buffer[103].%X4 := buf3.Weld1Position.Enable.Display_1;
            array_buffer[103].%X5 := buf3.Weld1Position.Enable._29;
            array_buffer[103].%X6 := buf3.Weld1Position.Enable._30;
            array_buffer[103].%X7 := buf3.Weld1Position.Enable._31;
            
            // ---- Weld1Position (DINTs) → bytes 104..119 ----
            array_buffer[104] := TO_BYTE(SHR(TO_DWORD(buf3.Weld1Position.LowerBad), UINT#24));
            array_buffer[105] := TO_BYTE(SHR(TO_DWORD(buf3.Weld1Position.LowerBad), UINT#16));
            array_buffer[106] := TO_BYTE(SHR(TO_DWORD(buf3.Weld1Position.LowerBad),  UINT#8));
            array_buffer[107] := TO_BYTE(     TO_DWORD(buf3.Weld1Position.LowerBad));
            
            array_buffer[108] := TO_BYTE(SHR(TO_DWORD(buf3.Weld1Position.LowerSuspect), UINT#24));
            array_buffer[109] := TO_BYTE(SHR(TO_DWORD(buf3.Weld1Position.LowerSuspect), UINT#16));
            array_buffer[110] := TO_BYTE(SHR(TO_DWORD(buf3.Weld1Position.LowerSuspect),  UINT#8));
            array_buffer[111] := TO_BYTE(     TO_DWORD(buf3.Weld1Position.LowerSuspect));
            
            array_buffer[112] := TO_BYTE(SHR(TO_DWORD(buf3.Weld1Position.UpperSuspect), UINT#24));
            array_buffer[113] := TO_BYTE(SHR(TO_DWORD(buf3.Weld1Position.UpperSuspect), UINT#16));
            array_buffer[114] := TO_BYTE(SHR(TO_DWORD(buf3.Weld1Position.UpperSuspect),  UINT#8));
            array_buffer[115] := TO_BYTE(     TO_DWORD(buf3.Weld1Position.UpperSuspect));
            
            array_buffer[116] := TO_BYTE(SHR(TO_DWORD(buf3.Weld1Position.UpperBad), UINT#24));
            array_buffer[117] := TO_BYTE(SHR(TO_DWORD(buf3.Weld1Position.UpperBad), UINT#16));
            array_buffer[118] := TO_BYTE(SHR(TO_DWORD(buf3.Weld1Position.UpperBad),  UINT#8));
            array_buffer[119] := TO_BYTE(     TO_DWORD(buf3.Weld1Position.UpperBad));
            
            // ---- Weld2Time.Enable bits → bytes 120..123 ----
            array_buffer[120].%X0 := buf3.Weld2Time.Enable._0;
            array_buffer[120].%X1 := buf3.Weld2Time.Enable._1;
            array_buffer[120].%X2 := buf3.Weld2Time.Enable._2;
            array_buffer[120].%X3 := buf3.Weld2Time.Enable._3;
            array_buffer[120].%X4 := buf3.Weld2Time.Enable._4;
            array_buffer[120].%X5 := buf3.Weld2Time.Enable._5;
            array_buffer[120].%X6 := buf3.Weld2Time.Enable._6;
            array_buffer[120].%X7 := buf3.Weld2Time.Enable._7;
            
            array_buffer[121].%X0 := buf3.Weld2Time.Enable._8;
            array_buffer[121].%X1 := buf3.Weld2Time.Enable._9;
            array_buffer[121].%X2 := buf3.Weld2Time.Enable._10;
            array_buffer[121].%X3 := buf3.Weld2Time.Enable._11;
            array_buffer[121].%X4 := buf3.Weld2Time.Enable._12;
            array_buffer[121].%X5 := buf3.Weld2Time.Enable._13;
            array_buffer[121].%X6 := buf3.Weld2Time.Enable._14;
            array_buffer[121].%X7 := buf3.Weld2Time.Enable._15;
            
            array_buffer[122].%X0 := buf3.Weld2Time.Enable._16;
            array_buffer[122].%X1 := buf3.Weld2Time.Enable._17;
            array_buffer[122].%X2 := buf3.Weld2Time.Enable._18;
            array_buffer[122].%X3 := buf3.Weld2Time.Enable._19;
            array_buffer[122].%X4 := buf3.Weld2Time.Enable._20;
            array_buffer[122].%X5 := buf3.Weld2Time.Enable._21;
            array_buffer[122].%X6 := buf3.Weld2Time.Enable._22;
            array_buffer[122].%X7 := buf3.Weld2Time.Enable._23;
            
            array_buffer[123].%X0 := buf3.Weld2Time.Enable.LowerBad_1;
            array_buffer[123].%X1 := buf3.Weld2Time.Enable.LowerSuspect_1;
            array_buffer[123].%X2 := buf3.Weld2Time.Enable.UpperSuspect_1;
            array_buffer[123].%X3 := buf3.Weld2Time.Enable.UpperBad_1;
            array_buffer[123].%X4 := buf3.Weld2Time.Enable.Display_1;
            array_buffer[123].%X5 := buf3.Weld2Time.Enable._29;
            array_buffer[123].%X6 := buf3.Weld2Time.Enable._30;
            array_buffer[123].%X7 := buf3.Weld2Time.Enable._31;
            
            // ---- Weld2Time (DINTs) → bytes 124..139 ----
            array_buffer[124] := TO_BYTE(SHR(TO_DWORD(buf3.Weld2Time.LowerBad), UINT#24));
            array_buffer[125] := TO_BYTE(SHR(TO_DWORD(buf3.Weld2Time.LowerBad), UINT#16));
            array_buffer[126] := TO_BYTE(SHR(TO_DWORD(buf3.Weld2Time.LowerBad),  UINT#8));
            array_buffer[127] := TO_BYTE(     TO_DWORD(buf3.Weld2Time.LowerBad));
            
            array_buffer[128] := TO_BYTE(SHR(TO_DWORD(buf3.Weld2Time.LowerSuspect), UINT#24));
            array_buffer[129] := TO_BYTE(SHR(TO_DWORD(buf3.Weld2Time.LowerSuspect), UINT#16));
            array_buffer[130] := TO_BYTE(SHR(TO_DWORD(buf3.Weld2Time.LowerSuspect),  UINT#8));
            array_buffer[131] := TO_BYTE(     TO_DWORD(buf3.Weld2Time.LowerSuspect));
            
            array_buffer[132] := TO_BYTE(SHR(TO_DWORD(buf3.Weld2Time.UpperSuspect), UINT#24));
            array_buffer[133] := TO_BYTE(SHR(TO_DWORD(buf3.Weld2Time.UpperSuspect), UINT#16));
            array_buffer[134] := TO_BYTE(SHR(TO_DWORD(buf3.Weld2Time.UpperSuspect),  UINT#8));
            array_buffer[135] := TO_BYTE(     TO_DWORD(buf3.Weld2Time.UpperSuspect));
            
            array_buffer[136] := TO_BYTE(SHR(TO_DWORD(buf3.Weld2Time.UpperBad), UINT#24));
            array_buffer[137] := TO_BYTE(SHR(TO_DWORD(buf3.Weld2Time.UpperBad), UINT#16));
            array_buffer[138] := TO_BYTE(SHR(TO_DWORD(buf3.Weld2Time.UpperBad),  UINT#8));
            array_buffer[139] := TO_BYTE(     TO_DWORD(buf3.Weld2Time.UpperBad));
            
            // ---- Weld2Energy.Enable bits → bytes 140..143 ----
            array_buffer[140].%X0 := buf3.Weld2Energy.Enable._0;
            array_buffer[140].%X1 := buf3.Weld2Energy.Enable._1;
            array_buffer[140].%X2 := buf3.Weld2Energy.Enable._2;
            array_buffer[140].%X3 := buf3.Weld2Energy.Enable._3;
            array_buffer[140].%X4 := buf3.Weld2Energy.Enable._4;
            array_buffer[140].%X5 := buf3.Weld2Energy.Enable._5;
            array_buffer[140].%X6 := buf3.Weld2Energy.Enable._6;
            array_buffer[140].%X7 := buf3.Weld2Energy.Enable._7;
            
            array_buffer[141].%X0 := buf3.Weld2Energy.Enable._8;
            array_buffer[141].%X1 := buf3.Weld2Energy.Enable._9;
            array_buffer[141].%X2 := buf3.Weld2Energy.Enable._10;
            array_buffer[141].%X3 := buf3.Weld2Energy.Enable._11;
            array_buffer[141].%X4 := buf3.Weld2Energy.Enable._12;
            array_buffer[141].%X5 := buf3.Weld2Energy.Enable._13;
            array_buffer[141].%X6 := buf3.Weld2Energy.Enable._14;
            array_buffer[141].%X7 := buf3.Weld2Energy.Enable._15;
            
            array_buffer[142].%X0 := buf3.Weld2Energy.Enable._16;
            array_buffer[142].%X1 := buf3.Weld2Energy.Enable._17;
            array_buffer[142].%X2 := buf3.Weld2Energy.Enable._18;
            array_buffer[142].%X3 := buf3.Weld2Energy.Enable._19;
            array_buffer[142].%X4 := buf3.Weld2Energy.Enable._20;
            array_buffer[142].%X5 := buf3.Weld2Energy.Enable._21;
            array_buffer[142].%X6 := buf3.Weld2Energy.Enable._22;
            array_buffer[142].%X7 := buf3.Weld2Energy.Enable._23;
            
            array_buffer[143].%X0 := buf3.Weld2Energy.Enable.LowerBad_1;
            array_buffer[143].%X1 := buf3.Weld2Energy.Enable.LowerSuspect_1;
            array_buffer[143].%X2 := buf3.Weld2Energy.Enable.UpperSuspect_1;
            array_buffer[143].%X3 := buf3.Weld2Energy.Enable.UpperBad_1;
            array_buffer[143].%X4 := buf3.Weld2Energy.Enable.Display_1;
            array_buffer[143].%X5 := buf3.Weld2Energy.Enable._29;
            array_buffer[143].%X6 := buf3.Weld2Energy.Enable._30;
            array_buffer[143].%X7 := buf3.Weld2Energy.Enable._31;
            
            // ---- Weld2Energy (DINTs) → bytes 144..159 ----
            array_buffer[144] := TO_BYTE(SHR(TO_DWORD(buf3.Weld2Energy.LowerBad), UINT#24));
            array_buffer[145] := TO_BYTE(SHR(TO_DWORD(buf3.Weld2Energy.LowerBad), UINT#16));
            array_buffer[146] := TO_BYTE(SHR(TO_DWORD(buf3.Weld2Energy.LowerBad),  UINT#8));
            array_buffer[147] := TO_BYTE(     TO_DWORD(buf3.Weld2Energy.LowerBad));
            
            array_buffer[148] := TO_BYTE(SHR(TO_DWORD(buf3.Weld2Energy.LowerSuspect), UINT#24));
            array_buffer[149] := TO_BYTE(SHR(TO_DWORD(buf3.Weld2Energy.LowerSuspect), UINT#16));
            array_buffer[150] := TO_BYTE(SHR(TO_DWORD(buf3.Weld2Energy.LowerSuspect),  UINT#8));
            array_buffer[151] := TO_BYTE(     TO_DWORD(buf3.Weld2Energy.LowerSuspect));
            
            array_buffer[152] := TO_BYTE(SHR(TO_DWORD(buf3.Weld2Energy.UpperSuspect), UINT#24));
            array_buffer[153] := TO_BYTE(SHR(TO_DWORD(buf3.Weld2Energy.UpperSuspect), UINT#16));
            array_buffer[154] := TO_BYTE(SHR(TO_DWORD(buf3.Weld2Energy.UpperSuspect),  UINT#8));
            array_buffer[155] := TO_BYTE(     TO_DWORD(buf3.Weld2Energy.UpperSuspect));
            
            array_buffer[156] := TO_BYTE(SHR(TO_DWORD(buf3.Weld2Energy.UpperBad), UINT#24));
            array_buffer[157] := TO_BYTE(SHR(TO_DWORD(buf3.Weld2Energy.UpperBad), UINT#16));
            array_buffer[158] := TO_BYTE(SHR(TO_DWORD(buf3.Weld2Energy.UpperBad),  UINT#8));
            array_buffer[159] := TO_BYTE(     TO_DWORD(buf3.Weld2Energy.UpperBad));
            
            // ---- Weld2Power.Enable bits → bytes 160..163 ----
            array_buffer[160].%X0 := buf3.Weld2Power.Enable._0;
            array_buffer[160].%X1 := buf3.Weld2Power.Enable._1;
            array_buffer[160].%X2 := buf3.Weld2Power.Enable._2;
            array_buffer[160].%X3 := buf3.Weld2Power.Enable._3;
            array_buffer[160].%X4 := buf3.Weld2Power.Enable._4;
            array_buffer[160].%X5 := buf3.Weld2Power.Enable._5;
            array_buffer[160].%X6 := buf3.Weld2Power.Enable._6;
            array_buffer[160].%X7 := buf3.Weld2Power.Enable._7;
            
            array_buffer[161].%X0 := buf3.Weld2Power.Enable._8;
            array_buffer[161].%X1 := buf3.Weld2Power.Enable._9;
            array_buffer[161].%X2 := buf3.Weld2Power.Enable._10;
            array_buffer[161].%X3 := buf3.Weld2Power.Enable._11;
            array_buffer[161].%X4 := buf3.Weld2Power.Enable._12;
            array_buffer[161].%X5 := buf3.Weld2Power.Enable._13;
            array_buffer[161].%X6 := buf3.Weld2Power.Enable._14;
            array_buffer[161].%X7 := buf3.Weld2Power.Enable._15;
            
            array_buffer[162].%X0 := buf3.Weld2Power.Enable._16;
            array_buffer[162].%X1 := buf3.Weld2Power.Enable._17;
            array_buffer[162].%X2 := buf3.Weld2Power.Enable._18;
            array_buffer[162].%X3 := buf3.Weld2Power.Enable._19;
            array_buffer[162].%X4 := buf3.Weld2Power.Enable._20;
            array_buffer[162].%X5 := buf3.Weld2Power.Enable._21;
            array_buffer[162].%X6 := buf3.Weld2Power.Enable._22;
            array_buffer[162].%X7 := buf3.Weld2Power.Enable._23;
            
            array_buffer[163].%X0 := buf3.Weld2Power.Enable.LowerBad_1;
            array_buffer[163].%X1 := buf3.Weld2Power.Enable.LowerSuspect_1;
            array_buffer[163].%X2 := buf3.Weld2Power.Enable.UpperSuspect_1;
            array_buffer[163].%X3 := buf3.Weld2Power.Enable.UpperBad_1;
            array_buffer[163].%X4 := buf3.Weld2Power.Enable.Display_1;
            array_buffer[163].%X5 := buf3.Weld2Power.Enable._29;
            array_buffer[163].%X6 := buf3.Weld2Power.Enable._30;
            array_buffer[163].%X7 := buf3.Weld2Power.Enable._31;
            
            // ---- Weld2Power (DINTs) → bytes 164..179 ----
            array_buffer[164] := TO_BYTE(SHR(TO_DWORD(buf3.Weld2Power.LowerBad), UINT#24));
            array_buffer[165] := TO_BYTE(SHR(TO_DWORD(buf3.Weld2Power.LowerBad), UINT#16));
            array_buffer[166] := TO_BYTE(SHR(TO_DWORD(buf3.Weld2Power.LowerBad),  UINT#8));
            array_buffer[167] := TO_BYTE(     TO_DWORD(buf3.Weld2Power.LowerBad));
            
            array_buffer[168] := TO_BYTE(SHR(TO_DWORD(buf3.Weld2Power.LowerSuspect), UINT#24));
            array_buffer[169] := TO_BYTE(SHR(TO_DWORD(buf3.Weld2Power.LowerSuspect), UINT#16));
            array_buffer[170] := TO_BYTE(SHR(TO_DWORD(buf3.Weld2Power.LowerSuspect),  UINT#8));
            array_buffer[171] := TO_BYTE(     TO_DWORD(buf3.Weld2Power.LowerSuspect));
            
            array_buffer[172] := TO_BYTE(SHR(TO_DWORD(buf3.Weld2Power.UpperSuspect), UINT#24));
            array_buffer[173] := TO_BYTE(SHR(TO_DWORD(buf3.Weld2Power.UpperSuspect), UINT#16));
            array_buffer[174] := TO_BYTE(SHR(TO_DWORD(buf3.Weld2Power.UpperSuspect),  UINT#8));
            array_buffer[175] := TO_BYTE(     TO_DWORD(buf3.Weld2Power.UpperSuspect));
            
            array_buffer[176] := TO_BYTE(SHR(TO_DWORD(buf3.Weld2Power.UpperBad), UINT#24));
            array_buffer[177] := TO_BYTE(SHR(TO_DWORD(buf3.Weld2Power.UpperBad), UINT#16));
            array_buffer[178] := TO_BYTE(SHR(TO_DWORD(buf3.Weld2Power.UpperBad),  UINT#8));
            array_buffer[179] := TO_BYTE(     TO_DWORD(buf3.Weld2Power.UpperBad));
            
        END_METHOD
            
        METHOD PRIVATE buf4_TO_ByteArray
            VAR_IN_OUT
                buf4 : Axo_IQ_SeriesWelder_data4_200bytes;
                array_buffer : ARRAY[0..253] OF BYTE;
            END_VAR
            
            // ---- Weld2Distance.Enable bits → bytes 0..3 ----
            array_buffer[ 0].%X0 := buf4.Weld2Distance.Enable._0;
            array_buffer[ 0].%X1 := buf4.Weld2Distance.Enable._1;
            array_buffer[ 0].%X2 := buf4.Weld2Distance.Enable._2;
            array_buffer[ 0].%X3 := buf4.Weld2Distance.Enable._3;
            array_buffer[ 0].%X4 := buf4.Weld2Distance.Enable._4;
            array_buffer[ 0].%X5 := buf4.Weld2Distance.Enable._5;
            array_buffer[ 0].%X6 := buf4.Weld2Distance.Enable._6;
            array_buffer[ 0].%X7 := buf4.Weld2Distance.Enable._7;
            
            array_buffer[ 1].%X0 := buf4.Weld2Distance.Enable._8;
            array_buffer[ 1].%X1 := buf4.Weld2Distance.Enable._9;
            array_buffer[ 1].%X2 := buf4.Weld2Distance.Enable._10;
            array_buffer[ 1].%X3 := buf4.Weld2Distance.Enable._11;
            array_buffer[ 1].%X4 := buf4.Weld2Distance.Enable._12;
            array_buffer[ 1].%X5 := buf4.Weld2Distance.Enable._13;
            array_buffer[ 1].%X6 := buf4.Weld2Distance.Enable._14;
            array_buffer[ 1].%X7 := buf4.Weld2Distance.Enable._15;
            
            array_buffer[ 2].%X0 := buf4.Weld2Distance.Enable._16;
            array_buffer[ 2].%X1 := buf4.Weld2Distance.Enable._17;
            array_buffer[ 2].%X2 := buf4.Weld2Distance.Enable._18;
            array_buffer[ 2].%X3 := buf4.Weld2Distance.Enable._19;
            array_buffer[ 2].%X4 := buf4.Weld2Distance.Enable._20;
            array_buffer[ 2].%X5 := buf4.Weld2Distance.Enable._21;
            array_buffer[ 2].%X6 := buf4.Weld2Distance.Enable._22;
            array_buffer[ 2].%X7 := buf4.Weld2Distance.Enable._23;
            
            array_buffer[ 3].%X0 := buf4.Weld2Distance.Enable.LowerBad_1;
            array_buffer[ 3].%X1 := buf4.Weld2Distance.Enable.LowerSuspect_1;
            array_buffer[ 3].%X2 := buf4.Weld2Distance.Enable.UpperSuspect_1;
            array_buffer[ 3].%X3 := buf4.Weld2Distance.Enable.UpperBad_1;
            array_buffer[ 3].%X4 := buf4.Weld2Distance.Enable.Display_1;
            array_buffer[ 3].%X5 := buf4.Weld2Distance.Enable._29;
            array_buffer[ 3].%X6 := buf4.Weld2Distance.Enable._30;
            array_buffer[ 3].%X7 := buf4.Weld2Distance.Enable._31;
            
            // ---- Weld2Distance (DINTs) → bytes 4..19 ----
            array_buffer[ 4] := TO_BYTE(SHR(TO_DWORD(buf4.Weld2Distance.LowerBad), UINT#24));
            array_buffer[ 5] := TO_BYTE(SHR(TO_DWORD(buf4.Weld2Distance.LowerBad), UINT#16));
            array_buffer[ 6] := TO_BYTE(SHR(TO_DWORD(buf4.Weld2Distance.LowerBad),  UINT#8));
            array_buffer[ 7] := TO_BYTE(     TO_DWORD(buf4.Weld2Distance.LowerBad));
            
            array_buffer[ 8] := TO_BYTE(SHR(TO_DWORD(buf4.Weld2Distance.LowerSuspect), UINT#24));
            array_buffer[ 9] := TO_BYTE(SHR(TO_DWORD(buf4.Weld2Distance.LowerSuspect), UINT#16));
            array_buffer[10] := TO_BYTE(SHR(TO_DWORD(buf4.Weld2Distance.LowerSuspect),  UINT#8));
            array_buffer[11] := TO_BYTE(     TO_DWORD(buf4.Weld2Distance.LowerSuspect));
            
            array_buffer[12] := TO_BYTE(SHR(TO_DWORD(buf4.Weld2Distance.UpperSuspect), UINT#24));
            array_buffer[13] := TO_BYTE(SHR(TO_DWORD(buf4.Weld2Distance.UpperSuspect), UINT#16));
            array_buffer[14] := TO_BYTE(SHR(TO_DWORD(buf4.Weld2Distance.UpperSuspect),  UINT#8));
            array_buffer[15] := TO_BYTE(     TO_DWORD(buf4.Weld2Distance.UpperSuspect));
            
            array_buffer[16] := TO_BYTE(SHR(TO_DWORD(buf4.Weld2Distance.UpperBad), UINT#24));
            array_buffer[17] := TO_BYTE(SHR(TO_DWORD(buf4.Weld2Distance.UpperBad), UINT#16));
            array_buffer[18] := TO_BYTE(SHR(TO_DWORD(buf4.Weld2Distance.UpperBad),  UINT#8));
            array_buffer[19] := TO_BYTE(     TO_DWORD(buf4.Weld2Distance.UpperBad));
            
            // ---- Weld2Position.Enable bits → bytes 20..23 ----
            array_buffer[20].%X0 := buf4.Weld2Position.Enable._0;
            array_buffer[20].%X1 := buf4.Weld2Position.Enable._1;
            array_buffer[20].%X2 := buf4.Weld2Position.Enable._2;
            array_buffer[20].%X3 := buf4.Weld2Position.Enable._3;
            array_buffer[20].%X4 := buf4.Weld2Position.Enable._4;
            array_buffer[20].%X5 := buf4.Weld2Position.Enable._5;
            array_buffer[20].%X6 := buf4.Weld2Position.Enable._6;
            array_buffer[20].%X7 := buf4.Weld2Position.Enable._7;
            
            array_buffer[21].%X0 := buf4.Weld2Position.Enable._8;
            array_buffer[21].%X1 := buf4.Weld2Position.Enable._9;
            array_buffer[21].%X2 := buf4.Weld2Position.Enable._10;
            array_buffer[21].%X3 := buf4.Weld2Position.Enable._11;
            array_buffer[21].%X4 := buf4.Weld2Position.Enable._12;
            array_buffer[21].%X5 := buf4.Weld2Position.Enable._13;
            array_buffer[21].%X6 := buf4.Weld2Position.Enable._14;
            array_buffer[21].%X7 := buf4.Weld2Position.Enable._15;
            
            array_buffer[22].%X0 := buf4.Weld2Position.Enable._16;
            array_buffer[22].%X1 := buf4.Weld2Position.Enable._17;
            array_buffer[22].%X2 := buf4.Weld2Position.Enable._18;
            array_buffer[22].%X3 := buf4.Weld2Position.Enable._19;
            array_buffer[22].%X4 := buf4.Weld2Position.Enable._20;
            array_buffer[22].%X5 := buf4.Weld2Position.Enable._21;
            array_buffer[22].%X6 := buf4.Weld2Position.Enable._22;
            array_buffer[22].%X7 := buf4.Weld2Position.Enable._23;
            
            array_buffer[23].%X0 := buf4.Weld2Position.Enable.LowerBad_1;
            array_buffer[23].%X1 := buf4.Weld2Position.Enable.LowerSuspect_1;
            array_buffer[23].%X2 := buf4.Weld2Position.Enable.UpperSuspect_1;
            array_buffer[23].%X3 := buf4.Weld2Position.Enable.UpperBad_1;
            array_buffer[23].%X4 := buf4.Weld2Position.Enable.Display_1;
            array_buffer[23].%X5 := buf4.Weld2Position.Enable._29;
            array_buffer[23].%X6 := buf4.Weld2Position.Enable._30;
            array_buffer[23].%X7 := buf4.Weld2Position.Enable._31;
            
            // ---- Weld2Position (DINTs) → bytes 24..39 ----
            array_buffer[24] := TO_BYTE(SHR(TO_DWORD(buf4.Weld2Position.LowerBad), UINT#24));
            array_buffer[25] := TO_BYTE(SHR(TO_DWORD(buf4.Weld2Position.LowerBad), UINT#16));
            array_buffer[26] := TO_BYTE(SHR(TO_DWORD(buf4.Weld2Position.LowerBad),  UINT#8));
            array_buffer[27] := TO_BYTE(     TO_DWORD(buf4.Weld2Position.LowerBad));
            
            array_buffer[28] := TO_BYTE(SHR(TO_DWORD(buf4.Weld2Position.LowerSuspect), UINT#24));
            array_buffer[29] := TO_BYTE(SHR(TO_DWORD(buf4.Weld2Position.LowerSuspect), UINT#16));
            array_buffer[30] := TO_BYTE(SHR(TO_DWORD(buf4.Weld2Position.LowerSuspect),  UINT#8));
            array_buffer[31] := TO_BYTE(     TO_DWORD(buf4.Weld2Position.LowerSuspect));
            
            array_buffer[32] := TO_BYTE(SHR(TO_DWORD(buf4.Weld2Position.UpperSuspect), UINT#24));
            array_buffer[33] := TO_BYTE(SHR(TO_DWORD(buf4.Weld2Position.UpperSuspect), UINT#16));
            array_buffer[34] := TO_BYTE(SHR(TO_DWORD(buf4.Weld2Position.UpperSuspect),  UINT#8));
            array_buffer[35] := TO_BYTE(     TO_DWORD(buf4.Weld2Position.UpperSuspect));
            
            array_buffer[36] := TO_BYTE(SHR(TO_DWORD(buf4.Weld2Position.UpperBad), UINT#24));
            array_buffer[37] := TO_BYTE(SHR(TO_DWORD(buf4.Weld2Position.UpperBad), UINT#16));
            array_buffer[38] := TO_BYTE(SHR(TO_DWORD(buf4.Weld2Position.UpperBad),  UINT#8));
            array_buffer[39] := TO_BYTE(     TO_DWORD(buf4.Weld2Position.UpperBad));
            
            // ---- TotalWeldTime.Enable bits → bytes 40..43 ----
            array_buffer[40].%X0 := buf4.TotalWeldTime.Enable._0;
            array_buffer[40].%X1 := buf4.TotalWeldTime.Enable._1;
            array_buffer[40].%X2 := buf4.TotalWeldTime.Enable._2;
            array_buffer[40].%X3 := buf4.TotalWeldTime.Enable._3;
            array_buffer[40].%X4 := buf4.TotalWeldTime.Enable._4;
            array_buffer[40].%X5 := buf4.TotalWeldTime.Enable._5;
            array_buffer[40].%X6 := buf4.TotalWeldTime.Enable._6;
            array_buffer[40].%X7 := buf4.TotalWeldTime.Enable._7;
            
            array_buffer[41].%X0 := buf4.TotalWeldTime.Enable._8;
            array_buffer[41].%X1 := buf4.TotalWeldTime.Enable._9;
            array_buffer[41].%X2 := buf4.TotalWeldTime.Enable._10;
            array_buffer[41].%X3 := buf4.TotalWeldTime.Enable._11;
            array_buffer[41].%X4 := buf4.TotalWeldTime.Enable._12;
            array_buffer[41].%X5 := buf4.TotalWeldTime.Enable._13;
            array_buffer[41].%X6 := buf4.TotalWeldTime.Enable._14;
            array_buffer[41].%X7 := buf4.TotalWeldTime.Enable._15;
            
            array_buffer[42].%X0 := buf4.TotalWeldTime.Enable._16;
            array_buffer[42].%X1 := buf4.TotalWeldTime.Enable._17;
            array_buffer[42].%X2 := buf4.TotalWeldTime.Enable._18;
            array_buffer[42].%X3 := buf4.TotalWeldTime.Enable._19;
            array_buffer[42].%X4 := buf4.TotalWeldTime.Enable._20;
            array_buffer[42].%X5 := buf4.TotalWeldTime.Enable._21;
            array_buffer[42].%X6 := buf4.TotalWeldTime.Enable._22;
            array_buffer[42].%X7 := buf4.TotalWeldTime.Enable._23;
            
            array_buffer[43].%X0 := buf4.TotalWeldTime.Enable.LowerBad_1;
            array_buffer[43].%X1 := buf4.TotalWeldTime.Enable.LowerSuspect_1;
            array_buffer[43].%X2 := buf4.TotalWeldTime.Enable.UpperSuspect_1;
            array_buffer[43].%X3 := buf4.TotalWeldTime.Enable.UpperBad_1;
            array_buffer[43].%X4 := buf4.TotalWeldTime.Enable.Display_1;
            array_buffer[43].%X5 := buf4.TotalWeldTime.Enable._29;
            array_buffer[43].%X6 := buf4.TotalWeldTime.Enable._30;
            array_buffer[43].%X7 := buf4.TotalWeldTime.Enable._31;
            
            // ---- TotalWeldTime (DINTs) → bytes 44..59 ----
            array_buffer[44] := TO_BYTE(SHR(TO_DWORD(buf4.TotalWeldTime.LowerBad), UINT#24));
            array_buffer[45] := TO_BYTE(SHR(TO_DWORD(buf4.TotalWeldTime.LowerBad), UINT#16));
            array_buffer[46] := TO_BYTE(SHR(TO_DWORD(buf4.TotalWeldTime.LowerBad),  UINT#8));
            array_buffer[47] := TO_BYTE(     TO_DWORD(buf4.TotalWeldTime.LowerBad));
            
            array_buffer[48] := TO_BYTE(SHR(TO_DWORD(buf4.TotalWeldTime.LowerSuspect), UINT#24));
            array_buffer[49] := TO_BYTE(SHR(TO_DWORD(buf4.TotalWeldTime.LowerSuspect), UINT#16));
            array_buffer[50] := TO_BYTE(SHR(TO_DWORD(buf4.TotalWeldTime.LowerSuspect),  UINT#8));
            array_buffer[51] := TO_BYTE(     TO_DWORD(buf4.TotalWeldTime.LowerSuspect));
            
            array_buffer[52] := TO_BYTE(SHR(TO_DWORD(buf4.TotalWeldTime.UpperSuspect), UINT#24));
            array_buffer[53] := TO_BYTE(SHR(TO_DWORD(buf4.TotalWeldTime.UpperSuspect), UINT#16));
            array_buffer[54] := TO_BYTE(SHR(TO_DWORD(buf4.TotalWeldTime.UpperSuspect),  UINT#8));
            array_buffer[55] := TO_BYTE(     TO_DWORD(buf4.TotalWeldTime.UpperSuspect));
            
            array_buffer[56] := TO_BYTE(SHR(TO_DWORD(buf4.TotalWeldTime.UpperBad), UINT#24));
            array_buffer[57] := TO_BYTE(SHR(TO_DWORD(buf4.TotalWeldTime.UpperBad), UINT#16));
            array_buffer[58] := TO_BYTE(SHR(TO_DWORD(buf4.TotalWeldTime.UpperBad),  UINT#8));
            array_buffer[59] := TO_BYTE(     TO_DWORD(buf4.TotalWeldTime.UpperBad));
            
            // ---- TotalWeldEnergy.Enable bits → bytes 60..63 ----
            array_buffer[60].%X0 := buf4.TotalWeldEnergy.Enable._0;
            array_buffer[60].%X1 := buf4.TotalWeldEnergy.Enable._1;
            array_buffer[60].%X2 := buf4.TotalWeldEnergy.Enable._2;
            array_buffer[60].%X3 := buf4.TotalWeldEnergy.Enable._3;
            array_buffer[60].%X4 := buf4.TotalWeldEnergy.Enable._4;
            array_buffer[60].%X5 := buf4.TotalWeldEnergy.Enable._5;
            array_buffer[60].%X6 := buf4.TotalWeldEnergy.Enable._6;
            array_buffer[60].%X7 := buf4.TotalWeldEnergy.Enable._7;
            
            array_buffer[61].%X0 := buf4.TotalWeldEnergy.Enable._8;
            array_buffer[61].%X1 := buf4.TotalWeldEnergy.Enable._9;
            array_buffer[61].%X2 := buf4.TotalWeldEnergy.Enable._10;
            array_buffer[61].%X3 := buf4.TotalWeldEnergy.Enable._11;
            array_buffer[61].%X4 := buf4.TotalWeldEnergy.Enable._12;
            array_buffer[61].%X5 := buf4.TotalWeldEnergy.Enable._13;
            array_buffer[61].%X6 := buf4.TotalWeldEnergy.Enable._14;
            array_buffer[61].%X7 := buf4.TotalWeldEnergy.Enable._15;
            
            array_buffer[62].%X0 := buf4.TotalWeldEnergy.Enable._16;
            array_buffer[62].%X1 := buf4.TotalWeldEnergy.Enable._17;
            array_buffer[62].%X2 := buf4.TotalWeldEnergy.Enable._18;
            array_buffer[62].%X3 := buf4.TotalWeldEnergy.Enable._19;
            array_buffer[62].%X4 := buf4.TotalWeldEnergy.Enable._20;
            array_buffer[62].%X5 := buf4.TotalWeldEnergy.Enable._21;
            array_buffer[62].%X6 := buf4.TotalWeldEnergy.Enable._22;
            array_buffer[62].%X7 := buf4.TotalWeldEnergy.Enable._23;
            
            array_buffer[63].%X0 := buf4.TotalWeldEnergy.Enable.LowerBad_1;
            array_buffer[63].%X1 := buf4.TotalWeldEnergy.Enable.LowerSuspect_1;
            array_buffer[63].%X2 := buf4.TotalWeldEnergy.Enable.UpperSuspect_1;
            array_buffer[63].%X3 := buf4.TotalWeldEnergy.Enable.UpperBad_1;
            array_buffer[63].%X4 := buf4.TotalWeldEnergy.Enable.Display_1;
            array_buffer[63].%X5 := buf4.TotalWeldEnergy.Enable._29;
            array_buffer[63].%X6 := buf4.TotalWeldEnergy.Enable._30;
            array_buffer[63].%X7 := buf4.TotalWeldEnergy.Enable._31;
            
            // ---- TotalWeldEnergy (DINTs) → bytes 64..79 ----
            array_buffer[64] := TO_BYTE(SHR(TO_DWORD(buf4.TotalWeldEnergy.LowerBad), UINT#24));
            array_buffer[65] := TO_BYTE(SHR(TO_DWORD(buf4.TotalWeldEnergy.LowerBad), UINT#16));
            array_buffer[66] := TO_BYTE(SHR(TO_DWORD(buf4.TotalWeldEnergy.LowerBad),  UINT#8));
            array_buffer[67] := TO_BYTE(     TO_DWORD(buf4.TotalWeldEnergy.LowerBad));
            
            array_buffer[68] := TO_BYTE(SHR(TO_DWORD(buf4.TotalWeldEnergy.LowerSuspect), UINT#24));
            array_buffer[69] := TO_BYTE(SHR(TO_DWORD(buf4.TotalWeldEnergy.LowerSuspect), UINT#16));
            array_buffer[70] := TO_BYTE(SHR(TO_DWORD(buf4.TotalWeldEnergy.LowerSuspect),  UINT#8));
            array_buffer[71] := TO_BYTE(     TO_DWORD(buf4.TotalWeldEnergy.LowerSuspect));
            
            array_buffer[72] := TO_BYTE(SHR(TO_DWORD(buf4.TotalWeldEnergy.UpperSuspect), UINT#24));
            array_buffer[73] := TO_BYTE(SHR(TO_DWORD(buf4.TotalWeldEnergy.UpperSuspect), UINT#16));
            array_buffer[74] := TO_BYTE(SHR(TO_DWORD(buf4.TotalWeldEnergy.UpperSuspect),  UINT#8));
            array_buffer[75] := TO_BYTE(     TO_DWORD(buf4.TotalWeldEnergy.UpperSuspect));
            
            array_buffer[76] := TO_BYTE(SHR(TO_DWORD(buf4.TotalWeldEnergy.UpperBad), UINT#24));
            array_buffer[77] := TO_BYTE(SHR(TO_DWORD(buf4.TotalWeldEnergy.UpperBad), UINT#16));
            array_buffer[78] := TO_BYTE(SHR(TO_DWORD(buf4.TotalWeldEnergy.UpperBad),  UINT#8));
            array_buffer[79] := TO_BYTE(     TO_DWORD(buf4.TotalWeldEnergy.UpperBad));
            
            // ---- TotalWeldDistance.Enable bits → bytes 80..83 ----
            array_buffer[80].%X0 := buf4.TotalWeldDistance.Enable._0;
            array_buffer[80].%X1 := buf4.TotalWeldDistance.Enable._1;
            array_buffer[80].%X2 := buf4.TotalWeldDistance.Enable._2;
            array_buffer[80].%X3 := buf4.TotalWeldDistance.Enable._3;
            array_buffer[80].%X4 := buf4.TotalWeldDistance.Enable._4;
            array_buffer[80].%X5 := buf4.TotalWeldDistance.Enable._5;
            array_buffer[80].%X6 := buf4.TotalWeldDistance.Enable._6;
            array_buffer[80].%X7 := buf4.TotalWeldDistance.Enable._7;
            
            array_buffer[81].%X0 := buf4.TotalWeldDistance.Enable._8;
            array_buffer[81].%X1 := buf4.TotalWeldDistance.Enable._9;
            array_buffer[81].%X2 := buf4.TotalWeldDistance.Enable._10;
            array_buffer[81].%X3 := buf4.TotalWeldDistance.Enable._11;
            array_buffer[81].%X4 := buf4.TotalWeldDistance.Enable._12;
            array_buffer[81].%X5 := buf4.TotalWeldDistance.Enable._13;
            array_buffer[81].%X6 := buf4.TotalWeldDistance.Enable._14;
            array_buffer[81].%X7 := buf4.TotalWeldDistance.Enable._15;
            
            array_buffer[82].%X0 := buf4.TotalWeldDistance.Enable._16;
            array_buffer[82].%X1 := buf4.TotalWeldDistance.Enable._17;
            array_buffer[82].%X2 := buf4.TotalWeldDistance.Enable._18;
            array_buffer[82].%X3 := buf4.TotalWeldDistance.Enable._19;
            array_buffer[82].%X4 := buf4.TotalWeldDistance.Enable._20;
            array_buffer[82].%X5 := buf4.TotalWeldDistance.Enable._21;
            array_buffer[82].%X6 := buf4.TotalWeldDistance.Enable._22;
            array_buffer[82].%X7 := buf4.TotalWeldDistance.Enable._23;
            
            array_buffer[83].%X0 := buf4.TotalWeldDistance.Enable.LowerBad_1;
            array_buffer[83].%X1 := buf4.TotalWeldDistance.Enable.LowerSuspect_1;
            array_buffer[83].%X2 := buf4.TotalWeldDistance.Enable.UpperSuspect_1;
            array_buffer[83].%X3 := buf4.TotalWeldDistance.Enable.UpperBad_1;
            array_buffer[83].%X4 := buf4.TotalWeldDistance.Enable.Display_1;
            array_buffer[83].%X5 := buf4.TotalWeldDistance.Enable._29;
            array_buffer[83].%X6 := buf4.TotalWeldDistance.Enable._30;
            array_buffer[83].%X7 := buf4.TotalWeldDistance.Enable._31;
            
            // ---- TotalWeldDistance (DINTs) → bytes 84..99 ----
            array_buffer[84] := TO_BYTE(SHR(TO_DWORD(buf4.TotalWeldDistance.LowerBad), UINT#24));
            array_buffer[85] := TO_BYTE(SHR(TO_DWORD(buf4.TotalWeldDistance.LowerBad), UINT#16));
            array_buffer[86] := TO_BYTE(SHR(TO_DWORD(buf4.TotalWeldDistance.LowerBad),  UINT#8));
            array_buffer[87] := TO_BYTE(     TO_DWORD(buf4.TotalWeldDistance.LowerBad));
            
            array_buffer[88] := TO_BYTE(SHR(TO_DWORD(buf4.TotalWeldDistance.LowerSuspect), UINT#24));
            array_buffer[89] := TO_BYTE(SHR(TO_DWORD(buf4.TotalWeldDistance.LowerSuspect), UINT#16));
            array_buffer[90] := TO_BYTE(SHR(TO_DWORD(buf4.TotalWeldDistance.LowerSuspect),  UINT#8));
            array_buffer[91] := TO_BYTE(     TO_DWORD(buf4.TotalWeldDistance.LowerSuspect));
            
            array_buffer[92] := TO_BYTE(SHR(TO_DWORD(buf4.TotalWeldDistance.UpperSuspect), UINT#24));
            array_buffer[93] := TO_BYTE(SHR(TO_DWORD(buf4.TotalWeldDistance.UpperSuspect), UINT#16));
            array_buffer[94] := TO_BYTE(SHR(TO_DWORD(buf4.TotalWeldDistance.UpperSuspect),  UINT#8));
            array_buffer[95] := TO_BYTE(     TO_DWORD(buf4.TotalWeldDistance.UpperSuspect));
            
            array_buffer[96] := TO_BYTE(SHR(TO_DWORD(buf4.TotalWeldDistance.UpperBad), UINT#24));
            array_buffer[97] := TO_BYTE(SHR(TO_DWORD(buf4.TotalWeldDistance.UpperBad), UINT#16));
            array_buffer[98] := TO_BYTE(SHR(TO_DWORD(buf4.TotalWeldDistance.UpperBad),  UINT#8));
            array_buffer[99] := TO_BYTE(     TO_DWORD(buf4.TotalWeldDistance.UpperBad));
            
            // ---- DynamicHoldTime.Enable bits → bytes 100..103 ----
            array_buffer[100].%X0 := buf4.DynamicHoldTime.Enable._0;
            array_buffer[100].%X1 := buf4.DynamicHoldTime.Enable._1;
            array_buffer[100].%X2 := buf4.DynamicHoldTime.Enable._2;
            array_buffer[100].%X3 := buf4.DynamicHoldTime.Enable._3;
            array_buffer[100].%X4 := buf4.DynamicHoldTime.Enable._4;
            array_buffer[100].%X5 := buf4.DynamicHoldTime.Enable._5;
            array_buffer[100].%X6 := buf4.DynamicHoldTime.Enable._6;
            array_buffer[100].%X7 := buf4.DynamicHoldTime.Enable._7;
            
            array_buffer[101].%X0 := buf4.DynamicHoldTime.Enable._8;
            array_buffer[101].%X1 := buf4.DynamicHoldTime.Enable._9;
            array_buffer[101].%X2 := buf4.DynamicHoldTime.Enable._10;
            array_buffer[101].%X3 := buf4.DynamicHoldTime.Enable._11;
            array_buffer[101].%X4 := buf4.DynamicHoldTime.Enable._12;
            array_buffer[101].%X5 := buf4.DynamicHoldTime.Enable._13;
            array_buffer[101].%X6 := buf4.DynamicHoldTime.Enable._14;
            array_buffer[101].%X7 := buf4.DynamicHoldTime.Enable._15;
            
            array_buffer[102].%X0 := buf4.DynamicHoldTime.Enable._16;
            array_buffer[102].%X1 := buf4.DynamicHoldTime.Enable._17;
            array_buffer[102].%X2 := buf4.DynamicHoldTime.Enable._18;
            array_buffer[102].%X3 := buf4.DynamicHoldTime.Enable._19;
            array_buffer[102].%X4 := buf4.DynamicHoldTime.Enable._20;
            array_buffer[102].%X5 := buf4.DynamicHoldTime.Enable._21;
            array_buffer[102].%X6 := buf4.DynamicHoldTime.Enable._22;
            array_buffer[102].%X7 := buf4.DynamicHoldTime.Enable._23;
            
            array_buffer[103].%X0 := buf4.DynamicHoldTime.Enable.LowerBad_1;
            array_buffer[103].%X1 := buf4.DynamicHoldTime.Enable.LowerSuspect_1;
            array_buffer[103].%X2 := buf4.DynamicHoldTime.Enable.UpperSuspect_1;
            array_buffer[103].%X3 := buf4.DynamicHoldTime.Enable.UpperBad_1;
            array_buffer[103].%X4 := buf4.DynamicHoldTime.Enable.Display_1;
            array_buffer[103].%X5 := buf4.DynamicHoldTime.Enable._29;
            array_buffer[103].%X6 := buf4.DynamicHoldTime.Enable._30;
            array_buffer[103].%X7 := buf4.DynamicHoldTime.Enable._31;
            
            // ---- DynamicHoldTime (DINTs) → bytes 104..119 ----
            array_buffer[104] := TO_BYTE(SHR(TO_DWORD(buf4.DynamicHoldTime.LowerBad), UINT#24));
            array_buffer[105] := TO_BYTE(SHR(TO_DWORD(buf4.DynamicHoldTime.LowerBad), UINT#16));
            array_buffer[106] := TO_BYTE(SHR(TO_DWORD(buf4.DynamicHoldTime.LowerBad),  UINT#8));
            array_buffer[107] := TO_BYTE(     TO_DWORD(buf4.DynamicHoldTime.LowerBad));
            
            array_buffer[108] := TO_BYTE(SHR(TO_DWORD(buf4.DynamicHoldTime.LowerSuspect), UINT#24));
            array_buffer[109] := TO_BYTE(SHR(TO_DWORD(buf4.DynamicHoldTime.LowerSuspect), UINT#16));
            array_buffer[110] := TO_BYTE(SHR(TO_DWORD(buf4.DynamicHoldTime.LowerSuspect),  UINT#8));
            array_buffer[111] := TO_BYTE(     TO_DWORD(buf4.DynamicHoldTime.LowerSuspect));
            
            array_buffer[112] := TO_BYTE(SHR(TO_DWORD(buf4.DynamicHoldTime.UpperSuspect), UINT#24));
            array_buffer[113] := TO_BYTE(SHR(TO_DWORD(buf4.DynamicHoldTime.UpperSuspect), UINT#16));
            array_buffer[114] := TO_BYTE(SHR(TO_DWORD(buf4.DynamicHoldTime.UpperSuspect),  UINT#8));
            array_buffer[115] := TO_BYTE(     TO_DWORD(buf4.DynamicHoldTime.UpperSuspect));
            
            array_buffer[116] := TO_BYTE(SHR(TO_DWORD(buf4.DynamicHoldTime.UpperBad), UINT#24));
            array_buffer[117] := TO_BYTE(SHR(TO_DWORD(buf4.DynamicHoldTime.UpperBad), UINT#16));
            array_buffer[118] := TO_BYTE(SHR(TO_DWORD(buf4.DynamicHoldTime.UpperBad),  UINT#8));
            array_buffer[119] := TO_BYTE(     TO_DWORD(buf4.DynamicHoldTime.UpperBad));
            
            // ---- DynamicHoldDistance.Enable bits → bytes 120..123 ----
            array_buffer[120].%X0 := buf4.DynamicHoldDistance.Enable._0;
            array_buffer[120].%X1 := buf4.DynamicHoldDistance.Enable._1;
            array_buffer[120].%X2 := buf4.DynamicHoldDistance.Enable._2;
            array_buffer[120].%X3 := buf4.DynamicHoldDistance.Enable._3;
            array_buffer[120].%X4 := buf4.DynamicHoldDistance.Enable._4;
            array_buffer[120].%X5 := buf4.DynamicHoldDistance.Enable._5;
            array_buffer[120].%X6 := buf4.DynamicHoldDistance.Enable._6;
            array_buffer[120].%X7 := buf4.DynamicHoldDistance.Enable._7;
            
            array_buffer[121].%X0 := buf4.DynamicHoldDistance.Enable._8;
            array_buffer[121].%X1 := buf4.DynamicHoldDistance.Enable._9;
            array_buffer[121].%X2 := buf4.DynamicHoldDistance.Enable._10;
            array_buffer[121].%X3 := buf4.DynamicHoldDistance.Enable._11;
            array_buffer[121].%X4 := buf4.DynamicHoldDistance.Enable._12;
            array_buffer[121].%X5 := buf4.DynamicHoldDistance.Enable._13;
            array_buffer[121].%X6 := buf4.DynamicHoldDistance.Enable._14;
            array_buffer[121].%X7 := buf4.DynamicHoldDistance.Enable._15;
            
            array_buffer[122].%X0 := buf4.DynamicHoldDistance.Enable._16;
            array_buffer[122].%X1 := buf4.DynamicHoldDistance.Enable._17;
            array_buffer[122].%X2 := buf4.DynamicHoldDistance.Enable._18;
            array_buffer[122].%X3 := buf4.DynamicHoldDistance.Enable._19;
            array_buffer[122].%X4 := buf4.DynamicHoldDistance.Enable._20;
            array_buffer[122].%X5 := buf4.DynamicHoldDistance.Enable._21;
            array_buffer[122].%X6 := buf4.DynamicHoldDistance.Enable._22;
            array_buffer[122].%X7 := buf4.DynamicHoldDistance.Enable._23;
            
            array_buffer[123].%X0 := buf4.DynamicHoldDistance.Enable.LowerBad_1;
            array_buffer[123].%X1 := buf4.DynamicHoldDistance.Enable.LowerSuspect_1;
            array_buffer[123].%X2 := buf4.DynamicHoldDistance.Enable.UpperSuspect_1;
            array_buffer[123].%X3 := buf4.DynamicHoldDistance.Enable.UpperBad_1;
            array_buffer[123].%X4 := buf4.DynamicHoldDistance.Enable.Display_1;
            array_buffer[123].%X5 := buf4.DynamicHoldDistance.Enable._29;
            array_buffer[123].%X6 := buf4.DynamicHoldDistance.Enable._30;
            array_buffer[123].%X7 := buf4.DynamicHoldDistance.Enable._31;
            
            // ---- DynamicHoldDistance (DINTs) → bytes 124..139 ----
            array_buffer[124] := TO_BYTE(SHR(TO_DWORD(buf4.DynamicHoldDistance.LowerBad), UINT#24));
            array_buffer[125] := TO_BYTE(SHR(TO_DWORD(buf4.DynamicHoldDistance.LowerBad), UINT#16));
            array_buffer[126] := TO_BYTE(SHR(TO_DWORD(buf4.DynamicHoldDistance.LowerBad),  UINT#8));
            array_buffer[127] := TO_BYTE(     TO_DWORD(buf4.DynamicHoldDistance.LowerBad));
            
            array_buffer[128] := TO_BYTE(SHR(TO_DWORD(buf4.DynamicHoldDistance.LowerSuspect), UINT#24));
            array_buffer[129] := TO_BYTE(SHR(TO_DWORD(buf4.DynamicHoldDistance.LowerSuspect), UINT#16));
            array_buffer[130] := TO_BYTE(SHR(TO_DWORD(buf4.DynamicHoldDistance.LowerSuspect),  UINT#8));
            array_buffer[131] := TO_BYTE(     TO_DWORD(buf4.DynamicHoldDistance.LowerSuspect));
            
            array_buffer[132] := TO_BYTE(SHR(TO_DWORD(buf4.DynamicHoldDistance.UpperSuspect), UINT#24));
            array_buffer[133] := TO_BYTE(SHR(TO_DWORD(buf4.DynamicHoldDistance.UpperSuspect), UINT#16));
            array_buffer[134] := TO_BYTE(SHR(TO_DWORD(buf4.DynamicHoldDistance.UpperSuspect),  UINT#8));
            array_buffer[135] := TO_BYTE(     TO_DWORD(buf4.DynamicHoldDistance.UpperSuspect));
            
            array_buffer[136] := TO_BYTE(SHR(TO_DWORD(buf4.DynamicHoldDistance.UpperBad), UINT#24));
            array_buffer[137] := TO_BYTE(SHR(TO_DWORD(buf4.DynamicHoldDistance.UpperBad), UINT#16));
            array_buffer[138] := TO_BYTE(SHR(TO_DWORD(buf4.DynamicHoldDistance.UpperBad),  UINT#8));
            array_buffer[139] := TO_BYTE(     TO_DWORD(buf4.DynamicHoldDistance.UpperBad));
            
            // ---- TotalCycleTime.Enable bits → bytes 140..143 ----
            array_buffer[140].%X0 := buf4.TotalCycleTime.Enable._0;
            array_buffer[140].%X1 := buf4.TotalCycleTime.Enable._1;
            array_buffer[140].%X2 := buf4.TotalCycleTime.Enable._2;
            array_buffer[140].%X3 := buf4.TotalCycleTime.Enable._3;
            array_buffer[140].%X4 := buf4.TotalCycleTime.Enable._4;
            array_buffer[140].%X5 := buf4.TotalCycleTime.Enable._5;
            array_buffer[140].%X6 := buf4.TotalCycleTime.Enable._6;
            array_buffer[140].%X7 := buf4.TotalCycleTime.Enable._7;
            
            array_buffer[141].%X0 := buf4.TotalCycleTime.Enable._8;
            array_buffer[141].%X1 := buf4.TotalCycleTime.Enable._9;
            array_buffer[141].%X2 := buf4.TotalCycleTime.Enable._10;
            array_buffer[141].%X3 := buf4.TotalCycleTime.Enable._11;
            array_buffer[141].%X4 := buf4.TotalCycleTime.Enable._12;
            array_buffer[141].%X5 := buf4.TotalCycleTime.Enable._13;
            array_buffer[141].%X6 := buf4.TotalCycleTime.Enable._14;
            array_buffer[141].%X7 := buf4.TotalCycleTime.Enable._15;
            
            array_buffer[142].%X0 := buf4.TotalCycleTime.Enable._16;
            array_buffer[142].%X1 := buf4.TotalCycleTime.Enable._17;
            array_buffer[142].%X2 := buf4.TotalCycleTime.Enable._18;
            array_buffer[142].%X3 := buf4.TotalCycleTime.Enable._19;
            array_buffer[142].%X4 := buf4.TotalCycleTime.Enable._20;
            array_buffer[142].%X5 := buf4.TotalCycleTime.Enable._21;
            array_buffer[142].%X6 := buf4.TotalCycleTime.Enable._22;
            array_buffer[142].%X7 := buf4.TotalCycleTime.Enable._23;
            
            array_buffer[143].%X0 := buf4.TotalCycleTime.Enable.LowerBad_1;
            array_buffer[143].%X1 := buf4.TotalCycleTime.Enable.LowerSuspect_1;
            array_buffer[143].%X2 := buf4.TotalCycleTime.Enable.UpperSuspect_1;
            array_buffer[143].%X3 := buf4.TotalCycleTime.Enable.UpperBad_1;
            array_buffer[143].%X4 := buf4.TotalCycleTime.Enable.Display_1;
            array_buffer[143].%X5 := buf4.TotalCycleTime.Enable._29;
            array_buffer[143].%X6 := buf4.TotalCycleTime.Enable._30;
            array_buffer[143].%X7 := buf4.TotalCycleTime.Enable._31;
            
            // ---- TotalCycleTime (DINTs) → bytes 144..159 ----
            array_buffer[144] := TO_BYTE(SHR(TO_DWORD(buf4.TotalCycleTime.LowerBad), UINT#24));
            array_buffer[145] := TO_BYTE(SHR(TO_DWORD(buf4.TotalCycleTime.LowerBad), UINT#16));
            array_buffer[146] := TO_BYTE(SHR(TO_DWORD(buf4.TotalCycleTime.LowerBad),  UINT#8));
            array_buffer[147] := TO_BYTE(     TO_DWORD(buf4.TotalCycleTime.LowerBad));
            
            array_buffer[148] := TO_BYTE(SHR(TO_DWORD(buf4.TotalCycleTime.LowerSuspect), UINT#24));
            array_buffer[149] := TO_BYTE(SHR(TO_DWORD(buf4.TotalCycleTime.LowerSuspect), UINT#16));
            array_buffer[150] := TO_BYTE(SHR(TO_DWORD(buf4.TotalCycleTime.LowerSuspect),  UINT#8));
            array_buffer[151] := TO_BYTE(     TO_DWORD(buf4.TotalCycleTime.LowerSuspect));
            
            array_buffer[152] := TO_BYTE(SHR(TO_DWORD(buf4.TotalCycleTime.UpperSuspect), UINT#24));
            array_buffer[153] := TO_BYTE(SHR(TO_DWORD(buf4.TotalCycleTime.UpperSuspect), UINT#16));
            array_buffer[154] := TO_BYTE(SHR(TO_DWORD(buf4.TotalCycleTime.UpperSuspect),  UINT#8));
            array_buffer[155] := TO_BYTE(     TO_DWORD(buf4.TotalCycleTime.UpperSuspect));
            
            array_buffer[156] := TO_BYTE(SHR(TO_DWORD(buf4.TotalCycleTime.UpperBad), UINT#24));
            array_buffer[157] := TO_BYTE(SHR(TO_DWORD(buf4.TotalCycleTime.UpperBad), UINT#16));
            array_buffer[158] := TO_BYTE(SHR(TO_DWORD(buf4.TotalCycleTime.UpperBad),  UINT#8));
            array_buffer[159] := TO_BYTE(     TO_DWORD(buf4.TotalCycleTime.UpperBad));
            
            // ---- FinalHoldPosition.Enable bits → bytes 160..163 ----
            array_buffer[160].%X0 := buf4.FinalHoldPosition.Enable._0;
            array_buffer[160].%X1 := buf4.FinalHoldPosition.Enable._1;
            array_buffer[160].%X2 := buf4.FinalHoldPosition.Enable._2;
            array_buffer[160].%X3 := buf4.FinalHoldPosition.Enable._3;
            array_buffer[160].%X4 := buf4.FinalHoldPosition.Enable._4;
            array_buffer[160].%X5 := buf4.FinalHoldPosition.Enable._5;
            array_buffer[160].%X6 := buf4.FinalHoldPosition.Enable._6;
            array_buffer[160].%X7 := buf4.FinalHoldPosition.Enable._7;
            
            array_buffer[161].%X0 := buf4.FinalHoldPosition.Enable._8;
            array_buffer[161].%X1 := buf4.FinalHoldPosition.Enable._9;
            array_buffer[161].%X2 := buf4.FinalHoldPosition.Enable._10;
            array_buffer[161].%X3 := buf4.FinalHoldPosition.Enable._11;
            array_buffer[161].%X4 := buf4.FinalHoldPosition.Enable._12;
            array_buffer[161].%X5 := buf4.FinalHoldPosition.Enable._13;
            array_buffer[161].%X6 := buf4.FinalHoldPosition.Enable._14;
            array_buffer[161].%X7 := buf4.FinalHoldPosition.Enable._15;
            
            array_buffer[162].%X0 := buf4.FinalHoldPosition.Enable._16;
            array_buffer[162].%X1 := buf4.FinalHoldPosition.Enable._17;
            array_buffer[162].%X2 := buf4.FinalHoldPosition.Enable._18;
            array_buffer[162].%X3 := buf4.FinalHoldPosition.Enable._19;
            array_buffer[162].%X4 := buf4.FinalHoldPosition.Enable._20;
            array_buffer[162].%X5 := buf4.FinalHoldPosition.Enable._21;
            array_buffer[162].%X6 := buf4.FinalHoldPosition.Enable._22;
            array_buffer[162].%X7 := buf4.FinalHoldPosition.Enable._23;
            
            array_buffer[163].%X0 := buf4.FinalHoldPosition.Enable.LowerBad_1;
            array_buffer[163].%X1 := buf4.FinalHoldPosition.Enable.LowerSuspect_1;
            array_buffer[163].%X2 := buf4.FinalHoldPosition.Enable.UpperSuspect_1;
            array_buffer[163].%X3 := buf4.FinalHoldPosition.Enable.UpperBad_1;
            array_buffer[163].%X4 := buf4.FinalHoldPosition.Enable.Display_1;
            array_buffer[163].%X5 := buf4.FinalHoldPosition.Enable._29;
            array_buffer[163].%X6 := buf4.FinalHoldPosition.Enable._30;
            array_buffer[163].%X7 := buf4.FinalHoldPosition.Enable._31;
            
            // ---- FinalHoldPosition (DINTs) → bytes 164..179 ----
            array_buffer[164] := TO_BYTE(SHR(TO_DWORD(buf4.FinalHoldPosition.LowerBad), UINT#24));
            array_buffer[165] := TO_BYTE(SHR(TO_DWORD(buf4.FinalHoldPosition.LowerBad), UINT#16));
            array_buffer[166] := TO_BYTE(SHR(TO_DWORD(buf4.FinalHoldPosition.LowerBad),  UINT#8));
            array_buffer[167] := TO_BYTE(     TO_DWORD(buf4.FinalHoldPosition.LowerBad));
            
            array_buffer[168] := TO_BYTE(SHR(TO_DWORD(buf4.FinalHoldPosition.LowerSuspect), UINT#24));
            array_buffer[169] := TO_BYTE(SHR(TO_DWORD(buf4.FinalHoldPosition.LowerSuspect), UINT#16));
            array_buffer[170] := TO_BYTE(SHR(TO_DWORD(buf4.FinalHoldPosition.LowerSuspect),  UINT#8));
            array_buffer[171] := TO_BYTE(     TO_DWORD(buf4.FinalHoldPosition.LowerSuspect));
            
            array_buffer[172] := TO_BYTE(SHR(TO_DWORD(buf4.FinalHoldPosition.UpperSuspect), UINT#24));
            array_buffer[173] := TO_BYTE(SHR(TO_DWORD(buf4.FinalHoldPosition.UpperSuspect), UINT#16));
            array_buffer[174] := TO_BYTE(SHR(TO_DWORD(buf4.FinalHoldPosition.UpperSuspect),  UINT#8));
            array_buffer[175] := TO_BYTE(     TO_DWORD(buf4.FinalHoldPosition.UpperSuspect));
            
            array_buffer[176] := TO_BYTE(SHR(TO_DWORD(buf4.FinalHoldPosition.UpperBad), UINT#24));
            array_buffer[177] := TO_BYTE(SHR(TO_DWORD(buf4.FinalHoldPosition.UpperBad), UINT#16));
            array_buffer[178] := TO_BYTE(SHR(TO_DWORD(buf4.FinalHoldPosition.UpperBad),  UINT#8));
            array_buffer[179] := TO_BYTE(     TO_DWORD(buf4.FinalHoldPosition.UpperBad));
            
            // ---- ErrorStatus.Enable bits → bytes 180..183 ----
            array_buffer[180].%X0 := buf4.ErrorStatus.Enable._0;
            array_buffer[180].%X1 := buf4.ErrorStatus.Enable._1;
            array_buffer[180].%X2 := buf4.ErrorStatus.Enable._2;
            array_buffer[180].%X3 := buf4.ErrorStatus.Enable._3;
            array_buffer[180].%X4 := buf4.ErrorStatus.Enable._4;
            array_buffer[180].%X5 := buf4.ErrorStatus.Enable._5;
            array_buffer[180].%X6 := buf4.ErrorStatus.Enable._6;
            array_buffer[180].%X7 := buf4.ErrorStatus.Enable._7;
            
            array_buffer[181].%X0 := buf4.ErrorStatus.Enable._8;
            array_buffer[181].%X1 := buf4.ErrorStatus.Enable._9;
            array_buffer[181].%X2 := buf4.ErrorStatus.Enable._10;
            array_buffer[181].%X3 := buf4.ErrorStatus.Enable._11;
            array_buffer[181].%X4 := buf4.ErrorStatus.Enable._12;
            array_buffer[181].%X5 := buf4.ErrorStatus.Enable._13;
            array_buffer[181].%X6 := buf4.ErrorStatus.Enable._14;
            array_buffer[181].%X7 := buf4.ErrorStatus.Enable._15;
            
            array_buffer[182].%X0 := buf4.ErrorStatus.Enable._16;
            array_buffer[182].%X1 := buf4.ErrorStatus.Enable._17;
            array_buffer[182].%X2 := buf4.ErrorStatus.Enable._18;
            array_buffer[182].%X3 := buf4.ErrorStatus.Enable._19;
            array_buffer[182].%X4 := buf4.ErrorStatus.Enable._20;
            array_buffer[182].%X5 := buf4.ErrorStatus.Enable._21;
            array_buffer[182].%X6 := buf4.ErrorStatus.Enable._22;
            array_buffer[182].%X7 := buf4.ErrorStatus.Enable._23;
            
            array_buffer[183].%X0 := buf4.ErrorStatus.Enable.LowerBad_1;
            array_buffer[183].%X1 := buf4.ErrorStatus.Enable.LowerSuspect_1;
            array_buffer[183].%X2 := buf4.ErrorStatus.Enable.UpperSuspect_1;
            array_buffer[183].%X3 := buf4.ErrorStatus.Enable.UpperBad_1;
            array_buffer[183].%X4 := buf4.ErrorStatus.Enable.Display_1;
            array_buffer[183].%X5 := buf4.ErrorStatus.Enable._29;
            array_buffer[183].%X6 := buf4.ErrorStatus.Enable._30;
            array_buffer[183].%X7 := buf4.ErrorStatus.Enable._31;
            
            // ---- ErrorStatus (DINTs) → bytes 184..199 ----
            array_buffer[184] := TO_BYTE(SHR(TO_DWORD(buf4.ErrorStatus.LowerBad), UINT#24));
            array_buffer[185] := TO_BYTE(SHR(TO_DWORD(buf4.ErrorStatus.LowerBad), UINT#16));
            array_buffer[186] := TO_BYTE(SHR(TO_DWORD(buf4.ErrorStatus.LowerBad),  UINT#8));
            array_buffer[187] := TO_BYTE(     TO_DWORD(buf4.ErrorStatus.LowerBad));
            
            array_buffer[188] := TO_BYTE(SHR(TO_DWORD(buf4.ErrorStatus.LowerSuspect), UINT#24));
            array_buffer[189] := TO_BYTE(SHR(TO_DWORD(buf4.ErrorStatus.LowerSuspect), UINT#16));
            array_buffer[190] := TO_BYTE(SHR(TO_DWORD(buf4.ErrorStatus.LowerSuspect),  UINT#8));
            array_buffer[191] := TO_BYTE(     TO_DWORD(buf4.ErrorStatus.LowerSuspect));
            
            array_buffer[192] := TO_BYTE(SHR(TO_DWORD(buf4.ErrorStatus.UpperSuspect), UINT#24));
            array_buffer[193] := TO_BYTE(SHR(TO_DWORD(buf4.ErrorStatus.UpperSuspect), UINT#16));
            array_buffer[194] := TO_BYTE(SHR(TO_DWORD(buf4.ErrorStatus.UpperSuspect),  UINT#8));
            array_buffer[195] := TO_BYTE(     TO_DWORD(buf4.ErrorStatus.UpperSuspect));
            
            array_buffer[196] := TO_BYTE(SHR(TO_DWORD(buf4.ErrorStatus.UpperBad), UINT#24));
            array_buffer[197] := TO_BYTE(SHR(TO_DWORD(buf4.ErrorStatus.UpperBad), UINT#16));
            array_buffer[198] := TO_BYTE(SHR(TO_DWORD(buf4.ErrorStatus.UpperBad),  UINT#8));
            array_buffer[199] := TO_BYTE(     TO_DWORD(buf4.ErrorStatus.UpperBad));
            
        END_METHOD
            
        METHOD PRIVATE buf5_TO_ByteArray
            VAR_IN_OUT
                buf5 : Axo_IQ_SeriesWelder_data5_176bytes;
                array_buffer : ARRAY[0..253] OF BYTE;
            END_VAR
            
            // --- Sensor[1] (bytes 0..19) ---
            array_buffer[ 0] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[1].Enable),    UINT#24));
            array_buffer[ 1] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[1].Enable),    UINT#16));
            array_buffer[ 2] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[1].Enable),     UINT#8));
            array_buffer[ 3] := TO_BYTE(     TO_DWORD(buf5.AnalogSensor.Sensor[1].Enable));
            
            array_buffer[ 4] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[1].MIN_VOLT),  UINT#24));
            array_buffer[ 5] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[1].MIN_VOLT),  UINT#16));
            array_buffer[ 6] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[1].MIN_VOLT),   UINT#8));
            array_buffer[ 7] := TO_BYTE(     TO_DWORD(buf5.AnalogSensor.Sensor[1].MIN_VOLT));
            
            array_buffer[ 8] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[1].MAX_VOLT),  UINT#24));
            array_buffer[ 9] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[1].MAX_VOLT),  UINT#16));
            array_buffer[10] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[1].MAX_VOLT),   UINT#8));
            array_buffer[11] := TO_BYTE(     TO_DWORD(buf5.AnalogSensor.Sensor[1].MAX_VOLT));
            
            array_buffer[12] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[1].MIN_VAL),   UINT#24));
            array_buffer[13] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[1].MIN_VAL),   UINT#16));
            array_buffer[14] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[1].MIN_VAL),    UINT#8));
            array_buffer[15] := TO_BYTE(     TO_DWORD(buf5.AnalogSensor.Sensor[1].MIN_VAL));
            
            array_buffer[16] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[1].MAX_VAL),   UINT#24));
            array_buffer[17] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[1].MAX_VAL),   UINT#16));
            array_buffer[18] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[1].MAX_VAL),    UINT#8));
            array_buffer[19] := TO_BYTE(     TO_DWORD(buf5.AnalogSensor.Sensor[1].MAX_VAL));
            
            // --- Sensor[2] (bytes 20..39) ---
            array_buffer[20] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[2].Enable),    UINT#24));
            array_buffer[21] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[2].Enable),    UINT#16));
            array_buffer[22] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[2].Enable),     UINT#8));
            array_buffer[23] := TO_BYTE(     TO_DWORD(buf5.AnalogSensor.Sensor[2].Enable));
            
            array_buffer[24] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[2].MIN_VOLT),  UINT#24));
            array_buffer[25] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[2].MIN_VOLT),  UINT#16));
            array_buffer[26] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[2].MIN_VOLT),   UINT#8));
            array_buffer[27] := TO_BYTE(     TO_DWORD(buf5.AnalogSensor.Sensor[2].MIN_VOLT));
            
            array_buffer[28] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[2].MAX_VOLT),  UINT#24));
            array_buffer[29] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[2].MAX_VOLT),  UINT#16));
            array_buffer[30] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[2].MAX_VOLT),   UINT#8));
            array_buffer[31] := TO_BYTE(     TO_DWORD(buf5.AnalogSensor.Sensor[2].MAX_VOLT));
            
            array_buffer[32] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[2].MIN_VAL),   UINT#24));
            array_buffer[33] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[2].MIN_VAL),   UINT#16));
            array_buffer[34] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[2].MIN_VAL),    UINT#8));
            array_buffer[35] := TO_BYTE(     TO_DWORD(buf5.AnalogSensor.Sensor[2].MIN_VAL));
            
            array_buffer[36] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[2].MAX_VAL),   UINT#24));
            array_buffer[37] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[2].MAX_VAL),   UINT#16));
            array_buffer[38] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[2].MAX_VAL),    UINT#8));
            array_buffer[39] := TO_BYTE(     TO_DWORD(buf5.AnalogSensor.Sensor[2].MAX_VAL));
            
            // --- Sensor[3] (bytes 40..59) ---
            array_buffer[40] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[3].Enable),    UINT#24));
            array_buffer[41] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[3].Enable),    UINT#16));
            array_buffer[42] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[3].Enable),     UINT#8));
            array_buffer[43] := TO_BYTE(     TO_DWORD(buf5.AnalogSensor.Sensor[3].Enable));
            
            array_buffer[44] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[3].MIN_VOLT),  UINT#24));
            array_buffer[45] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[3].MIN_VOLT),  UINT#16));
            array_buffer[46] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[3].MIN_VOLT),   UINT#8));
            array_buffer[47] := TO_BYTE(     TO_DWORD(buf5.AnalogSensor.Sensor[3].MIN_VOLT));
            
            array_buffer[48] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[3].MAX_VOLT),  UINT#24));
            array_buffer[49] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[3].MAX_VOLT),  UINT#16));
            array_buffer[50] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[3].MAX_VOLT),   UINT#8));
            array_buffer[51] := TO_BYTE(     TO_DWORD(buf5.AnalogSensor.Sensor[3].MAX_VOLT));
            
            array_buffer[52] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[3].MIN_VAL),   UINT#24));
            array_buffer[53] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[3].MIN_VAL),   UINT#16));
            array_buffer[54] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[3].MIN_VAL),    UINT#8));
            array_buffer[55] := TO_BYTE(     TO_DWORD(buf5.AnalogSensor.Sensor[3].MIN_VAL));
            
            array_buffer[56] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[3].MAX_VAL),   UINT#24));
            array_buffer[57] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[3].MAX_VAL),   UINT#16));
            array_buffer[58] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[3].MAX_VAL),    UINT#8));
            array_buffer[59] := TO_BYTE(     TO_DWORD(buf5.AnalogSensor.Sensor[3].MAX_VAL));
            
            // --- Sensor[4] (bytes 60..79) ---
            array_buffer[60] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[4].Enable),    UINT#24));
            array_buffer[61] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[4].Enable),    UINT#16));
            array_buffer[62] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[4].Enable),     UINT#8));
            array_buffer[63] := TO_BYTE(     TO_DWORD(buf5.AnalogSensor.Sensor[4].Enable));
            
            array_buffer[64] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[4].MIN_VOLT),  UINT#24));
            array_buffer[65] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[4].MIN_VOLT),  UINT#16));
            array_buffer[66] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[4].MIN_VOLT),   UINT#8));
            array_buffer[67] := TO_BYTE(     TO_DWORD(buf5.AnalogSensor.Sensor[4].MIN_VOLT));
            
            array_buffer[68] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[4].MAX_VOLT),  UINT#24));
            array_buffer[69] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[4].MAX_VOLT),  UINT#16));
            array_buffer[70] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[4].MAX_VOLT),   UINT#8));
            array_buffer[71] := TO_BYTE(     TO_DWORD(buf5.AnalogSensor.Sensor[4].MAX_VOLT));
            
            array_buffer[72] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[4].MIN_VAL),   UINT#24));
            array_buffer[73] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[4].MIN_VAL),   UINT#16));
            array_buffer[74] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[4].MIN_VAL),    UINT#8));
            array_buffer[75] := TO_BYTE(     TO_DWORD(buf5.AnalogSensor.Sensor[4].MIN_VAL));
            
            array_buffer[76] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[4].MAX_VAL),   UINT#24));
            array_buffer[77] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[4].MAX_VAL),   UINT#16));
            array_buffer[78] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[4].MAX_VAL),    UINT#8));
            array_buffer[79] := TO_BYTE(     TO_DWORD(buf5.AnalogSensor.Sensor[4].MAX_VAL));
            
            // --- Sensor[5] (bytes 80..99) ---
            array_buffer[80] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[5].Enable),    UINT#24));
            array_buffer[81] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[5].Enable),    UINT#16));
            array_buffer[82] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[5].Enable),     UINT#8));
            array_buffer[83] := TO_BYTE(     TO_DWORD(buf5.AnalogSensor.Sensor[5].Enable));
            
            array_buffer[84] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[5].MIN_VOLT),  UINT#24));
            array_buffer[85] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[5].MIN_VOLT),  UINT#16));
            array_buffer[86] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[5].MIN_VOLT),   UINT#8));
            array_buffer[87] := TO_BYTE(     TO_DWORD(buf5.AnalogSensor.Sensor[5].MIN_VOLT));
            
            array_buffer[88] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[5].MAX_VOLT),  UINT#24));
            array_buffer[89] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[5].MAX_VOLT),  UINT#16));
            array_buffer[90] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[5].MAX_VOLT),   UINT#8));
            array_buffer[91] := TO_BYTE(     TO_DWORD(buf5.AnalogSensor.Sensor[5].MAX_VOLT));
            
            array_buffer[92] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[5].MIN_VAL),   UINT#24));
            array_buffer[93] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[5].MIN_VAL),   UINT#16));
            array_buffer[94] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[5].MIN_VAL),    UINT#8));
            array_buffer[95] := TO_BYTE(     TO_DWORD(buf5.AnalogSensor.Sensor[5].MIN_VAL));
            
            array_buffer[96] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[5].MAX_VAL),   UINT#24));
            array_buffer[97] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[5].MAX_VAL),   UINT#16));
            array_buffer[98] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[5].MAX_VAL),    UINT#8));
            array_buffer[99] := TO_BYTE(     TO_DWORD(buf5.AnalogSensor.Sensor[5].MAX_VAL));
            
            // --- Sensor[6] (bytes 100..119) ---
            array_buffer[100] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[6].Enable),   UINT#24));
            array_buffer[101] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[6].Enable),   UINT#16));
            array_buffer[102] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[6].Enable),    UINT#8));
            array_buffer[103] := TO_BYTE(     TO_DWORD(buf5.AnalogSensor.Sensor[6].Enable));
            
            array_buffer[104] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[6].MIN_VOLT), UINT#24));
            array_buffer[105] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[6].MIN_VOLT), UINT#16));
            array_buffer[106] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[6].MIN_VOLT),  UINT#8));
            array_buffer[107] := TO_BYTE(     TO_DWORD(buf5.AnalogSensor.Sensor[6].MIN_VOLT));
            
            array_buffer[108] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[6].MAX_VOLT), UINT#24));
            array_buffer[109] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[6].MAX_VOLT), UINT#16));
            array_buffer[110] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[6].MAX_VOLT),  UINT#8));
            array_buffer[111] := TO_BYTE(     TO_DWORD(buf5.AnalogSensor.Sensor[6].MAX_VOLT));
            
            array_buffer[112] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[6].MIN_VAL),  UINT#24));
            array_buffer[113] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[6].MIN_VAL),  UINT#16));
            array_buffer[114] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[6].MIN_VAL),   UINT#8));
            array_buffer[115] := TO_BYTE(     TO_DWORD(buf5.AnalogSensor.Sensor[6].MIN_VAL));
            
            array_buffer[116] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[6].MAX_VAL),  UINT#24));
            array_buffer[117] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[6].MAX_VAL),  UINT#16));
            array_buffer[118] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[6].MAX_VAL),   UINT#8));
            array_buffer[119] := TO_BYTE(     TO_DWORD(buf5.AnalogSensor.Sensor[6].MAX_VAL));
            
            // --- Sensor[7] (bytes 120..139) ---
            array_buffer[120] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[7].Enable),   UINT#24));
            array_buffer[121] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[7].Enable),   UINT#16));
            array_buffer[122] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[7].Enable),    UINT#8));
            array_buffer[123] := TO_BYTE(     TO_DWORD(buf5.AnalogSensor.Sensor[7].Enable));
            
            array_buffer[124] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[7].MIN_VOLT), UINT#24));
            array_buffer[125] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[7].MIN_VOLT), UINT#16));
            array_buffer[126] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[7].MIN_VOLT),  UINT#8));
            array_buffer[127] := TO_BYTE(     TO_DWORD(buf5.AnalogSensor.Sensor[7].MIN_VOLT));
            
            array_buffer[128] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[7].MAX_VOLT), UINT#24));
            array_buffer[129] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[7].MAX_VOLT), UINT#16));
            array_buffer[130] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[7].MAX_VOLT),  UINT#8));
            array_buffer[131] := TO_BYTE(     TO_DWORD(buf5.AnalogSensor.Sensor[7].MAX_VOLT));
            
            array_buffer[132] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[7].MIN_VAL),  UINT#24));
            array_buffer[133] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[7].MIN_VAL),  UINT#16));
            array_buffer[134] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[7].MIN_VAL),   UINT#8));
            array_buffer[135] := TO_BYTE(     TO_DWORD(buf5.AnalogSensor.Sensor[7].MIN_VAL));
            
            array_buffer[136] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[7].MAX_VAL),  UINT#24));
            array_buffer[137] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[7].MAX_VAL),  UINT#16));
            array_buffer[138] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[7].MAX_VAL),   UINT#8));
            array_buffer[139] := TO_BYTE(     TO_DWORD(buf5.AnalogSensor.Sensor[7].MAX_VAL));
            
            // --- Sensor[8] (bytes 140..159) ---
            array_buffer[140] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[8].Enable),   UINT#24));
            array_buffer[141] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[8].Enable),   UINT#16));
            array_buffer[142] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[8].Enable),    UINT#8));
            array_buffer[143] := TO_BYTE(     TO_DWORD(buf5.AnalogSensor.Sensor[8].Enable));
            
            array_buffer[144] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[8].MIN_VOLT), UINT#24));
            array_buffer[145] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[8].MIN_VOLT), UINT#16));
            array_buffer[146] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[8].MIN_VOLT),  UINT#8));
            array_buffer[147] := TO_BYTE(     TO_DWORD(buf5.AnalogSensor.Sensor[8].MIN_VOLT));
            
            array_buffer[148] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[8].MAX_VOLT), UINT#24));
            array_buffer[149] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[8].MAX_VOLT), UINT#16));
            array_buffer[150] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[8].MAX_VOLT),  UINT#8));
            array_buffer[151] := TO_BYTE(     TO_DWORD(buf5.AnalogSensor.Sensor[8].MAX_VOLT));
            
            array_buffer[152] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[8].MIN_VAL),  UINT#24));
            array_buffer[153] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[8].MIN_VAL),  UINT#16));
            array_buffer[154] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[8].MIN_VAL),   UINT#8));
            array_buffer[155] := TO_BYTE(     TO_DWORD(buf5.AnalogSensor.Sensor[8].MIN_VAL));
            
            array_buffer[156] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[8].MAX_VAL),  UINT#24));
            array_buffer[157] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[8].MAX_VAL),  UINT#16));
            array_buffer[158] := TO_BYTE(SHR(TO_DWORD(buf5.AnalogSensor.Sensor[8].MAX_VAL),   UINT#8));
            array_buffer[159] := TO_BYTE(     TO_DWORD(buf5.AnalogSensor.Sensor[8].MAX_VAL));
            
            // --- AfterburstEnable (bytes 160..163) ---
            array_buffer[160] := TO_BYTE(SHR(TO_DWORD(buf5.AfterburstEnable), UINT#24));
            array_buffer[161] := TO_BYTE(SHR(TO_DWORD(buf5.AfterburstEnable), UINT#16));
            array_buffer[162] := TO_BYTE(SHR(TO_DWORD(buf5.AfterburstEnable),  UINT#8));
            array_buffer[163] := TO_BYTE(     TO_DWORD(buf5.AfterburstEnable));
            
            // --- LimitWeld1TimeEnable bits (bytes 164..167) ---
            array_buffer[164].%X0 := buf5.LimitWeld1TimeEnable._0;
            array_buffer[164].%X1 := buf5.LimitWeld1TimeEnable._1;
            array_buffer[164].%X2 := buf5.LimitWeld1TimeEnable._2;
            array_buffer[164].%X3 := buf5.LimitWeld1TimeEnable._3;
            array_buffer[164].%X4 := buf5.LimitWeld1TimeEnable._4;
            array_buffer[164].%X5 := buf5.LimitWeld1TimeEnable._5;
            array_buffer[164].%X6 := buf5.LimitWeld1TimeEnable._6;
            array_buffer[164].%X7 := buf5.LimitWeld1TimeEnable._7;
            
            array_buffer[165].%X0 := buf5.LimitWeld1TimeEnable._8;
            array_buffer[165].%X1 := buf5.LimitWeld1TimeEnable._9;
            array_buffer[165].%X2 := buf5.LimitWeld1TimeEnable._10;
            array_buffer[165].%X3 := buf5.LimitWeld1TimeEnable._11;
            array_buffer[165].%X4 := buf5.LimitWeld1TimeEnable._12;
            array_buffer[165].%X5 := buf5.LimitWeld1TimeEnable._13;
            array_buffer[165].%X6 := buf5.LimitWeld1TimeEnable._14;
            array_buffer[165].%X7 := buf5.LimitWeld1TimeEnable._15;
            
            array_buffer[166].%X0 := buf5.LimitWeld1TimeEnable._16;
            array_buffer[166].%X1 := buf5.LimitWeld1TimeEnable._17;
            array_buffer[166].%X2 := buf5.LimitWeld1TimeEnable._18;
            array_buffer[166].%X3 := buf5.LimitWeld1TimeEnable._19;
            array_buffer[166].%X4 := buf5.LimitWeld1TimeEnable._20;
            array_buffer[166].%X5 := buf5.LimitWeld1TimeEnable._21;
            array_buffer[166].%X6 := buf5.LimitWeld1TimeEnable._22;
            array_buffer[166].%X7 := buf5.LimitWeld1TimeEnable._23;
            
            array_buffer[167].%X0 := buf5.LimitWeld1TimeEnable.LowerBad_1;
            array_buffer[167].%X1 := buf5.LimitWeld1TimeEnable.LowerSuspect_1;
            array_buffer[167].%X2 := buf5.LimitWeld1TimeEnable.UpperSuspect_1;
            array_buffer[167].%X3 := buf5.LimitWeld1TimeEnable.UpperBad_1;
            array_buffer[167].%X4 := buf5.LimitWeld1TimeEnable.Display_1;
            array_buffer[167].%X5 := buf5.LimitWeld1TimeEnable._29;
            array_buffer[167].%X6 := buf5.LimitWeld1TimeEnable._30;
            array_buffer[167].%X7 := buf5.LimitWeld1TimeEnable._31;
            
            // --- LimitWeld1EnergyEnable bits (bytes 168..171) ---
            array_buffer[168].%X0 := buf5.LimitWeld1EnergyEnable._0;
            array_buffer[168].%X1 := buf5.LimitWeld1EnergyEnable._1;
            array_buffer[168].%X2 := buf5.LimitWeld1EnergyEnable._2;
            array_buffer[168].%X3 := buf5.LimitWeld1EnergyEnable._3;
            array_buffer[168].%X4 := buf5.LimitWeld1EnergyEnable._4;
            array_buffer[168].%X5 := buf5.LimitWeld1EnergyEnable._5;
            array_buffer[168].%X6 := buf5.LimitWeld1EnergyEnable._6;
            array_buffer[168].%X7 := buf5.LimitWeld1EnergyEnable._7;
            
            array_buffer[169].%X0 := buf5.LimitWeld1EnergyEnable._8;
            array_buffer[169].%X1 := buf5.LimitWeld1EnergyEnable._9;
            array_buffer[169].%X2 := buf5.LimitWeld1EnergyEnable._10;
            array_buffer[169].%X3 := buf5.LimitWeld1EnergyEnable._11;
            array_buffer[169].%X4 := buf5.LimitWeld1EnergyEnable._12;
            array_buffer[169].%X5 := buf5.LimitWeld1EnergyEnable._13;
            array_buffer[169].%X6 := buf5.LimitWeld1EnergyEnable._14;
            array_buffer[169].%X7 := buf5.LimitWeld1EnergyEnable._15;
            
            array_buffer[170].%X0 := buf5.LimitWeld1EnergyEnable._16;
            array_buffer[170].%X1 := buf5.LimitWeld1EnergyEnable._17;
            array_buffer[170].%X2 := buf5.LimitWeld1EnergyEnable._18;
            array_buffer[170].%X3 := buf5.LimitWeld1EnergyEnable._19;
            array_buffer[170].%X4 := buf5.LimitWeld1EnergyEnable._20;
            array_buffer[170].%X5 := buf5.LimitWeld1EnergyEnable._21;
            array_buffer[170].%X6 := buf5.LimitWeld1EnergyEnable._22;
            array_buffer[170].%X7 := buf5.LimitWeld1EnergyEnable._23;
            
            array_buffer[171].%X0 := buf5.LimitWeld1EnergyEnable.LowerBad_1;
            array_buffer[171].%X1 := buf5.LimitWeld1EnergyEnable.LowerSuspect_1;
            array_buffer[171].%X2 := buf5.LimitWeld1EnergyEnable.UpperSuspect_1;
            array_buffer[171].%X3 := buf5.LimitWeld1EnergyEnable.UpperBad_1;
            array_buffer[171].%X4 := buf5.LimitWeld1EnergyEnable.Display_1;
            array_buffer[171].%X5 := buf5.LimitWeld1EnergyEnable._29;
            array_buffer[171].%X6 := buf5.LimitWeld1EnergyEnable._30;
            array_buffer[171].%X7 := buf5.LimitWeld1EnergyEnable._31;
            
            // --- LimitWeld1PowerEnable bits (bytes 172..175) ---
            array_buffer[172].%X0 := buf5.LimitWeld1PowerEnable._0;
            array_buffer[172].%X1 := buf5.LimitWeld1PowerEnable._1;
            array_buffer[172].%X2 := buf5.LimitWeld1PowerEnable._2;
            array_buffer[172].%X3 := buf5.LimitWeld1PowerEnable._3;
            array_buffer[172].%X4 := buf5.LimitWeld1PowerEnable._4;
            array_buffer[172].%X5 := buf5.LimitWeld1PowerEnable._5;
            array_buffer[172].%X6 := buf5.LimitWeld1PowerEnable._6;
            array_buffer[172].%X7 := buf5.LimitWeld1PowerEnable._7;
            
            array_buffer[173].%X0 := buf5.LimitWeld1PowerEnable._8;
            array_buffer[173].%X1 := buf5.LimitWeld1PowerEnable._9;
            array_buffer[173].%X2 := buf5.LimitWeld1PowerEnable._10;
            array_buffer[173].%X3 := buf5.LimitWeld1PowerEnable._11;
            array_buffer[173].%X4 := buf5.LimitWeld1PowerEnable._12;
            array_buffer[173].%X5 := buf5.LimitWeld1PowerEnable._13;
            array_buffer[173].%X6 := buf5.LimitWeld1PowerEnable._14;
            array_buffer[173].%X7 := buf5.LimitWeld1PowerEnable._15;
            
            array_buffer[174].%X0 := buf5.LimitWeld1PowerEnable._16;
            array_buffer[174].%X1 := buf5.LimitWeld1PowerEnable._17;
            array_buffer[174].%X2 := buf5.LimitWeld1PowerEnable._18;
            array_buffer[174].%X3 := buf5.LimitWeld1PowerEnable._19;
            array_buffer[174].%X4 := buf5.LimitWeld1PowerEnable._20;
            array_buffer[174].%X5 := buf5.LimitWeld1PowerEnable._21;
            array_buffer[174].%X6 := buf5.LimitWeld1PowerEnable._22;
            array_buffer[174].%X7 := buf5.LimitWeld1PowerEnable._23;
            
            array_buffer[175].%X0 := buf5.LimitWeld1PowerEnable.LowerBad_1;
            array_buffer[175].%X1 := buf5.LimitWeld1PowerEnable.LowerSuspect_1;
            array_buffer[175].%X2 := buf5.LimitWeld1PowerEnable.UpperSuspect_1;
            array_buffer[175].%X3 := buf5.LimitWeld1PowerEnable.UpperBad_1;
            array_buffer[175].%X4 := buf5.LimitWeld1PowerEnable.Display_1;
            array_buffer[175].%X5 := buf5.LimitWeld1PowerEnable._29;
            array_buffer[175].%X6 := buf5.LimitWeld1PowerEnable._30;
            array_buffer[175].%X7 := buf5.LimitWeld1PowerEnable._31;
            
        END_METHOD

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
            // This was original inputs reading =>
            // synchronous_read_retval := DPRD_DAT(LADDR := Config.HWIDs.HwID_iQ_to_PLC_Inputs,RECORD => iq_if._in);
            // <= This was original inputs reading
            
            // This is new inputs reading =>
            synchronous_read_retval := TO_INT(ReadData(LADDR := TO_WORD(Config.HWIDs.HwID_iQ_to_PLC_Inputs),RECORD => _data_in));
            IF synchronous_read_retval > INT#0 THEN
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
            coms_read_ok := (synchronous_read_retval = 0);
            
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
            // Network 2: Clear model info on lost coms
            // ============================================================================
            
            IF NOT coms_read_ok THEN
                ModelInfo.ModelNumber := '';
                ModelInfo.SerialNumber := DINT#0;
                ModelInfo.MB_FirmwareVersion := '';
                ModelInfo.FP_FirmwareVersion := '';
                ModelInfo.MB_BootLoaderVersion := '';
                ModelInfo.FP_BootloaderVersion := '';
            END_IF;
            
            // ============================================================================
            // Network 3: Initialize read request
            // ============================================================================
            
            IF coms_just_restored OR coms_stable AND AxoTaskRefresh THEN
                model_read_map := initial_model_refresh;
                par_read_map := initial_parameter_refresh;
                AxoTaskRefresh := FALSE;
            END_IF;
            
            // ============================================================================
            // Network 4: Process synchronous data into HMI status
            // ============================================================================
            
            Hmi.s.RunningAndActiveSetupNotSame := (Inputs.ActiveSetup <> Inputs.RunningSetup);
            
            // ============================================================================
            // Network 5: To enable any other IQ control weld time must be enabled first
            // ============================================================================
            
            IF Parameters.PressWeld.Weld1Source.Power OR Parameters.PressWeld.Weld1Source.Energy OR Parameters.PressWeld.Weld1Source.Distance OR
                Parameters.PressWeld.Weld1Source.Position OR Parameters.PressWeld.Weld1Source.Ground_Detect OR Parameters.PressWeld.Weld1Source.Force THEN
                Parameters.PressWeld.Weld1Source._Time := TRUE;
            END_IF;
            
            IF Parameters.PressWeld.Weld1Source.Enable_Weld_1 AND NOT pEnableWeld THEN
                Parameters.PressWeld.Weld1Source._Time := TRUE;
            END_IF;
            Parameters.PressWeld.Weld1Source.Enable_Weld_1 := Parameters.PressWeld.Weld1Source._Time;
            pEnableWeld := Parameters.PressWeld.Weld1Source.Enable_Weld_1;
            
            // ============================================================================
            // Network 6: Automated reaction to (user) parameter changes
            // (handled more fully in Network 18 below - compare & set write map)
            // ============================================================================
            
            IF Parameters.PressTrigger.TriggerSource.Position AND NOT pTriggerSourcePosition THEN
                Parameters.PressTrigger.TriggerSource.Power := FALSE;
            END_IF;
            pTriggerSourcePosition := Parameters.PressTrigger.TriggerSource.Position;
            
            IF Parameters.PressTrigger.TriggerSource.Power AND NOT pTriggerSourcePower THEN
                Parameters.PressTrigger.TriggerSource.Position := FALSE;
            END_IF;
            pTriggerSourcePower :=Parameters.PressTrigger.TriggerSource.Power;
            
            IF Parameters.PressTrigger.TriggerSource.Position AND Parameters.PressTrigger.TriggerSource.Power THEN
                Parameters.PressTrigger.TriggerSource.Power := FALSE;
            END_IF;
            
            Parameters.PressTrigger.TriggerSource.Enable_Trigger := Parameters.PressTrigger.TriggerSource.Position OR Parameters.PressTrigger.TriggerSource.Power;
            
            Parameters.PressPretrigger.PreTriggerSource._Time := Parameters.PressTrigger.TriggerSource.Power;
            Parameters.PressPretrigger.PreTriggerSource.Enable_Trigger := Parameters.PressTrigger.TriggerSource.Power;
            IF Parameters.PressTrigger.TriggerSource.Power THEN
                Parameters.PressPretrigger.PreTriggerTime := 0;
            END_IF;
            
            // ============================================================================
            // Network 7: Afterburst enable / disable (handled via buf5 fields)
            // ============================================================================
            tmp_DW := TO_DWORD(Parameters.AfterburstEnable) AND DWORD#1;
            IF tmp_DW <> DWORD#0 THEN
                Parameters.AfterburstEnable := TO_DINT(TO_DWORD(Parameters.AfterburstEnable) OR DWORD#2);
            ELSE
                Parameters.AfterburstEnable := DINT#0;
            END_IF;
            
            // ============================================================================
            // Network 8: HMI processing (user controls -> request bits)
            // ============================================================================
            IF Hmi.c.flip_freq_tracking_compat THEN
                Hmi.c.flip_freq_tracking_compat := FALSE;
                tmp_bit := (Parameters.FreqCtrlMode = 6);
                IF tmp_bit THEN
                    Parameters.FreqCtrlMode := 1;
                ELSE
                    Parameters.FreqCtrlMode := 0;
                END_IF;
            END_IF;
            
            IF Hmi.c.apply_scanned_freq THEN
                Hmi.c.apply_scanned_freq := FALSE;
                Hmi.s.DisplayApplyScannedFrequency := FALSE;
                IF TestScanResults.TestScanResults > 0 THEN
                    TestScanResults.TestScanResults := TestScanResults.TestScanResults;
                END_IF;
            END_IF;
            
            IF Hmi.c.dont_apply_scanned_freq THEN
                Hmi.c.dont_apply_scanned_freq := FALSE;
                Hmi.s.DisplayApplyScannedFrequency := FALSE;
                IF Hmi.c.copy_setup THEN
                    on_demand_write_map := on_demand_write_map OR TO_WORD(2#0000000000000001);
                    Hmi.c.copy_setup := FALSE;
                END_IF;
            END_IF;
            
            // ============================================================================
            // Network 9: Parameters check (safety)
            // ============================================================================
            IF Parameters.FreqCtrlMode <> 1 AND Parameters.FreqCtrlMode <> 6 THEN
                Parameters.FreqCtrlMode := 1;
            END_IF;
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
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 301;
                    END_IF;
                END_IF;
    
                IF _progress = 301 THEN                                                                                     // TemplateTask_10steps_1 running: , <add the detailed description of the current action 2>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#501, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#501;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 302;
                    END_IF;
                END_IF;
                
                IF _progress = 302 THEN                                                                                     // TemplateTask_10steps_1 running: , <add the detailed description of the current action 3>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#502, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#502;
                    END_IF;

                    IF TRUE THEN
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
                
                IF _progress = 309 THEN                                                                                     // TemplateTask_10steps_1 running: , <add the detailed description of the current action 10>
                    TemplateTask_10steps_1.DoneWhen(TRUE);
                    _progress := 0;
                END_IF;
    
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
            // This was original outputs writing =>
            // synchronous_write_retval := DPWR_DAT(LADDR := outputs_hw_id,RECORD := iq_if._out);
            // <= This was original outputs writing
            
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

            synchronous_write_retval := TO_INT(WriteData(LADDR := TO_WORD(Config.HWIDs.HwID_PLC_to_iQ_Outputs),RECORD := _data_out));
            IF synchronous_write_retval > INT#0 THEN
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
            // Network 16: Read acyclic data
            // ============================================================================
            //Try asynchronous comunication only when synchronous comunication is stable (no errors for 1s)
            IF (coms_stable) THEN
                
                //Save rd_req value from previous iteation
                prev_rd_req := ReadRecord.request;
                
                // Proces valid data if needed
                IF ReadRecord.VALID THEN
                    Hmi.read_status[async_read_no] := ReadRecord.STATUS;
                    CASE async_read_no OF
                        -16: // Model no decode to string
                            // Chars_TO_Strg(Chars := str_read_buffer,
                            //               pChars := 0,
                            //               Cnt := RD_REC.length,
                            //               Strg => ModelInfo.ModelNumber);
                            _data_255[0]:= TO_BYTE(ReadRecord.length);
                            FOR index := UINT#0 TO ReadRecord.length DO
                                _data_255[index + UINT#1] := str_read_buffer_254[index];
                            END_FOR;
                            Deserialize(UDINT#0, str_read_buffer_254, ModelInfo.ModelNumber);

                        -15:  
                            Deserialize(UDINT#0, str_read_buffer_254, ModelInfo.SerialNumber);                            

                        -14: // MB firmware version decode to string
                            // Chars_TO_Strg(Chars := str_read_buffer_254,
                            //               pChars := 0,
                            //               Cnt := RD_REC.length,
                            //               Strg => ModelInfo.MB_FirmwareVersion);
                            _data_255[0]:= TO_BYTE(ReadRecord.length);
                            FOR index := UINT#0 TO ReadRecord.length DO
                                _data_255[index + UINT#1] := str_read_buffer_254[index];
                            END_FOR;
                            Deserialize(UDINT#0, str_read_buffer_254, ModelInfo.MB_FirmwareVersion);

                        -13: // FP firmware version decode to string
                            // Chars_TO_Strg(Chars := str_read_buffer_254,
                            //               pChars := 0,
                            //               Cnt := RD_REC.length,
                            //               Strg => ModelInfo.FP_FirmwareVersion);
                            _data_255[0]:= TO_BYTE(ReadRecord.length);
                            FOR index := UINT#0 TO ReadRecord.length DO
                                _data_255[index + UINT#1] := str_read_buffer_254[index];
                            END_FOR;
                            Deserialize(UDINT#0, str_read_buffer_254, ModelInfo.FP_FirmwareVersion);
                                        
                        -12: // MB bootloader version decode to string
                            // Chars_TO_Strg(Chars := str_read_buffer_254,
                            //               pChars := 0,
                            //               Cnt := RD_REC.length,
                            //               Strg => ModelInfo.MB_BootLoaderVersion);
                            _data_255[0]:= TO_BYTE(ReadRecord.length);
                            FOR index := UINT#0 TO ReadRecord.length DO
                                _data_255[index + UINT#1] := str_read_buffer_254[index];
                            END_FOR;
                            Deserialize(UDINT#0, str_read_buffer_254, ModelInfo.MB_BootLoaderVersion);
                                        
                        -11: // FP bootloader version decode to string
                            // Chars_TO_Strg(Chars := str_read_buffer_254,
                            //               pChars := 0,
                            //               Cnt := RD_REC.length,
                            //               Strg => ModelInfo.FP_BootloaderVersion);
                            _data_255[0]:= TO_BYTE(ReadRecord.length);
                            FOR index := UINT#0 TO ReadRecord.length DO
                                _data_255[index + UINT#1] := str_read_buffer_254[index];
                            END_FOR;
                            Deserialize(UDINT#0, str_read_buffer_254, ModelInfo.FP_BootloaderVersion);
                                        
                        1:  //Data 1 read to buffer succesfull - copy
                            Parameters.ProcCtrl := ReadBuffers.buf1.ProcCtrl;
                            Parameters.ProcLimits := ReadBuffers.buf1.ProcLimits;
                            Parameters.FreqCtrl := ReadBuffers.buf1.FreqCtrl;
                            Parameters.TriggerByPower := ReadBuffers.buf1.TriggerByPower;
                            Parameters.FreqCtrlMode := ReadBuffers.buf1.FreqCtrlMode;
                            
                        2: //Data 2 read to buffer succesfull - copy
                            Parameters.PowerReg := ReadBuffers.buf2.PowerReg;
                            Parameters.PressPretrigger := ReadBuffers.buf2.PressPretrigger;
                            Parameters.PressTrigger := ReadBuffers.buf2.PressTrigger;
                            Parameters.PressTriggerDelay := ReadBuffers.buf2.PressTriggerDelay;
                            Parameters.PressWeld := ReadBuffers.buf2.PressWeld;
                            Parameters.PressWeldScrub := ReadBuffers.buf2.PressWeldScrub;
                            Parameters.PressPostWeld := ReadBuffers.buf2.PressPostWeld;
                        3: //Data 3 read to buffer succesfull - copy
                            Parameters.PressLimits.TriggerTime := ReadBuffers.buf3.TriggerTime;
                            Parameters.PressLimits.TriggerPosition := ReadBuffers.buf3.TriggerPosition;
                            Parameters.PressLimits.TriggerDelayTime := ReadBuffers.buf3.TriggerDelayTime;
                            Parameters.PressLimits.TriggerDelayDistance := ReadBuffers.buf3.TriggerDelayDistance;
                            Parameters.PressLimits.Weld1Distance := ReadBuffers.buf3.Weld1Distance;
                            Parameters.PressLimits.Weld1Position := ReadBuffers.buf3.Weld1Position;
                            Parameters.PressLimits.Weld2Time := ReadBuffers.buf3.Weld2Time;
                            Parameters.PressLimits.Weld2Energy := ReadBuffers.buf3.Weld2Energy;
                            Parameters.PressLimits.Weld2Power := ReadBuffers.buf3.Weld2Power;
                        4: //Data 4 read to buffer succesfull - copy
                            Parameters.PressLimits.Weld2Distance := ReadBuffers.buf4.Weld2Distance;
                            Parameters.PressLimits.Weld2Position := ReadBuffers.buf4.Weld2Position;
                            Parameters.PressLimits.TotalWeldTime := ReadBuffers.buf4.TotalWeldTime;
                            Parameters.PressLimits.TotalWeldEnergy := ReadBuffers.buf4.TotalWeldEnergy;
                            Parameters.PressLimits.TotalWeldDistance := ReadBuffers.buf4.TotalWeldDistance;
                            Parameters.PressLimits.DynamicHoldTime := ReadBuffers.buf4.DynamicHoldTime;
                            Parameters.PressLimits.DynamicHoldDistance := ReadBuffers.buf4.DynamicHoldDistance;
                            Parameters.PressLimits.TotalCycleTime := ReadBuffers.buf4.TotalCycleTime;
                            Parameters.PressLimits.FinalHoldPosition := ReadBuffers.buf4.FinalHoldPosition;
                            Parameters.PressLimits.ErrorStatus := ReadBuffers.buf4.ErrorStatus;
                        5: //Data 5 read to buffer succesfull - copy
                            Parameters.AnalogSensor := ReadBuffers.buf5.AnalogSensor;
                            Parameters.AfterburstEnable := ReadBuffers.buf5.AfterburstEnable;
                            Parameters.LimitWeld1TimeEnable := ReadBuffers.buf5.LimitWeld1TimeEnable;
                            Parameters.LimitWeld1EnergyEnable := ReadBuffers.buf5.LimitWeld1EnergyEnable;
                            Parameters.LimitWeld1PowerEnable := ReadBuffers.buf5.LimitWeld1PowerEnable;
                        17://Test scan read finished succesfully
                            Hmi.s.DisplayApplyScannedFrequency := true;
                            
                    END_CASE;
                END_IF;
                
                // Read request error - reset invalidated date if needed
                IF ReadRecord.ERROR THEN
                    Hmi.read_status[async_read_no] := ReadRecord.STATUS;
                    
                    CASE async_read_no OF
                        -16:
                            ModelInfo.ModelNumber := '';
                        -15:
                            ModelInfo.SerialNumber := 0;
                        -14:
                            ModelInfo.MB_FirmwareVersion := '';
                        -13:
                            ModelInfo.FP_FirmwareVersion := '';
                        -12:
                            ModelInfo.MB_BootLoaderVersion := '';
                        -11:
                            ModelInfo.FP_BootloaderVersion := '';
                    END_CASE;
                END_IF;
                
                // Unmask bit map after successfully / unsuccesfully finished readout of model no
                IF (ReadRecord.VALID OR ReadRecord.ERROR) THEN
                    IF (async_read_no < 0) AND (async_read_no >= -16) THEN
                        mask := THIS.DECO_WORD(TO_UINT(async_read_no + 16));
                        model_read_map := model_read_map AND (NOT mask);
                    END_IF;
                    
                    IF (async_read_no > 13) AND (async_read_no < + 32) THEN
                        mask := THIS.DECO_WORD(TO_UINT(async_read_no - 17));
                        on_demand_read_map := on_demand_read_map AND (NOT mask);
                    END_IF;
                END_IF;
                
                // Unmask bit map after successfully finished readout of parameters
                IF ReadRecord.VALID THEN
                    IF (async_read_no > 0) AND (async_read_no <= 16) THEN
                        mask := THIS.DECO_WORD(TO_UINT(async_read_no - 1));
                        par_read_map := par_read_map AND (NOT mask);
                    END_IF;
                END_IF;
                
                rd_any_response := (ReadRecord.BUSY OR ReadRecord.VALID OR ReadRecord.ERROR);
                
                //If we get a signal that request was processed we can set it to false to prepare for generating a new rising edge
                IF rd_req AND rd_any_response THEN
                    rd_req := false;
                END_IF;
                
                //If the previous request was processed and we are ready for a new one (new rising edge on rd_req) lets create one
                IF (NOT prev_rd_req) AND (NOT rd_any_response) AND (NOT coms_just_restored) THEN
                    IF (model_read_map <> WORD#0) THEN
                        async_read_no := THIS.ENCO(model_read_map) - INT#16;
                        rd_req := true;
                    ELSIF (on_demand_read_map <> WORD#0) THEN
                        async_read_no := THIS.ENCO(on_demand_read_map) + INT#17;
                        rd_req := true;
                    ELSIF (par_read_map <> WORD#0) THEN
                        async_read_no := THIS.ENCO(par_read_map) + INT#1;
                        rd_req := true;
                    ELSE
                        //If no request present we call the default RD_REC but without request
                        async_read_no := 0;
                    END_IF;
                END_IF;
                
                //Perform the read itself
                CASE async_read_no OF
                    -16: //Read model no string  
                        ReadRecord( request := rd_req, 
                                id := TO_WORD(Config.HWIDs.HwID_iQ_to_PLC_Inputs),
                                index := index_async_model_no,
                                maxLength := UINT#64,
                                record := str_read_buffer_254);
                    -15:  //Read serial no
                        ReadRecord( request := rd_req, 
                                id := TO_WORD(Config.HWIDs.HwID_iQ_to_PLC_Inputs),
                                index := index_async_serial_no,
                                maxLength := UINT#4,
                                record :=  str_read_buffer_254); // ModelInfo.SerialNumber);
                    -14: //Read mb firmware version
                        ReadRecord( request := rd_req, 
                                id := TO_WORD(Config.HWIDs.HwID_iQ_to_PLC_Inputs),
                                index := index_async_mb_firmware_ver,
                                maxLength := UINT#64,
                                record := str_read_buffer_254);
                    -13: //Read fp firmware version
                        ReadRecord( request := rd_req, 
                                id := TO_WORD(Config.HWIDs.HwID_iQ_to_PLC_Inputs),
                                index := index_async_fp_firmware_ver,
                                maxLength := UINT#64,
                                record := str_read_buffer_254);
                    -12: //Read mb bootloader version
                        ReadRecord( request := rd_req, 
                                id := TO_WORD(Config.HWIDs.HwID_iQ_to_PLC_Inputs),
                                index := index_async_mb_bootloader_no,
                                maxLength := UINT#64,
                                record := str_read_buffer_254);
                    -11: //Read fp bootloader version
                        ReadRecord( request := rd_req, 
                                id := TO_WORD(Config.HWIDs.HwID_iQ_to_PLC_Inputs),
                                index := index_async_fp_bootloader_no,
                                maxLength := UINT#64,
                                record := str_read_buffer_254);
                        
                    1:  //Read parameter packet 1
                        ReadRecord( request := rd_req, 
                                id := TO_WORD(Config.HWIDs.HwID_iQ_to_PLC_Inputs),
                                index := index_async_data1,
                                maxLength := UINT#132,
                                record := str_read_buffer_254); 
                                THIS.ByteArray_TO_buf1(str_read_buffer_254,ReadBuffers.buf1);
                    2:  //Read parameter packet 2
                        ReadRecord( request := rd_req, 
                                id := TO_WORD(Config.HWIDs.HwID_iQ_to_PLC_Inputs),
                                index := index_async_data2,
                                maxLength := UINT#136,
                                record := str_read_buffer_254); 
                                THIS.ByteArray_TO_buf2(str_read_buffer_254,ReadBuffers.buf2);
                    3:  //Read parameter packet 3
                        ReadRecord( request := rd_req, 
                                id := TO_WORD(Config.HWIDs.HwID_iQ_to_PLC_Inputs),
                                index := index_async_data3,
                                maxLength := UINT#180,
                                record := str_read_buffer_254); 
                                THIS.ByteArray_TO_buf3(str_read_buffer_254,ReadBuffers.buf3);
                    4:  //Read parameter packet 4
                        ReadRecord( request := rd_req, 
                                id := TO_WORD(Config.HWIDs.HwID_iQ_to_PLC_Inputs),
                                index := index_async_data4,
                                maxLength := UINT#200,
                                record := str_read_buffer_254); 
                                THIS.ByteArray_TO_buf4(str_read_buffer_254,ReadBuffers.buf4);
                    5:  //Read parameter packet 5
                        ReadRecord( request := rd_req, 
                                id := TO_WORD(Config.HWIDs.HwID_iQ_to_PLC_Inputs),
                                index := index_async_data5,
                                maxLength := UINT#176,
                                record := str_read_buffer_254); 
                                THIS.ByteArray_TO_buf5(str_read_buffer_254,ReadBuffers.buf5);

                        //Start of on-demand request types    
                    17: //Read test scan results
                        ReadRecord( request := rd_req, 
                                id := TO_WORD(Config.HWIDs.HwID_iQ_to_PLC_Inputs),
                                index := index_async_test_scan_result,
                                maxLength := UINT#4,
                                record := str_read_buffer_254); 
                                TestScanResults.TestScanResults:=       TO_DINT(SHL(TO_DWORD(str_read_buffer_254[  0]), UINT#24) OR
                                                                                        SHL(TO_DWORD(str_read_buffer_254[  1]), UINT#16) OR
                                                                                        SHL(TO_DWORD(str_read_buffer_254[  2]),  UINT#8) OR
                                                                                            TO_DWORD(str_read_buffer_254[  3])); 
                    ELSE
                        //By default we call test scan results request (but req is off so o data transfer)
                        ReadRecord( request := FALSE, 
                                id := TO_WORD(Config.HWIDs.HwID_iQ_to_PLC_Inputs),
                                index := index_async_test_scan_result,
                                maxLength := UINT#4,
                                record := str_read_buffer_254); 
                                TestScanResults.TestScanResults:=       TO_DINT(SHL(TO_DWORD(str_read_buffer_254[  0]), UINT#24) OR
                                                                                        SHL(TO_DWORD(str_read_buffer_254[  1]), UINT#16) OR
                                                                                        SHL(TO_DWORD(str_read_buffer_254[  2]),  UINT#8) OR
                                                                                            TO_DWORD(str_read_buffer_254[  3])); 
                END_CASE;
            END_IF;
            
            // ============================================================================
            // Network 17: Analog sensor settings HMI processing 
            // ============================================================================
            // Currently supports only distance / MPC distance modes
            IF Hmi.c.selected_analog_sensor > 8 THEN
                Hmi.c.selected_analog_sensor := 8;
            ELSIF Hmi.c.selected_analog_sensor < 1 THEN
                Hmi.c.selected_analog_sensor := 1;
            END_IF;
            
            tmp_W := par_read_map AND TO_WORD(2#0000000000010000);
            IF tmp_W <> WORD#0 THEN
                Hmi.s.current_analog_sensor := 0;
            END_IF;
            
            IF coms_stable THEN
                IF Hmi.analog_sensor_data.Enable >= 2 THEN
                    IF Inputs.SystemStatus.MPC_Present THEN
                        Hmi.analog_sensor_data.Enable := 3;
                    ELSE
                        Hmi.analog_sensor_data.Enable := 2;
                    END_IF;
                ELSE
                    Hmi.analog_sensor_data.Enable := 0;
                END_IF;
            END_IF;
            
            IF coms_stable AND par_read_map = WORD#0 THEN
                IF Hmi.c.selected_analog_sensor <> Hmi.s.current_analog_sensor THEN
                    Hmi.analog_sensor_data := Parameters.AnalogSensor.Sensor[Hmi.c.selected_analog_sensor];
                    Hmi.s.current_analog_sensor := Hmi.c.selected_analog_sensor;
                    IF Inputs.SystemStatus.MPC_Present THEN
                        Hmi.c.selected_analog_sensor := Hmi.c.selected_analog_sensor;
                    END_IF;
                ELSE
                //  IF Parameters.AnalogSensor.Sensor[Hmi.c.selected_analog_sensor] <> Hmi.analog_sensor_data THEN
                    IF THIS.AnalogSensorDiffers(REF(Parameters.AnalogSensor.Sensor[Hmi.c.selected_analog_sensor]) , REF(Hmi.analog_sensor_data)) THEN
                        Parameters.AnalogSensor.Sensor[Hmi.c.selected_analog_sensor] := Hmi.analog_sensor_data;
                    END_IF;
                END_IF;
                IF NOT Inputs.SystemStatus.MPC_Present THEN
                    Outputs.RunningMPCProbeSelection := 0;
                END_IF;
            END_IF;
            
            // ============================================================================
            // Network 18: Trigger writes on user data change 
            // ============================================================================
            
            //Posibly compare only in certain cycles to limit the large data block comparison PLC load (if multiple IQ installed)
            IF AxoTaskCompareThisCycle THEN
                // We can only triger writes if we have communication and all parameters were already read
                IF (Config_async_write_permited AND coms_stable AND (NOT coms_just_restored) AND (par_read_map = WORD#0)) THEN
                    IF (comp_opt_cycler = 0) THEN
                        // IF (Parameters.ProcCtrl <> ReadBuffers.buf1.ProcCtrl) OR
                        //     (Parameters.ProcLimits <> ReadBuffers.buf1.ProcLimits) OR
                        //     (Parameters.FreqCtrl <> ReadBuffers.buf1.FreqCtrl) OR
                        //     (Parameters.TriggerByPower <> ReadBuffers.buf1.TriggerByPower) OR
                        //     (Parameters.FreqCtrlMode <> ReadBuffers.buf1.FreqCtrlMode) THEN
                        IF  (THIS.ProcCtrlDiffers(       REF(Parameters.ProcCtrl)       , REF(ReadBuffers.buf1.ProcCtrl)))       OR
                            (THIS.ProcLimitsDiffers(     REF(Parameters.ProcLimits)     , REF(ReadBuffers.buf1.ProcLimits)))     OR
                            (THIS.FreqCtrlDiffers(       REF(Parameters.FreqCtrl)       , REF(ReadBuffers.buf1.FreqCtrl)))       OR
                            (THIS.TriggerByPowerDiffers( REF(Parameters.TriggerByPower) , REF(ReadBuffers.buf1.TriggerByPower))) OR
                            (Parameters.FreqCtrlMode <> ReadBuffers.buf1.FreqCtrlMode) THEN
                                par_write_map := par_write_map OR TO_WORD(2#000000000000001);
                        END_IF;
                    END_IF;
                    IF (comp_opt_cycler = 1) THEN
                        // IF (Parameters.PowerReg <> ReadBuffers.buf2.PowerReg) OR
                        //     (Parameters.PressPretrigger <> ReadBuffers.buf2.PressPretrigger) OR
                        //     (Parameters.PressTrigger <> ReadBuffers.buf2.PressTrigger) OR
                        //     (Parameters.PressTriggerDelay <> ReadBuffers.buf2.PressTriggerDelay) OR
                        //     (Parameters.PressWeld <> ReadBuffers.buf2.PressWeld) OR
                        //     (Parameters.PressWeldScrub <> ReadBuffers.buf2.PressWeldScrub) OR
                        //     (Parameters.PressPostWeld <> ReadBuffers.buf2.PressPostWeld) THEN
                        IF  (THIS.PowerRegDiffers(          REF(Parameters.PowerReg)           ,   REF(ReadBuffers.buf2.PowerReg))) OR
                            (THIS.PressPretriggerDiffers(   REF(Parameters.PressPretrigger)    ,   REF(ReadBuffers.buf2.PressPretrigger))) OR
                            (THIS.PressTriggerDiffers(      REF(Parameters.PressTrigger)       ,   REF(ReadBuffers.buf2.PressTrigger))) OR
                            (THIS.PressTriggerDelayDiffers( REF(Parameters.PressTriggerDelay)  ,   REF(ReadBuffers.buf2.PressTriggerDelay))) OR
                            (THIS.PressWeldDiffers(         REF(Parameters.PressWeld)          ,   REF(ReadBuffers.buf2.PressWeld))) OR
                            (THIS.PressWeldScrubDiffers(    REF(Parameters.PressWeldScrub)     ,   REF(ReadBuffers.buf2.PressWeldScrub))) OR
                            (THIS.PressPostWeldDiffers(     REF(Parameters.PressPostWeld)      ,   REF(ReadBuffers.buf2.PressPostWeld))) THEN                            
                            par_write_map := par_write_map OR TO_WORD(2#000000000000010);
                        END_IF;
                    END_IF;
                    IF (comp_opt_cycler = 2) THEN
                        // IF (Parameters.PressLimits.TriggerTime <> ReadBuffers.buf3.TriggerTime) OR
                        //     (Parameters.PressLimits.TriggerPosition <> ReadBuffers.buf3.TriggerPosition) OR
                        //     (Parameters.PressLimits.TriggerDelayTime <> ReadBuffers.buf3.TriggerDelayTime) OR
                        //     (Parameters.PressLimits.TriggerDelayDistance <> ReadBuffers.buf3.TriggerDelayDistance) OR
                        //     (Parameters.PressLimits.Weld1Distance <> ReadBuffers.buf3.Weld1Distance) OR
                        //     (Parameters.PressLimits.Weld1Position <> ReadBuffers.buf3.Weld1Position) OR
                        //     (Parameters.PressLimits.Weld2Time <> ReadBuffers.buf3.Weld2Time) OR
                        //     (Parameters.PressLimits.Weld2Energy <> ReadBuffers.buf3.Weld2Energy) OR
                        //     (Parameters.PressLimits.Weld2Power <> ReadBuffers.buf3.Weld2Power) THEN
                        IF  (THIS.PressLimitDiffers(REF(Parameters.PressLimits.TriggerTime)            ,   REF( ReadBuffers.buf3.TriggerTime))) OR
                            (THIS.PressLimitDiffers(REF(Parameters.PressLimits.TriggerPosition)        ,   REF( ReadBuffers.buf3.TriggerPosition))) OR
                            (THIS.PressLimitDiffers(REF(Parameters.PressLimits.TriggerDelayTime)       ,   REF( ReadBuffers.buf3.TriggerDelayTime))) OR
                            (THIS.PressLimitDiffers(REF(Parameters.PressLimits.TriggerDelayDistance)   ,   REF( ReadBuffers.buf3.TriggerDelayDistance))) OR
                            (THIS.PressLimitDiffers(REF(Parameters.PressLimits.Weld1Distance)          ,   REF( ReadBuffers.buf3.Weld1Distance))) OR
                            (THIS.PressLimitDiffers(REF(Parameters.PressLimits.Weld1Position)          ,   REF( ReadBuffers.buf3.Weld1Position))) OR
                            (THIS.PressLimitDiffers(REF(Parameters.PressLimits.Weld2Time)              ,   REF( ReadBuffers.buf3.Weld2Time))) OR
                            (THIS.PressLimitDiffers(REF(Parameters.PressLimits.Weld2Energy)            ,   REF( ReadBuffers.buf3.Weld2Energy))) OR
                            (THIS.PressLimitDiffers(REF(Parameters.PressLimits.Weld2Power)             ,   REF( ReadBuffers.buf3.Weld2Power))) THEN
                            par_write_map := par_write_map OR TO_WORD(2#000000000000100);
                        END_IF;
                    END_IF;
                    IF (comp_opt_cycler = 3) THEN
                        // IF (Parameters.PressLimits.Weld2Distance <> ReadBuffers.buf4.Weld2Distance) OR
                        //     (Parameters.PressLimits.Weld2Position <> ReadBuffers.buf4.Weld2Position) OR
                        //     (Parameters.PressLimits.TotalWeldTime <> ReadBuffers.buf4.TotalWeldTime) OR
                        //     (Parameters.PressLimits.TotalWeldEnergy <> ReadBuffers.buf4.TotalWeldEnergy) OR
                        //     (Parameters.PressLimits.TotalWeldDistance <> ReadBuffers.buf4.TotalWeldDistance) OR
                        //     (Parameters.PressLimits.DynamicHoldTime <> ReadBuffers.buf4.DynamicHoldTime) OR
                        //     (Parameters.PressLimits.DynamicHoldDistance <> ReadBuffers.buf4.DynamicHoldDistance) OR
                        //     (Parameters.PressLimits.TotalCycleTime <> ReadBuffers.buf4.TotalCycleTime) OR
                        //     (Parameters.PressLimits.FinalHoldPosition <> ReadBuffers.buf4.FinalHoldPosition) OR
                        //     (Parameters.PressLimits.ErrorStatus <> ReadBuffers.buf4.ErrorStatus) THEN
                        IF  (THIS.PressLimitDiffers(REF(Parameters.PressLimits.Weld2Distance)          ,   REF(ReadBuffers.buf4.Weld2Distance))) OR
                            (THIS.PressLimitDiffers(REF(Parameters.PressLimits.Weld2Position)          ,   REF(ReadBuffers.buf4.Weld2Position))) OR
                            (THIS.PressLimitDiffers(REF(Parameters.PressLimits.TotalWeldTime)          ,   REF(ReadBuffers.buf4.TotalWeldTime))) OR
                            (THIS.PressLimitDiffers(REF(Parameters.PressLimits.TotalWeldEnergy)        ,   REF(ReadBuffers.buf4.TotalWeldEnergy))) OR
                            (THIS.PressLimitDiffers(REF(Parameters.PressLimits.TotalWeldDistance)      ,   REF(ReadBuffers.buf4.TotalWeldDistance))) OR
                            (THIS.PressLimitDiffers(REF(Parameters.PressLimits.DynamicHoldTime)        ,   REF(ReadBuffers.buf4.DynamicHoldTime))) OR
                            (THIS.PressLimitDiffers(REF(Parameters.PressLimits.DynamicHoldDistance)    ,   REF(ReadBuffers.buf4.DynamicHoldDistance))) OR
                            (THIS.PressLimitDiffers(REF(Parameters.PressLimits.TotalCycleTime)         ,   REF(ReadBuffers.buf4.TotalCycleTime))) OR
                            (THIS.PressLimitDiffers(REF(Parameters.PressLimits.FinalHoldPosition)      ,   REF(ReadBuffers.buf4.FinalHoldPosition))) OR
                            (THIS.PressLimitDiffers(REF(Parameters.PressLimits.ErrorStatus)            ,   REF(ReadBuffers.buf4.ErrorStatus))) THEN
                                par_write_map := par_write_map OR TO_WORD(2#000000000001000);
                        END_IF;
                    END_IF;
                    IF (comp_opt_cycler = 4) THEN
                        // IF (Parameters.AnalogSensor <> ReadBuffers.buf5.AnalogSensor) OR
                        //     (Parameters.AfterburstEnable <> ReadBuffers.buf5.AfterburstEnable) OR
                        //     (Parameters.LimitWeld1TimeEnable <> ReadBuffers.buf5.LimitWeld1TimeEnable) OR
                        //     (Parameters.LimitWeld1EnergyEnable <> ReadBuffers.buf5.LimitWeld1EnergyEnable) OR
                        //     (Parameters.LimitWeld1PowerEnable <> ReadBuffers.buf5.LimitWeld1PowerEnable) THEN
                        IF  (THIS.AnalogSensorSpecDiffers(REF(Parameters.AnalogSensor)             ,   REF(ReadBuffers.buf5.AnalogSensor))) OR
                            (Parameters.AfterburstEnable                                           <>  ReadBuffers.buf5.AfterburstEnable) OR
                            (THIS.PressLimitEnableDiffers(REF(Parameters.LimitWeld1TimeEnable)     ,   REF( ReadBuffers.buf5.LimitWeld1TimeEnable))) OR
                            (THIS.PressLimitEnableDiffers(REF(Parameters.LimitWeld1EnergyEnable)   ,   REF( ReadBuffers.buf5.LimitWeld1EnergyEnable))) OR
                            (THIS.PressLimitEnableDiffers(REF(Parameters.LimitWeld1PowerEnable)    ,   REF( ReadBuffers.buf5.LimitWeld1PowerEnable))) THEN
                            par_write_map := par_write_map OR TO_WORD(2#000000000010000);
                        END_IF;
                    END_IF;
                    comp_opt_cycler := (comp_opt_cycler + 1) MOD 5;
                END_IF;
            END_IF;
            
            // ============================================================================
            // Network 19: Write req - HMI export (indicators) + response handling
            // ============================================================================
            
            tof_async_write_ind(signal := (par_write_map <> WORD#0) OR (on_demand_write_map <> WORD#0), duration := T#500ms);
            Hmi.s.AsyncWriteIndicator := tof_async_write_ind.output;
            
            // ============================================================================
            // Network 20: Write acyclic data
            // ============================================================================
            
            //Try asynchronous comunication only when synchronous comunication is stable (no errors for 1s)
            IF (coms_stable) THEN
                
                //Save wr_req value from previous iteation
                prev_wr_req := WriteRecord.request;
                
                // React tovalid writes if needed
                IF WriteRecord.DONE THEN
                    Hmi.write_status[async_write_no] := WriteRecord.STATUS;
                END_IF;
                
                // Write request error - reset invalidated date if needed
                IF WriteRecord.ERROR THEN
                    Hmi.write_status[async_write_no] := WriteRecord.STATUS;
                END_IF;
                
                // Unmask bit map after successfully / unsuccesfully finished write and trigger apropriate re-read
                IF (WriteRecord.DONE OR WriteRecord.ERROR) THEN
                    IF (async_write_no > 0) AND (async_write_no <= 16) THEN
                        mask := THIS.DECO_WORD(TO_UINT(async_write_no - 1));
                        par_write_map := par_write_map AND (NOT mask); // unmask the processed write request
                        par_read_map := par_read_map OR mask; // and request a read to verify/refresh the data
                    END_IF;
                    IF (async_write_no > 16) AND (async_write_no <= 32) THEN
                        mask := THIS.DECO_WORD(TO_UINT(async_write_no - 17));
                        on_demand_write_map := on_demand_write_map AND (NOT mask); // unmask the processed write request
                    END_IF;
                END_IF;
                
                wr_any_response := (WriteRecord.BUSY OR WriteRecord.DONE OR WriteRecord.ERROR);
                
                //If we get a singnal that request was processed we can set it to false to prepare for generating a new rising edge
                IF wr_req AND wr_any_response THEN
                    wr_req := false;
                END_IF;
                
                //If the previous request was processed and we are ready for a new one (new rising edge on rd_req) lets create one
                IF Config_async_write_permited AND (NOT prev_wr_req) AND (NOT wr_any_response) AND (NOT coms_just_restored) THEN
                    IF (par_write_map <> WORD#0) THEN
                        async_write_no := THIS.ENCO(par_write_map) + 1;
                        //Fill the write buffer with latest data just before the request
                        CASE async_write_no OF
                            1: //Write buffer 1
                                WriteBuffers.buf1.ProcCtrl := Parameters.ProcCtrl;
                                WriteBuffers.buf1.ProcLimits := Parameters.ProcLimits;
                                WriteBuffers.buf1.FreqCtrl := Parameters.FreqCtrl;
                                WriteBuffers.buf1.TriggerByPower := Parameters.TriggerByPower;
                                WriteBuffers.buf1.FreqCtrlMode := Parameters.FreqCtrlMode;
                                wr_req := true;
                            2: //Write buffer 2
                                WriteBuffers.buf2.PowerReg := Parameters.PowerReg;
                                WriteBuffers.buf2.PressPretrigger := Parameters.PressPretrigger;
                                WriteBuffers.buf2.PressTrigger := Parameters.PressTrigger;
                                WriteBuffers.buf2.PressTriggerDelay := Parameters.PressTriggerDelay;
                                WriteBuffers.buf2.PressWeld := Parameters.PressWeld;
                                WriteBuffers.buf2.PressWeldScrub := Parameters.PressWeldScrub;
                                WriteBuffers.buf2.PressPostWeld := Parameters.PressPostWeld;
                                wr_req := true;
                            3: //Write buffer 3
                                WriteBuffers.buf3.TriggerTime := Parameters.PressLimits.TriggerTime;
                                WriteBuffers.buf3.TriggerPosition := Parameters.PressLimits.TriggerPosition;
                                WriteBuffers.buf3.TriggerDelayTime := Parameters.PressLimits.TriggerDelayTime;
                                WriteBuffers.buf3.TriggerDelayDistance := Parameters.PressLimits.TriggerDelayDistance;
                                WriteBuffers.buf3.Weld1Distance := Parameters.PressLimits.Weld1Distance;
                                WriteBuffers.buf3.Weld1Position := Parameters.PressLimits.Weld1Position;
                                WriteBuffers.buf3.Weld2Time := Parameters.PressLimits.Weld2Time;
                                WriteBuffers.buf3.Weld2Energy := Parameters.PressLimits.Weld2Energy;
                                WriteBuffers.buf3.Weld2Power := Parameters.PressLimits.Weld2Power;
                                wr_req := true;
                            4: //Write buffer 4
                                WriteBuffers.buf4.Weld2Distance := Parameters.PressLimits.Weld2Distance;
                                WriteBuffers.buf4.Weld2Position := Parameters.PressLimits.Weld2Position;
                                WriteBuffers.buf4.TotalWeldTime := Parameters.PressLimits.TotalWeldTime;
                                WriteBuffers.buf4.TotalWeldEnergy := Parameters.PressLimits.TotalWeldEnergy;
                                WriteBuffers.buf4.TotalWeldDistance := Parameters.PressLimits.TotalWeldDistance;
                                WriteBuffers.buf4.DynamicHoldTime := Parameters.PressLimits.DynamicHoldTime;
                                WriteBuffers.buf4.DynamicHoldDistance := Parameters.PressLimits.DynamicHoldDistance;
                                WriteBuffers.buf4.TotalCycleTime := Parameters.PressLimits.TotalCycleTime;
                                WriteBuffers.buf4.FinalHoldPosition := Parameters.PressLimits.FinalHoldPosition;
                                WriteBuffers.buf4.ErrorStatus := Parameters.PressLimits.ErrorStatus;
                                wr_req := true;
                                
                            5: //Write buffer 5
                                WriteBuffers.buf5.AnalogSensor := Parameters.AnalogSensor;
                                WriteBuffers.buf5.AfterburstEnable := Parameters.AfterburstEnable;
                                WriteBuffers.buf5.LimitWeld1TimeEnable := Parameters.LimitWeld1TimeEnable;
                                WriteBuffers.buf5.LimitWeld1EnergyEnable := Parameters.LimitWeld1EnergyEnable;
                                WriteBuffers.buf5.LimitWeld1PowerEnable := Parameters.LimitWeld1PowerEnable;
                                wr_req := true;
                            ELSE
                                //Unknown parameter write request - just unmask it
                                mask := THIS.DECO_WORD(TO_UINT(async_write_no - 1));
                                par_write_map := par_write_map AND (NOT mask); // unmask unknown write request
                                wr_req := false;
                                async_write_no := 0;
                        END_CASE;
                    ELSIF (on_demand_write_map <> WORD#0) THEN
                        async_write_no := THIS.ENCO(on_demand_write_map) + 17;
                        CASE async_write_no OF
                            17: //Copyrec request
                                wr_req := true;
                            ELSE
                                //Unknown on demand write request - just unmask it
                                mask := THIS.DECO_WORD(TO_UINT(async_write_no - 17));
                                on_demand_write_map := on_demand_write_map AND (NOT mask); // unmask unknown write request
                                wr_req := false;
                                async_write_no := 0;
                        END_CASE;
                    ELSE
                        //If no request present we call the default WR_REC but without request
                        async_write_no := 0;
                    END_IF;
                END_IF;
                
                //Safety - if write is not pemited wr_req shoud be always false
                IF NOT Config_async_write_permited THEN
                    wr_req := false;
                END_IF;
                
                //Perform the write itself
                CASE async_write_no OF
                    1:  //Write parameter packet 1
                        THIS.buf1_TO_ByteArray(WriteBuffers.buf1,write_buffer_254);
                        WriteRecord(request := wr_req,
                                id := TO_WORD(Config.HWIDs.HwID_iQ_to_PLC_Inputs),
                                index := index_async_data1,
                                length := UINT#132,
                                record := write_buffer_254);
                    2:  //Write parameter packet 2
                        THIS.buf2_TO_ByteArray(WriteBuffers.buf2,write_buffer_254);
                        WriteRecord(request := wr_req,
                                id := TO_WORD(Config.HWIDs.HwID_iQ_to_PLC_Inputs),
                                index := index_async_data2,
                                length := UINT#136,
                                record := write_buffer_254);
                    3:  //Write parameter packet 3
                        THIS.buf3_TO_ByteArray(WriteBuffers.buf3,write_buffer_254);
                        WriteRecord(request := wr_req,
                                id := TO_WORD(Config.HWIDs.HwID_iQ_to_PLC_Inputs),
                                index := index_async_data3,
                                length := UINT#180,
                                record := write_buffer_254);
                    4:  //Write parameter packet 4
                        THIS.buf4_TO_ByteArray(WriteBuffers.buf4,write_buffer_254);
                        WriteRecord(request := wr_req,
                                id := TO_WORD(Config.HWIDs.HwID_iQ_to_PLC_Inputs),
                                index := index_async_data4,
                                length := UINT#200,
                                record := write_buffer_254);
                    5:  //Write parameter packet 5
                        THIS.buf5_TO_ByteArray(WriteBuffers.buf5,write_buffer_254);
                        WriteRecord(request := wr_req,
                                id := TO_WORD(Config.HWIDs.HwID_iQ_to_PLC_Inputs),
                                index := index_async_data5,
                                length := UINT#176,
                                record := write_buffer_254);
                        //Start of on-demand request types    
                    17: // Copyrec request
                        write_buffer_254[ 0] := TO_BYTE(SHR(TO_WORD(CopySetup.Destination_Setup),   UINT#8));
                        write_buffer_254[ 1] := TO_BYTE(    TO_WORD(CopySetup.Destination_Setup));
                        write_buffer_254[ 2] := TO_BYTE(SHR(TO_WORD(CopySetup.Source_Setup),        UINT#8));
                        write_buffer_254[ 3] := TO_BYTE(    TO_WORD(CopySetup.Source_Setup));
                        WriteRecord(request := wr_req,
                                id := TO_WORD(Config.HWIDs.HwID_iQ_to_PLC_Inputs),
                                index := index_asycn_copyrec,
                                length := UINT#4,
                                record := write_buffer_254);
                    ELSE
                        //By default we call 0 byte WR_REC using REQ=false
                        THIS.buf1_TO_ByteArray(WriteBuffers.buf1,write_buffer_254);
                        WriteRecord( request := false,
                                id := TO_WORD(Config.HWIDs.HwID_iQ_to_PLC_Inputs),
                                index := index_async_data1,
                                length := UINT#0,
                                record := write_buffer_254);
                END_CASE;
            END_IF;           
            //******************************************      

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



