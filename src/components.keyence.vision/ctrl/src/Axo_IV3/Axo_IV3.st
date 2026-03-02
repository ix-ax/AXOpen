USING AXOpen.Core;
USING AXOpen.Messaging;
USING AXOpen.Messaging.Static;
USING AXOpen.Components.Abstractions;
USING Siemens.Simatic.Hardware.Utilities;

NAMESPACE AXOpen.Components.Keyence.Vision
    {S7.extern=ReadWrite}
    {#ix-prop: public string DeviceIpAddress}
    {#ix-prop: public string Proxy}
    CLASS Axo_IV3 EXTENDS AXOpen.Core.AxoComponent
        VAR PUBLIC // HEADER
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentHeader()]}
            {#ix-set:AttributeName = "<#Progress#>"}
            Progress : INT;
        END_VAR

        VAR PUBLIC // TASKS
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#TriggerTask#>"}
            TriggerTask : AXOpen.Core.AxoTask;
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#Restore#>"}
            RestoreTask : AXOpen.Core.AxoTask;
        

            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#Required program number#>"}
            RequiredProgramNumber : UINT;
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#ChangeProgramTask#>"}
            ChangeProgramTask : AXOpen.Core.AxoTask;
        END_VAR

        VAR PUBLIC // CONFIG
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("Config")]}
            {#ix-attr:[ReadOnly()]}
            Config  :   Axo_IV3_Config;
        END_VAR

        VAR PUBLIC // STATUS
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("Status")]}
            {#ix-attr:[ReadOnly()]}
            Status              :   Axo_IV3_Component_Status;
            Messenger           :   AXOpen.Messaging.Static.AxoMessenger;
            TaskMessenger       :   AXOpen.Messaging.Static.AxoMessenger;
        END_VAR    

        VAR PUBLIC // HARDWARE SIGNALS
            {#ix-attr:[ComponentDetails("HARDWARE SIGNALS")]}
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Inputs#>"}
            {#ix-attr:[ReadOnly()]}
            Inputs              :  Axo_IV3_In;
            {#ix-attr:[ComponentDetails("HARDWARE SIGNALS")]}
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Outputs#>"}
            {#ix-attr:[ReadOnly()]}
            Outputs              :   Axo_IV3_Out;
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
            _data_in        :   ARRAY[0..27] OF BYTE;
            _data_out_12    :   ARRAY[0..11] OF BYTE;
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
            _resultUpdateComplete   :   BOOL;
            _resultNo               :   UINT;
            _programNumber          :   UINT;
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
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_CommandControl);        
                IF Config.HWIDs.HwID_CommandControl = UINT#0 THEN
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
                ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HwID_CommandControl) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#0 OR _outputsCount <> UINT#12 THEN
                    Messenger.Activate(UINT#716,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#716;
                    RETURN;
                END_IF;
                //******************Slot 2*****************//
                _geoAddr.Slot   :=  UINT#2;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_CommandStatusBits);        
                IF Config.HWIDs.HwID_CommandStatusBits = UINT#0 THEN
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
                ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HwID_CommandStatusBits) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#4 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#726,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#726;
                    RETURN;
                END_IF;
                //******************Slot 3*****************//
                _geoAddr.Slot   :=  UINT#3;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_DeviceResultBits_1);        
                IF Config.HWIDs.HwID_DeviceResultBits_1 = UINT#0 THEN
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
                ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HwID_DeviceResultBits_1) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#4 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#736,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#736;
                    RETURN;
                END_IF;
                //******************Slot 4*****************//
                _geoAddr.Slot   :=  UINT#4;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_DeviceStatusWords);        
                IF Config.HWIDs.HwID_DeviceStatusWords = UINT#0 THEN
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
                ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HwID_DeviceStatusWords) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#16 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#746,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#746;
                    RETURN;
                END_IF;
                //******************Slot 5*****************//
                _geoAddr.Slot   :=  UINT#5;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_DeviceStatistics);        
                IF Config.HWIDs.HwID_DeviceStatistics = UINT#0 THEN
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
                ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HwID_DeviceStatistics) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#28 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#756,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#756;
                    RETURN;
                END_IF;
                //******************Slot 6*****************//
                _geoAddr.Slot   :=  UINT#6;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_PositionAdjustResult);        
                IF Config.HWIDs.HwID_PositionAdjustResult = UINT#0 THEN
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
                ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HwID_PositionAdjustResult) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#20 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#766,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#766;
                    RETURN;
                END_IF;
                //******************Slot 7*****************//
                _geoAddr.Slot   :=  UINT#7;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_ToolResult_1);        
                IF Config.HWIDs.HwID_ToolResult_1 = UINT#0 THEN
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
                ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HwID_ToolResult_1) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#20 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#776,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#776;
                    RETURN;
                END_IF;
                //******************Slot 8*****************//
                _geoAddr.Slot   :=  UINT#8;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_ToolResult_2);        
                IF Config.HWIDs.HwID_ToolResult_2 = UINT#0 THEN
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
                ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HwID_ToolResult_2) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#20 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#786,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#786;
                    RETURN;
                END_IF;
                //******************Slot 9*****************//
                _geoAddr.Slot   :=  UINT#9;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_ToolResult_3);        
                IF Config.HWIDs.HwID_ToolResult_3 = UINT#0 THEN
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
                ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HwID_ToolResult_3) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#20 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#796,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#796;
                    RETURN;
                END_IF;
                //******************Slot 10*****************//
                _geoAddr.Slot   :=  UINT#10;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_ToolResult_4);        
                IF Config.HWIDs.HwID_ToolResult_4 = UINT#0 THEN
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
                ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HwID_ToolResult_4) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#20 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#806,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#806;
                    RETURN;
                END_IF;
                //******************Slot 11*****************//
                _geoAddr.Slot   :=  UINT#11;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_ToolResult_5);        
                IF Config.HWIDs.HwID_ToolResult_5 = UINT#0 THEN
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
                ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HwID_ToolResult_5) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#20 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#816,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#816;
                    RETURN;
                END_IF;
                //******************Slot 12*****************//
                _geoAddr.Slot   :=  UINT#12;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_ToolResult_6);        
                IF Config.HWIDs.HwID_ToolResult_6 = UINT#0 THEN
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
                ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HwID_ToolResult_6) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#20 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#826,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#826;
                    RETURN;
                END_IF;
                //******************Slot 13*****************//
                _geoAddr.Slot   :=  UINT#13;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_ToolResult_7);        
                IF Config.HWIDs.HwID_ToolResult_7 = UINT#0 THEN
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
                ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HwID_ToolResult_7) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#20 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#836,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#836;
                    RETURN;
                END_IF;
                //******************Slot 14*****************//
                _geoAddr.Slot   :=  UINT#14;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_ToolResult_8);        
                IF Config.HWIDs.HwID_ToolResult_8 = UINT#0 THEN
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
                ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HwID_ToolResult_8) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#20 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#846,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#846;
                    RETURN;
                END_IF;
                //******************Slot 15*****************//
                _geoAddr.Slot   :=  UINT#15;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_ToolResult_9);        
                IF Config.HWIDs.HwID_ToolResult_9 = UINT#0 THEN
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
                ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HwID_ToolResult_9) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#20 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#856,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#856;
                    RETURN;
                END_IF;
                //******************Slot 16*****************//
                _geoAddr.Slot   :=  UINT#16;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_ToolResult_10);        
                IF Config.HWIDs.HwID_ToolResult_10 = UINT#0 THEN
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
                ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HwID_ToolResult_10) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#20 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#866,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#866;
                    RETURN;
                END_IF;
                //******************Slot 17*****************//
                _geoAddr.Slot   :=  UINT#17;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_ToolResult_11);        
                IF Config.HWIDs.HwID_ToolResult_11 = UINT#0 THEN
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
                ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HwID_ToolResult_11) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#20 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#876,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#876;
                    RETURN;
                END_IF;
                //******************Slot 18*****************//
                _geoAddr.Slot   :=  UINT#18;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_ToolResult_12);        
                IF Config.HWIDs.HwID_ToolResult_12 = UINT#0 THEN
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
                ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HwID_ToolResult_12) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#20 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#886,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#886;
                    RETURN;
                END_IF;
                //******************Slot 19*****************//
                _geoAddr.Slot   :=  UINT#19;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_ToolResult_13);        
                IF Config.HWIDs.HwID_ToolResult_13 = UINT#0 THEN
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
                ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HwID_ToolResult_13) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#20 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#896,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#896;
                    RETURN;
                END_IF;
                //******************Slot 20*****************//
                _geoAddr.Slot   :=  UINT#20;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_ToolResult_14);        
                IF Config.HWIDs.HwID_ToolResult_14 = UINT#0 THEN
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
                ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HwID_ToolResult_14) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#20 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#916,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#916;
                    RETURN;
                END_IF;
                //******************Slot 21*****************//
                _geoAddr.Slot   :=  UINT#21;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_ToolResult_15);        
                IF Config.HWIDs.HwID_ToolResult_15 = UINT#0 THEN
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
                ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HwID_ToolResult_15) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#20 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#916,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#916;
                    RETURN;
                END_IF;
                //******************Slot 22*****************//
                _geoAddr.Slot   :=  UINT#22;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_ToolResult_16);        
                IF Config.HWIDs.HwID_ToolResult_16 = UINT#0 THEN
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
                ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HwID_ToolResult_16) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#20 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#926,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#926;
                    RETURN;
                END_IF;
                //******************Slot 23*****************//
                _geoAddr.Slot   :=  UINT#23;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_ToolResult_17);        
                IF Config.HWIDs.HwID_ToolResult_17 = UINT#0 THEN
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
                ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HwID_ToolResult_17) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#20 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#936,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#936;
                    RETURN;
                END_IF;
                //******************Slot 24*****************//
                _geoAddr.Slot   :=  UINT#24;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_ToolResult_18);        
                IF Config.HWIDs.HwID_ToolResult_18 = UINT#0 THEN
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
                ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HwID_ToolResult_18) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#20 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#946,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#946;
                    RETURN;
                END_IF;
                //******************Slot 25*****************//
                _geoAddr.Slot   :=  UINT#25;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_ToolResult_19);        
                IF Config.HWIDs.HwID_ToolResult_19 = UINT#0 THEN
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
                ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HwID_ToolResult_19) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#20 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#956,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#956;
                    RETURN;
                END_IF;
                //******************Slot 26*****************//
                _geoAddr.Slot   :=  UINT#26;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_ToolResult_20);        
                IF Config.HWIDs.HwID_ToolResult_20 = UINT#0 THEN
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
                ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HwID_ToolResult_20) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#20 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#966,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#966;
                    RETURN;
                END_IF;
                //******************Slot 27*****************//
                _geoAddr.Slot   :=  UINT#27;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_ToolResult_21);        
                IF Config.HWIDs.HwID_ToolResult_21 = UINT#0 THEN
                    Messenger.Activate(UINT#970,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#970;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#971,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#971;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#972,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#972;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#973,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#973;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#974,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#974;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#975,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#975;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HwID_ToolResult_21) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#20 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#976,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#976;
                    RETURN;
                END_IF;
                //******************Slot 28*****************//
                _geoAddr.Slot   :=  UINT#28;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_ToolResult_22);        
                IF Config.HWIDs.HwID_ToolResult_22 = UINT#0 THEN
                    Messenger.Activate(UINT#980,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#980;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#981,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#981;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#982,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#982;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#983,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#983;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#984,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#984;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#985,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#985;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HwID_ToolResult_22) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#20 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#986,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#986;
                    RETURN;
                END_IF;
                //******************Slot 29*****************//
                _geoAddr.Slot   :=  UINT#29;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_ToolResult_23);        
                IF Config.HWIDs.HwID_ToolResult_23 = UINT#0 THEN
                    Messenger.Activate(UINT#990,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#990;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#991,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#991;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#992,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#992;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#993,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#993;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#994,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#994;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#995,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#995;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HwID_ToolResult_23) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#20 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#996,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#996;
                    RETURN;
                END_IF;
                //******************Slot 30*****************//
                _geoAddr.Slot   :=  UINT#30;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_ToolResult_24);        
                IF Config.HWIDs.HwID_ToolResult_24 = UINT#0 THEN
                    Messenger.Activate(UINT#1000,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1000;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#1001,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1001;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#1002,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1002;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#1003,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1003;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#1004,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1004;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#1005,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1005;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HwID_ToolResult_24) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#20 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#1006,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1006;
                    RETURN;
                END_IF;
                //******************Slot 31*****************//
                _geoAddr.Slot   :=  UINT#31;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_ToolResult_25);        
                IF Config.HWIDs.HwID_ToolResult_25 = UINT#0 THEN
                    Messenger.Activate(UINT#1010,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1010;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#1011,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1011;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#1012,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1012;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#1013,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1013;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#1014,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1014;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#1015,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1015;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HwID_ToolResult_25) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#20 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#1016,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1016;
                    RETURN;
                END_IF;
                //******************Slot 32*****************//
                _geoAddr.Slot   :=  UINT#32;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_ToolResult_26);        
                IF Config.HWIDs.HwID_ToolResult_26 = UINT#0 THEN
                    Messenger.Activate(UINT#1020,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1020;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#1021,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1021;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#1022,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1022;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#1023,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1023;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#1024,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1024;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#1025,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1025;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HwID_ToolResult_26) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#20 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#1026,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1026;
                    RETURN;
                END_IF;
                //******************Slot 33*****************//
                _geoAddr.Slot   :=  UINT#33;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_ToolResult_27);        
                IF Config.HWIDs.HwID_ToolResult_27 = UINT#0 THEN
                    Messenger.Activate(UINT#1030,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1030;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#1031,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1031;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#1032,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1032;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#1033,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1033;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#1034,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1034;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#1035,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1035;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HwID_ToolResult_27) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#20 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#1036,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1036;
                    RETURN;
                END_IF;
                //******************Slot 34*****************//
                _geoAddr.Slot   :=  UINT#34;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_ToolResult_28);        
                IF Config.HWIDs.HwID_ToolResult_28 = UINT#0 THEN
                    Messenger.Activate(UINT#1040,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1040;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#1041,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1041;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#1042,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1042;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#1043,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1043;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#1044,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1044;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#1045,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1045;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HwID_ToolResult_28) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#20 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#1046,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1046;
                    RETURN;
                END_IF;
                //******************Slot 35*****************//
                _geoAddr.Slot   :=  UINT#35;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_ToolResult_29);        
                IF Config.HWIDs.HwID_ToolResult_29 = UINT#0 THEN
                    Messenger.Activate(UINT#1050,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1050;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#1051,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1051;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#1052,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1052;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#1053,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1053;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#1054,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1054;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#1055,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1055;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HwID_ToolResult_29) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#20 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#1056,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1056;
                    RETURN;
                END_IF;
                //******************Slot 36*****************//
                _geoAddr.Slot   :=  UINT#36;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_ToolResult_30);        
                IF Config.HWIDs.HwID_ToolResult_30 = UINT#0 THEN
                    Messenger.Activate(UINT#1060,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1060;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#1061,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1061;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#1062,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1062;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#1063,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1063;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#1064,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1064;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#1065,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1065;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HwID_ToolResult_30) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#20 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#1066,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1066;
                    RETURN;
                END_IF;
                //******************Slot 37*****************//
                _geoAddr.Slot   :=  UINT#37;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_ToolResult_31);        
                IF Config.HWIDs.HwID_ToolResult_31 = UINT#0 THEN
                    Messenger.Activate(UINT#1070,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1070;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#1071,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1071;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#1072,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1072;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#1073,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1073;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#1074,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1074;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#1075,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1075;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HwID_ToolResult_31) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#20 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#1076,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1076;
                    RETURN;
                END_IF;
                //******************Slot 38*****************//
                _geoAddr.Slot   :=  UINT#38;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_ToolResult_32);        
                IF Config.HWIDs.HwID_ToolResult_32 = UINT#0 THEN
                    Messenger.Activate(UINT#1080,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1080;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#1081,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1081;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#1082,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1082;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#1083,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1083;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#1084,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1084;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#1085,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1085;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HwID_ToolResult_32) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#20 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#1086,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1086;
                    RETURN;
                END_IF;
                //******************Slot 39*****************//
                _geoAddr.Slot   :=  UINT#39;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_ToolResult_33);        
                IF Config.HWIDs.HwID_ToolResult_33 = UINT#0 THEN
                    Messenger.Activate(UINT#1090,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1090;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#1091,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1091;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#1092,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1092;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#1093,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1093;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#1094,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1094;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#1095,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1095;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HwID_ToolResult_33) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#20 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#1096,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1096;
                    RETURN;
                END_IF;
                //******************Slot 40*****************//
                _geoAddr.Slot   :=  UINT#40;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_ToolResult_34);        
                IF Config.HWIDs.HwID_ToolResult_34 = UINT#0 THEN
                    Messenger.Activate(UINT#1100,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1100;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#1101,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1101;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#1102,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1102;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#1103,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1103;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#1104,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1104;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#1105,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1105;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HwID_ToolResult_34) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#20 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#1106,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1106;
                    RETURN;
                END_IF;
                //******************Slot 41*****************//
                _geoAddr.Slot   :=  UINT#41;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_ToolResult_35);        
                IF Config.HWIDs.HwID_ToolResult_35 = UINT#0 THEN
                    Messenger.Activate(UINT#1110,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1110;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#1111,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1111;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#1112,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1112;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#1113,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1113;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#1114,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1114;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#1115,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1115;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HwID_ToolResult_35) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#20 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#1116,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1116;
                    RETURN;
                END_IF;
                //******************Slot 42*****************//
                _geoAddr.Slot   :=  UINT#42;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_ToolResult_36);        
                IF Config.HWIDs.HwID_ToolResult_36 = UINT#0 THEN
                    Messenger.Activate(UINT#1120,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1120;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#1121,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1121;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#1122,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1122;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#1123,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1123;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#1124,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1124;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#1125,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1125;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HwID_ToolResult_36) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#20 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#1126,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1126;
                    RETURN;
                END_IF;
                //******************Slot 43*****************//
                _geoAddr.Slot   :=  UINT#43;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_ToolResult_37);        
                IF Config.HWIDs.HwID_ToolResult_37 = UINT#0 THEN
                    Messenger.Activate(UINT#1130,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1130;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#1131,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1131;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#1132,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1132;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#1133,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1133;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#1134,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1134;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#1135,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1135;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HwID_ToolResult_37) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#20 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#1136,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1136;
                    RETURN;
                END_IF;
                //******************Slot 44*****************//
                _geoAddr.Slot   :=  UINT#44;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_ToolResult_38);        
                IF Config.HWIDs.HwID_ToolResult_38 = UINT#0 THEN
                    Messenger.Activate(UINT#1140,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1140;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#1141,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1141;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#1142,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1142;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#1143,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1143;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#1144,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1144;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#1145,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1145;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HwID_ToolResult_38) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#20 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#1146,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1146;
                    RETURN;
                END_IF;
                //******************Slot 45*****************//
                _geoAddr.Slot   :=  UINT#45;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_ToolResult_39);        
                IF Config.HWIDs.HwID_ToolResult_39 = UINT#0 THEN
                    Messenger.Activate(UINT#1150,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1150;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#1151,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1151;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#1152,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1152;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#1153,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1153;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#1154,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1154;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#1155,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1155;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HwID_ToolResult_39) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#20 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#1156,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1156;
                    RETURN;
                END_IF;
                //******************Slot 46*****************//
                _geoAddr.Slot   :=  UINT#46;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_ToolResult_40);        
                IF Config.HWIDs.HwID_ToolResult_40 = UINT#0 THEN
                    Messenger.Activate(UINT#1160,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1160;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#1161,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1161;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#1162,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1162;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#1163,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1163;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#1164,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1164;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#1165,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1165;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HwID_ToolResult_40) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#20 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#1166,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1166;
                    RETURN;
                END_IF;
                //******************Slot 47*****************//
                _geoAddr.Slot   :=  UINT#47;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_ToolResult_41);        
                IF Config.HWIDs.HwID_ToolResult_41 = UINT#0 THEN
                    Messenger.Activate(UINT#1170,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1170;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#1171,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1171;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#1172,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1172;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#1173,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1173;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#1174,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1174;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#1175,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1175;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HwID_ToolResult_41) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#20 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#1176,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1176;
                    RETURN;
                END_IF;
                //******************Slot 48*****************//
                _geoAddr.Slot   :=  UINT#48;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_ToolResult_42);        
                IF Config.HWIDs.HwID_ToolResult_42 = UINT#0 THEN
                    Messenger.Activate(UINT#1180,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1180;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#1181,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1181;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#1182,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1182;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#1183,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1183;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#1184,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1184;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#1185,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1185;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HwID_ToolResult_42) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#20 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#1186,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1186;
                    RETURN;
                END_IF;
                //******************Slot 49*****************//
                _geoAddr.Slot   :=  UINT#49;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_ToolResult_43);        
                IF Config.HWIDs.HwID_ToolResult_43 = UINT#0 THEN
                    Messenger.Activate(UINT#1190,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1190;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#1191,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1191;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#1192,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1192;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#1193,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1193;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#1194,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1194;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#1195,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1195;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HwID_ToolResult_43) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#20 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#1196,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1196;
                    RETURN;
                END_IF;
                //******************Slot 50*****************//
                _geoAddr.Slot   :=  UINT#50;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_ToolResult_44);        
                IF Config.HWIDs.HwID_ToolResult_44 = UINT#0 THEN
                    Messenger.Activate(UINT#1200,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1200;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#1201,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1201;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#1202,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1202;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#1203,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1203;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#1204,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1204;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#1205,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1205;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HwID_ToolResult_44) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#20 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#1206,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1206;
                    RETURN;
                END_IF;
                //******************Slot 51*****************//
                _geoAddr.Slot   :=  UINT#51;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_ToolResult_45);        
                IF Config.HWIDs.HwID_ToolResult_45 = UINT#0 THEN
                    Messenger.Activate(UINT#1210,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1210;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#1211,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1211;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#1212,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1212;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#1213,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1213;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#1214,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1214;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#1215,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1215;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HwID_ToolResult_45) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#20 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#1216,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1216;
                    RETURN;
                END_IF;
                //******************Slot 52*****************//
                _geoAddr.Slot   :=  UINT#52;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_ToolResult_46);        
                IF Config.HWIDs.HwID_ToolResult_46 = UINT#0 THEN
                    Messenger.Activate(UINT#1220,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1220;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#1221,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1221;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#1222,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1222;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#1223,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1223;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#1224,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1224;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#1225,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1225;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HwID_ToolResult_46) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#20 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#1226,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1226;
                    RETURN;
                END_IF;
                //******************Slot 53*****************//
                _geoAddr.Slot   :=  UINT#53;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_ToolResult_47);        
                IF Config.HWIDs.HwID_ToolResult_47 = UINT#0 THEN
                    Messenger.Activate(UINT#1230,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1230;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#1231,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1231;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#1232,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1232;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#1233,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1233;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#1234,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1234;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#1235,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1235;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HwID_ToolResult_47) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#20 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#1236,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1236;
                    RETURN;
                END_IF;
                //******************Slot 54*****************//
                _geoAddr.Slot   :=  UINT#54;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_ToolResult_48);        
                IF Config.HWIDs.HwID_ToolResult_48 = UINT#0 THEN
                    Messenger.Activate(UINT#1240,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1240;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#1241,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1241;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#1242,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1242;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#1243,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1243;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#1244,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1244;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#1245,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1245;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HwID_ToolResult_48) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#20 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#1246,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1246;
                    RETURN;
                END_IF;
                //******************Slot 55*****************//
                _geoAddr.Slot   :=  UINT#55;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_ToolResult_49);        
                IF Config.HWIDs.HwID_ToolResult_49 = UINT#0 THEN
                    Messenger.Activate(UINT#1250,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1250;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#1251,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1251;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#1252,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1252;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#1253,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1253;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#1254,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1254;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#1255,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1255;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HwID_ToolResult_49) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#20 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#1256,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1256;
                    RETURN;
                END_IF;
                //******************Slot 56*****************//
                _geoAddr.Slot   :=  UINT#56;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_ToolResult_50);        
                IF Config.HWIDs.HwID_ToolResult_50 = UINT#0 THEN
                    Messenger.Activate(UINT#1260,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1260;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#1261,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1261;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#1262,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1262;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#1263,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1263;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#1264,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1264;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#1265,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1265;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HwID_ToolResult_50) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#20 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#1266,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1266;
                    RETURN;
                END_IF;
                //******************Slot 57*****************//
                _geoAddr.Slot   :=  UINT#57;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_ToolResult_51);        
                IF Config.HWIDs.HwID_ToolResult_51 = UINT#0 THEN
                    Messenger.Activate(UINT#1270,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1270;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#1271,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1271;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#1272,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1272;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#1273,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1273;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#1274,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1274;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#1275,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1275;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HwID_ToolResult_51) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#20 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#1276,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1276;
                    RETURN;
                END_IF;
                //******************Slot 58*****************//
                _geoAddr.Slot   :=  UINT#58;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_ToolResult_52);        
                IF Config.HWIDs.HwID_ToolResult_52 = UINT#0 THEN
                    Messenger.Activate(UINT#1280,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1280;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#1281,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1281;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#1282,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1282;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#1283,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1283;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#1284,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1284;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#1285,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1285;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HwID_ToolResult_52) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#20 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#1286,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1286;
                    RETURN;
                END_IF;
                //******************Slot 59*****************//
                _geoAddr.Slot   :=  UINT#59;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_ToolResult_53);        
                IF Config.HWIDs.HwID_ToolResult_53 = UINT#0 THEN
                    Messenger.Activate(UINT#1290,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1290;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#1291,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1291;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#1292,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1292;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#1293,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1293;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#1294,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1294;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#1295,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1295;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HwID_ToolResult_53) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#20 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#1296,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1296;
                    RETURN;
                END_IF;
                //******************Slot 60*****************//
                _geoAddr.Slot   :=  UINT#60;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_ToolResult_54);        
                IF Config.HWIDs.HwID_ToolResult_54 = UINT#0 THEN
                    Messenger.Activate(UINT#1300,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1300;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#1301,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1301;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#1302,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1302;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#1303,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1303;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#1304,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1304;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#1305,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1305;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HwID_ToolResult_54) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#20 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#1306,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1306;
                    RETURN;
                END_IF;
                //******************Slot 61*****************//
                _geoAddr.Slot   :=  UINT#61;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_ToolResult_55);        
                IF Config.HWIDs.HwID_ToolResult_55 = UINT#0 THEN
                    Messenger.Activate(UINT#1310,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1310;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#1311,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1311;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#1312,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1312;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#1313,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1313;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#1314,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1314;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#1315,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1315;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HwID_ToolResult_55) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#20 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#1316,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1316;
                    RETURN;
                END_IF;
                //******************Slot 62*****************//
                _geoAddr.Slot   :=  UINT#62;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_ToolResult_56);        
                IF Config.HWIDs.HwID_ToolResult_56 = UINT#0 THEN
                    Messenger.Activate(UINT#1320,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1320;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#1321,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1321;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#1322,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1322;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#1323,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1323;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#1324,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1324;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#1325,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1325;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HwID_ToolResult_56) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#20 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#1326,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1326;
                    RETURN;
                END_IF;
                //******************Slot 63*****************//
                _geoAddr.Slot   :=  UINT#63;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_ToolResult_57);        
                IF Config.HWIDs.HwID_ToolResult_57 = UINT#0 THEN
                    Messenger.Activate(UINT#1330,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1330;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#1331,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1331;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#1332,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1332;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#1333,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1333;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#1334,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1334;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#1335,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1335;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HwID_ToolResult_57) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#20 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#1336,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1336;
                    RETURN;
                END_IF;
                //******************Slot 64*****************//
                _geoAddr.Slot   :=  UINT#64;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_ToolResult_58);        
                IF Config.HWIDs.HwID_ToolResult_58 = UINT#0 THEN
                    Messenger.Activate(UINT#1340,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1340;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#1341,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1341;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#1342,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1342;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#1343,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1343;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#1344,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1344;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#1345,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1345;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HwID_ToolResult_58) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#20 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#1346,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1346;
                    RETURN;
                END_IF;
                //******************Slot 65*****************//
                _geoAddr.Slot   :=  UINT#65;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_ToolResult_59);        
                IF Config.HWIDs.HwID_ToolResult_59 = UINT#0 THEN
                    Messenger.Activate(UINT#1350,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1350;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#1351,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1351;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#1352,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1352;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#1353,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1353;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#1354,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1354;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#1355,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1355;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HwID_ToolResult_59) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#20 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#1356,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1356;
                    RETURN;
                END_IF;
                //******************Slot 66*****************//
                _geoAddr.Slot   :=  UINT#66;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_ToolResult_60);        
                IF Config.HWIDs.HwID_ToolResult_60 = UINT#0 THEN
                    Messenger.Activate(UINT#1360,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1360;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#1361,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1361;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#1362,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1362;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#1363,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1363;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#1364,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1364;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#1365,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1365;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HwID_ToolResult_60) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#20 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#1366,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1366;
                    RETURN;
                END_IF;
                //******************Slot 67*****************//
                _geoAddr.Slot   :=  UINT#67;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_ToolResult_61);        
                IF Config.HWIDs.HwID_ToolResult_61 = UINT#0 THEN
                    Messenger.Activate(UINT#1370,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1370;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#1371,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1371;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#1372,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1372;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#1373,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1373;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#1374,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1374;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#1375,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1375;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HwID_ToolResult_61) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#20 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#1376,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1376;
                    RETURN;
                END_IF;
                //******************Slot 68*****************//
                _geoAddr.Slot   :=  UINT#68;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_ToolResult_62);        
                IF Config.HWIDs.HwID_ToolResult_62 = UINT#0 THEN
                    Messenger.Activate(UINT#1380,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1380;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#1381,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1381;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#1382,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1382;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#1383,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1383;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#1384,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1384;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#1385,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1385;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HwID_ToolResult_62) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#20 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#1386,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1386;
                    RETURN;
                END_IF;
                //******************Slot 69*****************//
                _geoAddr.Slot   :=  UINT#69;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_ToolResult_63);        
                IF Config.HWIDs.HwID_ToolResult_63 = UINT#0 THEN
                    Messenger.Activate(UINT#1390,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1390;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#1391,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1391;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#1392,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1392;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#1393,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1393;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#1394,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1394;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#1395,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1395;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HwID_ToolResult_63) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#20 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#1396,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1396;
                    RETURN;
                END_IF;
                //******************Slot 70*****************//
                _geoAddr.Slot   :=  UINT#70;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_ToolResult_64);        
                IF Config.HWIDs.HwID_ToolResult_64 = UINT#0 THEN
                    Messenger.Activate(UINT#1400,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1400;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#1401,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1401;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#1402,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1402;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#1403,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1403;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#1404,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1404;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#1405,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1405;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HwID_ToolResult_64) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#20 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#1406,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1406;
                    RETURN;
                END_IF;
                //******************Slot 71*****************//
                _geoAddr.Slot   :=  UINT#71;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HwID_DeviceResultBits_2);        
                IF Config.HWIDs.HwID_DeviceResultBits_2 = UINT#0 THEN
                    Messenger.Activate(UINT#1410,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1410;
                    RETURN;
                END_IF;
                IF _retval = WORD#8091 THEN
                    Messenger.Activate(UINT#1411,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1411;
                    RETURN;
                END_IF;
                IF _retval = WORD#8094 THEN
                    Messenger.Activate(UINT#1412,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1412;
                    RETURN;
                END_IF;
                IF _retval = WORD#8095 THEN
                    Messenger.Activate(UINT#1413,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1413;
                    RETURN;
                END_IF;
                IF _retval = WORD#8096 THEN
                    Messenger.Activate(UINT#1414,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1414;
                    RETURN;
                END_IF;
                IF _retval = WORD#8097 THEN
                    Messenger.Activate(UINT#1415,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1415;
                    RETURN;
                END_IF;
                ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HwID_DeviceResultBits_2) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#8 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#1416,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1416;
                    RETURN;
                END_IF;

                
                IF inParent = NULL THEN
                    Messenger.Activate(UINT#1500,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1500;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HW_Device  = UINT#0 THEN
                    Messenger.Activate(UINT#1501,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1501;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_CommandControl  = UINT#0 THEN
                    Messenger.Activate(UINT#1502,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1502;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_CommandStatusBits  = UINT#0 THEN
                    Messenger.Activate(UINT#1503,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1503;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_DeviceResultBits_1  = UINT#0 THEN
                    Messenger.Activate(UINT#1504,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1504;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_DeviceStatusWords  = UINT#0 THEN
                    Messenger.Activate(UINT#1505,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1505;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_DeviceStatistics  = UINT#0 THEN
                    Messenger.Activate(UINT#1506,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1506;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_PositionAdjustResult  = UINT#0 THEN
                    Messenger.Activate(UINT#1507,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1507;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_ToolResult_1  = UINT#0 THEN
                    Messenger.Activate(UINT#1508,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1508;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_ToolResult_2  = UINT#0 THEN
                    Messenger.Activate(UINT#1509,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1509;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_ToolResult_3  = UINT#0 THEN
                    Messenger.Activate(UINT#1510,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1510;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_ToolResult_4  = UINT#0 THEN
                    Messenger.Activate(UINT#1511,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1511;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_ToolResult_5  = UINT#0 THEN
                    Messenger.Activate(UINT#1512,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1512;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_ToolResult_6  = UINT#0 THEN
                    Messenger.Activate(UINT#1513,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1513;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_ToolResult_7  = UINT#0 THEN
                    Messenger.Activate(UINT#1514,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1514;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_ToolResult_8  = UINT#0 THEN
                    Messenger.Activate(UINT#1515,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1515;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_ToolResult_9  = UINT#0 THEN
                    Messenger.Activate(UINT#1516,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1516;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_ToolResult_10  = UINT#0 THEN
                    Messenger.Activate(UINT#1517,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1517;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_ToolResult_11  = UINT#0 THEN
                    Messenger.Activate(UINT#1518,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1518;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_ToolResult_12  = UINT#0 THEN
                    Messenger.Activate(UINT#1519,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1519;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_ToolResult_13  = UINT#0 THEN
                    Messenger.Activate(UINT#1520,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1520;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_ToolResult_14  = UINT#0 THEN
                    Messenger.Activate(UINT#1521,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1521;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_ToolResult_15  = UINT#0 THEN
                    Messenger.Activate(UINT#1522,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1522;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_ToolResult_16  = UINT#0 THEN
                    Messenger.Activate(UINT#1523,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1523;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_ToolResult_17  = UINT#0 THEN
                    Messenger.Activate(UINT#1524,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1524;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_ToolResult_18  = UINT#0 THEN
                    Messenger.Activate(UINT#1525,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1525;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_ToolResult_19  = UINT#0 THEN
                    Messenger.Activate(UINT#1526,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1526;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_ToolResult_20  = UINT#0 THEN
                    Messenger.Activate(UINT#1527,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1527;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_ToolResult_21  = UINT#0 THEN
                    Messenger.Activate(UINT#1528,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1528;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_ToolResult_22  = UINT#0 THEN
                    Messenger.Activate(UINT#1529,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1529;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_ToolResult_23  = UINT#0 THEN
                    Messenger.Activate(UINT#1530,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1530;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_ToolResult_24  = UINT#0 THEN
                    Messenger.Activate(UINT#1531,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1531;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_ToolResult_25  = UINT#0 THEN
                    Messenger.Activate(UINT#1532,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1532;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_ToolResult_26  = UINT#0 THEN
                    Messenger.Activate(UINT#1533,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1533;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_ToolResult_27  = UINT#0 THEN
                    Messenger.Activate(UINT#1534,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1534;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_ToolResult_28  = UINT#0 THEN
                    Messenger.Activate(UINT#1535,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1535;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_ToolResult_29  = UINT#0 THEN
                    Messenger.Activate(UINT#1536,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1536;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_ToolResult_30  = UINT#0 THEN
                    Messenger.Activate(UINT#1537,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1537;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_ToolResult_31  = UINT#0 THEN
                    Messenger.Activate(UINT#1538,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1538;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_ToolResult_32  = UINT#0 THEN
                    Messenger.Activate(UINT#1539,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1539;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_ToolResult_33  = UINT#0 THEN
                    Messenger.Activate(UINT#1540,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1540;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_ToolResult_34  = UINT#0 THEN
                    Messenger.Activate(UINT#1541,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1541;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_ToolResult_35  = UINT#0 THEN
                    Messenger.Activate(UINT#1542,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1542;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_ToolResult_36  = UINT#0 THEN
                    Messenger.Activate(UINT#1543,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1543;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_ToolResult_37  = UINT#0 THEN
                    Messenger.Activate(UINT#1544,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1544;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_ToolResult_38  = UINT#0 THEN
                    Messenger.Activate(UINT#1545,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1545;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_ToolResult_39  = UINT#0 THEN
                    Messenger.Activate(UINT#1546,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1546;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_ToolResult_40  = UINT#0 THEN
                    Messenger.Activate(UINT#1547,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1547;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_ToolResult_41  = UINT#0 THEN
                    Messenger.Activate(UINT#1548,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1548;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_ToolResult_42  = UINT#0 THEN
                    Messenger.Activate(UINT#1549,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1549;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_ToolResult_43  = UINT#0 THEN
                    Messenger.Activate(UINT#1550,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1550;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_ToolResult_44  = UINT#0 THEN
                    Messenger.Activate(UINT#1551,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1551;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_ToolResult_45  = UINT#0 THEN
                    Messenger.Activate(UINT#1552,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1552;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_ToolResult_46  = UINT#0 THEN
                    Messenger.Activate(UINT#1553,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1553;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_ToolResult_47  = UINT#0 THEN
                    Messenger.Activate(UINT#1554,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1554;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_ToolResult_48  = UINT#0 THEN
                    Messenger.Activate(UINT#1555,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1555;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_ToolResult_49  = UINT#0 THEN
                    Messenger.Activate(UINT#1556,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1556;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_ToolResult_50  = UINT#0 THEN
                    Messenger.Activate(UINT#1557,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1557;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_ToolResult_51  = UINT#0 THEN
                    Messenger.Activate(UINT#1558,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1558;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_ToolResult_52  = UINT#0 THEN
                    Messenger.Activate(UINT#1559,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1559;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_ToolResult_53  = UINT#0 THEN
                    Messenger.Activate(UINT#1560,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1560;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_ToolResult_54  = UINT#0 THEN
                    Messenger.Activate(UINT#1561,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1561;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_ToolResult_55  = UINT#0 THEN
                    Messenger.Activate(UINT#1562,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1562;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_ToolResult_56  = UINT#0 THEN
                    Messenger.Activate(UINT#1563,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1563;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_ToolResult_57  = UINT#0 THEN
                    Messenger.Activate(UINT#1564,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1564;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_ToolResult_58  = UINT#0 THEN
                    Messenger.Activate(UINT#1565,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1565;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_ToolResult_59  = UINT#0 THEN
                    Messenger.Activate(UINT#1566,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1566;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_ToolResult_60  = UINT#0 THEN
                    Messenger.Activate(UINT#1567,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1567;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_ToolResult_61  = UINT#0 THEN
                    Messenger.Activate(UINT#1568,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1568;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_ToolResult_62  = UINT#0 THEN
                    Messenger.Activate(UINT#1569,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1569;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_ToolResult_63  = UINT#0 THEN
                    Messenger.Activate(UINT#1570,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1570;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_ToolResult_64  = UINT#0 THEN
                    Messenger.Activate(UINT#1571,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1571;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HwID_DeviceResultBits_2  = UINT#0 THEN
                    Messenger.Activate(UINT#1572,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1572;
                    RETURN;
                END_IF;

                _initHwCheckDone    := TRUE;
            END_IF;            

            //***********Update inputs **************
            //*************************CommandStatusBits*********************
            _retVal := Siemens.Simatic.DistributedIO.ReadData((Config.HWIDs.HwID_CommandStatusBits) ,_data_in);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1601, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1601;
                RETURN;
            END_IF;

            Inputs.CommandStatusBits.TriggerResponse               :=   _data_in[0].%X0;       // IB0.0
            Inputs.CommandStatusBits.MasterRegistrationResponse    :=   _data_in[0].%X1;       // IB0.1
            Inputs.CommandStatusBits.ProgramSwitchingResponse      :=   _data_in[0].%X2;       // IB0.2
            Inputs.CommandStatusBits.WarningClearResponse          :=   _data_in[0].%X3;       // IB0.3
            Inputs.CommandStatusBits.StatisticsResetResponse       :=   _data_in[0].%X4;       // IB0.4
            Inputs.CommandStatusBits.BufferClearResponse           :=   _data_in[0].%X5;       // IB0.5
            Inputs.CommandStatusBits.SdCardSavingStopResponse      :=   _data_in[0].%X6;       // IB0.6
            Inputs.CommandStatusBits.SettingValueChangeResponse    :=   _data_in[0].%X7;       // IB0.7

            Inputs.CommandStatusBits.TriggerFailed                 :=   _data_in[1].%X0;       // IB1.0
            Inputs.CommandStatusBits.MasterRegistrationFailed      :=   _data_in[1].%X1;       // IB1.1
            Inputs.CommandStatusBits.ProgramSwitchingFailed        :=   _data_in[1].%X2;       // IB1.2
                                                               //  :=   _data_in[1].%X3;       // IB1.3
                                                               //  :=   _data_in[1].%X4;       // IB1.4
                                                               //  :=   _data_in[1].%X5;       // IB1.5
            Inputs.CommandStatusBits.SdCardSavingStopFailed        :=   _data_in[1].%X6;       // IB1.6
            Inputs.CommandStatusBits.SettingValueChangeFailed      :=   _data_in[1].%X7;       // IB1.7

            Inputs.CommandStatusBits.ResultAvailable               :=   _data_in[2].%X0;       // IB2.0
            Inputs.CommandStatusBits.ResultUpdateComplete          :=   _data_in[2].%X1;       // IB2.1
            Inputs.CommandStatusBits.BUSY                          :=   _data_in[2].%X2;       // IB2.2
            Inputs.CommandStatusBits.ImagingStatus                 :=   _data_in[2].%X3;       // IB2.3
            Inputs.CommandStatusBits.RUN                           :=   _data_in[2].%X4;       // IB2.4
            Inputs.CommandStatusBits.Ready                         :=   _data_in[2].%X5;       // IB2.5
            Inputs.CommandStatusBits.TriggerReady                  :=   _data_in[2].%X6;       // IB2.6
            Inputs.CommandStatusBits.SdCardIdentificationStatus    :=   _data_in[2].%X7;       // IB2.7

            Inputs.CommandStatusBits.SortingModeInformation        :=   _data_in[3].%X0;       // IB3.0
                                                                // :=   _data_in[3].%X1;       // IB3.1
                                                                // :=   _data_in[3].%X2;       // IB3.2
                                                                // :=   _data_in[3].%X3;       // IB3.3
            Inputs.CommandStatusBits.InsufficientFreeSpaceOnSdCard :=   _data_in[3].%X4;       // IB3.4   
            Inputs.CommandStatusBits.BufferOverrun                 :=   _data_in[3].%X5;       // IB3.5   
            Inputs.CommandStatusBits.Warning                       :=   _data_in[3].%X6;       // IB3.6   
            Inputs.CommandStatusBits.Error                         :=   _data_in[3].%X7;       // IB3.7   
            //***************************************************************

            //*************************DeviceResultBits_1********************
            _retVal := Siemens.Simatic.DistributedIO.ReadData((Config.HWIDs.HwID_DeviceResultBits_1) ,_data_in);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1602, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1602;
                RETURN;
            END_IF;

            Inputs.DeviceResultBits_1.OverallJudgmentOK             :=   _data_in[0].%X0;       // IB4.0
            Inputs.DeviceResultBits_1.PositionCorrection            :=   _data_in[0].%X1;       // IB4.1
            Inputs.DeviceResultBits_1.LOGIC1                        :=   _data_in[0].%X2;       // IB4.2
            Inputs.DeviceResultBits_1.LOGIC2                        :=   _data_in[0].%X3;       // IB4.3
            Inputs.DeviceResultBits_1.LOGIC3                        :=   _data_in[0].%X4;       // IB4.4
            Inputs.DeviceResultBits_1.LOGIC4                        :=   _data_in[0].%X5;       // IB4.5
            Inputs.DeviceResultBits_1.OverallJudgmentNG             :=   _data_in[0].%X6;       // IB4.6
                                                                 // :=   _data_in[0].%X7;       // IB4.7

            Inputs.DeviceResultBits_1.Tool_1                        :=   _data_in[2].%X0;       // IB6.0
            Inputs.DeviceResultBits_1.Tool_2                        :=   _data_in[2].%X1;       // IB6.1
            Inputs.DeviceResultBits_1.Tool_3                        :=   _data_in[2].%X2;       // IB6.2
            Inputs.DeviceResultBits_1.Tool_4                        :=   _data_in[2].%X3;       // IB6.3
            Inputs.DeviceResultBits_1.Tool_5                        :=   _data_in[2].%X4;       // IB6.4
            Inputs.DeviceResultBits_1.Tool_6                        :=   _data_in[2].%X5;       // IB6.5
            Inputs.DeviceResultBits_1.Tool_7                        :=   _data_in[2].%X6;       // IB6.6
            Inputs.DeviceResultBits_1.Tool_8                        :=   _data_in[2].%X7;       // IB6.7

            Inputs.DeviceResultBits_1.Tool_9                        :=   _data_in[3].%X0;       // IB7.0
            Inputs.DeviceResultBits_1.Tool_10                       :=   _data_in[3].%X1;       // IB7.1
            Inputs.DeviceResultBits_1.Tool_11                       :=   _data_in[3].%X2;       // IB7.2
            Inputs.DeviceResultBits_1.Tool_12                       :=   _data_in[3].%X3;       // IB7.3
            Inputs.DeviceResultBits_1.Tool_13                       :=   _data_in[3].%X4;       // IB7.4
            Inputs.DeviceResultBits_1.Tool_14                       :=   _data_in[3].%X5;       // IB7.5
            Inputs.DeviceResultBits_1.Tool_15                       :=   _data_in[3].%X6;       // IB7.6
            Inputs.DeviceResultBits_1.Tool_16                       :=   _data_in[3].%X7;       // IB7.7
            //***************************************************************

            //*************************DeviceStatusWords*********************
            _retVal := Siemens.Simatic.DistributedIO.ReadData((Config.HWIDs.HwID_DeviceStatusWords) ,_data_in);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1603, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1603;
                RETURN;
            END_IF;
            
            _word.%B0 := _data_in[1];
            _word.%B1 := _data_in[0];
            Inputs.DeviceStatusWords.ErrorNo                       :=  TO_UINT(_word);         // IW8
            _word.%B0 := _data_in[3];
            _word.%B1 := _data_in[2];
            Inputs.DeviceStatusWords.WarningNo                     :=  TO_UINT(_word);         // IW10
            _word.%B0 := _data_in[5];
            _word.%B1 := _data_in[4];
            Inputs.DeviceStatusWords.NumberOfRemainingBuffers      :=  TO_UINT(_word);         // IW12
            _word.%B0 := _data_in[7];
            _word.%B1 := _data_in[6];
            Inputs.DeviceStatusWords.Checksum                      :=  TO_UINT(_word);         // IW14
            _word.%B0 := _data_in[9];
            _word.%B1 := _data_in[8];
            Inputs.DeviceStatusWords.CurrentProgramNo              :=  TO_UINT(_word);         // IW16
            _word.%B0 := _data_in[11];
            _word.%B1 := _data_in[10];
            Inputs.DeviceStatusWords.ProgramNoDuringJudgment       :=  TO_UINT(_word);         // IW18
            _word.%B0 := _data_in[13];
            _word.%B1 := _data_in[12];
            Inputs.DeviceStatusWords.ResultNo                      :=  TO_UINT(_word);         // IW20
            _word.%B0 := _data_in[15];
            _word.%B1 := _data_in[14];
            Inputs.DeviceStatusWords.ProcessingTime                :=  TO_UINT(_word);         // IW22
            //***************************************************************

            //*************************DeviceStatistics**********************
            _retVal := Siemens.Simatic.DistributedIO.ReadData((Config.HWIDs.HwID_DeviceStatistics) ,_data_in);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1604, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1604;
                RETURN;
            END_IF;

            _word.%B0 := _data_in[1];
            _word.%B1 := _data_in[0];
            Inputs.DeviceStatistics.ProcessingTimeMax             :=  TO_UINT(_word);         // IW24
            _word.%B0 := _data_in[3];
            _word.%B1 := _data_in[2];
            Inputs.DeviceStatistics.ProcessingTimeMin             :=  TO_UINT(_word);         // IW26
            _word.%B0 := _data_in[5];
            _word.%B1 := _data_in[4];
            Inputs.DeviceStatistics.ProcessingTimeAve             :=  TO_UINT(_word);         // IW28
                                                                                              // IW30
            _dword.%B0 := _data_in[11];
            _dword.%B1 := _data_in[10];
            _dword.%B2 := _data_in[9];
            _dword.%B3 := _data_in[8];
            Inputs.DeviceStatistics.NumberOfTriggers              :=  TO_UINT(_dword);        // ID32
            _dword.%B0 := _data_in[15];
            _dword.%B1 := _data_in[14];
            _dword.%B2 := _data_in[13];
            _dword.%B3 := _data_in[12];
            Inputs.DeviceStatistics.NumberOfOKs                   :=  TO_UINT(_dword);        // ID36
            _dword.%B0 := _data_in[19];
            _dword.%B1 := _data_in[18];
            _dword.%B2 := _data_in[17];
            _dword.%B3 := _data_in[16];
            Inputs.DeviceStatistics.NumberOfNGs                   :=  TO_UINT(_dword);        // ID40
            _dword.%B0 := _data_in[23];
            _dword.%B1 := _data_in[22];
            _dword.%B2 := _data_in[21];
            _dword.%B3 := _data_in[20];
            Inputs.DeviceStatistics.NumberOfTriggerErrors         :=  TO_UINT(_dword);        // ID44
                                                                                              // ID48
            //***************************************************************

            //*************************PositionAdjustResult******************
            _retVal := Siemens.Simatic.DistributedIO.ReadData((Config.HWIDs.HwID_PositionAdjustResult) ,_data_in);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1605, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1605;
                RETURN;
            END_IF;

            _word.%B0 := _data_in[1];
            _word.%B1 := _data_in[0];
            Inputs.PositionAdjustResult.PositionCorrectionScore       :=  TO_UINT(_word);         // IW52
            _word.%B0 := _data_in[3];
            _word.%B1 := _data_in[2];
            Inputs.PositionAdjustResult.PositionCorrectionScoreMAX    :=  TO_UINT(_word);         // IW54
            _word.%B0 := _data_in[5];
            _word.%B1 := _data_in[4];
            Inputs.PositionAdjustResult.PositionCorrectionScoreMIN    :=  TO_UINT(_word);         // IW56
            _word.%B0 := _data_in[7];
            _word.%B1 := _data_in[6];
            Inputs.PositionAdjustResult.PositionCorrectionScoreLowerThreshold :=  TO_UINT(_word); // IW58
                                                                                                  // IB60-IB71
            //***************************************************************

            //*************************ToolResult_1**************************
            _retVal := Siemens.Simatic.DistributedIO.ReadData((Config.HWIDs.HwID_ToolResult_1) ,_data_in);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1606, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1606;
                RETURN;
            END_IF;

            _word.%B0 := _data_in[1];
            _word.%B1 := _data_in[0];
            Inputs.ToolResult_1.MatchingRate       :=  TO_UINT(_word);         // IW72
            _word.%B0 := _data_in[3];
            _word.%B1 := _data_in[2];
            Inputs.ToolResult_1.MatchingRateMAX    :=  TO_UINT(_word);         // IW74
            _word.%B0 := _data_in[5];
            _word.%B1 := _data_in[4];
            Inputs.ToolResult_1.MatchingRateMIN    :=  TO_UINT(_word);         // IW76
            _word.%B0 := _data_in[7];
            _word.%B1 := _data_in[6];
            Inputs.ToolResult_1.LowerThreshold     :=  TO_UINT(_word);         // IW78
            _word.%B0 := _data_in[9];
            _word.%B1 := _data_in[8];
            Inputs.ToolResult_1.UpperThreshold     :=  TO_UINT(_word);         // IW80
            _word.%B0 := _data_in[11];
            _word.%B1 := _data_in[10];
            Inputs.ToolResult_1.DecimalPointPosition:=  TO_UINT(_word);        // IW82
            _word.%B0 := _data_in[13];
            _word.%B1 := _data_in[12];
            Inputs.ToolResult_1.Data_1             :=  TO_UINT(_word);         // IW84
            _word.%B0 := _data_in[15];
            _word.%B1 := _data_in[14];
            Inputs.ToolResult_1.Data_2             :=  TO_UINT(_word);         // IW86
            _word.%B0 := _data_in[17];
            _word.%B1 := _data_in[16];
            Inputs.ToolResult_1.Data_3             :=  TO_UINT(_word);         // IW88
                                                                                    // IW90
            //***************************************************************

            //*************************ToolResult_2**************************
            _retVal := Siemens.Simatic.DistributedIO.ReadData((Config.HWIDs.HwID_ToolResult_2) ,_data_in);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1607, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1607;
                RETURN;
            END_IF;

            _word.%B0 := _data_in[1];
            _word.%B1 := _data_in[0];
            Inputs.ToolResult_2.MatchingRate       :=  TO_UINT(_word);         // IW92
            _word.%B0 := _data_in[3];
            _word.%B1 := _data_in[2];
            Inputs.ToolResult_2.MatchingRateMAX    :=  TO_UINT(_word);         // IW94
            _word.%B0 := _data_in[5];
            _word.%B1 := _data_in[4];
            Inputs.ToolResult_2.MatchingRateMIN    :=  TO_UINT(_word);         // IW96
            _word.%B0 := _data_in[7];
            _word.%B1 := _data_in[6];
            Inputs.ToolResult_2.LowerThreshold     :=  TO_UINT(_word);         // IW98
            _word.%B0 := _data_in[9];
            _word.%B1 := _data_in[8];
            Inputs.ToolResult_2.UpperThreshold     :=  TO_UINT(_word);         // IW100
            _word.%B0 := _data_in[11];
            _word.%B1 := _data_in[10];
            Inputs.ToolResult_2.DecimalPointPosition:=  TO_UINT(_word);        // IW102
            _word.%B0 := _data_in[13];
            _word.%B1 := _data_in[12];
            Inputs.ToolResult_2.Data_1             :=  TO_UINT(_word);         // IW104
            _word.%B0 := _data_in[15];
            _word.%B1 := _data_in[14];
            Inputs.ToolResult_2.Data_2             :=  TO_UINT(_word);         // IW106
            _word.%B0 := _data_in[17];
            _word.%B1 := _data_in[16];
            Inputs.ToolResult_2.Data_3             :=  TO_UINT(_word);         // IW108
                                                                                    // IW110
            //***************************************************************

            //*************************ToolResult_3**************************
            _retVal := Siemens.Simatic.DistributedIO.ReadData((Config.HWIDs.HwID_ToolResult_3) ,_data_in);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1608, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1608;
                RETURN;
            END_IF;

            _word.%B0 := _data_in[1];
            _word.%B1 := _data_in[0];
            Inputs.ToolResult_3.MatchingRate       :=  TO_UINT(_word);         // IW112
            _word.%B0 := _data_in[3];
            _word.%B1 := _data_in[2];
            Inputs.ToolResult_3.MatchingRateMAX    :=  TO_UINT(_word);         // IW114
            _word.%B0 := _data_in[5];
            _word.%B1 := _data_in[4];
            Inputs.ToolResult_3.MatchingRateMIN    :=  TO_UINT(_word);         // IW116
            _word.%B0 := _data_in[7];
            _word.%B1 := _data_in[6];
            Inputs.ToolResult_3.LowerThreshold     :=  TO_UINT(_word);         // IW118
            _word.%B0 := _data_in[9];
            _word.%B1 := _data_in[8];
            Inputs.ToolResult_3.UpperThreshold     :=  TO_UINT(_word);         // IW120
            _word.%B0 := _data_in[11];
            _word.%B1 := _data_in[10];
            Inputs.ToolResult_3.DecimalPointPosition:=  TO_UINT(_word);        // IW122
            _word.%B0 := _data_in[13];
            _word.%B1 := _data_in[12];
            Inputs.ToolResult_3.Data_1             :=  TO_UINT(_word);         // IW124
            _word.%B0 := _data_in[15];
            _word.%B1 := _data_in[14];
            Inputs.ToolResult_3.Data_2             :=  TO_UINT(_word);         // IW126
            _word.%B0 := _data_in[17];
            _word.%B1 := _data_in[16];
            Inputs.ToolResult_3.Data_3             :=  TO_UINT(_word);         // IW128
                                                                                    // IW130
            //***************************************************************

            //*************************ToolResult_4**************************
            _retVal := Siemens.Simatic.DistributedIO.ReadData((Config.HWIDs.HwID_ToolResult_4) ,_data_in);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1609, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1609;
                RETURN;
            END_IF;

            _word.%B0 := _data_in[1];
            _word.%B1 := _data_in[0];
            Inputs.ToolResult_4.MatchingRate       :=  TO_UINT(_word);         // IW132
            _word.%B0 := _data_in[3];
            _word.%B1 := _data_in[2];
            Inputs.ToolResult_4.MatchingRateMAX    :=  TO_UINT(_word);         // IW134
            _word.%B0 := _data_in[5];
            _word.%B1 := _data_in[4];
            Inputs.ToolResult_4.MatchingRateMIN    :=  TO_UINT(_word);         // IW136
            _word.%B0 := _data_in[7];
            _word.%B1 := _data_in[6];
            Inputs.ToolResult_4.LowerThreshold     :=  TO_UINT(_word);         // IW138
            _word.%B0 := _data_in[9];
            _word.%B1 := _data_in[8];
            Inputs.ToolResult_4.UpperThreshold     :=  TO_UINT(_word);         // IW140
            _word.%B0 := _data_in[11];
            _word.%B1 := _data_in[10];
            Inputs.ToolResult_4.DecimalPointPosition:=  TO_UINT(_word);        // IW142
            _word.%B0 := _data_in[13];
            _word.%B1 := _data_in[12];
            Inputs.ToolResult_4.Data_1             :=  TO_UINT(_word);         // IW144
            _word.%B0 := _data_in[15];
            _word.%B1 := _data_in[14];
            Inputs.ToolResult_4.Data_2             :=  TO_UINT(_word);         // IW146
            _word.%B0 := _data_in[17];
            _word.%B1 := _data_in[16];
            Inputs.ToolResult_4.Data_3             :=  TO_UINT(_word);         // IW148
                                                                                    // IW150
            //***************************************************************

            //*************************ToolResult_5**************************
            _retVal := Siemens.Simatic.DistributedIO.ReadData((Config.HWIDs.HwID_ToolResult_5) ,_data_in);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1610, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1610;
                RETURN;
            END_IF;

            _word.%B0 := _data_in[1];
            _word.%B1 := _data_in[0];
            Inputs.ToolResult_5.MatchingRate       :=  TO_UINT(_word);         // IW152
            _word.%B0 := _data_in[3];
            _word.%B1 := _data_in[2];
            Inputs.ToolResult_5.MatchingRateMAX    :=  TO_UINT(_word);         // IW154
            _word.%B0 := _data_in[5];
            _word.%B1 := _data_in[4];
            Inputs.ToolResult_5.MatchingRateMIN    :=  TO_UINT(_word);         // IW156
            _word.%B0 := _data_in[7];
            _word.%B1 := _data_in[6];
            Inputs.ToolResult_5.LowerThreshold     :=  TO_UINT(_word);         // IW158
            _word.%B0 := _data_in[9];
            _word.%B1 := _data_in[8];
            Inputs.ToolResult_5.UpperThreshold     :=  TO_UINT(_word);         // IW160
            _word.%B0 := _data_in[11];
            _word.%B1 := _data_in[10];
            Inputs.ToolResult_5.DecimalPointPosition:=  TO_UINT(_word);        // IW162
            _word.%B0 := _data_in[13];
            _word.%B1 := _data_in[12];
            Inputs.ToolResult_5.Data_1             :=  TO_UINT(_word);         // IW164
            _word.%B0 := _data_in[15];
            _word.%B1 := _data_in[14];
            Inputs.ToolResult_5.Data_2             :=  TO_UINT(_word);         // IW166
            _word.%B0 := _data_in[17];
            _word.%B1 := _data_in[16];
            Inputs.ToolResult_5.Data_3             :=  TO_UINT(_word);         // IW168
                                                                                    // IW170
            //***************************************************************

            //*************************ToolResult_6**************************
            _retVal := Siemens.Simatic.DistributedIO.ReadData((Config.HWIDs.HwID_ToolResult_6) ,_data_in);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1611, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1611;
                RETURN;
            END_IF;

            _word.%B0 := _data_in[1];
            _word.%B1 := _data_in[0];
            Inputs.ToolResult_6.MatchingRate       :=  TO_UINT(_word);         // IW172
            _word.%B0 := _data_in[3];
            _word.%B1 := _data_in[2];
            Inputs.ToolResult_6.MatchingRateMAX    :=  TO_UINT(_word);         // IW174
            _word.%B0 := _data_in[5];
            _word.%B1 := _data_in[4];
            Inputs.ToolResult_6.MatchingRateMIN    :=  TO_UINT(_word);         // IW176
            _word.%B0 := _data_in[7];
            _word.%B1 := _data_in[6];
            Inputs.ToolResult_6.LowerThreshold     :=  TO_UINT(_word);         // IW178
            _word.%B0 := _data_in[9];
            _word.%B1 := _data_in[8];
            Inputs.ToolResult_6.UpperThreshold     :=  TO_UINT(_word);         // IW180
            _word.%B0 := _data_in[11];
            _word.%B1 := _data_in[10];
            Inputs.ToolResult_6.DecimalPointPosition:=  TO_UINT(_word);        // IW182
            _word.%B0 := _data_in[13];
            _word.%B1 := _data_in[12];
            Inputs.ToolResult_6.Data_1             :=  TO_UINT(_word);         // IW184
            _word.%B0 := _data_in[15];
            _word.%B1 := _data_in[14];
            Inputs.ToolResult_6.Data_2             :=  TO_UINT(_word);         // IW186
            _word.%B0 := _data_in[17];
            _word.%B1 := _data_in[16];
            Inputs.ToolResult_6.Data_3             :=  TO_UINT(_word);         // IW188
                                                                                    // IW190
            //***************************************************************

            //*************************ToolResult_7**************************
            _retVal := Siemens.Simatic.DistributedIO.ReadData((Config.HWIDs.HwID_ToolResult_7) ,_data_in);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1612, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1612;
                RETURN;
            END_IF;

            _word.%B0 := _data_in[1];
            _word.%B1 := _data_in[0];
            Inputs.ToolResult_7.MatchingRate       :=  TO_UINT(_word);         // IW192
            _word.%B0 := _data_in[3];
            _word.%B1 := _data_in[2];
            Inputs.ToolResult_7.MatchingRateMAX    :=  TO_UINT(_word);         // IW194
            _word.%B0 := _data_in[5];
            _word.%B1 := _data_in[4];
            Inputs.ToolResult_7.MatchingRateMIN    :=  TO_UINT(_word);         // IW196
            _word.%B0 := _data_in[7];
            _word.%B1 := _data_in[6];
            Inputs.ToolResult_7.LowerThreshold     :=  TO_UINT(_word);         // IW198
            _word.%B0 := _data_in[9];
            _word.%B1 := _data_in[8];
            Inputs.ToolResult_7.UpperThreshold     :=  TO_UINT(_word);         // IW200
            _word.%B0 := _data_in[11];
            _word.%B1 := _data_in[10];
            Inputs.ToolResult_7.DecimalPointPosition:=  TO_UINT(_word);        // IW202
            _word.%B0 := _data_in[13];
            _word.%B1 := _data_in[12];
            Inputs.ToolResult_7.Data_1             :=  TO_UINT(_word);         // IW204
            _word.%B0 := _data_in[15];
            _word.%B1 := _data_in[14];
            Inputs.ToolResult_7.Data_2             :=  TO_UINT(_word);         // IW206
            _word.%B0 := _data_in[17];
            _word.%B1 := _data_in[16];
            Inputs.ToolResult_7.Data_3             :=  TO_UINT(_word);         // IW208
                                                                                    // IW210
            //***************************************************************

            //*************************ToolResult_8**************************
            _retVal := Siemens.Simatic.DistributedIO.ReadData((Config.HWIDs.HwID_ToolResult_8) ,_data_in);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1613, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1613;
                RETURN;
            END_IF;

            _word.%B0 := _data_in[1];
            _word.%B1 := _data_in[0];
            Inputs.ToolResult_8.MatchingRate       :=  TO_UINT(_word);         // IW212
            _word.%B0 := _data_in[3];
            _word.%B1 := _data_in[2];
            Inputs.ToolResult_8.MatchingRateMAX    :=  TO_UINT(_word);         // IW214
            _word.%B0 := _data_in[5];
            _word.%B1 := _data_in[4];
            Inputs.ToolResult_8.MatchingRateMIN    :=  TO_UINT(_word);         // IW216
            _word.%B0 := _data_in[7];
            _word.%B1 := _data_in[6];
            Inputs.ToolResult_8.LowerThreshold     :=  TO_UINT(_word);         // IW218
            _word.%B0 := _data_in[9];
            _word.%B1 := _data_in[8];
            Inputs.ToolResult_8.UpperThreshold     :=  TO_UINT(_word);         // IW220
            _word.%B0 := _data_in[11];
            _word.%B1 := _data_in[10];
            Inputs.ToolResult_8.DecimalPointPosition:=  TO_UINT(_word);        // IW222
            _word.%B0 := _data_in[13];
            _word.%B1 := _data_in[12];
            Inputs.ToolResult_8.Data_1             :=  TO_UINT(_word);         // IW224
            _word.%B0 := _data_in[15];
            _word.%B1 := _data_in[14];
            Inputs.ToolResult_8.Data_2             :=  TO_UINT(_word);         // IW226
            _word.%B0 := _data_in[17];
            _word.%B1 := _data_in[16];
            Inputs.ToolResult_8.Data_3             :=  TO_UINT(_word);         // IW228
                                                                                    // IW230
            //***************************************************************

            //*************************ToolResult_9**************************
            _retVal := Siemens.Simatic.DistributedIO.ReadData((Config.HWIDs.HwID_ToolResult_9) ,_data_in);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1614, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1614;
                RETURN;
            END_IF;

            _word.%B0 := _data_in[1];
            _word.%B1 := _data_in[0];
            Inputs.ToolResult_9.MatchingRate       :=  TO_UINT(_word);         // IW232
            _word.%B0 := _data_in[3];
            _word.%B1 := _data_in[2];
            Inputs.ToolResult_9.MatchingRateMAX    :=  TO_UINT(_word);         // IW234
            _word.%B0 := _data_in[5];
            _word.%B1 := _data_in[4];
            Inputs.ToolResult_9.MatchingRateMIN    :=  TO_UINT(_word);         // IW236
            _word.%B0 := _data_in[7];
            _word.%B1 := _data_in[6];
            Inputs.ToolResult_9.LowerThreshold     :=  TO_UINT(_word);         // IW238
            _word.%B0 := _data_in[9];
            _word.%B1 := _data_in[8];
            Inputs.ToolResult_9.UpperThreshold     :=  TO_UINT(_word);         // IW240
            _word.%B0 := _data_in[11];
            _word.%B1 := _data_in[10];
            Inputs.ToolResult_9.DecimalPointPosition:=  TO_UINT(_word);        // IW242
            _word.%B0 := _data_in[13];
            _word.%B1 := _data_in[12];
            Inputs.ToolResult_9.Data_1             :=  TO_UINT(_word);         // IW244
            _word.%B0 := _data_in[15];
            _word.%B1 := _data_in[14];
            Inputs.ToolResult_9.Data_2             :=  TO_UINT(_word);         // IW246
            _word.%B0 := _data_in[17];
            _word.%B1 := _data_in[16];
            Inputs.ToolResult_9.Data_3             :=  TO_UINT(_word);         // IW248
                                                                                    // IW250
            //***************************************************************

            //*************************ToolResult_10*************************
            _retVal := Siemens.Simatic.DistributedIO.ReadData((Config.HWIDs.HwID_ToolResult_10) ,_data_in);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1615, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1615;
                RETURN;
            END_IF;

            _word.%B0 := _data_in[1];
            _word.%B1 := _data_in[0];
            Inputs.ToolResult_10.MatchingRate       :=  TO_UINT(_word);        // IW252
            _word.%B0 := _data_in[3];
            _word.%B1 := _data_in[2];
            Inputs.ToolResult_10.MatchingRateMAX    :=  TO_UINT(_word);        // IW254
            _word.%B0 := _data_in[5];
            _word.%B1 := _data_in[4];
            Inputs.ToolResult_10.MatchingRateMIN    :=  TO_UINT(_word);        // IW256
            _word.%B0 := _data_in[7];
            _word.%B1 := _data_in[6];
            Inputs.ToolResult_10.LowerThreshold     :=  TO_UINT(_word);        // IW258
            _word.%B0 := _data_in[9];
            _word.%B1 := _data_in[8];
            Inputs.ToolResult_10.UpperThreshold     :=  TO_UINT(_word);        // IW260
            _word.%B0 := _data_in[11];
            _word.%B1 := _data_in[10];
            Inputs.ToolResult_10.DecimalPointPosition:=  TO_UINT(_word);       // IW262
            _word.%B0 := _data_in[13];
            _word.%B1 := _data_in[12];
            Inputs.ToolResult_10.Data_1             :=  TO_UINT(_word);        // IW264
            _word.%B0 := _data_in[15];
            _word.%B1 := _data_in[14];
            Inputs.ToolResult_10.Data_2             :=  TO_UINT(_word);        // IW266
            _word.%B0 := _data_in[17];
            _word.%B1 := _data_in[16];
            Inputs.ToolResult_10.Data_3             :=  TO_UINT(_word);        // IW268
                                                                                    // IW270
            //***************************************************************

            //*************************ToolResult_11*************************
            _retVal := Siemens.Simatic.DistributedIO.ReadData((Config.HWIDs.HwID_ToolResult_11) ,_data_in);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1616, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1616;
                RETURN;
            END_IF;

            _word.%B0 := _data_in[1];
            _word.%B1 := _data_in[0];
            Inputs.ToolResult_11.MatchingRate       :=  TO_UINT(_word);        // IW272
            _word.%B0 := _data_in[3];
            _word.%B1 := _data_in[2];
            Inputs.ToolResult_11.MatchingRateMAX    :=  TO_UINT(_word);        // IW274
            _word.%B0 := _data_in[5];
            _word.%B1 := _data_in[4];
            Inputs.ToolResult_11.MatchingRateMIN    :=  TO_UINT(_word);        // IW276
            _word.%B0 := _data_in[7];
            _word.%B1 := _data_in[6];
            Inputs.ToolResult_11.LowerThreshold     :=  TO_UINT(_word);        // IW278
            _word.%B0 := _data_in[9];
            _word.%B1 := _data_in[8];
            Inputs.ToolResult_11.UpperThreshold     :=  TO_UINT(_word);        // IW280
            _word.%B0 := _data_in[11];
            _word.%B1 := _data_in[10];
            Inputs.ToolResult_11.DecimalPointPosition:=  TO_UINT(_word);       // IW282
            _word.%B0 := _data_in[13];
            _word.%B1 := _data_in[12];
            Inputs.ToolResult_11.Data_1             :=  TO_UINT(_word);        // IW284
            _word.%B0 := _data_in[15];
            _word.%B1 := _data_in[14];
            Inputs.ToolResult_11.Data_2             :=  TO_UINT(_word);        // IW286
            _word.%B0 := _data_in[17];
            _word.%B1 := _data_in[16];
            Inputs.ToolResult_11.Data_3             :=  TO_UINT(_word);        // IW288
                                                                                    // IW290
            //***************************************************************

            //*************************ToolResult_12*************************
            _retVal := Siemens.Simatic.DistributedIO.ReadData((Config.HWIDs.HwID_ToolResult_12) ,_data_in);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1617, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1617;
                RETURN;
            END_IF;

            _word.%B0 := _data_in[1];
            _word.%B1 := _data_in[0];
            Inputs.ToolResult_12.MatchingRate       :=  TO_UINT(_word);        // IW292
            _word.%B0 := _data_in[3];
            _word.%B1 := _data_in[2];
            Inputs.ToolResult_12.MatchingRateMAX    :=  TO_UINT(_word);        // IW294
            _word.%B0 := _data_in[5];
            _word.%B1 := _data_in[4];
            Inputs.ToolResult_12.MatchingRateMIN    :=  TO_UINT(_word);        // IW296
            _word.%B0 := _data_in[7];
            _word.%B1 := _data_in[6];
            Inputs.ToolResult_12.LowerThreshold     :=  TO_UINT(_word);        // IW298
            _word.%B0 := _data_in[9];
            _word.%B1 := _data_in[8];
            Inputs.ToolResult_12.UpperThreshold     :=  TO_UINT(_word);        // IW300
            _word.%B0 := _data_in[11];
            _word.%B1 := _data_in[10];
            Inputs.ToolResult_12.DecimalPointPosition:=  TO_UINT(_word);       // IW302
            _word.%B0 := _data_in[13];
            _word.%B1 := _data_in[12];
            Inputs.ToolResult_12.Data_1             :=  TO_UINT(_word);        // IW304
            _word.%B0 := _data_in[15];
            _word.%B1 := _data_in[14];
            Inputs.ToolResult_12.Data_2             :=  TO_UINT(_word);        // IW306
            _word.%B0 := _data_in[17];
            _word.%B1 := _data_in[16];
            Inputs.ToolResult_12.Data_3             :=  TO_UINT(_word);        // IW308
                                                                                    // IW310
            //***************************************************************

            //*************************ToolResult_13*************************
            _retVal := Siemens.Simatic.DistributedIO.ReadData((Config.HWIDs.HwID_ToolResult_13) ,_data_in);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1618, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1618;
                RETURN;
            END_IF;

            _word.%B0 := _data_in[1];
            _word.%B1 := _data_in[0];
            Inputs.ToolResult_13.MatchingRate       :=  TO_UINT(_word);        // IW312
            _word.%B0 := _data_in[3];
            _word.%B1 := _data_in[2];
            Inputs.ToolResult_13.MatchingRateMAX    :=  TO_UINT(_word);        // IW314
            _word.%B0 := _data_in[5];
            _word.%B1 := _data_in[4];
            Inputs.ToolResult_13.MatchingRateMIN    :=  TO_UINT(_word);        // IW316
            _word.%B0 := _data_in[7];
            _word.%B1 := _data_in[6];
            Inputs.ToolResult_13.LowerThreshold     :=  TO_UINT(_word);        // IW318
            _word.%B0 := _data_in[9];
            _word.%B1 := _data_in[8];
            Inputs.ToolResult_13.UpperThreshold     :=  TO_UINT(_word);        // IW320
            _word.%B0 := _data_in[11];
            _word.%B1 := _data_in[10];
            Inputs.ToolResult_13.DecimalPointPosition:=  TO_UINT(_word);       // IW322
            _word.%B0 := _data_in[13];
            _word.%B1 := _data_in[12];
            Inputs.ToolResult_13.Data_1             :=  TO_UINT(_word);        // IW324
            _word.%B0 := _data_in[15];
            _word.%B1 := _data_in[14];
            Inputs.ToolResult_13.Data_2             :=  TO_UINT(_word);        // IW326
            _word.%B0 := _data_in[17];
            _word.%B1 := _data_in[16];
            Inputs.ToolResult_13.Data_3             :=  TO_UINT(_word);        // IW328
                                                                                    // IW330
            //***************************************************************

            //*************************ToolResult_14*************************
            _retVal := Siemens.Simatic.DistributedIO.ReadData((Config.HWIDs.HwID_ToolResult_14) ,_data_in);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1619, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1619;
                RETURN;
            END_IF;

            _word.%B0 := _data_in[1];
            _word.%B1 := _data_in[0];
            Inputs.ToolResult_14.MatchingRate       :=  TO_UINT(_word);        // IW332
            _word.%B0 := _data_in[3];
            _word.%B1 := _data_in[2];
            Inputs.ToolResult_14.MatchingRateMAX    :=  TO_UINT(_word);        // IW334
            _word.%B0 := _data_in[5];
            _word.%B1 := _data_in[4];
            Inputs.ToolResult_14.MatchingRateMIN    :=  TO_UINT(_word);        // IW336
            _word.%B0 := _data_in[7];
            _word.%B1 := _data_in[6];
            Inputs.ToolResult_14.LowerThreshold     :=  TO_UINT(_word);        // IW338
            _word.%B0 := _data_in[9];
            _word.%B1 := _data_in[8];
            Inputs.ToolResult_14.UpperThreshold     :=  TO_UINT(_word);        // IW340
            _word.%B0 := _data_in[11];
            _word.%B1 := _data_in[10];
            Inputs.ToolResult_14.DecimalPointPosition:=  TO_UINT(_word);       // IW342
            _word.%B0 := _data_in[13];
            _word.%B1 := _data_in[12];
            Inputs.ToolResult_14.Data_1             :=  TO_UINT(_word);        // IW344
            _word.%B0 := _data_in[15];
            _word.%B1 := _data_in[14];
            Inputs.ToolResult_14.Data_2             :=  TO_UINT(_word);        // IW346
            _word.%B0 := _data_in[17];
            _word.%B1 := _data_in[16];
            Inputs.ToolResult_14.Data_3             :=  TO_UINT(_word);        // IW348
                                                                                    // IW350
            //***************************************************************

            //*************************ToolResult_15*************************
            _retVal := Siemens.Simatic.DistributedIO.ReadData((Config.HWIDs.HwID_ToolResult_15) ,_data_in);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1620, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1620;
                RETURN;
            END_IF;

            _word.%B0 := _data_in[1];
            _word.%B1 := _data_in[0];
            Inputs.ToolResult_15.MatchingRate       :=  TO_UINT(_word);        // IW352
            _word.%B0 := _data_in[3];
            _word.%B1 := _data_in[2];
            Inputs.ToolResult_15.MatchingRateMAX    :=  TO_UINT(_word);        // IW354
            _word.%B0 := _data_in[5];
            _word.%B1 := _data_in[4];
            Inputs.ToolResult_15.MatchingRateMIN    :=  TO_UINT(_word);        // IW356
            _word.%B0 := _data_in[7];
            _word.%B1 := _data_in[6];
            Inputs.ToolResult_15.LowerThreshold     :=  TO_UINT(_word);        // IW358
            _word.%B0 := _data_in[9];
            _word.%B1 := _data_in[8];
            Inputs.ToolResult_15.UpperThreshold     :=  TO_UINT(_word);        // IW360
            _word.%B0 := _data_in[11];
            _word.%B1 := _data_in[10];
            Inputs.ToolResult_15.DecimalPointPosition:=  TO_UINT(_word);       // IW362
            _word.%B0 := _data_in[13];
            _word.%B1 := _data_in[12];
            Inputs.ToolResult_15.Data_1             :=  TO_UINT(_word);        // IW364
            _word.%B0 := _data_in[15];
            _word.%B1 := _data_in[14];
            Inputs.ToolResult_15.Data_2             :=  TO_UINT(_word);        // IW366
            _word.%B0 := _data_in[17];
            _word.%B1 := _data_in[16];
            Inputs.ToolResult_15.Data_3             :=  TO_UINT(_word);        // IW368
                                                                                    // IW370
            //***************************************************************

            //*************************ToolResult_16*************************
            _retVal := Siemens.Simatic.DistributedIO.ReadData((Config.HWIDs.HwID_ToolResult_16) ,_data_in);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1621, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1621;
                RETURN;
            END_IF;

            _word.%B0 := _data_in[1];
            _word.%B1 := _data_in[0];
            Inputs.ToolResult_16.MatchingRate       :=  TO_UINT(_word);        // IW372
            _word.%B0 := _data_in[3];
            _word.%B1 := _data_in[2];
            Inputs.ToolResult_16.MatchingRateMAX    :=  TO_UINT(_word);        // IW374
            _word.%B0 := _data_in[5];
            _word.%B1 := _data_in[4];
            Inputs.ToolResult_16.MatchingRateMIN    :=  TO_UINT(_word);        // IW376
            _word.%B0 := _data_in[7];
            _word.%B1 := _data_in[6];
            Inputs.ToolResult_16.LowerThreshold     :=  TO_UINT(_word);        // IW378
            _word.%B0 := _data_in[9];
            _word.%B1 := _data_in[8];
            Inputs.ToolResult_16.UpperThreshold     :=  TO_UINT(_word);        // IW380
            _word.%B0 := _data_in[11];
            _word.%B1 := _data_in[10];
            Inputs.ToolResult_16.DecimalPointPosition:=  TO_UINT(_word);       // IW382
            _word.%B0 := _data_in[13];
            _word.%B1 := _data_in[12];
            Inputs.ToolResult_16.Data_1             :=  TO_UINT(_word);        // IW384
            _word.%B0 := _data_in[15];
            _word.%B1 := _data_in[14];
            Inputs.ToolResult_16.Data_2             :=  TO_UINT(_word);        // IW386
            _word.%B0 := _data_in[17];
            _word.%B1 := _data_in[16];
            Inputs.ToolResult_16.Data_3             :=  TO_UINT(_word);        // IW388
                                                                                    // IW390
            //***************************************************************

            //*************************ToolResult_17*************************
            _retVal := Siemens.Simatic.DistributedIO.ReadData((Config.HWIDs.HwID_ToolResult_17) ,_data_in);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1622, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1622;
                RETURN;
            END_IF;

            _word.%B0 := _data_in[1];
            _word.%B1 := _data_in[0];
            Inputs.ToolResult_17.MatchingRate       :=  TO_UINT(_word);        // IW392
            _word.%B0 := _data_in[3];
            _word.%B1 := _data_in[2];
            Inputs.ToolResult_17.MatchingRateMAX    :=  TO_UINT(_word);        // IW394
            _word.%B0 := _data_in[5];
            _word.%B1 := _data_in[4];
            Inputs.ToolResult_17.MatchingRateMIN    :=  TO_UINT(_word);        // IW396
            _word.%B0 := _data_in[7];
            _word.%B1 := _data_in[6];
            Inputs.ToolResult_17.LowerThreshold     :=  TO_UINT(_word);        // IW398
            _word.%B0 := _data_in[9];
            _word.%B1 := _data_in[8];
            Inputs.ToolResult_17.UpperThreshold     :=  TO_UINT(_word);        // IW400
            _word.%B0 := _data_in[11];
            _word.%B1 := _data_in[10];
            Inputs.ToolResult_17.DecimalPointPosition:=  TO_UINT(_word);       // IW402
            _word.%B0 := _data_in[13];
            _word.%B1 := _data_in[12];
            Inputs.ToolResult_17.Data_1             :=  TO_UINT(_word);        // IW404
            _word.%B0 := _data_in[15];
            _word.%B1 := _data_in[14];
            Inputs.ToolResult_17.Data_2             :=  TO_UINT(_word);        // IW406
            _word.%B0 := _data_in[17];
            _word.%B1 := _data_in[16];
            Inputs.ToolResult_17.Data_3             :=  TO_UINT(_word);        // IW408
                                                                                    // IW410
            //***************************************************************

            //*************************ToolResult_18*************************
            _retVal := Siemens.Simatic.DistributedIO.ReadData((Config.HWIDs.HwID_ToolResult_18) ,_data_in);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1623, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1623;
                RETURN;
            END_IF;

            _word.%B0 := _data_in[1];
            _word.%B1 := _data_in[0];
            Inputs.ToolResult_18.MatchingRate       :=  TO_UINT(_word);        // IW412
            _word.%B0 := _data_in[3];
            _word.%B1 := _data_in[2];
            Inputs.ToolResult_18.MatchingRateMAX    :=  TO_UINT(_word);        // IW414
            _word.%B0 := _data_in[5];
            _word.%B1 := _data_in[4];
            Inputs.ToolResult_18.MatchingRateMIN    :=  TO_UINT(_word);        // IW416
            _word.%B0 := _data_in[7];
            _word.%B1 := _data_in[6];
            Inputs.ToolResult_18.LowerThreshold     :=  TO_UINT(_word);        // IW418
            _word.%B0 := _data_in[9];
            _word.%B1 := _data_in[8];
            Inputs.ToolResult_18.UpperThreshold     :=  TO_UINT(_word);        // IW420
            _word.%B0 := _data_in[11];
            _word.%B1 := _data_in[10];
            Inputs.ToolResult_18.DecimalPointPosition:=  TO_UINT(_word);       // IW422
            _word.%B0 := _data_in[13];
            _word.%B1 := _data_in[12];
            Inputs.ToolResult_18.Data_1             :=  TO_UINT(_word);        // IW424
            _word.%B0 := _data_in[15];
            _word.%B1 := _data_in[14];
            Inputs.ToolResult_18.Data_2             :=  TO_UINT(_word);        // IW426
            _word.%B0 := _data_in[17];
            _word.%B1 := _data_in[16];
            Inputs.ToolResult_18.Data_3             :=  TO_UINT(_word);        // IW428
                                                                                    // IW430
            //***************************************************************

            //*************************ToolResult_19*************************
            _retVal := Siemens.Simatic.DistributedIO.ReadData((Config.HWIDs.HwID_ToolResult_19) ,_data_in);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1624, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1624;
                RETURN;
            END_IF;

            _word.%B0 := _data_in[1];
            _word.%B1 := _data_in[0];
            Inputs.ToolResult_19.MatchingRate       :=  TO_UINT(_word);        // IW432
            _word.%B0 := _data_in[3];
            _word.%B1 := _data_in[2];
            Inputs.ToolResult_19.MatchingRateMAX    :=  TO_UINT(_word);        // IW434
            _word.%B0 := _data_in[5];
            _word.%B1 := _data_in[4];
            Inputs.ToolResult_19.MatchingRateMIN    :=  TO_UINT(_word);        // IW436
            _word.%B0 := _data_in[7];
            _word.%B1 := _data_in[6];
            Inputs.ToolResult_19.LowerThreshold     :=  TO_UINT(_word);        // IW438
            _word.%B0 := _data_in[9];
            _word.%B1 := _data_in[8];
            Inputs.ToolResult_19.UpperThreshold     :=  TO_UINT(_word);        // IW440
            _word.%B0 := _data_in[11];
            _word.%B1 := _data_in[10];
            Inputs.ToolResult_19.DecimalPointPosition:=  TO_UINT(_word);       // IW442
            _word.%B0 := _data_in[13];
            _word.%B1 := _data_in[12];
            Inputs.ToolResult_19.Data_1             :=  TO_UINT(_word);        // IW444
            _word.%B0 := _data_in[15];
            _word.%B1 := _data_in[14];
            Inputs.ToolResult_19.Data_2             :=  TO_UINT(_word);        // IW446
            _word.%B0 := _data_in[17];
            _word.%B1 := _data_in[16];
            Inputs.ToolResult_19.Data_3             :=  TO_UINT(_word);        // IW448
                                                                                    // IW450
            //***************************************************************

            //*************************ToolResult_20*************************
            _retVal := Siemens.Simatic.DistributedIO.ReadData((Config.HWIDs.HwID_ToolResult_20) ,_data_in);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1625, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1625;
                RETURN;
            END_IF;

            _word.%B0 := _data_in[1];
            _word.%B1 := _data_in[0];
            Inputs.ToolResult_20.MatchingRate       :=  TO_UINT(_word);        // IW452
            _word.%B0 := _data_in[3];
            _word.%B1 := _data_in[2];
            Inputs.ToolResult_20.MatchingRateMAX    :=  TO_UINT(_word);        // IW454
            _word.%B0 := _data_in[5];
            _word.%B1 := _data_in[4];
            Inputs.ToolResult_20.MatchingRateMIN    :=  TO_UINT(_word);        // IW456
            _word.%B0 := _data_in[7];
            _word.%B1 := _data_in[6];
            Inputs.ToolResult_20.LowerThreshold     :=  TO_UINT(_word);        // IW458
            _word.%B0 := _data_in[9];
            _word.%B1 := _data_in[8];
            Inputs.ToolResult_20.UpperThreshold     :=  TO_UINT(_word);        // IW460
            _word.%B0 := _data_in[11];
            _word.%B1 := _data_in[10];
            Inputs.ToolResult_20.DecimalPointPosition:=  TO_UINT(_word);       // IW462
            _word.%B0 := _data_in[13];
            _word.%B1 := _data_in[12];
            Inputs.ToolResult_20.Data_1             :=  TO_UINT(_word);        // IW464
            _word.%B0 := _data_in[15];
            _word.%B1 := _data_in[14];
            Inputs.ToolResult_20.Data_2             :=  TO_UINT(_word);        // IW466
            _word.%B0 := _data_in[17];
            _word.%B1 := _data_in[16];
            Inputs.ToolResult_20.Data_3             :=  TO_UINT(_word);        // IW468
                                                                                    // IW470
            //***************************************************************

            //*************************ToolResult_21*************************
            _retVal := Siemens.Simatic.DistributedIO.ReadData((Config.HWIDs.HwID_ToolResult_21) ,_data_in);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1626, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1626;
                RETURN;
            END_IF;

            _word.%B0 := _data_in[1];
            _word.%B1 := _data_in[0];
            Inputs.ToolResult_21.MatchingRate       :=  TO_UINT(_word);        // IW472
            _word.%B0 := _data_in[3];
            _word.%B1 := _data_in[2];
            Inputs.ToolResult_21.MatchingRateMAX    :=  TO_UINT(_word);        // IW474
            _word.%B0 := _data_in[5];
            _word.%B1 := _data_in[4];
            Inputs.ToolResult_21.MatchingRateMIN    :=  TO_UINT(_word);        // IW476
            _word.%B0 := _data_in[7];
            _word.%B1 := _data_in[6];
            Inputs.ToolResult_21.LowerThreshold     :=  TO_UINT(_word);        // IW478
            _word.%B0 := _data_in[9];
            _word.%B1 := _data_in[8];
            Inputs.ToolResult_21.UpperThreshold     :=  TO_UINT(_word);        // IW480
            _word.%B0 := _data_in[11];
            _word.%B1 := _data_in[10];
            Inputs.ToolResult_21.DecimalPointPosition:=  TO_UINT(_word);       // IW482
            _word.%B0 := _data_in[13];
            _word.%B1 := _data_in[12];
            Inputs.ToolResult_21.Data_1             :=  TO_UINT(_word);        // IW484
            _word.%B0 := _data_in[15];
            _word.%B1 := _data_in[14];
            Inputs.ToolResult_21.Data_2             :=  TO_UINT(_word);        // IW486
            _word.%B0 := _data_in[17];
            _word.%B1 := _data_in[16];
            Inputs.ToolResult_21.Data_3             :=  TO_UINT(_word);        // IW488
                                                                                    // IW490
            //***************************************************************

            //*************************ToolResult_22*************************
            _retVal := Siemens.Simatic.DistributedIO.ReadData((Config.HWIDs.HwID_ToolResult_22) ,_data_in);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1627, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1627;
                RETURN;
            END_IF;

            _word.%B0 := _data_in[1];
            _word.%B1 := _data_in[0];
            Inputs.ToolResult_22.MatchingRate       :=  TO_UINT(_word);        // IW492
            _word.%B0 := _data_in[3];
            _word.%B1 := _data_in[2];
            Inputs.ToolResult_22.MatchingRateMAX    :=  TO_UINT(_word);        // IW494
            _word.%B0 := _data_in[5];
            _word.%B1 := _data_in[4];
            Inputs.ToolResult_22.MatchingRateMIN    :=  TO_UINT(_word);        // IW496
            _word.%B0 := _data_in[7];
            _word.%B1 := _data_in[6];
            Inputs.ToolResult_22.LowerThreshold     :=  TO_UINT(_word);        // IW498
            _word.%B0 := _data_in[9];
            _word.%B1 := _data_in[8];
            Inputs.ToolResult_22.UpperThreshold     :=  TO_UINT(_word);        // IW500
            _word.%B0 := _data_in[11];
            _word.%B1 := _data_in[10];
            Inputs.ToolResult_22.DecimalPointPosition:=  TO_UINT(_word);       // IW502
            _word.%B0 := _data_in[13];
            _word.%B1 := _data_in[12];
            Inputs.ToolResult_22.Data_1             :=  TO_UINT(_word);        // IW504
            _word.%B0 := _data_in[15];
            _word.%B1 := _data_in[14];
            Inputs.ToolResult_22.Data_2             :=  TO_UINT(_word);        // IW506
            _word.%B0 := _data_in[17];
            _word.%B1 := _data_in[16];
            Inputs.ToolResult_22.Data_3             :=  TO_UINT(_word);        // IW508
                                                                                    // IW510
            //***************************************************************

            //*************************ToolResult_23*************************
            _retVal := Siemens.Simatic.DistributedIO.ReadData((Config.HWIDs.HwID_ToolResult_23) ,_data_in);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1628, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1628;
                RETURN;
            END_IF;

            _word.%B0 := _data_in[1];
            _word.%B1 := _data_in[0];
            Inputs.ToolResult_23.MatchingRate       :=  TO_UINT(_word);        // IW512
            _word.%B0 := _data_in[3];
            _word.%B1 := _data_in[2];
            Inputs.ToolResult_23.MatchingRateMAX    :=  TO_UINT(_word);        // IW514
            _word.%B0 := _data_in[5];
            _word.%B1 := _data_in[4];
            Inputs.ToolResult_23.MatchingRateMIN    :=  TO_UINT(_word);        // IW516
            _word.%B0 := _data_in[7];
            _word.%B1 := _data_in[6];
            Inputs.ToolResult_23.LowerThreshold     :=  TO_UINT(_word);        // IW518
            _word.%B0 := _data_in[9];
            _word.%B1 := _data_in[8];
            Inputs.ToolResult_23.UpperThreshold     :=  TO_UINT(_word);        // IW520
            _word.%B0 := _data_in[11];
            _word.%B1 := _data_in[10];
            Inputs.ToolResult_23.DecimalPointPosition:=  TO_UINT(_word);       // IW522
            _word.%B0 := _data_in[13];
            _word.%B1 := _data_in[12];
            Inputs.ToolResult_23.Data_1             :=  TO_UINT(_word);        // IW524
            _word.%B0 := _data_in[15];
            _word.%B1 := _data_in[14];
            Inputs.ToolResult_23.Data_2             :=  TO_UINT(_word);        // IW526
            _word.%B0 := _data_in[17];
            _word.%B1 := _data_in[16];
            Inputs.ToolResult_23.Data_3             :=  TO_UINT(_word);        // IW528
                                                                                    // IW530
            //***************************************************************

            //*************************ToolResult_24*************************
            _retVal := Siemens.Simatic.DistributedIO.ReadData((Config.HWIDs.HwID_ToolResult_24) ,_data_in);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1629, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1629;
                RETURN;
            END_IF;

            _word.%B0 := _data_in[1];
            _word.%B1 := _data_in[0];
            Inputs.ToolResult_24.MatchingRate       :=  TO_UINT(_word);        // IW532
            _word.%B0 := _data_in[3];
            _word.%B1 := _data_in[2];
            Inputs.ToolResult_24.MatchingRateMAX    :=  TO_UINT(_word);        // IW534
            _word.%B0 := _data_in[5];
            _word.%B1 := _data_in[4];
            Inputs.ToolResult_24.MatchingRateMIN    :=  TO_UINT(_word);        // IW536
            _word.%B0 := _data_in[7];
            _word.%B1 := _data_in[6];
            Inputs.ToolResult_24.LowerThreshold     :=  TO_UINT(_word);        // IW538
            _word.%B0 := _data_in[9];
            _word.%B1 := _data_in[8];
            Inputs.ToolResult_24.UpperThreshold     :=  TO_UINT(_word);        // IW540
            _word.%B0 := _data_in[11];
            _word.%B1 := _data_in[10];
            Inputs.ToolResult_24.DecimalPointPosition:=  TO_UINT(_word);       // IW542
            _word.%B0 := _data_in[13];
            _word.%B1 := _data_in[12];
            Inputs.ToolResult_24.Data_1             :=  TO_UINT(_word);        // IW544
            _word.%B0 := _data_in[15];
            _word.%B1 := _data_in[14];
            Inputs.ToolResult_24.Data_2             :=  TO_UINT(_word);        // IW546
            _word.%B0 := _data_in[17];
            _word.%B1 := _data_in[16];
            Inputs.ToolResult_24.Data_3             :=  TO_UINT(_word);        // IW548
                                                                                    // IW550
            //***************************************************************

            //*************************ToolResult_25*************************
            _retVal := Siemens.Simatic.DistributedIO.ReadData((Config.HWIDs.HwID_ToolResult_25) ,_data_in);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1630, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1630;
                RETURN;
            END_IF;

            _word.%B0 := _data_in[1];
            _word.%B1 := _data_in[0];
            Inputs.ToolResult_25.MatchingRate       :=  TO_UINT(_word);        // IW552
            _word.%B0 := _data_in[3];
            _word.%B1 := _data_in[2];
            Inputs.ToolResult_25.MatchingRateMAX    :=  TO_UINT(_word);        // IW554
            _word.%B0 := _data_in[5];
            _word.%B1 := _data_in[4];
            Inputs.ToolResult_25.MatchingRateMIN    :=  TO_UINT(_word);        // IW556
            _word.%B0 := _data_in[7];
            _word.%B1 := _data_in[6];
            Inputs.ToolResult_25.LowerThreshold     :=  TO_UINT(_word);        // IW558
            _word.%B0 := _data_in[9];
            _word.%B1 := _data_in[8];
            Inputs.ToolResult_25.UpperThreshold     :=  TO_UINT(_word);        // IW560
            _word.%B0 := _data_in[11];
            _word.%B1 := _data_in[10];
            Inputs.ToolResult_25.DecimalPointPosition:=  TO_UINT(_word);       // IW562
            _word.%B0 := _data_in[13];
            _word.%B1 := _data_in[12];
            Inputs.ToolResult_25.Data_1             :=  TO_UINT(_word);        // IW564
            _word.%B0 := _data_in[15];
            _word.%B1 := _data_in[14];
            Inputs.ToolResult_25.Data_2             :=  TO_UINT(_word);        // IW566
            _word.%B0 := _data_in[17];
            _word.%B1 := _data_in[16];
            Inputs.ToolResult_25.Data_3             :=  TO_UINT(_word);        // IW568
                                                                                    // IW570
            //***************************************************************

            //*************************ToolResult_26*************************
            _retVal := Siemens.Simatic.DistributedIO.ReadData((Config.HWIDs.HwID_ToolResult_26) ,_data_in);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1631, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1631;
                RETURN;
            END_IF;

            _word.%B0 := _data_in[1];
            _word.%B1 := _data_in[0];
            Inputs.ToolResult_26.MatchingRate       :=  TO_UINT(_word);        // IW572
            _word.%B0 := _data_in[3];
            _word.%B1 := _data_in[2];
            Inputs.ToolResult_26.MatchingRateMAX    :=  TO_UINT(_word);        // IW574
            _word.%B0 := _data_in[5];
            _word.%B1 := _data_in[4];
            Inputs.ToolResult_26.MatchingRateMIN    :=  TO_UINT(_word);        // IW576
            _word.%B0 := _data_in[7];
            _word.%B1 := _data_in[6];
            Inputs.ToolResult_26.LowerThreshold     :=  TO_UINT(_word);        // IW578
            _word.%B0 := _data_in[9];
            _word.%B1 := _data_in[8];
            Inputs.ToolResult_26.UpperThreshold     :=  TO_UINT(_word);        // IW580
            _word.%B0 := _data_in[11];
            _word.%B1 := _data_in[10];
            Inputs.ToolResult_26.DecimalPointPosition:=  TO_UINT(_word);       // IW582
            _word.%B0 := _data_in[13];
            _word.%B1 := _data_in[12];
            Inputs.ToolResult_26.Data_1             :=  TO_UINT(_word);        // IW584
            _word.%B0 := _data_in[15];
            _word.%B1 := _data_in[14];
            Inputs.ToolResult_26.Data_2             :=  TO_UINT(_word);        // IW586
            _word.%B0 := _data_in[17];
            _word.%B1 := _data_in[16];
            Inputs.ToolResult_26.Data_3             :=  TO_UINT(_word);        // IW588
                                                                                    // IW590
            //***************************************************************

            //*************************ToolResult_27*************************
            _retVal := Siemens.Simatic.DistributedIO.ReadData((Config.HWIDs.HwID_ToolResult_27) ,_data_in);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1632, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1632;
                RETURN;
            END_IF;

            _word.%B0 := _data_in[1];
            _word.%B1 := _data_in[0];
            Inputs.ToolResult_27.MatchingRate       :=  TO_UINT(_word);        // IW592
            _word.%B0 := _data_in[3];
            _word.%B1 := _data_in[2];
            Inputs.ToolResult_27.MatchingRateMAX    :=  TO_UINT(_word);        // IW594
            _word.%B0 := _data_in[5];
            _word.%B1 := _data_in[4];
            Inputs.ToolResult_27.MatchingRateMIN    :=  TO_UINT(_word);        // IW596
            _word.%B0 := _data_in[7];
            _word.%B1 := _data_in[6];
            Inputs.ToolResult_27.LowerThreshold     :=  TO_UINT(_word);        // IW598
            _word.%B0 := _data_in[9];
            _word.%B1 := _data_in[8];
            Inputs.ToolResult_27.UpperThreshold     :=  TO_UINT(_word);        // IW600
            _word.%B0 := _data_in[11];
            _word.%B1 := _data_in[10];
            Inputs.ToolResult_27.DecimalPointPosition:=  TO_UINT(_word);       // IW602
            _word.%B0 := _data_in[13];
            _word.%B1 := _data_in[12];
            Inputs.ToolResult_27.Data_1             :=  TO_UINT(_word);        // IW604
            _word.%B0 := _data_in[15];
            _word.%B1 := _data_in[14];
            Inputs.ToolResult_27.Data_2             :=  TO_UINT(_word);        // IW606
            _word.%B0 := _data_in[17];
            _word.%B1 := _data_in[16];
            Inputs.ToolResult_27.Data_3             :=  TO_UINT(_word);        // IW608
                                                                                    // IW610
            //***************************************************************

            //*************************ToolResult_28*************************
            _retVal := Siemens.Simatic.DistributedIO.ReadData((Config.HWIDs.HwID_ToolResult_28) ,_data_in);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1633, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1633;
                RETURN;
            END_IF;

            _word.%B0 := _data_in[1];
            _word.%B1 := _data_in[0];
            Inputs.ToolResult_28.MatchingRate       :=  TO_UINT(_word);        // IW612
            _word.%B0 := _data_in[3];
            _word.%B1 := _data_in[2];
            Inputs.ToolResult_28.MatchingRateMAX    :=  TO_UINT(_word);        // IW614
            _word.%B0 := _data_in[5];
            _word.%B1 := _data_in[4];
            Inputs.ToolResult_28.MatchingRateMIN    :=  TO_UINT(_word);        // IW616
            _word.%B0 := _data_in[7];
            _word.%B1 := _data_in[6];
            Inputs.ToolResult_28.LowerThreshold     :=  TO_UINT(_word);        // IW618
            _word.%B0 := _data_in[9];
            _word.%B1 := _data_in[8];
            Inputs.ToolResult_28.UpperThreshold     :=  TO_UINT(_word);        // IW620
            _word.%B0 := _data_in[11];
            _word.%B1 := _data_in[10];
            Inputs.ToolResult_28.DecimalPointPosition:=  TO_UINT(_word);       // IW622
            _word.%B0 := _data_in[13];
            _word.%B1 := _data_in[12];
            Inputs.ToolResult_28.Data_1             :=  TO_UINT(_word);        // IW624
            _word.%B0 := _data_in[15];
            _word.%B1 := _data_in[14];
            Inputs.ToolResult_28.Data_2             :=  TO_UINT(_word);        // IW626
            _word.%B0 := _data_in[17];
            _word.%B1 := _data_in[16];
            Inputs.ToolResult_28.Data_3             :=  TO_UINT(_word);        // IW628
                                                                                    // IW630
            //***************************************************************

            //*************************ToolResult_29*************************
            _retVal := Siemens.Simatic.DistributedIO.ReadData((Config.HWIDs.HwID_ToolResult_29) ,_data_in);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1634, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1634;
                RETURN;
            END_IF;

            _word.%B0 := _data_in[1];
            _word.%B1 := _data_in[0];
            Inputs.ToolResult_29.MatchingRate       :=  TO_UINT(_word);        // IW632
            _word.%B0 := _data_in[3];
            _word.%B1 := _data_in[2];
            Inputs.ToolResult_29.MatchingRateMAX    :=  TO_UINT(_word);        // IW634
            _word.%B0 := _data_in[5];
            _word.%B1 := _data_in[4];
            Inputs.ToolResult_29.MatchingRateMIN    :=  TO_UINT(_word);        // IW636
            _word.%B0 := _data_in[7];
            _word.%B1 := _data_in[6];
            Inputs.ToolResult_29.LowerThreshold     :=  TO_UINT(_word);        // IW638
            _word.%B0 := _data_in[9];
            _word.%B1 := _data_in[8];
            Inputs.ToolResult_29.UpperThreshold     :=  TO_UINT(_word);        // IW640
            _word.%B0 := _data_in[11];
            _word.%B1 := _data_in[10];
            Inputs.ToolResult_29.DecimalPointPosition:=  TO_UINT(_word);       // IW642
            _word.%B0 := _data_in[13];
            _word.%B1 := _data_in[12];
            Inputs.ToolResult_29.Data_1             :=  TO_UINT(_word);        // IW644
            _word.%B0 := _data_in[15];
            _word.%B1 := _data_in[14];
            Inputs.ToolResult_29.Data_2             :=  TO_UINT(_word);        // IW646
            _word.%B0 := _data_in[17];
            _word.%B1 := _data_in[16];
            Inputs.ToolResult_29.Data_3             :=  TO_UINT(_word);        // IW648
                                                                                    // IW650
            //***************************************************************

            //*************************ToolResult_30*************************
            _retVal := Siemens.Simatic.DistributedIO.ReadData((Config.HWIDs.HwID_ToolResult_30) ,_data_in);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1635, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1635;
                RETURN;
            END_IF;

            _word.%B0 := _data_in[1];
            _word.%B1 := _data_in[0];
            Inputs.ToolResult_30.MatchingRate       :=  TO_UINT(_word);        // IW652
            _word.%B0 := _data_in[3];
            _word.%B1 := _data_in[2];
            Inputs.ToolResult_30.MatchingRateMAX    :=  TO_UINT(_word);        // IW654
            _word.%B0 := _data_in[5];
            _word.%B1 := _data_in[4];
            Inputs.ToolResult_30.MatchingRateMIN    :=  TO_UINT(_word);        // IW656
            _word.%B0 := _data_in[7];
            _word.%B1 := _data_in[6];
            Inputs.ToolResult_30.LowerThreshold     :=  TO_UINT(_word);        // IW658
            _word.%B0 := _data_in[9];
            _word.%B1 := _data_in[8];
            Inputs.ToolResult_30.UpperThreshold     :=  TO_UINT(_word);        // IW660
            _word.%B0 := _data_in[11];
            _word.%B1 := _data_in[10];
            Inputs.ToolResult_30.DecimalPointPosition:=  TO_UINT(_word);       // IW662
            _word.%B0 := _data_in[13];
            _word.%B1 := _data_in[12];
            Inputs.ToolResult_30.Data_1             :=  TO_UINT(_word);        // IW664
            _word.%B0 := _data_in[15];
            _word.%B1 := _data_in[14];
            Inputs.ToolResult_30.Data_2             :=  TO_UINT(_word);        // IW666
            _word.%B0 := _data_in[17];
            _word.%B1 := _data_in[16];
            Inputs.ToolResult_30.Data_3             :=  TO_UINT(_word);        // IW668
                                                                                    // IW670
            //***************************************************************

            //*************************ToolResult_31*************************
            _retVal := Siemens.Simatic.DistributedIO.ReadData((Config.HWIDs.HwID_ToolResult_31) ,_data_in);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1636, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1636;
                RETURN;
            END_IF;

            _word.%B0 := _data_in[1];
            _word.%B1 := _data_in[0];
            Inputs.ToolResult_31.MatchingRate       :=  TO_UINT(_word);        // IW672
            _word.%B0 := _data_in[3];
            _word.%B1 := _data_in[2];
            Inputs.ToolResult_31.MatchingRateMAX    :=  TO_UINT(_word);        // IW674
            _word.%B0 := _data_in[5];
            _word.%B1 := _data_in[4];
            Inputs.ToolResult_31.MatchingRateMIN    :=  TO_UINT(_word);        // IW676
            _word.%B0 := _data_in[7];
            _word.%B1 := _data_in[6];
            Inputs.ToolResult_31.LowerThreshold     :=  TO_UINT(_word);        // IW678
            _word.%B0 := _data_in[9];
            _word.%B1 := _data_in[8];
            Inputs.ToolResult_31.UpperThreshold     :=  TO_UINT(_word);        // IW680
            _word.%B0 := _data_in[11];
            _word.%B1 := _data_in[10];
            Inputs.ToolResult_31.DecimalPointPosition:=  TO_UINT(_word);       // IW682
            _word.%B0 := _data_in[13];
            _word.%B1 := _data_in[12];
            Inputs.ToolResult_31.Data_1             :=  TO_UINT(_word);        // IW684
            _word.%B0 := _data_in[15];
            _word.%B1 := _data_in[14];
            Inputs.ToolResult_31.Data_2             :=  TO_UINT(_word);        // IW686
            _word.%B0 := _data_in[17];
            _word.%B1 := _data_in[16];
            Inputs.ToolResult_31.Data_3             :=  TO_UINT(_word);        // IW688
                                                                                    // IW690
            //***************************************************************

            //*************************ToolResult_32*************************
            _retVal := Siemens.Simatic.DistributedIO.ReadData((Config.HWIDs.HwID_ToolResult_32) ,_data_in);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1637, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1637;
                RETURN;
            END_IF;

            _word.%B0 := _data_in[1];
            _word.%B1 := _data_in[0];
            Inputs.ToolResult_32.MatchingRate       :=  TO_UINT(_word);        // IW692
            _word.%B0 := _data_in[3];
            _word.%B1 := _data_in[2];
            Inputs.ToolResult_32.MatchingRateMAX    :=  TO_UINT(_word);        // IW694
            _word.%B0 := _data_in[5];
            _word.%B1 := _data_in[4];
            Inputs.ToolResult_32.MatchingRateMIN    :=  TO_UINT(_word);        // IW696
            _word.%B0 := _data_in[7];
            _word.%B1 := _data_in[6];
            Inputs.ToolResult_32.LowerThreshold     :=  TO_UINT(_word);        // IW698
            _word.%B0 := _data_in[9];
            _word.%B1 := _data_in[8];
            Inputs.ToolResult_32.UpperThreshold     :=  TO_UINT(_word);        // IW700
            _word.%B0 := _data_in[11];
            _word.%B1 := _data_in[10];
            Inputs.ToolResult_32.DecimalPointPosition:=  TO_UINT(_word);       // IW702
            _word.%B0 := _data_in[13];
            _word.%B1 := _data_in[12];
            Inputs.ToolResult_32.Data_1             :=  TO_UINT(_word);        // IW704
            _word.%B0 := _data_in[15];
            _word.%B1 := _data_in[14];
            Inputs.ToolResult_32.Data_2             :=  TO_UINT(_word);        // IW706
            _word.%B0 := _data_in[17];
            _word.%B1 := _data_in[16];
            Inputs.ToolResult_32.Data_3             :=  TO_UINT(_word);        // IW708
                                                                                    // IW710
            //***************************************************************

            //*************************ToolResult_33*************************
            _retVal := Siemens.Simatic.DistributedIO.ReadData((Config.HWIDs.HwID_ToolResult_33) ,_data_in);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1638, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1638;
                RETURN;
            END_IF;

            _word.%B0 := _data_in[1];
            _word.%B1 := _data_in[0];
            Inputs.ToolResult_33.MatchingRate       :=  TO_UINT(_word);        // IW712
            _word.%B0 := _data_in[3];
            _word.%B1 := _data_in[2];
            Inputs.ToolResult_33.MatchingRateMAX    :=  TO_UINT(_word);        // IW714
            _word.%B0 := _data_in[5];
            _word.%B1 := _data_in[4];
            Inputs.ToolResult_33.MatchingRateMIN    :=  TO_UINT(_word);        // IW716
            _word.%B0 := _data_in[7];
            _word.%B1 := _data_in[6];
            Inputs.ToolResult_33.LowerThreshold     :=  TO_UINT(_word);        // IW718
            _word.%B0 := _data_in[9];
            _word.%B1 := _data_in[8];
            Inputs.ToolResult_33.UpperThreshold     :=  TO_UINT(_word);        // IW720
            _word.%B0 := _data_in[11];
            _word.%B1 := _data_in[10];
            Inputs.ToolResult_33.DecimalPointPosition:=  TO_UINT(_word);       // IW722
            _word.%B0 := _data_in[13];
            _word.%B1 := _data_in[12];
            Inputs.ToolResult_33.Data_1             :=  TO_UINT(_word);        // IW724
            _word.%B0 := _data_in[15];
            _word.%B1 := _data_in[14];
            Inputs.ToolResult_33.Data_2             :=  TO_UINT(_word);        // IW726
            _word.%B0 := _data_in[17];
            _word.%B1 := _data_in[16];
            Inputs.ToolResult_33.Data_3             :=  TO_UINT(_word);        // IW728
                                                                                    // IW730
            //***************************************************************

            //*************************ToolResult_34*************************
            _retVal := Siemens.Simatic.DistributedIO.ReadData((Config.HWIDs.HwID_ToolResult_34) ,_data_in);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1639, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1639;
                RETURN;
            END_IF;

            _word.%B0 := _data_in[1];
            _word.%B1 := _data_in[0];
            Inputs.ToolResult_34.MatchingRate       :=  TO_UINT(_word);        // IW732
            _word.%B0 := _data_in[3];
            _word.%B1 := _data_in[2];
            Inputs.ToolResult_34.MatchingRateMAX    :=  TO_UINT(_word);        // IW734
            _word.%B0 := _data_in[5];
            _word.%B1 := _data_in[4];
            Inputs.ToolResult_34.MatchingRateMIN    :=  TO_UINT(_word);        // IW736
            _word.%B0 := _data_in[7];
            _word.%B1 := _data_in[6];
            Inputs.ToolResult_34.LowerThreshold     :=  TO_UINT(_word);        // IW738
            _word.%B0 := _data_in[9];
            _word.%B1 := _data_in[8];
            Inputs.ToolResult_34.UpperThreshold     :=  TO_UINT(_word);        // IW740
            _word.%B0 := _data_in[11];
            _word.%B1 := _data_in[10];
            Inputs.ToolResult_34.DecimalPointPosition:=  TO_UINT(_word);       // IW742
            _word.%B0 := _data_in[13];
            _word.%B1 := _data_in[12];
            Inputs.ToolResult_34.Data_1             :=  TO_UINT(_word);        // IW744
            _word.%B0 := _data_in[15];
            _word.%B1 := _data_in[14];
            Inputs.ToolResult_34.Data_2             :=  TO_UINT(_word);        // IW746
            _word.%B0 := _data_in[17];
            _word.%B1 := _data_in[16];
            Inputs.ToolResult_34.Data_3             :=  TO_UINT(_word);        // IW748
                                                                                    // IW750
            //***************************************************************

            //*************************ToolResult_35*************************
            _retVal := Siemens.Simatic.DistributedIO.ReadData((Config.HWIDs.HwID_ToolResult_35) ,_data_in);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1640, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1640;
                RETURN;
            END_IF;

            _word.%B0 := _data_in[1];
            _word.%B1 := _data_in[0];
            Inputs.ToolResult_35.MatchingRate       :=  TO_UINT(_word);        // IW752
            _word.%B0 := _data_in[3];
            _word.%B1 := _data_in[2];
            Inputs.ToolResult_35.MatchingRateMAX    :=  TO_UINT(_word);        // IW754
            _word.%B0 := _data_in[5];
            _word.%B1 := _data_in[4];
            Inputs.ToolResult_35.MatchingRateMIN    :=  TO_UINT(_word);        // IW756
            _word.%B0 := _data_in[7];
            _word.%B1 := _data_in[6];
            Inputs.ToolResult_35.LowerThreshold     :=  TO_UINT(_word);        // IW758
            _word.%B0 := _data_in[9];
            _word.%B1 := _data_in[8];
            Inputs.ToolResult_35.UpperThreshold     :=  TO_UINT(_word);        // IW760
            _word.%B0 := _data_in[11];
            _word.%B1 := _data_in[10];
            Inputs.ToolResult_35.DecimalPointPosition:=  TO_UINT(_word);       // IW762
            _word.%B0 := _data_in[13];
            _word.%B1 := _data_in[12];
            Inputs.ToolResult_35.Data_1             :=  TO_UINT(_word);        // IW764
            _word.%B0 := _data_in[15];
            _word.%B1 := _data_in[14];
            Inputs.ToolResult_35.Data_2             :=  TO_UINT(_word);        // IW766
            _word.%B0 := _data_in[17];
            _word.%B1 := _data_in[16];
            Inputs.ToolResult_35.Data_3             :=  TO_UINT(_word);        // IW768
                                                                                    // IW770
            //***************************************************************

            //*************************ToolResult_36*************************
            _retVal := Siemens.Simatic.DistributedIO.ReadData((Config.HWIDs.HwID_ToolResult_36) ,_data_in);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1641, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1641;
                RETURN;
            END_IF;

            _word.%B0 := _data_in[1];
            _word.%B1 := _data_in[0];
            Inputs.ToolResult_36.MatchingRate       :=  TO_UINT(_word);        // IW772
            _word.%B0 := _data_in[3];
            _word.%B1 := _data_in[2];
            Inputs.ToolResult_36.MatchingRateMAX    :=  TO_UINT(_word);        // IW774
            _word.%B0 := _data_in[5];
            _word.%B1 := _data_in[4];
            Inputs.ToolResult_36.MatchingRateMIN    :=  TO_UINT(_word);        // IW776
            _word.%B0 := _data_in[7];
            _word.%B1 := _data_in[6];
            Inputs.ToolResult_36.LowerThreshold     :=  TO_UINT(_word);        // IW778
            _word.%B0 := _data_in[9];
            _word.%B1 := _data_in[8];
            Inputs.ToolResult_36.UpperThreshold     :=  TO_UINT(_word);        // IW780
            _word.%B0 := _data_in[11];
            _word.%B1 := _data_in[10];
            Inputs.ToolResult_36.DecimalPointPosition:=  TO_UINT(_word);       // IW782
            _word.%B0 := _data_in[13];
            _word.%B1 := _data_in[12];
            Inputs.ToolResult_36.Data_1             :=  TO_UINT(_word);        // IW784
            _word.%B0 := _data_in[15];
            _word.%B1 := _data_in[14];
            Inputs.ToolResult_36.Data_2             :=  TO_UINT(_word);        // IW786
            _word.%B0 := _data_in[17];
            _word.%B1 := _data_in[16];
            Inputs.ToolResult_36.Data_3             :=  TO_UINT(_word);        // IW788
                                                                                    // IW790
            //***************************************************************

            //*************************ToolResult_37*************************
            _retVal := Siemens.Simatic.DistributedIO.ReadData((Config.HWIDs.HwID_ToolResult_37) ,_data_in);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1642, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1642;
                RETURN;
            END_IF;

            _word.%B0 := _data_in[1];
            _word.%B1 := _data_in[0];
            Inputs.ToolResult_37.MatchingRate       :=  TO_UINT(_word);        // IW792
            _word.%B0 := _data_in[3];
            _word.%B1 := _data_in[2];
            Inputs.ToolResult_37.MatchingRateMAX    :=  TO_UINT(_word);        // IW794
            _word.%B0 := _data_in[5];
            _word.%B1 := _data_in[4];
            Inputs.ToolResult_37.MatchingRateMIN    :=  TO_UINT(_word);        // IW796
            _word.%B0 := _data_in[7];
            _word.%B1 := _data_in[6];
            Inputs.ToolResult_37.LowerThreshold     :=  TO_UINT(_word);        // IW798
            _word.%B0 := _data_in[9];
            _word.%B1 := _data_in[8];
            Inputs.ToolResult_37.UpperThreshold     :=  TO_UINT(_word);        // IW800
            _word.%B0 := _data_in[11];
            _word.%B1 := _data_in[10];
            Inputs.ToolResult_37.DecimalPointPosition:=  TO_UINT(_word);       // IW802
            _word.%B0 := _data_in[13];
            _word.%B1 := _data_in[12];
            Inputs.ToolResult_37.Data_1             :=  TO_UINT(_word);        // IW804
            _word.%B0 := _data_in[15];
            _word.%B1 := _data_in[14];
            Inputs.ToolResult_37.Data_2             :=  TO_UINT(_word);        // IW806
            _word.%B0 := _data_in[17];
            _word.%B1 := _data_in[16];
            Inputs.ToolResult_37.Data_3             :=  TO_UINT(_word);        // IW808
                                                                                    // IW810
            //***************************************************************

            //*************************ToolResult_38*************************
            _retVal := Siemens.Simatic.DistributedIO.ReadData((Config.HWIDs.HwID_ToolResult_38) ,_data_in);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1643, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1643;
                RETURN;
            END_IF;

            _word.%B0 := _data_in[1];
            _word.%B1 := _data_in[0];
            Inputs.ToolResult_38.MatchingRate       :=  TO_UINT(_word);        // IW812
            _word.%B0 := _data_in[3];
            _word.%B1 := _data_in[2];
            Inputs.ToolResult_38.MatchingRateMAX    :=  TO_UINT(_word);        // IW814
            _word.%B0 := _data_in[5];
            _word.%B1 := _data_in[4];
            Inputs.ToolResult_38.MatchingRateMIN    :=  TO_UINT(_word);        // IW816
            _word.%B0 := _data_in[7];
            _word.%B1 := _data_in[6];
            Inputs.ToolResult_38.LowerThreshold     :=  TO_UINT(_word);        // IW818
            _word.%B0 := _data_in[9];
            _word.%B1 := _data_in[8];
            Inputs.ToolResult_38.UpperThreshold     :=  TO_UINT(_word);        // IW820
            _word.%B0 := _data_in[11];
            _word.%B1 := _data_in[10];
            Inputs.ToolResult_38.DecimalPointPosition:=  TO_UINT(_word);       // IW822
            _word.%B0 := _data_in[13];
            _word.%B1 := _data_in[12];
            Inputs.ToolResult_38.Data_1             :=  TO_UINT(_word);        // IW824
            _word.%B0 := _data_in[15];
            _word.%B1 := _data_in[14];
            Inputs.ToolResult_38.Data_2             :=  TO_UINT(_word);        // IW826
            _word.%B0 := _data_in[17];
            _word.%B1 := _data_in[16];
            Inputs.ToolResult_38.Data_3             :=  TO_UINT(_word);        // IW828
                                                                                    // IW830
            //***************************************************************

            //*************************ToolResult_39*************************
            _retVal := Siemens.Simatic.DistributedIO.ReadData((Config.HWIDs.HwID_ToolResult_39) ,_data_in);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1644, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1644;
                RETURN;
            END_IF;

            _word.%B0 := _data_in[1];
            _word.%B1 := _data_in[0];
            Inputs.ToolResult_39.MatchingRate       :=  TO_UINT(_word);        // IW832
            _word.%B0 := _data_in[3];
            _word.%B1 := _data_in[2];
            Inputs.ToolResult_39.MatchingRateMAX    :=  TO_UINT(_word);        // IW834
            _word.%B0 := _data_in[5];
            _word.%B1 := _data_in[4];
            Inputs.ToolResult_39.MatchingRateMIN    :=  TO_UINT(_word);        // IW836
            _word.%B0 := _data_in[7];
            _word.%B1 := _data_in[6];
            Inputs.ToolResult_39.LowerThreshold     :=  TO_UINT(_word);        // IW838
            _word.%B0 := _data_in[9];
            _word.%B1 := _data_in[8];
            Inputs.ToolResult_39.UpperThreshold     :=  TO_UINT(_word);        // IW840
            _word.%B0 := _data_in[11];
            _word.%B1 := _data_in[10];
            Inputs.ToolResult_39.DecimalPointPosition:=  TO_UINT(_word);       // IW842
            _word.%B0 := _data_in[13];
            _word.%B1 := _data_in[12];
            Inputs.ToolResult_39.Data_1             :=  TO_UINT(_word);        // IW844
            _word.%B0 := _data_in[15];
            _word.%B1 := _data_in[14];
            Inputs.ToolResult_39.Data_2             :=  TO_UINT(_word);        // IW846
            _word.%B0 := _data_in[17];
            _word.%B1 := _data_in[16];
            Inputs.ToolResult_39.Data_3             :=  TO_UINT(_word);        // IW848
                                                                                    // IW850
            //***************************************************************

            //*************************ToolResult_40*************************
            _retVal := Siemens.Simatic.DistributedIO.ReadData((Config.HWIDs.HwID_ToolResult_40) ,_data_in);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1645, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1645;
                RETURN;
            END_IF;

            _word.%B0 := _data_in[1];
            _word.%B1 := _data_in[0];
            Inputs.ToolResult_40.MatchingRate       :=  TO_UINT(_word);        // IW852
            _word.%B0 := _data_in[3];
            _word.%B1 := _data_in[2];
            Inputs.ToolResult_40.MatchingRateMAX    :=  TO_UINT(_word);        // IW854
            _word.%B0 := _data_in[5];
            _word.%B1 := _data_in[4];
            Inputs.ToolResult_40.MatchingRateMIN    :=  TO_UINT(_word);        // IW856
            _word.%B0 := _data_in[7];
            _word.%B1 := _data_in[6];
            Inputs.ToolResult_40.LowerThreshold     :=  TO_UINT(_word);        // IW858
            _word.%B0 := _data_in[9];
            _word.%B1 := _data_in[8];
            Inputs.ToolResult_40.UpperThreshold     :=  TO_UINT(_word);        // IW860
            _word.%B0 := _data_in[11];
            _word.%B1 := _data_in[10];
            Inputs.ToolResult_40.DecimalPointPosition:=  TO_UINT(_word);       // IW862
            _word.%B0 := _data_in[13];
            _word.%B1 := _data_in[12];
            Inputs.ToolResult_40.Data_1             :=  TO_UINT(_word);        // IW864
            _word.%B0 := _data_in[15];
            _word.%B1 := _data_in[14];
            Inputs.ToolResult_40.Data_2             :=  TO_UINT(_word);        // IW866
            _word.%B0 := _data_in[17];
            _word.%B1 := _data_in[16];
            Inputs.ToolResult_40.Data_3             :=  TO_UINT(_word);        // IW868
                                                                                    // IW870
            //***************************************************************

            //*************************ToolResult_41*************************
            _retVal := Siemens.Simatic.DistributedIO.ReadData((Config.HWIDs.HwID_ToolResult_41) ,_data_in);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1646, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1646;
                RETURN;
            END_IF;

            _word.%B0 := _data_in[1];
            _word.%B1 := _data_in[0];
            Inputs.ToolResult_41.MatchingRate       :=  TO_UINT(_word);        // IW872
            _word.%B0 := _data_in[3];
            _word.%B1 := _data_in[2];
            Inputs.ToolResult_41.MatchingRateMAX    :=  TO_UINT(_word);        // IW874
            _word.%B0 := _data_in[5];
            _word.%B1 := _data_in[4];
            Inputs.ToolResult_41.MatchingRateMIN    :=  TO_UINT(_word);        // IW876
            _word.%B0 := _data_in[7];
            _word.%B1 := _data_in[6];
            Inputs.ToolResult_41.LowerThreshold     :=  TO_UINT(_word);        // IW878
            _word.%B0 := _data_in[9];
            _word.%B1 := _data_in[8];
            Inputs.ToolResult_41.UpperThreshold     :=  TO_UINT(_word);        // IW880
            _word.%B0 := _data_in[11];
            _word.%B1 := _data_in[10];
            Inputs.ToolResult_41.DecimalPointPosition:=  TO_UINT(_word);       // IW882
            _word.%B0 := _data_in[13];
            _word.%B1 := _data_in[12];
            Inputs.ToolResult_41.Data_1             :=  TO_UINT(_word);        // IW884
            _word.%B0 := _data_in[15];
            _word.%B1 := _data_in[14];
            Inputs.ToolResult_41.Data_2             :=  TO_UINT(_word);        // IW886
            _word.%B0 := _data_in[17];
            _word.%B1 := _data_in[16];
            Inputs.ToolResult_41.Data_3             :=  TO_UINT(_word);        // IW888
                                                                                    // IW890
            //***************************************************************

            //*************************ToolResult_42*************************
            _retVal := Siemens.Simatic.DistributedIO.ReadData((Config.HWIDs.HwID_ToolResult_42) ,_data_in);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1647, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1647;
                RETURN;
            END_IF;

            _word.%B0 := _data_in[1];
            _word.%B1 := _data_in[0];
            Inputs.ToolResult_42.MatchingRate       :=  TO_UINT(_word);        // IW892
            _word.%B0 := _data_in[3];
            _word.%B1 := _data_in[2];
            Inputs.ToolResult_42.MatchingRateMAX    :=  TO_UINT(_word);        // IW894
            _word.%B0 := _data_in[5];
            _word.%B1 := _data_in[4];
            Inputs.ToolResult_42.MatchingRateMIN    :=  TO_UINT(_word);        // IW896
            _word.%B0 := _data_in[7];
            _word.%B1 := _data_in[6];
            Inputs.ToolResult_42.LowerThreshold     :=  TO_UINT(_word);        // IW898
            _word.%B0 := _data_in[9];
            _word.%B1 := _data_in[8];
            Inputs.ToolResult_42.UpperThreshold     :=  TO_UINT(_word);        // IW900
            _word.%B0 := _data_in[11];
            _word.%B1 := _data_in[10];
            Inputs.ToolResult_42.DecimalPointPosition:=  TO_UINT(_word);       // IW902
            _word.%B0 := _data_in[13];
            _word.%B1 := _data_in[12];
            Inputs.ToolResult_42.Data_1             :=  TO_UINT(_word);        // IW904
            _word.%B0 := _data_in[15];
            _word.%B1 := _data_in[14];
            Inputs.ToolResult_42.Data_2             :=  TO_UINT(_word);        // IW906
            _word.%B0 := _data_in[17];
            _word.%B1 := _data_in[16];
            Inputs.ToolResult_42.Data_3             :=  TO_UINT(_word);        // IW908
                                                                                    // IW910
            //***************************************************************

            //*************************ToolResult_43*************************
            _retVal := Siemens.Simatic.DistributedIO.ReadData((Config.HWIDs.HwID_ToolResult_43) ,_data_in);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1648, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1648;
                RETURN;
            END_IF;

            _word.%B0 := _data_in[1];
            _word.%B1 := _data_in[0];
            Inputs.ToolResult_43.MatchingRate       :=  TO_UINT(_word);        // IW912
            _word.%B0 := _data_in[3];
            _word.%B1 := _data_in[2];
            Inputs.ToolResult_43.MatchingRateMAX    :=  TO_UINT(_word);        // IW914
            _word.%B0 := _data_in[5];
            _word.%B1 := _data_in[4];
            Inputs.ToolResult_43.MatchingRateMIN    :=  TO_UINT(_word);        // IW916
            _word.%B0 := _data_in[7];
            _word.%B1 := _data_in[6];
            Inputs.ToolResult_43.LowerThreshold     :=  TO_UINT(_word);        // IW918
            _word.%B0 := _data_in[9];
            _word.%B1 := _data_in[8];
            Inputs.ToolResult_43.UpperThreshold     :=  TO_UINT(_word);        // IW920
            _word.%B0 := _data_in[11];
            _word.%B1 := _data_in[10];
            Inputs.ToolResult_43.DecimalPointPosition:=  TO_UINT(_word);       // IW922
            _word.%B0 := _data_in[13];
            _word.%B1 := _data_in[12];
            Inputs.ToolResult_43.Data_1             :=  TO_UINT(_word);        // IW924
            _word.%B0 := _data_in[15];
            _word.%B1 := _data_in[14];
            Inputs.ToolResult_43.Data_2             :=  TO_UINT(_word);        // IW926
            _word.%B0 := _data_in[17];
            _word.%B1 := _data_in[16];
            Inputs.ToolResult_43.Data_3             :=  TO_UINT(_word);        // IW928
                                                                                    // IW930
            //***************************************************************

            //*************************ToolResult_44*************************
            _retVal := Siemens.Simatic.DistributedIO.ReadData((Config.HWIDs.HwID_ToolResult_44) ,_data_in);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1649, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1649;
                RETURN;
            END_IF;

            _word.%B0 := _data_in[1];
            _word.%B1 := _data_in[0];
            Inputs.ToolResult_44.MatchingRate       :=  TO_UINT(_word);        // IW932
            _word.%B0 := _data_in[3];
            _word.%B1 := _data_in[2];
            Inputs.ToolResult_44.MatchingRateMAX    :=  TO_UINT(_word);        // IW934
            _word.%B0 := _data_in[5];
            _word.%B1 := _data_in[4];
            Inputs.ToolResult_44.MatchingRateMIN    :=  TO_UINT(_word);        // IW936
            _word.%B0 := _data_in[7];
            _word.%B1 := _data_in[6];
            Inputs.ToolResult_44.LowerThreshold     :=  TO_UINT(_word);        // IW938
            _word.%B0 := _data_in[9];
            _word.%B1 := _data_in[8];
            Inputs.ToolResult_44.UpperThreshold     :=  TO_UINT(_word);        // IW940
            _word.%B0 := _data_in[11];
            _word.%B1 := _data_in[10];
            Inputs.ToolResult_44.DecimalPointPosition:=  TO_UINT(_word);       // IW942
            _word.%B0 := _data_in[13];
            _word.%B1 := _data_in[12];
            Inputs.ToolResult_44.Data_1             :=  TO_UINT(_word);        // IW944
            _word.%B0 := _data_in[15];
            _word.%B1 := _data_in[14];
            Inputs.ToolResult_44.Data_2             :=  TO_UINT(_word);        // IW946
            _word.%B0 := _data_in[17];
            _word.%B1 := _data_in[16];
            Inputs.ToolResult_44.Data_3             :=  TO_UINT(_word);        // IW948
                                                                                    // IW950
            //***************************************************************

            //*************************ToolResult_45*************************
            _retVal := Siemens.Simatic.DistributedIO.ReadData((Config.HWIDs.HwID_ToolResult_45) ,_data_in);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1650, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1650;
                RETURN;
            END_IF;

            _word.%B0 := _data_in[1];
            _word.%B1 := _data_in[0];
            Inputs.ToolResult_45.MatchingRate       :=  TO_UINT(_word);        // IW952
            _word.%B0 := _data_in[3];
            _word.%B1 := _data_in[2];
            Inputs.ToolResult_45.MatchingRateMAX    :=  TO_UINT(_word);        // IW954
            _word.%B0 := _data_in[5];
            _word.%B1 := _data_in[4];
            Inputs.ToolResult_45.MatchingRateMIN    :=  TO_UINT(_word);        // IW956
            _word.%B0 := _data_in[7];
            _word.%B1 := _data_in[6];
            Inputs.ToolResult_45.LowerThreshold     :=  TO_UINT(_word);        // IW958
            _word.%B0 := _data_in[9];
            _word.%B1 := _data_in[8];
            Inputs.ToolResult_45.UpperThreshold     :=  TO_UINT(_word);        // IW960
            _word.%B0 := _data_in[11];
            _word.%B1 := _data_in[10];
            Inputs.ToolResult_45.DecimalPointPosition:=  TO_UINT(_word);       // IW962
            _word.%B0 := _data_in[13];
            _word.%B1 := _data_in[12];
            Inputs.ToolResult_45.Data_1             :=  TO_UINT(_word);        // IW964
            _word.%B0 := _data_in[15];
            _word.%B1 := _data_in[14];
            Inputs.ToolResult_45.Data_2             :=  TO_UINT(_word);        // IW966
            _word.%B0 := _data_in[17];
            _word.%B1 := _data_in[16];
            Inputs.ToolResult_45.Data_3             :=  TO_UINT(_word);        // IW968
                                                                                    // IW970
            //***************************************************************

            //*************************ToolResult_46*************************
            _retVal := Siemens.Simatic.DistributedIO.ReadData((Config.HWIDs.HwID_ToolResult_46) ,_data_in);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1651, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1651;
                RETURN;
            END_IF;

            _word.%B0 := _data_in[1];
            _word.%B1 := _data_in[0];
            Inputs.ToolResult_46.MatchingRate       :=  TO_UINT(_word);        // IW972
            _word.%B0 := _data_in[3];
            _word.%B1 := _data_in[2];
            Inputs.ToolResult_46.MatchingRateMAX    :=  TO_UINT(_word);        // IW974
            _word.%B0 := _data_in[5];
            _word.%B1 := _data_in[4];
            Inputs.ToolResult_46.MatchingRateMIN    :=  TO_UINT(_word);        // IW976
            _word.%B0 := _data_in[7];
            _word.%B1 := _data_in[6];
            Inputs.ToolResult_46.LowerThreshold     :=  TO_UINT(_word);        // IW978
            _word.%B0 := _data_in[9];
            _word.%B1 := _data_in[8];
            Inputs.ToolResult_46.UpperThreshold     :=  TO_UINT(_word);        // IW980
            _word.%B0 := _data_in[11];
            _word.%B1 := _data_in[10];
            Inputs.ToolResult_46.DecimalPointPosition:=  TO_UINT(_word);       // IW982
            _word.%B0 := _data_in[13];
            _word.%B1 := _data_in[12];
            Inputs.ToolResult_46.Data_1             :=  TO_UINT(_word);        // IW984
            _word.%B0 := _data_in[15];
            _word.%B1 := _data_in[14];
            Inputs.ToolResult_46.Data_2             :=  TO_UINT(_word);        // IW986
            _word.%B0 := _data_in[17];
            _word.%B1 := _data_in[16];
            Inputs.ToolResult_46.Data_3             :=  TO_UINT(_word);        // IW988
                                                                                    // IW990
            //***************************************************************

            //*************************ToolResult_47*************************
            _retVal := Siemens.Simatic.DistributedIO.ReadData((Config.HWIDs.HwID_ToolResult_47) ,_data_in);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1652, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1652;
                RETURN;
            END_IF;

            _word.%B0 := _data_in[1];
            _word.%B1 := _data_in[0];
            Inputs.ToolResult_47.MatchingRate       :=  TO_UINT(_word);        // IW992
            _word.%B0 := _data_in[3];
            _word.%B1 := _data_in[2];
            Inputs.ToolResult_47.MatchingRateMAX    :=  TO_UINT(_word);        // IW994
            _word.%B0 := _data_in[5];
            _word.%B1 := _data_in[4];
            Inputs.ToolResult_47.MatchingRateMIN    :=  TO_UINT(_word);        // IW996
            _word.%B0 := _data_in[7];
            _word.%B1 := _data_in[6];
            Inputs.ToolResult_47.LowerThreshold     :=  TO_UINT(_word);        // IW998
            _word.%B0 := _data_in[9];
            _word.%B1 := _data_in[8];
            Inputs.ToolResult_47.UpperThreshold     :=  TO_UINT(_word);        // IW1000
            _word.%B0 := _data_in[11];
            _word.%B1 := _data_in[10];
            Inputs.ToolResult_47.DecimalPointPosition:=  TO_UINT(_word);       // IW1002
            _word.%B0 := _data_in[13];
            _word.%B1 := _data_in[12];
            Inputs.ToolResult_47.Data_1             :=  TO_UINT(_word);        // IW1004
            _word.%B0 := _data_in[15];
            _word.%B1 := _data_in[14];
            Inputs.ToolResult_47.Data_2             :=  TO_UINT(_word);        // IW1006
            _word.%B0 := _data_in[17];
            _word.%B1 := _data_in[16];
            Inputs.ToolResult_47.Data_3             :=  TO_UINT(_word);        // IW1008
                                                                                    // IW1010
            //***************************************************************

            //*************************ToolResult_48*************************
            _retVal := Siemens.Simatic.DistributedIO.ReadData((Config.HWIDs.HwID_ToolResult_48) ,_data_in);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1653, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1653;
                RETURN;
            END_IF;

            _word.%B0 := _data_in[1];
            _word.%B1 := _data_in[0];
            Inputs.ToolResult_48.MatchingRate       :=  TO_UINT(_word);        // IW1012
            _word.%B0 := _data_in[3];
            _word.%B1 := _data_in[2];
            Inputs.ToolResult_48.MatchingRateMAX    :=  TO_UINT(_word);        // IW1014
            _word.%B0 := _data_in[5];
            _word.%B1 := _data_in[4];
            Inputs.ToolResult_48.MatchingRateMIN    :=  TO_UINT(_word);        // IW1016
            _word.%B0 := _data_in[7];
            _word.%B1 := _data_in[6];
            Inputs.ToolResult_48.LowerThreshold     :=  TO_UINT(_word);        // IW1018
            _word.%B0 := _data_in[9];
            _word.%B1 := _data_in[8];
            Inputs.ToolResult_48.UpperThreshold     :=  TO_UINT(_word);        // IW1020
            _word.%B0 := _data_in[11];
            _word.%B1 := _data_in[10];
            Inputs.ToolResult_48.DecimalPointPosition:=  TO_UINT(_word);       // IW1022
            _word.%B0 := _data_in[13];
            _word.%B1 := _data_in[12];
            Inputs.ToolResult_48.Data_1             :=  TO_UINT(_word);        // IW1024
            _word.%B0 := _data_in[15];
            _word.%B1 := _data_in[14];
            Inputs.ToolResult_48.Data_2             :=  TO_UINT(_word);        // IW1026
            _word.%B0 := _data_in[17];
            _word.%B1 := _data_in[16];
            Inputs.ToolResult_48.Data_3             :=  TO_UINT(_word);        // IW1028
                                                                                    // IW1030
            //***************************************************************

            //*************************ToolResult_49*************************
            _retVal := Siemens.Simatic.DistributedIO.ReadData((Config.HWIDs.HwID_ToolResult_49) ,_data_in);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1654, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1654;
                RETURN;
            END_IF;

            _word.%B0 := _data_in[1];
            _word.%B1 := _data_in[0];
            Inputs.ToolResult_49.MatchingRate       :=  TO_UINT(_word);        // IW1032
            _word.%B0 := _data_in[3];
            _word.%B1 := _data_in[2];
            Inputs.ToolResult_49.MatchingRateMAX    :=  TO_UINT(_word);        // IW1034
            _word.%B0 := _data_in[5];
            _word.%B1 := _data_in[4];
            Inputs.ToolResult_49.MatchingRateMIN    :=  TO_UINT(_word);        // IW1036
            _word.%B0 := _data_in[7];
            _word.%B1 := _data_in[6];
            Inputs.ToolResult_49.LowerThreshold     :=  TO_UINT(_word);        // IW1038
            _word.%B0 := _data_in[9];
            _word.%B1 := _data_in[8];
            Inputs.ToolResult_49.UpperThreshold     :=  TO_UINT(_word);        // IW1040
            _word.%B0 := _data_in[11];
            _word.%B1 := _data_in[10];
            Inputs.ToolResult_49.DecimalPointPosition:=  TO_UINT(_word);       // IW1042
            _word.%B0 := _data_in[13];
            _word.%B1 := _data_in[12];
            Inputs.ToolResult_49.Data_1             :=  TO_UINT(_word);        // IW1044
            _word.%B0 := _data_in[15];
            _word.%B1 := _data_in[14];
            Inputs.ToolResult_49.Data_2             :=  TO_UINT(_word);        // IW1046
            _word.%B0 := _data_in[17];
            _word.%B1 := _data_in[16];
            Inputs.ToolResult_49.Data_3             :=  TO_UINT(_word);        // IW1048
                                                                                    // IW1050
            //***************************************************************

            //*************************ToolResult_50*************************
            _retVal := Siemens.Simatic.DistributedIO.ReadData((Config.HWIDs.HwID_ToolResult_50) ,_data_in);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1655, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1655;
                RETURN;
            END_IF;

            _word.%B0 := _data_in[1];
            _word.%B1 := _data_in[0];
            Inputs.ToolResult_50.MatchingRate       :=  TO_UINT(_word);        // IW1052
            _word.%B0 := _data_in[3];
            _word.%B1 := _data_in[2];
            Inputs.ToolResult_50.MatchingRateMAX    :=  TO_UINT(_word);        // IW1054
            _word.%B0 := _data_in[5];
            _word.%B1 := _data_in[4];
            Inputs.ToolResult_50.MatchingRateMIN    :=  TO_UINT(_word);        // IW1056
            _word.%B0 := _data_in[7];
            _word.%B1 := _data_in[6];
            Inputs.ToolResult_50.LowerThreshold     :=  TO_UINT(_word);        // IW1058
            _word.%B0 := _data_in[9];
            _word.%B1 := _data_in[8];
            Inputs.ToolResult_50.UpperThreshold     :=  TO_UINT(_word);        // IW1060
            _word.%B0 := _data_in[11];
            _word.%B1 := _data_in[10];
            Inputs.ToolResult_50.DecimalPointPosition:=  TO_UINT(_word);       // IW1062
            _word.%B0 := _data_in[13];
            _word.%B1 := _data_in[12];
            Inputs.ToolResult_50.Data_1             :=  TO_UINT(_word);        // IW1064
            _word.%B0 := _data_in[15];
            _word.%B1 := _data_in[14];
            Inputs.ToolResult_50.Data_2             :=  TO_UINT(_word);        // IW1066
            _word.%B0 := _data_in[17];
            _word.%B1 := _data_in[16];
            Inputs.ToolResult_50.Data_3             :=  TO_UINT(_word);        // IW1068
                                                                                    // IW1070
            //***************************************************************

            //*************************ToolResult_51*************************
            _retVal := Siemens.Simatic.DistributedIO.ReadData((Config.HWIDs.HwID_ToolResult_51) ,_data_in);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1656, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1656;
                RETURN;
            END_IF;

            _word.%B0 := _data_in[1];
            _word.%B1 := _data_in[0];
            Inputs.ToolResult_51.MatchingRate       :=  TO_UINT(_word);        // IW1072
            _word.%B0 := _data_in[3];
            _word.%B1 := _data_in[2];
            Inputs.ToolResult_51.MatchingRateMAX    :=  TO_UINT(_word);        // IW1074
            _word.%B0 := _data_in[5];
            _word.%B1 := _data_in[4];
            Inputs.ToolResult_51.MatchingRateMIN    :=  TO_UINT(_word);        // IW1076
            _word.%B0 := _data_in[7];
            _word.%B1 := _data_in[6];
            Inputs.ToolResult_51.LowerThreshold     :=  TO_UINT(_word);        // IW1078
            _word.%B0 := _data_in[9];
            _word.%B1 := _data_in[8];
            Inputs.ToolResult_51.UpperThreshold     :=  TO_UINT(_word);        // IW1080
            _word.%B0 := _data_in[11];
            _word.%B1 := _data_in[10];
            Inputs.ToolResult_51.DecimalPointPosition:=  TO_UINT(_word);       // IW1082
            _word.%B0 := _data_in[13];
            _word.%B1 := _data_in[12];
            Inputs.ToolResult_51.Data_1             :=  TO_UINT(_word);        // IW1084
            _word.%B0 := _data_in[15];
            _word.%B1 := _data_in[14];
            Inputs.ToolResult_51.Data_2             :=  TO_UINT(_word);        // IW1086
            _word.%B0 := _data_in[17];
            _word.%B1 := _data_in[16];
            Inputs.ToolResult_51.Data_3             :=  TO_UINT(_word);        // IW1088
                                                                                    // IW1090
            //***************************************************************

            //*************************ToolResult_52*************************
            _retVal := Siemens.Simatic.DistributedIO.ReadData((Config.HWIDs.HwID_ToolResult_52) ,_data_in);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1657, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1657;
                RETURN;
            END_IF;

            _word.%B0 := _data_in[1];
            _word.%B1 := _data_in[0];
            Inputs.ToolResult_52.MatchingRate       :=  TO_UINT(_word);        // IW1092
            _word.%B0 := _data_in[3];
            _word.%B1 := _data_in[2];
            Inputs.ToolResult_52.MatchingRateMAX    :=  TO_UINT(_word);        // IW1094
            _word.%B0 := _data_in[5];
            _word.%B1 := _data_in[4];
            Inputs.ToolResult_52.MatchingRateMIN    :=  TO_UINT(_word);        // IW1096
            _word.%B0 := _data_in[7];
            _word.%B1 := _data_in[6];
            Inputs.ToolResult_52.LowerThreshold     :=  TO_UINT(_word);        // IW1098
            _word.%B0 := _data_in[9];
            _word.%B1 := _data_in[8];
            Inputs.ToolResult_52.UpperThreshold     :=  TO_UINT(_word);        // IW1100
            _word.%B0 := _data_in[11];
            _word.%B1 := _data_in[10];
            Inputs.ToolResult_52.DecimalPointPosition:=  TO_UINT(_word);       // IW1102
            _word.%B0 := _data_in[13];
            _word.%B1 := _data_in[12];
            Inputs.ToolResult_52.Data_1             :=  TO_UINT(_word);        // IW1104
            _word.%B0 := _data_in[15];
            _word.%B1 := _data_in[14];
            Inputs.ToolResult_52.Data_2             :=  TO_UINT(_word);        // IW1106
            _word.%B0 := _data_in[17];
            _word.%B1 := _data_in[16];
            Inputs.ToolResult_52.Data_3             :=  TO_UINT(_word);        // IW1108
                                                                                    // IW1110
            //***************************************************************

            //*************************ToolResult_53*************************
            _retVal := Siemens.Simatic.DistributedIO.ReadData((Config.HWIDs.HwID_ToolResult_53) ,_data_in);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1658, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1658;
                RETURN;
            END_IF;

            _word.%B0 := _data_in[1];
            _word.%B1 := _data_in[0];
            Inputs.ToolResult_53.MatchingRate       :=  TO_UINT(_word);        // IW1112
            _word.%B0 := _data_in[3];
            _word.%B1 := _data_in[2];
            Inputs.ToolResult_53.MatchingRateMAX    :=  TO_UINT(_word);        // IW1114
            _word.%B0 := _data_in[5];
            _word.%B1 := _data_in[4];
            Inputs.ToolResult_53.MatchingRateMIN    :=  TO_UINT(_word);        // IW1116
            _word.%B0 := _data_in[7];
            _word.%B1 := _data_in[6];
            Inputs.ToolResult_53.LowerThreshold     :=  TO_UINT(_word);        // IW1118
            _word.%B0 := _data_in[9];
            _word.%B1 := _data_in[8];
            Inputs.ToolResult_53.UpperThreshold     :=  TO_UINT(_word);        // IW1120
            _word.%B0 := _data_in[11];
            _word.%B1 := _data_in[10];
            Inputs.ToolResult_53.DecimalPointPosition:=  TO_UINT(_word);       // IW1122
            _word.%B0 := _data_in[13];
            _word.%B1 := _data_in[12];
            Inputs.ToolResult_53.Data_1             :=  TO_UINT(_word);        // IW1124
            _word.%B0 := _data_in[15];
            _word.%B1 := _data_in[14];
            Inputs.ToolResult_53.Data_2             :=  TO_UINT(_word);        // IW1126
            _word.%B0 := _data_in[17];
            _word.%B1 := _data_in[16];
            Inputs.ToolResult_53.Data_3             :=  TO_UINT(_word);        // IW1128
                                                                                    // IW1130
            //***************************************************************

            //*************************ToolResult_54*************************
            _retVal := Siemens.Simatic.DistributedIO.ReadData((Config.HWIDs.HwID_ToolResult_54) ,_data_in);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1659, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1659;
                RETURN;
            END_IF;

            _word.%B0 := _data_in[1];
            _word.%B1 := _data_in[0];
            Inputs.ToolResult_54.MatchingRate       :=  TO_UINT(_word);        // IW1132
            _word.%B0 := _data_in[3];
            _word.%B1 := _data_in[2];
            Inputs.ToolResult_54.MatchingRateMAX    :=  TO_UINT(_word);        // IW1134
            _word.%B0 := _data_in[5];
            _word.%B1 := _data_in[4];
            Inputs.ToolResult_54.MatchingRateMIN    :=  TO_UINT(_word);        // IW1136
            _word.%B0 := _data_in[7];
            _word.%B1 := _data_in[6];
            Inputs.ToolResult_54.LowerThreshold     :=  TO_UINT(_word);        // IW1138
            _word.%B0 := _data_in[9];
            _word.%B1 := _data_in[8];
            Inputs.ToolResult_54.UpperThreshold     :=  TO_UINT(_word);        // IW1140
            _word.%B0 := _data_in[11];
            _word.%B1 := _data_in[10];
            Inputs.ToolResult_54.DecimalPointPosition:=  TO_UINT(_word);       // IW1142
            _word.%B0 := _data_in[13];
            _word.%B1 := _data_in[12];
            Inputs.ToolResult_54.Data_1             :=  TO_UINT(_word);        // IW1144
            _word.%B0 := _data_in[15];
            _word.%B1 := _data_in[14];
            Inputs.ToolResult_54.Data_2             :=  TO_UINT(_word);        // IW1146
            _word.%B0 := _data_in[17];
            _word.%B1 := _data_in[16];
            Inputs.ToolResult_54.Data_3             :=  TO_UINT(_word);        // IW1148
                                                                                    // IW1150
            //***************************************************************

            //*************************ToolResult_55*************************
            _retVal := Siemens.Simatic.DistributedIO.ReadData((Config.HWIDs.HwID_ToolResult_55) ,_data_in);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1660, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1660;
                RETURN;
            END_IF;

            _word.%B0 := _data_in[1];
            _word.%B1 := _data_in[0];
            Inputs.ToolResult_55.MatchingRate       :=  TO_UINT(_word);        // IW1152
            _word.%B0 := _data_in[3];
            _word.%B1 := _data_in[2];
            Inputs.ToolResult_55.MatchingRateMAX    :=  TO_UINT(_word);        // IW1154
            _word.%B0 := _data_in[5];
            _word.%B1 := _data_in[4];
            Inputs.ToolResult_55.MatchingRateMIN    :=  TO_UINT(_word);        // IW1156
            _word.%B0 := _data_in[7];
            _word.%B1 := _data_in[6];
            Inputs.ToolResult_55.LowerThreshold     :=  TO_UINT(_word);        // IW1158
            _word.%B0 := _data_in[9];
            _word.%B1 := _data_in[8];
            Inputs.ToolResult_55.UpperThreshold     :=  TO_UINT(_word);        // IW1160
            _word.%B0 := _data_in[11];
            _word.%B1 := _data_in[10];
            Inputs.ToolResult_55.DecimalPointPosition:=  TO_UINT(_word);       // IW1162
            _word.%B0 := _data_in[13];
            _word.%B1 := _data_in[12];
            Inputs.ToolResult_55.Data_1             :=  TO_UINT(_word);        // IW1164
            _word.%B0 := _data_in[15];
            _word.%B1 := _data_in[14];
            Inputs.ToolResult_55.Data_2             :=  TO_UINT(_word);        // IW1166
            _word.%B0 := _data_in[17];
            _word.%B1 := _data_in[16];
            Inputs.ToolResult_55.Data_3             :=  TO_UINT(_word);        // IW1168
                                                                                    // IW1170
            //***************************************************************

            //*************************ToolResult_56*************************
            _retVal := Siemens.Simatic.DistributedIO.ReadData((Config.HWIDs.HwID_ToolResult_56) ,_data_in);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1661, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1661;
                RETURN;
            END_IF;

            _word.%B0 := _data_in[1];
            _word.%B1 := _data_in[0];
            Inputs.ToolResult_56.MatchingRate       :=  TO_UINT(_word);        // IW1172
            _word.%B0 := _data_in[3];
            _word.%B1 := _data_in[2];
            Inputs.ToolResult_56.MatchingRateMAX    :=  TO_UINT(_word);        // IW1174
            _word.%B0 := _data_in[5];
            _word.%B1 := _data_in[4];
            Inputs.ToolResult_56.MatchingRateMIN    :=  TO_UINT(_word);        // IW1176
            _word.%B0 := _data_in[7];
            _word.%B1 := _data_in[6];
            Inputs.ToolResult_56.LowerThreshold     :=  TO_UINT(_word);        // IW1178
            _word.%B0 := _data_in[9];
            _word.%B1 := _data_in[8];
            Inputs.ToolResult_56.UpperThreshold     :=  TO_UINT(_word);        // IW1180
            _word.%B0 := _data_in[11];
            _word.%B1 := _data_in[10];
            Inputs.ToolResult_56.DecimalPointPosition:=  TO_UINT(_word);       // IW1182
            _word.%B0 := _data_in[13];
            _word.%B1 := _data_in[12];
            Inputs.ToolResult_56.Data_1             :=  TO_UINT(_word);        // IW1184
            _word.%B0 := _data_in[15];
            _word.%B1 := _data_in[14];
            Inputs.ToolResult_56.Data_2             :=  TO_UINT(_word);        // IW1186
            _word.%B0 := _data_in[17];
            _word.%B1 := _data_in[16];
            Inputs.ToolResult_56.Data_3             :=  TO_UINT(_word);        // IW1188
                                                                                    // IW1190
            //***************************************************************

            //*************************ToolResult_57*************************
            _retVal := Siemens.Simatic.DistributedIO.ReadData((Config.HWIDs.HwID_ToolResult_57) ,_data_in);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1662, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1662;
                RETURN;
            END_IF;

            _word.%B0 := _data_in[1];
            _word.%B1 := _data_in[0];
            Inputs.ToolResult_57.MatchingRate       :=  TO_UINT(_word);        // IW1192
            _word.%B0 := _data_in[3];
            _word.%B1 := _data_in[2];
            Inputs.ToolResult_57.MatchingRateMAX    :=  TO_UINT(_word);        // IW1194
            _word.%B0 := _data_in[5];
            _word.%B1 := _data_in[4];
            Inputs.ToolResult_57.MatchingRateMIN    :=  TO_UINT(_word);        // IW1196
            _word.%B0 := _data_in[7];
            _word.%B1 := _data_in[6];
            Inputs.ToolResult_57.LowerThreshold     :=  TO_UINT(_word);        // IW1198
            _word.%B0 := _data_in[9];
            _word.%B1 := _data_in[8];
            Inputs.ToolResult_57.UpperThreshold     :=  TO_UINT(_word);        // IW1200
            _word.%B0 := _data_in[11];
            _word.%B1 := _data_in[10];
            Inputs.ToolResult_57.DecimalPointPosition:=  TO_UINT(_word);       // IW1202
            _word.%B0 := _data_in[13];
            _word.%B1 := _data_in[12];
            Inputs.ToolResult_57.Data_1             :=  TO_UINT(_word);        // IW1204
            _word.%B0 := _data_in[15];
            _word.%B1 := _data_in[14];
            Inputs.ToolResult_57.Data_2             :=  TO_UINT(_word);        // IW1206
            _word.%B0 := _data_in[17];
            _word.%B1 := _data_in[16];
            Inputs.ToolResult_57.Data_3             :=  TO_UINT(_word);        // IW1208
                                                                                    // IW1210
            //***************************************************************

            //*************************ToolResult_58*************************
            _retVal := Siemens.Simatic.DistributedIO.ReadData((Config.HWIDs.HwID_ToolResult_58) ,_data_in);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1663, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1663;
                RETURN;
            END_IF;

            _word.%B0 := _data_in[1];
            _word.%B1 := _data_in[0];
            Inputs.ToolResult_58.MatchingRate       :=  TO_UINT(_word);        // IW1212
            _word.%B0 := _data_in[3];
            _word.%B1 := _data_in[2];
            Inputs.ToolResult_58.MatchingRateMAX    :=  TO_UINT(_word);        // IW1214
            _word.%B0 := _data_in[5];
            _word.%B1 := _data_in[4];
            Inputs.ToolResult_58.MatchingRateMIN    :=  TO_UINT(_word);        // IW1216
            _word.%B0 := _data_in[7];
            _word.%B1 := _data_in[6];
            Inputs.ToolResult_58.LowerThreshold     :=  TO_UINT(_word);        // IW1218
            _word.%B0 := _data_in[9];
            _word.%B1 := _data_in[8];
            Inputs.ToolResult_58.UpperThreshold     :=  TO_UINT(_word);        // IW1220
            _word.%B0 := _data_in[11];
            _word.%B1 := _data_in[10];
            Inputs.ToolResult_58.DecimalPointPosition:=  TO_UINT(_word);       // IW1222
            _word.%B0 := _data_in[13];
            _word.%B1 := _data_in[12];
            Inputs.ToolResult_58.Data_1             :=  TO_UINT(_word);        // IW1224
            _word.%B0 := _data_in[15];
            _word.%B1 := _data_in[14];
            Inputs.ToolResult_58.Data_2             :=  TO_UINT(_word);        // IW1226
            _word.%B0 := _data_in[17];
            _word.%B1 := _data_in[16];
            Inputs.ToolResult_58.Data_3             :=  TO_UINT(_word);        // IW1228
                                                                                    // IW1230
            //***************************************************************

            //*************************ToolResult_59*************************
            _retVal := Siemens.Simatic.DistributedIO.ReadData((Config.HWIDs.HwID_ToolResult_59) ,_data_in);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1664, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1664;
                RETURN;
            END_IF;

            _word.%B0 := _data_in[1];
            _word.%B1 := _data_in[0];
            Inputs.ToolResult_59.MatchingRate       :=  TO_UINT(_word);        // IW1232
            _word.%B0 := _data_in[3];
            _word.%B1 := _data_in[2];
            Inputs.ToolResult_59.MatchingRateMAX    :=  TO_UINT(_word);        // IW1234
            _word.%B0 := _data_in[5];
            _word.%B1 := _data_in[4];
            Inputs.ToolResult_59.MatchingRateMIN    :=  TO_UINT(_word);        // IW1236
            _word.%B0 := _data_in[7];
            _word.%B1 := _data_in[6];
            Inputs.ToolResult_59.LowerThreshold     :=  TO_UINT(_word);        // IW1238
            _word.%B0 := _data_in[9];
            _word.%B1 := _data_in[8];
            Inputs.ToolResult_59.UpperThreshold     :=  TO_UINT(_word);        // IW1240
            _word.%B0 := _data_in[11];
            _word.%B1 := _data_in[10];
            Inputs.ToolResult_59.DecimalPointPosition:=  TO_UINT(_word);       // IW1242
            _word.%B0 := _data_in[13];
            _word.%B1 := _data_in[12];
            Inputs.ToolResult_59.Data_1             :=  TO_UINT(_word);        // IW1244
            _word.%B0 := _data_in[15];
            _word.%B1 := _data_in[14];
            Inputs.ToolResult_59.Data_2             :=  TO_UINT(_word);        // IW1246
            _word.%B0 := _data_in[17];
            _word.%B1 := _data_in[16];
            Inputs.ToolResult_59.Data_3             :=  TO_UINT(_word);        // IW1248
                                                                                    // IW1250
            //***************************************************************

            //*************************ToolResult_60*************************
            _retVal := Siemens.Simatic.DistributedIO.ReadData((Config.HWIDs.HwID_ToolResult_60) ,_data_in);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1665, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1665;
                RETURN;
            END_IF;

            _word.%B0 := _data_in[1];
            _word.%B1 := _data_in[0];
            Inputs.ToolResult_60.MatchingRate       :=  TO_UINT(_word);        // IW1252
            _word.%B0 := _data_in[3];
            _word.%B1 := _data_in[2];
            Inputs.ToolResult_60.MatchingRateMAX    :=  TO_UINT(_word);        // IW1254
            _word.%B0 := _data_in[5];
            _word.%B1 := _data_in[4];
            Inputs.ToolResult_60.MatchingRateMIN    :=  TO_UINT(_word);        // IW1256
            _word.%B0 := _data_in[7];
            _word.%B1 := _data_in[6];
            Inputs.ToolResult_60.LowerThreshold     :=  TO_UINT(_word);        // IW1258
            _word.%B0 := _data_in[9];
            _word.%B1 := _data_in[8];
            Inputs.ToolResult_60.UpperThreshold     :=  TO_UINT(_word);        // IW1260
            _word.%B0 := _data_in[11];
            _word.%B1 := _data_in[10];
            Inputs.ToolResult_60.DecimalPointPosition:=  TO_UINT(_word);       // IW1262
            _word.%B0 := _data_in[13];
            _word.%B1 := _data_in[12];
            Inputs.ToolResult_60.Data_1             :=  TO_UINT(_word);        // IW1264
            _word.%B0 := _data_in[15];
            _word.%B1 := _data_in[14];
            Inputs.ToolResult_60.Data_2             :=  TO_UINT(_word);        // IW1266
            _word.%B0 := _data_in[17];
            _word.%B1 := _data_in[16];
            Inputs.ToolResult_60.Data_3             :=  TO_UINT(_word);        // IW1268
                                                                                    // IW1270
            //***************************************************************

            //*************************ToolResult_61*************************
            _retVal := Siemens.Simatic.DistributedIO.ReadData((Config.HWIDs.HwID_ToolResult_61) ,_data_in);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1666, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1666;
                RETURN;
            END_IF;

            _word.%B0 := _data_in[1];
            _word.%B1 := _data_in[0];
            Inputs.ToolResult_61.MatchingRate       :=  TO_UINT(_word);        // IW1272
            _word.%B0 := _data_in[3];
            _word.%B1 := _data_in[2];
            Inputs.ToolResult_61.MatchingRateMAX    :=  TO_UINT(_word);        // IW1274
            _word.%B0 := _data_in[5];
            _word.%B1 := _data_in[4];
            Inputs.ToolResult_61.MatchingRateMIN    :=  TO_UINT(_word);        // IW1276
            _word.%B0 := _data_in[7];
            _word.%B1 := _data_in[6];
            Inputs.ToolResult_61.LowerThreshold     :=  TO_UINT(_word);        // IW1278
            _word.%B0 := _data_in[9];
            _word.%B1 := _data_in[8];
            Inputs.ToolResult_61.UpperThreshold     :=  TO_UINT(_word);        // IW1280
            _word.%B0 := _data_in[11];
            _word.%B1 := _data_in[10];
            Inputs.ToolResult_61.DecimalPointPosition:=  TO_UINT(_word);       // IW1282
            _word.%B0 := _data_in[13];
            _word.%B1 := _data_in[12];
            Inputs.ToolResult_61.Data_1             :=  TO_UINT(_word);        // IW1284
            _word.%B0 := _data_in[15];
            _word.%B1 := _data_in[14];
            Inputs.ToolResult_61.Data_2             :=  TO_UINT(_word);        // IW1286
            _word.%B0 := _data_in[17];
            _word.%B1 := _data_in[16];
            Inputs.ToolResult_61.Data_3             :=  TO_UINT(_word);        // IW1288
                                                                                    // IW1290
            //***************************************************************

            //*************************ToolResult_62*************************
            _retVal := Siemens.Simatic.DistributedIO.ReadData((Config.HWIDs.HwID_ToolResult_62) ,_data_in);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1667, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1667;
                RETURN;
            END_IF;

            _word.%B0 := _data_in[1];
            _word.%B1 := _data_in[0];
            Inputs.ToolResult_62.MatchingRate       :=  TO_UINT(_word);        // IW1292
            _word.%B0 := _data_in[3];
            _word.%B1 := _data_in[2];
            Inputs.ToolResult_62.MatchingRateMAX    :=  TO_UINT(_word);        // IW1294
            _word.%B0 := _data_in[5];
            _word.%B1 := _data_in[4];
            Inputs.ToolResult_62.MatchingRateMIN    :=  TO_UINT(_word);        // IW1296
            _word.%B0 := _data_in[7];
            _word.%B1 := _data_in[6];
            Inputs.ToolResult_62.LowerThreshold     :=  TO_UINT(_word);        // IW1298
            _word.%B0 := _data_in[9];
            _word.%B1 := _data_in[8];
            Inputs.ToolResult_62.UpperThreshold     :=  TO_UINT(_word);        // IW1300
            _word.%B0 := _data_in[11];
            _word.%B1 := _data_in[10];
            Inputs.ToolResult_62.DecimalPointPosition:=  TO_UINT(_word);       // IW1302
            _word.%B0 := _data_in[13];
            _word.%B1 := _data_in[12];
            Inputs.ToolResult_62.Data_1             :=  TO_UINT(_word);        // IW1304
            _word.%B0 := _data_in[15];
            _word.%B1 := _data_in[14];
            Inputs.ToolResult_62.Data_2             :=  TO_UINT(_word);        // IW1306
            _word.%B0 := _data_in[17];
            _word.%B1 := _data_in[16];
            Inputs.ToolResult_62.Data_3             :=  TO_UINT(_word);        // IW1308
                                                                                    // IW1310
            //***************************************************************

            //*************************ToolResult_63*************************
            _retVal := Siemens.Simatic.DistributedIO.ReadData((Config.HWIDs.HwID_ToolResult_63) ,_data_in);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1668, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1668;
                RETURN;
            END_IF;

            _word.%B0 := _data_in[1];
            _word.%B1 := _data_in[0];
            Inputs.ToolResult_63.MatchingRate       :=  TO_UINT(_word);        // IW1312
            _word.%B0 := _data_in[3];
            _word.%B1 := _data_in[2];
            Inputs.ToolResult_63.MatchingRateMAX    :=  TO_UINT(_word);        // IW1314
            _word.%B0 := _data_in[5];
            _word.%B1 := _data_in[4];
            Inputs.ToolResult_63.MatchingRateMIN    :=  TO_UINT(_word);        // IW1316
            _word.%B0 := _data_in[7];
            _word.%B1 := _data_in[6];
            Inputs.ToolResult_63.LowerThreshold     :=  TO_UINT(_word);        // IW1318
            _word.%B0 := _data_in[9];
            _word.%B1 := _data_in[8];
            Inputs.ToolResult_63.UpperThreshold     :=  TO_UINT(_word);        // IW1320
            _word.%B0 := _data_in[11];
            _word.%B1 := _data_in[10];
            Inputs.ToolResult_63.DecimalPointPosition:=  TO_UINT(_word);       // IW1322
            _word.%B0 := _data_in[13];
            _word.%B1 := _data_in[12];
            Inputs.ToolResult_63.Data_1             :=  TO_UINT(_word);        // IW1324
            _word.%B0 := _data_in[15];
            _word.%B1 := _data_in[14];
            Inputs.ToolResult_63.Data_2             :=  TO_UINT(_word);        // IW1326
            _word.%B0 := _data_in[17];
            _word.%B1 := _data_in[16];
            Inputs.ToolResult_63.Data_3             :=  TO_UINT(_word);        // IW1328
                                                                                    // IW1330
            //***************************************************************

            //*************************ToolResult_64*************************
            _retVal := Siemens.Simatic.DistributedIO.ReadData((Config.HWIDs.HwID_ToolResult_64) ,_data_in);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1669, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1669;
                RETURN;
            END_IF;

            _word.%B0 := _data_in[1];
            _word.%B1 := _data_in[0];
            Inputs.ToolResult_64.MatchingRate       :=  TO_UINT(_word);        // IW1332
            _word.%B0 := _data_in[3];
            _word.%B1 := _data_in[2];
            Inputs.ToolResult_64.MatchingRateMAX    :=  TO_UINT(_word);        // IW1334
            _word.%B0 := _data_in[5];
            _word.%B1 := _data_in[4];
            Inputs.ToolResult_64.MatchingRateMIN    :=  TO_UINT(_word);        // IW1336
            _word.%B0 := _data_in[7];
            _word.%B1 := _data_in[6];
            Inputs.ToolResult_64.LowerThreshold     :=  TO_UINT(_word);        // IW1338
            _word.%B0 := _data_in[9];
            _word.%B1 := _data_in[8];
            Inputs.ToolResult_64.UpperThreshold     :=  TO_UINT(_word);        // IW1340
            _word.%B0 := _data_in[11];
            _word.%B1 := _data_in[10];
            Inputs.ToolResult_64.DecimalPointPosition:=  TO_UINT(_word);       // IW1342
            _word.%B0 := _data_in[13];
            _word.%B1 := _data_in[12];
            Inputs.ToolResult_64.Data_1             :=  TO_UINT(_word);        // IW1344
            _word.%B0 := _data_in[15];
            _word.%B1 := _data_in[14];
            Inputs.ToolResult_64.Data_2             :=  TO_UINT(_word);        // IW1346
            _word.%B0 := _data_in[17];
            _word.%B1 := _data_in[16];
            Inputs.ToolResult_64.Data_3             :=  TO_UINT(_word);        // IW1348
                                                                                    // IW1350
            //***************************************************************

            //*************************DeviceResultBits_2********************
            _retVal := Siemens.Simatic.DistributedIO.ReadData((Config.HWIDs.HwID_DeviceResultBits_2) ,_data_in);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1670, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1670;
                RETURN;
            END_IF;

            _word.%B0 := _data_in[1];
            _word.%B1 := _data_in[0];
            Inputs.DeviceResultBits_2.MasterNumber                  :=  TO_UINT(_word);        // IW1352

            Inputs.DeviceResultBits_2.Tool_17                       :=   _data_in[2].%X0;       // IB1354.0
            Inputs.DeviceResultBits_2.Tool_18                       :=   _data_in[2].%X1;       // IB1354.1
            Inputs.DeviceResultBits_2.Tool_19                       :=   _data_in[2].%X2;       // IB1354.2
            Inputs.DeviceResultBits_2.Tool_20                       :=   _data_in[2].%X3;       // IB1354.3
            Inputs.DeviceResultBits_2.Tool_21                       :=   _data_in[2].%X4;       // IB1354.4
            Inputs.DeviceResultBits_2.Tool_22                       :=   _data_in[2].%X5;       // IB1354.5
            Inputs.DeviceResultBits_2.Tool_23                       :=   _data_in[2].%X6;       // IB1354.6
            Inputs.DeviceResultBits_2.Tool_24                       :=   _data_in[2].%X7;       // IB1354.7
            Inputs.DeviceResultBits_2.Tool_25                       :=   _data_in[3].%X0;       // IB1355.0
            Inputs.DeviceResultBits_2.Tool_26                       :=   _data_in[3].%X1;       // IB1355.1
            Inputs.DeviceResultBits_2.Tool_27                       :=   _data_in[3].%X2;       // IB1355.2
            Inputs.DeviceResultBits_2.Tool_28                       :=   _data_in[3].%X3;       // IB1355.3
            Inputs.DeviceResultBits_2.Tool_29                       :=   _data_in[3].%X4;       // IB1355.4
            Inputs.DeviceResultBits_2.Tool_30                       :=   _data_in[3].%X5;       // IB1355.5
            Inputs.DeviceResultBits_2.Tool_31                       :=   _data_in[3].%X6;       // IB1355.6
            Inputs.DeviceResultBits_2.Tool_32                       :=   _data_in[3].%X7;       // IB1355.7
            Inputs.DeviceResultBits_2.Tool_33                       :=   _data_in[4].%X0;       // IB1356.0
            Inputs.DeviceResultBits_2.Tool_34                       :=   _data_in[4].%X1;       // IB1356.1
            Inputs.DeviceResultBits_2.Tool_35                       :=   _data_in[4].%X2;       // IB1356.2
            Inputs.DeviceResultBits_2.Tool_36                       :=   _data_in[4].%X3;       // IB1356.3
            Inputs.DeviceResultBits_2.Tool_37                       :=   _data_in[4].%X4;       // IB1356.4
            Inputs.DeviceResultBits_2.Tool_38                       :=   _data_in[4].%X5;       // IB1356.5
            Inputs.DeviceResultBits_2.Tool_39                       :=   _data_in[4].%X6;       // IB1356.6
            Inputs.DeviceResultBits_2.Tool_40                       :=   _data_in[4].%X7;       // IB1356.7
            Inputs.DeviceResultBits_2.Tool_41                       :=   _data_in[5].%X0;       // IB1357.0
            Inputs.DeviceResultBits_2.Tool_42                       :=   _data_in[5].%X1;       // IB1357.1
            Inputs.DeviceResultBits_2.Tool_43                       :=   _data_in[5].%X2;       // IB1357.2
            Inputs.DeviceResultBits_2.Tool_44                       :=   _data_in[5].%X3;       // IB1357.3
            Inputs.DeviceResultBits_2.Tool_45                       :=   _data_in[5].%X4;       // IB1357.4
            Inputs.DeviceResultBits_2.Tool_46                       :=   _data_in[5].%X5;       // IB1357.5
            Inputs.DeviceResultBits_2.Tool_47                       :=   _data_in[5].%X6;       // IB1357.6
            Inputs.DeviceResultBits_2.Tool_48                       :=   _data_in[5].%X7;       // IB1357.7
            Inputs.DeviceResultBits_2.Tool_49                       :=   _data_in[6].%X0;       // IB1358.0
            Inputs.DeviceResultBits_2.Tool_50                       :=   _data_in[6].%X1;       // IB1358.1
            Inputs.DeviceResultBits_2.Tool_51                       :=   _data_in[6].%X2;       // IB1358.2
            Inputs.DeviceResultBits_2.Tool_52                       :=   _data_in[6].%X3;       // IB1358.3
            Inputs.DeviceResultBits_2.Tool_53                       :=   _data_in[6].%X4;       // IB1358.4
            Inputs.DeviceResultBits_2.Tool_54                       :=   _data_in[6].%X5;       // IB1358.5
            Inputs.DeviceResultBits_2.Tool_55                       :=   _data_in[6].%X6;       // IB1358.6
            Inputs.DeviceResultBits_2.Tool_56                       :=   _data_in[6].%X7;       // IB1358.7
            Inputs.DeviceResultBits_2.Tool_57                       :=   _data_in[7].%X0;       // IB1359.0
            Inputs.DeviceResultBits_2.Tool_58                       :=   _data_in[7].%X1;       // IB1359.1
            Inputs.DeviceResultBits_2.Tool_59                       :=   _data_in[7].%X2;       // IB1359.2
            Inputs.DeviceResultBits_2.Tool_60                       :=   _data_in[7].%X3;       // IB1359.3
            Inputs.DeviceResultBits_2.Tool_61                       :=   _data_in[7].%X4;       // IB1359.4
            Inputs.DeviceResultBits_2.Tool_62                       :=   _data_in[7].%X5;       // IB1359.5
            Inputs.DeviceResultBits_2.Tool_63                       :=   _data_in[7].%X6;       // IB1359.6
            Inputs.DeviceResultBits_2.Tool_64                       :=   _data_in[7].%X7;       // IB1359.7

            //***************************************************************
          
            //*************INITIALIZATION*************
            RestoreTask.Run(THIS);
            TriggerTask.Run(THIS);
            ChangeProgramTask.Run(THIS);
   
            //****************************************
    
            //********************Diagnostics*********        
            HardwareDiagnosticsTask.Run(THIS,Config.HWIDs.HW_Device);
            IF Inputs.CommandStatusBits.Error THEN
                Messenger.Activate(UINT#1800 + Inputs.DeviceStatusWords.ErrorNo, eAxoMessageCategory#Error);
                Status.Error.Id := UINT#1800 + Inputs.DeviceStatusWords.ErrorNo;
            ELSIF Inputs.CommandStatusBits.Warning THEN
                Messenger.Activate(UINT#400 + Inputs.DeviceStatusWords.WarningNo, eAxoMessageCategory#Warning);
                Status.Error.Id := UINT#400 + Inputs.DeviceStatusWords.WarningNo;
            END_IF;
            //****************************************
    
            //*************RESTORE********************
            RestoreTask.IsDisabled := FALSE;
            IF RestoreTask.Execute(THIS) THEN
                THIS.Restore();
            END_IF;
            //****************************************
            
    
            //*************TriggerTask**************
            TriggerTask.SetIsDisabled(FALSE);
            IF TriggerTask.StartTriggered() THEN
                Status.Action.Id :=  UINT#100;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#100,TriggerTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#101,TriggerTask.IsDone(), eAxoMessageCategory#Info);
            IF TriggerTask.Execute(THIS) THEN
                IF _progress = 0 THEN
                    _resultUpdateComplete := Inputs.CommandStatusBits.ResultUpdateComplete;
                    _resultNo := Inputs.DeviceStatusWords.ResultNo;
                    Outputs.CommandControl.TriggerRequest                               := FALSE;
                    Outputs.CommandControl.MasterRegistrationRequest                    := FALSE;
                    Outputs.CommandControl.ProgramSwitchingRequest                      := FALSE;
                    Outputs.CommandControl.WarningClearRequest                          := FALSE;
                    Outputs.CommandControl.StatisticsResetRequest                       := FALSE;
                    Outputs.CommandControl.BufferClearRequest                           := FALSE;
                    Outputs.CommandControl.SdCardSavingStopRequest                      := FALSE;
                    Outputs.CommandControl.SettingValueChangeRequest                    := FALSE;
                    Outputs.CommandControl.ResultAcquisitionCompleteNotification        := FALSE;                    
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 300;
                END_IF;
                // TriggerTask running: waiting for the raising of the 'TriggerReady' signal.
                IF _progress = 300 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#500, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#500;
                    END_IF;

                    IF Inputs.CommandStatusBits.TriggerReady THEN
                        THIS.CallTimers(FALSE);
                        _progress := 301;
                    END_IF;
                END_IF;
                // TriggerTask running: waiting for the raising of the 'TriggerResponse' signal.
                IF _progress = 301 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#501, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#501;
                    END_IF;

                    Outputs.CommandControl.TriggerRequest := TRUE;
    
                    IF Inputs.CommandStatusBits.TriggerResponse THEN
                        THIS.CallTimers(FALSE);
                        _progress := 302;
                    END_IF;
                END_IF;
                // TriggerTask running: waiting for the raising of the 'BUSY' signal.
                IF _progress = 302 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#502, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#502;
                    END_IF;

                    IF Inputs.CommandStatusBits.BUSY THEN
                        THIS.CallTimers(FALSE);
                        _progress := 303;
                    END_IF;
                END_IF;
                // TriggerTask running: waiting for the raising of the 'ImagingStatus' signal.
                IF _progress = 303 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#503, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#503;
                    END_IF;
    
                    IF TRUE OR Inputs.CommandStatusBits.ImagingStatus THEN
                        THIS.CallTimers(FALSE);
                        _progress := 304;
                    END_IF;
                END_IF;
                // TriggerTask running: waiting for the falling of the 'BUSY' signal.
                IF _progress = 304 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#504, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#504;
                    END_IF;

                    Outputs.CommandControl.TriggerRequest := FALSE;

                    IF NOT Inputs.CommandStatusBits.BUSY THEN
                        THIS.CallTimers(FALSE);
                        _progress := 305;
                    END_IF;
                END_IF;
                // TriggerTask running: waiting for the change of the 'ResultUpdateComplete' signal.
                IF _progress = 305 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#505, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#505;
                    END_IF;
    
                    IF Inputs.CommandStatusBits.ResultUpdateComplete <> _resultUpdateComplete THEN
                        THIS.CallTimers(FALSE);
                        _progress := 306;
                    END_IF;
                END_IF;
                // TriggerTask running: waiting for the raising of the 'ResultAvailable' signal.
                IF _progress = 306 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#506, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#506;
                    END_IF;
    
                    IF Inputs.CommandStatusBits.ResultAvailable THEN
                        THIS.CallTimers(FALSE);
                        _progress := 307;
                    END_IF;
                END_IF;
                // TriggerTask running: waiting for the incrementation of the 'ResultNo' signal.
                IF _progress = 307 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#507, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#507;
                    END_IF;

                    IF Inputs.DeviceStatusWords.ResultNo > _resultNo THEN
                        THIS.CallTimers(FALSE);
                        _progress := 308;
                    END_IF;
                END_IF;
                // TriggerTask finished.
                IF _progress = 308 THEN
                    TriggerTask.DoneWhen(TRUE);
                    _progress := 0;
                END_IF;
    
                THIS.CallTimers(TRUE);
                
                TriggerTask.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);  
                TriggerTask.ThrowWhen(TriggerTask.Duration >= Config.TaskTimeout AND Config.TaskTimeout > T#0s ,'<#TriggerTask timeout.#>');                
            END_IF;
            IF TriggerTask.DoneReached() THEN
                Status.Action.Id :=  UINT#101;
                Status.Error.Id :=  UINT#0;
            ELSIF TriggerTask.ErrorOccured() THEN
                Status.Action.Id :=  UINT#10000;
                Status.Error.Id  :=  UINT#10000;
            ELSIF TriggerTask.AbortTriggered()THEN
                Status.Action.Id :=  UINT#10001;
                Status.Error.Id  :=  UINT#10001;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#10000,TriggerTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#10001,TriggerTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#102,TriggerTask.RestoreTriggered() , eAxoMessageCategory#Error);
            IF TriggerTask.RestoreTriggered() AND _progress >= 300 AND _progress <= 309  THEN
                Status.Action.Id :=  UINT#102;
                _progress := 0;
            END_IF;
            //**************************************************
    
            //*************ChangeProgramTask***************
            ChangeProgramTask.SetIsDisabled(FALSE);
            IF ChangeProgramTask.StartTriggered() THEN
                Status.Action.Id :=  UINT#110;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#110,ChangeProgramTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#111,ChangeProgramTask.IsDone(), eAxoMessageCategory#Info);
            IF ChangeProgramTask.Execute(THIS) THEN
                IF _progress = 0 THEN
                    Outputs.CommandControl.TriggerRequest                               := FALSE;
                    Outputs.CommandControl.MasterRegistrationRequest                    := FALSE;
                    Outputs.CommandControl.ProgramSwitchingRequest                      := FALSE;
                    Outputs.CommandControl.WarningClearRequest                          := FALSE;
                    Outputs.CommandControl.StatisticsResetRequest                       := FALSE;
                    Outputs.CommandControl.BufferClearRequest                           := FALSE;
                    Outputs.CommandControl.SdCardSavingStopRequest                      := FALSE;
                    Outputs.CommandControl.SettingValueChangeRequest                    := FALSE;
                    Outputs.CommandControl.ResultAcquisitionCompleteNotification        := FALSE;                    
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 310;
                END_IF;
                // ChangeProgramTask running: checking the program number.
                IF _progress = 310 THEN
                    IF _programNumber <= Config.MaxProgramNumber THEN
                        THIS.CallTimers(FALSE);
                        _progress := 311;
                    ELSE
                        TaskMessenger.Activate( UINT#510, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#510;
                    END_IF;
                END_IF;
                 // ChangeProgramTask running: if 'ProgramSwitchingResponse' signal is true finish previous change.
                IF _progress = 311 THEN 
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#511, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#511;
                    END_IF;

                    IF Inputs.CommandStatusBits.ProgramSwitchingResponse THEN
                        THIS.CallTimers(FALSE);                  
                        _progress := 312; // ACK PREVIOUS CHANGE
                    ELSE
                        THIS.CallTimers(FALSE);
                        _progress := 314; // Continue to change program
                    END_IF;
                END_IF;
                 // evaluated before 312 => +1 plc cycle
                 // ChangeProgramTask running: wait for falling edge ProgramSwitchingResponse
                IF _progress = 313 THEN 
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#513, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#513;
                    END_IF;
    
                    Outputs.CommandControl.ProgramSwitchingRequest     := FALSE;
                    IF NOT Inputs.CommandStatusBits.BUSY  THEN
                        THIS.CallTimers(FALSE);
                        _progress := 311; // +1 plc cycle to check ProgramSwitchingResponse
                    END_IF;
                END_IF;
                // ChangeProgramTask running: wait for program numbers to be equal.
                IF _progress = 312 THEN 
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#513, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#513;
                    END_IF;
    
                    Outputs.CommandControl.ProgramSwitchingRequest     := TRUE;
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 313; //+1 plc cycle to wait for falling edge
                    END_IF;
                END_IF;
                
                // ChangeProgramTask running: setting the new program number.
                IF _progress = 314 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#511, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#511;
                    END_IF;

                    Outputs.CommandControl.ProgramNo := _programNumber;
                    IF Outputs.CommandControl.ProgramNo = Inputs.DeviceStatusWords.CurrentProgramNo THEN
                        THIS.CallTimers(FALSE);
                        _progress := 317;
                    ELSE
                        THIS.CallTimers(FALSE);
                        _progress := 315;
                    END_IF;
                END_IF;
                // ChangeProgramTask running: waiting for the raising of the 'ProgramSwitchingResponse' signal.
                IF _progress = 315 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#512, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#512;
                    END_IF;
    
                    Outputs.CommandControl.ProgramSwitchingRequest     := TRUE;

                    IF Inputs.CommandStatusBits.ProgramSwitchingResponse THEN
                        THIS.CallTimers(FALSE);
                        _progress := 316;
                    END_IF;
                END_IF;
                // ChangeProgramTask running: waiting for the falling of the 'ProgramSwitchingResponse' signal.
                IF _progress = 316 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#513, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#513;
                    END_IF;
    
                    Outputs.CommandControl.ProgramSwitchingRequest  := FALSE;

                    IF NOT Inputs.CommandStatusBits.ProgramSwitchingResponse THEN
                        THIS.CallTimers(FALSE);
                        _progress := 317;
                    END_IF;
                END_IF;

                // ChangeProgramTask running: waiting for equals program change.
                IF _progress = 317 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#513, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#513;
                    END_IF;
    
                    IF (_programNumber = Inputs.DeviceStatusWords.CurrentProgramNo) 
                       AND (Outputs.CommandControl.ProgramNo = Inputs.DeviceStatusWords.CurrentProgramNo) 
                    THEN
                        THIS.CallTimers(FALSE);
                        _progress := 318;
                    END_IF;
                END_IF;

                // ChangeProgramTask finished.
                IF _progress = 318 THEN
                    ChangeProgramTask.DoneWhen(TRUE);
                    _progress := 0;
                END_IF;
    
                THIS.CallTimers(TRUE);
                
                ChangeProgramTask.ThrowWhen(Inputs.CommandStatusBits.ProgramSwitchingFailed,'<#Attempt to change the program failed.#>');
                ChangeProgramTask.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);  
                ChangeProgramTask.ThrowWhen(ChangeProgramTask.Duration >= Config.TaskTimeout AND Config.TaskTimeout > T#0s ,'<#ChangeProgramTask timeout.#>');                
            END_IF;
            IF ChangeProgramTask.DoneReached() THEN
                Status.Action.Id :=  UINT#111;
                Status.Error.Id :=  UINT#0;
            ELSIF ChangeProgramTask.ErrorOccured() THEN
                Status.Action.Id :=  UINT#10010;
                Status.Error.Id  :=  UINT#10010;
            ELSIF ChangeProgramTask.AbortTriggered()THEN
                Status.Action.Id :=  UINT#10011;
                Status.Error.Id  :=  UINT#10011;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#10010,ChangeProgramTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#10011,ChangeProgramTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#112,ChangeProgramTask.RestoreTriggered() , eAxoMessageCategory#Error);
            IF ChangeProgramTask.RestoreTriggered() AND _progress >= 310 AND _progress <= 319  THEN
                Status.Action.Id :=  UINT#112;
                _progress := 0;
            END_IF;
            //**************************************************

            //***********Update outputs ****************
            _data_out_12[0].%X0                  :=      Outputs.CommandControl.TriggerRequest;                        //  QB0.0
            _data_out_12[0].%X1                  :=      Outputs.CommandControl.MasterRegistrationRequest;             //  QB0.1
            _data_out_12[0].%X2                  :=      Outputs.CommandControl.ProgramSwitchingRequest;               //  QB0.2
            _data_out_12[0].%X3                  :=      Outputs.CommandControl.WarningClearRequest;                   //  QB0.3
            _data_out_12[0].%X4                  :=      Outputs.CommandControl.StatisticsResetRequest;                //  QB0.4
            _data_out_12[0].%X5                  :=      Outputs.CommandControl.BufferClearRequest;                    //  QB0.5
            _data_out_12[0].%X6                  :=      Outputs.CommandControl.SdCardSavingStopRequest;               //  QB0.6
            _data_out_12[0].%X7                  :=      Outputs.CommandControl.SettingValueChangeRequest;             //  QB0.7
            _data_out_12[2].%X0                  :=      Outputs.CommandControl.ResultAcquisitionCompleteNotification; //  QB2.0

            _word                                :=      TO_WORD(Outputs.CommandControl.ProgramNo);                    //  QW4
            _data_out_12[4]                      :=      _word.%B1;                                             //  QW4
            _data_out_12[5]                      :=      _word.%B0;                                             //  QW4

            _data_out_12[6]                      :=      Outputs.CommandControl.Function_1.%B1;                         //  QW6
            _data_out_12[7]                      :=      Outputs.CommandControl.Function_1.%B0;                         //  QW6

            _data_out_12[8]                      :=      Outputs.CommandControl.Function_2.%B3;                         //  QD8
            _data_out_12[9]                      :=      Outputs.CommandControl.Function_2.%B2;                         //  QD8
            _data_out_12[10]                     :=      Outputs.CommandControl.Function_2.%B1;                         //  QD8
            _data_out_12[11]                     :=      Outputs.CommandControl.Function_2.%B0;                         //  QD8

            _retVal := Siemens.Simatic.DistributedIO.WriteData((Config.HWIDs.HwID_CommandControl),_data_out_12);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1701, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1701;
                RETURN;
            END_IF;            
            //******************************************      

        END_METHOD

        METHOD PUBLIC Trigger : IAxoTaskState
            Trigger := TriggerTask.Invoke(THIS);
        END_METHOD

        METHOD PUBLIC ChangeProgram : IAxoTaskState
            VAR_INPUT
                inProgramNumber : UINT;
            END_VAR

            // different program loaded in HW - restore task to be able to run it again
            IF ( inProgramNumber <> Inputs.DeviceStatusWords.CurrentProgramNo ) && ChangeProgramTask.IsDone() THEN 
                ChangeProgramTask.Restore();
            END_IF;

            _programNumber := inProgramNumber;
            ChangeProgram := ChangeProgramTask.Invoke(THIS);
        END_METHOD

        METHOD PROTECTED OVERRIDE ManualControl
            THIS._isManuallyControllable := true;
            _programNumber := RequiredProgramNumber;
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

            Outputs.CommandControl.TriggerRequest                               := FALSE;
            Outputs.CommandControl.MasterRegistrationRequest                    := FALSE;
            Outputs.CommandControl.ProgramSwitchingRequest                      := FALSE;
            Outputs.CommandControl.WarningClearRequest                          := FALSE;
            Outputs.CommandControl.StatisticsResetRequest                       := FALSE;
            Outputs.CommandControl.BufferClearRequest                           := FALSE;
            Outputs.CommandControl.SdCardSavingStopRequest                      := FALSE;
            Outputs.CommandControl.SettingValueChangeRequest                    := FALSE;
            Outputs.CommandControl.ResultAcquisitionCompleteNotification        := FALSE;
            Outputs.CommandControl.ProgramNo                                    := UINT#0;
            Outputs.CommandControl.Function_1                                   := WORD#0;
            Outputs.CommandControl.Function_2                                   := DWORD#0;

            FOR _index := 0 TO 11 DO
                _data_in[_index] := BYTE#0;
                _data_out_12[_index] := BYTE#0;
            END_FOR;

            FOR _index := 12 TO 27 DO
                _data_in[_index] := BYTE#0;
            END_FOR;

            _word           :=   WORD#0;
            _dword          :=   DWORD#0;

            TriggerTask.Restore();
            ChangeProgramTask.Restore();
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
