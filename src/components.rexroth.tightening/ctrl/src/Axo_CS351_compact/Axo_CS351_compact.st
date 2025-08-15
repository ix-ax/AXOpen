USING AXOpen.Core;
USING AXOpen.Messaging;
USING AXOpen.Messaging.Static;
USING AXOpen.Components.Abstractions;
USING Siemens.Simatic.S71500.Hardware.Utilities;
USING System.Serialization;

NAMESPACE AXOpen.Components.Rexroth.Tightening
    {S7.extern=ReadWrite}
    CLASS Axo_CS351_compact EXTENDS AXOpen.Core.AxoComponent
        VAR PUBLIC // HEADER
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentHeader()]}
            {#ix-attr:[ReadOnly()]}
            {#ix-set:AttributeName = "<#OK#>"}
            OK : BOOL;
            {#ix-attr:[ComponentHeader()]}
            {#ix-attr:[ReadOnly()]}
            {#ix-set:AttributeName = "<#NOK#>"}
            NOK : BOOL;
            {#ix-attr:[ComponentHeader()]}         
            {#ix-attr:[ReadOnly()]}
            {#ix-set:AttributeName = "<#Results#>"}
            Results  :   Axo_CS351_compact_Results;
            {#ix-attr:[ComponentHeader()]}
            {#ix-set:AttributeName = "<#Progress#>"}
            {#ix-attr:[ReadOnly()]}
            Progress : INT;            
        END_VAR

        VAR PUBLIC // TASKS
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#Program number (manual)#>"}
            ProgramNoManual : BYTE;
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#IDcode (manual)#>"}
            IDcodeManual : STRING[64];
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#Automatic start manual#>"}
            AutomaticStartManual : BOOL;
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#Restore#>"}
            RestoreTask : AXOpen.Core.AxoTask;
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#DisableTask#>"}
            DisableTask : AXOpen.Core.AxoTask;
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#EnableTask#>"}
            EnableTask : AXOpen.Core.AxoTask;
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#DisableClockwiseTask#>"}
            DisableClockwiseTask : AXOpen.Core.AxoTask;
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#EnableClockwiseTask#>"}
            EnableClockwiseTask : AXOpen.Core.AxoTask;
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#DisableCounterClockwiseTask#>"}
            DisableCounterClockwiseTask : AXOpen.Core.AxoTask;
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#EnableCounterClockwiseTask#>"}
            EnableCounterClockwiseTask : AXOpen.Core.AxoTask;
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#ResetFaultTask#>"}
            ResetFaultTask : AXOpen.Core.AxoTask;
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#ResetResultsTask#>"}
            ResetResultsTask : AXOpen.Core.AxoTask;
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#SetScrewingProgramTask#>"}
            SetScrewingProgramTask : AXOpen.Core.AxoTask;
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#GetScrewingResultsTask#>"}
            GetScrewingResultsTask : AXOpen.Core.AxoTask;
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#ScrewClockwiseTask#>"}
            ScrewClockwiseTask : AXOpen.Core.AxoTask;
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#ScrewCounterClockwiseTask#>"}
            ScrewCounterClockwiseTask : AXOpen.Core.AxoTask;
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#RunAutomatTask#>"}
            RunAutomatTask : AXOpen.Core.AxoTask;
        END_VAR

        VAR PUBLIC // CONFIG
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("Config")]}
            {#ix-attr:[ReadOnly()]}
            Config  :   Axo_CS351_compact_Config;
        END_VAR

        VAR PUBLIC // STATUS
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("Status")]}
            {#ix-attr:[ReadOnly()]}
            Status              :   Axo_CS351_compact_Component_Status;
            Messenger           :   AXOpen.Messaging.Static.AxoMessenger;
            TaskMessenger       :   AXOpen.Messaging.Static.AxoMessenger;
        END_VAR    

        VAR PUBLIC // HARDWARE SIGNALS
            {#ix-attr:[ComponentDetails("HARDWARE SIGNALS")]}
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Inputs#>"}
            {#ix-attr:[ReadOnly()]}
            Inputs              :  Axo_CS351_compact_In;
            {#ix-attr:[ComponentDetails("HARDWARE SIGNALS")]}
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Outputs#>"}
            {#ix-attr:[ReadOnly()]}
            Outputs              :   Axo_CS351_compact_Out;

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
            _returnValue    :   WORD;
            _data_in4w      :   ARRAY[0..3] OF WORD;
            _data_out4w     :   ARRAY[0..3] OF WORD;
            _data_out2w     :   ARRAY[0..1] OF WORD;
            _word           :   WORD;
            _dword          :   DWORD;

            _initHwCheckDone        :   BOOL;
            _retval                 :   WORD;
            _geoAddr                :   GeoAddr;
            _outHwid                :   UINT;
            _startAddress           :   UDINT;
            _bytesCount             :   UINT;
            _blink                  :   AXOpen.Timers.AxoBlinker;   
            _programNo              :   BYTE;
            _IDcode                 :   ARRAY[0..63] OF BYTE;
            _automaticStart         :   BOOL;
            _inputsAddress          :   UDINT;   
            _inputsCount            :   UINT;
            _outputsAddress         :   UDINT;  
            _outputsCount           :   UINT; 
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
            
            Progress := _progress;

            SUPER.Run(parent);

            Messenger.Serve(THIS);

            IF NOT _initHwCheckDone THEN
                IF parent = NULL THEN
                    Messenger.Activate(UINT#700, eAxoMessageCategory#ProgrammingError);
                    Status.Error.Id := UINT#700;
                    RETURN;
                END_IF;
                Config.HWIDs.HW_Device := hwID;
                IF Config.HWIDs.HW_Device = UINT#0 THEN
                    Messenger.Activate(UINT#701, eAxoMessageCategory#ProgrammingError);
                    Status.Error.Id := UINT#701;
                    RETURN;
                END_IF;
    
                _retval := ReadSlotFromHardwareID(hardwareID := Config.HWIDs.HW_Device, geoAddr :=_geoAddr);   
                IF _retval = WORD#8090 THEN
                    Messenger.Activate(UINT#702,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#702;
                    RETURN;
                END_IF;
                //******************Slot 1*****************//
                _geoAddr.Slot   :=  UINT#1;   
                _geoAddr.HardwareType := UINT#4; // (4-Module)                                                      
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_Slot_1);        
                IF Config.HWIDs.HwID_Slot_1 = UINT#0 THEN
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
                ReadHardwareIOAddress(hardwareIdentifier :=  TO_WORD(Config.HWIDs.HwID_Slot_1) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#0 OR _outputsCount <> UINT#8 THEN
                    Messenger.Activate(UINT#716,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#716;
                    RETURN;
                END_IF;
                //******************Slot 2*****************//
                _geoAddr.Slot   :=  UINT#2;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)                                                      
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_Slot_2);        
                IF Config.HWIDs.HwID_Slot_2 = UINT#0 THEN
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
                ReadHardwareIOAddress(hardwareIdentifier :=  TO_WORD(Config.HWIDs.HwID_Slot_2) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#0 OR _outputsCount <> UINT#8 THEN
                    Messenger.Activate(UINT#726,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#726;
                    RETURN;
                END_IF;
                //******************Slot 3*****************//
                _geoAddr.Slot   :=  UINT#3;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)                                                      
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_Slot_3);        
                IF Config.HWIDs.HwID_Slot_3 = UINT#0 THEN
                    Messenger.Activate(UINT#730,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#730;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#731,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#731;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#732,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#732;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#733,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#733;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#734,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#734;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#735,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#735;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareIdentifier :=  TO_WORD(Config.HWIDs.HwID_Slot_3) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#0 OR _outputsCount <> UINT#8 THEN
                    Messenger.Activate(UINT#736,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#736;
                    RETURN;
                END_IF;
                //******************Slot 4*****************//
                _geoAddr.Slot   :=  UINT#4;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)                                                      
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_Slot_4);        
                IF Config.HWIDs.HwID_Slot_4 = UINT#0 THEN
                    Messenger.Activate(UINT#740,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#740;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#741,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#741;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#742,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#742;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#743,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#743;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#744,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#744;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#745,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#745;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareIdentifier :=  TO_WORD(Config.HWIDs.HwID_Slot_4) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#0 OR _outputsCount <> UINT#8 THEN
                    Messenger.Activate(UINT#746,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#746;
                    RETURN;
                END_IF;
                //******************Slot 5*****************//
                _geoAddr.Slot   :=  UINT#5;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)                                                      
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_Slot_5);        
                IF Config.HWIDs.HwID_Slot_5 = UINT#0 THEN
                    Messenger.Activate(UINT#750,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#750;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#751,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#751;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#752,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#752;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#753,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#753;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#754,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#754;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#755,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#755;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareIdentifier :=  TO_WORD(Config.HWIDs.HwID_Slot_5) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#0 OR _outputsCount <> UINT#8 THEN
                    Messenger.Activate(UINT#756,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#756;
                    RETURN;
                END_IF;
                //******************Slot 6*****************//
                _geoAddr.Slot   :=  UINT#6;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)                                                      
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_Slot_6);        
                IF Config.HWIDs.HwID_Slot_6 = UINT#0 THEN
                    Messenger.Activate(UINT#760,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#760;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#761,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#761;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#762,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#762;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#763,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#763;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#764,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#764;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#765,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#765;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareIdentifier :=  TO_WORD(Config.HWIDs.HwID_Slot_6) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#0 OR _outputsCount <> UINT#8 THEN
                    Messenger.Activate(UINT#766,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#766;
                    RETURN;
                END_IF;
                //******************Slot 7*****************//
                _geoAddr.Slot   :=  UINT#7;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)                                                      
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_Slot_7);        
                IF Config.HWIDs.HwID_Slot_7 = UINT#0 THEN
                    Messenger.Activate(UINT#770,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#770;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#771,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#771;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#772,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#772;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#773,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#773;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#774,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#774;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#775,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#775;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareIdentifier :=  TO_WORD(Config.HWIDs.HwID_Slot_7) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#0 OR _outputsCount <> UINT#8 THEN
                    Messenger.Activate(UINT#776,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#776;
                    RETURN;
                END_IF;
                //******************Slot 8*****************//
                _geoAddr.Slot   :=  UINT#8;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)                                                      
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_Slot_8);        
                IF Config.HWIDs.HwID_Slot_8 = UINT#0 THEN
                    Messenger.Activate(UINT#780,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#780;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#781,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#781;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#782,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#782;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#783,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#783;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#784,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#784;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#785,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#785;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareIdentifier :=  TO_WORD(Config.HWIDs.HwID_Slot_8) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#0 OR _outputsCount <> UINT#8 THEN
                    Messenger.Activate(UINT#786,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#786;
                    RETURN;
                END_IF;
                //******************Slot 9*****************//
                _geoAddr.Slot   :=  UINT#9;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)                                                      
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_Slot_9);        
                IF Config.HWIDs.HwID_Slot_9 = UINT#0 THEN
                    Messenger.Activate(UINT#790,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#790;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#791,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#791;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#792,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#792;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#793,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#793;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#794,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#794;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#795,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#795;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareIdentifier :=  TO_WORD(Config.HWIDs.HwID_Slot_9) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#0 OR _outputsCount <> UINT#4 THEN
                    Messenger.Activate(UINT#796,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#796;
                    RETURN;
                END_IF;
                //******************Slot 10*****************//
                _geoAddr.Slot   :=  UINT#10;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)                                                      
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_Slot_10);        
                IF Config.HWIDs.HwID_Slot_10 = UINT#0 THEN
                    Messenger.Activate(UINT#800,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#800;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#801,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#801;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#802,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#802;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#803,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#803;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#804,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#804;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#805,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#805;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareIdentifier :=  TO_WORD(Config.HWIDs.HwID_Slot_10) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#8 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#806,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#806;
                    RETURN;
                END_IF;
                //******************Slot 11*****************//
                _geoAddr.Slot   :=  UINT#11;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)                                                      
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_Slot_11);        
                IF Config.HWIDs.HwID_Slot_11 = UINT#0 THEN
                    Messenger.Activate(UINT#810,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#810;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#811,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#811;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#812,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#812;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#813,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#813;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#814,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#814;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#815,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#815;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareIdentifier :=  TO_WORD(Config.HWIDs.HwID_Slot_11) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#8 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#816,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#816;
                    RETURN;
                END_IF;
                //******************Slot 12*****************//
                _geoAddr.Slot   :=  UINT#12;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)                                                      
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_Slot_12);        
                IF Config.HWIDs.HwID_Slot_12 = UINT#0 THEN
                    Messenger.Activate(UINT#820,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#820;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#821,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#821;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#822,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#822;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#823,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#823;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#824,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#824;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#825,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#825;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareIdentifier :=  TO_WORD(Config.HWIDs.HwID_Slot_12) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#8 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#826,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#826;
                    RETURN;
                END_IF;
                //******************Slot 13*****************//
                _geoAddr.Slot   :=  UINT#13;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)                                                      
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_Slot_13);        
                IF Config.HWIDs.HwID_Slot_13 = UINT#0 THEN
                    Messenger.Activate(UINT#830,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#830;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#831,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#831;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#832,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#832;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#833,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#833;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#834,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#834;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#835,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#835;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareIdentifier :=  TO_WORD(Config.HWIDs.HwID_Slot_13) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#8 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#836,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#836;
                    RETURN;
                END_IF;
                //******************Slot 14*****************//
                _geoAddr.Slot   :=  UINT#14;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)                                                      
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_Slot_14);        
                IF Config.HWIDs.HwID_Slot_14 = UINT#0 THEN
                    Messenger.Activate(UINT#840,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#840;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#841,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#841;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#842,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#842;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#843,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#843;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#844,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#844;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#845,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#845;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareIdentifier :=  TO_WORD(Config.HWIDs.HwID_Slot_14) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#8 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#846,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#846;
                    RETURN;
                END_IF;
                //******************Slot 15*****************//
                _geoAddr.Slot   :=  UINT#15;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)                                                      
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_Slot_15);        
                IF Config.HWIDs.HwID_Slot_15 = UINT#0 THEN
                    Messenger.Activate(UINT#850,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#850;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#851,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#851;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#852,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#852;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#853,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#853;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#854,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#854;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#855,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#855;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareIdentifier :=  TO_WORD(Config.HWIDs.HwID_Slot_15) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#8 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#856,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#856;
                    RETURN;
                END_IF;
                //******************Slot 16*****************//
                _geoAddr.Slot   :=  UINT#16;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)                                                      
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_Slot_16);        
                IF Config.HWIDs.HwID_Slot_16 = UINT#0 THEN
                    Messenger.Activate(UINT#860,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#860;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#861,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#861;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#862,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#862;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#863,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#863;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#864,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#864;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#865,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#865;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareIdentifier :=  TO_WORD(Config.HWIDs.HwID_Slot_16) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#8 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#866,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#866;
                    RETURN;
                END_IF;
                //******************Slot 17*****************//
                _geoAddr.Slot   :=  UINT#17;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)                                                      
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_Slot_17);        
                IF Config.HWIDs.HwID_Slot_17 = UINT#0 THEN
                    Messenger.Activate(UINT#870,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#870;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#871,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#871;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#872,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#872;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#873,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#873;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#874,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#874;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#875,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#875;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareIdentifier :=  TO_WORD(Config.HWIDs.HwID_Slot_17) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#8 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#876,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#876;
                    RETURN;
                END_IF;
                //******************Slot 18*****************//
                _geoAddr.Slot   :=  UINT#18;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)                                                      
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_Slot_18);        
                IF Config.HWIDs.HwID_Slot_18 = UINT#0 THEN
                    Messenger.Activate(UINT#880,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#880;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#881,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#881;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#882,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#882;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#883,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#883;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#884,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#884;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#885,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#885;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareIdentifier :=  TO_WORD(Config.HWIDs.HwID_Slot_18) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#8 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#886,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#886;
                    RETURN;
                END_IF;
                //******************Slot 19*****************//
                _geoAddr.Slot   :=  UINT#19;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)                                                      
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_Slot_19);        
                IF Config.HWIDs.HwID_Slot_19 = UINT#0 THEN
                    Messenger.Activate(UINT#890,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#890;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#891,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#891;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#892,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#892;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#893,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#893;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#894,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#894;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#895,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#895;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareIdentifier :=  TO_WORD(Config.HWIDs.HwID_Slot_19) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#8 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#896,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#896;
                    RETURN;
                END_IF;
                //******************Slot 20*****************//
                _geoAddr.Slot   :=  UINT#20;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)                                                      
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_Slot_20);        
                IF Config.HWIDs.HwID_Slot_20 = UINT#0 THEN
                    Messenger.Activate(UINT#900,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#900;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#901,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#901;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#902,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#902;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#903,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#903;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#904,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#904;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#905,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#905;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareIdentifier :=  TO_WORD(Config.HWIDs.HwID_Slot_20) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#8 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#916,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#916;
                    RETURN;
                END_IF;
                //******************Slot 21*****************//
                _geoAddr.Slot   :=  UINT#21;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)                                                      
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_Slot_21);        
                IF Config.HWIDs.HwID_Slot_21 = UINT#0 THEN
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
                ReadHardwareIOAddress(hardwareIdentifier :=  TO_WORD(Config.HWIDs.HwID_Slot_21) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#8 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#916,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#916;
                    RETURN;
                END_IF;
                //******************Slot 22*****************//
                _geoAddr.Slot   :=  UINT#22;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)                                                      
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_Slot_22);        
                IF Config.HWIDs.HwID_Slot_22 = UINT#0 THEN
                    Messenger.Activate(UINT#920,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#920;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#921,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#921;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#922,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#922;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#923,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#923;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#924,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#924;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#925,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#925;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareIdentifier :=  TO_WORD(Config.HWIDs.HwID_Slot_22) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#8 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#926,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#926;
                    RETURN;
                END_IF;
                //******************Slot 23*****************//
                _geoAddr.Slot   :=  UINT#23;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)                                                      
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_Slot_23);        
                IF Config.HWIDs.HwID_Slot_23 = UINT#0 THEN
                    Messenger.Activate(UINT#930,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#930;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#931,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#931;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#932,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#932;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#933,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#933;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#934,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#934;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#935,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#935;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareIdentifier :=  TO_WORD(Config.HWIDs.HwID_Slot_23) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#8 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#936,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#936;
                    RETURN;
                END_IF;
                //******************Slot 24*****************//
                _geoAddr.Slot   :=  UINT#24;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)                                                      
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_Slot_24);        
                IF Config.HWIDs.HwID_Slot_24 = UINT#0 THEN
                    Messenger.Activate(UINT#940,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#940;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#941,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#941;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#942,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#942;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#943,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#943;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#944,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#944;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#945,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#945;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareIdentifier :=  TO_WORD(Config.HWIDs.HwID_Slot_24) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#8 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#946,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#946;
                    RETURN;
                END_IF;
                //******************Slot 25*****************//
                _geoAddr.Slot   :=  UINT#25;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)                                                      
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_Slot_25);        
                IF Config.HWIDs.HwID_Slot_25 = UINT#0 THEN
                    Messenger.Activate(UINT#950,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#950;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#951,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#951;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#952,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#952;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#953,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#953;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#954,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#954;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#955,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#955;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareIdentifier :=  TO_WORD(Config.HWIDs.HwID_Slot_25) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#8 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#956,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#956;
                    RETURN;
                END_IF;
                //******************Slot 26*****************//
                _geoAddr.Slot   :=  UINT#26;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)                                                      
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_Slot_26);        
                IF Config.HWIDs.HwID_Slot_26 = UINT#0 THEN
                    Messenger.Activate(UINT#960,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#960;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#961,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#961;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#962,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#962;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#963,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#963;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#964,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#964;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#965,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#965;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareIdentifier :=  TO_WORD(Config.HWIDs.HwID_Slot_26) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#4 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#966,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#966;
                    RETURN;
                END_IF;
                //******************************************//

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
            
                IF Config.HWIDs.HwID_Slot_1  = UINT#0 THEN
                    Messenger.Activate(UINT#1132,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1132;
                    RETURN;
                END_IF;
            
                IF Config.HWIDs.HwID_Slot_2 = UINT#0 THEN
                    Messenger.Activate(UINT#1133,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1133;
                    RETURN;
                END_IF;
            
                IF Config.HWIDs.HwID_Slot_3 = UINT#0 THEN
                    Messenger.Activate(UINT#1134,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1134;
                    RETURN;
                END_IF;

                IF Config.HWIDs.HwID_Slot_4 = UINT#0 THEN
                    Messenger.Activate(UINT#1135,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1135;
                    RETURN;
                END_IF;
            
                IF Config.HWIDs.HwID_Slot_5 = UINT#0 THEN
                    Messenger.Activate(UINT#1136,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1136;
                    RETURN;
                END_IF;
            
                IF Config.HWIDs.HwID_Slot_6 = UINT#0 THEN
                    Messenger.Activate(UINT#1137,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1137;
                    RETURN;
                END_IF;
            
                IF Config.HWIDs.HwID_Slot_7 = UINT#0 THEN
                    Messenger.Activate(UINT#1138,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1138;
                    RETURN;
                END_IF;
            
                IF Config.HWIDs.HwID_Slot_8 = UINT#0 THEN
                    Messenger.Activate(UINT#1139,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1139;
                    RETURN;
                END_IF;
            
                IF Config.HWIDs.HwID_Slot_9 = UINT#0 THEN
                    Messenger.Activate(UINT#1140,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1140;
                    RETURN;
                END_IF;

                IF Config.HWIDs.HwID_Slot_10 = UINT#0 THEN
                    Messenger.Activate(UINT#1141,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1141;
                    RETURN;
                END_IF;
            
                IF Config.HWIDs.HwID_Slot_11 = UINT#0 THEN
                    Messenger.Activate(UINT#1142,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1142;
                    RETURN;
                END_IF;
            
                IF Config.HWIDs.HwID_Slot_12 = UINT#0 THEN
                    Messenger.Activate(UINT#1143,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1143;
                    RETURN;
                END_IF;
            
                IF Config.HWIDs.HwID_Slot_13 = UINT#0 THEN
                    Messenger.Activate(UINT#1144,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1144;
                    RETURN;
                END_IF;
            
                IF Config.HWIDs.HwID_Slot_14 = UINT#0 THEN
                    Messenger.Activate(UINT#1145,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1145;
                    RETURN;
                END_IF;
            
                IF Config.HWIDs.HwID_Slot_15 = UINT#0 THEN
                    Messenger.Activate(UINT#1146,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1146;
                    RETURN;
                END_IF;

                IF Config.HWIDs.HwID_Slot_16 = UINT#0 THEN
                    Messenger.Activate(UINT#1147,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1147;
                    RETURN;
                END_IF;
            
                IF Config.HWIDs.HwID_Slot_17 = UINT#0 THEN
                    Messenger.Activate(UINT#1148,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1148;
                    RETURN;
                END_IF;
            
                IF Config.HWIDs.HwID_Slot_18 = UINT#0 THEN
                    Messenger.Activate(UINT#1149,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1149;
                    RETURN;
                END_IF;
            
                IF Config.HWIDs.HwID_Slot_19 = UINT#0 THEN
                    Messenger.Activate(UINT#1150,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1150;
                    RETURN;
                END_IF;
            
                IF Config.HWIDs.HwID_Slot_20 = UINT#0 THEN
                    Messenger.Activate(UINT#1151,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1151;
                    RETURN;
                END_IF;

                IF Config.HWIDs.HwID_Slot_21 = UINT#0 THEN
                    Messenger.Activate(UINT#1152,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1152;
                    RETURN;
                END_IF;
            
                IF Config.HWIDs.HwID_Slot_22 = UINT#0 THEN
                    Messenger.Activate(UINT#1153,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1153;
                    RETURN;
                END_IF;
            
                IF Config.HWIDs.HwID_Slot_23 = UINT#0 THEN
                    Messenger.Activate(UINT#1154,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1154;
                    RETURN;
                END_IF;

                IF Config.HWIDs.HwID_Slot_24 = UINT#0 THEN
                    Messenger.Activate(UINT#1155,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1155;
                    RETURN;
                END_IF;
            
                IF Config.HWIDs.HwID_Slot_25 = UINT#0 THEN
                    Messenger.Activate(UINT#1156,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1156;
                    RETURN;
                END_IF;
            
                IF Config.HWIDs.HwID_Slot_26 = UINT#0 THEN
                    Messenger.Activate(UINT#1157,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1157;
                    RETURN;
                END_IF;

                _initHwCheckDone    := TRUE;
            END_IF;            

            //***********Update inputs ******************************
            //  Slot 10 Input_4_word_1
            _returnValue := Siemens.Simatic.S71500.DistributedIO.ReadData(TO_WORD(Config.HWIDs.HwID_Slot_10),_data_in4w);
            IF _returnValue > WORD#0 THEN
                Messenger.Activate(UINT#1201, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1201;
                RETURN;
            END_IF;

            Inputs.ProgramNoAck                 :=  _data_in4w[0].%B1;        //  0

            Inputs.Ready                        :=  _data_in4w[0].%X0;        //  1
            Inputs.NoFault                      :=  _data_in4w[0].%X1;
            Inputs.InCycle                      :=  _data_in4w[0].%X2;
            Inputs.InCycleCcw                   :=  _data_in4w[0].%X3;
            Inputs.CycleComplete                :=  _data_in4w[0].%X4;
            Inputs.OK                           :=  _data_in4w[0].%X5;
            Inputs.NOK                          :=  _data_in4w[0].%X6;
            Inputs.ToolButton                   :=  _data_in4w[0].%X7;

            Inputs.CcwSelect                    :=  _data_in4w[1].%X8;        //  2
            Inputs.StartButton                  :=  _data_in4w[1].%X9;
            Inputs.TrigOut                      :=  _data_in4w[1].%X10;
            Inputs.TorqueHigh                   :=  _data_in4w[1].%X11;
            Inputs.TorqueLow                    :=  _data_in4w[1].%X12;
            Inputs.AngleHigh                    :=  _data_in4w[1].%X13;
            Inputs.AngleLow                     :=  _data_in4w[1].%X14;
            Inputs.CcwLockAck                   :=  _data_in4w[1].%X15;

            Inputs.EnableAck                    :=  _data_in4w[1].%X0;        //  3
            Inputs.ActiveEnableAck              :=  _data_in4w[1].%X1;
            Inputs.CwLockAck                    :=  _data_in4w[1].%X2;
            Inputs.CwAck                        :=  _data_in4w[1].%X3;
            Inputs.CcwAck                       :=  _data_in4w[1].%X4;
            Inputs.ES_LED_GreenAck              :=  _data_in4w[1].%X5;
            Inputs.ES_LED_YellowAck             :=  _data_in4w[1].%X6;
            Inputs.ES_LED_RedAck                :=  _data_in4w[1].%X7;

            Inputs.Result                       :=  _data_in4w[2].%B1;        //  4
            Inputs.IDcode[0]                    :=  _data_in4w[2].%B0;        //  5
            Inputs.IDcode[1]                    :=  _data_in4w[3].%B1;        //  6
            Inputs.IDcode[2]                    :=  _data_in4w[3].%B0;        //  7

            //  Slot 11 Input_4_word_2
            _returnValue := Siemens.Simatic.S71500.DistributedIO.ReadData(TO_WORD(Config.HWIDs.HwID_Slot_11) ,_data_in4w);
            IF _returnValue > WORD#0 THEN
                Messenger.Activate(UINT#1202, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1202;
                RETURN;
            END_IF;

            Inputs.IDcode[3]                    :=  _data_in4w[0].%B1;        //  8
            Inputs.IDcode[4]                    :=  _data_in4w[0].%B0;        //  9
            Inputs.IDcode[5]                    :=  _data_in4w[1].%B1;        //  10
            Inputs.IDcode[6]                    :=  _data_in4w[1].%B0;        //  11
            Inputs.IDcode[7]                    :=  _data_in4w[2].%B1;        //  12
            Inputs.IDcode[8]                    :=  _data_in4w[2].%B0;        //  13
            Inputs.IDcode[9]                    :=  _data_in4w[3].%B1;        //  14
            Inputs.IDcode[10]                   :=  _data_in4w[3].%B0;        //  15

            //  Slot 12 Input_4_word_3
            _returnValue := Siemens.Simatic.S71500.DistributedIO.ReadData(TO_WORD(Config.HWIDs.HwID_Slot_12) ,_data_in4w);
            IF _returnValue > WORD#0 THEN
                Messenger.Activate(UINT#1203, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1203;
                RETURN;
            END_IF;

            Inputs.IDcode[11]                   :=  _data_in4w[0].%B1;        //  16
            Inputs.IDcode[12]                   :=  _data_in4w[0].%B0;        //  17
            Inputs.IDcode[13]                   :=  _data_in4w[1].%B1;        //  18
            Inputs.IDcode[14]                   :=  _data_in4w[1].%B0;        //  19
            Inputs.IDcode[15]                   :=  _data_in4w[2].%B1;        //  20
            Inputs.IDcode[16]                   :=  _data_in4w[2].%B0;        //  21
            Inputs.IDcode[17]                   :=  _data_in4w[3].%B1;        //  22
            Inputs.IDcode[18]                   :=  _data_in4w[3].%B0;        //  23

            _returnValue := Siemens.Simatic.S71500.DistributedIO.ReadData(TO_WORD(Config.HWIDs.HwID_Slot_13) ,_data_in4w);
            IF _returnValue > WORD#0 THEN
                Messenger.Activate(UINT#1204, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1204;
                RETURN;
            END_IF;

            //  Slot 13 Input_4_word_4
            Inputs.IDcode[19]                   :=  _data_in4w[0].%B1;        //  24
            Inputs.IDcode[20]                   :=  _data_in4w[0].%B0;        //  25
            Inputs.IDcode[21]                   :=  _data_in4w[1].%B1;        //  26
            Inputs.IDcode[22]                   :=  _data_in4w[1].%B0;        //  27
            Inputs.IDcode[23]                   :=  _data_in4w[2].%B1;        //  28
            Inputs.IDcode[24]                   :=  _data_in4w[2].%B0;        //  29
            Inputs.IDcode[25]                   :=  _data_in4w[3].%B1;        //  30
            Inputs.IDcode[26]                   :=  _data_in4w[3].%B0;        //  31

            //  Slot 14 Input_4_word_5
            _returnValue := Siemens.Simatic.S71500.DistributedIO.ReadData(TO_WORD(Config.HWIDs.HwID_Slot_14) ,_data_in4w);
            IF _returnValue > WORD#0 THEN
                Messenger.Activate(UINT#1205, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1205;
                RETURN;
            END_IF;

            Inputs.IDcode[27]                   :=  _data_in4w[0].%B1;        //  32
            Inputs.IDcode[28]                   :=  _data_in4w[0].%B0;        //  33
            Inputs.IDcode[29]                   :=  _data_in4w[1].%B1;        //  34
            Inputs.IDcode[30]                   :=  _data_in4w[1].%B0;        //  35
            Inputs.IDcode[31]                   :=  _data_in4w[2].%B1;        //  36
            Inputs.IDcode[32]                   :=  _data_in4w[2].%B0;        //  37
            Inputs.IDcode[33]                   :=  _data_in4w[3].%B1;        //  38
            Inputs.IDcode[34]                   :=  _data_in4w[3].%B0;        //  39

            //  Slot 15 Input_4_word_6
            _returnValue := Siemens.Simatic.S71500.DistributedIO.ReadData(TO_WORD(Config.HWIDs.HwID_Slot_15) ,_data_in4w);
            IF _returnValue > WORD#0 THEN
                Messenger.Activate(UINT#1206, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1206;
                RETURN;
            END_IF;

            Inputs.IDcode[35]                   :=  _data_in4w[0].%B1;        //  40
            Inputs.IDcode[36]                   :=  _data_in4w[0].%B0;        //  41
            Inputs.IDcode[37]                   :=  _data_in4w[1].%B1;        //  42
            Inputs.IDcode[38]                   :=  _data_in4w[1].%B0;        //  43
            Inputs.IDcode[39]                   :=  _data_in4w[2].%B1;        //  44
            Inputs.IDcode[40]                   :=  _data_in4w[2].%B0;        //  45
            Inputs.IDcode[41]                   :=  _data_in4w[3].%B1;        //  46
            Inputs.IDcode[42]                   :=  _data_in4w[3].%B0;        //  47

            //  Slot 16 Input_4_word_7
            _returnValue := Siemens.Simatic.S71500.DistributedIO.ReadData(TO_WORD(Config.HWIDs.HwID_Slot_16) ,_data_in4w);
            IF _returnValue > WORD#0 THEN
                Messenger.Activate(UINT#1207, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1207;
                RETURN;
            END_IF;

            Inputs.IDcode[43]                   :=  _data_in4w[0].%B1;        //  48
            Inputs.IDcode[44]                   :=  _data_in4w[0].%B0;        //  49
            Inputs.IDcode[45]                   :=  _data_in4w[1].%B1;        //  50
            Inputs.IDcode[46]                   :=  _data_in4w[1].%B0;        //  51
            Inputs.IDcode[47]                   :=  _data_in4w[2].%B1;        //  52
            Inputs.IDcode[48]                   :=  _data_in4w[2].%B0;        //  53
            Inputs.IDcode[49]                   :=  _data_in4w[3].%B1;        //  54
            Inputs.IDcode[50]                   :=  _data_in4w[3].%B0;        //  55

            //  Slot 17 Input_4_word_8
            _returnValue := Siemens.Simatic.S71500.DistributedIO.ReadData(TO_WORD(Config.HWIDs.HwID_Slot_17) ,_data_in4w);
            IF _returnValue > WORD#0 THEN
                Messenger.Activate(UINT#1208, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1208;
                RETURN;
            END_IF;

            Inputs.IDcode[51]                   :=  _data_in4w[0].%B1;        //  56
            Inputs.IDcode[52]                   :=  _data_in4w[0].%B0;        //  57
            Inputs.IDcode[53]                   :=  _data_in4w[1].%B1;        //  58
            Inputs.IDcode[54]                   :=  _data_in4w[1].%B0;        //  59
            Inputs.IDcode[55]                   :=  _data_in4w[2].%B1;        //  60
            Inputs.IDcode[56]                   :=  _data_in4w[2].%B0;        //  61
            Inputs.IDcode[57]                   :=  _data_in4w[3].%B1;        //  62
            Inputs.IDcode[58]                   :=  _data_in4w[3].%B0;        //  63

            //  Slot 18 Input_4_word_9
            _returnValue := Siemens.Simatic.S71500.DistributedIO.ReadData(TO_WORD(Config.HWIDs.HwID_Slot_18) ,_data_in4w);
            IF _returnValue > WORD#0 THEN
                Messenger.Activate(UINT#1209, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1209;
                RETURN;
            END_IF;

            Inputs.IDcode[59]                   :=  _data_in4w[0].%B1;        //  64
            Inputs.IDcode[60]                   :=  _data_in4w[0].%B0;        //  65
            Inputs.IDcode[61]                   :=  _data_in4w[1].%B1;        //  66
            Inputs.IDcode[62]                   :=  _data_in4w[1].%B0;        //  67
            Inputs.IDcode[63]                   :=  _data_in4w[2].%B1;        //  68
            
            _dword.%B0                          :=  _data_in4w[2].%B0;        //  69
            _dword.%B1                          :=  _data_in4w[3].%B1;        //  70
            _dword.%B2                          :=  _data_in4w[3].%B0;        //  71

            //  Slot 19 Input_4_word_10
            _returnValue := Siemens.Simatic.S71500.DistributedIO.ReadData(TO_WORD(Config.HWIDs.HwID_Slot_19) ,_data_in4w);
            IF _returnValue > WORD#0 THEN
                Messenger.Activate(UINT#1210, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1210;
                RETURN;
            END_IF;

            _dword.%B3                          :=  _data_in4w[0].%B1;        //  72
            Inputs.CnoSE                        :=  TO_UDINT(_dword);              
            Inputs.ProgramNo                    :=  _data_in4w[0].%B0;        //  73
            _dword.%B0                          :=  _data_in4w[1].%B1;        //  74
            _dword.%B1                          :=  _data_in4w[1].%B0;        //  75
            _dword.%B2                          :=  _data_in4w[2].%B1;        //  76
            _dword.%B3                          :=  _data_in4w[2].%B0;        //  77
            Inputs.TorqueMin                    :=  TO_REAL(TO_DINT(_dword)) / Config.TorqueScalingConstant; /// REAL#100000.0;
            _dword.%B0                          :=  _data_in4w[3].%B1;        //  78
            _dword.%B1                          :=  _data_in4w[3].%B0;        //  79

            // Slot 20 Input_4_word_11
            _returnValue := Siemens.Simatic.S71500.DistributedIO.ReadData(TO_WORD(Config.HWIDs.HwID_Slot_20) ,_data_in4w);
            IF _returnValue > WORD#0 THEN
                Messenger.Activate(UINT#1211, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1211;
                RETURN;
            END_IF;  

            _dword.%B2                           :=  _data_in4w[0].%B1;        //  80
            _dword.%B3                           :=  _data_in4w[0].%B0;        //  81
            Inputs.Torque                        :=  TO_REAL(TO_DINT(_dword))  / Config.TorqueScalingConstant; /// REAL#100000.0;
            _dword.%B0                           :=  _data_in4w[1].%B1;        //  82
            _dword.%B1                           :=  _data_in4w[1].%B0;        //  83
            _dword.%B2                           :=  _data_in4w[2].%B1;        //  84
            _dword.%B3                           :=  _data_in4w[2].%B0;        //  85
            Inputs.TorqueMax                     :=  TO_REAL(TO_DINT(_dword))  / Config.TorqueScalingConstant; /// REAL#100000.0;
            _dword.%B0                           :=  _data_in4w[3].%B1;        //  86
            _dword.%B1                           :=  _data_in4w[3].%B0;        //  87

            // Slot 21 Input_4_word_12
            _returnValue := Siemens.Simatic.S71500.DistributedIO.ReadData(TO_WORD(Config.HWIDs.HwID_Slot_21) ,_data_in4w);
            IF _returnValue > WORD#0 THEN
                Messenger.Activate(UINT#1212, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1212;
                RETURN;
            END_IF;  

            _dword.%B2                           :=  _data_in4w[0].%B1;        //  88
            _dword.%B3                           :=  _data_in4w[0].%B0;        //  89
            Inputs.AngleMin                      :=  TO_REAL(TO_DINT(_dword))  / Config.AngleScalingConstant; /// REAL#100000.0;
            _dword.%B0                           :=  _data_in4w[1].%B1;        //  90
            _dword.%B1                           :=  _data_in4w[1].%B0;        //  91
            _dword.%B2                           :=  _data_in4w[2].%B1;        //  92
            _dword.%B3                           :=  _data_in4w[2].%B0;        //  93
            Inputs.Angle                         :=  TO_REAL(TO_DINT(_dword)) / Config.AngleScalingConstant; /// REAL#100000.0;
            _dword.%B0                           :=  _data_in4w[3].%B1;        //  94
            _dword.%B1                           :=  _data_in4w[3].%B0;        //  95

            // Slot 22 Input_4_word_13
            _returnValue := Siemens.Simatic.S71500.DistributedIO.ReadData(TO_WORD(Config.HWIDs.HwID_Slot_22) ,_data_in4w);
            IF _returnValue > WORD#0 THEN
                Messenger.Activate(UINT#1213, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1213;
                RETURN;
            END_IF;  
            _dword.%B2                          :=  _data_in4w[0].%B1;        //  96
            _dword.%B3                          :=  _data_in4w[0].%B0;        //  97
            Inputs.AngleMax                     :=  TO_REAL(TO_DINT(_dword)) / Config.AngleScalingConstant; /// REAL#100000.0;

            Inputs.ErrorCode.%B0                :=  _data_in4w[1].%B1;        //  99  
            Inputs.ErrorCode.%B1                :=  _data_in4w[1].%B0;        //  98
            Inputs.ErrorClass.%B0               :=  _data_in4w[2].%B1;        //  101  
            Inputs.ErrorClass.%B1               :=  _data_in4w[2].%B0;        //  100

            // Slot 23 Input_4_word_14
            _returnValue := Siemens.Simatic.S71500.DistributedIO.ReadData(TO_WORD(Config.HWIDs.HwID_Slot_23) ,_data_in4w);
            IF _returnValue > WORD#0 THEN
                Messenger.Activate(UINT#1214, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1214;
                RETURN;
            END_IF;  

            // Slot 24 Input_4_word_15
            _returnValue := Siemens.Simatic.S71500.DistributedIO.ReadData(TO_WORD(Config.HWIDs.HwID_Slot_24) ,_data_in4w);
            IF _returnValue > WORD#0 THEN
                Messenger.Activate(UINT#1215, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1215;
                RETURN;
            END_IF;  

            // Slot 25 Input_4_word_16
            _returnValue := Siemens.Simatic.S71500.DistributedIO.ReadData(TO_WORD(Config.HWIDs.HwID_Slot_25) ,_data_in4w);
            IF _returnValue > WORD#0 THEN
                Messenger.Activate(UINT#1216, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1216;
                RETURN;
            END_IF;  

            // Slot 26 Input_2_word_1
            _returnValue := Siemens.Simatic.S71500.DistributedIO.ReadData(TO_WORD(Config.HWIDs.HwID_Slot_26) ,_data_in4w);
            IF _returnValue > WORD#0 THEN
                Messenger.Activate(UINT#1217, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1217;
                RETURN;
            END_IF;  

            //*************INITIALIZATION*********************
            RestoreTask.Run(THIS);
            DisableTask.Run(THIS);
            EnableTask.Run(THIS);
            DisableClockwiseTask.Run(THIS);
            EnableClockwiseTask.Run(THIS);
            DisableCounterClockwiseTask.Run(THIS);
            EnableCounterClockwiseTask.Run(THIS);
            ResetFaultTask.Run(THIS);
            ResetResultsTask.Run(THIS);
            SetScrewingProgramTask.Run(THIS);
            GetScrewingResultsTask.Run(THIS);
            ScrewClockwiseTask.Run(THIS);
            ScrewCounterClockwiseTask.Run(THIS);
            RunAutomatTask.Run(THIS);
   
            //************************************************
            _blink.Blink(THIS, T#500ms,T#500ms);
            //********************Diagnostics*****************        
            HardwareDiagnosticsTask.Run(THIS,Config.HWIDs.HW_Device);
            //************************************************
    
            //*************RESTORE****************************
            RestoreTask.SetIsDisabled(FALSE);
            IF RestoreTask.Execute(THIS) THEN
                THIS.Restore();
            END_IF;
            //************************************************
            
    
            //*************DisableTask************************
            DisableTask.SetIsDisabled(FALSE);
            IF DisableTask.StartTriggered() THEN
                Status.Action.Id :=  UINT#100;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#100,DisableTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#101,DisableTask.IsDone(), eAxoMessageCategory#Info);
            IF DisableTask.Execute(THIS) THEN
                IF _progress = 0 THEN
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 300;
                END_IF;
    
                IF _progress = 300 THEN                                                                                     // DisableTask running
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#500, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#500;
                    END_IF;

                    Outputs.Enable := FALSE;

                    IF NOT Inputs.EnableAck THEN
                        THIS.CallTimers(FALSE);
                        _progress := 301;
                    END_IF;
                END_IF;
                
                IF _progress = 301 THEN                                                                                     // DisableTask finished
                    DisableTask.DoneWhen(TRUE);
                    _progress := 0;
                END_IF;
    
                THIS.CallTimers(TRUE);
                
                DisableTask.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);  
                DisableTask.ThrowWhen(DisableTask.Duration >= Config.TaskTimeout AND Config.TaskTimeout > T#0s ,'DisableTask timeout.');                
            END_IF;
            IF DisableTask.DoneReached() THEN
                Status.Action.Id :=  UINT#101;
                Status.Error.Id :=  UINT#0;
            ELSIF DisableTask.ErrorOccured() THEN
                Status.Action.Id :=  UINT#10000;
                Status.Error.Id  :=  UINT#10000;
            ELSIF DisableTask.AbortTriggered()THEN
                Status.Action.Id :=  UINT#10001;
                Status.Error.Id  :=  UINT#10001;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#10000,DisableTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#10001,DisableTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#102,DisableTask.RestoreTriggered() , eAxoMessageCategory#Error);
            IF DisableTask.RestoreTriggered() AND _progress >= 300 AND _progress <= 304  THEN
                Status.Action.Id :=  UINT#102;
                _progress := 0;
            END_IF;
            //**************************************************

            //*************EnableTask***************************
            EnableTask.SetIsDisabled(FALSE);
            IF EnableTask.StartTriggered() THEN
                Status.Action.Id :=  UINT#105;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#105,EnableTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#106,EnableTask.IsDone(), eAxoMessageCategory#Info);
            IF EnableTask.Execute(THIS) THEN
                IF _progress = 0 THEN
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 305;
                END_IF;
                
                IF _progress = 305 THEN                                                                                     // EnableTask running
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#505, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#505;
                    END_IF;
    
                    Outputs.Enable := TRUE;

                    IF Inputs.EnableAck THEN
                        THIS.CallTimers(FALSE);
                        _progress := 306;
                    END_IF;
                END_IF;
                
                IF _progress = 306 THEN                                                                                     // EnableTask finished
                    EnableTask.DoneWhen(TRUE);
                    _progress := 0;
                END_IF;
    
                THIS.CallTimers(TRUE);
                
                EnableTask.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);  
                EnableTask.ThrowWhen(EnableTask.Duration >= Config.TaskTimeout AND Config.TaskTimeout > T#0s ,'EnableTask timeout.');                
            END_IF;
            IF EnableTask.DoneReached() THEN
                Status.Action.Id :=  UINT#106;
                Status.Error.Id :=  UINT#0;
            ELSIF EnableTask.ErrorOccured() THEN
                Status.Action.Id :=  UINT#10005;
                Status.Error.Id  :=  UINT#10005;
            ELSIF EnableTask.AbortTriggered()THEN
                Status.Action.Id :=  UINT#10006;
                Status.Error.Id  :=  UINT#10006;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#10005,EnableTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#10006,EnableTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#107,EnableTask.RestoreTriggered() , eAxoMessageCategory#Error);
            IF EnableTask.RestoreTriggered() AND _progress >= 305 AND _progress <= 309  THEN
                Status.Action.Id :=  UINT#107;
                _progress := 0;
            END_IF;
            //**************************************************
        
            //*************DisableClockwiseTask*****************
            DisableClockwiseTask.SetIsDisabled(FALSE);
            IF DisableClockwiseTask.StartTriggered() THEN
                Status.Action.Id :=  UINT#110;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#110,DisableClockwiseTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#111,DisableClockwiseTask.IsDone(), eAxoMessageCategory#Info);
            IF DisableClockwiseTask.Execute(THIS) THEN
                IF _progress = 0 THEN
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 310;
                END_IF;
    
                IF _progress = 310 THEN                                                                                     // DisableClockwiseTask running
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#510, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#510;
                    END_IF;
    
                    Outputs.CwAnd := FALSE;
                    Outputs.CwLock := TRUE;

                    IF Inputs.CwLockAck THEN
                        THIS.CallTimers(FALSE);
                        _progress := 311;
                    END_IF;
                END_IF;
    
                IF _progress = 311 THEN                                                                                     // DisableClockwiseTask finished
                    DisableClockwiseTask.DoneWhen(TRUE);
                    _progress := 0;
                END_IF;
    
                THIS.CallTimers(TRUE);
                
                DisableClockwiseTask.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);  
                DisableClockwiseTask.ThrowWhen(DisableClockwiseTask.Duration >= Config.TaskTimeout AND Config.TaskTimeout > T#0s ,'DisableClockwiseTask timeout.');                
            END_IF;
            IF DisableClockwiseTask.DoneReached() THEN
                Status.Action.Id :=  UINT#111;
                Status.Error.Id :=  UINT#0;
            ELSIF DisableClockwiseTask.ErrorOccured() THEN
                Status.Action.Id :=  UINT#10010;
                Status.Error.Id  :=  UINT#10010;
            ELSIF DisableClockwiseTask.AbortTriggered()THEN
                Status.Action.Id :=  UINT#10011;
                Status.Error.Id  :=  UINT#10011;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#10010,DisableClockwiseTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#10011,DisableClockwiseTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#112,DisableClockwiseTask.RestoreTriggered() , eAxoMessageCategory#Error);
            IF DisableClockwiseTask.RestoreTriggered() AND _progress >= 310 AND _progress <= 314  THEN
                Status.Action.Id :=  UINT#112;
                _progress := 0;
            END_IF;
            //**************************************************
    
            //*************EnableClockwiseTask******************
            EnableClockwiseTask.SetIsDisabled(FALSE);
            IF EnableClockwiseTask.StartTriggered() THEN
                Status.Action.Id :=  UINT#115;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#115,EnableClockwiseTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#116,EnableClockwiseTask.IsDone(), eAxoMessageCategory#Info);
            IF EnableClockwiseTask.Execute(THIS) THEN
                IF _progress = 0 THEN
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 315;
                END_IF;
                
                IF _progress = 315 THEN                                                                                     // EnableClockwiseTask running: , <add the detailed description of the current action 6>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#515, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#515;
                    END_IF;
                    
                    Outputs.CwAnd := TRUE;
                    Outputs.CwLock := FALSE;
                    
                    IF NOT Inputs.CwLockAck THEN
                        THIS.CallTimers(FALSE);
                        _progress := 316;
                    END_IF;
                END_IF;
                
                IF _progress = 316 THEN                                                                                     // EnableClockwiseTask running: , <add the detailed description of the current action 10>
                    EnableClockwiseTask.DoneWhen(TRUE);
                    _progress := 0;
                END_IF;
    
                THIS.CallTimers(TRUE);
                
                EnableClockwiseTask.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);  
                EnableClockwiseTask.ThrowWhen(EnableClockwiseTask.Duration >= Config.TaskTimeout AND Config.TaskTimeout > T#0s ,'EnableClockwiseTask timeout.');                
            END_IF;
            IF EnableClockwiseTask.DoneReached() THEN
                Status.Action.Id :=  UINT#116;
                Status.Error.Id :=  UINT#0;
            ELSIF EnableClockwiseTask.ErrorOccured() THEN
                Status.Action.Id :=  UINT#10015;
                Status.Error.Id  :=  UINT#10015;
            ELSIF EnableClockwiseTask.AbortTriggered()THEN
                Status.Action.Id :=  UINT#10016;
                Status.Error.Id  :=  UINT#10016;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#10015,EnableClockwiseTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#10016,EnableClockwiseTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#117,EnableClockwiseTask.RestoreTriggered() , eAxoMessageCategory#Error);
            IF EnableClockwiseTask.RestoreTriggered() AND _progress >= 315 AND _progress <= 319  THEN
                Status.Action.Id :=  UINT#117;
                _progress := 0;
            END_IF;
            //**************************************************

            //*************DisableCounterClockwiseTask**********
            DisableCounterClockwiseTask.SetIsDisabled(FALSE);
            IF DisableCounterClockwiseTask.StartTriggered() THEN
                Status.Action.Id :=  UINT#120;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#120,DisableCounterClockwiseTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#121,DisableCounterClockwiseTask.IsDone(), eAxoMessageCategory#Info);
            IF DisableCounterClockwiseTask.Execute(THIS) THEN
                IF _progress = 0 THEN
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 320;
                END_IF;
    
                IF _progress = 320 THEN                                                                                     // DisableCounterClockwiseTask running
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#520, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#520;
                    END_IF;

                    Outputs.CcwAnd := FALSE;
                    Outputs.CcwLock := TRUE;
                    
                    IF Inputs.CcwLockAck THEN
                        THIS.CallTimers(FALSE);
                        _progress := 321;
                    END_IF;
                END_IF;
                
                IF _progress = 321 THEN                                                                                     // DisableCounterClockwiseTask finished
                    DisableCounterClockwiseTask.DoneWhen(TRUE);
                    _progress := 0;
                END_IF;
    
                THIS.CallTimers(TRUE);
                
                DisableCounterClockwiseTask.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);  
                DisableCounterClockwiseTask.ThrowWhen(DisableCounterClockwiseTask.Duration >= Config.TaskTimeout AND Config.TaskTimeout > T#0s ,'DisableCounterClockwiseTask timeout.');                
            END_IF;
            IF DisableCounterClockwiseTask.DoneReached() THEN
                Status.Action.Id :=  UINT#121;
                Status.Error.Id :=  UINT#0;
            ELSIF DisableCounterClockwiseTask.ErrorOccured() THEN
                Status.Action.Id :=  UINT#10020;
                Status.Error.Id  :=  UINT#10020;
            ELSIF DisableCounterClockwiseTask.AbortTriggered()THEN
                Status.Action.Id :=  UINT#10021;
                Status.Error.Id  :=  UINT#10021;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#10020,DisableCounterClockwiseTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#10021,DisableCounterClockwiseTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#122,DisableCounterClockwiseTask.RestoreTriggered() , eAxoMessageCategory#Error);
            IF DisableCounterClockwiseTask.RestoreTriggered() AND _progress >= 320 AND _progress <= 324  THEN
                Status.Action.Id :=  UINT#122;
                _progress := 0;
            END_IF;
            //**************************************************
   
            //*************EnableCounterClockwiseTask***********
            EnableCounterClockwiseTask.SetIsDisabled(FALSE);
            IF EnableCounterClockwiseTask.StartTriggered() THEN
                Status.Action.Id :=  UINT#125;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#125,EnableCounterClockwiseTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#126,EnableCounterClockwiseTask.IsDone(), eAxoMessageCategory#Info);
            IF EnableCounterClockwiseTask.Execute(THIS) THEN
                IF _progress = 0 THEN
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 325;
                END_IF;
    
                IF _progress = 325 THEN                                                                                     // EnableCounterClockwiseTask running
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#525, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#525;
                    END_IF;
    
                    Outputs.CcwAnd := TRUE;
                    Outputs.CcwLock := FALSE;

                    IF NOT Inputs.CcwLockAck THEN
                        THIS.CallTimers(FALSE);
                        _progress := 326;
                    END_IF;
                END_IF;
                
                IF _progress = 326 THEN                                                                                     // EnableCounterClockwiseTask finished
                    EnableCounterClockwiseTask.DoneWhen(TRUE);
                    _progress := 0;
                END_IF;
    
                THIS.CallTimers(TRUE);
                
                EnableCounterClockwiseTask.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);  
                EnableCounterClockwiseTask.ThrowWhen(EnableCounterClockwiseTask.Duration >= Config.TaskTimeout AND Config.TaskTimeout > T#0s ,'EnableCounterClockwiseTask timeout.');                
            END_IF;
            IF EnableCounterClockwiseTask.DoneReached() THEN
                Status.Action.Id :=  UINT#126;
                Status.Error.Id :=  UINT#0;
            ELSIF EnableCounterClockwiseTask.ErrorOccured() THEN
                Status.Action.Id :=  UINT#10025;
                Status.Error.Id  :=  UINT#10025;
            ELSIF EnableCounterClockwiseTask.AbortTriggered()THEN
                Status.Action.Id :=  UINT#10026;
                Status.Error.Id  :=  UINT#10026;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#10025,EnableCounterClockwiseTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#10026,EnableCounterClockwiseTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#127,EnableCounterClockwiseTask.RestoreTriggered() , eAxoMessageCategory#Error);
            IF EnableCounterClockwiseTask.RestoreTriggered() AND _progress >= 325 AND _progress <= 329  THEN
                Status.Action.Id :=  UINT#127;
                _progress := 0;
            END_IF;
            //**************************************************
            
            //*************ResetFaultTask***********************
            ResetFaultTask.SetIsDisabled(FALSE);
            IF ResetFaultTask.StartTriggered() THEN
                Status.Action.Id :=  UINT#130;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#130,ResetFaultTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#131,ResetFaultTask.IsDone(), eAxoMessageCategory#Info);
            IF ResetFaultTask.Execute(THIS) THEN
                IF _progress = 0 THEN
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 330;
                END_IF;
    
                IF _progress = 330 THEN                                                                                     // ResetFaultTask running
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#530, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#530;
                    END_IF;
    
                    Outputs.ResetFault := NOT Inputs.NoFault AND _blink.output;

                    IF Inputs.NoFault THEN
                        THIS.CallTimers(FALSE);
                        _progress := 331;
                    END_IF;
                END_IF;
    
                IF _progress = 331 THEN                                                                                     // ResetFaultTask finished
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#531, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#531;
                    END_IF;

                    IF Inputs.Ready THEN
                        THIS.CallTimers(FALSE);
                        _progress := 332;
                    END_IF;
                END_IF;
                
                IF _progress = 332 THEN                                                                                     // ResetFaultTask running: , <add the detailed description of the current action 3>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#532, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#532;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 333;
                    END_IF;
                END_IF;
                
                IF _progress = 333 THEN                                                                                     // ResetFaultTask running: , <add the detailed description of the current action 4>
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#533, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#533;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 334;
                    END_IF;
                END_IF;
                
                IF _progress = 334 THEN                                                                                     // ResetFaultTask running: , <add the detailed description of the current action 5>
                    ResetFaultTask.DoneWhen(TRUE);
                    _progress := 0;
                END_IF;
    
                THIS.CallTimers(TRUE);
                
                ResetFaultTask.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);  
                ResetFaultTask.ThrowWhen(ResetFaultTask.Duration >= Config.TaskTimeout AND Config.TaskTimeout > T#0s ,'ResetFaultTask timeout.');                
            END_IF;
            IF ResetFaultTask.DoneReached() THEN
                Status.Action.Id :=  UINT#131;
                Status.Error.Id :=  UINT#0;
            ELSIF ResetFaultTask.ErrorOccured() THEN
                Status.Action.Id :=  UINT#10030;
                Status.Error.Id  :=  UINT#10030;
            ELSIF ResetFaultTask.AbortTriggered()THEN
                Status.Action.Id :=  UINT#10031;
                Status.Error.Id  :=  UINT#10031;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#10030,ResetFaultTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#10031,ResetFaultTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#132,ResetFaultTask.RestoreTriggered() , eAxoMessageCategory#Error);
            IF ResetFaultTask.RestoreTriggered() AND _progress >= 330 AND _progress <= 334  THEN
                Status.Action.Id :=  UINT#132;
                _progress := 0;
            END_IF;
            //**************************************************
    
            //*************ResetResultsTask*********************
            ResetResultsTask.SetIsDisabled(FALSE);
            IF ResetResultsTask.StartTriggered() THEN
                Status.Action.Id :=  UINT#135;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#135,ResetResultsTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#136,ResetResultsTask.IsDone(), eAxoMessageCategory#Info);
            IF ResetResultsTask.Execute(THIS) THEN
                IF _progress = 0 THEN
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 335;
                END_IF;
    
                IF _progress = 335 THEN                                                                                     // ResetResultsTask running
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#535, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#535;
                    END_IF;

                    Outputs.ResetResults := Inputs.CycleComplete AND _blink.output;
                    IF NOT Inputs.CycleComplete THEN
                        Outputs.ResetResults := FALSE;
                        THIS.CallTimers(FALSE);
                        _progress := 336;
                    END_IF;
                END_IF;
                
                IF _progress = 336 THEN                                                                                     // ResetResultsTask finished
                    ResetResultsTask.DoneWhen(TRUE);
                    _progress := 0;
                END_IF;
    
                THIS.CallTimers(TRUE);
                
                ResetResultsTask.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);  
                ResetResultsTask.ThrowWhen(ResetResultsTask.Duration >= Config.TaskTimeout AND Config.TaskTimeout > T#0s ,'ResetResultsTask timeout.');                
            END_IF;
            IF ResetResultsTask.DoneReached() THEN
                Status.Action.Id :=  UINT#136;
                Status.Error.Id :=  UINT#0;
            ELSIF ResetResultsTask.ErrorOccured() THEN
                Status.Action.Id :=  UINT#10035;
                Status.Error.Id  :=  UINT#10035;
            ELSIF ResetResultsTask.AbortTriggered()THEN
                Status.Action.Id :=  UINT#10036;
                Status.Error.Id  :=  UINT#10036;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#10035,ResetResultsTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#10036,ResetResultsTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#137,ResetResultsTask.RestoreTriggered() , eAxoMessageCategory#Error);
            IF ResetResultsTask.RestoreTriggered() AND _progress >= 335 AND _progress <= 339  THEN
                Status.Action.Id :=  UINT#137;
                _progress := 0;
            END_IF;
            //**************************************************
            
            //*************SetScrewingProgramTask***************
            SetScrewingProgramTask.SetIsDisabled(FALSE);
            IF SetScrewingProgramTask.StartTriggered() THEN
                Status.Action.Id :=  UINT#140;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#140,SetScrewingProgramTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#141,SetScrewingProgramTask.IsDone(), eAxoMessageCategory#Info);
            IF SetScrewingProgramTask.Execute(THIS) THEN
                IF _progress = 0 THEN
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 340;
                END_IF;
    
                IF _progress = 340 THEN                                                                                     // SetScrewingProgramTask running: checking actual screwing program number
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#540, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#540;
                    END_IF;

                    IF _programNo <> Inputs.ProgramNo THEN
                        THIS.CallTimers(FALSE);
                        _progress := 341;
                    ELSE
                        THIS.CallTimers(FALSE);
                        _progress := 344;
                    END_IF;
                END_IF;
    
                IF _progress = 341 THEN                                                                                     // SetScrewingProgramTask running: checking required screwing program number
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#541, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#541;
                    END_IF;

                    IF _programNo>=BYTE#0 AND _programNo<=BYTE#99 THEN
                        THIS.CallTimers(FALSE);
                        _progress := 342;
                    ELSE
                        Messenger.Activate(ULINT#2000,eAxoMessageCategory#ProgrammingError);
                    END_IF;
                END_IF;
                
                IF _progress = 342 THEN                                                                                     // SetScrewingProgramTask running: waiting for the device to be ready
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#542, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#542;
                    END_IF;
    
                    IF Inputs.Ready THEN
                        THIS.CallTimers(FALSE);
                        _progress := 343;
                    END_IF;
                END_IF;
                
                IF _progress = 343 THEN                                                                                     // SetScrewingProgramTask running: waiting for the program to be set
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#543, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#543;
                    END_IF;
    
                    Outputs.ProgramNo := _programNo;

                    IF Inputs.ProgramNoAck = Outputs.ProgramNo THEN
                        THIS.CallTimers(FALSE);
                        _progress := 344;
                    END_IF;
                END_IF;
                
                IF _progress = 344 THEN                                                                                     // SetScrewingProgramTask finished
                    SetScrewingProgramTask.DoneWhen(TRUE);
                    _progress := 0;
                END_IF;
    
                THIS.CallTimers(TRUE);
                
                SetScrewingProgramTask.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);  
                SetScrewingProgramTask.ThrowWhen(SetScrewingProgramTask.Duration >= Config.TaskTimeout AND Config.TaskTimeout > T#0s ,'SetScrewingProgramTask timeout.');                
            END_IF;
            IF SetScrewingProgramTask.DoneReached() THEN
                Status.Action.Id :=  UINT#141;
                Status.Error.Id :=  UINT#0;
            ELSIF SetScrewingProgramTask.ErrorOccured() THEN
                Status.Action.Id :=  UINT#10040;
                Status.Error.Id  :=  UINT#10040;
            ELSIF SetScrewingProgramTask.AbortTriggered()THEN
                Status.Action.Id :=  UINT#10041;
                Status.Error.Id  :=  UINT#10041;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#10040,SetScrewingProgramTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#10041,SetScrewingProgramTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#142,SetScrewingProgramTask.RestoreTriggered() , eAxoMessageCategory#Error);
            IF SetScrewingProgramTask.RestoreTriggered() AND _progress >= 340 AND _progress <= 344  THEN
                Status.Action.Id :=  UINT#142;
                _progress := 0;
            END_IF;
            //**************************************************
    
            //*************GetScrewingResultsTask*******************
            GetScrewingResultsTask.SetIsDisabled(FALSE);
            IF GetScrewingResultsTask.StartTriggered() THEN
                Status.Action.Id :=  UINT#150;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#150,GetScrewingResultsTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#151,GetScrewingResultsTask.IsDone(), eAxoMessageCategory#Info);
            IF GetScrewingResultsTask.Execute(THIS) THEN
                IF _progress = 0 THEN
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 350;
                END_IF;
    
                IF _progress = 350 THEN                                                                                     // GetScrewingResultsTask running
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#550, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#550;
                    END_IF;
    
                    Results.Result := Inputs.Result;
                    Results.IDcode.Data := Inputs.IDcode;
                    Results.CnoSE := Inputs.CnoSE;		
                    Results.ProgramNo := Inputs.ProgramNo;		
                    Results.TorqueMin := Inputs.TorqueMin;			
                    Results.Torque := Inputs.Torque;		
                    Results.TorqueMax := Inputs.TorqueMax;		
                    Results.AngleMin := Inputs.AngleMin;		
                    Results.Angle := Inputs.Angle;		
                    Results.AngleMax := Inputs.AngleMax;			
                    Results.ErrorCode := Inputs.ErrorCode;
                    Results.ErrorClass := Inputs.ErrorClass;

                    Results.IDcode.ToggleDataChangedFlag();

                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 351;
                    END_IF;
                END_IF;
    
                IF _progress = 351 THEN                                                                                     // GetScrewingResultsTask finished
                    GetScrewingResultsTask.DoneWhen(TRUE);
                    _progress := 0;
                END_IF;
    
                THIS.CallTimers(TRUE);
                
                GetScrewingResultsTask.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);  
                GetScrewingResultsTask.ThrowWhen(GetScrewingResultsTask.Duration >= Config.TaskTimeout AND Config.TaskTimeout > T#0s ,'GetScrewingResultsTask timeout.');                
            END_IF;
            IF GetScrewingResultsTask.DoneReached() THEN
                Status.Action.Id :=  UINT#151;
                Status.Error.Id :=  UINT#0;
            ELSIF GetScrewingResultsTask.ErrorOccured() THEN
                Status.Action.Id :=  UINT#10050;
                Status.Error.Id  :=  UINT#10050;
            ELSIF GetScrewingResultsTask.AbortTriggered()THEN
                Status.Action.Id :=  UINT#10051;
                Status.Error.Id  :=  UINT#10051;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#10050,GetScrewingResultsTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#10051,GetScrewingResultsTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#152,GetScrewingResultsTask.RestoreTriggered() , eAxoMessageCategory#Error);
            IF GetScrewingResultsTask.RestoreTriggered() AND _progress >= 350 AND _progress <= 359  THEN
                Status.Action.Id :=  UINT#152;
                _progress := 0;
            END_IF;
            //**************************************************
    
            //*************ScrewClockwiseTask*******************
            ScrewClockwiseTask.SetIsDisabled(FALSE);
            IF ScrewClockwiseTask.StartTriggered() THEN
                Status.Action.Id :=  UINT#160;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#160,ScrewClockwiseTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#161,ScrewClockwiseTask.IsDone(), eAxoMessageCategory#Info);
            IF ScrewClockwiseTask.Execute(THIS) THEN
                IF _progress = 0 THEN
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 360;
                END_IF;
    
                IF _progress = 360 THEN                                                                                     // ScrewClockwiseTask running: waiting for the device to be ready
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#560, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#560;
                    END_IF;
    
                    IF Inputs.Ready THEN
                        THIS.CallTimers(FALSE);
                        _progress := 361;
                    END_IF;
                END_IF;
    
                IF _progress = 361 THEN                                                                                     // ScrewClockwiseTask running: enabling device
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#561, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#561;
                    END_IF;
    
                    Outputs.Enable := TRUE;
                    Outputs.ActiveEnable := TRUE;
                    IF Inputs.EnableAck THEN
                        THIS.CallTimers(FALSE);
                        _progress := 362;
                    END_IF;
                END_IF;
                
                IF _progress = 362 THEN                                                                                     // ScrewClockwiseTask running: enabling device
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#562, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#562;
                    END_IF;
    
                    Outputs.Enable := TRUE;
                    Outputs.ActiveEnable := TRUE;

                    IF Inputs.ActiveEnableAck THEN
                        THIS.CallTimers(FALSE);
                        _progress := 363;
                    END_IF;
                END_IF;
                
                IF _progress = 363 THEN                                                                                     // ScrewClockwiseTask running: enabling screwing clockwise
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#563, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#563;
                    END_IF;

                    Outputs.CwAnd := TRUE;
                    Outputs.CwLock := FALSE;

                    IF NOT Inputs.CwLockAck THEN
                        THIS.CallTimers(FALSE);
                        _progress := 364;
                    END_IF;
                END_IF;
                
                IF _progress = 364 THEN                                                                                     // ScrewClockwiseTask running: starting screwing clockwise
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#564, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#564;
                    END_IF;
    
                    Outputs.StartClockwise := TRUE;
                    
                    IF Inputs.InCycle THEN
                        THIS.CallTimers(FALSE);
                        _progress := 365;
                    END_IF;
                END_IF;
                
                IF _progress = 365 THEN                                                                                     // ScrewClockwiseTask running: screwing clockwise
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#565, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#565;
                    END_IF;

                    Outputs.StartClockwise := _automaticStart;

                    IF Inputs.InCycle THEN
                        THIS.CallTimers(FALSE);
                        _progress := 366;
                    END_IF;
                END_IF;
                
                IF _progress = 366 THEN                                                                                     // ScrewClockwiseTask running: screwing clockwise
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#566, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#566;
                    END_IF;

                    Outputs.StartClockwise := _automaticStart;
                    
                    IF Inputs.CycleComplete THEN
                        THIS.CallTimers(FALSE);
                        _progress := 367;
                    END_IF;
                END_IF;
                
                IF _progress = 367 THEN                                                                                     // ScrewClockwiseTask running: screwing clockwise finished
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#567, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#567;
                    END_IF;

                    Outputs.StartClockwise := FALSE;
                    Outputs.ActiveEnable := FALSE;
                    
                    IF NOT Inputs.InCycle THEN
                        THIS.CallTimers(FALSE);
                        _progress := 368;
                    END_IF;
                END_IF;
                
                IF _progress = 368 THEN                                                                                     // ScrewClockwiseTask running: screwing clockwise finished
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#568, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#568;
                    END_IF;

                    Outputs.StartClockwise := FALSE;
                    Outputs.ActiveEnable := FALSE;
                    
                    IF NOT Inputs.ActiveEnableAck THEN
                        THIS.CallTimers(FALSE);
                        _progress := 369;
                    END_IF;
                END_IF;
                
                IF _progress = 369 THEN                                                                                     // ScrewClockwiseTask running: screwing clockwise finished
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#569, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#569;
                    END_IF;

                    Outputs.StartClockwise := FALSE;
                    Outputs.ActiveEnable := FALSE;
                    
                    IF Inputs.CycleComplete THEN
                        THIS.CallTimers(FALSE);
                        _progress := 370;
                    END_IF;
                END_IF;
    
                IF _progress = 370 THEN                                                                                     // ScrewClockwiseTask running: disabling screwing clockwise
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#570, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#570;
                    END_IF;
    
                    Outputs.CwAnd := FALSE;
                    Outputs.CwLock := TRUE;

                    IF Inputs.CwLockAck THEN
                        THIS.CallTimers(FALSE);
                        _progress := 371;
                    END_IF;
                END_IF;
    
                IF _progress = 371 THEN                                                                                     // ScrewClockwiseTask running: disabling screwing counterclockwise
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#571, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#571;
                    END_IF;
    
                    Outputs.CcwAnd := FALSE;
                    Outputs.CcwLock := TRUE;
                    
                   IF Inputs.CcwLockAck THEN
                        THIS.CallTimers(FALSE);
                        _progress := 372;
                    END_IF;
                END_IF;
                
                IF _progress = 372 THEN                                                                                     // ScrewClockwiseTask finished
                    ScrewClockwiseTask.DoneWhen(TRUE);
                    _progress := 0;
                END_IF;
    
                THIS.CallTimers(TRUE);
                
                ScrewClockwiseTask.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);  
                ScrewClockwiseTask.ThrowWhen(ScrewClockwiseTask.Duration >= Config.TaskTimeout AND Config.TaskTimeout > T#0s ,'ScrewClockwiseTask timeout.');                
            END_IF;
            IF ScrewClockwiseTask.DoneReached() THEN
                Status.Action.Id :=  UINT#161;
                Status.Error.Id :=  UINT#0;
            ELSIF ScrewClockwiseTask.ErrorOccured() THEN
                Status.Action.Id :=  UINT#10060;
                Status.Error.Id  :=  UINT#10060;
            ELSIF ScrewClockwiseTask.AbortTriggered()THEN
                Status.Action.Id :=  UINT#10061;
                Status.Error.Id  :=  UINT#10061;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#10060,ScrewClockwiseTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#10061,ScrewClockwiseTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#162,ScrewClockwiseTask.RestoreTriggered() , eAxoMessageCategory#Error);
            IF ScrewClockwiseTask.RestoreTriggered() AND _progress >= 360 AND _progress <= 379  THEN
                Status.Action.Id :=  UINT#162;
                _progress := 0;
            END_IF;
            //*****************************************************            
    
            //*************ScrewCounterClockwiseTask***************
            ScrewCounterClockwiseTask.SetIsDisabled(FALSE);
            IF ScrewCounterClockwiseTask.StartTriggered() THEN
                Status.Action.Id :=  UINT#180;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#180,ScrewCounterClockwiseTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#181,ScrewCounterClockwiseTask.IsDone(), eAxoMessageCategory#Info);
            IF ScrewCounterClockwiseTask.Execute(THIS) THEN
                IF _progress = 0 THEN
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 380;
                END_IF;
    
                IF _progress = 380 THEN                                                                                     // ScrewCounterClockwiseTask running: waiting for the device to be ready
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#580, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#580;
                    END_IF;
    
                    IF Inputs.Ready THEN
                        THIS.CallTimers(FALSE);
                        _progress := 381;
                    END_IF;
                END_IF;
    
                IF _progress = 381 THEN                                                                                     // ScrewCounterClockwiseTask running: enabling device
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#581, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#581;
                    END_IF;
    
                    Outputs.Enable := TRUE;
                    Outputs.ActiveEnable := TRUE;
                    IF Inputs.EnableAck THEN
                        THIS.CallTimers(FALSE);
                        _progress := 382;
                    END_IF;
                END_IF;
                
                IF _progress = 382 THEN                                                                                     // ScrewCounterClockwiseTask running: enabling device
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#582, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#582;
                    END_IF;
    
                    Outputs.Enable := TRUE;
                    Outputs.ActiveEnable := TRUE;
                    IF Inputs.ActiveEnableAck THEN
                        THIS.CallTimers(FALSE);
                        _progress := 383;
                    END_IF;
                END_IF;
                
                IF _progress = 383 THEN                                                                                     // ScrewCounterClockwiseTask running: enabling screwing counterclockwise
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#583, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#583;
                    END_IF;
    
                    Outputs.CcwAnd := TRUE;
                    Outputs.CcwLock := FALSE;
                    IF NOT Inputs.CcwLockAck THEN
                        THIS.CallTimers(FALSE);
                        _progress := 384;
                    END_IF;
                END_IF;
                
                IF _progress = 384 THEN                                                                                     // ScrewCounterClockwiseTask running: enabling screwing counterclockwise
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#584, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#584;
                    END_IF;
    
                    IF _automaticStart THEN
                        Outputs.StartCounterClockwise := TRUE;
                    END_IF;
                    IF Inputs.InCycleCcw THEN
                        THIS.CallTimers(FALSE);
                        _progress := 385;
                    END_IF;
                END_IF;
                
                IF _progress = 385 THEN                                                                                     // ScrewCounterClockwiseTask running: screwing counterclockwise
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#585, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#585;
                    END_IF;
    
                    Outputs.StartCounterClockwise := TRUE;
                    IF Inputs.InCycleCcw THEN
                        THIS.CallTimers(FALSE);
                        _progress := 386;
                    END_IF;
                END_IF;
                
                IF _progress = 386 THEN                                                                                     // ScrewCounterClockwiseTask running: screwing counterclockwise
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#586, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#586;
                    END_IF;
    
                    Outputs.StartCounterClockwise := TRUE;
                    IF Inputs.CycleComplete THEN
                        THIS.CallTimers(FALSE);
                        _progress := 387;
                    END_IF;
                END_IF;
                
                IF _progress = 387 THEN                                                                                     // ScrewCounterClockwiseTask running: screwing counterclockwise finished
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#587, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#587;
                    END_IF;
    
                    Outputs.StartCounterClockwise := FALSE;
                    Outputs.ActiveEnable := FALSE;
                    
                    IF NOT Inputs.InCycleCcw THEN
                        THIS.CallTimers(FALSE);
                        _progress := 388;
                    END_IF;
                END_IF;
                
                IF _progress = 388 THEN                                                                                     // ScrewCounterClockwiseTask running: screwing counterclockwise finished
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#588, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#588;
                    END_IF;
    
                    Outputs.StartCounterClockwise := FALSE;
                    Outputs.ActiveEnable := FALSE;
                    
                    IF NOT Inputs.ActiveEnableAck THEN
                        THIS.CallTimers(FALSE);
                        _progress := 389;
                    END_IF;
                END_IF;
                
                IF _progress = 389 THEN                                                                                     // ScrewCounterClockwiseTask running: screwing counterclockwise finished
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#589, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#589;
                    END_IF;
    
                    Outputs.StartCounterClockwise := FALSE;
                    Outputs.ActiveEnable := FALSE;
                    
                    IF Inputs.CycleComplete THEN
                        THIS.CallTimers(FALSE);
                        _progress := 390;
                    END_IF;
                END_IF;
    
                IF _progress = 390 THEN                                                                                     // ScrewCounterClockwiseTask running: disabling screwing counterclockwise
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#590, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#590;
                    END_IF;
    
                    Outputs.CcwAnd := FALSE;
                    Outputs.CcwLock := TRUE;
                    IF Inputs.CcwLockAck THEN
                        THIS.CallTimers(FALSE);
                        _progress := 391;
                    END_IF;
                END_IF;
    
                IF _progress = 391 THEN                                                                                     // ScrewCounterClockwiseTask running: disabling screwing clockwise
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#591, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#591;
                    END_IF;
    
                    Outputs.CwAnd := FALSE;
                    Outputs.CwLock := TRUE;
                    IF Inputs.CwLockAck THEN
                        THIS.CallTimers(FALSE);
                        _progress := 392;
                    END_IF;
                END_IF;
                
                IF _progress = 392 THEN                                                                                     // ScrewCounterClockwiseTask finished
                    ScrewCounterClockwiseTask.DoneWhen(TRUE);
                    _progress := 0;
                END_IF;
    
                THIS.CallTimers(TRUE);
                
                ScrewCounterClockwiseTask.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);  
                ScrewCounterClockwiseTask.ThrowWhen(ScrewCounterClockwiseTask.Duration >= Config.TaskTimeout AND Config.TaskTimeout > T#0s ,'ScrewCounterClockwiseTask timeout.');                
            END_IF;
            IF ScrewCounterClockwiseTask.DoneReached() THEN
                Status.Action.Id :=  UINT#181;
                Status.Error.Id :=  UINT#0;
            ELSIF ScrewCounterClockwiseTask.ErrorOccured() THEN
                Status.Action.Id :=  UINT#10080;
                Status.Error.Id  :=  UINT#10080;
            ELSIF ScrewCounterClockwiseTask.AbortTriggered()THEN
                Status.Action.Id :=  UINT#10081;
                Status.Error.Id  :=  UINT#10081;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#10080,ScrewCounterClockwiseTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#10081,ScrewCounterClockwiseTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#182,ScrewCounterClockwiseTask.RestoreTriggered() , eAxoMessageCategory#Error);
            IF ScrewCounterClockwiseTask.RestoreTriggered() AND _progress >= 380 AND _progress <= 399  THEN
                Status.Action.Id :=  UINT#182;
                _progress := 0;
            END_IF;
            //**************************************************
    
            //*************RunAutomatTask***********************
            RunAutomatTask.SetIsDisabled(FALSE);
            IF RunAutomatTask.StartTriggered() THEN
                Status.Action.Id :=  UINT#200;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#200,RunAutomatTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#201,RunAutomatTask.IsDone(), eAxoMessageCategory#Info);
            IF RunAutomatTask.Execute(THIS) THEN
                IF _progress = 0 THEN
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 400;
                END_IF;
    
                IF _progress = 400 THEN                                                                                     // RunAutomatTask running: initialization
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#600, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#600;
                    END_IF;

                    OK := FALSE;
                    NOK := FALSE;

                    Outputs.IDcode := _IDcode;

                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 401;
                    END_IF;
                END_IF;
    
                IF _progress = 401 THEN                                                                                     // RunAutomatTask running: reseting fault
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#601, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#601;
                    END_IF;
    
                    Outputs.ResetFault := NOT Inputs.NoFault AND _blink.output;
                    IF Inputs.NoFault THEN
                        Outputs.ResetFault := FALSE;
                        THIS.CallTimers(FALSE);
                        _progress := 402;
                    END_IF;
                END_IF;
                
                IF _progress = 402 THEN                                                                                     // RunAutomatTask running: reseting fault
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#602, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#602;
                    END_IF;
    
                    Outputs.ResetFault := NOT Inputs.NoFault AND _blink.output;
                    IF Inputs.Ready THEN
                        Outputs.ResetFault := FALSE;
                        THIS.CallTimers(FALSE);
                        _progress := 403;
                    END_IF;
                END_IF;
                
                IF _progress = 403 THEN                                                                                     // RunAutomatTask running: checking the actual screwing program number
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#603, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#603;
                    END_IF;

                    IF _programNo <> Inputs.ProgramNo THEN
                        THIS.CallTimers(FALSE);
                        _progress := 404;
                    ELSE
                        THIS.CallTimers(FALSE);
                        _progress := 407;
                    END_IF;
                END_IF;
                
                IF _progress = 404 THEN                                                                                     // RunAutomatTask running: checking the required screwing program number
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#604, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#604;
                    END_IF;
    
                    IF _programNo>=BYTE#0 AND _programNo<=BYTE#99 THEN
                        THIS.CallTimers(FALSE);
                        _progress := 405;
                    ELSE
                        Messenger.Activate(ULINT#1100,eAxoMessageCategory#ProgrammingError);
                    END_IF;
                END_IF;
                
                IF _progress = 405 THEN                                                                                     // RunAutomatTask running: waiting for the device to be ready
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#605, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#605;
                    END_IF;
    
                    IF Inputs.Ready THEN
                        THIS.CallTimers(FALSE);
                        _progress := 406;
                    END_IF;
                END_IF;
                
                IF _progress = 406 THEN                                                                                     // RunAutomatTask running: waiting for the screwing program to be set
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#606, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#606;
                    END_IF;
    
                    Outputs.ProgramNo := _programNo;

                    IF Inputs.ProgramNoAck = Outputs.ProgramNo THEN
                        THIS.CallTimers(FALSE);
                        _progress := 407;
                    END_IF;
                END_IF;
                
                IF _progress = 407 THEN                                                                                     // RunAutomatTask running: enabling device
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#607, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#607;
                    END_IF;

                    Outputs.Enable := TRUE;

                    IF Inputs.EnableAck THEN
                        THIS.CallTimers(FALSE);
                        _progress := 408;
                    END_IF;
                END_IF;
                
                IF _progress = 408 THEN                                                                                     // RunAutomatTask running: reseting previous results
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#608, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#608;
                    END_IF;
    
                    Outputs.ResetResults := Inputs.CycleComplete AND _blink.output;
                    IF NOT Inputs.CycleComplete THEN
                        Outputs.ResetResults := FALSE;
                        THIS.CallTimers(FALSE);
                        _progress := 409;
                    END_IF;
                END_IF;
                
                IF _progress = 409 THEN                                                                                     // RunAutomatTask running: enabling device
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#609, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#609;
                    END_IF;

                    Outputs.ActiveEnable := TRUE;
                    IF Inputs.ActiveEnableAck THEN
                        THIS.CallTimers(FALSE);
                        _progress := 410;
                    END_IF;
                END_IF;
    
                IF _progress = 410 THEN                                                                                     // RunAutomatTask running: enabling screwing clockwise
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#610, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#610;
                    END_IF;
    
                    Outputs.CwAnd := TRUE;
                    Outputs.CwLock := FALSE;
                    IF NOT Inputs.CwLockAck THEN
                        THIS.CallTimers(FALSE);
                        _progress := 411;
                    END_IF;
                END_IF;
    
                IF _progress = 411 THEN                                                                                     // RunAutomatTask running: starting screwing clockwise
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#611, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#611;
                    END_IF;
    
                    Outputs.StartClockwise := TRUE;
                    IF Inputs.InCycle THEN
                        THIS.CallTimers(FALSE);
                        _progress := 412;
                    END_IF;
                END_IF;
                
                IF _progress = 412 THEN                                                                                     // RunAutomatTask running: screwing clockwise
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#612, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#612;
                    END_IF;

                    IF _automaticStart THEN
                        Outputs.StartClockwise := TRUE;
                    END_IF;
                    IF Inputs.InCycle THEN
                        THIS.CallTimers(FALSE);
                        _progress := 413;
                    END_IF;
                END_IF;
                
                IF _progress = 413 THEN                                                                                     // RunAutomatTask running: screwing clockwise
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#613, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#613;
                    END_IF;
    
                    IF _automaticStart THEN
                        Outputs.StartClockwise := TRUE;
                    END_IF;
                    IF Inputs.CycleComplete THEN
                        THIS.CallTimers(FALSE);
                        _progress := 414;
                    END_IF;
                END_IF;
                
                IF _progress = 414 THEN                                                                                     // RunAutomatTask running: screwing clockwise finished
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#614, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#614;
                    END_IF;
    
                    Outputs.StartClockwise := FALSE;
                    Outputs.ActiveEnable := FALSE;
                    IF NOT Inputs.InCycle THEN
                        THIS.CallTimers(FALSE);
                        _progress := 415;
                    END_IF;
                END_IF;
                
                IF _progress = 415 THEN                                                                                     // RunAutomatTask running: screwing clockwise finished
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#615, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#615;
                    END_IF;

                    Outputs.StartClockwise := FALSE;
                    Outputs.ActiveEnable := FALSE;

                    IF NOT Inputs.ActiveEnableAck THEN
                        THIS.CallTimers(FALSE);
                        _progress := 416;
                    END_IF;
                END_IF;
                
                IF _progress = 416 THEN                                                                                     // RunAutomatTask running: screwing clockwise finished
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#616, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#616;
                    END_IF;

                    Outputs.StartClockwise := FALSE;
                    Outputs.ActiveEnable := FALSE;
                    
                    IF Inputs.CycleComplete THEN
                        THIS.CallTimers(FALSE);
                        _progress := 417;
                    END_IF;
                END_IF;
                
                IF _progress = 417 THEN                                                                                     // RunAutomatTask running: disabling screwing clockwise
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#617, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#617;
                    END_IF;

                    Outputs.CwAnd := FALSE;
                    Outputs.CwLock := TRUE;

                    IF Inputs.CwLockAck THEN
                        THIS.CallTimers(FALSE);
                        _progress := 418;
                    END_IF;
                END_IF;
                
                IF _progress = 418 THEN                                                                                     // RunAutomatTask running: disabling screwing counterclockwise
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#618, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#618;
                    END_IF;

                    Outputs.CcwAnd := FALSE;
                    Outputs.CcwLock := TRUE;

                    IF Inputs.CcwLockAck THEN
                        THIS.CallTimers(FALSE);
                        _progress := 419;
                    END_IF;
                END_IF;
                
                IF _progress = 419 THEN                                                                                     // RunAutomatTask running: getting results
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#619, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#619;
                    END_IF;

                    Results.Result := Inputs.Result;
                    Results.IDcode.Data := Inputs.IDcode;
                    Results.CnoSE := Inputs.CnoSE;		
                    Results.ProgramNo := Inputs.ProgramNo;		
                    Results.TorqueMin := Inputs.TorqueMin;			
                    Results.Torque := Inputs.Torque;		
                    Results.TorqueMax := Inputs.TorqueMax;		
                    Results.AngleMin := Inputs.AngleMin;		
                    Results.Angle := Inputs.Angle;		
                    Results.AngleMax := Inputs.AngleMax;			
                    Results.ErrorCode := Inputs.ErrorCode;
                    Results.ErrorClass := Inputs.ErrorClass;

                    Results.IDcode.ToggleDataChangedFlag();

                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 420;
                    END_IF;
                END_IF;
    
                IF _progress = 420 THEN                                                                                     // RunAutomatTask running: evaluating results
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#620, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#620;
                    END_IF;
    
                    OK := Inputs.OK AND NOT Inputs.NOK;
                    NOK := NOT Inputs.OK OR Inputs.NOK;
                    IF OK OR NOK THEN
                        THIS.CallTimers(FALSE);
                        _progress := 421;
                    END_IF;
                END_IF;
    
                IF _progress = 421 THEN                                                                                     // RunAutomatTask running: disabling
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#621, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#621;
                    END_IF;
    
                    Outputs.Enable := FALSE;

                    IF NOT Inputs.EnableAck THEN
                        THIS.CallTimers(FALSE);
                        _progress := 422;
                    END_IF;
                END_IF;
                
                IF _progress = 422 THEN                                                                                     // RunAutomatTask finished
                    RunAutomatTask.DoneWhen(TRUE);
                    _progress := 0;
                END_IF;
                 
                THIS.CallTimers(TRUE);
                
                RunAutomatTask.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);  
                RunAutomatTask.ThrowWhen(RunAutomatTask.Duration >= Config.TaskTimeout AND Config.TaskTimeout > T#0s ,'RunAutomatTask timeout.');                
            END_IF;
            IF RunAutomatTask.DoneReached() THEN
                Status.Action.Id :=  UINT#201;
                Status.Error.Id :=  UINT#0;
            ELSIF RunAutomatTask.ErrorOccured() THEN
                Status.Action.Id :=  UINT#10100;
                Status.Error.Id  :=  UINT#10100;
            ELSIF RunAutomatTask.AbortTriggered()THEN
                Status.Action.Id :=  UINT#10101;
                Status.Error.Id  :=  UINT#10101;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#10100,RunAutomatTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#10101,RunAutomatTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#202,RunAutomatTask.RestoreTriggered() , eAxoMessageCategory#Error);
            IF RunAutomatTask.RestoreTriggered() AND _progress >= 400 AND _progress <= 439  THEN
                Status.Action.Id :=  UINT#202;
                _progress := 0;
            END_IF;
            //**************************************************

            //***********Update outputs ****************
            // Slot 1 Output_4_word_1
            _data_out4w[0].%B1        :=      Outputs.ProgramNo;                      //  0

            _data_out4w[0].%X0        :=      Outputs.Enable;                         //  1
            _data_out4w[0].%X1        :=      Outputs.ResetFault;
            _data_out4w[0].%X2        :=      Outputs.StartClockwise;
            _data_out4w[0].%X3        :=      Outputs.StartCounterClockwise;
            _data_out4w[0].%X4        :=      Outputs.ResetResults;
            _data_out4w[0].%X5        :=      Outputs.NokAck;
            _data_out4w[0].%X6        :=      Outputs.UsrIn1;
            _data_out4w[0].%X7        :=      Outputs.UsrIn2;
            
            _data_out4w[1].%X8        :=      Outputs.ES_LED_Green;                   //  2
            _data_out4w[1].%X9        :=      Outputs.ES_LED_Yellow;
            _data_out4w[1].%X10       :=      Outputs.ES_LED_Red;
            _data_out4w[1].%X11       :=      Outputs.ActiveEnable;
            _data_out4w[1].%X12       :=      Outputs.CcwLock;
            _data_out4w[1].%X13       :=      Outputs.CwLock;
            _data_out4w[1].%X14       :=      Outputs.CwAnd;
            _data_out4w[1].%X15       :=      Outputs.CcwAnd;

            _data_out4w[2].%B1        :=      Outputs.IDcode[0];                      //  4
            _data_out4w[2].%B0        :=      Outputs.IDcode[1];                      //  5
            _data_out4w[3].%B1        :=      Outputs.IDcode[2];                      //  6
            _data_out4w[3].%B0        :=      Outputs.IDcode[3];                      //  7

            _returnValue := Siemens.Simatic.S71500.DistributedIO.WriteData(TO_WORD(Config.HWIDs.HwID_Slot_1),_data_out4w);
            IF _returnValue > WORD#0 THEN
                Messenger.Activate(UINT#1231, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1231;
                RETURN;
            END_IF;
            
            // Slot 2 Output_4_word_2
            _data_out4w[0].%B1        :=      Outputs.IDcode[4];                      //  8
            _data_out4w[0].%B0        :=      Outputs.IDcode[5];                      //  9
            _data_out4w[1].%B1        :=      Outputs.IDcode[6];                      //  10
            _data_out4w[1].%B0        :=      Outputs.IDcode[7];                      //  11
            _data_out4w[2].%B1        :=      Outputs.IDcode[8];                      //  12
            _data_out4w[2].%B0        :=      Outputs.IDcode[9];                      //  13
            _data_out4w[3].%B1        :=      Outputs.IDcode[10];                     //  14
            _data_out4w[3].%B0        :=      Outputs.IDcode[11];                     //  15

            _returnValue := Siemens.Simatic.S71500.DistributedIO.WriteData(TO_WORD(Config.HWIDs.HwID_Slot_2),_data_out4w);
            IF _returnValue > WORD#0 THEN
                Messenger.Activate(UINT#1232, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1232;
                RETURN;
            END_IF;

            // Slot 3 Output_4_word_3
            _data_out4w[0].%B1        :=      Outputs.IDcode[12];                     //  16
            _data_out4w[0].%B0        :=      Outputs.IDcode[13];                     //  17
            _data_out4w[1].%B1        :=      Outputs.IDcode[14];                     //  18
            _data_out4w[1].%B0        :=      Outputs.IDcode[15];                     //  19
            _data_out4w[2].%B1        :=      Outputs.IDcode[16];                     //  20
            _data_out4w[2].%B0        :=      Outputs.IDcode[17];                     //  21
            _data_out4w[3].%B1        :=      Outputs.IDcode[18];                     //  22
            _data_out4w[3].%B0        :=      Outputs.IDcode[19];                     //  23

            _returnValue := Siemens.Simatic.S71500.DistributedIO.WriteData(TO_WORD(Config.HWIDs.HwID_Slot_3),_data_out4w);
            IF _returnValue > WORD#0 THEN
                Messenger.Activate(UINT#1233, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1233;
                RETURN;
            END_IF;

            // Slot 4 Output_4_word_4
            _data_out4w[0].%B1        :=      Outputs.IDcode[20];                     //  24
            _data_out4w[0].%B0        :=      Outputs.IDcode[21];                     //  25
            _data_out4w[1].%B1        :=      Outputs.IDcode[22];                     //  26
            _data_out4w[1].%B0        :=      Outputs.IDcode[23];                     //  27
            _data_out4w[2].%B1        :=      Outputs.IDcode[24];                     //  28
            _data_out4w[2].%B0        :=      Outputs.IDcode[25];                     //  29
            _data_out4w[3].%B1        :=      Outputs.IDcode[26];                     //  30
            _data_out4w[3].%B0        :=      Outputs.IDcode[27];                     //  31

            _returnValue := Siemens.Simatic.S71500.DistributedIO.WriteData(TO_WORD(Config.HWIDs.HwID_Slot_4),_data_out4w);
            IF _returnValue > WORD#0 THEN
                Messenger.Activate(UINT#1234, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1234;
                RETURN;
            END_IF;
            
            // Slot 5 Output_4_word_5
            _data_out4w[0].%B1        :=      Outputs.IDcode[28];                     //  32
            _data_out4w[0].%B0        :=      Outputs.IDcode[29];                     //  33
            _data_out4w[1].%B1        :=      Outputs.IDcode[30];                     //  34
            _data_out4w[1].%B0        :=      Outputs.IDcode[31];                     //  35
            _data_out4w[2].%B1        :=      Outputs.IDcode[32];                     //  36
            _data_out4w[2].%B0        :=      Outputs.IDcode[33];                     //  37
            _data_out4w[3].%B1        :=      Outputs.IDcode[34];                     //  38
            _data_out4w[3].%B0        :=      Outputs.IDcode[35];                     //  39

            _returnValue := Siemens.Simatic.S71500.DistributedIO.WriteData(TO_WORD(Config.HWIDs.HwID_Slot_5),_data_out4w);
            IF _returnValue > WORD#0 THEN
                Messenger.Activate(UINT#1235, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1235;
                RETURN;
            END_IF;
            
            // Slot 6 Output_4_word_6
            _data_out4w[0].%B1        :=      Outputs.IDcode[36];                     //  40
            _data_out4w[0].%B0        :=      Outputs.IDcode[37];                     //  41
            _data_out4w[1].%B1        :=      Outputs.IDcode[38];                     //  42
            _data_out4w[1].%B0        :=      Outputs.IDcode[39];                     //  43
            _data_out4w[2].%B1        :=      Outputs.IDcode[40];                     //  44
            _data_out4w[2].%B0        :=      Outputs.IDcode[41];                     //  45
            _data_out4w[3].%B1        :=      Outputs.IDcode[42];                     //  46
            _data_out4w[3].%B0        :=      Outputs.IDcode[43];                     //  47

            _returnValue := Siemens.Simatic.S71500.DistributedIO.WriteData(TO_WORD(Config.HWIDs.HwID_Slot_6),_data_out4w);
            IF _returnValue > WORD#0 THEN
                Messenger.Activate(UINT#1236, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1236;
                RETURN;
            END_IF;
            
            // Slot 7 Output_4_word_7
            _data_out4w[0].%B1        :=      Outputs.IDcode[44];                     //  48
            _data_out4w[0].%B0        :=      Outputs.IDcode[45];                     //  49
            _data_out4w[1].%B1        :=      Outputs.IDcode[46];                     //  50
            _data_out4w[1].%B0        :=      Outputs.IDcode[47];                     //  51
            _data_out4w[2].%B1        :=      Outputs.IDcode[48];                     //  52
            _data_out4w[2].%B0        :=      Outputs.IDcode[49];                     //  53
            _data_out4w[3].%B1        :=      Outputs.IDcode[50];                     //  54
            _data_out4w[3].%B0        :=      Outputs.IDcode[51];                     //  55

            _returnValue := Siemens.Simatic.S71500.DistributedIO.WriteData(TO_WORD(Config.HWIDs.HwID_Slot_7),_data_out4w);
            IF _returnValue > WORD#0 THEN
                Messenger.Activate(UINT#1237, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1237;
                RETURN;
            END_IF;
            
            // Slot 8 Output_4_word_8
            _data_out4w[0].%B1        :=      Outputs.IDcode[52];                     //  56
            _data_out4w[0].%B0        :=      Outputs.IDcode[53];                     //  57
            _data_out4w[1].%B1        :=      Outputs.IDcode[54];                     //  58
            _data_out4w[1].%B0        :=      Outputs.IDcode[55];                     //  59
            _data_out4w[2].%B1        :=      Outputs.IDcode[56];                     //  60
            _data_out4w[2].%B0        :=      Outputs.IDcode[57];                     //  61
            _data_out4w[3].%B1        :=      Outputs.IDcode[58];                     //  62
            _data_out4w[3].%B0        :=      Outputs.IDcode[59];                     //  63

            _returnValue := Siemens.Simatic.S71500.DistributedIO.WriteData(TO_WORD(Config.HWIDs.HwID_Slot_8),_data_out4w);
            IF _returnValue > WORD#0 THEN
                Messenger.Activate(UINT#1238, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1238;
                RETURN;
            END_IF;
            
            // Slot 9 Output_2_word_1
            _data_out2w[0].%B1        :=      Outputs.IDcode[60];                     //  64
            _data_out2w[0].%B0        :=      Outputs.IDcode[61];                     //  65
            _data_out2w[1].%B1        :=      Outputs.IDcode[62];                     //  66
            _data_out2w[1].%B0        :=      Outputs.IDcode[63];                     //  67

            _returnValue := Siemens.Simatic.S71500.DistributedIO.WriteData(TO_WORD(Config.HWIDs.HwID_Slot_9),_data_out2w);
            IF _returnValue > WORD#0 THEN
                Messenger.Activate(UINT#1239, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1239;
                RETURN;
            END_IF;
            //******************************************      

        END_METHOD

        METHOD PUBLIC Disable : IAxoTaskState
            Disable := DisableTask.Invoke(THIS);
        END_METHOD

        METHOD PUBLIC Enable : IAxoTaskState
            Enable := EnableTask.Invoke(THIS);
        END_METHOD

        METHOD PUBLIC DisableClockwise : IAxoTaskState
            DisableClockwise := DisableClockwiseTask.Invoke(THIS);
        END_METHOD

        METHOD PUBLIC EnableClockwise : IAxoTaskState
            EnableClockwise := EnableClockwiseTask.Invoke(THIS);
        END_METHOD

        METHOD PUBLIC DisableCounterClockwise : IAxoTaskState
            DisableCounterClockwise := DisableCounterClockwiseTask.Invoke(THIS);
        END_METHOD

        METHOD PUBLIC EnableCounterClockwise : IAxoTaskState
            EnableCounterClockwise := EnableCounterClockwiseTask.Invoke(THIS);
        END_METHOD

        METHOD PUBLIC ResetFault : IAxoTaskState
            ResetFault := ResetFaultTask.Invoke(THIS);
        END_METHOD

        METHOD PUBLIC ResetResults : IAxoTaskState
            ResetResults := ResetResultsTask.Invoke(THIS);
        END_METHOD

        METHOD PUBLIC SetScrewingProgram : IAxoTaskState
            VAR_INPUT
                ProgramNo : BYTE;
            END_VAR
            _programNo  :=  ProgramNo;
            SetScrewingProgram := SetScrewingProgramTask.Invoke(THIS);
        END_METHOD

        METHOD PUBLIC GetScrewingResults : IAxoTaskState
            GetScrewingResults := GetScrewingResultsTask.Invoke(THIS);
        END_METHOD

        METHOD PUBLIC ScrewClockwise : IAxoTaskState
            VAR_INPUT
                AutomaticStart : BOOL;
            END_VAR
            _automaticStart := AutomaticStart;
            ScrewClockwise := ScrewClockwiseTask.Invoke(THIS);
        END_METHOD

        METHOD PUBLIC ScrewCounterClockwise : IAxoTaskState
            VAR_INPUT
                AutomaticStart : BOOL;
            END_VAR
            _automaticStart := AutomaticStart;
            ScrewCounterClockwise := ScrewCounterClockwiseTask.Invoke(THIS);
        END_METHOD

        METHOD PUBLIC RunAutomat : IAxoTaskState
            VAR_INPUT
                ProgramNo : BYTE;
                IDcode : STRING[64];
                AutomaticStart : BOOL;
            END_VAR
            VAR
               _data : ARRAY[0..64] OF BYTE;
               _i   :   UINT;
            END_VAR
            Serialize(UDINT#0, IDcode, _data);
            _programNo  :=  ProgramNo;
            FOR _i := UINT#1 TO UINT#64 DO
                _IDcode[_i - UINT#1] := _data[_i];
            END_FOR;
            _automaticStart := AutomaticStart;
            RunAutomat := RunAutomatTask.Invoke(THIS);
        END_METHOD

        METHOD PROTECTED OVERRIDE ManualControl
            VAR
                _data : ARRAY[0..64] OF BYTE;
                _i   :   UINT;
             END_VAR
             Serialize(UDINT#0, IDcodeManual, _data);
             _programNo  :=  ProgramNoManual;
             FOR _i := UINT#1 TO UINT#64 DO
                 _IDcode[_i - UINT#1] := _data[_i];
             END_FOR;
             _automaticStart := AutomaticStartManual;
            THIS._isManuallyControllable := TRUE;
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
            _returnValue    :=   WORD#0;

            _data_in4w[0] := WORD#0;
            _data_in4w[1] := WORD#0;
            _data_in4w[2] := WORD#0;
            _data_in4w[3] := WORD#0;

            _data_out4w[0] := WORD#0;
            _data_out4w[1] := WORD#0;
            _data_out4w[2] := WORD#0;
            _data_out4w[3] := WORD#0;

            _data_out2w[0] := WORD#0;
            _data_out2w[1] := WORD#0;

            _word           :=   WORD#0;
            _dword          :=   DWORD#0;

            DisableTask.Restore();
            EnableTask.Restore();
            DisableClockwiseTask.Restore();
            EnableClockwiseTask.Restore();
            DisableCounterClockwiseTask.Restore();
            EnableCounterClockwiseTask.Restore();
            ResetFaultTask.Restore();
            ResetResultsTask.Restore();
            SetScrewingProgramTask.Restore();
            GetScrewingResultsTask.Restore();

            ScrewClockwiseTask.Restore();
            ScrewCounterClockwiseTask.Restore();
            RunAutomatTask.Restore();
            HardwareDiagnosticsTask.Restore();

            Status.Action.Id := UINT#50;
            RestoreTask.DoneWhen(TRUE);

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
