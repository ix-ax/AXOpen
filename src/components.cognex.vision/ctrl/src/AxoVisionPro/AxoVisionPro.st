USING AXOpen.Core;
USING AXOpen.Messaging;
USING AXOpen.Messaging.Static;
USING AXOpen.Components.Abstractions;
USING Siemens.Simatic.Hardware.Utilities;
USING Siemens.Simatic.MemoryAccess;
USING AXOpen.Timers;

NAMESPACE AXOpen.Components.Cognex.Vision
    {S7.extern=ReadWrite}
    CLASS AxoVisionPro EXTENDS AXOpen.Core.AxoComponent
        VAR PUBLIC //Header
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentHeader()]}         
            {#ix-set:AttributeName = "<#Result data#>"}
            {#ix-attr:[ReadOnly()]}
            {#ix-set:DisplayFormat = "string"}
            ResultData  :   AxoVisionPro_ResultData;
            {#ix-attr:[ComponentHeader()]}         
            {#ix-set:AttributeName = "<#User data#>"}
            {#ix-set:DisplayFormat = "string"}
            UserData  :   AxoVisionPro_ResultData;
            {#ix-attr:[ComponentHeader()]}
            {#ix-set:AttributeName = "<#Progress#>"}
            {#ix-attr:[ReadOnly()]}
            Progress : INT;
        END_VAR

        VAR PUBLIC // TASKS
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#Restore#>"}
            RestoreTask : AXOpen.Core.AxoTask;
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#Hard reset all cameras#>"}
            HardResetAllCamerasTask : AXOpen.Core.AxoTask;
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#Reset#>"}
            ResetTask : AXOpen.Core.AxoTask;
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#Trigger #>"}
            TriggerTask : AXOpen.Core.AxoTask;
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#ReadResults#>"}
            ReadResultsTask : AXOpen.Core.AxoTask;
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#ReadResults job ID  (service mode)#>"}
            ReadResultsJobIDServiceMode       :   BYTE;
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#ReadResults length (service mode)#>"}
            ReadResultsLengthServiceMode      :   UINT;
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#SendData#>"}
            SendDataTask : AXOpen.Core.AxoTask;
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#SendData inspection type (service mode)#>"}
            SendDataInspectionTypeServiceMode  :   BYTE;   // (0 = Undefined, 1 = Zmena jobu/referencie, 2=Nacitanie
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#SendData BufferID (service mode)#>"}
            SendDataBufferIDServiceMode  :   BYTE;  // Buffer ID, 0-9
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#SendResults job ID  (service mode)#>"}
            SendResultsJobIDServiceMode       :   BYTE;
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#SendResults length (service mode)#>"}
            SendResultsLengthServiceMode      :   UINT;
        END_VAR
        
        VAR PUBLIC // CONFIG
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("Config")]}
            {#ix-attr:[ReadOnly()]}
            Config  :   AxoVisionPro_Config;
        END_VAR

        VAR PUBLIC // STATUS
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("Status")]}
            {#ix-attr:[ReadOnly()]}
            Status              :   AxoVisionPro_Component_Status;
            Messenger           :   AXOpen.Messaging.Static.AxoMessenger;
            TaskMessenger       :   AXOpen.Messaging.Static.AxoMessenger;
        END_VAR    

        VAR PUBLIC // HARDWARE SIGNALS
            {#ix-attr:[ComponentDetails("HARDWARE SIGNALS")]}
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Inputs#>"}
            {#ix-attr:[ReadOnly()]}
            Inputs              :  AxoVisionPro_In;
            {#ix-attr:[ComponentDetails("HARDWARE SIGNALS")]}
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Outputs#>"}
            {#ix-attr:[ReadOnly()]} 
            Outputs              :   AxoVisionPro_Out;
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
            _data_in_1301   :   ARRAY[0..1300] OF BYTE;
            _data_out_1301  :   ARRAY[0..1300] OF BYTE;

            _initHwCheckDone        :   BOOL;
            _retval                 :   WORD;
            _geoAddr                :   GeoAddr;
            _startAddress           :   UDINT;
            _bytesCount             :   UINT;
            _Clock_1Hz              :   AxoBlinker;
            _readResultsJobID       :   BYTE;
            _readResultsLength      :   UINT;
            _data_                  :   ARRAY[0..1300] OF BYTE;
            _data_out               :   ARRAY[0..1300] OF BYTE;
            _sendDataInspectionType :   BYTE;
            _sendDataBufferID       :   BYTE;
            _sendDataJobID          :   BYTE;
            _sendDataLength         :   UINT;
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
                inParent      :   IAxoObject;
                hwID        :   UINT;
                CameraNo    :   BYTE;
            END_VAR
			VAR_TEMP 
                SeparatorPos : INT;
                inputsAddress : UDINT;
                inputsCount : UINT;
                outputsAddress : UDINT;
                outputsCount : UINT;
                retValRdAddr : WORD;
                i : Int;
                BitOffset : Int;
                LogGeoData_retval : WORD;
                _tmpWord : WORD;

                index : UINT;

            END_VAR
            
            Progress := _progress;

            SUPER.Run(inParent);

            Messenger.Serve(THIS);

            IF NOT _initHwCheckDone THEN
                IF inParent = NULL THEN
                    Messenger.Activate(ULINT#700, eAxoMessageCategory#ProgrammingError);
                    Status.Error.Id := UINT#700;
                    RETURN;
                END_IF;
                Config.HWIDs.HW_Device  := hwID;
                IF Config.HWIDs.HW_Device = UINT#0 THEN
                    Messenger.Activate(ULINT#701, eAxoMessageCategory#ProgrammingError);
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
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HW_SystemControl);        
                IF Config.HWIDs.HW_SystemControl = UINT#0 THEN
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
                ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HW_SystemControl) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#16 OR _outputsCount <> UINT#16 THEN
                    Messenger.Activate(UINT#716,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#716;
                    RETURN;
                END_IF;
                //******************Slot 2*****************//
                _geoAddr.Slot   :=  UINT#2;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)                                                      
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HW_EngineControl_1);        
                IF Config.HWIDs.HW_EngineControl_1 = UINT#0 THEN
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
                ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HW_EngineControl_1) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#8 OR _outputsCount <> UINT#1 THEN
                    Messenger.Activate(UINT#726,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#726;
                    RETURN;
                END_IF;
                //******************Slot 3*****************//
                _geoAddr.Slot   :=  UINT#3;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)                                                      
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HW_EngineControl_2);        
                IF Config.HWIDs.HW_EngineControl_2 = UINT#0 THEN
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
                ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HW_EngineControl_2) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#8 OR _outputsCount <> UINT#1 THEN
                    Messenger.Activate(UINT#736,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#736;
                    RETURN;
                END_IF;
                //******************Slot 4*****************//
                _geoAddr.Slot   :=  UINT#4;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)                                                      
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HW_EngineControl_3);        
                IF Config.HWIDs.HW_EngineControl_3 = UINT#0 THEN
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
                ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HW_EngineControl_3) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#8 OR _outputsCount <> UINT#1 THEN
                    Messenger.Activate(UINT#746,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#746;
                    RETURN;
                END_IF;
                //******************Slot 5*****************//
                _geoAddr.Slot   :=  UINT#5;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)                                                      
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HW_EngineControl_4);        
                IF Config.HWIDs.HW_EngineControl_4 = UINT#0 THEN
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
                ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HW_EngineControl_4) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#8 OR _outputsCount <> UINT#1 THEN
                    Messenger.Activate(UINT#756,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#756;
                    RETURN;
                END_IF;
                //******************Slot 6*****************//
                _geoAddr.Slot   :=  UINT#6;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)                                                      
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HW_UserData_240B_1);        
                IF Config.HWIDs.HW_UserData_240B_1 = UINT#0 THEN
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
                ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HW_UserData_240B_1) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#0 OR _outputsCount <> UINT#240 THEN
                    Messenger.Activate(UINT#766,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#766;
                    RETURN;
                END_IF;
                //******************Slot 7*****************//
                _geoAddr.Slot   :=  UINT#7;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)                                                      
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HW_UserData_240B_2);        
                IF Config.HWIDs.HW_UserData_240B_2 = UINT#0 THEN
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
                ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HW_UserData_240B_2) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#0 OR _outputsCount <> UINT#240 THEN
                    Messenger.Activate(UINT#776,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#776;
                    RETURN;
                END_IF;
                //******************Slot 8*****************//
                _geoAddr.Slot   :=  UINT#8;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)                                                      
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HW_UserData_240B_3);        
                IF Config.HWIDs.HW_UserData_240B_3 = UINT#0 THEN
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
                ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HW_UserData_240B_3) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#0 OR _outputsCount <> UINT#240 THEN
                    Messenger.Activate(UINT#786,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#786;
                    RETURN;
                END_IF;
                //******************Slot 9*****************//
                _geoAddr.Slot   :=  UINT#9;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)                                                      
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HW_UserData_240B_4);        
                IF Config.HWIDs.HW_UserData_240B_4 = UINT#0 THEN
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
                ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HW_UserData_240B_4) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#0 OR _outputsCount <> UINT#240 THEN
                    Messenger.Activate(UINT#796,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#796;
                    RETURN;
                END_IF;
                //******************Slot 10*****************//
                _geoAddr.Slot   :=  UINT#10;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)                                                      
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HW_UserData_240B_5);        
                IF Config.HWIDs.HW_UserData_240B_5 = UINT#0 THEN
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
                ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HW_UserData_240B_5) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#0 OR _outputsCount <> UINT#240 THEN
                    Messenger.Activate(UINT#806,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#806;
                    RETURN;
                END_IF;
                //******************Slot 11*****************//
                _geoAddr.Slot   :=  UINT#11;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)                                                      
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HW_UserData_64B_1);        
                IF Config.HWIDs.HW_UserData_64B_1 = UINT#0 THEN
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
                ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HW_UserData_64B_1) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#0 OR _outputsCount <> UINT#64 THEN
                    Messenger.Activate(UINT#816,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#816;
                    RETURN;
                END_IF;
                //******************Slot 12*****************//
                _geoAddr.Slot   :=  UINT#12;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)                                                      
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HW_Results_240B_1);        
                IF Config.HWIDs.HW_Results_240B_1 = UINT#0 THEN
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
                ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HW_Results_240B_1) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#240 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#826,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#826;
                    RETURN;
                END_IF;
                //******************Slot 13*****************//
                _geoAddr.Slot   :=  UINT#13;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)                                                      
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HW_Results_240B_2);        
                IF Config.HWIDs.HW_Results_240B_2 = UINT#0 THEN
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
                ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HW_Results_240B_2) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#240 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#836,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#836;
                    RETURN;
                END_IF;
                //******************Slot 14*****************//
                _geoAddr.Slot   :=  UINT#14;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)                                                      
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HW_Results_240B_3);        
                IF Config.HWIDs.HW_Results_240B_3 = UINT#0 THEN
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
                ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HW_Results_240B_3) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#240 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#846,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#846;
                    RETURN;
                END_IF;
                //******************Slot 15*****************//
                _geoAddr.Slot   :=  UINT#15;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)                                                      
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HW_Results_240B_4);        
                IF Config.HWIDs.HW_Results_240B_4 = UINT#0 THEN
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
                ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HW_Results_240B_4) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#240 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#856,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#856;
                    RETURN;
                END_IF;
                //******************Slot 16*****************//
                _geoAddr.Slot   :=  UINT#16;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)                                                      
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HW_Results_240B_5);        
                IF Config.HWIDs.HW_Results_240B_5 = UINT#0 THEN
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
                ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HW_Results_240B_5) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#240 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#866,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#866;
                    RETURN;
                END_IF;
                //******************Slot 17*****************//
                _geoAddr.Slot   :=  UINT#17;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)                                                      
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HW_Results_64B_1);        
                IF Config.HWIDs.HW_Results_64B_1 = UINT#0 THEN
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
                ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HW_Results_64B_1) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#64 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#876,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#876;
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
            
                IF Config.HWIDs.HW_SystemControl  = UINT#0 THEN
                    Messenger.Activate(UINT#1132,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1132;
                    RETURN;
                END_IF;
            
                IF Config.HWIDs.HW_EngineControl_1  = UINT#0 THEN
                    Messenger.Activate(UINT#1133,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1133;
                    RETURN;
                END_IF;
            
                IF Config.HWIDs.HW_EngineControl_2  = UINT#0 THEN
                    Messenger.Activate(UINT#1134,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1134;
                    RETURN;
                END_IF;

                IF Config.HWIDs.HW_EngineControl_3  = UINT#0 THEN
                    Messenger.Activate(UINT#1135,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1135;
                    RETURN;
                END_IF;
            
                IF Config.HWIDs.HW_EngineControl_4  = UINT#0 THEN
                    Messenger.Activate(UINT#1136,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1136;
                    RETURN;
                END_IF;
            
                IF Config.HWIDs.HW_UserData_240B_1  = UINT#0 THEN
                    Messenger.Activate(UINT#1137,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1137;
                    RETURN;
                END_IF;
            
                IF Config.HWIDs.HW_UserData_240B_2  = UINT#0 THEN
                    Messenger.Activate(UINT#1138,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1138;
                    RETURN;
                END_IF;
            
                IF Config.HWIDs.HW_UserData_240B_3  = UINT#0 THEN
                    Messenger.Activate(UINT#1139,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1139;
                    RETURN;
                END_IF;
            
                IF Config.HWIDs.HW_UserData_240B_4  = UINT#0 THEN
                    Messenger.Activate(UINT#1140,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1140;
                    RETURN;
                END_IF;

                IF Config.HWIDs.HW_UserData_240B_5  = UINT#0 THEN
                    Messenger.Activate(UINT#1141,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1141;
                    RETURN;
                END_IF;
            
                IF Config.HWIDs.HW_UserData_64B_1  = UINT#0 THEN
                    Messenger.Activate(UINT#1142,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1142;
                    RETURN;
                END_IF;
            
                IF Config.HWIDs.HW_Results_240B_1  = UINT#0 THEN
                    Messenger.Activate(UINT#1143,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1143;
                    RETURN;
                END_IF;
            
                IF Config.HWIDs.HW_Results_240B_2  = UINT#0 THEN
                    Messenger.Activate(UINT#1144,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1144;
                    RETURN;
                END_IF;
            
                IF Config.HWIDs.HW_Results_240B_3  = UINT#0 THEN
                    Messenger.Activate(UINT#1145,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1145;
                    RETURN;
                END_IF;
            
                IF Config.HWIDs.HW_Results_240B_4  = UINT#0 THEN
                    Messenger.Activate(UINT#1146,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1146;
                    RETURN;
                END_IF;

                IF Config.HWIDs.HW_Results_240B_5  = UINT#0 THEN
                    Messenger.Activate(UINT#1147,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1147;
                    RETURN;
                END_IF;
            
                IF Config.HWIDs.HW_Results_64B_1  = UINT#0 THEN
                    Messenger.Activate(UINT#1148,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1148;
                    RETURN;
                END_IF;

                _initHwCheckDone    := TRUE;
            END_IF;            

            //***********Update inputs **************

			Config.CameraNo := CameraNo;

			IF Config.CameraNo < BYTE#1 THEN
                Messenger.Activate(UINT#1301, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1301;
                RETURN;
            END_IF;

            IF Config.CameraNo > BYTE#8 THEN
                Messenger.Activate(UINT#1302, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1302;
                RETURN;
            END_IF;

			retValRdAddr := ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HW_SystemControl),inputStartAddress=> inputsAddress,inputCount => inputsCount,outputStartAddress => outputsAddress,outputCount=> outputsCount);//(LADDR := Component.HW.HW_SystemControl, PIADDR => inputsAddress, PICount => inputsCount, PQADDR => outputsAddress, PQCount => outputsCount);
			
			IF CameraNo = BYTE#1 THEN
					inputsAddress := inputsAddress + UDINT#8;
					BitOffset := 0;
            ELSIF CameraNo = BYTE#2 THEN
					inputsAddress := inputsAddress + UDINT#8;
					BitOffset := 4;
			ELSIF CameraNo = BYTE#3 THEN
					inputsAddress := inputsAddress + UDINT#9;
					BitOffset := 0;
			ELSIF CameraNo = BYTE#4 THEN
					inputsAddress := inputsAddress + UDINT#9;
					BitOffset := 4;
			ELSIF CameraNo = BYTE#5 THEN
					inputsAddress := inputsAddress + UDINT#10;
					BitOffset := 0;
			ELSIF CameraNo = BYTE#6 THEN
					inputsAddress := inputsAddress + UDINT#10;
					BitOffset := 4;
			ELSIF CameraNo = BYTE#7 THEN
					inputsAddress := inputsAddress + UDINT#11;
					BitOffset := 0;
			ELSIF CameraNo = BYTE#8 THEN
					inputsAddress := inputsAddress + UDINT#11;
					BitOffset := 4;
            END_IF;

            ReadMemory(area := ReadArea#Input,byteOffset := TO_DINT(inputsAddress), bitOffset := BitOffset, value => Inputs.Status.SoftEvent.ResetAck );
			ReadMemory(area := ReadArea#Input,byteOffset := TO_DINT(inputsAddress), bitOffset := (BitOffset + INT#1),value => Inputs.Status.SoftEvent.DataHandlerDone);	
			ReadMemory(area := ReadArea#Input,byteOffset := TO_DINT(inputsAddress), bitOffset := (BitOffset + INT#2),value => Inputs.Status.SoftEvent.TriggerAck);		
			ReadMemory(area := ReadArea#Input,byteOffset := TO_DINT(inputsAddress), bitOffset := (BitOffset + INT#3),value => Inputs.Status.SoftEvent.Reserve);		

            retValRdAddr := ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HW_SystemControl),inputStartAddress=> inputsAddress,inputCount => inputsCount,outputStartAddress => outputsAddress,outputCount=> outputsCount); 
			ReadMemory(area := ReadArea#Input,byteOffset := TO_DINT(inputsAddress), bitOffset := INT#0, value => Inputs.Status.SystemReady);
			ReadMemory(area := ReadArea#Input,byteOffset := TO_DINT(inputsAddress), bitOffset := INT#1, value => Inputs.Status.SystemBusy); 
			ReadMemory(area := ReadArea#Input,byteOffset := TO_DINT(inputsAddress), bitOffset := INT#7, value => Inputs.Status.Online); 
			ReadMemory(area := ReadArea#Input,byteOffset := TO_DINT(inputsAddress + UDINT#1), bitOffset := INT#5, value => Inputs.Status.JobLoadComplete); 
			//nacitanie user dat pre kontrolu.. ci a ako to nastavili ine kamery. 
			ReadMemory(area := ReadArea#Input, byteOffset := TO_DINT(inputsAddress) + DINT#4, value => Inputs.Status.CurentJobID ); 
			Inputs.Status.ReadDataLockerJobID := TO_BYTE(TO_INT(Inputs.Status.CurentJobID) / INT#10);
			
			retValRdAddr := ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HW_EngineControl_1),inputStartAddress=> inputsAddress,inputCount => inputsCount,outputStartAddress => outputsAddress,outputCount=> outputsCount); 
			ReadMemory(area := ReadArea#Input,byteOffset := TO_DINT(inputsAddress), bitOffset := INT#5, value => Inputs.Status.ResultValid); 
			ReadMemory(area := ReadArea#Input,byteOffset := TO_DINT(inputsAddress) + DINT#4, value => Inputs.Status.ID_Inspection);
			ReadMemory(area := ReadArea#Input,byteOffset := TO_DINT(inputsAddress) + DINT#1, bitOffset := INT#0, value => Inputs.Status.SetUserDataAck); 
			
			//nacitanie user dat pre kontrolu.. ci a ako to nastavili ine kamery. 
			retValRdAddr := ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HW_UserData_240B_1),inputStartAddress=> inputsAddress,inputCount => inputsCount,outputStartAddress => outputsAddress,outputCount=> outputsCount); 
    		ReadMemory(area := ReadArea#Output,byteOffset := TO_DINT(outputsAddress), value => Inputs.Status.UserDataJobID); 
            Inputs.Status.UserDataLockerJobID := TO_BYTE(TO_UINT(Inputs.Status.UserDataJobID) / UINT#10);  
            ReadMemory(area := ReadArea#Output,byteOffset := TO_DINT(outputsAddress) + DINT#1, value => Inputs.Status.UserDataLockerIdOperation);
		
            //*************INITIALIZATION*************
            RestoreTask.Run(THIS);
            HardResetAllCamerasTask.Run(THIS);
            ResetTask.Run(THIS);
            TriggerTask.Run(THIS);
            ReadResultsTask.Run(THIS);
            SendDataTask.Run(THIS);
            
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
    
            //*************HardResetAllCamerasTask**************
            HardResetAllCamerasTask.SetIsDisabled(FALSE);
            IF HardResetAllCamerasTask.StartTriggered() THEN
                Status.Action.Id :=  UINT#100;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#100,HardResetAllCamerasTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#101,HardResetAllCamerasTask.IsDone(), eAxoMessageCategory#Info);
            IF HardResetAllCamerasTask.Execute(THIS) THEN
                IF _progress = 0 THEN
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 300;
                END_IF;
                // HardResetAllCamerasTask running: waiting for the job id set.
                IF _progress = 300 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#500, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#500;
                    END_IF;
                    		
                    Outputs.Control.SoftEvent.Trigger := FALSE;
                    Outputs.Control.SoftEvent.DataHandlerAck := FALSE;
                    Outputs.Control.SetUserdata := FALSE;
                    Outputs.Control.InitiateJobLoad := FALSE;
                    Outputs.Control.InspectionResultsAck := FALSE;
               
                    retValRdAddr := ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HW_UserData_240B_1),inputStartAddress=> inputsAddress,inputCount => inputsCount,outputStartAddress => outputsAddress,outputCount=> outputsCount); 

                    WriteMemory(area := WriteArea#Output,byteOffset := TO_DINT(outputsAddress),value:= BYTE#0);
                    WriteMemory(area := WriteArea#Output,byteOffset := TO_DINT(outputsAddress) + DINT#1,value:= BYTE#0);
                    WriteMemory(area := WriteArea#Output,byteOffset := TO_DINT(outputsAddress) + DINT#2,value:= BYTE#0);
                    Outputs.Control.JobLoadID := WORD#0; 
                    
                    retValRdAddr := ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HW_SystemControl),inputStartAddress=> inputsAddress,inputCount => inputsCount,outputStartAddress => outputsAddress,outputCount=> outputsCount); 
                    
                    WriteMemory(area := WriteArea#Output,byteOffset := TO_DINT(outputsAddress), bitOffset := INT#4, value:= FALSE);

                    
                    retValRdAddr := ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HW_SystemControl),inputStartAddress=> inputsAddress,inputCount => inputsCount,outputStartAddress => outputsAddress,outputCount=> outputsCount); 
                    
                    WriteMemory(area := WriteArea#Output,byteOffset := TO_DINT(outputsAddress) + DINT#2,value:= WORD#0);
                    
                    retValRdAddr := ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HW_EngineControl_1),inputStartAddress=> inputsAddress,inputCount => inputsCount,outputStartAddress => outputsAddress,outputCount=> outputsCount); 
                    
                    WriteMemory(area := WriteArea#Output,byteOffset := TO_DINT(outputsAddress), bitOffset := INT#1, value:= FALSE);                    

                    IF Inputs.Status.CurentJobID > WORD#0 THEN 
                        THIS.CallTimers(FALSE);
                        _progress := 301;
                    ELSE
                        _progress := 302;
                    END_IF;
                END_IF;
                // HardResetAllCamerasTask running: waiting for the job id cleared.
                IF _progress = 301 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#501, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#501;
                    END_IF;
    
                    _Clock_1Hz.Blink(THIS,TIME#500MS,TIME#500MS);
                    WriteMemory(area := WriteArea#Output,byteOffset := TO_DINT(outputsAddress), bitOffset := INT#4, value:= _Clock_1Hz.output);

                    IF Inputs.Status.CurentJobID = WORD#0  THEN
                        WriteMemory(area := WriteArea#Output,byteOffset := TO_DINT(outputsAddress), bitOffset := INT#4, value:= FALSE);
                        THIS.CallTimers(FALSE);
                        _progress := 302;
                    END_IF;
                END_IF;
                // HardResetAllCamerasTask finished.
                IF _progress = 302 THEN 
                    HardResetAllCamerasTask.DoneWhen(TRUE);
                    _progress := 0;
                END_IF;
    
                THIS.CallTimers(TRUE);
                
                HardResetAllCamerasTask.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);  
                HardResetAllCamerasTask.ThrowWhen(HardResetAllCamerasTask.Duration >= Config.TaskTimeout AND Config.TaskTimeout > T#0s ,'<#HardResetAllCamerasTask timeout.#>');
            END_IF;
            IF HardResetAllCamerasTask.DoneReached() THEN
                Status.Action.Id :=  UINT#101;
                Status.Error.Id :=  UINT#0;
            ELSIF HardResetAllCamerasTask.ErrorOccured() THEN
                Status.Action.Id :=  UINT#10000;
                Status.Error.Id  :=  UINT#10000;
            ELSIF HardResetAllCamerasTask.AbortTriggered()THEN
                Status.Action.Id :=  UINT#10001;
                Status.Error.Id  :=  UINT#10001;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#10000,HardResetAllCamerasTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#10001,HardResetAllCamerasTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#102,HardResetAllCamerasTask.RestoreTriggered() , eAxoMessageCategory#Error);
            IF HardResetAllCamerasTask.RestoreTriggered() AND _progress >= 300 AND _progress <= 309  THEN
                Status.Action.Id :=  UINT#102;
                _progress := 0;
            END_IF;
            //**************************************************
    
            //*************ResetTask***************
            ResetTask.SetIsDisabled(FALSE);
            IF ResetTask.StartTriggered() THEN
                Status.Action.Id :=  UINT#110;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#110,ResetTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#111,ResetTask.IsDone(), eAxoMessageCategory#Info);
            IF ResetTask.Execute(THIS) THEN
                IF _progress = 0 THEN
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 310;
                END_IF;
                // ResetTask running: checking if the data buffer is free.
                IF _progress = 310 THEN                                                                                     
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#510, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#510;
                    END_IF;
    
                    Outputs.Control.SoftEvent.Trigger := FALSE;
                    Outputs.Control.SoftEvent.DataHandlerAck := FALSE;
                    Outputs.Control.SetUserdata := FALSE;
                    Outputs.Control.InitiateJobLoad := FALSE;
                    Outputs.Control.InspectionResultsAck := FALSE;
                    Inputs.Status.ReadedDataVariantSize := UINT#0;
                    Inputs.Status.WrittenDataVariantSize := UINT#0;
                    
                    IF (Inputs.Status.UserDataLockerJobID = (Config.CameraNo)) OR  (Inputs.Status.UserDataLockerJobID = BYTE#0) THEN  
                        THIS.CallTimers(FALSE);
                        _progress := 311;
                    ELSE
                        THIS.CallTimers(FALSE);
                        _progress := 312;
                    END_IF;
                END_IF;
                // ResetTask running: writing the user data.
                IF _progress = 311 THEN   
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#511, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#511;
                    END_IF;
    
                    retValRdAddr := ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HW_UserData_240B_1),inputStartAddress=> inputsAddress,inputCount => inputsCount,outputStartAddress => outputsAddress,outputCount=> outputsCount); 
                    WriteMemory(area := WriteArea#Output,byteOffset := TO_DINT(outputsAddress),value:= BYTE#0);

                    //zapisovanie dat pre kameru, ]: typ spracovania dat (0 = Undefined, 1 = Zmena jobu/referencie, 2=Nacitanie parametrov0, 3=Nacitanie paramterov1,…)
                    WriteMemory(area := WriteArea#Output,byteOffset := TO_DINT(outputsAddress) + DINT#1,value:= BYTE#0);
                    WriteMemory(area := WriteArea#Output,byteOffset := TO_DINT(outputsAddress) + DINT#2,value:= BYTE#0);
                    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 312;
                    END_IF;
                END_IF;
                // ResetTask running: checking if the data buffer is free.
                IF _progress = 312 THEN                           
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#512, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#512;
                    END_IF;
    
                    IF (Inputs.Status.ReadDataLockerJobID = TO_WORD(Config.CameraNo)) OR (Inputs.Status.ReadDataLockerJobID = WORD#0) THEN 
                        THIS.CallTimers(FALSE);
                        _progress := 313;
                    ELSE
                        THIS.CallTimers(FALSE);
                        _progress := 314;
                    END_IF;
                END_IF;
                // ResetTask running: releasing the data buffer.
                IF _progress = 313 THEN                           
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#513, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#513;
                    END_IF;
    
                    Inputs.Status.ReadDataLockerJobID   := BYTE#0;  
                    Outputs.Control.JobLoadID           := WORD#0;  
                    
                    retValRdAddr := ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HW_SystemControl),inputStartAddress=> inputsAddress,inputCount => inputsCount,outputStartAddress => outputsAddress,outputCount=> outputsCount); 
                    WriteMemory(area := WriteArea#Output,byteOffset := TO_DINT(outputsAddress),bitOffset := INT#4,value:= FALSE);
                    WriteMemory(area := WriteArea#Output,byteOffset := TO_DINT(outputsAddress) + DINT#2,value:= WORD#0);
                    
                    retValRdAddr := ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HW_EngineControl_1),inputStartAddress=> inputsAddress,inputCount => inputsCount,outputStartAddress => outputsAddress,outputCount=> outputsCount); 
                    WriteMemory(area := WriteArea#Output,byteOffset := TO_DINT(outputsAddress),bitOffset := INT#1,value:= FALSE);
                         
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 314;
                    END_IF;
                END_IF;
                // ResetTask finished.
                IF _progress = 314 THEN
                    ResetTask.DoneWhen(TRUE);
                    _progress := 0;
                END_IF;
    
                THIS.CallTimers(TRUE);
                
                ResetTask.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);  
                ResetTask.ThrowWhen(ResetTask.Duration >= Config.TaskTimeout AND Config.TaskTimeout > T#0s ,'<#ResetTask timeout.#>');
            END_IF;
            IF ResetTask.DoneReached() THEN
                Status.Action.Id :=  UINT#111;
                Status.Error.Id :=  UINT#0;
            ELSIF ResetTask.ErrorOccured() THEN
                Status.Action.Id :=  UINT#10010;
                Status.Error.Id  :=  UINT#10010;
            ELSIF ResetTask.AbortTriggered()THEN
                Status.Action.Id :=  UINT#10011;
                Status.Error.Id  :=  UINT#10011;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#10010,ResetTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#10011,ResetTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#112,ResetTask.RestoreTriggered() , eAxoMessageCategory#Error);
            IF ResetTask.RestoreTriggered() AND _progress >= 310 AND _progress <= 319  THEN
                Status.Action.Id :=  UINT#112;
                _progress := 0;
            END_IF;
            //**************************************************
    
            //*************TriggerTask***************
            TriggerTask.SetIsDisabled(FALSE);
            IF TriggerTask.StartTriggered() THEN
                Status.Action.Id :=  UINT#120;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#120,TriggerTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#121,TriggerTask.IsDone(), eAxoMessageCategory#Info);
            IF TriggerTask.Execute(THIS) THEN
                IF _progress = 0 THEN
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 320;
                END_IF;
                // TriggerTask running: waiting for the system to be ready.
                IF _progress = 320 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#520, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#520;
                    END_IF;
    
                    Outputs.Control.SoftEvent.Trigger := FALSE;
                    Outputs.Control.SoftEvent.Reset := FALSE;
                    Outputs.Control.SoftEvent.DataHandlerAck := FALSE;

                    IF Inputs.Status.SystemReady THEN
                        THIS.CallTimers(FALSE);
                        _progress := 321;
                    END_IF;
                END_IF;
                // TriggerTask running: waiting for the system to be online.
                IF _progress = 321 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#521, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#521;
                    END_IF;
    
                    IF Inputs.Status.Online THEN
                        THIS.CallTimers(FALSE);
                        _progress := 322;
                    END_IF;
                END_IF;
                // TriggerTask running: reseting camera before trigger started.                
                IF _progress = 322 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#522, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#522;
                    END_IF;
    
                    Outputs.Control.SoftEvent.Reset := TRUE;
				
                    IF (Inputs.Status.SoftEvent.ResetAck ) THEN
                        Outputs.Control.SoftEvent.Reset  := FALSE;
                        THIS.CallTimers(FALSE);
                        _progress := 323;
                    END_IF;
                END_IF;
                // TriggerTask running: reseting the trigger.
                IF _progress = 323 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#523, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#523;
                    END_IF;
    
                    IF NOT Inputs.Status.SoftEvent.TriggerAck THEN
                        Outputs.Control.SoftEvent.Trigger := TRUE;
                        THIS.CallTimers(FALSE);
                        _progress := 324;
                    END_IF;
                END_IF;
                // TriggerTask running: setting the trigger and waiting for acknowledgement.
                IF _progress = 324 THEN                                                
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#524, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#524;
                    END_IF;
    
                    IF Inputs.Status.SoftEvent.TriggerAck THEN
                        Outputs.Control.SoftEvent.Trigger := FALSE;
                        THIS.CallTimers(FALSE);
                        _progress := 325;
                    END_IF;
                END_IF;
                // TriggerTask running: resetting the trigger and waiting for acknowledgment to fall.
                IF _progress = 325 THEN                                                              
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#525, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#525;
                    END_IF;
    
                    IF NOT Inputs.Status.SoftEvent.TriggerAck THEN
                        THIS.CallTimers(FALSE);
                        _progress := 326;
                    END_IF;
                END_IF;
                // TriggerTask finished.
                IF _progress = 326 THEN
                    TriggerTask.DoneWhen(TRUE);
                    _progress := 0;
                END_IF;
    
                THIS.CallTimers(TRUE);
                
                TriggerTask.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);  
                TriggerTask.ThrowWhen(TriggerTask.Duration >= Config.TaskTimeout AND Config.TaskTimeout > T#0s ,'<#TriggerTask timeout.#>');
            END_IF;
            IF TriggerTask.DoneReached() THEN
                Status.Action.Id :=  UINT#121;
                Status.Error.Id :=  UINT#0;
            ELSIF TriggerTask.ErrorOccured() THEN
                Status.Action.Id :=  UINT#10020;
                Status.Error.Id  :=  UINT#10020;
            ELSIF TriggerTask.AbortTriggered()THEN
                Status.Action.Id :=  UINT#10021;
                Status.Error.Id  :=  UINT#10021;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#10020,TriggerTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#10021,TriggerTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#122,TriggerTask.RestoreTriggered() , eAxoMessageCategory#Error);
            IF TriggerTask.RestoreTriggered() AND _progress >= 320 AND _progress <= 329  THEN
                Status.Action.Id :=  UINT#122;
                _progress := 0;
            END_IF;
            //**************************************************
    
            //*************ReadResultsTask***************
            ReadResultsTask.SetIsDisabled(FALSE);
            IF ReadResultsTask.StartTriggered() THEN
                Status.Action.Id :=  UINT#160;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#160,ReadResultsTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#161,ReadResultsTask.IsDone(), eAxoMessageCategory#Info);
            IF ReadResultsTask.Execute(THIS) THEN
                IF _progress = 0 THEN
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 360;
                END_IF;
                // ReadResultsTask running: waiting for the system to be ready.
                IF _progress = 360 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#560, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#560;
                    END_IF;
    
                    IF Inputs.Status.SystemReady THEN
                        THIS.CallTimers(FALSE);
                        _progress := 361;
                    END_IF;
                END_IF;
                // ReadResultsTask running: waiting for the system to be online.
                IF _progress = 361 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#561, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#561;
                    END_IF;
    
                    IF Inputs.Status.Online THEN
                        THIS.CallTimers(FALSE);
                        _progress := 362;
                    END_IF;
                END_IF;
                // ReadResultsTask running: checking the correct JobId.
                IF _progress = 362 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#562, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#562;
                    END_IF;
    
                    IF (_readResultsJobID >= BYTE#0) AND (_readResultsJobID < BYTE#10) THEN
                        THIS.CallTimers(FALSE);
                        _progress := 363;
                    END_IF;
                END_IF;
                // ReadResultsTask running: waiting for the data buffer is free.
                IF _progress = 363 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#563, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#563;
                    END_IF;

                    // PLC nastavi na User Data ID inspekcie, ID operacie a User Data (cislo jobu, seriove cislo kusu, tolerancie).
                    // V dalsom kroku nastavi SetUserData bit a caka na potrvdenie prevzatia dat pomocou UserDataAck.
                    // Akonahle dostane UserDataAck, moze resetnut SetUserData bit a UserData prepisovat pre inu inspekciu.
                
                    IF (Inputs.Status.ReadDataLockerJobID = BYTE#0 OR (Inputs.Status.ReadDataLockerJobID = Config.CameraNo))
                        AND (NOT Inputs.Status.JobLoadComplete) THEN
                        
                        Outputs.Control.JobLoadID := TO_BYTE(TO_UINT(_readResultsJobID) + (TO_UINT(Config.CameraNo) * UINT#10)); //nastavenie ID podla jobuID 50-59 pre kameru 5
                        retValRdAddr := ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HW_SystemControl),inputStartAddress=> inputsAddress,inputCount => inputsCount,outputStartAddress => outputsAddress,outputCount=> outputsCount); 
                        WriteMemory(area := WriteArea#Output,byteOffset := TO_DINT(outputsAddress) + DINT#2,value:= Outputs.Control.JobLoadID);  
                        _progress := 364;
                    END_IF;
                END_IF;
                // ReadResultsTask running: locking the data buffer.
                IF _progress = 364 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#564, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#564;
                    END_IF;
    
                    IF TRUE  THEN
                        THIS.CallTimers(FALSE);
                        _progress := 365;
                    END_IF;
                END_IF;
                // ReadResultsTask running: setting the user data.
                IF _progress = 365 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#565, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#565;
                    END_IF;

                    Outputs.Control.InitiateJobLoad := TRUE;
                    _Clock_1Hz.Blink(THIS,TIME#500MS,TIME#500MS);
                    retValRdAddr := ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HW_SystemControl),inputStartAddress=> inputsAddress,inputCount => inputsCount,outputStartAddress => outputsAddress,outputCount=> outputsCount); 
                    WriteMemory(area := WriteArea#Output,byteOffset := TO_DINT(outputsAddress),bitOffset := INT#4,value:= _Clock_1Hz.output);  
                    IF (Inputs.Status.CurentJobID = Outputs.Control.JobLoadID) AND Outputs.Control.JobLoadID > WORD#0 AND 
                        Inputs.Status.CurentJobID > BYTE#0 AND Inputs.Status.JobLoadComplete THEN 
                        WriteMemory(area := WriteArea#Output,byteOffset := TO_DINT(outputsAddress),bitOffset := INT#4,value:= FALSE); // ??? not in original code, but probably it should be reseted here 
                        THIS.CallTimers(FALSE);
                        _progress := 366;
                    END_IF;
                END_IF;
                // ReadResultsTask running: waiting for the results to be valid.
                IF _progress = 366 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#566, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#566;
                    END_IF;
    
                    IF Inputs.Status.ResultValid THEN
                        THIS.CallTimers(FALSE);
                        _progress := 367;
                    END_IF;
                END_IF;
                // ReadResultsTask running: calculating the size of the data.
                IF _progress = 367 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#567, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#567;
                    END_IF;
                    Inputs.Status.ReadedDataVariantSize := _readResultsLength;
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 369;
                    END_IF;
                END_IF;
                // ReadResultsTask running: copying the data from hardware to the buffer.
                IF _progress = 369 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#569, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#569;
                    END_IF;
    
                    IF _readResultsLength = UINT#0 THEN
                        TaskMessenger.Activate( UINT#1303, eAxoMessageCategory#Error); 
                        Status.Error.Id:=       UINT#1303;
                        RETURN;
                    END_IF;

                    CASE THIS._readResultsLength OF
        	            UINT#1..UINT#240:  // Statement section case 1
                            retValRdAddr := ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HW_Results_240B_1),inputStartAddress=> inputsAddress,inputCount => inputsCount,outputStartAddress => outputsAddress,outputCount=> outputsCount); 
                            FOR index := UINT#0 TO _readResultsLength - UINT#1 DO //nacitavanie tolko dat kolko treba do buffra.
                                ReadMemory(area := ReadArea#Input,byteOffset := TO_DINT(inputsAddress) + TO_DINT(index), value => _data_in_1301[index]);
                            END_FOR;

                            FOR index := _readResultsLength TO UINT#1300 DO 
                                _data_in_1301[index] := BYTE#0;
                            END_FOR;
                
                        UINT#241..UINT#480:
                            retValRdAddr := ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HW_Results_240B_1),inputStartAddress=> inputsAddress,inputCount => inputsCount,outputStartAddress => outputsAddress,outputCount=> outputsCount); 
                            FOR index := UINT#0 TO UINT#239 DO //nacitavanie tolko dat kolko treba do buffra.
                                ReadMemory(area := ReadArea#Input,byteOffset := TO_DINT(inputsAddress) + TO_DINT(index), value => _data_in_1301[index]);
                            END_FOR;

                            retValRdAddr := ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HW_Results_240B_2),inputStartAddress=> inputsAddress,inputCount => inputsCount,outputStartAddress => outputsAddress,outputCount=> outputsCount); 
                            FOR index := 240 TO _readResultsLength - UINT#1 DO //nacitavanie tolko dat kolko treba do buffra.
                                ReadMemory(area := ReadArea#Input,byteOffset := TO_DINT(inputsAddress) + TO_DINT(index), value => _data_in_1301[index - UINT#240]);
                            END_FOR;

                            FOR index := _readResultsLength TO UINT#1300 DO 
                                _data_in_1301[index] := BYTE#0;
                            END_FOR;
	                
                        UINT#481..UINT#720:
                            retValRdAddr := ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HW_Results_240B_1),inputStartAddress=> inputsAddress,inputCount => inputsCount,outputStartAddress => outputsAddress,outputCount=> outputsCount); 
                            FOR index := UINT#0 TO UINT#239 DO //nacitavanie tolko dat kolko treba do buffra.
                                ReadMemory(area := ReadArea#Input,byteOffset := TO_DINT(inputsAddress) + TO_DINT(index), value => _data_in_1301[index]);
                            END_FOR;

                            retValRdAddr := ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HW_Results_240B_2),inputStartAddress=> inputsAddress,inputCount => inputsCount,outputStartAddress => outputsAddress,outputCount=> outputsCount); 
                            FOR index := UINT#240 TO UINT#479 DO //nacitavanie tolko dat kolko treba do buffra.
                                ReadMemory(area := ReadArea#Input,byteOffset := TO_DINT(inputsAddress) + TO_DINT(index), value => _data_in_1301[index - UINT#240]);
                            END_FOR;

                            retValRdAddr := ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HW_Results_240B_3),inputStartAddress=> inputsAddress,inputCount => inputsCount,outputStartAddress => outputsAddress,outputCount=> outputsCount); 
                            FOR index := UINT#480 TO _readResultsLength - UINT#1 DO //nacitavanie tolko dat kolko treba do buffra.
                                ReadMemory(area := ReadArea#Input,byteOffset := TO_DINT(inputsAddress) + TO_DINT(index), value => _data_in_1301[index - UINT#480]);
                            END_FOR;

                            FOR index := _readResultsLength TO UINT#1300 DO 
                                _data_in_1301[index] := BYTE#0;
                            END_FOR;
	                
                        UINT#721..UINT#960:
                            retValRdAddr := ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HW_Results_240B_1),inputStartAddress=> inputsAddress,inputCount => inputsCount,outputStartAddress => outputsAddress,outputCount=> outputsCount); 
                            FOR index := UINT#0 TO UINT#239 DO //nacitavanie tolko dat kolko treba do buffra.
                                ReadMemory(area := ReadArea#Input,byteOffset := TO_DINT(inputsAddress) + TO_DINT(index), value => _data_in_1301[index]);
                            END_FOR;

                            retValRdAddr := ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HW_Results_240B_2),inputStartAddress=> inputsAddress,inputCount => inputsCount,outputStartAddress => outputsAddress,outputCount=> outputsCount); 
                            FOR index := UINT#240 TO UINT#479 DO //nacitavanie tolko dat kolko treba do buffra.
                                ReadMemory(area := ReadArea#Input,byteOffset := TO_DINT(inputsAddress) + TO_DINT(index), value => _data_in_1301[index - UINT#240]);
                            END_FOR;

                            retValRdAddr := ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HW_Results_240B_3),inputStartAddress=> inputsAddress,inputCount => inputsCount,outputStartAddress => outputsAddress,outputCount=> outputsCount); 
                            FOR index := UINT#480 TO UINT#719 DO //nacitavanie tolko dat kolko treba do buffra.
                                ReadMemory(area := ReadArea#Input,byteOffset := TO_DINT(inputsAddress) + TO_DINT(index), value => _data_in_1301[index - UINT#480]);
                            END_FOR;

                            retValRdAddr := ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HW_Results_240B_4),inputStartAddress=> inputsAddress,inputCount => inputsCount,outputStartAddress => outputsAddress,outputCount=> outputsCount); 
                            FOR index := UINT#720 TO _readResultsLength - UINT#1 DO //nacitavanie tolko dat kolko treba do buffra.
                                ReadMemory(area := ReadArea#Input,byteOffset := TO_DINT(inputsAddress) + TO_DINT(index), value => _data_in_1301[index - UINT#480]);
                            END_FOR;

                            FOR index := _readResultsLength TO UINT#1300 DO 
                                _data_in_1301[index] := BYTE#0;
                            END_FOR;

                        UINT#961..UINT#1200:
                            retValRdAddr := ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HW_Results_240B_1),inputStartAddress=> inputsAddress,inputCount => inputsCount,outputStartAddress => outputsAddress,outputCount=> outputsCount); 
                            FOR index := UINT#0 TO UINT#239 DO //nacitavanie tolko dat kolko treba do buffra.
                                ReadMemory(area := ReadArea#Input,byteOffset := TO_DINT(inputsAddress) + TO_DINT(index), value => _data_in_1301[index]);
                            END_FOR;

                            retValRdAddr := ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HW_Results_240B_2),inputStartAddress=> inputsAddress,inputCount => inputsCount,outputStartAddress => outputsAddress,outputCount=> outputsCount); 
                            FOR index := UINT#240 TO UINT#479 DO //nacitavanie tolko dat kolko treba do buffra.
                                ReadMemory(area := ReadArea#Input,byteOffset := TO_DINT(inputsAddress) + TO_DINT(index), value => _data_in_1301[index - UINT#240]);
                            END_FOR;

                            retValRdAddr := ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HW_Results_240B_3),inputStartAddress=> inputsAddress,inputCount => inputsCount,outputStartAddress => outputsAddress,outputCount=> outputsCount); 
                            FOR index := UINT#480 TO UINT#719 DO //nacitavanie tolko dat kolko treba do buffra.
                                ReadMemory(area := ReadArea#Input,byteOffset := TO_DINT(inputsAddress) + TO_DINT(index), value => _data_in_1301[index - UINT#480]);
                            END_FOR;

                            retValRdAddr := ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HW_Results_240B_4),inputStartAddress=> inputsAddress,inputCount => inputsCount,outputStartAddress => outputsAddress,outputCount=> outputsCount); 
                            FOR index := UINT#720 TO UINT#960 DO //nacitavanie tolko dat kolko treba do buffra.
                                ReadMemory(area := ReadArea#Input,byteOffset := TO_DINT(inputsAddress) + TO_DINT(index), value => _data_in_1301[index - UINT#480]);
                            END_FOR;
                        
                            retValRdAddr := ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HW_Results_240B_5),inputStartAddress=> inputsAddress,inputCount => inputsCount,outputStartAddress => outputsAddress,outputCount=> outputsCount); 
                            FOR index := UINT#961 TO _readResultsLength - UINT#1 DO //nacitavanie tolko dat kolko treba do buffra.
                                ReadMemory(area := ReadArea#Input,byteOffset := TO_DINT(inputsAddress) + TO_DINT(index), value => _data_in_1301[index - UINT#480]);
                            END_FOR;

                            FOR index := _readResultsLength TO UINT#1300 DO 
                                _data_in_1301[index] := BYTE#0;
                            END_FOR;
	                
                        UINT#1201..UINT#1264:
                            retValRdAddr := ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HW_Results_240B_1),inputStartAddress=> inputsAddress,inputCount => inputsCount,outputStartAddress => outputsAddress,outputCount=> outputsCount); 
                            FOR index := UINT#0 TO UINT#239 DO //nacitavanie tolko dat kolko treba do buffra.
                                ReadMemory(area := ReadArea#Input,byteOffset := TO_DINT(inputsAddress) + TO_DINT(index), value => _data_in_1301[index]);
                            END_FOR;

                            retValRdAddr := ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HW_Results_240B_2),inputStartAddress=> inputsAddress,inputCount => inputsCount,outputStartAddress => outputsAddress,outputCount=> outputsCount); 
                            FOR index := UINT#240 TO UINT#479 DO //nacitavanie tolko dat kolko treba do buffra.
                                ReadMemory(area := ReadArea#Input,byteOffset := TO_DINT(inputsAddress) + TO_DINT(index), value => _data_in_1301[index - UINT#240]);
                            END_FOR;

                            retValRdAddr := ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HW_Results_240B_3),inputStartAddress=> inputsAddress,inputCount => inputsCount,outputStartAddress => outputsAddress,outputCount=> outputsCount); 
                            FOR index := UINT#480 TO UINT#719 DO //nacitavanie tolko dat kolko treba do buffra.
                                ReadMemory(area := ReadArea#Input,byteOffset := TO_DINT(inputsAddress) + TO_DINT(index), value => _data_in_1301[index - UINT#480]);
                            END_FOR;

                            retValRdAddr := ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HW_Results_240B_4),inputStartAddress=> inputsAddress,inputCount => inputsCount,outputStartAddress => outputsAddress,outputCount=> outputsCount); 
                            FOR index := UINT#720 TO UINT#960 DO //nacitavanie tolko dat kolko treba do buffra.
                                ReadMemory(area := ReadArea#Input,byteOffset := TO_DINT(inputsAddress) + TO_DINT(index), value => _data_in_1301[index - UINT#480]);
                            END_FOR;
                        
                            retValRdAddr := ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HW_Results_240B_5),inputStartAddress=> inputsAddress,inputCount => inputsCount,outputStartAddress => outputsAddress,outputCount=> outputsCount); 
                            FOR index := UINT#961 TO _readResultsLength - UINT#1 DO //nacitavanie tolko dat kolko treba do buffra.
                                ReadMemory(area := ReadArea#Input,byteOffset := TO_DINT(inputsAddress) + TO_DINT(index), value => _data_in_1301[index - UINT#480]);
                            END_FOR;

                            retValRdAddr := ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HW_Results_64B_1),inputStartAddress=> inputsAddress,inputCount => inputsCount,outputStartAddress => outputsAddress,outputCount=> outputsCount); 
                            FOR index := UINT#1201 TO _readResultsLength - UINT#1 DO //nacitavanie tolko dat kolko treba do buffra.
                                ReadMemory(area := ReadArea#Input,byteOffset := TO_DINT(inputsAddress) + TO_DINT(index), value => _data_in_1301[index - UINT#480]);
                            END_FOR;

                            FOR index := _readResultsLength TO UINT#1300 DO 
                                _data_in_1301[index] := BYTE#0;
                            END_FOR;
                            
                        ELSE  
                            TaskMessenger.Activate( UINT#1304, eAxoMessageCategory#Error); 
                            Status.Error.Id:=       UINT#1304;
                    END_CASE;
                    THIS.ResultData.Data := _data_in_1301;
                    THIS.ResultData.ToggleDataChangedFlag();
                    IF TRUE  THEN
                        THIS.CallTimers(FALSE);
                        _progress := 370;
                    END_IF;
                END_IF;
                // ReadResultsTask running: reading the data.
                IF _progress = 370 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#570, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#570;
                    END_IF;

                    IF TRUE  THEN
                        THIS.CallTimers(FALSE);
                        _progress := 371;
                    END_IF;
                END_IF;
                // ReadResultsTask running: acknowledging the result data.
                IF _progress = 371 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#571, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#571;
                    END_IF;
    
                    Outputs.Control.InspectionResultsAck := TRUE;
                    Outputs.Control.InitiateJobLoad := FALSE;
                    
                    Outputs.Control.JobLoadID := BYTE#0;
                    
                    IF NOT Inputs.Status.ResultValid THEN
                        Outputs.Control.InspectionResultsAck := false;
                        THIS.CallTimers(FALSE);
                        _progress := 372;
                    END_IF;
                END_IF;
                // ReadResultsTask running: reseting the job load Id.
                IF _progress = 372 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#572, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#572;
                    END_IF;
    
                    Outputs.Control.JobLoadID := BYTE#0; 
                    retValRdAddr := ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HW_SystemControl),inputStartAddress=> inputsAddress,inputCount => inputsCount,outputStartAddress => outputsAddress,outputCount=> outputsCount); 
                    WriteMemory(area := WriteArea#Output,byteOffset := TO_DINT(outputsAddress) + DINT#2, value:= Outputs.Control.JobLoadID);  

                    IF TRUE  THEN
                        THIS.CallTimers(FALSE);
                        _progress := 373;
                    END_IF;
                END_IF;
                // ReadResultsTask running: loading the job.
                IF _progress = 373 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#573, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#573;
                    END_IF;
    
                    Outputs.Control.InitiateJobLoad := TRUE;
                    retValRdAddr := ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HW_SystemControl),inputStartAddress=> inputsAddress,inputCount => inputsCount,outputStartAddress => outputsAddress,outputCount=> outputsCount); 
                    WriteMemory(area := WriteArea#Output,byteOffset := TO_DINT(outputsAddress), bitOffset := 4, value:=  Outputs.Control.InitiateJobLoad);
                    
                    IF (Inputs.Status.CurentJobID = WORD#0) AND Inputs.Status.JobLoadComplete THEN
                        Outputs.Control.InitiateJobLoad := FALSE;
                        retValRdAddr := ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HW_SystemControl),inputStartAddress=> inputsAddress,inputCount => inputsCount,outputStartAddress => outputsAddress,outputCount=> outputsCount); 
                        WriteMemory(area := WriteArea#Output,byteOffset := TO_DINT(outputsAddress), bitOffset := 4, value:=  Outputs.Control.InitiateJobLoad);
                        THIS.CallTimers(FALSE);
                        _progress := 374;
                    END_IF;
                END_IF;
                // ReadResultsTask finished.
                IF _progress = 374 THEN
                    ReadResultsTask.DoneWhen(TRUE);
                    _progress := 0;
                END_IF;
    
                THIS.CallTimers(TRUE);
                ReadResultsTask.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);  
                ReadResultsTask.ThrowWhen(ReadResultsTask.Duration >= Config.TaskTimeout AND Config.TaskTimeout > T#0s ,'<#ReadResultsTask timeout.#>');
            END_IF;
            IF ReadResultsTask.DoneReached() THEN
                Status.Action.Id :=  UINT#161;
                Status.Error.Id :=  UINT#0;
            ELSIF ReadResultsTask.ErrorOccured() THEN
                Status.Action.Id :=  UINT#10060;
                Status.Error.Id  :=  UINT#10060;
            ELSIF ReadResultsTask.AbortTriggered()THEN
                Status.Action.Id :=  UINT#10061;
                Status.Error.Id  :=  UINT#10061;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#10060,ReadResultsTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#10061,ReadResultsTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#162,ReadResultsTask.RestoreTriggered() , eAxoMessageCategory#Error);
            IF ReadResultsTask.RestoreTriggered() AND _progress >= 360 AND _progress <= 379  THEN
                Status.Action.Id :=  UINT#162;
                _progress := 0;
            END_IF;
            //**************************************************            
    
            //*************SendDataTask***************
            SendDataTask.SetIsDisabled(FALSE);
            IF SendDataTask.StartTriggered() THEN
                Status.Action.Id :=  UINT#180;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#180,SendDataTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#181,SendDataTask.IsDone(), eAxoMessageCategory#Info);
            IF SendDataTask.Execute(THIS) THEN
                IF _progress = 0 THEN
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 380;
                END_IF;
                // SendDataTask running: waiting for the system to be ready.
                IF _progress = 380 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#580, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#580;
                    END_IF;
                	//Userdata buffer sa plnia prve 4 bajty informacne, data su od 4 a viac.
	                //(0 = Undefined, 1 = Zmena jobu/referencie, 2=Nacitanie data
	
                    Outputs.Control.SoftEvent.Reset := FALSE;
                    Outputs.Control.SoftEvent.DataHandlerAck := FALSE;

                    IF Inputs.Status.SystemReady THEN
                        THIS.CallTimers(FALSE);
                        _progress := 381;
                    END_IF;
                END_IF;
                // SendDataTask running: waiting for the system to be online.
                IF _progress = 381 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#581, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#581;
                    END_IF;
    
                    IF Inputs.Status.Online THEN
                        THIS.CallTimers(FALSE);
                        _progress := 382;
                    END_IF;
                END_IF;
                // SendDataTask running: waiting for the data buffer is free.
                IF _progress = 382 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#582, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#582;
                    END_IF;
                    // PLC nastavi na User Data ID inspekcie, ID operacie a User Data (cislo jobu, seriove cislo kusu, tolerancie).
                    // V dalsom kroku nastavi SetUserData bit a caka na potrvdenie prevzatia dat pomocou UserDataAck.
                    // Akonahle dostane UserDataAck, moze resetnut SetUserData bit a UserData prepisovat pre inu inspekciu.
                    Outputs.Control.WriteDataID := TO_BYTE(TO_UINT(_sendDataBufferID) + (TO_UINT(Config.CameraNo) * UINT#10)); 
	    
                    IF Inputs.Status.UserDataLockerJobID = BYTE#0 OR (Inputs.Status.UserDataLockerJobID = Config.CameraNo) THEN 
                        THIS.CallTimers(FALSE);
                        _progress := 383;
                    END_IF;
                END_IF;
                // SendDataTask running: locking the data buffer.
                IF _progress = 383 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#583, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#583; 
                    END_IF;
	    
                    retValRdAddr := ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HW_UserData_240B_1),inputStartAddress=> inputsAddress,inputCount => inputsCount,outputStartAddress => outputsAddress,outputCount=> outputsCount); 
                    WriteMemory(area := WriteArea#Output,byteOffset := TO_DINT(outputsAddress + UDINT#0), value:= Outputs.Control.WriteDataID);
                    WriteMemory(area := WriteArea#Output,byteOffset := TO_DINT(outputsAddress + UDINT#1),value:= _sendDataInspectionType);      
                    WriteMemory(area := WriteArea#Output,byteOffset := TO_DINT(outputsAddress + UDINT#2),value:= _sendDataJobID);               

                    IF (Inputs.Status.UserDataLockerJobID = Config.CameraNo) THEN  // IF (Inputs.Status.UserDataLockerJobID = Config.CameraNo) THEN
                        THIS.CallTimers(FALSE);
                        _progress := 384;
                    END_IF;
                END_IF;
                // SendDataTask running: setting the length of the data to sent.
                IF _progress = 384 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#584, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#584;
                    END_IF;
    
                    Inputs.Status.WrittenDataVariantSize := _sendDataLength;
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 386;
                    END_IF;
                END_IF;
                // SendDataTask running: filling the user data to be sent.
                IF _progress = 386 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#586, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#586;
                    END_IF;
                    IF _sendDataLength = UINT#0 THEN
                        TaskMessenger.Activate( UINT#1305, eAxoMessageCategory#Error); 
                        Status.Error.Id:=       UINT#1305;
                        RETURN;
                    END_IF;

                    CASE _sendDataLength OF
                        UINT#1..UINT#235:  // Statement section case 1
                            retValRdAddr := ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HW_UserData_240B_1),inputStartAddress=> inputsAddress,inputCount => inputsCount,outputStartAddress => outputsAddress,outputCount=> outputsCount); 
                            FOR index := UINT#0 TO _sendDataLength - UINT#1 DO //nacitavanie tolko dat kolko treba do buffra.
                                WriteMemory(area := WriteArea#Output,byteOffset := TO_DINT(outputsAddress) + DINT#4 + TO_DINT(index),value:= _data_out_1301[index]);
                            END_FOR;

                            FOR index := _sendDataLength TO UINT#235 DO //nacitavanie tolko dat kolko treba do buffra.
                                WriteMemory(area := WriteArea#Output,byteOffset := TO_DINT(outputsAddress) + DINT#4 + TO_DINT(index),value:= BYTE#0);
                            END_FOR;
        
                            retValRdAddr := ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HW_UserData_240B_2),inputStartAddress=> inputsAddress,inputCount => inputsCount,outputStartAddress => outputsAddress,outputCount=> outputsCount); 
                            FOR index := UINT#236 TO UINT#475 DO //nacitavanie tolko dat kolko treba do buffra.
                                WriteMemory(area := WriteArea#Output,byteOffset := TO_DINT(outputsAddress) - DINT#236 + TO_DINT(index),value:= BYTE#0);
                            END_FOR;
        
                            retValRdAddr := ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HW_UserData_240B_3),inputStartAddress=> inputsAddress,inputCount => inputsCount,outputStartAddress => outputsAddress,outputCount=> outputsCount); 
                            FOR index := UINT#476 TO UINT#715 DO //nacitavanie tolko dat kolko treba do buffra.
                                WriteMemory(area := WriteArea#Output,byteOffset := TO_DINT(outputsAddress) - DINT#476 + TO_DINT(index),value:= BYTE#0);
                            END_FOR;
        
                            retValRdAddr := ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HW_UserData_240B_4),inputStartAddress=> inputsAddress,inputCount => inputsCount,outputStartAddress => outputsAddress,outputCount=> outputsCount); 
                            FOR index := UINT#716 TO UINT#955 DO //nacitavanie tolko dat kolko treba do buffra.
                                WriteMemory(area := WriteArea#Output,byteOffset := TO_DINT(outputsAddress) - DINT#716 + TO_DINT(index),value:= BYTE#0);
                            END_FOR;
        
                            retValRdAddr := ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HW_UserData_240B_5),inputStartAddress=> inputsAddress,inputCount => inputsCount,outputStartAddress => outputsAddress,outputCount=> outputsCount); 
                            FOR index := UINT#956 TO UINT#1195 DO //nacitavanie tolko dat kolko treba do buffra.
                                WriteMemory(area := WriteArea#Output,byteOffset := TO_DINT(outputsAddress) - DINT#956 + TO_DINT(index),value:= BYTE#0);
                            END_FOR;
        
                            retValRdAddr := ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HW_UserData_64B_1),inputStartAddress=> inputsAddress,inputCount => inputsCount,outputStartAddress => outputsAddress,outputCount=> outputsCount); 
                            FOR index := UINT#1196 TO UINT#1263 DO //nacitavanie tolko dat kolko treba do buffra.
                                WriteMemory(area := WriteArea#Output,byteOffset := TO_DINT(outputsAddress) - DINT#1196 + TO_DINT(index),value:= BYTE#0);
                            END_FOR;                            

                        UINT#236..UINT#475:  // Statement section case 1
                            retValRdAddr := ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HW_UserData_240B_1),inputStartAddress=> inputsAddress,inputCount => inputsCount,outputStartAddress => outputsAddress,outputCount=> outputsCount); 
                            FOR index := UINT#0 TO UINT#235 DO //nacitavanie tolko dat kolko treba do buffra.
                                WriteMemory(area := WriteArea#Output,byteOffset := TO_DINT(outputsAddress) + DINT#4 + TO_DINT(index),value:= _data_out_1301[index]);
                            END_FOR;
       
                            retValRdAddr := ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HW_UserData_240B_2),inputStartAddress=> inputsAddress,inputCount => inputsCount,outputStartAddress => outputsAddress,outputCount=> outputsCount); 
                            FOR index := UINT#236 TO _sendDataLength - UINT#1 DO //nacitavanie tolko dat kolko treba do buffra.
                                WriteMemory(area := WriteArea#Output,byteOffset := TO_DINT(outputsAddress) - DINT#236 + TO_DINT(index),value:= _data_out_1301[index]);
                            END_FOR;
        
                            FOR index := _sendDataLength TO UINT#475 DO //nacitavanie tolko dat kolko treba do buffra.
                                WriteMemory(area := WriteArea#Output,byteOffset := TO_DINT(outputsAddress) - DINT#236 + TO_DINT(index),value:= BYTE#0);
                            END_FOR;

                            retValRdAddr := ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HW_UserData_240B_3),inputStartAddress=> inputsAddress,inputCount => inputsCount,outputStartAddress => outputsAddress,outputCount=> outputsCount); 
                            FOR index := UINT#476 TO UINT#715 DO //nacitavanie tolko dat kolko treba do buffra.
                                WriteMemory(area := WriteArea#Output,byteOffset := TO_DINT(outputsAddress) - DINT#476 + TO_DINT(index),value:= BYTE#0);
                            END_FOR;
        
                            retValRdAddr := ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HW_UserData_240B_4),inputStartAddress=> inputsAddress,inputCount => inputsCount,outputStartAddress => outputsAddress,outputCount=> outputsCount); 
                            FOR index := UINT#716 TO UINT#955 DO //nacitavanie tolko dat kolko treba do buffra.
                                WriteMemory(area := WriteArea#Output,byteOffset := TO_DINT(outputsAddress) - DINT#716 + TO_DINT(index),value:= BYTE#0);
                            END_FOR;
        
                            retValRdAddr := ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HW_UserData_240B_5),inputStartAddress=> inputsAddress,inputCount => inputsCount,outputStartAddress => outputsAddress,outputCount=> outputsCount); 
                            FOR index := UINT#956 TO UINT#1195 DO //nacitavanie tolko dat kolko treba do buffra.
                                WriteMemory(area := WriteArea#Output,byteOffset := TO_DINT(outputsAddress) - DINT#956 + TO_DINT(index),value:= BYTE#0);
                            END_FOR;
        
                            retValRdAddr := ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HW_UserData_64B_1),inputStartAddress=> inputsAddress,inputCount => inputsCount,outputStartAddress => outputsAddress,outputCount=> outputsCount); 
                            FOR index := UINT#1196 TO UINT#1263 DO //nacitavanie tolko dat kolko treba do buffra.
                                WriteMemory(area := WriteArea#Output,byteOffset := TO_DINT(outputsAddress) - DINT#1196 + TO_DINT(index),value:= BYTE#0);
                            END_FOR;                            

                        UINT#476..UINT#715:
                            retValRdAddr := ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HW_UserData_240B_1),inputStartAddress=> inputsAddress,inputCount => inputsCount,outputStartAddress => outputsAddress,outputCount=> outputsCount); 
                            FOR index := UINT#0 TO UINT#235 DO //nacitavanie tolko dat kolko treba do buffra.
                                WriteMemory(area := WriteArea#Output,byteOffset := TO_DINT(outputsAddress) + DINT#4 + TO_DINT(index),value:= _data_out_1301[index]);
                            END_FOR;
        
                            retValRdAddr := ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HW_UserData_240B_2),inputStartAddress=> inputsAddress,inputCount => inputsCount,outputStartAddress => outputsAddress,outputCount=> outputsCount); 
                            FOR index := UINT#236 TO UINT#475 DO //nacitavanie tolko dat kolko treba do buffra.
                                WriteMemory(area := WriteArea#Output,byteOffset := TO_DINT(outputsAddress) - DINT#236 + TO_DINT(index),value:= _data_out_1301[index]);
                            END_FOR;
        
                            retValRdAddr := ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HW_UserData_240B_3),inputStartAddress=> inputsAddress,inputCount => inputsCount,outputStartAddress => outputsAddress,outputCount=> outputsCount); 
                            FOR index := UINT#476 TO _sendDataLength - UINT#1 DO //nacitavanie tolko dat kolko treba do buffra.
                                WriteMemory(area := WriteArea#Output,byteOffset := TO_DINT(outputsAddress) - DINT#476 + TO_DINT(index),value:= _data_out_1301[index]);
                            END_FOR;
                            FOR index := _sendDataLength TO UINT#715 DO //nacitavanie tolko dat kolko treba do buffra.
                                WriteMemory(area := WriteArea#Output,byteOffset := TO_DINT(outputsAddress) - DINT#476 + TO_DINT(index),value:= BYTE#0);
                            END_FOR;
        
                            retValRdAddr := ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HW_UserData_240B_4),inputStartAddress=> inputsAddress,inputCount => inputsCount,outputStartAddress => outputsAddress,outputCount=> outputsCount); 
                            FOR index := UINT#716 TO UINT#955 DO //nacitavanie tolko dat kolko treba do buffra.
                                WriteMemory(area := WriteArea#Output,byteOffset := TO_DINT(outputsAddress) - DINT#716 + TO_DINT(index),value:= BYTE#0);
                            END_FOR;
        
                            retValRdAddr := ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HW_UserData_240B_5),inputStartAddress=> inputsAddress,inputCount => inputsCount,outputStartAddress => outputsAddress,outputCount=> outputsCount); 
                            FOR index := UINT#956 TO UINT#1195 DO //nacitavanie tolko dat kolko treba do buffra.
                                WriteMemory(area := WriteArea#Output,byteOffset := TO_DINT(outputsAddress) - DINT#956 + TO_DINT(index),value:= BYTE#0);
                            END_FOR;
        
                            retValRdAddr := ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HW_UserData_64B_1),inputStartAddress=> inputsAddress,inputCount => inputsCount,outputStartAddress => outputsAddress,outputCount=> outputsCount); 
                            FOR index := UINT#1196 TO UINT#1263 DO //nacitavanie tolko dat kolko treba do buffra.
                                WriteMemory(area := WriteArea#Output,byteOffset := TO_DINT(outputsAddress) - DINT#1196 + TO_DINT(index),value:= BYTE#0);
                            END_FOR;
                            
                        UINT#716..UINT#955:
                            retValRdAddr := ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HW_UserData_240B_1),inputStartAddress=> inputsAddress,inputCount => inputsCount,outputStartAddress => outputsAddress,outputCount=> outputsCount); 
                            FOR index := UINT#0 TO UINT#235 DO //nacitavanie tolko dat kolko treba do buffra.
                                WriteMemory(area := WriteArea#Output,byteOffset := TO_DINT(outputsAddress) + DINT#4 + TO_DINT(index),value:= _data_out_1301[index]);
                            END_FOR;
        
                            retValRdAddr := ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HW_UserData_240B_2),inputStartAddress=> inputsAddress,inputCount => inputsCount,outputStartAddress => outputsAddress,outputCount=> outputsCount); 
                            FOR index := UINT#236 TO UINT#475 DO //nacitavanie tolko dat kolko treba do buffra.
                                WriteMemory(area := WriteArea#Output,byteOffset := TO_DINT(outputsAddress) - DINT#236 + TO_DINT(index),value:= _data_out_1301[index]);
                            END_FOR;
        
                            retValRdAddr := ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HW_UserData_240B_3),inputStartAddress=> inputsAddress,inputCount => inputsCount,outputStartAddress => outputsAddress,outputCount=> outputsCount); 
                            FOR index := UINT#476 TO UINT#715 DO //nacitavanie tolko dat kolko treba do buffra.
                                WriteMemory(area := WriteArea#Output,byteOffset := TO_DINT(outputsAddress) - DINT#476 + TO_DINT(index),value:= _data_out_1301[index]);
                            END_FOR;
        
                            retValRdAddr := ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HW_UserData_240B_4),inputStartAddress=> inputsAddress,inputCount => inputsCount,outputStartAddress => outputsAddress,outputCount=> outputsCount); 
                            FOR index := UINT#716 TO _sendDataLength - UINT#1 DO //nacitavanie tolko dat kolko treba do buffra.
                                WriteMemory(area := WriteArea#Output,byteOffset := TO_DINT(outputsAddress) - DINT#716 + TO_DINT(index),value:= _data_out_1301[index]);
                            END_FOR;
                            FOR index := _sendDataLength TO UINT#955 DO //nacitavanie tolko dat kolko treba do buffra.
                                WriteMemory(area := WriteArea#Output,byteOffset := TO_DINT(outputsAddress) - DINT#716 + TO_DINT(index),value:= BYTE#0);
                            END_FOR;     
        
                            retValRdAddr := ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HW_UserData_240B_5),inputStartAddress=> inputsAddress,inputCount => inputsCount,outputStartAddress => outputsAddress,outputCount=> outputsCount); 
                            FOR index := UINT#956 TO UINT#1195 DO //nacitavanie tolko dat kolko treba do buffra.
                                WriteMemory(area := WriteArea#Output,byteOffset := TO_DINT(outputsAddress) - DINT#956 + TO_DINT(index),value:= BYTE#0);
                            END_FOR;
        
                            retValRdAddr := ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HW_UserData_64B_1),inputStartAddress=> inputsAddress,inputCount => inputsCount,outputStartAddress => outputsAddress,outputCount=> outputsCount); 
                            FOR index := UINT#1196 TO UINT#1263 DO //nacitavanie tolko dat kolko treba do buffra.
                                WriteMemory(area := WriteArea#Output,byteOffset := TO_DINT(outputsAddress) - DINT#1196 + TO_DINT(index),value:= BYTE#0);
                            END_FOR;                            

                        UINT#956..UINT#1195:
                            retValRdAddr := ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HW_UserData_240B_1),inputStartAddress=> inputsAddress,inputCount => inputsCount,outputStartAddress => outputsAddress,outputCount=> outputsCount); 
                            FOR index := UINT#0 TO UINT#235 DO //nacitavanie tolko dat kolko treba do buffra.
                                WriteMemory(area := WriteArea#Output,byteOffset := TO_DINT(outputsAddress) + DINT#4 + TO_DINT(index),value:= _data_out_1301[index]);
                            END_FOR;
        
                            retValRdAddr := ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HW_UserData_240B_2),inputStartAddress=> inputsAddress,inputCount => inputsCount,outputStartAddress => outputsAddress,outputCount=> outputsCount); 
                            FOR index := UINT#236 TO UINT#475 DO //nacitavanie tolko dat kolko treba do buffra.
                                WriteMemory(area := WriteArea#Output,byteOffset := TO_DINT(outputsAddress) - DINT#236 + TO_DINT(index),value:= _data_out_1301[index]);
                            END_FOR;
        
                            retValRdAddr := ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HW_UserData_240B_3),inputStartAddress=> inputsAddress,inputCount => inputsCount,outputStartAddress => outputsAddress,outputCount=> outputsCount); 
                            FOR index := UINT#476 TO UINT#715 DO //nacitavanie tolko dat kolko treba do buffra.
                                WriteMemory(area := WriteArea#Output,byteOffset := TO_DINT(outputsAddress) - DINT#476 + TO_DINT(index),value:= _data_out_1301[index]);
                            END_FOR;
        
                            retValRdAddr := ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HW_UserData_240B_4),inputStartAddress=> inputsAddress,inputCount => inputsCount,outputStartAddress => outputsAddress,outputCount=> outputsCount); 
                            FOR index := UINT#716 TO UINT#955 DO //nacitavanie tolko dat kolko treba do buffra.
                                WriteMemory(area := WriteArea#Output,byteOffset := TO_DINT(outputsAddress) - DINT#716 + TO_DINT(index),value:= _data_out_1301[index]);
                            END_FOR;
        
                            retValRdAddr := ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HW_UserData_240B_5),inputStartAddress=> inputsAddress,inputCount => inputsCount,outputStartAddress => outputsAddress,outputCount=> outputsCount); 
                            FOR index := UINT#956 TO _sendDataLength - UINT#1 DO //nacitavanie tolko dat kolko treba do buffra.
                                WriteMemory(area := WriteArea#Output,byteOffset := TO_DINT(outputsAddress) - DINT#956 + TO_DINT(index),value:= _data_out_1301[index]);
                            END_FOR;

                            FOR index := _sendDataLength TO UINT#1195 DO //nacitavanie tolko dat kolko treba do buffra.
                                WriteMemory(area := WriteArea#Output,byteOffset := TO_DINT(outputsAddress) - DINT#956 + TO_DINT(index),value:= BYTE#0);
                            END_FOR;

                            retValRdAddr := ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HW_UserData_64B_1),inputStartAddress=> inputsAddress,inputCount => inputsCount,outputStartAddress => outputsAddress,outputCount=> outputsCount); 
                            FOR index := UINT#1196 TO UINT#1259 DO //nacitavanie tolko dat kolko treba do buffra.
                                WriteMemory(area := WriteArea#Output,byteOffset := TO_DINT(outputsAddress) - DINT#1196 + TO_DINT(index),value:= BYTE#0);
                            END_FOR;

                        UINT#1196..UINT#1260:
                            retValRdAddr := ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HW_UserData_240B_1),inputStartAddress=> inputsAddress,inputCount => inputsCount,outputStartAddress => outputsAddress,outputCount=> outputsCount); 
                            FOR index := UINT#0 TO UINT#235 DO //nacitavanie tolko dat kolko treba do buffra.
                                WriteMemory(area := WriteArea#Output,byteOffset := TO_DINT(outputsAddress) + DINT#4 + TO_DINT(index),value:= _data_out_1301[index]);
                            END_FOR;
        
                            retValRdAddr := ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HW_UserData_240B_2),inputStartAddress=> inputsAddress,inputCount => inputsCount,outputStartAddress => outputsAddress,outputCount=> outputsCount); 
                            FOR index := UINT#236 TO UINT#475 DO //nacitavanie tolko dat kolko treba do buffra.
                                WriteMemory(area := WriteArea#Output,byteOffset := TO_DINT(outputsAddress) - DINT#236 + TO_DINT(index),value:= _data_out_1301[index]);
                            END_FOR;
        
                            retValRdAddr := ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HW_UserData_240B_3),inputStartAddress=> inputsAddress,inputCount => inputsCount,outputStartAddress => outputsAddress,outputCount=> outputsCount); 
                            FOR index := UINT#476 TO UINT#715 DO //nacitavanie tolko dat kolko treba do buffra.
                                WriteMemory(area := WriteArea#Output,byteOffset := TO_DINT(outputsAddress) - DINT#476 + TO_DINT(index),value:= _data_out_1301[index]);
                            END_FOR;
        
                            retValRdAddr := ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HW_UserData_240B_4),inputStartAddress=> inputsAddress,inputCount => inputsCount,outputStartAddress => outputsAddress,outputCount=> outputsCount); 
                            FOR index := UINT#716 TO UINT#955 DO //nacitavanie tolko dat kolko treba do buffra.
                                WriteMemory(area := WriteArea#Output,byteOffset := TO_DINT(outputsAddress) - DINT#716 + TO_DINT(index),value:= _data_out_1301[index]);
                            END_FOR;
        
                            retValRdAddr := ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HW_UserData_240B_5),inputStartAddress=> inputsAddress,inputCount => inputsCount,outputStartAddress => outputsAddress,outputCount=> outputsCount); 
                            FOR index := UINT#956 TO UINT#1195 DO //nacitavanie tolko dat kolko treba do buffra.
                                WriteMemory(area := WriteArea#Output,byteOffset := TO_DINT(outputsAddress) - DINT#956 + TO_DINT(index),value:= _data_out_1301[index]);
                            END_FOR;
        
                            retValRdAddr := ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HW_UserData_64B_1),inputStartAddress=> inputsAddress,inputCount => inputsCount,outputStartAddress => outputsAddress,outputCount=> outputsCount); 
                            FOR index := UINT#1196 TO _sendDataLength - UINT#1 DO //nacitavanie tolko dat kolko treba do buffra.
                                WriteMemory(area := WriteArea#Output,byteOffset := TO_DINT(outputsAddress) - DINT#1196 + TO_DINT(index),value:= _data_out_1301[index]);
                            END_FOR;

                            FOR index := _sendDataLength TO UINT#1263 DO //nacitavanie tolko dat kolko treba do buffra.
                                WriteMemory(area := WriteArea#Output,byteOffset := TO_DINT(outputsAddress) - DINT#1196 + TO_DINT(index),value:= BYTE#0);
                            END_FOR;
                            
                            
                        ELSE  
                            TaskMessenger.Activate( UINT#1306, eAxoMessageCategory#Error); 
                            Status.Error.Id:=       UINT#1306;
                    END_CASE;
            
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 387;
                    END_IF;
                END_IF;
                // SendDataTask running: waiting for falling of the set user data acknowledge.
                IF _progress = 387 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#587, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#587;
                    END_IF;
    
                    IF NOT Inputs.Status.SetUserDataAck THEN
                        Outputs.Control.SetUserdata := TRUE;
                        THIS.CallTimers(FALSE);
                        _progress := 388;
                    END_IF;
                END_IF;
                // SendDataTask running: waiting for the confirmation of the user data.
                IF _progress = 388 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#588, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#588;
                    END_IF;
    
                    IF Inputs.Status.SetUserDataAck THEN
                        Outputs.Control.SetUserdata := FALSE;
                        THIS.CallTimers(FALSE);
                        _progress := 389;
                    END_IF;
                END_IF;
                // SendDataTask running: waiting for falling of the set user data acknowledge.
                IF _progress = 389 THEN 
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#589, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#589;
                    END_IF;
    
                    IF NOT Inputs.Status.SetUserDataAck THEN
                        THIS.CallTimers(FALSE);
                        _progress := 390;
                    END_IF;
                END_IF;
                // SendDataTask running: waiting for falling of the set user data acknowledge.
                IF _progress = 390 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#590, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#590;
                    END_IF;

                    retValRdAddr := ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HW_UserData_240B_1),inputStartAddress=> inputsAddress,inputCount => inputsCount,outputStartAddress => outputsAddress,outputCount=> outputsCount); 
                    WriteMemory(area := WriteArea#Output,byteOffset := TO_DINT(outputsAddress) + DINT#0,value:= BYTE#0);
                    WriteMemory(area := WriteArea#Output,byteOffset := TO_DINT(outputsAddress) + DINT#1,value:= BYTE#0);
                    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 391;
                    END_IF;
                END_IF;
                // SendDataTask running: data handler set.
                IF _progress = 391 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#591, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#591;
                    END_IF;
    
                    IF NOT Inputs.Status.SoftEvent.DataHandlerDone THEN
                        Outputs.Control.SoftEvent.DataHandlerAck := TRUE;
                        THIS.CallTimers(FALSE);
                        _progress := 392;
                    END_IF;
                END_IF;
                // SendDataTask running: waiting for data handler ack.
                IF _progress = 392 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#592, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#592;
                    END_IF;
    
                    IF Inputs.Status.SoftEvent.DataHandlerDone THEN
                        Outputs.Control.SoftEvent.DataHandlerAck := FALSE;
                        THIS.CallTimers(FALSE);
                        _progress := 393;
                    END_IF;
                END_IF;
                // SendDataTask running: waiting for data handler ack false.
                IF _progress = 393 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#593, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#593;
                    END_IF;
    
                    IF NOT Inputs.Status.SoftEvent.DataHandlerDone THEN
                        THIS.CallTimers(FALSE);
                        _progress := 394;
                    END_IF;
                END_IF;
                // SendDataTask finished.
                IF _progress = 394 THEN
                    SendDataTask.DoneWhen(TRUE);
                    _progress := 0;
                END_IF;
    
                THIS.CallTimers(TRUE);
                
                SendDataTask.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);  
                SendDataTask.ThrowWhen(SendDataTask.Duration >= Config.TaskTimeout AND Config.TaskTimeout > T#0s ,'<#SendDataTask timeout.#>');
            END_IF;
            IF SendDataTask.DoneReached() THEN
                Status.Action.Id :=  UINT#181;
                Status.Error.Id :=  UINT#0;
            ELSIF SendDataTask.ErrorOccured() THEN
                Status.Action.Id :=  UINT#10080;
                Status.Error.Id  :=  UINT#10080;
            ELSIF SendDataTask.AbortTriggered()THEN
                Status.Action.Id :=  UINT#10081;
                Status.Error.Id  :=  UINT#10081;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#10080,SendDataTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#10081,SendDataTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#182,SendDataTask.RestoreTriggered() , eAxoMessageCategory#Error);
            IF SendDataTask.RestoreTriggered() AND _progress >= 380 AND _progress <= 399  THEN
                Status.Action.Id :=  UINT#182;
                _progress := 0;
            END_IF;
            //**************************************************

            //***********Update outputs ****************
			
			retValRdAddr := ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HW_SystemControl),inputStartAddress=> inputsAddress,inputCount => inputsCount,outputStartAddress => outputsAddress,outputCount=> outputsCount); 
			
			IF    CameraNo = BYTE#1 THEN
					outputsAddress := outputsAddress + UDINT#4;
					BitOffset := 0;
            ELSIF CameraNo = BYTE#2 THEN
					outputsAddress := outputsAddress + UDINT#4;
					BitOffset := 4;
            ELSIF CameraNo = BYTE#3 THEN
					outputsAddress := outputsAddress + UDINT#5;
					BitOffset := 0;
            ELSIF CameraNo = BYTE#4 THEN
					outputsAddress := outputsAddress + UDINT#5;
					BitOffset := 4;
            ELSIF CameraNo = BYTE#5 THEN
					outputsAddress := outputsAddress + UDINT#6;
					BitOffset := 0;
            ELSIF CameraNo = BYTE#6 THEN
					outputsAddress := outputsAddress + UDINT#6;
					BitOffset := 4;
            ELSIF CameraNo = BYTE#7 THEN
					outputsAddress := outputsAddress + UDINT#7;
					BitOffset := 0;
            ELSIF CameraNo = BYTE#8 THEN
					outputsAddress := outputsAddress + UDINT#8;
					BitOffset := 4;
			END_IF;
			
			WriteMemory(area := WriteArea#Output,byteOffset := TO_DINT(outputsAddress), bitOffset := BitOffset, value:= Outputs.Control.SoftEvent.Reset);
			WriteMemory(area := WriteArea#Output,byteOffset := TO_DINT(outputsAddress), bitOffset := BitOffset + INT#1, value:= Outputs.Control.SoftEvent.DataHandlerAck);
			WriteMemory(area := WriteArea#Output,byteOffset := TO_DINT(outputsAddress), bitOffset := BitOffset + INT#2, value:= Outputs.Control.SoftEvent.Trigger);
			WriteMemory(area := WriteArea#Output,byteOffset := TO_DINT(outputsAddress), bitOffset := BitOffset + INT#3, value:= Outputs.Control.SoftEvent.Reserve);
			
			IF (Inputs.Status.ReadDataLockerJobID = Config.CameraNo) THEN  
				retValRdAddr := ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HW_SystemControl),inputStartAddress=> inputsAddress,inputCount => inputsCount,outputStartAddress => outputsAddress,outputCount=> outputsCount); 
				WriteMemory(area := WriteArea#Output,byteOffset := TO_DINT(outputsAddress), bitOffset := INT#4, value:= Outputs.Control.InitiateJobLoad );
				
				WriteMemory(area := WriteArea#Output,byteOffset := TO_DINT(outputsAddress) + DINT#2, value:= Outputs.Control.JobLoadID);

                retValRdAddr := ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HW_EngineControl_1),inputStartAddress=> inputsAddress,inputCount => inputsCount,outputStartAddress => outputsAddress,outputCount=> outputsCount); 
		        WriteMemory(area := WriteArea#Output,byteOffset := TO_DINT(outputsAddress), bitOffset := INT#1, value:= Outputs.Control.InspectionResultsAck);
			END_IF;


			IF  (Inputs.Status.UserDataLockerJobID = Config.CameraNo) THEN
				retValRdAddr := ReadHardwareIOAddress(hardwareID := (Config.HWIDs.HW_EngineControl_1),inputStartAddress=> inputsAddress,inputCount => inputsCount,outputStartAddress => outputsAddress,outputCount=> outputsCount); 
				WriteMemory(area := WriteArea#Output,byteOffset := TO_DINT(outputsAddress), bitOffset := INT#3, value:= Outputs.Control.SetUserdata);
			END_IF;

			// -   User Data [20-1400]: Spolocny buffer pre user data. Vyuziva sa vzdy cely buffer (v jednom CASE moze pristupovat len jedna inspekcia).
			//     o   Byte[0]: cislo inspekcie (camera*10 + ( 0 az 9)), pre ktore su aktualne data v bufferi platne
			//     o   Byte[1]: typ spracovania dat (0 = Undefined, 1 = Zmena jobu/referencie, )
			//     o   Byte[2]: cislo jobu
			//     o   Byte[3-??]: id kusu
           
            //******************************************      

        END_METHOD

        METHOD PUBLIC HardResetAllCameras : IAxoTaskState
            HardResetAllCameras := HardResetAllCamerasTask.Invoke(THIS);
        END_METHOD

        METHOD PUBLIC Reset : IAxoTaskState
            Reset := ResetTask.Invoke(THIS);
        END_METHOD

        METHOD PUBLIC Trigger : IAxoTaskState
            Trigger := TriggerTask.Invoke(THIS);
        END_METHOD


        METHOD PUBLIC ReadResults : IAxoTaskState
            VAR_INPUT
                JobID       :   BYTE;
                Length      :   UINT;
            END_VAR
            VAR_IN_OUT 
                Data : ARRAY[0..1300] OF BYTE;
            END_VAR
            _readResultsJobID   :=  JobID;
            _readResultsLength  :=  Length;
            _data_in_1301       :=  Data;
            ReadResults         :=  ReadResultsTask.Invoke(THIS);
        END_METHOD

        METHOD PUBLIC SendData : IAxoTaskState
            VAR_INPUT
                InspectionType  :   BYTE;   // (0 = Undefined, 1 = Zmena jobu/referencie, 2=Nacitanie
                BufferID        :   BYTE;   // Buffer ID, 0-9
                JobID           :   BYTE;
                Length          :   UINT;
            END_VAR
            VAR_IN_OUT 
                Data : ARRAY[0..1300] OF BYTE;
            END_VAR  
            _sendDataInspectionType :=  InspectionType;
            _sendDataBufferID       :=  BufferID;
            _sendDataJobID          :=  JobID;
            _sendDataLength         :=  Length;
            _data_out_1301          :=  Data;          
            SendData                :=  SendDataTask.Invoke(THIS);
        END_METHOD


        METHOD PROTECTED OVERRIDE ManualControl
            THIS._isManuallyControllable := TRUE;

            _readResultsJobID       :=  ReadResultsJobIDServiceMode;
            _readResultsLength      :=  ReadResultsLengthServiceMode;
            _data_in_1301           :=  ResultData.Data;

            _sendDataInspectionType :=  SendDataInspectionTypeServiceMode;
            _sendDataBufferID       :=  SendDataBufferIDServiceMode;
            _sendDataJobID          :=  SendResultsJobIDServiceMode;
            _sendDataLength         :=  SendResultsLengthServiceMode;
            _data_out_1301          :=  UserData.Data;

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
        

            FOR _index := 0 TO 1300 DO
                _data_in_1301[_index] := BYTE#0;
                _data_out_1301[_index] := BYTE#0;
            END_FOR;
            

            HardResetAllCamerasTask.Restore();
            ResetTask.Restore();
            TriggerTask.Restore();
            ReadResultsTask.Restore();
            SendDataTask.Restore();
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

