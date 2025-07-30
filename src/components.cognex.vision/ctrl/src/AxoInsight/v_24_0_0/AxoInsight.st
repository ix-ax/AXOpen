USING AXOpen.Messaging.Static;
USING AXOpen.Messaging;
USING AXOpen.Core;
USING AXOpen.Components.Abstractions;
USING System.Strings;
USING System.Serialization;
USING Siemens.Simatic.S71500.Hardware.Utilities;

NAMESPACE AXOpen.Components.Cognex.Vision.v_24_0_0
    {#ix-attr:[Container(Layout.Wrap)]}
    {S7.extern=ReadWrite}
    CLASS PUBLIC AxoInsight EXTENDS AXOpen.Core.AxoComponent IMPLEMENTS AXOpen.Components.Abstractions.IAxoVisionSensor
        VAR PRIVATE
            _UserDataSize_Slot_7    :   UINT;
            _UserDataSize_Slot_8    :   UINT;
            _UserDataSize_Slot_9    :   UINT;
            _UserDataSize_Slot_10   :   UINT;
            _UserDataSize           :   UINT;
            _ResultDataSize_Slot_11 :   UINT;
            _ResultDataSize_Slot_12 :   UINT;
            _ResultDataSize_Slot_13 :   UINT;
            _ResultDataSize_Slot_14 :   UINT;
            _ResultDataSize         :   UINT;
            // _hwID                   :   WORD;
            // _hwIdAcquisitionControl :   WORD;
            // _hwIdAcquisitionStatus  :   WORD;
            // _hwIdInspectionControl  :   WORD;
            // _hwIdInspectionStatus   :   WORD;
            // _hwIdCommandControl     :   WORD;
            // _hwIdSoftEventControl   :   WORD;
            // _hwIdUserDataSlot_7     :   WORD;
            // _hwIdUserDataSlot_8     :   WORD;
            // _hwIdUserDataSlot_9     :   WORD;
            // _hwIdUserDataSlot_10    :   WORD;
            // _hwIdResultData_Slot_11 :   WORD;
            // _hwIdResultData_Slot_12 :   WORD;
            // _hwIdResultData_Slot_13 :   WORD;
            // _hwIdResultData_Slot_14 :   WORD;

            _progress               :   INT := 0;
            _infoTimer              :   AXOpen.Timers.OnDelayTimer;
            _errorTimer             :   AXOpen.Timers.OnDelayTimer;
            _jobName                :   STRING;
            _inspectionCompleted    :   BOOL;
            _data_255               :   ARRAY[0..254] OF BYTE;
            _jobNumber              :   UINT;
            _softEventNumber        :   UINT;
            _UserDataChanged        :   BOOL;

            _initHwCheckDone        :   BOOL;
            _retval                 :   WORD;
            _geoAddr                :   GeoAddr;
            _outHwid                :   UINT;
            _startAddress           :   UDINT;
            _bytesCount             :   UINT;
            _inputsAddress          :   UDINT;   
            _inputsCount            :   UINT;
            _outputsAddress         :   UDINT;  
            _outputsCount           :   UINT; 
            _offset                 :   UINT;
            _fromFor                :   UINT;
            _toFor                  :   UINT;
            _userDataLength         :   UINT;            
            _userData               :   AxoInsight_UserData;
        END_VAR
        VAR CONSTANT
            _maxUserDataIndex   : UINT:= UINT#1015;
            _maxResultDataIndex : UINT:= UINT#999;
        END_VAR

        VAR PUBLIC //Header
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentHeader()]}
            {#ix-set:AttributeName = "<#Trigger#>"}
            TriggerTask : AXOpen.Core.AxoTask;

            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentHeader()]}
            {#ix-attr:[ReadOnly()]}
            {#ix-set:DisplayFormat = "string"}
            {#ix-set:AttributeName = "<#Inspection results#>"}
            InspectionResults : AxoInsight_ResultData;

            {#ix-attr:[ComponentHeader()]}
            {#ix-set:AttributeName = "<#Progress#>"}
            {#ix-attr:[ReadOnly()]}
            Progress : INT;
        END_VAR

        VAR PUBLIC //Tasks
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#Restore#>"}
            RestoreTask : AXOpen.Core.AxoTask;
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#Clear inspection results#>"}
            ClearInspectionResultsTask : AXOpen.Core.AxoTask;
            {#ix-attr:[Container(Layout.UniformGrid)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#Required job name#>"}
            RequiredJobName : STRING;
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#Change job by name#>"}
            ChangeJobByNameTask : AXOpen.Core.AxoTask;
            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#Required job number#>"}
            RequiredJobNumber : UINT;
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#Change job by number#>"}
            ChangeJobByNumberTask : AXOpen.Core.AxoTask;

            {#ix-attr:[Container(Layout.UniformGrid)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#Required soft event number#>"}
            RequiredSoftEventNumber : UINT;
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#Trigger soft event#>"}
            SoftEventTask : AXOpen.Core.AxoTask;

            {#ix-attr:[Container(Layout.UniformGrid)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#User data to sent#>"}
            UserDataToSent : AxoInsight_UserData;
            {#ix-attr:[Container(Layout.UniformGrid)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#User data length#>"}
            UserDataLength : UINT;            
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#Send user data#>"}
            SendUserDataTask : AXOpen.Core.AxoTask;
        END_VAR

        VAR PUBLIC //Config
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Config")]}
            {#ix-attr:[ReadOnly()]}
            Config      :   AxoInsight_Config;
        END_VAR

        VAR PUBLIC //Status
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("Status")]}
            {#ix-attr:[ReadOnly()]}
            Status      :   AxoInsight_Status;

            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-attr:[ComponentDetails("Status")]}
            {#ix-attr:[ReadOnly()]}
            {#ix-set:AttributeName = "<#Results#>"}
            Results     :   AxoInsight_Results;

            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-attr:[ComponentDetails("Status")]}
            {#ix-set:AttributeName = "<#Acquisition control#>"}
            // {#ix-attr:[ReadOnly()]} 
            AcquisitionControl      :   AxoInsight_AcquisitionControl;

            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-attr:[ComponentDetails("Status")]}
            {#ix-set:AttributeName = "<#Acquisition status#>"}
            {#ix-attr:[ReadOnly()]}
            AcquisitionStatus      :   AxoInsight_AcquisitionStatus;

            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-attr:[ComponentDetails("Status")]}
            {#ix-set:AttributeName = "<#Inspection control#>"}
            // {#ix-attr:[ReadOnly()]} 
            InspectionControl      :   AxoInsight_InspectionControl;

            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-attr:[ComponentDetails("Status")]}
            {#ix-set:AttributeName = "<#Inspection status#>"}
            {#ix-attr:[ReadOnly()]}
            InspectionStatus      :   AxoInsight_InspectionStatus;

            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-attr:[ComponentDetails("Status")]}
            {#ix-set:AttributeName = "<#Command control#>"}
            // {#ix-attr:[ReadOnly()]} 
            CommandControl      :   AxoInsight_CommandControl;

            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-attr:[ComponentDetails("Status")]}
            {#ix-set:AttributeName = "<#Command status#>"}
            {#ix-attr:[ReadOnly()]}
            CommandStatus      :   AxoInsight_CommandStatus;

            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-attr:[ComponentDetails("Status")]}
            {#ix-set:AttributeName = "<#Soft-event control#>"}
            // {#ix-attr:[ReadOnly()]} 
            SoftEventControl      :           AxoInsight_SoftEventControl;

            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-attr:[ComponentDetails("Status")]}
            {#ix-set:AttributeName = "<#Soft-event status#>"}
            {#ix-attr:[ReadOnly()]}
            SoftEventStatus      :           AxoInsight_SoftEventStatus;

            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-attr:[ComponentDetails("Status")]}
            {#ix-set:AttributeName = "<#User data#>"}
            {#ix-attr:[ReadOnly()]} 
            UserData        :   AxoInsight_UserData;
        END_VAR

        VAR PUBLIC //Hardware diagnostics
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("Hardware diagnostics")]}
            {#ix-set:AttributeName = "<#Update diagnostics#>"}
            HardwareDiagnosticsTask :   AXOpen.Io.AxoHardwareDiagnostics;
        END_VAR

        VAR PUBLIC //Messengers
            Messenger          :   AXOpen.Messaging.Static.AxoMessenger;
            TaskMessenger      :   AXOpen.Messaging.Static.AxoMessenger;
        END_VAR

        ///<summary>
        /// Runs tasks and logic of this component.
        /// >[!IMPORTANT] This method or one of its overloads must be called cyclically.
        ///</summary>
        METHOD PUBLIC Run
            VAR_INPUT
                parent                  :   IAxoObject; 
                hwID                    :   WORD;
            END_VAR
            VAR
                _index              :   UINT;
                _invalidDataSize    :   BOOL;
                _data_1             :   ARRAY[0..0] OF BYTE;
                _data_2             :   ARRAY[0..1] OF BYTE;
                _data_16            :   ARRAY[0..15] OF BYTE;
                _data_32            :   ARRAY[0..31] OF BYTE;
                _data_64            :   ARRAY[0..63] OF BYTE;
                _data_128           :   ARRAY[0..127] OF BYTE;
                _data_254           :   ARRAY[0..253] OF BYTE;                
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
                IF hwID = WORD#0 THEN
                    Messenger.Activate(UINT#701, eAxoMessageCategory#ProgrammingError);
                    Status.Error.Id := UINT#701;
                    RETURN;
                END_IF;
    
                Config.HWIDs.HW_Device                    := TO_UINT(hwID);                                                      
                _retval := ReadSlotFromHardwareID(hardwareID := Config.HWIDs.HW_Device, geoAddr :=_geoAddr);   
                IF _retval = WORD#8090 THEN
                    Messenger.Activate(UINT#702,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#702;
                    RETURN;
                END_IF;
                
                //******************Slot 1*****************//
                _geoAddr.Slot   :=  UINT#1;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HW_AcquisitionControl);        
                IF Config.HWIDs.HW_AcquisitionControl = UINT#0 THEN
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
                ReadHardwareIOAddress(hardwareIdentifier :=  TO_WORD(Config.HWIDs.HW_AcquisitionControl) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#0 OR _outputsCount <> UINT#1 THEN
                    Messenger.Activate(UINT#716,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#716;
                    RETURN;
                END_IF;
                //******************Slot 2*****************//
                _geoAddr.Slot   :=  UINT#2;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HW_AcquisitionStatus);        
                IF Config.HWIDs.HW_AcquisitionStatus = UINT#0 THEN
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
                ReadHardwareIOAddress(hardwareIdentifier :=  TO_WORD(Config.HWIDs.HW_AcquisitionStatus) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF (_inputsCount <> UINT#3 AND _inputsCount <> UINT#4) OR _outputsCount <> UINT#0 THEN  // 3 for is2000, 4 for 2800 
                    Messenger.Activate(UINT#726,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#726;
                    RETURN;
                END_IF;
                //******************Slot 3*****************//
                _geoAddr.Slot   :=  UINT#3;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HW_InspectionControl);        
                IF Config.HWIDs.HW_InspectionControl = UINT#0 THEN
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
                ReadHardwareIOAddress(hardwareIdentifier :=  TO_WORD(Config.HWIDs.HW_InspectionControl) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#0 OR _outputsCount <> UINT#1 THEN
                    Messenger.Activate(UINT#736,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#736;
                    RETURN;
                END_IF;
                //******************Slot 4*****************//
                _geoAddr.Slot   :=  UINT#4;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HW_InspectionStatus);        
                IF Config.HWIDs.HW_InspectionStatus = UINT#0 THEN
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
                ReadHardwareIOAddress(hardwareIdentifier :=  TO_WORD(Config.HWIDs.HW_InspectionStatus) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#4 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#746,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#746;
                    RETURN;
                END_IF;
                //******************Slot 5*****************//
                _geoAddr.Slot   :=  UINT#5;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HW_CommandControl);        
                IF Config.HWIDs.HW_CommandControl = UINT#0 THEN
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
                ReadHardwareIOAddress(hardwareIdentifier :=  TO_WORD(Config.HWIDs.HW_CommandControl) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF (_inputsCount <> UINT#2 AND _inputsCount <> UINT#4) OR _outputsCount <> UINT#2 THEN
                    Messenger.Activate(UINT#756,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#756;
                    RETURN;
                END_IF;
                //******************Slot 6*****************//
                _geoAddr.Slot   :=  UINT#6;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HW_SoftEventControl);        
                IF Config.HWIDs.HW_SoftEventControl = UINT#0 THEN
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
                ReadHardwareIOAddress(hardwareIdentifier :=  TO_WORD(Config.HWIDs.HW_SoftEventControl) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#1 OR _outputsCount <> UINT#1 THEN
                    Messenger.Activate(UINT#766,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#766;
                    RETURN;
                END_IF;
                //******************Slot 7*****************//
                _geoAddr.Slot   :=  UINT#7;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HW_UserDataSlot_7);        
                IF Config.HWIDs.HW_UserDataSlot_7 = UINT#0 THEN
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
                ReadHardwareIOAddress(hardwareIdentifier :=  TO_WORD(Config.HWIDs.HW_UserDataSlot_7) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount = UINT#0 AND _outputsCount = UINT#16 THEN
                    _UserDataSize_Slot_7 := UINT#16;
                ELSIF _inputsCount = UINT#0 AND _outputsCount = UINT#32 THEN
                    _UserDataSize_Slot_7 := UINT#32;
                ELSIF _inputsCount = UINT#0 AND _outputsCount = UINT#64 THEN
                    _UserDataSize_Slot_7 := UINT#64;
                ELSIF _inputsCount = UINT#0 AND _outputsCount = UINT#128 THEN
                    _UserDataSize_Slot_7 := UINT#128;
                ELSIF _inputsCount = UINT#0 AND _outputsCount = UINT#254 THEN
                    _UserDataSize_Slot_7 := UINT#254;
                ELSE
                    _UserDataSize_Slot_7 := UINT#0;
                    Messenger.Activate(UINT#776,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#776;    
                END_IF;
                //******************Slot 8*****************//
                _geoAddr.Slot   :=  UINT#8;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HW_UserDataSlot_8);        
                // IF Config.HWIDs.HW_UserDataSlot_8 = UINT#0 THEN
                //     Messenger.Activate(UINT#780,eAxoMessageCategory#Error);
                //     Status.Error.Id := UINT#780;
                //     RETURN;
                // END_IF;
                IF Config.HWIDs.HW_UserDataSlot_8 <> UINT#0 THEN
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
                    ReadHardwareIOAddress(hardwareIdentifier :=  TO_WORD(Config.HWIDs.HW_UserDataSlot_8) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                    IF _inputsCount = UINT#0 AND _outputsCount = UINT#16 THEN
                        _UserDataSize_Slot_8 := UINT#16;
                    ELSIF _inputsCount = UINT#0 AND _outputsCount = UINT#32 THEN
                        _UserDataSize_Slot_8 := UINT#32;
                    ELSIF _inputsCount = UINT#0 AND _outputsCount = UINT#64 THEN
                        _UserDataSize_Slot_8 := UINT#64;
                    ELSIF _inputsCount = UINT#0 AND _outputsCount = UINT#128 THEN
                        _UserDataSize_Slot_8 := UINT#128;
                    ELSIF _inputsCount = UINT#0 AND _outputsCount = UINT#254 THEN
                        _UserDataSize_Slot_8 := UINT#254;
                    ELSE
                        _UserDataSize_Slot_8 := UINT#0;
                        Messenger.Activate(UINT#786,eAxoMessageCategory#Error);
                        Status.Error.Id := UINT#786;    
                    END_IF;
                END_IF;
                //******************Slot 9*****************//
                _geoAddr.Slot   :=  UINT#9;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HW_UserDataSlot_9);        
                IF Config.HWIDs.HW_UserDataSlot_9 <> UINT#0 AND Config.HWIDs.HW_UserDataSlot_8 = UINT#0 THEN  // Slot 7 is mandatory. If there are User data defined at Slot 7, Slot 8 is empty and another data are defined in slot 9 
                    Messenger.Activate(UINT#790,eAxoMessageCategory#Error);             // an error message will prompt to move module from slot 9 to Slot 8
                    Status.Error.Id := UINT#790;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HW_UserDataSlot_9 <> UINT#0 THEN
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
                    ReadHardwareIOAddress(hardwareIdentifier :=  TO_WORD(Config.HWIDs.HW_UserDataSlot_9) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                    IF _inputsCount = UINT#0 AND _outputsCount = UINT#16 THEN
                        _UserDataSize_Slot_9 := UINT#16;
                    ELSIF _inputsCount = UINT#0 AND _outputsCount = UINT#32 THEN
                        _UserDataSize_Slot_9 := UINT#32;
                    ELSIF _inputsCount = UINT#0 AND _outputsCount = UINT#64 THEN
                        _UserDataSize_Slot_9 := UINT#64;
                    ELSIF _inputsCount = UINT#0 AND _outputsCount = UINT#128 THEN
                        _UserDataSize_Slot_9 := UINT#128;
                    ELSIF _inputsCount = UINT#0 AND _outputsCount = UINT#254 THEN
                        _UserDataSize_Slot_9 := UINT#254;
                    ELSE
                        _UserDataSize_Slot_9 := UINT#0;
                        Messenger.Activate(UINT#796,eAxoMessageCategory#Error);
                        Status.Error.Id := UINT#796;    
                    END_IF;
                END_IF;
                //******************Slot 10*****************//
                _geoAddr.Slot   :=  UINT#10;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HW_UserDataSlot_10);        
                IF Config.HWIDs.HW_UserDataSlot_10 <> UINT#0 AND Config.HWIDs.HW_UserDataSlot_9 = UINT#0 THEN     // Slot 7 is mandatory. If there are User data defined at Slot 7, Slot 9 is empty and another data are defined in slot 10 
                    Messenger.Activate(UINT#800,eAxoMessageCategory#Error);                 // an error message will prompt to move module from slot 10 to Slot 9
                    Status.Error.Id := UINT#800;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HW_UserDataSlot_10 <> UINT#0 THEN
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
                    ReadHardwareIOAddress(hardwareIdentifier :=  TO_WORD(Config.HWIDs.HW_UserDataSlot_10) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                    IF _inputsCount = UINT#0 AND _outputsCount = UINT#16 THEN
                        _UserDataSize_Slot_10 := UINT#16;
                    ELSIF _inputsCount = UINT#0 AND _outputsCount = UINT#32 THEN
                        _UserDataSize_Slot_10 := UINT#32;
                    ELSIF _inputsCount = UINT#0 AND _outputsCount = UINT#64 THEN
                        _UserDataSize_Slot_10 := UINT#64;
                    ELSIF _inputsCount = UINT#0 AND _outputsCount = UINT#128 THEN
                        _UserDataSize_Slot_10 := UINT#128;
                    ELSIF _inputsCount = UINT#0 AND _outputsCount = UINT#254 THEN
                        _UserDataSize_Slot_10 := UINT#254;
                    ELSE
                        _UserDataSize_Slot_10 := UINT#0;
                        Messenger.Activate(UINT#806,eAxoMessageCategory#Error);
                        Status.Error.Id := UINT#806;    
                    END_IF;                                                
                END_IF;                                                
                //******************Slot 11*****************//
                _geoAddr.Slot   :=  UINT#11;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HW_ResultData_Slot_11);        
                IF Config.HWIDs.HW_ResultData_Slot_11 = UINT#0 THEN
                    Messenger.Activate(UINT#810,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#810;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HW_ResultData_Slot_11 <> UINT#0 THEN
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
                    ReadHardwareIOAddress(hardwareIdentifier :=  TO_WORD(Config.HWIDs.HW_ResultData_Slot_11) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                    IF _outputsCount = UINT#0 AND _inputsCount = UINT#20 THEN
                        _ResultDataSize_Slot_11 := UINT#16;
                    ELSIF _outputsCount = UINT#0 AND _inputsCount = UINT#36 THEN
                        _ResultDataSize_Slot_11 := UINT#32;
                    ELSIF _outputsCount = UINT#0 AND _inputsCount = UINT#68 THEN
                        _ResultDataSize_Slot_11 := UINT#64;
                    ELSIF _outputsCount = UINT#0 AND _inputsCount = UINT#132 THEN
                        _ResultDataSize_Slot_11 := UINT#128;
                    ELSIF _outputsCount = UINT#0 AND _inputsCount = UINT#254 THEN
                        _ResultDataSize_Slot_11 := UINT#250;
                    ELSE
                        _ResultDataSize_Slot_11 := UINT#0;
                        Messenger.Activate(UINT#816,eAxoMessageCategory#Error);
                        Status.Error.Id := UINT#816;
                    END_IF;
                END_IF;
                //******************Slot 12*****************//
                _geoAddr.Slot   :=  UINT#12;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HW_ResultData_Slot_12);        
                // IF Config.HWIDs.HW_ResultData_Slot_12 = UINT#0 THEN                    
                //     Messenger.Activate(UINT#820,eAxoMessageCategory#Error); 
                //     Status.Error.Id := UINT#820;
                //     RETURN;
                // END_IF;
                IF Config.HWIDs.HW_ResultData_Slot_12 <> UINT#0 THEN
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
                    ReadHardwareIOAddress(hardwareIdentifier :=  TO_WORD(Config.HWIDs.HW_ResultData_Slot_12) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                    IF _outputsCount = UINT#0 AND _inputsCount = UINT#16 THEN
                        _ResultDataSize_Slot_12 := UINT#16;
                    ELSIF _outputsCount = UINT#0 AND _inputsCount = UINT#32 THEN
                        _ResultDataSize_Slot_12 := UINT#32;
                    ELSIF _outputsCount = UINT#0 AND _inputsCount = UINT#64 THEN
                        _ResultDataSize_Slot_12 := UINT#64;
                    ELSIF _outputsCount = UINT#0 AND _inputsCount = UINT#128 THEN
                        _ResultDataSize_Slot_12 := UINT#128;
                    ELSIF _outputsCount = UINT#0 AND _inputsCount = UINT#250 THEN
                        _ResultDataSize_Slot_12 := UINT#250;
                    ELSE
                        _ResultDataSize_Slot_12 := UINT#0;
                        Messenger.Activate(UINT#826,eAxoMessageCategory#Error);
                        Status.Error.Id := UINT#826;
                    END_IF;
                END_IF;
                //******************Slot 13*****************//
                _geoAddr.Slot   :=  UINT#13;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HW_ResultData_Slot_13);        
                IF Config.HWIDs.HW_ResultData_Slot_13 <> UINT#0 AND Config.HWIDs.HW_ResultData_Slot_12 = UINT#0 THEN      // Slot 11 is mandatory. If there are Result data defined at Slot 11, Slot 12 is empty and another data are defined in slot 13 
                    Messenger.Activate(UINT#830,eAxoMessageCategory#Error);                         // an error message will prompt to move module from slot 13 to Slot 12
                    Status.Error.Id := UINT#830;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HW_ResultData_Slot_13 <> UINT#0 THEN
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
                    ReadHardwareIOAddress(hardwareIdentifier :=  TO_WORD(Config.HWIDs.HW_ResultData_Slot_13) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                    IF _outputsCount = UINT#0 AND _inputsCount = UINT#16 THEN
                        _ResultDataSize_Slot_13 := UINT#16;
                    ELSIF _outputsCount = UINT#0 AND _inputsCount = UINT#32 THEN
                        _ResultDataSize_Slot_13 := UINT#32;
                    ELSIF _outputsCount = UINT#0 AND _inputsCount = UINT#64 THEN
                        _ResultDataSize_Slot_13 := UINT#64;
                    ELSIF _outputsCount = UINT#0 AND _inputsCount = UINT#128 THEN
                        _ResultDataSize_Slot_13 := UINT#128;
                    ELSIF _outputsCount = UINT#0 AND _inputsCount = UINT#250 THEN
                        _ResultDataSize_Slot_13 := UINT#250;
                    ELSE
                        _ResultDataSize_Slot_13 := UINT#0;
                        Messenger.Activate(UINT#836,eAxoMessageCategory#Error);
                        Status.Error.Id := UINT#836;
                    END_IF;
                END_IF;
                //******************Slot 14*****************//
                _geoAddr.Slot   :=  UINT#14;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => Config.HWIDs.HW_ResultData_Slot_14);        
                IF Config.HWIDs.HW_ResultData_Slot_14 <> UINT#0 AND Config.HWIDs.HW_ResultData_Slot_13 = UINT#0 THEN      // Slot 11 is mandatory. If there are Result data defined at Slot 11, Slot 13 is empty and another data are defined in slot 14 
                    Messenger.Activate(UINT#840,eAxoMessageCategory#Error);                         // an error message will prompt to move module from slot 14 to Slot 13
                    Status.Error.Id := UINT#840;
                    RETURN;
                END_IF;
                IF Config.HWIDs.HW_ResultData_Slot_14 <> UINT#0 THEN
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
                    ReadHardwareIOAddress(hardwareIdentifier :=  TO_WORD(Config.HWIDs.HW_ResultData_Slot_14) , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                    IF _outputsCount = UINT#0 AND _inputsCount = UINT#16 THEN
                        _ResultDataSize_Slot_14 := UINT#16;
                    ELSIF _outputsCount = UINT#0 AND _inputsCount = UINT#32 THEN
                        _ResultDataSize_Slot_14 := UINT#32;
                    ELSIF _outputsCount = UINT#0 AND _inputsCount = UINT#64 THEN
                        _ResultDataSize_Slot_14 := UINT#64;
                    ELSIF _outputsCount = UINT#0 AND _inputsCount = UINT#128 THEN
                        _ResultDataSize_Slot_14 := UINT#128;
                    ELSIF _outputsCount = UINT#0 AND _inputsCount = UINT#250 THEN
                        _ResultDataSize_Slot_14 := UINT#250;
                    ELSE
                        _ResultDataSize_Slot_14 := UINT#0;
                        Messenger.Activate(UINT#846,eAxoMessageCategory#Error);
                        Status.Error.Id := UINT#846;
                    END_IF;
                END_IF;
                //*************Slot 7 - 10***************************//
                IF _UserDataSize_Slot_7 = UINT#0 AND _UserDataSize_Slot_8 = UINT#0 AND _UserDataSize_Slot_9 = UINT#0 AND _UserDataSize_Slot_10 = UINT#0 THEN
                    Messenger.Activate(UINT#1400,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1400;
                    RETURN;
                END_IF;
                _UserDataSize := _UserDataSize_Slot_7 + _UserDataSize_Slot_8 + _UserDataSize_Slot_9 + _UserDataSize_Slot_10;
                //*************Slot 11 - 14**************************//
                IF _ResultDataSize_Slot_11 = UINT#0 AND _ResultDataSize_Slot_12 = UINT#0 AND _ResultDataSize_Slot_13 = UINT#0 AND _ResultDataSize_Slot_14 = UINT#0 THEN
                    Messenger.Activate(UINT#1401,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1401;
                    RETURN;
                END_IF;
                _ResultDataSize := _ResultDataSize_Slot_11 + _ResultDataSize_Slot_12 + _ResultDataSize_Slot_13 + _ResultDataSize_Slot_14;
                //***************************************************//
                
                IF parent = NULL THEN
                    Messenger.Activate(UINT#1130, eAxoMessageCategory#ProgrammingError);
                    Status.Error.Id := UINT#1130;
                    RETURN;
                ELSIF Config.HWIDs.HW_Device = UINT#0 THEN
                    Messenger.Activate(UINT#1131, eAxoMessageCategory#ProgrammingError);
                    Status.Error.Id := UINT#1131;
                    RETURN;
                ELSIF Config.HWIDs.HW_AcquisitionControl = UINT#0 THEN
                    Messenger.Activate(UINT#1132, eAxoMessageCategory#ProgrammingError);
                    Status.Error.Id := UINT#1132;
                    RETURN;
                ELSIF Config.HWIDs.HW_AcquisitionStatus = UINT#0 THEN
                    Messenger.Activate(UINT#1133, eAxoMessageCategory#ProgrammingError);
                    Status.Error.Id := UINT#1133;
                    RETURN;
                ELSIF Config.HWIDs.HW_InspectionControl = UINT#0 THEN
                    Messenger.Activate(UINT#1134, eAxoMessageCategory#ProgrammingError);
                    Status.Error.Id := UINT#1134;
                    RETURN;
                ELSIF Config.HWIDs.HW_InspectionStatus = UINT#0 THEN
                    Messenger.Activate(UINT#1135, eAxoMessageCategory#ProgrammingError);
                    Status.Error.Id := UINT#1135;
                    RETURN;
                ELSIF Config.HWIDs.HW_CommandControl = UINT#0 THEN
                    Messenger.Activate(UINT#1136, eAxoMessageCategory#ProgrammingError);
                    Status.Error.Id := UINT#1136;
                    RETURN;
                ELSIF Config.HWIDs.HW_SoftEventControl = UINT#0 THEN
                    Messenger.Activate(UINT#1137, eAxoMessageCategory#ProgrammingError);
                    Status.Error.Id := UINT#1137;
                    RETURN;
                ELSIF  Config.HWIDs.HW_UserDataSlot_7 = UINT#0 AND Config.HWIDs.HW_UserDataSlot_8 = UINT#0 AND Config.HWIDs.HW_UserDataSlot_9 = UINT#0 AND Config.HWIDs.HW_UserDataSlot_10 = UINT#0 THEN
                    Messenger.Activate(UINT#1138, eAxoMessageCategory#ProgrammingError);
                    Status.Error.Id := UINT#1138;
                    RETURN;
                ELSIF Config.HWIDs.HW_ResultData_Slot_11 = UINT#0 AND Config.HWIDs.HW_ResultData_Slot_12 = UINT#0 AND Config.HWIDs.HW_ResultData_Slot_13 = UINT#0 AND Config.HWIDs.HW_ResultData_Slot_14 = UINT#0 THEN
                    Messenger.Activate(UINT#1139, eAxoMessageCategory#ProgrammingError);
                    Status.Error.Id := UINT#1139;
                    RETURN; 
                END_IF;

                _initHwCheckDone    := TRUE;
            END_IF;

            //***********Update inputs **************
            _retVal := Siemens.Simatic.S71500.DistributedIO.ReadData(TO_WORD(Config.HWIDs.HW_AcquisitionStatus),_data_255);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1201, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1201;
                RETURN;
            END_IF;

            AcquisitionStatus.TriggerReady                  :=      _data_255[0].%X0;
            AcquisitionStatus.TriggerAcknowledge            :=      _data_255[0].%X1;
            AcquisitionStatus.ExposureComplete              :=      _data_255[0].%X2;
            AcquisitionStatus.MissedAcquisition             :=      _data_255[0].%X3;
            AcquisitionStatus.OfflineReason0                :=      _data_255[0].%X4;
            AcquisitionStatus.OfflineReason1                :=      _data_255[0].%X5;
            AcquisitionStatus.OfflineReason2                :=      _data_255[0].%X6;
            AcquisitionStatus.Online                        :=      _data_255[0].%X7;

            AcquisitionStatus.AcquisitionID.%B1             :=      _data_255[1];	 
            AcquisitionStatus.AcquisitionID.%B0             :=      _data_255[2];	 

            _retVal := Siemens.Simatic.S71500.DistributedIO.ReadData(TO_WORD(Config.HWIDs.HW_InspectionStatus),_data_255);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1202, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1202;
                RETURN;
            END_IF;

            InspectionStatus.SystemBusy                     :=      _data_255[0].%X0;
            InspectionStatus.InspectionCompleted            :=      _data_255[0].%X1;
            InspectionStatus.ResultsBufferOverrun           :=      _data_255[0].%X2;
            InspectionStatus.ResultsValid                   :=      _data_255[0].%X3;
            InspectionStatus.CommandExecuting               :=      _data_255[0].%X4;
            InspectionStatus.CommandComplete                :=      _data_255[0].%X5;
            InspectionStatus.CommandFailed                  :=      _data_255[0].%X6;
            InspectionStatus.ExtendedUserDataSetAcknowledge :=      _data_255[0].%X0;
            InspectionStatus.OverallJobPassFail             :=      _data_255[1].%X0;
            InspectionStatus.TestRunReady                   :=      _data_255[1].%X1;
            InspectionStatus.Error                          :=      _data_255[1].%X7;

            InspectionStatus.ErrorCode.%B1                  :=      _data_255[2];	 
            InspectionStatus.ErrorCode.%B0                  :=      _data_255[3];	 

            _retVal := Siemens.Simatic.S71500.DistributedIO.ReadData(TO_WORD(Config.HWIDs.HW_CommandControl), _data_255);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1203, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1203;
                RETURN;
            END_IF;

            CommandStatus.CurrentJobID.%B0                  :=      _data_255[1];
            CommandStatus.CurrentJobID.%B1                  :=      _data_255[0];

            _retVal := Siemens.Simatic.S71500.DistributedIO.ReadData(TO_WORD(Config.HWIDs.HW_SoftEventControl) ,_data_255);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1204, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1204;
                RETURN;
            END_IF;
            
            SoftEventStatus.TriggerSoftEventAcknowledge.Data[0] :=      _data_255[0].%X0;
            SoftEventStatus.TriggerSoftEventAcknowledge.Data[1] :=      _data_255[0].%X1;
            SoftEventStatus.TriggerSoftEventAcknowledge.Data[2] :=      _data_255[0].%X2;
            SoftEventStatus.TriggerSoftEventAcknowledge.Data[3] :=      _data_255[0].%X3;
            SoftEventStatus.TriggerSoftEventAcknowledge.Data[4] :=      _data_255[0].%X4;
            SoftEventStatus.TriggerSoftEventAcknowledge.Data[5] :=      _data_255[0].%X5;
            SoftEventStatus.TriggerSoftEventAcknowledge.Data[6] :=      _data_255[0].%X6;
            SoftEventStatus.TriggerSoftEventAcknowledge.Data[7] :=      _data_255[0].%X7;

            _retVal := Siemens.Simatic.S71500.DistributedIO.ReadData(TO_WORD(Config.HWIDs.HW_ResultData_Slot_11) ,_data_255);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1205, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1205;
                RETURN;
            END_IF;

            _invalidDataSize := NOT (   _ResultDataSize_Slot_11 = UINT#16  OR
                                        _ResultDataSize_Slot_11 = UINT#32  OR
                                        _ResultDataSize_Slot_11 = UINT#64  OR
                                        _ResultDataSize_Slot_11 = UINT#128 OR
                                        _ResultDataSize_Slot_11 = UINT#250 );

            IF _invalidDataSize THEN
                Messenger.Activate(UINT#1206, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1206;
                RETURN;
            END_IF;
            Results.InspectionID.%B1        :=  _data_255[0];     
            Results.InspectionID.%B0        :=  _data_255[1];     
            Results.ResultCode.%B1          :=  _data_255[2];     
            Results.ResultCode.%B0          :=  _data_255[3];     
            
            IF Config.HWIDs.HW_ResultData_Slot_12 <> UINT#0 THEN
                // going to be read conditionally 
                // _retVal := Siemens.Simatic.S71500.DistributedIO.ReadData(TO_WORD(Config.HWIDs.HW_ResultData_Slot_12) ,_data_in);
                // IF _retVal > WORD#0 THEN
                //     Messenger.Activate(UINT#1207, eAxoMessageCategory#ProgrammingError);
                //     Status.Error.Id := UINT#1207;
                //     RETURN;
                // END_IF;

                _invalidDataSize := NOT (   _ResultDataSize_Slot_12 = UINT#16  OR
                                            _ResultDataSize_Slot_12 = UINT#32  OR
                                            _ResultDataSize_Slot_12 = UINT#64  OR
                                            _ResultDataSize_Slot_12 = UINT#128 OR
                                            _ResultDataSize_Slot_12 = UINT#250 );

                IF _invalidDataSize THEN
                    Messenger.Activate(UINT#1208, eAxoMessageCategory#ProgrammingError);
                    Status.Error.Id := UINT#1208;
                    RETURN;
                END_IF;
            END_IF;
            IF Config.HWIDs.HW_ResultData_Slot_13 <> UINT#0 THEN
                // going to be read conditionally 
                // _retVal := Siemens.Simatic.S71500.DistributedIO.ReadData(TO_WORD(Config.HWIDs.HW_ResultData_Slot_13) ,_data_in);
                // IF _retVal > WORD#0 THEN
                //     Messenger.Activate(UINT#1209, eAxoMessageCategory#ProgrammingError);
                //     Status.Error.Id := UINT#1209;
                //     RETURN;
                // END_IF;

                _invalidDataSize := NOT (   _ResultDataSize_Slot_13 = UINT#16  OR
                                            _ResultDataSize_Slot_13 = UINT#32  OR
                                            _ResultDataSize_Slot_13 = UINT#64  OR
                                            _ResultDataSize_Slot_13 = UINT#128 OR
                                            _ResultDataSize_Slot_13 = UINT#250 );

                IF _invalidDataSize THEN
                    Messenger.Activate(UINT#1210, eAxoMessageCategory#ProgrammingError);
                    Status.Error.Id := UINT#1210;
                    RETURN;
                END_IF;
            END_IF;
            IF Config.HWIDs.HW_ResultData_Slot_14 <> UINT#0 THEN
                // going to be read conditionally 
                // _retVal := Siemens.Simatic.S71500.DistributedIO.ReadData(TO_WORD(Config.HWIDs.HW_ResultData_Slot_14) ,_data_in);
                // IF _retVal > WORD#0 THEN
                //     Messenger.Activate(UINT#1211, eAxoMessageCategory#ProgrammingError);
                //     Status.Error.Id := UINT#1211;
                //     RETURN;
                // END_IF;

                _invalidDataSize := NOT (   _ResultDataSize_Slot_14 = UINT#16  OR
                                            _ResultDataSize_Slot_14 = UINT#32  OR
                                            _ResultDataSize_Slot_14 = UINT#64  OR
                                            _ResultDataSize_Slot_14 = UINT#128 OR
                                            _ResultDataSize_Slot_14 = UINT#250 );

                IF _invalidDataSize THEN
                    Messenger.Activate(UINT#1212, eAxoMessageCategory#ProgrammingError);
                    Status.Error.Id := UINT#1212;
                    RETURN;
                END_IF;
            END_IF;

            Config.ResultDataSize := _ResultDataSize;
            
            //**************************************Execute inline********************
            RestoreTask.Run(THIS);
            ClearInspectionResultsTask.Run(THIS);
            TriggerTask.Run(THIS);
            ChangeJobByNameTask.Run(THIS);
            ChangeJobByNumberTask.Run(THIS);
            SoftEventTask.Run(THIS);
            SendUserDataTask.Run(THIS);
            HardwareDiagnosticsTask.Run(THIS,TO_WORD(Config.HWIDs.HW_Device));
            //*************Restore********************
            RestoreTask.IsDisabled := FALSE;
            IF RestoreTask.Execute(THIS) THEN
                THIS.Restore();
            END_IF;
            //****************************************

            //************* ClearInspectionResults****
            ClearInspectionResultsTask.IsDisabled := RestoreTask.IsBusy() OR TriggerTask.IsBusy() OR ChangeJobByNameTask.IsBusy() OR ChangeJobByNumberTask.IsBusy() OR SoftEventTask.IsBusy() OR SendUserDataTask.IsBusy();
            IF ClearInspectionResultsTask.StartTriggered() THEN
                Status.Action.Id :=  UINT#100;
            END_IF;
            Messenger.ActivateOnCondition(ULINT#100,ClearInspectionResultsTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#101,ClearInspectionResultsTask.IsDone(), eAxoMessageCategory#Info);
            IF ClearInspectionResultsTask.Execute(THIS) THEN
                IF _progress = 0 THEN
                    Status.Error.Id :=  UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 300;
                END_IF;
                
                IF _progress = 300 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#500, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#500;
                    END_IF;

                    AcquisitionControl.TriggerEnable := FALSE;
                    AcquisitionControl.Trigger := FALSE;
                    InspectionControl.AcknowledgeInspectionResults := TRUE;
                    Results.InspectionID := UINT#0; 
                    Results.ResultCode := UINT#0; 

                    FOR _index := 0 TO _maxResultDataIndex DO
                        InspectionResults.Data[_index] := BYTE#0;
                    END_FOR;
                    InspectionResults.DataChanged := NOT InspectionResults.DataChanged ;

                    THIS.CallTimers(FALSE);
                    _progress := 301;
                END_IF;
                
                IF _progress = 301 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#501, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#501;
                    END_IF;

                    IF NOT InspectionStatus.ResultsValid THEN
                        THIS.CallTimers(FALSE);
                        _progress := 302;
                    END_IF;
                END_IF;
                
                IF _progress = 302 THEN
                    InspectionControl.AcknowledgeInspectionResults := TRUE;
                    ClearInspectionResultsTask.DoneWhen(TRUE);
                    THIS.CallTimers(FALSE);
                    _progress := 0;
                END_IF;
                
                THIS.CallTimers(TRUE);
                
                ClearInspectionResultsTask.ThrowWhen(_errorTimer.output);

                Status.Action.Id := TO_UINT(_progress);
            END_IF;
            IF ClearInspectionResultsTask.DoneReached() THEN
                Status.Action.Id :=  UINT#101;
                Status.Error.Id :=  UINT#0;
            ELSIF ClearInspectionResultsTask.ErrorOccured() THEN
                Status.Action.Id :=  UINT#10000;
                Status.Error.Id  :=  UINT#10000;
            ELSIF ClearInspectionResultsTask.AbortTriggered()THEN
                Status.Action.Id :=  UINT#10001;
                Status.Error.Id  :=  UINT#10001;
            END_IF;     
            Messenger.ActivateOnCondition(ULINT#10000,ClearInspectionResultsTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#10001,ClearInspectionResultsTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#102,ClearInspectionResultsTask.RestoreTriggered() , eAxoMessageCategory#Error);
            IF ClearInspectionResultsTask.RestoreTriggered() AND _progress >= 300 AND _progress <= 309  THEN
                Status.Action.Id :=  UINT#102;
                _progress := 0;
            END_IF;
            //****************************************
            //*************Trigger********************
            TriggerTask.IsDisabled :=  RestoreTask.IsBusy() OR ClearInspectionResultsTask.IsBusy() OR ChangeJobByNameTask.IsBusy() OR ChangeJobByNumberTask.IsBusy() OR SoftEventTask.IsBusy() OR SendUserDataTask.IsBusy();
            IF TriggerTask.StartTriggered() THEN
                Status.Action.Id :=  UINT#110;
            END_IF;
            Messenger.ActivateOnCondition(ULINT#110,TriggerTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#111,TriggerTask.IsDone(), eAxoMessageCategory#Info);
            IF TriggerTask.Execute(THIS) THEN
                IF _progress = 0 THEN
                    Status.Error.Id :=  UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 310;
                END_IF;

                IF _progress = 310 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#510, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#510;
                    END_IF;

                    AcquisitionControl.TriggerEnable  := TRUE;
                    AcquisitionControl.Trigger := FALSE;
                    AcquisitionControl.ClearExposureComplete := AcquisitionStatus.ExposureComplete;
                    AcquisitionControl.SetOffline := FALSE;
                
                    InspectionControl.EnableResultsBuffering := FALSE; 
                    InspectionControl.AcknowledgeInspectionResults := InspectionStatus.ResultsValid;
                    InspectionControl.ExtendedUserDataSet := FALSE;
                    InspectionControl.ExecuteCommand := FALSE;
                    InspectionControl.ClearError := InspectionStatus.Error;
    
                    CommandControl.Command:= UINT#0;
                    _progress := 311;
                END_IF;

                IF _progress = 311 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#511, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#511;
                    END_IF;

                    IF NOT AcquisitionStatus.ExposureComplete THEN
                        AcquisitionControl.ClearExposureComplete := FALSE;
                        THIS.CallTimers(FALSE);
                        _progress :=312;
                    END_IF;
                END_IF;
                
                IF _progress = 312 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#512, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#512;
                    END_IF;

                    IF NOT InspectionStatus.ResultsValid THEN
                        InspectionControl.AcknowledgeInspectionResults := FALSE;
                        THIS.CallTimers(FALSE);
                        _progress := 313;
                    END_IF;
                END_IF;
                
                IF _progress = 313 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#513, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#513;
                    END_IF;

                    IF NOT InspectionStatus.Error THEN
                        InspectionControl.ClearError := FALSE;
                        THIS.CallTimers(FALSE);
                        _progress := 314;
                    END_IF;
                END_IF;
                
                IF _progress = 314 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#514, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#514;
                    END_IF;

                    _inspectionCompleted := InspectionStatus.InspectionCompleted;
                    IF AcquisitionStatus.TriggerReady THEN
                        THIS.CallTimers(FALSE);
                        _progress := 315;
                    END_IF;
                END_IF;
                
                IF _progress = 315 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#515, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#515;
                    END_IF;

                    AcquisitionControl.Trigger := TRUE;
                    IF AcquisitionStatus.TriggerAcknowledge THEN
                        THIS.CallTimers(FALSE);
                        _progress := 316;
                    END_IF;
                END_IF;
                
                IF _progress = 316 THEN	
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#516, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#516;
                    END_IF;

                    AcquisitionControl.Trigger := FALSE;
                    IF _inspectionCompleted <> InspectionStatus.InspectionCompleted THEN
                        THIS.CallTimers(FALSE);
                        _progress := 317;
                    END_IF;
                END_IF;
            
                IF _progress = 317 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#517, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#517;
                    END_IF;

                    IF InspectionStatus.ResultsValid THEN
                        THIS.CallTimers(FALSE);
                        _progress := 318;
                    END_IF;
                END_IF;
                
                IF _progress = 318 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#518, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#518;
                    END_IF;
                    _offset     :=  UINT#4;
                    _fromFor    :=  UINT#0;
                    // Slot 11
                    IF _ResultDataSize > _ResultDataSize_Slot_11 THEN
                        _toFor := _ResultDataSize_Slot_11 - UINT#1;
                    ELSE
                        _toFor := _ResultDataSize - UINT#1;
                    END_IF;
                    FOR _index := _fromFor TO _toFor DO
                        InspectionResults.Data[_index] := _data_255[_index + _offset];
                    END_FOR;
                    // Slot 12
                    IF _ResultDataSize > _ResultDataSize_Slot_11 AND _ResultDataSize_Slot_12 > UINT#0 THEN
                        IF _ResultDataSize > _ResultDataSize_Slot_12 + _ResultDataSize_Slot_11 THEN
                            _toFor := _ResultDataSize_Slot_12 - UINT#1;
                        ELSE
                            _toFor := _ResultDataSize - _ResultDataSize_Slot_11 - UINT#1;
                        END_IF;
                        _fromFor    :=  UINT#0;
                        _offset     :=  _ResultDataSize_Slot_11;
                        _retVal := Siemens.Simatic.S71500.DistributedIO.ReadData(TO_WORD(Config.HWIDs.HW_ResultData_Slot_12) ,_data_255);
                        IF _retVal > WORD#0 THEN
                            Messenger.Activate(UINT#1207, eAxoMessageCategory#ProgrammingError);
                            Status.Error.Id := UINT#1207;
                            RETURN;
                        END_IF;
                        FOR _index := _fromFor TO _toFor DO
                            InspectionResults.Data[_index + _offset] := _data_255[_index];
                        END_FOR;
                    END_IF;
                    // Slot 13
                    IF _ResultDataSize > (_ResultDataSize_Slot_11 + _ResultDataSize_Slot_12) AND _ResultDataSize_Slot_13 > UINT#0 THEN
                        IF _ResultDataSize > _ResultDataSize_Slot_13 + _ResultDataSize_Slot_12 + _ResultDataSize_Slot_11 THEN
                            _toFor := _ResultDataSize_Slot_13 - UINT#1;
                        ELSE
                            _toFor := _ResultDataSize - _ResultDataSize_Slot_12 - _ResultDataSize_Slot_11 - UINT#1;
                        END_IF;
                        _fromFor    :=  UINT#0;
                        _offset     :=  _ResultDataSize_Slot_11 + _ResultDataSize_Slot_12;
                        _retVal := Siemens.Simatic.S71500.DistributedIO.ReadData(TO_WORD(Config.HWIDs.HW_ResultData_Slot_13) ,_data_255);
                        IF _retVal > WORD#0 THEN
                            Messenger.Activate(UINT#1209, eAxoMessageCategory#ProgrammingError);
                            Status.Error.Id := UINT#1209;
                            RETURN;
                        END_IF;
                        FOR _index := _fromFor TO _toFor DO
                            InspectionResults.Data[_index + _offset] := _data_255[_index];
                        END_FOR;
                    END_IF;
                    // Slot 14
                    IF _ResultDataSize > (_ResultDataSize_Slot_11 + _ResultDataSize_Slot_12 + _ResultDataSize_Slot_13) (*AND _ResultDataSize_Slot_14 > UINT#0*) THEN
                        // IF _ResultDataSize > _ResultDataSize_Slot_14 + _ResultDataSize_Slot_13 + _ResultDataSize_Slot_12 + _ResultDataSize_Slot_11 THEN
                        //     _toFor := TO_INT(_ResultDataSize_Slot_13) - INT#1;
                        // ELSE
                            _toFor := _ResultDataSize - _ResultDataSize_Slot_13 - _ResultDataSize_Slot_12 - _ResultDataSize_Slot_11 - UINT#1;
                        // END_IF;
                        _fromFor    :=  UINT#0;
                        _offset     :=  _ResultDataSize_Slot_11 + _ResultDataSize_Slot_12 + _ResultDataSize_Slot_13;
                        _retVal := Siemens.Simatic.S71500.DistributedIO.ReadData(TO_WORD(Config.HWIDs.HW_ResultData_Slot_14) ,_data_255);
                        IF _retVal > WORD#0 THEN
                            Messenger.Activate(UINT#1211, eAxoMessageCategory#ProgrammingError);
                            Status.Error.Id := UINT#1211;
                            RETURN;
                        END_IF;
                        FOR _index := _fromFor TO _toFor DO
                            InspectionResults.Data[_index + _offset] := _data_255[_index];
                        END_FOR;
                    END_IF;
                    // Cleaning the rest of the array
                    FOR _index := Config.ResultDataSize TO _maxResultDataIndex DO
                        InspectionResults.Data[_index] := BYTE#0;
                    END_FOR;
                    InspectionResults.DataChanged := NOT InspectionResults.DataChanged ;
                    _progress := 319;
                END_IF;

                IF _progress = 319 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#519, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#519;
                    END_IF;

                    AcquisitionControl.Trigger := FALSE;
                    InspectionControl.EnableResultsBuffering := FALSE;
                    InspectionControl.AcknowledgeInspectionResults := TRUE;
                    TriggerTask.ThrowWhen(InspectionStatus.Error);
                    TriggerTask.DoneWhen(TRUE);
                    _progress := 0;
                END_IF;               


                THIS.CallTimers(TRUE);
                
                TriggerTask.ThrowWhen(_errorTimer.output);

                Status.Action.Id := TO_UINT(_progress);
            END_IF;
            IF TriggerTask.DoneReached() THEN
                Status.Action.Id :=  UINT#111;
                Status.Error.Id :=  UINT#0;
            ELSIF TriggerTask.ErrorOccured() THEN
                Status.Action.Id :=  UINT#10010;
                Status.Error.Id  :=  UINT#10010;
            ELSIF TriggerTask.AbortTriggered() THEN
                Status.Action.Id :=  UINT#10011;
                Status.Error.Id  :=  UINT#10011;
            END_IF;         
            Messenger.ActivateOnCondition(ULINT#10010,TriggerTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#10011,TriggerTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#112,TriggerTask.RestoreTriggered() , eAxoMessageCategory#Error);
            IF TriggerTask.RestoreTriggered() AND _progress >= 310 AND _progress <= 319  THEN
                Status.Action.Id :=  UINT#112;
                _progress := 0;
            END_IF;   
            //****************************************

            //*************ChangeJobByName************
            ChangeJobByNameTask.IsDisabled :=  RestoreTask.IsBusy() OR ClearInspectionResultsTask.IsBusy() OR TriggerTask.IsBusy() OR ChangeJobByNumberTask.IsBusy() OR SoftEventTask.IsBusy() OR SendUserDataTask.IsBusy();
            IF ChangeJobByNameTask.StartTriggered() THEN
                Status.Action.Id :=  UINT#120;
            END_IF;
            Messenger.ActivateOnCondition(ULINT#120,ChangeJobByNameTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#121,ChangeJobByNameTask.IsDone(), eAxoMessageCategory#Info);
            IF ChangeJobByNameTask.Execute(THIS) THEN
                IF _progress = 0 THEN
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    Status.CurrentJobName := '';
                    Status.CurrentJobNumber := UINT#0;
                    THIS.CallTimers(FALSE);
                    _progress := 320;
                END_IF;

                IF _progress = 320 THEN
                    THIS.CallTimers(FALSE);
                    IF _jobName='' THEN
                        TaskMessenger.Activate( UINT#520, eAxoMessageCategory#Error);
                        Status.Error.Id :=      UINT#520;
                        ChangeJobByNameTask.ThrowWhen(TRUE);
                    ELSE	
                        _progress := 321;
                    END_IF;
                END_IF;

                IF _progress = 321 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#521, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#521;
                    END_IF;

                    InspectionControl.ExecuteCommand:=FALSE;
                    InspectionControl.ClearError:=TRUE;
                    AcquisitionControl.SetOffline := FALSE;
                    IF NOT InspectionStatus.CommandExecuting THEN
                        THIS.CallTimers(FALSE);
                        _progress := 322;
                    END_IF;
                END_IF;
                
                IF _progress = 322 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#522, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#522;
                    END_IF;

                    AcquisitionControl.SetOffline := TRUE;
                    IF(NOT AcquisitionStatus.Online) THEN
                        THIS.CallTimers(FALSE);
                        _progress := 323;
                    END_IF;
                END_IF;
                
                IF _progress = 323 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#523, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#523;
                    END_IF;

                    AcquisitionControl.SetOffline := TRUE;
                    InspectionControl.ExecuteCommand := FALSE;
                    InspectionControl.ClearError := InspectionStatus.Error;
                    IF NOT InspectionStatus.Error THEN
                        THIS.CallTimers(FALSE);
                        _progress := 324;
                    END_IF;
                END_IF;
                
                IF _progress = 324 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#524, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#524;
                    END_IF;

                    AcquisitionControl.SetOffline := TRUE;

                    Serialize(UINT#0, _jobName, _data_255);
                    FOR _index := INT#0 TO (TO_UINT(LengthOf(_jobName)) - UINT#1) BY UINT#1 DO
                        _userData.Data[_index] := _data_255[_index + UINT#1];
                    END_FOR;
                    FOR _index := LengthOf(_jobName) TO _maxUserDataIndex BY UINT#1 DO
                        _userData.Data[_index] :=BYTE#0;
                    END_FOR;
                    
                    IF THIS.SetUserData(_userData,TO_UINT(LengthOf(_jobName))) THEN
                        THIS.CallTimers(FALSE);
                        _progress := 325;
                    END_IF;
                END_IF;
                
                IF _progress = 325 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#525, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#525;
                    END_IF;

                    // UserData.ToggleDataChangedFlag();

                    AcquisitionControl.SetOffline := TRUE;
                    InspectionControl.ExtendedUserDataSet := TRUE;
                    CommandControl.Command := UINT#16384;//16#4000;
                    InspectionControl.ExecuteCommand:=TRUE;

                    IF(InspectionStatus.ExtendedUserDataSetAcknowledge OR(InspectionStatus.CommandComplete AND NOT InspectionStatus.CommandFailed)) THEN
                        THIS.CallTimers(FALSE);
                        _progress := 326;
                    END_IF;            
                END_IF;
                
                IF _progress = 326 THEN	
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#526, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#526;
                    END_IF;

                    AcquisitionControl.SetOffline := TRUE;
                    InspectionControl.ExtendedUserDataSet := FALSE;
                    CommandControl.Command := UINT#16384;//16#4000;
                    InspectionControl.ExecuteCommand:=TRUE;
                                        
                    IF(NOT InspectionStatus.ExtendedUserDataSetAcknowledge) THEN
                        THIS.CallTimers(FALSE);
                        _progress := 327;
                    END_IF;
                END_IF;
            
                IF _progress = 327 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#527, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#527;
                    END_IF;

                    AcquisitionControl.SetOffline := TRUE;
                    CommandControl.Command := UINT#16384;//16#4000;
                    InspectionControl.ExecuteCommand:=TRUE;
                    
                    IF(InspectionStatus.CommandComplete AND NOT InspectionStatus.CommandFailed) THEN
                        THIS.CallTimers(FALSE);
                        _progress := 328;
                    ELSIF(InspectionStatus.CommandComplete AND InspectionStatus.CommandFailed AND NOT InspectionStatus.CommandExecuting) THEN
                        _progress := 339;
                    END_IF;
                END_IF;
                
                IF _progress = 328 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#528, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#528;
                    END_IF;

                    AcquisitionControl.SetOffline := TRUE;
                    CommandControl.Command := UINT#0;
                    InspectionControl.ExecuteCommand:=FALSE;
                    IF(NOT InspectionStatus.CommandComplete) THEN
                        THIS.CallTimers(FALSE);
                        _progress := 329;
                    END_IF;
                END_IF;
                
                IF _progress = 329 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#529, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#529;
                    END_IF;

                    AcquisitionControl.SetOffline := FALSE;
                    
                    IF(AcquisitionStatus.Online) THEN
                        THIS.CallTimers(FALSE);
                        _progress := 330;
                    END_IF;
                END_IF;               

                IF _progress = 330 THEN
                    Status.CurrentJobName := _jobName;
                    InspectionControl.ExecuteCommand := FALSE;
                    AcquisitionControl.SetOffline := FALSE;
                    InspectionControl.ClearError := FALSE;
                    CommandControl.Command := UINT#0;
                    ChangeJobByNameTask.DoneWhen(TRUE);
                    _progress := 0;
                END_IF;               

                IF _progress = 339 THEN
                    InspectionControl.ExecuteCommand := FALSE;
                    AcquisitionControl.SetOffline := FALSE;
                    CommandControl.Command := UINT#0;
                    ChangeJobByNameTask.ThrowWhen(TRUE);
                END_IF;               

                THIS.CallTimers(TRUE);
                ChangeJobByNameTask.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);
            END_IF;
            IF ChangeJobByNameTask.DoneReached() THEN
                Status.Action.Id :=  UINT#121;
                Status.Error.Id :=  UINT#0;
            ELSIF ChangeJobByNameTask.ErrorOccured() THEN
                Status.Action.Id :=  UINT#10020;
                Status.Error.Id  :=  UINT#10020;
            ELSIF ChangeJobByNameTask.AbortTriggered() THEN
                Status.Action.Id :=  UINT#10021;
                Status.Error.Id  :=  UINT#10021;
            END_IF; 
            Messenger.ActivateOnCondition(ULINT#10020,ChangeJobByNameTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#10021,ChangeJobByNameTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#122,ChangeJobByNameTask.RestoreTriggered() , eAxoMessageCategory#Error);
            IF ChangeJobByNameTask.RestoreTriggered() AND _progress >= 320 AND _progress <= 339  THEN
                Status.Action.Id :=  UINT#122;
                _progress := 0;
            END_IF;  
            //****************************************

            //*************ChangeJobByNumber**********
            ChangeJobByNumberTask.IsDisabled :=  RestoreTask.IsBusy() OR ClearInspectionResultsTask.IsBusy() OR TriggerTask.IsBusy() OR ChangeJobByNameTask.IsBusy() OR SoftEventTask.IsBusy() OR SendUserDataTask.IsBusy();
            IF ChangeJobByNumberTask.StartTriggered() THEN
                Status.Action.Id :=  UINT#140;
            END_IF;
            Messenger.ActivateOnCondition(ULINT#140,ChangeJobByNumberTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#141,ChangeJobByNumberTask.IsDone(), eAxoMessageCategory#Info);
            IF ChangeJobByNumberTask.Execute(THIS) THEN
                IF _progress = 0 THEN
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    Status.CurrentJobName := '';
                    Status.CurrentJobNumber := UINT#0;
                    THIS.CallTimers(FALSE);
                    _progress := 340;
                END_IF;

                IF _progress = 340 THEN
                    THIS.CallTimers(FALSE);
                    
                    IF _jobNumber > Config.MaxJobNumber THEN 
                        TaskMessenger.Activate( UINT#540, eAxoMessageCategory#Error);
                        Status.Error.Id :=      UINT#540;
                        ChangeJobByNumberTask.ThrowWhen(TRUE);
                    ELSIF _jobNumber = CommandStatus.CurrentJobID THEN 
                        _progress := 347;
                    ELSE	
                        _progress := 341;
                    END_IF;
                END_IF;

                IF _progress = 341 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#541, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#541;
                    END_IF;

                    InspectionControl.ExecuteCommand:=FALSE;
                    InspectionControl.ClearError:=FALSE;
                    AcquisitionControl.SetOffline := FALSE;
                    IF NOT InspectionStatus.CommandExecuting THEN
                        THIS.CallTimers(FALSE);
                        _progress := 342;
                    END_IF;
                END_IF;
                
                IF _progress = 342 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#542, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#542;
                    END_IF;

                    AcquisitionControl.SetOffline := TRUE;
                    IF(NOT AcquisitionStatus.Online) THEN
                        THIS.CallTimers(FALSE);
                        _progress := 343;
                    END_IF;
                END_IF;
                
                IF _progress = 343 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#543, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#543;
                    END_IF;

                    AcquisitionControl.SetOffline := TRUE;
                    InspectionControl.ExecuteCommand := FALSE;
                    InspectionControl.ClearError := InspectionStatus.Error;
                    IF NOT InspectionStatus.Error THEN
                        THIS.CallTimers(FALSE);
                        _progress := 344;
                    END_IF;
                END_IF;
                
                IF _progress = 344 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#544, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#544;
                    END_IF;

                    AcquisitionControl.SetOffline := TRUE;
                    CommandControl.Command := _jobNumber;
                    InspectionControl.ExecuteCommand:=TRUE;
                    
                    IF(InspectionStatus.CommandComplete AND NOT InspectionStatus.CommandFailed) THEN
                        THIS.CallTimers(FALSE);
                        _progress := 345;
                    ELSIF(InspectionStatus.CommandComplete AND InspectionStatus.CommandFailed AND NOT InspectionStatus.CommandExecuting) THEN
                        _progress := 349;
                    END_IF;
                END_IF;
                
                IF _progress = 345 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#545, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#545;
                    END_IF;

                    AcquisitionControl.SetOffline := TRUE;
                    CommandControl.Command := UINT#0;
                    InspectionControl.ExecuteCommand:=FALSE;
                    IF(NOT InspectionStatus.CommandComplete) THEN
                        THIS.CallTimers(FALSE);
                        _progress := 346;
                    END_IF;
                END_IF;
                
                IF _progress = 346 THEN	
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#546, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#546;
                    END_IF;

                    AcquisitionControl.SetOffline := FALSE;
                    IF(AcquisitionStatus.Online) THEN
                        THIS.CallTimers(FALSE);
                        _progress := 347;
                    END_IF;
                END_IF;

                IF _progress = 347 THEN
                    Status.CurrentJobNumber := _jobNumber;
                    InspectionControl.ExecuteCommand := FALSE;
                    AcquisitionControl.SetOffline := FALSE;
                    InspectionControl.ClearError := FALSE;
                    CommandControl.Command := UINT#0;
                    ChangeJobByNumberTask.DoneWhen(TRUE);
                    _progress := 0;            
                END_IF;               

                IF _progress = 349 THEN
                    InspectionControl.ExecuteCommand := FALSE;
                    AcquisitionControl.SetOffline := FALSE;
                    CommandControl.Command := UINT#0;
                    ChangeJobByNumberTask.ThrowWhen(TRUE);
                END_IF;                   

                THIS.CallTimers(TRUE);
                ChangeJobByNumberTask.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);
            END_IF;
            IF ChangeJobByNumberTask.DoneReached() THEN
                Status.Action.Id :=  UINT#141;
                Status.Error.Id :=  UINT#0;
            ELSIF ChangeJobByNumberTask.ErrorOccured() THEN
                Status.Action.Id :=  UINT#10040;
                Status.Error.Id  :=  UINT#10040;
            ELSIF ChangeJobByNumberTask.AbortTriggered() THEN
                Status.Action.Id :=  UINT#10041;
                Status.Error.Id  :=  UINT#10041;
            END_IF;    
            Messenger.ActivateOnCondition(ULINT#10040,ChangeJobByNumberTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#10041,ChangeJobByNumberTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#142,ChangeJobByNumberTask.RestoreTriggered() , eAxoMessageCategory#Error);
            IF ChangeJobByNumberTask.RestoreTriggered() AND _progress >= 340 AND _progress <= 349 THEN
                Status.Action.Id :=  UINT#142;
                _progress := 0;
            END_IF;  
            //****************************************

            //*************SoftEvent******************
            SoftEventTask.IsDisabled :=  RestoreTask.IsBusy() OR ClearInspectionResultsTask.IsBusy() OR TriggerTask.IsBusy() OR ChangeJobByNameTask.IsBusy() OR ChangeJobByNumberTask.IsBusy() OR SendUserDataTask.IsBusy();
            IF SoftEventTask.StartTriggered() THEN
                Status.Action.Id :=  UINT#150;
            END_IF;
            Messenger.ActivateOnCondition(ULINT#150,SoftEventTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#151,SoftEventTask.IsDone(), eAxoMessageCategory#Info);
            IF SoftEventTask.Execute(THIS) THEN
                IF _progress = 0 THEN
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 350;
                END_IF;

                IF _progress = 350 THEN
                    THIS.CallTimers(FALSE);
                    IF _softEventNumber > UINT#7 THEN
                        TaskMessenger.Activate( UINT#550, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#550;
                        SoftEventTask.ThrowWhen(TRUE);
                    ELSE	
                        _progress := 351;
                    END_IF;
                END_IF;

                IF _progress = 351 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#551, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#551;
                    END_IF;
                    _progress := 352;
                END_IF;
                
                IF _progress = 352 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#552, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#552;
                    END_IF;

                    SoftEventControl.TriggerSoftEvent.Data[_softEventNumber] := TRUE;
                    SoftEventControl.TriggerSoftEvent.ToggleDataChangedFlag();
                    IF SoftEventStatus.TriggerSoftEventAcknowledge.Data[_softEventNumber] THEN
                        SoftEventStatus.TriggerSoftEventAcknowledge.ToggleDataChangedFlag();
                        THIS.CallTimers(FALSE);
                        _progress := 353;
                    END_IF;
                END_IF;
                
                IF _progress = 353 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#553, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#553;
                    END_IF;

                    SoftEventControl.TriggerSoftEvent.Data[_softEventNumber] := FALSE;
                    SoftEventControl.TriggerSoftEvent.ToggleDataChangedFlag();
                    IF NOT SoftEventStatus.TriggerSoftEventAcknowledge.Data[_softEventNumber] THEN
                        SoftEventStatus.TriggerSoftEventAcknowledge.ToggleDataChangedFlag();
                        THIS.CallTimers(FALSE);
                        _progress := 354;
                    END_IF;
                END_IF;
                
                IF _progress = 354 THEN
                    SoftEventTask.DoneWhen(TRUE);
                    _progress := 0;            
                END_IF;               

                THIS.CallTimers(TRUE);
                SoftEventTask.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);
            END_IF;
            IF SoftEventTask.DoneReached() THEN
                Status.Action.Id :=  UINT#151;
                Status.Error.Id :=  UINT#0;
            ELSIF SoftEventTask.ErrorOccured() THEN
                Status.Action.Id :=  UINT#10050;
                Status.Error.Id  :=  UINT#10050;
            ELSIF SoftEventTask.AbortTriggered() THEN
                Status.Action.Id :=  UINT#10051;
                Status.Error.Id  :=  UINT#10051;
            END_IF; 
            Messenger.ActivateOnCondition(ULINT#10050,SoftEventTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#10051,SoftEventTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#152,SoftEventTask.RestoreTriggered() , eAxoMessageCategory#Error);
            IF SoftEventTask.RestoreTriggered() AND _progress >= 350 AND _progress <= 359 THEN
                Status.Action.Id :=  UINT#152;
                _progress := 0;
            END_IF;   
            //******************************************      
            
            //*************SendUserData*****************
            SendUserDataTask.IsDisabled :=   RestoreTask.IsBusy() OR ClearInspectionResultsTask.IsBusy() OR TriggerTask.IsBusy() OR ChangeJobByNameTask.IsBusy() OR ChangeJobByNumberTask.IsBusy()  OR SoftEventTask.IsBusy();
            IF SendUserDataTask.StartTriggered() THEN
                Status.Action.Id :=  UINT#160;
            END_IF;
            Messenger.ActivateOnCondition(ULINT#160,SendUserDataTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#161,SendUserDataTask.IsDone(), eAxoMessageCategory#Info);
            IF SendUserDataTask.Execute(THIS) THEN
                IF _progress = 0 THEN
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 360;
                END_IF;

                IF _progress = 360 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#560, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#560;
                    END_IF;

                    InspectionControl.ExecuteCommand := FALSE;
                    InspectionControl.ClearError := FALSE;
                    AcquisitionControl.SetOffline := FALSE;

                    IF THIS.SetUserData(_userData, _userDataLength) THEN
                        THIS.CallTimers(FALSE);
                        _progress := 361;
                    END_IF;
                END_IF;
                
                IF _progress = 361 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#561, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#561;
                    END_IF;

                    InspectionControl.ExtendedUserDataSet := TRUE;

                    IF InspectionStatus.ExtendedUserDataSetAcknowledge OR _infoTimer.elapsedTime >=T#1S THEN
                        THIS.CallTimers(FALSE);
                        _progress := 362;
                    END_IF;
                END_IF;

                IF _progress = 362 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#562, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#562;
                    END_IF;

                    InspectionControl.ExtendedUserDataSet := FALSE;

                    IF NOT InspectionStatus.ExtendedUserDataSetAcknowledge THEN
                        THIS.CallTimers(FALSE);
                        _progress := 363;
                    END_IF;
                END_IF;

                IF _progress = 363 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#563, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#563;
                    END_IF;

                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 364;
                    END_IF;
                END_IF;

                IF _progress = 364 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#564, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#564;
                    END_IF;

                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 365;
                    END_IF;
                END_IF;

                IF _progress = 365 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#565, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#565;
                    END_IF;

                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 366;
                    END_IF;
                END_IF;

                IF _progress = 366 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#566, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#566;
                    END_IF;

                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 367;
                    END_IF;
                END_IF;

                IF _progress = 367 THEN
                    SendUserDataTask.DoneWhen(TRUE);
                    _progress := 0;            
                END_IF;               

                THIS.CallTimers(TRUE);
                SendUserDataTask.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);
            END_IF;
            IF SendUserDataTask.DoneReached() THEN
                Status.Action.Id :=  UINT#161;
                Status.Error.Id :=  UINT#0;
            ELSIF SendUserDataTask.ErrorOccured() THEN
                Status.Action.Id :=  UINT#10060;
                Status.Error.Id  :=  UINT#10060;
            ELSIF SoftEventTask.AbortTriggered() THEN
                Status.Action.Id :=  UINT#10061;
                Status.Error.Id  :=  UINT#10061;
            END_IF; 
            Messenger.ActivateOnCondition(ULINT#10060,SendUserDataTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#10061,SendUserDataTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#162,SendUserDataTask.RestoreTriggered() , eAxoMessageCategory#Error);
            IF SendUserDataTask.RestoreTriggered() AND _progress >= 360 AND _progress <= 369 THEN
                Status.Action.Id :=  UINT#162;
                _progress := 0;
            END_IF;   
            //******************************************      

            //***********Update outputs ****************
            _data_1[0].%X0              :=      AcquisitionControl.TriggerEnable;
            _data_1[0].%X1              :=      AcquisitionControl.Trigger;
            _data_1[0].%X2              :=      AcquisitionControl.ClearExposureComplete;
            _data_1[0].%X7              :=      AcquisitionControl.SetOffline;

            _retVal := Siemens.Simatic.S71500.DistributedIO.WriteData(TO_WORD(Config.HWIDs.HW_AcquisitionControl),_data_1);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1231, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1231;
                RETURN;
            END_IF;  

            _data_1[0].%X0               :=      InspectionControl.EnableResultsBuffering;
            _data_1[0].%X1               :=      InspectionControl.AcknowledgeInspectionResults;
            _data_1[0].%X2               :=      InspectionControl.ExtendedUserDataSet;
            _data_1[0].%X3               :=      InspectionControl.ExecuteCommand;
            _data_1[0].%X7               :=      InspectionControl.ClearError;

            _retVal := Siemens.Simatic.S71500.DistributedIO.WriteData(TO_WORD(Config.HWIDs.HW_InspectionControl),_data_1);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1232, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1232;
                RETURN;
            END_IF;  

            _data_2[0]                    :=      CommandControl.Command.%B1;
            _data_2[1]                    :=      CommandControl.Command.%B0;
            
            _retVal := Siemens.Simatic.S71500.DistributedIO.WriteData(TO_WORD(Config.HWIDs.HW_CommandControl),_data_2);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1233, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1233;
                RETURN;
            END_IF;  

            _data_1[0].%X0                  :=      SoftEventControl.TriggerSoftEvent.Data[0];
            _data_1[0].%X1                  :=      SoftEventControl.TriggerSoftEvent.Data[1];
            _data_1[0].%X2                  :=      SoftEventControl.TriggerSoftEvent.Data[2];
            _data_1[0].%X3                  :=      SoftEventControl.TriggerSoftEvent.Data[3];
            _data_1[0].%X4                  :=      SoftEventControl.TriggerSoftEvent.Data[4];
            _data_1[0].%X5                  :=      SoftEventControl.TriggerSoftEvent.Data[5];
            _data_1[0].%X6                  :=      SoftEventControl.TriggerSoftEvent.Data[6];
            _data_1[0].%X7                  :=      SoftEventControl.TriggerSoftEvent.Data[7];

            _retVal := Siemens.Simatic.S71500.DistributedIO.WriteData(TO_WORD(Config.HWIDs.HW_SoftEventControl),_data_1);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1234, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1234;
                RETURN;
            END_IF;  

            IF Config.HWIDs.HW_UserDataSlot_7 <> UINT#0 THEN
                _invalidDataSize := NOT (   _UserDataSize_Slot_7 = UINT#16  OR
                                            _UserDataSize_Slot_7 = UINT#32  OR
                                            _UserDataSize_Slot_7 = UINT#64  OR
                                            _UserDataSize_Slot_7 = UINT#128 OR
                                            _UserDataSize_Slot_7 = UINT#254 );
                IF _invalidDataSize THEN
                    Messenger.Activate(UINT#1235, eAxoMessageCategory#ProgrammingError);
                    Status.Error.Id := UINT#1235;
                    RETURN;
                END_IF;  
                IF (UserData.DataChanged <> _UserDataChanged) THEN
                    IF _UserDataSize_Slot_7 = UINT#16 THEN
                        FOR _index := 0 TO UINT#15 DO
                            _data_16[_index] := UserData.Data[_index];
                        END_FOR;
                        _retVal := Siemens.Simatic.S71500.DistributedIO.WriteData(TO_WORD(Config.HWIDs.HW_UserDataSlot_7) ,_data_16);
                        IF _retVal > WORD#0 THEN
                            Messenger.Activate(UINT#1236, eAxoMessageCategory#ProgrammingError);
                            Status.Error.Id := UINT#1236;
                            RETURN;
                        END_IF;  
                    ELSIF _UserDataSize_Slot_7 = UINT#32 THEN
                        FOR _index := 0 TO UINT#31 DO
                            _data_32[_index] := UserData.Data[_index];
                        END_FOR;
                        _retVal := Siemens.Simatic.S71500.DistributedIO.WriteData(TO_WORD(Config.HWIDs.HW_UserDataSlot_7) ,_data_32);
                        IF _retVal > WORD#0 THEN
                            Messenger.Activate(UINT#1237, eAxoMessageCategory#ProgrammingError);
                            Status.Error.Id := UINT#1237;
                            RETURN;
                        END_IF;  
                    ELSIF _UserDataSize_Slot_7 = UINT#64 THEN
                        FOR _index := 0 TO UINT#63 DO
                            _data_64[_index] := UserData.Data[_index];
                        END_FOR;
                        _retVal := Siemens.Simatic.S71500.DistributedIO.WriteData(TO_WORD(Config.HWIDs.HW_UserDataSlot_7) ,_data_64);
                        IF _retVal > WORD#0 THEN
                            Messenger.Activate(UINT#1238, eAxoMessageCategory#ProgrammingError);
                            Status.Error.Id := UINT#1238;
                            RETURN;
                        END_IF;  
                    ELSIF _UserDataSize_Slot_7 = UINT#128 THEN
                        FOR _index := 0 TO UINT#127 DO
                            _data_128[_index] := UserData.Data[_index];
                        END_FOR;
                        _retVal := Siemens.Simatic.S71500.DistributedIO.WriteData(TO_WORD(Config.HWIDs.HW_UserDataSlot_7) ,_data_128);
                        IF _retVal > WORD#0 THEN
                            Messenger.Activate(UINT#1239, eAxoMessageCategory#ProgrammingError);
                            Status.Error.Id := UINT#1239;
                            RETURN;
                        END_IF;  
                    ELSIF _UserDataSize_Slot_7 = UINT#254 THEN
                        FOR _index := 0 TO UINT#253 DO
                            _data_254[_index] := UserData.Data[_index];
                        END_FOR;
                        _retVal := Siemens.Simatic.S71500.DistributedIO.WriteData(TO_WORD(Config.HWIDs.HW_UserDataSlot_7) ,_data_254);
                        IF _retVal > WORD#0 THEN
                            Messenger.Activate(UINT#1240, eAxoMessageCategory#ProgrammingError);
                            Status.Error.Id := UINT#1240;
                            RETURN;
                        END_IF;  
                    END_IF;
                END_IF;
            END_IF;

            IF Config.HWIDs.HW_UserDataSlot_8 <> UINT#0 THEN
                _invalidDataSize := NOT (   _UserDataSize_Slot_8 = UINT#16  OR
                                            _UserDataSize_Slot_8 = UINT#32  OR
                                            _UserDataSize_Slot_8 = UINT#64  OR
                                            _UserDataSize_Slot_8 = UINT#128 OR
                                            _UserDataSize_Slot_8 = UINT#254 );
                IF _invalidDataSize THEN
                    Messenger.Activate(UINT#1241, eAxoMessageCategory#ProgrammingError);
                    Status.Error.Id := UINT#1241;
                    RETURN;
                END_IF;  
                IF (UserData.DataChanged <> _UserDataChanged) THEN
                    _offset := _UserDataSize_Slot_7;
                    IF _UserDataSize_Slot_8 = UINT#16 THEN
                        FOR _index := 0 TO UINT#15 DO
                            _data_16[_index] := UserData.Data[_index+_offset];
                        END_FOR;
                        _retVal := Siemens.Simatic.S71500.DistributedIO.WriteData(TO_WORD(Config.HWIDs.HW_UserDataSlot_8) ,_data_16);
                        IF _retVal > WORD#0 THEN
                            Messenger.Activate(UINT#1242, eAxoMessageCategory#ProgrammingError);
                            Status.Error.Id := UINT#1242;
                            RETURN;
                        END_IF;  
                    ELSIF _UserDataSize_Slot_8 = UINT#32 THEN
                        FOR _index := 0 TO UINT#31 DO
                            _data_32[_index] := UserData.Data[_index+_offset];
                        END_FOR;
                        _retVal := Siemens.Simatic.S71500.DistributedIO.WriteData(TO_WORD(Config.HWIDs.HW_UserDataSlot_8) ,_data_32);
                        IF _retVal > WORD#0 THEN
                            Messenger.Activate(UINT#1243, eAxoMessageCategory#ProgrammingError);
                            Status.Error.Id := UINT#1243;
                            RETURN;
                        END_IF;  
                    ELSIF _UserDataSize_Slot_8 = UINT#64 THEN
                        FOR _index := 0 TO UINT#63 DO
                            _data_64[_index] := UserData.Data[_index+_offset];
                        END_FOR;
                        _retVal := Siemens.Simatic.S71500.DistributedIO.WriteData(TO_WORD(Config.HWIDs.HW_UserDataSlot_8) ,_data_64);
                        IF _retVal > WORD#0 THEN
                            Messenger.Activate(UINT#1244, eAxoMessageCategory#ProgrammingError);
                            Status.Error.Id := UINT#1244;
                            RETURN;
                        END_IF;  
                    ELSIF _UserDataSize_Slot_8 = UINT#128 THEN
                        FOR _index := 0 TO UINT#127 DO
                            _data_128[_index] := UserData.Data[_index+_offset];
                        END_FOR;
                        _retVal := Siemens.Simatic.S71500.DistributedIO.WriteData(TO_WORD(Config.HWIDs.HW_UserDataSlot_8) ,_data_128);
                        IF _retVal > WORD#0 THEN
                            Messenger.Activate(UINT#1245, eAxoMessageCategory#ProgrammingError);
                            Status.Error.Id := UINT#1245;
                            RETURN;
                        END_IF;  
                    ELSIF _UserDataSize_Slot_8 = UINT#254 THEN
                        FOR _index := 0 TO UINT#253 DO
                            _data_254[_index] := UserData.Data[_index+_offset];
                        END_FOR;
                        _retVal := Siemens.Simatic.S71500.DistributedIO.WriteData(TO_WORD(Config.HWIDs.HW_UserDataSlot_8) ,_data_254);
                        IF _retVal > WORD#0 THEN
                            Messenger.Activate(UINT#1246, eAxoMessageCategory#ProgrammingError);
                            Status.Error.Id := UINT#1246;
                            RETURN;
                        END_IF;  
                    END_IF;
                END_IF;
            END_IF;

            IF Config.HWIDs.HW_UserDataSlot_9 <> UINT#0 THEN
                _invalidDataSize := NOT (   _UserDataSize_Slot_9 = UINT#16  OR
                                            _UserDataSize_Slot_9 = UINT#32  OR
                                            _UserDataSize_Slot_9 = UINT#64  OR
                                            _UserDataSize_Slot_9 = UINT#128 OR
                                            _UserDataSize_Slot_9 = UINT#254 );
                IF _invalidDataSize THEN
                    Messenger.Activate(UINT#1247, eAxoMessageCategory#ProgrammingError);
                    Status.Error.Id := UINT#1247;
                    RETURN;
                END_IF;  
                IF (UserData.DataChanged <> _UserDataChanged) THEN
                    _offset := _UserDataSize_Slot_7 + _UserDataSize_Slot_8;
                    IF _UserDataSize_Slot_9 = UINT#16 THEN
                        FOR _index := 0 TO UINT#15 DO
                            _data_16[_index] := UserData.Data[_index+_offset];
                        END_FOR;
                        _retVal := Siemens.Simatic.S71500.DistributedIO.WriteData(TO_WORD(Config.HWIDs.HW_UserDataSlot_9) ,_data_16);
                        IF _retVal > WORD#0 THEN
                            Messenger.Activate(UINT#1248, eAxoMessageCategory#ProgrammingError);
                            Status.Error.Id := UINT#1248;
                            RETURN;
                        END_IF;  
                    ELSIF _UserDataSize_Slot_9 = UINT#32 THEN
                        FOR _index := 0 TO UINT#31 DO
                            _data_32[_index] := UserData.Data[_index+_offset];
                        END_FOR;
                        _retVal := Siemens.Simatic.S71500.DistributedIO.WriteData(TO_WORD(Config.HWIDs.HW_UserDataSlot_9) ,_data_32);
                        IF _retVal > WORD#0 THEN
                            Messenger.Activate(UINT#1249, eAxoMessageCategory#ProgrammingError);
                            Status.Error.Id := UINT#1249;
                            RETURN;
                        END_IF;  
                    ELSIF _UserDataSize_Slot_9 = UINT#64 THEN
                        FOR _index := 0 TO UINT#63 DO
                            _data_64[_index] := UserData.Data[_index+_offset];
                        END_FOR;
                        _retVal := Siemens.Simatic.S71500.DistributedIO.WriteData(TO_WORD(Config.HWIDs.HW_UserDataSlot_9) ,_data_64);
                        IF _retVal > WORD#0 THEN
                            Messenger.Activate(UINT#1250, eAxoMessageCategory#ProgrammingError);
                            Status.Error.Id := UINT#1250;
                            RETURN;
                        END_IF;  
                    ELSIF _UserDataSize_Slot_9 = UINT#128 THEN
                        FOR _index := 0 TO UINT#127 DO
                            _data_128[_index] := UserData.Data[_index+_offset];
                        END_FOR;
                        _retVal := Siemens.Simatic.S71500.DistributedIO.WriteData(TO_WORD(Config.HWIDs.HW_UserDataSlot_9) ,_data_128);
                        IF _retVal > WORD#0 THEN
                            Messenger.Activate(UINT#1251, eAxoMessageCategory#ProgrammingError);
                            Status.Error.Id := UINT#1251;
                            RETURN;
                        END_IF;  
                    ELSIF _UserDataSize_Slot_9 = UINT#254 THEN
                        FOR _index := 0 TO UINT#253 DO
                            _data_254[_index] := UserData.Data[_index+_offset];
                        END_FOR;
                        _retVal := Siemens.Simatic.S71500.DistributedIO.WriteData(TO_WORD(Config.HWIDs.HW_UserDataSlot_9) ,_data_254);
                        IF _retVal > WORD#0 THEN
                            Messenger.Activate(UINT#1252, eAxoMessageCategory#ProgrammingError);
                            Status.Error.Id := UINT#1252;
                            RETURN;
                        END_IF;  
                    END_IF;
                END_IF;
            END_IF;

            IF Config.HWIDs.HW_UserDataSlot_10 <> UINT#0 THEN
                _invalidDataSize := NOT (   _UserDataSize_Slot_10 = UINT#16  OR
                                            _UserDataSize_Slot_10 = UINT#32  OR
                                            _UserDataSize_Slot_10 = UINT#64  OR
                                            _UserDataSize_Slot_10 = UINT#128 OR
                                            _UserDataSize_Slot_10 = UINT#254 );
                IF _invalidDataSize THEN
                    Messenger.Activate(UINT#1253, eAxoMessageCategory#ProgrammingError);
                    Status.Error.Id := UINT#1253;
                    RETURN;
                END_IF;  
                IF (UserData.DataChanged <> _UserDataChanged) THEN
                    _offset := _UserDataSize_Slot_7 + _UserDataSize_Slot_8 + _UserDataSize_Slot_9;
                    IF _UserDataSize_Slot_10 = UINT#16 THEN
                        FOR _index := 0 TO UINT#15 DO
                            _data_16[_index] := UserData.Data[_index+_offset];
                        END_FOR;
                        _retVal := Siemens.Simatic.S71500.DistributedIO.WriteData(TO_WORD(Config.HWIDs.HW_UserDataSlot_10) ,_data_16);
                        IF _retVal > WORD#0 THEN
                            Messenger.Activate(UINT#1254, eAxoMessageCategory#ProgrammingError);
                            Status.Error.Id := UINT#1254;
                            RETURN;
                        END_IF;  
                    ELSIF _UserDataSize_Slot_10 = UINT#32 THEN
                        FOR _index := 0 TO UINT#31 DO
                            _data_32[_index] := UserData.Data[_index+_offset];
                        END_FOR;
                        _retVal := Siemens.Simatic.S71500.DistributedIO.WriteData(TO_WORD(Config.HWIDs.HW_UserDataSlot_10) ,_data_32);
                        IF _retVal > WORD#0 THEN
                            Messenger.Activate(UINT#1255, eAxoMessageCategory#ProgrammingError);
                            Status.Error.Id := UINT#1255;
                            RETURN;
                        END_IF;  
                    ELSIF _UserDataSize_Slot_10 = UINT#64 THEN
                        FOR _index := 0 TO UINT#63 DO
                            _data_64[_index] := UserData.Data[_index+_offset];
                        END_FOR;
                        _retVal := Siemens.Simatic.S71500.DistributedIO.WriteData(TO_WORD(Config.HWIDs.HW_UserDataSlot_10) ,_data_64);
                        IF _retVal > WORD#0 THEN
                            Messenger.Activate(UINT#1256, eAxoMessageCategory#ProgrammingError);
                            Status.Error.Id := UINT#1256;
                            RETURN;
                        END_IF;  
                    ELSIF _UserDataSize_Slot_10 = UINT#128 THEN
                        FOR _index := 0 TO UINT#127 DO
                            _data_128[_index] := UserData.Data[_index+_offset];
                        END_FOR;
                        _retVal := Siemens.Simatic.S71500.DistributedIO.WriteData(TO_WORD(Config.HWIDs.HW_UserDataSlot_10) ,_data_128);
                        IF _retVal > WORD#0 THEN
                            Messenger.Activate(UINT#1257, eAxoMessageCategory#ProgrammingError);
                            Status.Error.Id := UINT#1257;
                            RETURN;
                        END_IF;  
                    ELSIF _UserDataSize_Slot_10 = UINT#254 THEN
                        FOR _index := 0 TO UINT#253 DO
                            _data_254[_index] := UserData.Data[_index+_offset];
                        END_FOR;
                        _retVal := Siemens.Simatic.S71500.DistributedIO.WriteData(TO_WORD(Config.HWIDs.HW_UserDataSlot_10) ,_data_254);
                        IF _retVal > WORD#0 THEN
                            Messenger.Activate(UINT#1258, eAxoMessageCategory#ProgrammingError);
                            Status.Error.Id := UINT#1258;
                            RETURN;
                        END_IF;  
                    END_IF;
                END_IF;
            END_IF;

            _UserDataChanged := UserData.DataChanged;  //TODO check the functionality in case of multiple user data slots
            Config.UserDataSize := _UserDataSize;
        END_METHOD

        METHOD PRIVATE CallTimers
            VAR_INPUT
                signal : BOOL;
            END_VAR
            
            _infoTimer.OnDelay(THIS, signal AND Config.InfoTime > LT#0S ,Config.InfoTime);
            _errorTimer.OnDelay(THIS, signal AND Config.ErrorTime > LT#0S , Config.ErrorTime);
        END_METHOD

        METHOD PRIVATE SetUserData: BOOL
            VAR_IN_OUT
                Data      :   AxoInsight_UserData;
            END_VAR
            VAR_INPUT
                Length    :   UINT;	
            END_VAR
            VAR
                _index : UINT;
            END_VAR
            
            SetUserData := FALSE;

            
            IF (Length) > Config.UserDataSize THEN
                Messenger.Activate(UINT#1402, eAxoMessageCategory#Error);
                Status.Error.Id := UINT#1402;
                RETURN;
            END_IF;

            IF (Length) > _maxUserDataIndex THEN
                Messenger.Activate(UINT#1403, eAxoMessageCategory#Error);
                Status.Error.Id := UINT#1403;
                RETURN;
            END_IF;

            FOR	_index := UINT#0 TO Length BY UINT#1 DO	
                UserData.Data[( _index)] := Data.Data[_index];
            END_FOR;
            
            FOR	_index := Length TO _maxUserDataIndex BY UINT#1 DO	
                UserData.Data[_index] := BYTE#0;
            END_FOR;
            UserData.ToggleDataChangedFlag();

            SetUserData := TRUE;
        END_METHOD

        ///<summary>
		/// Clears the inspection results. 	
        ///</summary>       
        METHOD PUBLIC ClearInspectionResults : IAxoTaskState
            ClearInspectionResults := ClearInspectionResultsTask.Invoke(THIS);;
        END_METHOD

        ///<summary>
		/// Triggers the reading sequence and waits for results. 	
        ///</summary>       
        METHOD PUBLIC Trigger : IAxoTaskState
            Trigger := TriggerTask.Invoke(THIS);
        END_METHOD

        ///<summary>
		/// Changes the sensor job using job number. 	
        ///</summary>       
        METHOD PUBLIC ChangeJob : IAxoTaskState
            VAR_INPUT 
                Job : UINT;
            END_VAR
            _jobNumber := Job;
            ChangeJob := ChangeJobByNumberTask.Invoke(THIS);
        END_METHOD

        ///<summary>
		/// Changes the sensor job using job name. 	
        ///</summary>       
        METHOD PUBLIC ChangeJob : IAxoTaskState
            VAR_INPUT 
                Job : STRING;
            END_VAR
            _jobName := Job;
            ChangeJob := ChangeJobByNameTask.Invoke(THIS);
        END_METHOD
        
        ///<summary>
		/// Triggers the soft event. 
        ///</summary>       
        METHOD PUBLIC SoftEvent : IAxoTaskState
            VAR_INPUT 
                EventNumber : UINT;
            END_VAR
            _softEventNumber := EventNumber;
            SoftEvent := SoftEventTask.Invoke(THIS);
        END_METHOD

        ///<summary>
		/// Sends the user data from PLC to device. 
        ///</summary>   
        METHOD PUBLIC SendUserData : IAxoTaskState
            VAR_IN_OUT
                Data      :   AxoInsight_UserData;
            END_VAR
            VAR_INPUT
                Length    :   UINT;	
            END_VAR

            _userDataLength :=  Length;
            _userData       :=  Data;
            SendUserData := SendUserDataTask.Invoke(THIS);
        END_METHOD

        ///<summary>
		/// Sends the already prepared user data from PLC to device. 
        ///</summary>   
        METHOD PUBLIC SendUserData : IAxoTaskState
            _userDataLength :=  Config.UserDataSize;
            SendUserData := SendUserDataTask.Invoke(THIS);
        END_METHOD

        ///<summary>
		/// Writes a single byte into a specified position within an internal user data buffer. 
        ///</summary>   
        METHOD PUBLIC SetUserDataAsByte : BOOL
            VAR_INPUT
                inValue     : BYTE;
                inPosition  : UINT;	
            END_VAR

            SetUserDataAsByte := FALSE;

            IF (inPosition + UINT#1) > Config.UserDataSize THEN
                Messenger.Activate(UINT#1404, eAxoMessageCategory#Error);
                Status.Error.Id := UINT#1404;
                RETURN;
            END_IF;

            IF (inPosition + UINT#1) > _maxUserDataIndex THEN
                Messenger.Activate(UINT#1405, eAxoMessageCategory#Error);
                Status.Error.Id := UINT#1405;
                RETURN;
            END_IF;

            _userData.Data[inPosition] := inValue;
            
            SetUserDataAsByte := TRUE;            
        END_METHOD

        ///<summary>
        /// Writes a 32-bit signed integer into the internal user data buffer starting at the specified byte position.
        ///</summary>   
        METHOD PUBLIC SetUserDataAsDint : BOOL
            VAR_INPUT
                inValue     : DINT;
                inPosition  : UINT;	
            END_VAR

            SetUserDataAsDint := FALSE;

            IF (inPosition + UINT#4) > Config.UserDataSize THEN
                Messenger.Activate(UINT#1406, eAxoMessageCategory#Error);
                Status.Error.Id := UINT#1406;
                RETURN;
            END_IF;

            IF (inPosition + UINT#4) > _maxUserDataIndex THEN
                Messenger.Activate(UINT#1407, eAxoMessageCategory#Error);
                Status.Error.Id := UINT#1407;
                RETURN;
            END_IF;

            _userData.Data[inPosition           ] := inValue.%B0;
            _userData.Data[inPosition + UINT#1  ] := inValue.%B1;
            _userData.Data[inPosition + UINT#2  ] := inValue.%B2;
            _userData.Data[inPosition + UINT#3  ] := inValue.%B3;
            
            SetUserDataAsDint := TRUE;            
        END_METHOD

        ///<summary>
        /// Writes a 32-bit IEEE 754 floating-point number (REAL) into the internal user data buffer 
        /// starting at the specified byte position.
        ///</summary>   
        METHOD PUBLIC SetUserDataAsReal : BOOL
            VAR_INPUT
                inValue     : REAL;
                inPosition  : UINT;	
            END_VAR
            VAR
                _dword : DWORD;
            END_VAR

            SetUserDataAsReal := FALSE;

            IF (inPosition + UINT#4) > Config.UserDataSize THEN
                Messenger.Activate(UINT#1408, eAxoMessageCategory#Error);
                Status.Error.Id := UINT#1408;
                RETURN;
            END_IF;

            IF (inPosition + UINT#4) > _maxUserDataIndex THEN
                Messenger.Activate(UINT#1409, eAxoMessageCategory#Error);
                Status.Error.Id := UINT#1409;
                RETURN;
            END_IF;

            _dword := TO_DWORD(inValue);
            _userData.Data[inPosition           ] := _dword.%B0;
            _userData.Data[inPosition + UINT#1  ] := _dword.%B1;
            _userData.Data[inPosition + UINT#2  ] := _dword.%B2;
            _userData.Data[inPosition + UINT#3  ] := _dword.%B3;
            
            SetUserDataAsReal := TRUE;            
        END_METHOD

        ///<summary>
        /// Writes a STRING value into the internal user data buffer starting at the specified byte position. 
        ///</summary>   
        METHOD PUBLIC SetUserDataAsString : BOOL
            VAR_INPUT
                inValue     : STRING;
                inPosition  : UINT;	
            END_VAR
            VAR
                _size   :   UINT;
                _index  :   UINT;
            END_VAR

            SetUserDataAsString := FALSE;

            _size := TO_UINT(LengthOf(inValue));
            IF (inPosition + _size) > Config.UserDataSize THEN
                Messenger.Activate(UINT#1410, eAxoMessageCategory#Error);
                Status.Error.Id := UINT#1410;
                RETURN;
            END_IF;

            IF (inPosition + _size) > _maxUserDataIndex THEN
                Messenger.Activate(UINT#1411, eAxoMessageCategory#Error);
                Status.Error.Id := UINT#1411;
                RETURN;
            END_IF;

            Serialize(UINT#0, inValue, _data_255);
            FOR _index := UINT#0 TO (TO_UINT(LengthOf(inValue)) - UINT#1) BY UINT#1 DO
                _userData.Data[inPosition + _index] := _data_255[_index + UINT#1];
            END_FOR;
            
            SetUserDataAsString := TRUE;            
        END_METHOD

        ///<summary>
        /// Clears all user data in the internal buffer and sends it to the device.
        ///</summary>
        METHOD PUBLIC ClearUserData : IAxoTaskState
            VAR
                _index : UINT;
            END_VAR
            FOR _index := UINT#0 TO _maxUserDataIndex BY UINT#1 DO
                _userData.Data[_index] := BYTE#0;
            END_FOR;
            UserDataToSent := _userData;
            UserDataLength := UINT#0; 
            _userDataLength :=  Config.UserDataSize;
            ClearUserData := SendUserDataTask.Invoke(THIS);
        END_METHOD

        ///<summary>
		/// Custom logic for the manual control.
        ///</summary>   
        METHOD PROTECTED OVERRIDE ManualControl
            _jobName := RequiredJobName;
            _jobNumber := RequiredJobNumber;
            _softEventNumber := RequiredSoftEventNumber;
            _userDataLength :=  UserDataLength; 
            _userData       :=  UserDataToSent;
        END_METHOD

        ///<summary>
		/// Restores this instance . 
        ///</summary>   
        METHOD PUBLIC OVERRIDE Restore
            VAR
                _index : UINT;
            END_VAR
            _progress := 0;
            Status.Action.Id := UINT#0;
            Status.Error.Id  := UINT#0;
            Status.CurrentJobName := '';
            Messenger.Restore();
            TaskMessenger.Restore();


            ClearInspectionResultsTask.Restore();
            TriggerTask.Restore();
            ChangeJobByNameTask.Restore();
            ChangeJobByNumberTask.Restore();
            SoftEventTask.Restore();
            SendUserDataTask.Restore();
            HardwareDiagnosticsTask.Restore();

            FOR _index := 0 TO _maxUserDataIndex DO
                UserDataToSent.Data[_index] := BYTE#0;
            END_FOR;
            UserDataLength := UINT#0;            

            RequiredJobName := '';
            RequiredJobNumber := UINT#0;
             
            Results.InspectionID                            :=  UINT#0;
            Results.ResultCode                              :=  UINT#0;
            
            FOR _index := 0 TO _maxResultDataIndex DO
                InspectionResults.Data[_index] := BYTE#0;
            END_FOR;
            InspectionResults.ToggleDataChangedFlag();
  
            AcquisitionControl.TriggerEnable                :=  FALSE;
            AcquisitionControl.Trigger					    :=  FALSE;
            AcquisitionControl.ClearExposureComplete        :=  AcquisitionStatus.ExposureComplete;
            AcquisitionControl.SetOffline                   :=  FALSE;


            InspectionControl.EnableResultsBuffering        :=  FALSE;
            InspectionControl.AcknowledgeInspectionResults  :=  FALSE;
            InspectionControl.ExtendedUserDataSet           :=  FALSE;
            InspectionControl.ExecuteCommand                :=  FALSE;
            InspectionControl.ClearError                    :=  InspectionStatus.Error;

            CommandControl.Command                          :=  UINT#0;

            SoftEventControl.TriggerSoftEvent.Data[0]       :=  FALSE;
            SoftEventControl.TriggerSoftEvent.Data[1]       :=  FALSE;
            SoftEventControl.TriggerSoftEvent.Data[2]       :=  FALSE;
            SoftEventControl.TriggerSoftEvent.Data[3]       :=  FALSE;
            SoftEventControl.TriggerSoftEvent.Data[4]       :=  FALSE;
            SoftEventControl.TriggerSoftEvent.Data[5]       :=  FALSE;
            SoftEventControl.TriggerSoftEvent.Data[6]       :=  FALSE;
            SoftEventControl.TriggerSoftEvent.Data[7]       :=  FALSE;

            FOR _index := 0 TO _maxUserDataIndex DO
                UserData.Data[_index] := BYTE#0;
            END_FOR;
            UserData.ToggleDataChangedFlag();

            IF NOT AcquisitionStatus.ExposureComplete AND NOT InspectionStatus.Error THEN
                Status.Action.Id := UINT#50;
                RestoreTask.DoneWhen(TRUE);
            END_IF;
        END_METHOD
    END_CLASS    
END_NAMESPACE
