USING AXOpen.Messaging.Static;
USING AXOpen.Messaging;
USING AXOpen.Core;
USING AXOpen.Components.Abstractions;
USING Siemens.Simatic.S71500.Hardware.Utilities;

NAMESPACE AXOpen.Components.Cognex.Vision.v_6_0_0_0

    {S7.extern=ReadWrite}
    CLASS PUBLIC AxoDataman EXTENDS AXOpen.Core.AxoComponent IMPLEMENTS AXOpen.Components.Abstractions.IAxoCodeReader 
        VAR PRIVATE
            _UserDataSize           :   eAxoDataman_UserDataSize;
            _ResultDataSize         :   eAxoDataman_ResultDataSize;
            _hwID                   :   WORD;
            _hwIdAcquisitionControl :   WORD;
            _hwIdAcquisitionStatus  :   WORD;
            _hwIdResultsControl     :   WORD;
            _hwIdResultsStatus      :   WORD;
            _hwIdSoftEventControl   :   WORD;
            _hwIdUserData           :   WORD;
            _hwIdResultData         :   WORD;

            _progress               :   INT := 0;
            _infoTimer              :   AXOpen.Timers.OnDelayTimer;
            _errorTimer             :   AXOpen.Timers.OnDelayTimer;
            _inspectionCompleted    :   BOOL;
            _data_in                :   ARRAY[0..254] OF BYTE;
            _jobNumber              :   UINT;
            _softEventNumber        :   UINT;
            _UserDataChanged        :   BOOL;

            _invalidDataSize        :   BOOL;
            _data_1                 :   ARRAY[0..0] OF BYTE;
            _data_16                :   ARRAY[0..15] OF BYTE;
            _data_32                :   ARRAY[0..31] OF BYTE;
            _data_64                :   ARRAY[0..63] OF BYTE;
            _data_128               :   ARRAY[0..127] OF BYTE;
            _data_250               :   ARRAY[0..249] OF BYTE;           

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
        END_VAR            
        
        VAR PUBLIC //Header
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentHeader()]}
            {#ix-set:AttributeName = "<#Read#>"}
            ReadTask : AXOpen.Core.AxoTask;
            {#ix-attr:[ComponentHeader()]}         
            {#ix-attr:[ReadOnly()]}
            {#ix-set:AttributeName = "<#Inspection results#>"}
            {#ix-set:DisplayFormat = "string"}
            ResultData  :   AxoDataman_ResultData;
        END_VAR

        VAR PUBLIC //Tasks
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#Restore#>"}
            RestoreTask : AXOpen.Core.AxoTask;
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#Clear result data#>"}
            ClearResultDataTask : AXOpen.Core.AxoTask;
        END_VAR

        VAR PUBLIC //Config
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Config")]}
            Config      :   AxoDataman_Config;

        END_VAR

        VAR PUBLIC //Status
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("Status")]}
            {#ix-attr:[ReadOnly()]}
            Status      :   AxoDataman_Status;

            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-attr:[ComponentDetails("Status")]}
            {#ix-attr:[ReadOnly()]}
            {#ix-set:AttributeName = "<#Results#>"}
            Results     :   AxoDataman_Results;

            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-attr:[ComponentDetails("Status")]}
            {#ix-set:AttributeName = "<#Acquisition control#>"}
            {#ix-attr:[ReadOnly()]}
            AcquisitionControl     :   AxoDataman_AcquisitionControl;

            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-attr:[ComponentDetails("Status")]}
            {#ix-set:AttributeName = "<#Acquisition status#>"}
            {#ix-attr:[ReadOnly()]}
            AcquisitionStatus      :   AxoDataman_AcquisitionStatus;

            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-attr:[ComponentDetails("Status")]}
            {#ix-set:AttributeName = "<#Results control#>"}
            {#ix-attr:[ReadOnly()]}
            ResultsControl         :   AxoDataman_ResultsControl;

            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-attr:[ComponentDetails("Status")]}
            {#ix-set:AttributeName = "<#Results status#>"}
            {#ix-attr:[ReadOnly()]}
            ResultsStatus          :   AxoDataman_ResultsStatus;

            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-attr:[ComponentDetails("Status")]}
            {#ix-set:AttributeName = "<#Soft-event control#>"}
            {#ix-attr:[ReadOnly()]}
            SoftEventControl       :   AxoDataman_SoftEventControl;
 
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-attr:[ComponentDetails("Status")]}
            {#ix-set:AttributeName = "<#Soft-event status#>"}
            {#ix-attr:[ReadOnly()]}
            SoftEventStatus        :   AxoDataman_SoftEventStatus;
 
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-attr:[ComponentDetails("Status")]}
            {#ix-set:AttributeName = "<#User data#>"}
            {#ix-attr:[ReadOnly()]}
            User        :   AxoDataman_User;
            {#ix-set:AttributeName = "<#User data#>"}
            {#ix-attr:[ReadOnly()]}
            {#ix-set:DisplayFormat = "hexadecimal"}
            UserData        :   AxoDataman_UserData;
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
                _index                  :   INT;
            END_VAR

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
    
                _hwID                    := hwID;                                                      
                _retval := ReadSlotFromHardwareID(hardwareID := TO_UINT(_hwID), geoAddr :=_geoAddr);   
                IF _retval = WORD#8090 THEN
                    Messenger.Activate(UINT#702,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#702;
                    RETURN;
                END_IF;
                //******************Slot 1*****************//
                _geoAddr.Slot   :=  UINT#1;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => _outHwid);        
                _hwIdAcquisitionControl :=  TO_WORD(_outHwid);                                         
                IF _hwIdAcquisitionControl = WORD#0 THEN
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
                ReadHardwareIOAddress(hardwareIdentifier :=  _hwIdAcquisitionControl , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#0 OR _outputsCount <> UINT#1 THEN
                    Messenger.Activate(UINT#716,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#716;
                    RETURN;
                END_IF;
                //******************Slot 2*****************//
                _geoAddr.Slot   :=  UINT#2;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => _outHwid);        
                _hwIdAcquisitionStatus :=  TO_WORD(_outHwid);                                         
                IF _hwIdAcquisitionStatus = WORD#0 THEN
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
                ReadHardwareIOAddress(hardwareIdentifier :=  _hwIdAcquisitionStatus , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#3 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#726,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#726;
                    RETURN;
                END_IF;
                //******************Slot 3*****************//
                _geoAddr.Slot   :=  UINT#3;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => _outHwid);        
                _hwIdResultsControl :=  TO_WORD(_outHwid);                                         
                IF _hwIdResultsControl = WORD#0 THEN
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
                ReadHardwareIOAddress(hardwareIdentifier :=  _hwIdResultsControl , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#0 OR _outputsCount <> UINT#1 THEN
                    Messenger.Activate(UINT#736,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#736;
                    RETURN;
                END_IF;
                //******************Slot 4*****************//
                _geoAddr.Slot   :=  UINT#4;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => _outHwid);        
                _hwIdResultsStatus :=  TO_WORD(_outHwid);                                         
                IF _hwIdResultsStatus = WORD#0 THEN
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
                ReadHardwareIOAddress(hardwareIdentifier :=  _hwIdResultsStatus , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#1 OR _outputsCount <> UINT#0 THEN
                    Messenger.Activate(UINT#746,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#746;
                    RETURN;
                END_IF;
                //******************Slot 5*****************//
                _geoAddr.Slot   :=  UINT#5;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => _outHwid);        
                _hwIdSoftEventControl :=  TO_WORD(_outHwid);                                         
                IF _hwIdSoftEventControl = WORD#0 THEN
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
                ReadHardwareIOAddress(hardwareIdentifier :=  _hwIdSoftEventControl , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#1 OR _outputsCount <> UINT#1 THEN
                    Messenger.Activate(UINT#756,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#756;
                    RETURN;
                END_IF;
                //******************Slot 6*****************//
                _geoAddr.Slot   :=  UINT#6;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => _outHwid);        
                _hwIdUserData :=  TO_WORD(_outHwid);                                         
                IF _hwIdUserData = WORD#0 THEN
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
                ReadHardwareIOAddress(hardwareIdentifier :=  _hwIdUserData , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount = UINT#0 AND _outputsCount = UINT#20 THEN           //16 + 4 ( Option(UINT) + Length(UINT))
                    _UserDataSize := eAxoDataman_UserDataSize#USER_DATA_16B;
                ELSIF _inputsCount = UINT#0 AND _outputsCount = UINT#36 THEN        //32 + 4 ( Option(UINT) + Length(UINT))
                    _UserDataSize := eAxoDataman_UserDataSize#USER_DATA_32B;
                ELSIF _inputsCount = UINT#0 AND _outputsCount = UINT#68 THEN        //6432 + 4 ( Option(UINT) + Length(UINT))
                    _UserDataSize := eAxoDataman_UserDataSize#USER_DATA_64B;
                ELSIF _inputsCount = UINT#0 AND _outputsCount = UINT#132 THEN       //128 + 4 ( Option(UINT) + Length(UINT))       
                    _UserDataSize := eAxoDataman_UserDataSize#USER_DATA_128B;
                ELSIF _inputsCount = UINT#0 AND _outputsCount = UINT#254 THEN       //25 + 4 ( Option(UINT) + Length(UINT))
                    _UserDataSize := eAxoDataman_UserDataSize#USER_DATA_250B;
                ELSE
                    _UserDataSize := eAxoDataman_UserDataSize#USER_DATA_SIZE_INVALID;
                    Messenger.Activate(UINT#766,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#766;    
                    RETURN;
                END_IF;
                //******************Slot 7*****************//
                _geoAddr.Slot   :=  UINT#7;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => _outHwid);        
                _hwIdResultData :=  TO_WORD(_outHwid);                                         
                IF _hwIdResultData = WORD#0 THEN
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
                ReadHardwareIOAddress(hardwareIdentifier :=  _hwIdResultData , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _outputsCount = UINT#0 AND _inputsCount = UINT#24 THEN               //16 + 8 ( Id(UINT) + Code(UINT) + Extended(UINT) + Length(UINT))
                    _ResultDataSize := eAxoDataman_ResultDataSize#RESULT_DATA_16B;
                ELSIF _outputsCount = UINT#0 AND _inputsCount = UINT#40 THEN            //32 + 8 ( Id(UINT) + Code(UINT) + Extended(UINT) + Length(UINT))
                    _ResultDataSize := eAxoDataman_ResultDataSize#RESULT_DATA_32B;
                ELSIF _outputsCount = UINT#0 AND _inputsCount = UINT#72 THEN            //64 + 8 ( Id(UINT) + Code(UINT) + Extended(UINT) + Length(UINT))
                    _ResultDataSize := eAxoDataman_ResultDataSize#RESULT_DATA_64B;
                ELSIF _outputsCount = UINT#0 AND _inputsCount = UINT#136 THEN           //128 + 8 ( Id(UINT) + Code(UINT) + Extended(UINT) + Length(UINT))
                    _ResultDataSize := eAxoDataman_ResultDataSize#RESULT_DATA_128B;
                ELSIF _outputsCount = UINT#0 AND _inputsCount = UINT#254 THEN           //246 + 8 ( Id(UINT) + Code(UINT) + Extended(UINT) + Length(UINT))
                    _ResultDataSize := eAxoDataman_ResultDataSize#RESULT_DATA_246B;
                ELSE
                    _ResultDataSize := eAxoDataman_ResultDataSize#RESULT_DATA_SIZE_INVALID;
                    Messenger.Activate(UINT#776,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#776;
                END_IF;

                IF parent = NULL THEN
                    Messenger.Activate(UINT#1130, eAxoMessageCategory#ProgrammingError);
                    Status.Error.Id := UINT#1130;
                    RETURN;
                ELSIF _hwID = WORD#0 THEN
                    Messenger.Activate(UINT#1131, eAxoMessageCategory#ProgrammingError);
                    Status.Error.Id := UINT#1131;
                    RETURN;
                ELSIF _hwIdAcquisitionControl = WORD#0 THEN
                    Messenger.Activate(UINT#1132, eAxoMessageCategory#ProgrammingError);
                    Status.Error.Id := UINT#1132;
                    RETURN;
                ELSIF _hwIdAcquisitionStatus = WORD#0 THEN
                    Messenger.Activate(UINT#1133, eAxoMessageCategory#ProgrammingError);
                    Status.Error.Id := UINT#1133;
                    RETURN;
                ELSIF _hwIdResultsControl = WORD#0 THEN
                    Messenger.Activate(UINT#1134, eAxoMessageCategory#ProgrammingError);
                    Status.Error.Id := UINT#1134;
                    RETURN;
                ELSIF _hwIdResultsStatus = WORD#0 THEN
                    Messenger.Activate(UINT#1135, eAxoMessageCategory#ProgrammingError);
                    Status.Error.Id := UINT#1135;
                    RETURN;
                ELSIF _hwIdSoftEventControl = WORD#0 THEN
                    Messenger.Activate(UINT#1136, eAxoMessageCategory#ProgrammingError);
                    Status.Error.Id := UINT#1136;
                    RETURN;
                ELSIF  _hwIdUserData= WORD#0 THEN
                    Messenger.Activate(UINT#1137, eAxoMessageCategory#ProgrammingError);
                    Status.Error.Id := UINT#1137;
                    RETURN;
                ELSIF _hwIdResultData = WORD#0 THEN
                    Messenger.Activate(UINT#1138, eAxoMessageCategory#ProgrammingError);
                    Status.Error.Id := UINT#1138;
                    RETURN; 
                END_IF;

                _initHwCheckDone    := TRUE;
            END_IF;

            //***********Update inputs **************
            _retVal := Siemens.Simatic.S71500.DistributedIO.ReadData(_hwIdAcquisitionStatus ,_data_in);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1201, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1201;
                RETURN;
            END_IF;

            AcquisitionStatus.TriggerReady                  :=      _data_in[0].%X0;
            AcquisitionStatus.TriggerAcknowledge            :=      _data_in[0].%X1;
            AcquisitionStatus.MissedAcquisition             :=      _data_in[0].%X3;
            AcquisitionStatus.TriggerID.%B1                 :=      _data_in[1];	 
            AcquisitionStatus.TriggerID.%B0                 :=      _data_in[2];	 

            _retVal := Siemens.Simatic.S71500.DistributedIO.ReadData(_hwIdResultsStatus ,_data_in);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1202, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1202;
                RETURN;
            END_IF;

            ResultsStatus.Decoding                          :=      _data_in[0].%X0;
            ResultsStatus.DecodeComplete                    :=      _data_in[0].%X1;
            ResultsStatus.ResultsBufferOverrun              :=      _data_in[0].%X2;
            ResultsStatus.ResultsAvailable                  :=      _data_in[0].%X3;
            ResultsStatus.ErrorDetected                     :=      _data_in[0].%X7;

            _retVal := Siemens.Simatic.S71500.DistributedIO.ReadData(_hwIdSoftEventControl ,_data_in);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1203, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1203;
                RETURN;
            END_IF;

            SoftEventStatus.TrainCodeAcknowledge            :=      _data_in[0].%X0;
            SoftEventStatus.TrainMatchStringAcknowledge     :=      _data_in[0].%X1;
            SoftEventStatus.TrainFocusAcknowledge           :=      _data_in[0].%X2;
            SoftEventStatus.TrainBrightnessAcknowledge      :=      _data_in[0].%X3;
            SoftEventStatus.UntrainAcknowledge              :=      _data_in[0].%X4;
            SoftEventStatus.ExecuteDmccAcknowledge          :=      _data_in[0].%X5;
            SoftEventStatus.Reserved06                      :=      _data_in[0].%X6;
            SoftEventStatus.SetMatchStringAcknowledge       :=      _data_in[0].%X7;

            _retVal := Siemens.Simatic.S71500.DistributedIO.ReadData(_hwIdResultData ,_data_in);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1204, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1204;
                RETURN;
            END_IF;

            _invalidDataSize := NOT (_ResultDataSize = eAxoDataman_ResultDataSize#RESULT_DATA_16B OR
            _ResultDataSize = eAxoDataman_ResultDataSize#RESULT_DATA_32B OR
            _ResultDataSize = eAxoDataman_ResultDataSize#RESULT_DATA_64B OR
            _ResultDataSize = eAxoDataman_ResultDataSize#RESULT_DATA_128B OR
            _ResultDataSize = eAxoDataman_ResultDataSize#RESULT_DATA_246B);

            IF _invalidDataSize THEN
                Messenger.Activate(UINT#1205, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1205;
                RETURN;
            END_IF;

            Config.ResultDataSize := _ResultDataSize;

            Results.Id.%B1          :=  _data_in[0];     
            Results.Id.%B0          :=  _data_in[1];     
            Results.Code.%B1        :=  _data_in[2];     
            Results.Code.%B0        :=  _data_in[3];     
            Results.Extended.%B1    :=  _data_in[4];     
            Results.Extended.%B0    :=  _data_in[5];     
            Results.Length.%B1      :=  _data_in[6];     
            Results.Length.%B0      :=  _data_in[7];     

            //************Execute inline**************
            RestoreTask.Run(THIS);
            ClearResultDataTask.Run(THIS);
            ReadTask.Run(THIS);
            HardwareDiagnosticsTask.Run(THIS,_hwID);

            TaskMessenger.Serve(THIS);

            IF Config.ContinuousReading THEN
	            THIS.ContinuousReading();
            END_IF;
            
            //*************RESTORE********************
            RestoreTask.IsDisabled := FALSE;
            IF RestoreTask.Execute(THIS) THEN
                THIS.Restore();
            END_IF;
            //****************************************

            //*************CLEAR*DATA*****************
            ClearResultDataTask.IsDisabled := RestoreTask.IsBusy() OR ReadTask.IsBusy();
            IF ClearResultDataTask.StartTriggered() THEN
                Status.Action.Id :=  UINT#100;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#100,ClearResultDataTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#101,ClearResultDataTask.IsDone(), eAxoMessageCategory#Info);
            IF ClearResultDataTask.Execute(THIS) THEN
                IF _progress = 0 THEN
                    Status.Error.Id := UINT#0;
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
                    ResultsControl.ResultsAcknowledge := TRUE;
                    Results.Id := UINT#0; 
                    Results.Code := UINT#0; 
                    Results.Extended := UINT#0; 
                    Results.Length := UINT#0; 

                    FOR _index := 0 TO 245 DO
                        ResultData.Data[_index] := BYTE#0;
                    END_FOR;
                    THIS.CallTimers(FALSE);
                    _progress := 301;
                END_IF;
                
                IF _progress = 301 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#501, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#501;
                    END_IF;

                    IF NOT ResultsStatus.ResultsAvailable THEN
                        THIS.CallTimers(FALSE);
                        _progress := 302;
                    END_IF;
                END_IF;
                
                IF _progress = 302 THEN
                    ResultsControl.ResultsAcknowledge := FALSE;
                    ClearResultDataTask.DoneWhen(TRUE);
                    THIS.CallTimers(FALSE);
                    _progress := 0;
                END_IF;
                
                THIS.CallTimers(TRUE);
                
                ClearResultDataTask.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);                
            END_IF;
            IF ClearResultDataTask.DoneReached() THEN
                Status.Action.Id :=  UINT#101;
                Status.Error.Id :=  UINT#0;
            ELSIF ClearResultDataTask.ErrorOccured() THEN
                Status.Action.Id :=  UINT#10000;
                Status.Error.Id  :=  UINT#10000;
            ELSIF ClearResultDataTask.AbortTriggered()THEN
                Status.Action.Id :=  UINT#10001;
                Status.Error.Id  :=  UINT#10001;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#10000,ClearResultDataTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#10001,ClearResultDataTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#102,ClearResultDataTask.RestoreTriggered() , eAxoMessageCategory#Error);
            IF ClearResultDataTask.RestoreTriggered() AND _progress >= 300 AND _progress <= 309  THEN
                Status.Action.Id :=  UINT#102;
                _progress := 0;
            END_IF;
            //****************************************

            //*************READ***********************
            ReadTask.IsDisabled :=  RestoreTask.IsBusy() OR ClearResultDataTask.IsBusy();
            IF ReadTask.StartTriggered() THEN
                Status.Action.Id :=  UINT#110;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#110,ReadTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#111,ReadTask.IsDone(), eAxoMessageCategory#Info);
            IF ReadTask.Execute(THIS) THEN
                IF _progress = 0 THEN
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    IF ResultsStatus.ErrorDetected THEN
                        _progress := 319;
                    ELSE
                        _progress := 310;
                    END_IF;
                END_IF;

                IF _progress = 310 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#510, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#510;
                    END_IF;

                    AcquisitionControl.TriggerEnable := TRUE;
                    AcquisitionControl.Trigger := FALSE;
                    ResultsControl.EnableResultBuffering := FALSE;
                    ResultsControl.ResultsAcknowledge := ResultsStatus.ResultsAvailable;

                    IF NOT ResultsStatus.ResultsAvailable THEN
                        THIS.CallTimers(FALSE);
                        _progress := 311;
                    END_IF;
                END_IF;
                
                IF _progress = 311 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#511, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#511;
                    END_IF;

                    IF AcquisitionStatus.TriggerReady THEN
                        THIS.CallTimers(FALSE);
                        _progress := 312;
                    END_IF;
                END_IF;
                
                IF _progress = 312 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#512, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#512;
                    END_IF;

                    AcquisitionControl.Trigger := TRUE;

                    IF AcquisitionStatus.TriggerAcknowledge THEN
                        THIS.CallTimers(FALSE);
                        _progress := 313;
                    END_IF;
                END_IF;
                
                IF _progress = 313 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#513, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#513;
                    END_IF;

                    IF ResultsStatus.ResultsAvailable THEN
                        THIS.CallTimers(FALSE);
                        _progress := 314;
                    END_IF;
                END_IF;
                
                IF _progress = 314 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#514, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#514;
                    END_IF;

                    IF (*Results.Code = UINT#0 OR*) Results.Length=UINT#0 OR Results.Length > TO_UINT(Config.ResultDataSize) THEN
                        ReadTask.ThrowWhen(TRUE);
                        IF Results.Length > TO_UINT(Config.ResultDataSize) THEN
                            TaskMessenger.Activate( UINT#614, eAxoMessageCategory#Error);
                            Status.Error.Id :=      UINT#614;
                        END_IF;
                    ELSE
                        THIS.CallTimers(FALSE);
                        _progress := 315;
                    END_IF;
                END_IF;
                
                IF _progress = 315 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#515, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#515;
                    END_IF;

                    FOR _index := 0 TO (TO_INT(Results.Length) - INT#1) DO
                        ResultData.Data[_index] := _data_in[_index + 8];
                    END_FOR;
                    FOR _index := TO_INT(Results.Length) TO 245 DO
                        ResultData.Data[_index] := BYTE#0;
                    END_FOR;
                    ResultData.DataChanged := NOT ResultData.DataChanged ;
                    _progress := 316;
                END_IF;
                
                IF _progress = 316 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#516, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#516;
                    END_IF;

                    AcquisitionControl.Trigger := FALSE;
                    ResultsControl.EnableResultBuffering := FALSE;
                    ResultsControl.ResultsAcknowledge := TRUE;
                    ReadTask.DoneWhen(TRUE);
                    _progress := 0;
                END_IF;
                
                IF _progress = 319 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#519, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#519;
                    END_IF;

                    AcquisitionControl.TriggerEnable :=FALSE;
                    AcquisitionControl.Trigger := FALSE;
                    ResultsControl.EnableResultBuffering := FALSE;
                    ResultsControl.ResultsAcknowledge := FALSE;
                    IF NOT AcquisitionStatus.TriggerReady THEN
                        THIS.CallTimers(FALSE);
                        _progress := 320;
                    END_IF;
                END_IF;

                IF _progress = 320 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#520, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#520;
                    END_IF;

                    AcquisitionControl.TriggerEnable :=TRUE;
                    IF NOT ResultsStatus.ErrorDetected THEN
                        THIS.CallTimers(FALSE);
                        _progress := 321;
                    END_IF;
                END_IF;

                IF _progress = 321 THEN
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#521, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#521;
                    END_IF;

                    AcquisitionControl.TriggerEnable :=FALSE;
                    IF _infoTimer.elapsedTime >= T#1s THEN
                        THIS.CallTimers(FALSE);
                        _progress :=  310;
                    END_IF;
                END_IF;
                
                THIS.CallTimers(TRUE);
                
                ReadTask.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);
            END_IF;
            IF ReadTask.DoneReached() THEN
                Status.Action.Id :=  UINT#111;
                Status.Error.Id :=  UINT#0;
            ELSIF ReadTask.ErrorOccured() THEN
                Status.Action.Id :=  UINT#10010;
                Status.Error.Id  :=  UINT#10010;
            ELSIF ReadTask.AbortTriggered()THEN
                Status.Action.Id :=  UINT#10011;
                Status.Error.Id  :=  UINT#10011;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#10010,ReadTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#10011,ReadTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#112,ReadTask.RestoreTriggered() , eAxoMessageCategory#Error);
            IF ReadTask.RestoreTriggered() AND _progress >= 300 AND _progress <= 329  THEN
                Status.Action.Id :=  UINT#112;
                _progress := 0;
            END_IF;
            //******************************************      

            //***********Update outputs ****************
            _data_1[0].%X0                  :=      AcquisitionControl.TriggerEnable;
            _data_1[0].%X1                  :=      AcquisitionControl.Trigger;

            _retVal := Siemens.Simatic.S71500.DistributedIO.WriteData(_hwIdAcquisitionControl,_data_1);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1231, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1231;
                RETURN;
            END_IF;  

            _data_1[0].%X0                  :=      ResultsControl.EnableResultBuffering;
            _data_1[0].%X1                  :=      ResultsControl.ResultsAcknowledge;
            
            _retVal := Siemens.Simatic.S71500.DistributedIO.WriteData(_hwIdResultsControl,_data_1);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1232, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1232;
                RETURN;
            END_IF;  

            _data_1[0].%X0                  :=      SoftEventControl.TrainCode;
            _data_1[0].%X1                  :=      SoftEventControl.TrainMatchString;
            _data_1[0].%X2                  :=      SoftEventControl.TrainFocus;
            _data_1[0].%X3                  :=      SoftEventControl.TrainBrightness;
            _data_1[0].%X4                  :=      SoftEventControl.Untrain;
            _data_1[0].%X5                  :=      SoftEventControl.ExecuteDMCC;
            _data_1[0].%X6                  :=      SoftEventControl.Reserved06;
            _data_1[0].%X7                  :=      SoftEventControl.SetMatchString;

            _retVal := Siemens.Simatic.S71500.DistributedIO.WriteData(_hwIdSoftEventControl,_data_1);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1233, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1233;
                RETURN;
            END_IF;  

            _invalidDataSize := NOT (_UserDataSize = eAxoDataman_UserDataSize#USER_DATA_16B OR
                                     _UserDataSize = eAxoDataman_UserDataSize#USER_DATA_32B OR
                                     _UserDataSize = eAxoDataman_UserDataSize#USER_DATA_64B OR
                                     _UserDataSize = eAxoDataman_UserDataSize#USER_DATA_128B OR
                                     _UserDataSize = eAxoDataman_UserDataSize#USER_DATA_250B);

            IF _invalidDataSize THEN
                Messenger.Activate(UINT#1234, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1234;
                RETURN;
            END_IF;

            Config.UserDataSize := _UserDataSize;

            IF (UserData.DataChanged <> _UserDataChanged) THEN
                IF Config.UserDataSize = eAxoDataman_UserDataSize#USER_DATA_16B THEN
                    FOR _index := 0 TO 15 DO
                        _data_16[_index] := UserData.Data[_index];
                    END_FOR;
                    _retVal := Siemens.Simatic.S71500.DistributedIO.WriteData(_hwIdUserData ,_data_16);
                    IF _retVal > WORD#0 THEN
                        Messenger.Activate(UINT#1235, eAxoMessageCategory#ProgrammingError);
                        Status.Error.Id := UINT#1235;
                        RETURN;
                    END_IF;  
                ELSIF Config.UserDataSize = eAxoDataman_UserDataSize#USER_DATA_32B THEN
                    FOR _index := 0 TO 31 DO
                        _data_32[_index] := UserData.Data[_index];
                    END_FOR;
                    _retVal := Siemens.Simatic.S71500.DistributedIO.WriteData(_hwIdUserData ,_data_32);
                    IF _retVal > WORD#0 THEN
                        Messenger.Activate(UINT#1236, eAxoMessageCategory#ProgrammingError);
                        Status.Error.Id := UINT#1236;
                        RETURN;
                    END_IF;  
                ELSIF Config.UserDataSize = eAxoDataman_UserDataSize#USER_DATA_64B THEN
                    FOR _index := 0 TO 63 DO
                        _data_64[_index] := UserData.Data[_index];
                    END_FOR;
                    _retVal := Siemens.Simatic.S71500.DistributedIO.WriteData(_hwIdUserData ,_data_64);
                    IF _retVal > WORD#0 THEN
                        Messenger.Activate(UINT#1237, eAxoMessageCategory#ProgrammingError);
                        Status.Error.Id := UINT#1237;
                        RETURN;
                    END_IF;  
                ELSIF Config.UserDataSize = eAxoDataman_UserDataSize#USER_DATA_128B THEN
                    FOR _index := 0 TO 127 DO
                        _data_128[_index] := UserData.Data[_index];
                    END_FOR;
                    _retVal := Siemens.Simatic.S71500.DistributedIO.WriteData(_hwIdUserData ,_data_128);
                    IF _retVal > WORD#0 THEN
                        Messenger.Activate(UINT#1238, eAxoMessageCategory#ProgrammingError);
                        Status.Error.Id := UINT#1238;
                        RETURN;
                    END_IF;  
                ELSIF Config.UserDataSize = eAxoDataman_UserDataSize#USER_DATA_250B THEN
                    FOR _index := 0 TO 253 DO
                        _data_250[_index] := UserData.Data[_index];
                    END_FOR;
                    _retVal := Siemens.Simatic.S71500.DistributedIO.WriteData(_hwIdUserData ,_data_250);
                    IF _retVal > WORD#0 THEN
                        Messenger.Activate(UINT#1239, eAxoMessageCategory#ProgrammingError);
                        Status.Error.Id := UINT#1239;
                        RETURN;
                    END_IF;  
                END_IF;
                _UserDataChanged := UserData.DataChanged;
            END_IF;
        END_METHOD

        ///<summary>
		/// Clears the result data. 	
        ///</summary>       
        METHOD PUBLIC ClearResultData : IAxoTaskState
            ClearResultData :=ClearResultDataTask.Invoke(THIS);;
        END_METHOD

        ///<summary>
		/// Triggers the reading sequence and waits for results. 	
        ///</summary>       
        METHOD PUBLIC Read : IAxoTaskState
            VAR_OUTPUT
                result : ARRAY [0..245] OF BYTE;
            END_VAR
            result := ResultData.Data;
            Read := ReadTask.Invoke(THIS);
        END_METHOD
        
        METHOD PRIVATE CallTimers
            VAR_INPUT
                signal : BOOL;
            END_VAR
            
            _infoTimer.OnDelay(THIS, signal , Config.InfoTime);
            _errorTimer.OnDelay(THIS, signal , Config.ErrorTime );
        END_METHOD
  
        METHOD PRIVATE ContinuousReading
            VAR 
                _index : INT;
            END_VAR
            IF ResultsStatus.ResultsAvailable AND NOT ResultsControl.ResultsAcknowledge AND Results.Code > UINT#0 AND Results.Length > UINT#0 THEN
                IF Results.Length > TO_UINT(Config.ResultDataSize) THEN
                    Messenger.Activate( UINT#10020, eAxoMessageCategory#Error);
                    Status.Action.Id := UINT#10020;
                    TaskMessenger.Activate( UINT#713, eAxoMessageCategory#Error);
                    Status.Error.Id :=      UINT#713;
                ELSE
                    FOR _index := 0 TO (TO_INT(Results.Length) - INT#1) DO
                        ResultData.Data[_index] := _data_in[_index + 8];
                    END_FOR;
                    FOR _index := TO_INT(Results.Length) TO 245 DO
                        ResultData.Data[_index] := BYTE#0;
                    END_FOR;
                    ResultData.DataChanged := NOT ResultData.DataChanged ;
                    Status.Action.Id := UINT#120;
                END_IF;
            END_IF;
            ResultsControl.ResultsAcknowledge := ResultsStatus.ResultsAvailable;
        END_METHOD
        
        ///<summary>
		/// Custom logic for the manual control.
        ///</summary>   
        METHOD PROTECTED OVERRIDE ManualControl
            ;
        END_METHOD

        ///<summary>
		/// Restores this instance to its initial state. 
        ///</summary>   
        METHOD PUBLIC OVERRIDE Restore
            VAR
                _index : INT;
            END_VAR
            Status.Action.Id := UINT#0;
            Status.Error.Id  := UINT#0;
            Messenger.Restore();
            TaskMessenger.Restore();

            ClearResultDataTask.Restore();
            ReadTask.Restore();
             
            Results.Code        :=  UINT#0;
            Results.Extended    :=  UINT#0;
            Results.Id          :=  UINT#0;
            Results.Length      :=  UINT#0;

            FOR _index := 0 TO 245 DO
                ResultData.Data[_index] := BYTE#0;
            END_FOR;
            ResultData.ToggleDataChangedFlag();

            AcquisitionControl.TriggerEnable       :=  ResultsStatus.ErrorDetected;
            AcquisitionControl.Trigger             :=  FALSE;

            ResultsControl.EnableResultBuffering   :=  FALSE;
            ResultsControl.ResultsAcknowledge      :=  FALSE;       

            SoftEventControl.TrainCode 			    :=  FALSE;    			
            SoftEventControl.TrainMatchString 		:=  FALSE;   
            SoftEventControl.TrainFocus 			:=  FALSE;   			
            SoftEventControl.TrainBrightness 		:=  FALSE;   
            SoftEventControl.Untrain 				:=  FALSE;   		
            SoftEventControl.ExecuteDMCC 			:=  FALSE;   	
            SoftEventControl.Reserved06 			:=  FALSE;    	
            SoftEventControl.SetMatchString 		:=  FALSE;   		

            User.Option :=  UINT#0;
            User.Length :=  UINT#0;
            FOR _index := 0 TO 249 DO
                UserData.Data[_index] := BYTE#0;
            END_FOR;
            UserData.ToggleDataChangedFlag();

            IF NOT ResultsStatus.ErrorDetected THEN
                Status.Action.Id := UINT#50;
                RestoreTask.DoneWhen(TRUE);
            END_IF;
        END_METHOD

END_CLASS    
END_NAMESPACE
