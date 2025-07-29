USING AXOpen.Messaging.Static;
USING AXOpen.Messaging;
USING AXOpen.Core;
USING AXOpen.Components.Abstractions;
USING Siemens.Simatic.S71500.Hardware.Utilities;

NAMESPACE AXOpen.Components.Keyence.Vision
    {S7.extern=ReadWrite}
    CLASS PUBLIC Axo_SR_1000 EXTENDS AXOpen.Core.AxoComponent IMPLEMENTS AXOpen.Components.Abstractions.IAxoCodeReader 
        VAR PRIVATE
            _ResultDataSize                                     :   eAxo_SR_1000_ResultDataSize;
            _UserDataSize                                       :   eAxo_SR_1000_UserDataSize;
            _hwID                                               :   WORD;
            _hwIdHandshakeAndGeneralErrorStatus                 :   WORD;
            _hwIdBUSY_Status                                    :   WORD;
            _hwIdCompletionStatus                               :   WORD;
            _hwIdErrorStatus                                    :   WORD;
            _hwIdTerminalStatus                                 :   WORD;
            _hwIdUnstableReadStatus                             :   WORD;
            _hwIdMatchingLevelAndTotalEvaluationGradeStatus     :   WORD;
            _hwIdOperationalResultStatus                        :   WORD;
            _hwIdReadData                                       :   WORD;
            _hwIdLatchAndErrorClearControl                      :   WORD;
            _hwIdOperationInstructionControl                    :   WORD;
            _hwIdCompletionClearControl                         :   WORD;
            _hwIdParameterBankNumber                            :   WORD;
            _hwIdUserData                                       :   WORD;

            _progress                                           :   INT := 0;
            _infoTimer                                          :   AXOpen.Timers.OnDelayTimer;
            _errorTimer                                         :   AXOpen.Timers.OnDelayTimer;
            _inspectionCompleted                                :   BOOL;
            _data_in                                            :   ARRAY[0..254] OF BYTE;
            _Bank                                               :   UINT;
            _UserDataChanged                                    :   BOOL;

            _invalidDataSize                                    :   BOOL;
            _retVal                                             :   WORD;
            _word                                               :   WORD;
            _data_1                                             :   ARRAY[0..0] OF BYTE;
            _data_2                                             :   ARRAY[0..1] OF BYTE;
            _data_34                                            :   ARRAY[0..33] OF BYTE;
            _data_66                                            :   ARRAY[0..65] OF BYTE;
            _data_130                                           :   ARRAY[0..129] OF BYTE;
            _data_254                                           :   ARRAY[0..253] OF BYTE;           

            _prevResultDataReadyCount                           :   UINT;
            _prevResultDataUpdateCount                          :   UINT;
            _resultString                                       :   STRING[254];

            _initHwCheckDone        :   BOOL;
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
        
        VAR PUBLIC //Header
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentHeader()]}
            {#ix-set:AttributeName = "<#Bank#>"}
            Bank : UINT;
            {#ix-attr:[ComponentHeader()]}
            {#ix-set:AttributeName = "<#Read#>"}
            ReadTask : AXOpen.Core.AxoTask;            
            {#ix-attr:[ComponentHeader()]}         
            {#ix-attr:[ReadOnly()]}
            {#ix-set:AttributeName = "<#Inspection results#>"}
            {#ix-set:DisplayFormat = "string"}
            ResultData  :   Axo_SR_1000_ResultData;
        END_VAR

        VAR PUBLIC //Tasks
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#Restore#>"}
            RestoreTask : AXOpen.Core.AxoTask;
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#Clear result data#>"}
            ClearResultDataTask : AXOpen.Core.AxoTask;
            {#ix-attr:[ComponentDetails("Tasks")]}
            {#ix-set:AttributeName = "<#Tune data#>"}
            TuneTask : AXOpen.Core.AxoTask;
        END_VAR

        VAR PUBLIC //Config
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[ComponentDetails("Config")]}
            Config      :   Axo_SR_1000_Config;

        END_VAR

        VAR PUBLIC //Status
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[ComponentDetails("Status")]}
            {#ix-attr:[ReadOnly()]}
            Status      :   Axo_SR_1000_Component_Status;

            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-attr:[ComponentDetails("Status")]}
            {#ix-attr:[ReadOnly()]}
            {#ix-set:AttributeName = "<#Read data#>"}
            Results     :   Axo_SR_1000_ReadData;

            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-attr:[ComponentDetails("Status")]}
            {#ix-attr:[ReadOnly()]}
            {#ix-set:AttributeName = "<#Handshake and General Error#>"}
            HandshakeAndGeneralErrorStatus    :   Axo_SR_1000_HandshakeAndGeneralErrorStatus;

            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-attr:[ComponentDetails("Status")]}
            {#ix-attr:[ReadOnly()]}
            {#ix-set:AttributeName = "<#BUSY Status#>"}
            BUSY_Status     :   Axo_SR_1000_BusyStatus;

            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-attr:[ComponentDetails("Status")]}
            {#ix-set:AttributeName = "<#Completion Status#>"}
            {#ix-attr:[ReadOnly()]}
            CompletionStatus     :   Axo_SR_1000_CompletionStatus;

            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-attr:[ComponentDetails("Status")]}
            {#ix-set:AttributeName = "<#Error Status#>"}
            {#ix-attr:[ReadOnly()]}
            ErrorStatus      :   Axo_SR_1000_ErrorStatus;

            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-attr:[ComponentDetails("Status")]}
            {#ix-set:AttributeName = "<#Terminal Status#>"}
            {#ix-attr:[ReadOnly()]}
            TerminalStatus         :   Axo_SR_1000_TerminalStatus;

            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-attr:[ComponentDetails("Status")]}
            {#ix-set:AttributeName = "<#Unstable Read Status#>"}
            {#ix-attr:[ReadOnly()]}
            UnstableReadStatus          :   Axo_SR_1000_UnstableReadStatus;

            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-attr:[ComponentDetails("Status")]}
            {#ix-set:AttributeName = "<#Matching Level and Total Evaluation Grade Status#>"}
            {#ix-attr:[ReadOnly()]}
            MatchingLevelAndTotalEvaluationGradeStatus       :   Axo_SR_1000_MatchingLevelAndTotalEvaluationGradeStatus;
 
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-attr:[ComponentDetails("Status")]}
            {#ix-set:AttributeName = "<#Operation Result Status#>"}
            {#ix-attr:[ReadOnly()]}
            OperationalResultStatus        :   Axo_SR_1000_OperationalResultStatus;
 
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-attr:[ComponentDetails("Status")]}
            {#ix-set:AttributeName = "<#Read Data#>"}
            {#ix-attr:[ReadOnly()]}
            ReadData        :   Axo_SR_1000_ReadData;

            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-attr:[ComponentDetails("Status")]}
            {#ix-set:AttributeName = "<#Latch and Error Clear Control#>"}
            {#ix-attr:[ReadOnly()]}
            LatchAndErrorClearControl        :   Axo_SR_1000_LatchAndErrorClearControl;

            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-attr:[ComponentDetails("Status")]}
            {#ix-set:AttributeName = "<#Operation instruction Control#>"}
            {#ix-attr:[ReadOnly()]}
            OperationInstructionControl        :   Axo_SR_1000_OperationInstructionControl;

            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-attr:[ComponentDetails("Status")]}
            {#ix-set:AttributeName = "<#Completion Clear Control#>"}
            {#ix-attr:[ReadOnly()]}
            CompletionClearControl        :   Axo_SR_1000_CompletionClearControl;

            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-attr:[ComponentDetails("Status")]}
            {#ix-set:AttributeName = "<#Parameter Bank Number#>"}
            {#ix-attr:[ReadOnly()]}
            ParameterBankNumber        :   Axo_SR_1000_ParameterBankNumber;

            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-attr:[ComponentDetails("Status")]}
            {#ix-set:AttributeName = "<#User data#>"}
            {#ix-attr:[ReadOnly()]}
            User        :   Axo_SR_1000_User;

            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]} 
            {#ix-attr:[ComponentDetails("Status")]}
            {#ix-set:AttributeName = "<#User Data#>"}
            {#ix-attr:[ReadOnly()]}
            UserData        :   Axo_SR_1000_UserData;
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
                parent                                          :   IAxoObject; 
                hwID                                            :   WORD;
            END_VAR
        
            VAR
                _index                   :   INT;
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
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => _outHwid);        
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _hwIdHandshakeAndGeneralErrorStatus :=  TO_WORD(_outHwid);                                         
                IF _hwIdHandshakeAndGeneralErrorStatus = WORD#0 THEN
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
                ReadHardwareIOAddress(hardwareIdentifier :=  _hwIdHandshakeAndGeneralErrorStatus , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#1 THEN
                    Messenger.Activate(UINT#716,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#716;
                    RETURN;
                END_IF;
                //******************Slot 2*****************//
                _geoAddr.Slot   :=  UINT#2;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => _outHwid);        
                _hwIdBUSY_Status :=  TO_WORD(_outHwid);                                         
                IF _hwIdBUSY_Status = WORD#0 THEN
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
                ReadHardwareIOAddress(hardwareIdentifier :=  _hwIdBUSY_Status , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#1 THEN
                    Messenger.Activate(UINT#726,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#726;
                    RETURN;
                END_IF;
                //******************Slot 3*****************//
                _geoAddr.Slot   :=  UINT#3;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => _outHwid);        
                _hwIdCompletionStatus :=  TO_WORD(_outHwid);                                         
                IF _hwIdCompletionStatus = WORD#0 THEN
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
                ReadHardwareIOAddress(hardwareIdentifier :=  _hwIdCompletionStatus , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#1 THEN
                    Messenger.Activate(UINT#736,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#736;
                    RETURN;
                END_IF;
                //******************Slot 4*****************//
                _geoAddr.Slot   :=  UINT#4;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => _outHwid);        
                _hwIdErrorStatus :=  TO_WORD(_outHwid);                                         
                IF _hwIdErrorStatus = WORD#0 THEN
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
                ReadHardwareIOAddress(hardwareIdentifier :=  _hwIdErrorStatus , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#1 THEN
                    Messenger.Activate(UINT#746,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#746;
                    RETURN;
                END_IF;
                //******************Slot 5*****************//
                _geoAddr.Slot   :=  UINT#5;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => _outHwid);        
                _hwIdTerminalStatus :=  TO_WORD(_outHwid);                                         
                IF _hwIdTerminalStatus = WORD#0 THEN
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
                ReadHardwareIOAddress(hardwareIdentifier :=  _hwIdTerminalStatus , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#1 THEN
                    Messenger.Activate(UINT#756,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#756;
                    RETURN;
                END_IF;
                //******************Slot 6*****************//
                _geoAddr.Slot   :=  UINT#6;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => _outHwid);        
                _hwIdUnstableReadStatus :=  TO_WORD(_outHwid);                                         
                IF _hwIdUnstableReadStatus = WORD#0 THEN
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
                ReadHardwareIOAddress(hardwareIdentifier :=  _hwIdUnstableReadStatus , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#1 THEN
                    Messenger.Activate(UINT#766,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#766;
                    RETURN;
                END_IF;
                //******************Slot 7*****************//
                _geoAddr.Slot   :=  UINT#7;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => _outHwid);        
                _hwIdMatchingLevelAndTotalEvaluationGradeStatus :=  TO_WORD(_outHwid);                                         
                IF _hwIdMatchingLevelAndTotalEvaluationGradeStatus = WORD#0 THEN
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
                ReadHardwareIOAddress(hardwareIdentifier :=  _hwIdMatchingLevelAndTotalEvaluationGradeStatus , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#8 THEN
                    Messenger.Activate(UINT#776,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#776;
                    RETURN;
                END_IF;
                //******************Slot 8*****************//
                _geoAddr.Slot   :=  UINT#8;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => _outHwid);        
                _hwIdOperationalResultStatus :=  TO_WORD(_outHwid);                                         
                IF _hwIdOperationalResultStatus = WORD#0 THEN
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
                ReadHardwareIOAddress(hardwareIdentifier :=  _hwIdOperationalResultStatus , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount <> UINT#20 THEN
                    Messenger.Activate(UINT#786,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#786;
                    RETURN;
                END_IF;
                //******************Slot 9*****************//
                _geoAddr.Slot   :=  UINT#9;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => _outHwid);        
                _hwIdReadData :=  TO_WORD(_outHwid);
                IF _hwIdReadData = WORD#0 THEN
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
                ReadHardwareIOAddress(hardwareIdentifier :=  _hwIdReadData , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount = UINT#32 THEN
                    Config.ResultDataSize := eAxo_SR_750_ResultDataSize#RESULT_DATA_32B;
                ELSIF _inputsCount = UINT#64 THEN
                    Config.ResultDataSize := eAxo_SR_750_ResultDataSize#RESULT_DATA_64B;
                ELSIF _inputsCount = UINT#128 THEN
                    Config.ResultDataSize := eAxo_SR_750_ResultDataSize#RESULT_DATA_128B;
                ELSIF _inputsCount = UINT#246 THEN
                    Config.ResultDataSize := eAxo_SR_750_ResultDataSize#RESULT_DATA_246B;
                ELSE
                    Config.ResultDataSize := eAxo_SR_750_ResultDataSize#RESULT_DATA_SIZE_INVALID;
                    Messenger.Activate(UINT#796,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#796;
                    RETURN;
                END_IF;
                //******************Slot 10*****************//
                _geoAddr.Slot   :=  UINT#10;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => _outHwid);        
                _hwIdLatchAndErrorClearControl :=  TO_WORD(_outHwid);                                         
                IF _hwIdLatchAndErrorClearControl = WORD#0 THEN
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
                ReadHardwareIOAddress(hardwareIdentifier :=  _hwIdLatchAndErrorClearControl , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _outputsCount <> UINT#1 THEN
                    Messenger.Activate(UINT#806,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#806;
                    RETURN;
                END_IF;
                //******************Slot 11*****************//
                _geoAddr.Slot   :=  UINT#11;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => _outHwid);        
                _hwIdOperationInstructionControl :=  TO_WORD(_outHwid);                                         
                IF _hwIdOperationInstructionControl = WORD#0 THEN
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
                ReadHardwareIOAddress(hardwareIdentifier :=  _hwIdOperationInstructionControl , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _outputsCount <> UINT#1 THEN
                    Messenger.Activate(UINT#816,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#816;
                    RETURN;
                END_IF;
                //******************Slot 12*****************//
                _geoAddr.Slot   :=  UINT#12;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => _outHwid);        
                _hwIdCompletionClearControl :=  TO_WORD(_outHwid);                                         
                IF _hwIdCompletionClearControl = WORD#0 THEN
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
                ReadHardwareIOAddress(hardwareIdentifier :=  _hwIdCompletionClearControl , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _outputsCount <> UINT#1 THEN
                    Messenger.Activate(UINT#826,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#826;
                    RETURN;
                END_IF;
                //******************Slot 13*****************//
                _geoAddr.Slot   :=  UINT#13;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => _outHwid);        
                _hwIdParameterBankNumber :=  TO_WORD(_outHwid);                                         
                IF _hwIdParameterBankNumber = WORD#0 THEN
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
                ReadHardwareIOAddress(hardwareIdentifier :=  _hwIdParameterBankNumber , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _outputsCount <> UINT#2 THEN
                    Messenger.Activate(UINT#836,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#836;
                    RETURN;
                END_IF;
                //******************Slot 14*****************//
                _geoAddr.Slot   :=  UINT#14;                                                            
                _geoAddr.HardwareType := UINT#4; // (4-Module)
                _retval := ReadHardwareIDFromSlot(geoAddr := _geoAddr, hardwareID => _outHwid);        
                _hwIdUserData :=  TO_WORD(_outHwid);                                         
                IF _hwIdUserData = WORD#0 THEN
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
                ReadHardwareIOAddress(hardwareIdentifier :=  _hwIdUserData , inputStartAddress => _inputsAddress , inputCount => _inputsCount , outputStartAddress => _outputsAddress , outputCount => _outputsCount); 
                IF _inputsCount = UINT#32 THEN
                    Config.UserDataSize := eAxo_SR_750_UserDataSize#USER_DATA_32B;    
                ELSIF _inputsCount = UINT#64 THEN
                    Config.UserDataSize := eAxo_SR_750_UserDataSize#USER_DATA_64B;    
                ELSIF _inputsCount = UINT#128 THEN
                    Config.UserDataSize := eAxo_SR_750_UserDataSize#USER_DATA_128B;    
                ELSIF _inputsCount = UINT#252 THEN
                    Config.UserDataSize := eAxo_SR_750_UserDataSize#USER_DATA_252B;    
                ELSE
                    Config.UserDataSize := eAxo_SR_750_UserDataSize#USER_DATA_SIZE_INVALID;    
                    Messenger.Activate(UINT#846,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#846;
                    RETURN;
                END_IF;

                IF parent = NULL THEN
                    Messenger.Activate(UINT#1130,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1130;
                    RETURN;
                END_IF;

                IF _hwID  = WORD#0 THEN
                    Messenger.Activate(UINT#1131,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1131;
                    RETURN;
                END_IF;
            
                IF _hwIdHandshakeAndGeneralErrorStatus  = WORD#0 THEN
                    Messenger.Activate(UINT#1132,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1132;
                    RETURN;
                END_IF;
            
                IF _hwIdBUSY_Status  = WORD#0 THEN
                    Messenger.Activate(UINT#1133,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1133;
                    RETURN;
                END_IF;
            
                IF _hwIdCompletionStatus  = WORD#0 THEN
                    Messenger.Activate(UINT#1134,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1134;
                    RETURN;
                END_IF;

                IF _hwIdErrorStatus  = WORD#0 THEN
                    Messenger.Activate(UINT#1135,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1135;
                    RETURN;
                END_IF;
            
                IF _hwIdTerminalStatus  = WORD#0 THEN
                    Messenger.Activate(UINT#1136,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1136;
                    RETURN;
                END_IF;
            
                IF _hwIdUnstableReadStatus  = WORD#0 THEN
                    Messenger.Activate(UINT#1137,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1137;
                    RETURN;
                END_IF;
            
                IF _hwIdMatchingLevelAndTotalEvaluationGradeStatus  = WORD#0 THEN
                    Messenger.Activate(UINT#1138,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1138;
                    RETURN;
                END_IF;
            
                IF _hwIdOperationalResultStatus  = WORD#0 THEN
                    Messenger.Activate(UINT#1139,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1139;
                    RETURN;
                END_IF;
            
                IF _hwIdReadData  = WORD#0 THEN
                    Messenger.Activate(UINT#1140,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1140;
                    RETURN;
                END_IF;

                IF _hwIdLatchAndErrorClearControl  = WORD#0 THEN
                    Messenger.Activate(UINT#1141,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1141;
                    RETURN;
                END_IF;
            
                IF _hwIdOperationInstructionControl  = WORD#0 THEN
                    Messenger.Activate(UINT#1142,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1142;
                    RETURN;
                END_IF;
            
                IF _hwIdCompletionClearControl  = WORD#0 THEN
                    Messenger.Activate(UINT#1143,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1143;
                    RETURN;
                END_IF;
            
                IF _hwIdParameterBankNumber  = WORD#0 THEN
                    Messenger.Activate(UINT#1144,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1144;
                    RETURN;
                END_IF;
            
                IF _hwIdUserData  = WORD#0 THEN
                    Messenger.Activate(UINT#1145,eAxoMessageCategory#Error);
                    Status.Error.Id := UINT#1145;
                    RETURN;
                END_IF;


                _initHwCheckDone    := TRUE;
            END_IF;            

            //****************************************
            //***********Update inputs ***************
            _retVal := Siemens.Simatic.S71500.DistributedIO.ReadData(_hwIdHandshakeAndGeneralErrorStatus ,_data_in);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1201, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1201;
                RETURN;
            END_IF;

            HandshakeAndGeneralErrorStatus.Error                :=      _data_in[0].%X0;
            HandshakeAndGeneralErrorStatus.ResultDataAvailable  :=      _data_in[0].%X1;
            HandshakeAndGeneralErrorStatus.ResultDataStrobe     :=      _data_in[0].%X2;
            HandshakeAndGeneralErrorStatus.BufferOverflowError  :=      _data_in[0].%X6; 
            HandshakeAndGeneralErrorStatus.GeneralError         :=      _data_in[0].%X7; 

            _retVal := Siemens.Simatic.S71500.DistributedIO.ReadData(_hwIdBUSY_Status ,_data_in);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1202, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1202;
                RETURN;
            END_IF;

            BUSY_Status.BUSY                                    :=      _data_in[0].%X0;
            BUSY_Status.TRG_BUSY                                :=      _data_in[0].%X1;
            BUSY_Status.LOCK_BUSY                               :=      _data_in[0].%X2;
            BUSY_Status.MODE_BUSY                               :=      _data_in[0].%X3;
            BUSY_Status.ERR_BUSY                                :=      _data_in[0].%X4;

            _retVal := Siemens.Simatic.S71500.DistributedIO.ReadData(_hwIdCompletionStatus ,_data_in);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1203, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1203;
                RETURN;
            END_IF;


            CompletionStatus.ReadComplete                       :=      _data_in[0].%X0;
            CompletionStatus.PresetComplete                     :=      _data_in[0].%X1;
            CompletionStatus.RegisterPresetDataComplete         :=      _data_in[0].%X2;
            CompletionStatus.TuneComplete                       :=      _data_in[0].%X3;
            CompletionStatus.EXT_RequestComplete                :=      _data_in[0].%X7;

            _retVal := Siemens.Simatic.S71500.DistributedIO.ReadData(_hwIdErrorStatus ,_data_in);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1204, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1204;
                RETURN;
            END_IF;

            ErrorStatus.ReadFailure                             :=      _data_in[0].%X0;
            ErrorStatus.PresetFailure                           :=      _data_in[0].%X1;
            ErrorStatus.RegisterPresetDataFailure               :=      _data_in[0].%X2;
            ErrorStatus.TuneFailure                             :=      _data_in[0].%X3;
            ErrorStatus.EXT_RequestFailure                      :=      _data_in[0].%X7;

            _retVal := Siemens.Simatic.S71500.DistributedIO.ReadData( _hwIdTerminalStatus,_data_in);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1205, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1205;
                RETURN;
            END_IF;

            TerminalStatus.IN1_Status                           :=      _data_in[0].%X0;
            TerminalStatus.IN2_Status                           :=      _data_in[0].%X1;
            TerminalStatus.OUT1_Status                          :=      _data_in[0].%X4;
            TerminalStatus.OUT2_Status                          :=      _data_in[0].%X5;
            TerminalStatus.OUT3_Status                          :=      _data_in[0].%X6;

            _retVal := Siemens.Simatic.S71500.DistributedIO.ReadData( _hwIdUnstableReadStatus,_data_in);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1206, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1206;
                RETURN;
            END_IF;
            
            UnstableReadStatus.Unstable                         :=      _data_in[0].%X0;
            UnstableReadStatus.MatchingLevelUnstable            :=      _data_in[0].%X1;
            UnstableReadStatus.ISO_IEC_15415_Unstable           :=      _data_in[0].%X2;
            UnstableReadStatus.ISO_IEC_TR_29158_Unstable        :=      _data_in[0].%X3;
            UnstableReadStatus.SAE_AS9132_Unstable              :=      _data_in[0].%X4;

            _retVal := Siemens.Simatic.S71500.DistributedIO.ReadData(_hwIdMatchingLevelAndTotalEvaluationGradeStatus ,_data_in);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1207, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1207;
                RETURN;
            END_IF;
            
            _word.%B1                                                           :=  _data_in[0];
            _word.%B0                                                           :=  _data_in[1];
            MatchingLevelAndTotalEvaluationGradeStatus.MatchingLevel            :=  TO_UINT(_word);
            _word.%B1                                                           :=  _data_in[2];
            _word.%B0                                                           :=  _data_in[3];
            MatchingLevelAndTotalEvaluationGradeStatus.ISO_IEC_15415_Grade      :=  TO_UINT(_word);
            _word.%B1                                                           :=  _data_in[4];
            _word.%B0                                                           :=  _data_in[5];
            MatchingLevelAndTotalEvaluationGradeStatus.ISO_IEC_TR_29158_Grade   :=  TO_UINT(_word);
            _word.%B1                                                           :=  _data_in[6];
            _word.%B0                                                           :=  _data_in[7];
            MatchingLevelAndTotalEvaluationGradeStatus._Reserved                :=  TO_UINT(_word);

            _retVal := Siemens.Simatic.S71500.DistributedIO.ReadData( _hwIdOperationalResultStatus,_data_in);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1208, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1208;
                RETURN;
            END_IF;

            _word.%B1                                                           :=  _data_in[0];
            _word.%B0                                                           :=  _data_in[1];
            OperationalResultStatus.ReadResultCode                              :=  TO_UINT(_word);
            _word.%B1                                                           :=  _data_in[2];
            _word.%B0                                                           :=  _data_in[3];
            OperationalResultStatus.PresetResultCode                            :=  TO_UINT(_word);
            _word.%B1                                                           :=  _data_in[4];
            _word.%B0                                                           :=  _data_in[5];
            OperationalResultStatus.RegisterPresetDataResultCode                :=  TO_UINT(_word);
            _word.%B1                                                           :=  _data_in[6];
            _word.%B0                                                           :=  _data_in[7];
            OperationalResultStatus.TuneResultCode                              :=  TO_UINT(_word);
            _word.%B1                                                           :=  _data_in[8];
            _word.%B0                                                           :=  _data_in[9];
            OperationalResultStatus._Reserved_0                                 :=  TO_UINT(_word);
            _word.%B1                                                           :=  _data_in[10];
            _word.%B0                                                           :=  _data_in[11];
            OperationalResultStatus._Reserved_1                                 :=  TO_UINT(_word);
            _word.%B1                                                           :=  _data_in[12];
            _word.%B0                                                           :=  _data_in[13];
            OperationalResultStatus._Reserved_2                                 :=  TO_UINT(_word);
            _word.%B1                                                           :=  _data_in[14];
            _word.%B0                                                           :=  _data_in[15];
            OperationalResultStatus.EXT_RequestResultCode                       :=  TO_UINT(_word);
            _word.%B1                                                           :=  _data_in[16];
            _word.%B0                                                           :=  _data_in[17];
            OperationalResultStatus.GeneralErrorCode                            :=  TO_UINT(_word);
            _word.%B1                                                           :=  _data_in[18];
            _word.%B0                                                           :=  _data_in[19];
            OperationalResultStatus._Reserved_3                                 :=  TO_UINT(_word);

            _retVal := Siemens.Simatic.S71500.DistributedIO.ReadData( _hwIdReadData,_data_in);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1209, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1209;
                RETURN;
            END_IF;

            _invalidDataSize := NOT (   _ResultDataSize = eAxo_SR_1000_ResultDataSize#RESULT_DATA_32B OR
                                        _ResultDataSize = eAxo_SR_1000_ResultDataSize#RESULT_DATA_64B OR
                                        _ResultDataSize = eAxo_SR_1000_ResultDataSize#RESULT_DATA_128B OR
                                        _ResultDataSize = eAxo_SR_1000_ResultDataSize#RESULT_DATA_246B);

            IF _invalidDataSize THEN
                Messenger.Activate(UINT#1210, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1210;
                RETURN;
            END_IF;

            _word.%B1                                                           :=  _data_in[0];
            _word.%B0                                                           :=  _data_in[1];
            ReadData.ResultDataReadyCount                                       :=  TO_UINT(_word);
            _word.%B1                                                           :=  _data_in[2];
            _word.%B0                                                           :=  _data_in[3];
            ReadData.ResultDataUpdateCount                                      :=  TO_UINT(_word);
            _word.%B1                                                           :=  _data_in[4];
            _word.%B0                                                           :=  _data_in[5];
            ReadData._Reserved                                                  :=  TO_UINT(_word);
            _word.%B1                                                           :=  _data_in[6];
            _word.%B0                                                           :=  _data_in[7];
            ReadData.ResultDataSize                                             :=  TO_UINT(_word);
            //ResultData.Data : ARRAY[0..245] OF BYTE;      // will be read conditionally after results are available



            //************Execute*********************
            RestoreTask.Run(THIS);
            ClearResultDataTask.Run(THIS);
            ReadTask.Run(THIS);
            TuneTask.Run(THIS);
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

            //*************ClearResultDataTask***************
            ClearResultDataTask.IsDisabled := RestoreTask.IsBusy() OR ReadTask.IsBusy() OR TuneTask.IsBusy();
            IF ClearResultDataTask.StartTriggered() THEN
                Status.Action.Id :=  UINT#130;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#130,ClearResultDataTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#131,ClearResultDataTask.IsDone(), eAxoMessageCategory#Info);
            IF ClearResultDataTask.Execute(THIS) THEN
                IF _progress = 0 THEN
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 330;
                END_IF;
    
                IF _progress = 330 THEN                 // ClearResultDataTask running, reset outputs
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#530, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#530;
                    END_IF;

                    LatchAndErrorClearControl.ResultDataLatch               :=  FALSE;
                    LatchAndErrorClearControl.ErrorClear                    :=  FALSE;
                    OperationInstructionControl.ReadRequest                 :=  FALSE;
                    OperationInstructionControl.PresetRequest               :=  FALSE;
                    OperationInstructionControl.RegisterPresetDataRequest	:=  FALSE;
                    OperationInstructionControl.TuneRequest	                :=  FALSE;
                    CompletionClearControl.ReadCompleteClear	            :=  FALSE;
                    CompletionClearControl.PresetCompleteClear	            :=  FALSE;
                    CompletionClearControl.RegisterPresetDataCompleteClear	:=  FALSE;
                    CompletionClearControl.TuneCompleteClear	            :=  FALSE;
                    CompletionClearControl.EXT_RequestCompleteClear	        :=  FALSE;
                    ParameterBankNumber.BankNumberRegister	                :=  UINT#0;
                    User.UserDataSize                                       :=  UINT#0;

                    _prevResultDataReadyCount                               :=  UINT#0;
                    _prevResultDataUpdateCount                              :=  UINT#0;
                    _resultString                                           :=  '';
                    ReadData.ResultDataSize                                 :=  UINT#0;	

                    FOR _index := 0 TO 245 DO
                        ResultData.Data[_index] := BYTE#0;
                    END_FOR;
                    THIS.CallTimers(FALSE);
                    _progress := 331;
                END_IF;
    
                IF _progress = 331 THEN                 // ClearResultDataTask running, clear error flag
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#531, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#531;
                    END_IF;
    
                    LatchAndErrorClearControl.ErrorClear := HandshakeAndGeneralErrorStatus.Error;
                    IF NOT HandshakeAndGeneralErrorStatus.Error THEN
                        LatchAndErrorClearControl.ErrorClear := FALSE;
                        THIS.CallTimers(FALSE);
                        _progress := 332;
                    END_IF;
                END_IF;
                
                IF _progress = 332 THEN                 // ClearResultDataTask running, clear read complete flag
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#532, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#532;
                    END_IF;
    
                    CompletionClearControl.ReadCompleteClear := CompletionStatus.ReadComplete;
                    IF NOT CompletionStatus.ReadComplete THEN
                        CompletionClearControl.ReadCompleteClear := FALSE;
                        THIS.CallTimers(FALSE);
                        _progress := 333;
                    END_IF;
                END_IF;

                IF _progress = 333 THEN                 //ClearResultDataTask running, clear preset complete flag
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#533, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#533;
                    END_IF;
    
                    CompletionClearControl.PresetCompleteClear := CompletionStatus.PresetComplete;
                    IF NOT CompletionStatus.PresetComplete THEN
                        CompletionClearControl.PresetCompleteClear := FALSE;
                        THIS.CallTimers(FALSE);
                        _progress := 334;
                    END_IF;
                END_IF;
                
                IF _progress = 334 THEN                 // ClearResultDataTask running, clear register preset data complete flag
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#534, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#534;
                    END_IF;
    
                    CompletionClearControl.RegisterPresetDataCompleteClear := CompletionStatus.RegisterPresetDataComplete;
                    IF NOT CompletionStatus.RegisterPresetDataComplete THEN
                        CompletionClearControl.RegisterPresetDataCompleteClear := FALSE;
                        THIS.CallTimers(FALSE);
                        _progress := 335;
                    END_IF;
                END_IF;
                
                IF _progress = 335 THEN                 // ClearResultDataTask running, clear tune complete flag
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#535, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#535;
                    END_IF;
    
                    CompletionClearControl.TuneCompleteClear := CompletionStatus.TuneComplete;
                    IF NOT CompletionStatus.TuneComplete THEN
                        CompletionClearControl.TuneCompleteClear := FALSE;
                        THIS.CallTimers(FALSE);
                        _progress := 336;
                    END_IF;
                END_IF;
                
                IF _progress = 336 THEN                 // ClearResultDataTask running, clear external request complete flag
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#536, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#536;
                    END_IF;
    
                    CompletionClearControl.EXT_RequestCompleteClear := CompletionStatus.EXT_RequestComplete;
                    IF NOT CompletionStatus.EXT_RequestComplete THEN
                        CompletionClearControl.EXT_RequestCompleteClear := FALSE;
                        THIS.CallTimers(FALSE);
                        _progress := 337;
                    END_IF;
                END_IF;
                
                IF _progress = 337 THEN                 // ClearResultDataTask running, waiting for general error flag is reseted
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#537, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#537;
                    END_IF;
    
                    IF NOT HandshakeAndGeneralErrorStatus.GeneralError THEN
                        THIS.CallTimers(FALSE);
                        _progress := 338;
                    END_IF;
                END_IF;
                
                IF _progress = 338 THEN                 // ClearResultDataTask running, 
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#538, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#538;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 339;
                    END_IF;
                END_IF;
                
                IF _progress = 339 THEN                  // ClearResultDataTask finished
                    ClearResultDataTask.DoneWhen(TRUE);
                    _progress := 0;
                END_IF;
    
                THIS.CallTimers(TRUE);
                
                ClearResultDataTask.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);  
            END_IF;
            IF ClearResultDataTask.DoneReached() THEN
                Status.Action.Id :=  UINT#131;
                Status.Error.Id :=  UINT#0;
            ELSIF ClearResultDataTask.ErrorOccured() THEN
                Status.Action.Id :=  UINT#10030;
                Status.Error.Id  :=  UINT#10030;
            ELSIF ClearResultDataTask.AbortTriggered()THEN
                Status.Action.Id :=  UINT#10031;
                Status.Error.Id  :=  UINT#10031;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#10030,ClearResultDataTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#10031,ClearResultDataTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#132,ClearResultDataTask.RestoreTriggered() , eAxoMessageCategory#Error);
            IF ClearResultDataTask.RestoreTriggered() AND _progress >= 330 AND _progress <= 339  THEN
                Status.Action.Id :=  UINT#132;
                _progress := 0;
            END_IF;
            //******************************************

            //*************ReadTask*********************
            ReadTask.IsDisabled :=  RestoreTask.IsBusy() OR ClearResultDataTask.IsBusy() OR TuneTask.IsBusy();
            IF ReadTask.StartTriggered() THEN
                Status.Action.Id :=  UINT#180;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#180,ReadTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#181,ReadTask.IsDone(), eAxoMessageCategory#Info);
            IF ReadTask.Execute(THIS) THEN
                IF _progress = 0 THEN
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 380;
                END_IF;
    
                IF _progress = 380 THEN             // ReadTask running, reset outputs
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#580, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#580;
                    END_IF;

                    LatchAndErrorClearControl.ResultDataLatch               :=  FALSE;
                    LatchAndErrorClearControl.ErrorClear                    :=  FALSE;
                    OperationInstructionControl.ReadRequest                 :=  FALSE;
                    OperationInstructionControl.PresetRequest               :=  FALSE;
                    OperationInstructionControl.RegisterPresetDataRequest	:=  FALSE;
                    OperationInstructionControl.TuneRequest	                :=  FALSE;
                    CompletionClearControl.ReadCompleteClear	            :=  FALSE;
                    CompletionClearControl.PresetCompleteClear	            :=  FALSE;
                    CompletionClearControl.RegisterPresetDataCompleteClear	:=  FALSE;
                    CompletionClearControl.TuneCompleteClear	            :=  FALSE;
                    CompletionClearControl.EXT_RequestCompleteClear	        :=  FALSE;
                    ParameterBankNumber.BankNumberRegister	                :=  UINT#0;
                    User.UserDataSize                                       :=  UINT#0;

                    _prevResultDataReadyCount                               :=  UINT#0;
                    _prevResultDataUpdateCount                              :=  UINT#0;
                    _resultString                                           :=  '';
                    ReadData.ResultDataSize                                 :=  UINT#0;	

                    FOR _index := 0 TO 245 DO
                        ResultData.Data[_index] := BYTE#0;
                    END_FOR;
                    THIS.CallTimers(FALSE);
                    _progress := 381;
                END_IF;
    
                IF _progress = 381 THEN             // ReadTask running, clear error flag
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#581, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#581;
                    END_IF;
    
                    LatchAndErrorClearControl.ErrorClear := HandshakeAndGeneralErrorStatus.Error;
                    IF NOT HandshakeAndGeneralErrorStatus.Error THEN
                        LatchAndErrorClearControl.ErrorClear := FALSE;
                        THIS.CallTimers(FALSE);
                        _progress := 382;
                    END_IF;
                END_IF;
                
                IF _progress = 382 THEN             // ReadTask running, clear read complete flag
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#582, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#582;
                    END_IF;
    
                    CompletionClearControl.ReadCompleteClear := CompletionStatus.ReadComplete;
                    IF NOT CompletionStatus.ReadComplete THEN
                        CompletionClearControl.ReadCompleteClear := FALSE;
                        THIS.CallTimers(FALSE);
                        _progress := 383;
                    END_IF;
                END_IF;
                
                IF _progress = 383 THEN             // ReadTask running, clear preset complete flag
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#583, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#583;
                    END_IF;
    
                    CompletionClearControl.PresetCompleteClear := CompletionStatus.PresetComplete;
                    IF NOT CompletionStatus.PresetComplete THEN
                        CompletionClearControl.PresetCompleteClear := FALSE;
                        THIS.CallTimers(FALSE);
                        _progress := 384;
                    END_IF;
                END_IF;                

                IF _progress = 384 THEN             // ReadTask running, clear register preset data complete flag
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#584, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#584;
                    END_IF;
    
                    CompletionClearControl.RegisterPresetDataCompleteClear := CompletionStatus.RegisterPresetDataComplete;
                    IF NOT CompletionStatus.RegisterPresetDataComplete THEN
                        CompletionClearControl.RegisterPresetDataCompleteClear := FALSE;
                        THIS.CallTimers(FALSE);
                        _progress := 385;
                    END_IF;
                END_IF;
                
                IF _progress = 385 THEN             // ReadTask running, clear tune complete flag
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#585, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#585;
                    END_IF;
    
                    CompletionClearControl.TuneCompleteClear := CompletionStatus.TuneComplete;
                    IF NOT CompletionStatus.TuneComplete THEN
                        CompletionClearControl.TuneCompleteClear := FALSE;
                        THIS.CallTimers(FALSE);
                        _progress := 386;
                    END_IF;
                END_IF;

                IF _progress = 386 THEN             // ReadTask running, clear external request complete flag
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#586, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#586;
                    END_IF;
    
                    CompletionClearControl.EXT_RequestCompleteClear := CompletionStatus.EXT_RequestComplete;
                    IF NOT CompletionStatus.EXT_RequestComplete THEN
                        CompletionClearControl.EXT_RequestCompleteClear := FALSE;
                        THIS.CallTimers(FALSE);
                        _progress := 387;
                    END_IF;
                END_IF;
                
                IF _progress = 387 THEN             // ReadTask running, waiting for general error flag is reseted
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#587, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#587;
                    END_IF;
    
                    IF NOT HandshakeAndGeneralErrorStatus.GeneralError THEN
                        THIS.CallTimers(FALSE);
                        _progress := 388;
                    END_IF;
                END_IF;
                               
                IF _progress = 388 THEN             // ReadTask running, setting bank number
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#588, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#588;
                    END_IF;
    
                    IF _Bank>=UINT#0 AND _Bank <=UINT#10 THEN
                        ParameterBankNumber.BankNumberRegister := _Bank;
                        THIS.CallTimers(FALSE);
                        _progress := 389;
                    END_IF;
                END_IF;
             
                IF _progress = 389 THEN             // ReadTask running, starting trigger
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#589, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#589;
                    END_IF;
    
                    OperationInstructionControl.ReadRequest := TRUE;
                    IF CompletionStatus.ReadComplete THEN
                        OperationInstructionControl.ReadRequest := FALSE;
                        THIS.CallTimers(FALSE);
                        IF NOT ErrorStatus.ReadFailure THEN
                            THIS.CallTimers(FALSE);
                            _progress := 390;
                        ELSE
                            ReadTask.ThrowWhen(TRUE,'ErrorStatus.ReadFailure');
                        END_IF;
                    END_IF;
                END_IF;
    
                IF _progress = 390 THEN             // ReadTask running, waiting for data
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#590, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#590;
                    END_IF;
    
                    IF  ReadData.ResultDataReadyCount >_prevResultDataReadyCount THEN
                        THIS.CallTimers(FALSE);
                        _progress := 391;
                    END_IF;
                END_IF;
    
                IF _progress = 391 THEN             // ReadTask running, acknowledging results
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#591, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#591;
                    END_IF;

                    CompletionClearControl.ReadCompleteClear := TRUE;
                    IF NOT CompletionStatus.ReadComplete THEN
                        CompletionClearControl.ReadCompleteClear := FALSE;
                        _progress := 392;
                    END_IF;
                END_IF;
                
                IF _progress = 392 THEN             // ReadTask running, 
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#592, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#592;
                    END_IF;
    
                    IF TRUE THEN
                        _progress := 393;
                    END_IF;
                END_IF;
                
                IF _progress = 393 THEN             // ReadTask running, 
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#593, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#593;
                    END_IF;
    
                    IF TRUE THEN
                        _progress := 394;
                    END_IF;
                END_IF;
                
                IF _progress = 394 THEN             // ReadTask running, 
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#594, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#594;
                    END_IF;
    
                    IF TRUE THEN
                        _progress := 395;
                    END_IF;
                END_IF;
                
                IF _progress = 395 THEN             // ReadTask running, 
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#595, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#595;
                    END_IF;
    
                    IF TRUE THEN
                        _progress := 396;
                    END_IF;
                END_IF;
                
                IF _progress = 396 THEN             // ReadTask running, 
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#596, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#596;
                    END_IF;
    
                    IF TRUE THEN
                        _progress := 397;
                    END_IF;
                END_IF;
                
                IF _progress = 397 THEN             // ReadTask running, 
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#597, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#597;
                    END_IF;
    
                    IF TRUE THEN
                        _progress := 398;
                    END_IF;
                END_IF;
                
                IF _progress = 398 THEN             // ReadTask running, 
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#598, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#598;
                    END_IF;
    
                    IF TRUE THEN
                        _progress := 399;
                    END_IF;
                END_IF;
                
                IF _progress = 399 THEN             // ReadTask finished 
                    ReadTask.DoneWhen(TRUE);
                    _progress := 0;
                END_IF;
    
                THIS.CallTimers(TRUE);
                
                ReadTask.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);  
            END_IF;
            IF ReadTask.DoneReached() THEN
                Status.Action.Id :=  UINT#181;
                Status.Error.Id :=  UINT#0;
            ELSIF ReadTask.ErrorOccured() THEN
                Status.Action.Id :=  UINT#10080;
                Status.Error.Id  :=  UINT#10080;
            ELSIF ReadTask.AbortTriggered()THEN
                Status.Action.Id :=  UINT#10081;
                Status.Error.Id  :=  UINT#10081;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#10080,ReadTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#10081,ReadTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#182,ReadTask.RestoreTriggered() , eAxoMessageCategory#Error);
            IF ReadTask.RestoreTriggered() AND _progress >= 380 AND _progress <= 399  THEN
                Status.Action.Id :=  UINT#182;
                _progress := 0;
            END_IF;
            //******************************************

            //*************TuneTask*********************
            TuneTask.SetIsDisabled(FALSE);
            IF TuneTask.StartTriggered() THEN
                Status.Action.Id :=  UINT#200;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#200,TuneTask.IsBusy(), eAxoMessageCategory#Info);
            Messenger.ActivateOnCondition(ULINT#201,TuneTask.IsDone(), eAxoMessageCategory#Info);
            IF TuneTask.Execute(THIS) THEN
                IF _progress = 0 THEN               // TuneTask started
                    Status.Error.Id := UINT#0;
                    TaskMessenger.Restore();
                    THIS.CallTimers(FALSE);
                    _progress := 400;
                END_IF;
    
                IF _progress = 400 THEN             // TuneTask running, reset outputs
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#600, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#600;
                    END_IF;
    
                    LatchAndErrorClearControl.ResultDataLatch               :=  FALSE;
                    LatchAndErrorClearControl.ErrorClear                    :=  FALSE;
                    OperationInstructionControl.ReadRequest                 :=  FALSE;
                    OperationInstructionControl.PresetRequest               :=  FALSE;
                    OperationInstructionControl.RegisterPresetDataRequest	:=  FALSE;
                    OperationInstructionControl.TuneRequest	                :=  FALSE;
                    CompletionClearControl.ReadCompleteClear	            :=  FALSE;
                    CompletionClearControl.PresetCompleteClear	            :=  FALSE;
                    CompletionClearControl.RegisterPresetDataCompleteClear	:=  FALSE;
                    CompletionClearControl.TuneCompleteClear	            :=  FALSE;
                    CompletionClearControl.EXT_RequestCompleteClear	        :=  FALSE;
                    ParameterBankNumber.BankNumberRegister	                :=  UINT#0;
                    User.UserDataSize                                       :=  UINT#0;

                    _prevResultDataReadyCount                               :=  UINT#0;
                    _prevResultDataUpdateCount                              :=  UINT#0;
                    _resultString                                           :=  '';
                    ReadData.ResultDataSize                                 :=  UINT#0;	

                    FOR _index := 0 TO 245 DO
                        ResultData.Data[_index] := BYTE#0;
                    END_FOR;
                    THIS.CallTimers(FALSE);
                    _progress := 401;
                END_IF;
    
                IF _progress = 401 THEN             // TuneTask running, clear error flag
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#601, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#601;
                    END_IF;
    
                    LatchAndErrorClearControl.ErrorClear := HandshakeAndGeneralErrorStatus.Error;
                    IF NOT HandshakeAndGeneralErrorStatus.Error THEN
                        LatchAndErrorClearControl.ErrorClear := FALSE;
                        THIS.CallTimers(FALSE);
                        _progress := 402;
                    END_IF;
                END_IF;
                
                IF _progress = 402 THEN             // TuneTask running, clear read complete flag
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#602, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#602;
                    END_IF;
    
                    CompletionClearControl.ReadCompleteClear := CompletionStatus.ReadComplete;
                    IF NOT CompletionStatus.ReadComplete THEN
                        CompletionClearControl.ReadCompleteClear := FALSE;
                        THIS.CallTimers(FALSE);
                        _progress := 403;
                    END_IF;
                END_IF;
                
                IF _progress = 403 THEN             // TuneTask running, clear preset complete flag
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#603, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#603;
                    END_IF;

                    CompletionClearControl.PresetCompleteClear := CompletionStatus.PresetComplete;
                    IF NOT CompletionStatus.PresetComplete THEN
                        CompletionClearControl.PresetCompleteClear := FALSE;
                        THIS.CallTimers(FALSE);
                        _progress := 404;
                    END_IF;
                END_IF;
                
                IF _progress = 404 THEN             // TuneTask running, clear register preset data complete flag
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#604, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#604;
                    END_IF;
    
                    CompletionClearControl.RegisterPresetDataCompleteClear := CompletionStatus.RegisterPresetDataComplete;
                    IF NOT CompletionStatus.RegisterPresetDataComplete THEN
                        CompletionClearControl.RegisterPresetDataCompleteClear := FALSE;
                        THIS.CallTimers(FALSE);
                        _progress := 405;
                    END_IF;
                END_IF;
                
                IF _progress = 405 THEN             // TuneTask running, clear tune complete flag
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#605, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#605;
                    END_IF;
    
                    CompletionClearControl.TuneCompleteClear := CompletionStatus.TuneComplete;
                    IF NOT CompletionStatus.TuneComplete THEN
                        CompletionClearControl.TuneCompleteClear := FALSE;
                        THIS.CallTimers(FALSE);
                        _progress := 406;
                    END_IF;
                END_IF;
                
                IF _progress = 406 THEN             // TuneTask running, clear external request complete flag
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#606, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#606;
                    END_IF;
    
                    CompletionClearControl.EXT_RequestCompleteClear := CompletionStatus.EXT_RequestComplete;
                    IF NOT CompletionStatus.EXT_RequestComplete THEN
                        CompletionClearControl.EXT_RequestCompleteClear := FALSE;
                        THIS.CallTimers(FALSE);
                        _progress := 407;
                    END_IF;
                END_IF;
                
                IF _progress = 407 THEN             // TuneTask running, waiting for general error flag is reseted
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#607, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#607;
                    END_IF;
    
                    IF NOT HandshakeAndGeneralErrorStatus.GeneralError THEN
                        THIS.CallTimers(FALSE);
                        _progress := 408;
                    END_IF;
                END_IF;
                
                IF _progress = 408 THEN             // TuneTask running, setting bank number
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#608, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#608;
                    END_IF;
    
                    IF _Bank>=UINT#0 AND _Bank <=UINT#10 THEN
                        ParameterBankNumber.BankNumberRegister := _Bank;
                        THIS.CallTimers(FALSE);
                        _progress := 409;
                    END_IF;
                END_IF;
                
                IF _progress = 409 THEN             // TuneTask running, starting tune process
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#609, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#609;
                    END_IF;
    
                    OperationInstructionControl.TuneRequest := TRUE;
                    IF CompletionStatus.TuneComplete THEN
                        OperationInstructionControl.TuneRequest := FALSE;
                        THIS.CallTimers(FALSE);
                        IF NOT ErrorStatus.TuneFailure THEN
                            _progress := 410;
                        ELSE
                            TuneTask.ThrowWhen(TRUE,'ErrorStatus.TuneFailure');
                        END_IF;
                    END_IF;
                END_IF;
    
                IF _progress = 410 THEN             // TuneTask running, acknowledging tunning process
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#610, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#610;
                    END_IF;
    
                    CompletionClearControl.TuneCompleteClear := TRUE;
                    IF NOT CompletionStatus.TuneComplete THEN
                        CompletionClearControl.TuneCompleteClear := FALSE;
                        _progress := 411;
                    END_IF;
                END_IF;
    
                IF _progress = 411 THEN             // TuneTask running, 
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#611, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#611;
                    END_IF;
    
                    IF TRUE THEN
                        _progress := 412;
                    END_IF;
                END_IF;
                
                IF _progress = 412 THEN             // TuneTask running, 
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#612, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#612;
                    END_IF;
    
                    IF TRUE THEN
                        _progress := 413;
                    END_IF;
                END_IF;
                
                IF _progress = 413 THEN             // TuneTask running, 
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#613, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#613;
                    END_IF;
    
                    IF TRUE THEN
                        _progress := 414;
                    END_IF;
                END_IF;
                
                IF _progress = 414 THEN             // TuneTask running, 
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#614, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#614;
                    END_IF;
    
                    IF TRUE THEN
                        _progress := 415;
                    END_IF;
                END_IF;
                
                IF _progress = 415 THEN             // TuneTask running, 
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#615, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#615;
                    END_IF;
    
                    IF TRUE THEN
                        _progress := 416;
                    END_IF;
                END_IF;
                
                IF _progress = 416 THEN             // TuneTask running, 
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#616, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#616;
                    END_IF;
    
                    IF TRUE THEN
                        _progress := 417;
                    END_IF;
                END_IF;
                
                IF _progress = 417 THEN             // TuneTask running, 
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#617, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#617;
                    END_IF;
    
                    IF TRUE THEN
                        _progress := 418;
                    END_IF;
                END_IF;
                
                IF _progress = 418 THEN             // TuneTask running, 
                    IF _infoTimer.output THEN
                        TaskMessenger.Activate( UINT#618, eAxoMessageCategory#Warning);
                        Status.Error.Id :=      UINT#618;
                    END_IF;
    
                    IF TRUE THEN
                        _progress := 419;
                    END_IF;
                END_IF;
                
                IF _progress = 419 THEN             // TuneTask finished
                    TuneTask.DoneWhen(TRUE);
                    _progress := 0;
                END_IF;
    
                THIS.CallTimers(TRUE);
                
                TuneTask.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);  
            END_IF;
            IF TuneTask.DoneReached() THEN
                Status.Action.Id :=  UINT#201;
                Status.Error.Id :=  UINT#0;
            ELSIF TuneTask.ErrorOccured() THEN
                Status.Action.Id :=  UINT#10100;
                Status.Error.Id  :=  UINT#10100;
            ELSIF TuneTask.AbortTriggered()THEN
                Status.Action.Id :=  UINT#10101;
                Status.Error.Id  :=  UINT#10101;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#10100,TuneTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#10101,TuneTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#202,TuneTask.RestoreTriggered() , eAxoMessageCategory#Error);
            IF TuneTask.RestoreTriggered() AND _progress >= 400 AND _progress <= 419  THEN
                Status.Action.Id :=  UINT#202;
                _progress := 0;
            END_IF;
            //******************************************

            //****************Update outputs*****************
            _data_1[0].%X1                  :=      LatchAndErrorClearControl.ResultDataLatch;
            _data_1[0].%X7                  :=      LatchAndErrorClearControl.ErrorClear;

            _retVal := Siemens.Simatic.S71500.DistributedIO.WriteData(_hwIdLatchAndErrorClearControl,_data_1);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1231, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1231;
                RETURN;
            END_IF;

            _data_1[0].%X0                  :=      OperationInstructionControl.ReadRequest;
            _data_1[0].%X1                  :=      OperationInstructionControl.PresetRequest;
            _data_1[0].%X2                  :=      OperationInstructionControl.RegisterPresetDataRequest;
            _data_1[0].%X3                  :=      OperationInstructionControl.TuneRequest;

            _retVal := Siemens.Simatic.S71500.DistributedIO.WriteData(_hwIdOperationInstructionControl,_data_1);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1232, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1232;
                RETURN;
            END_IF;

            _data_1[0].%X0                  :=      CompletionClearControl.ReadCompleteClear;
            _data_1[0].%X1                  :=      CompletionClearControl.PresetCompleteClear;
            _data_1[0].%X2                  :=      CompletionClearControl.RegisterPresetDataCompleteClear;
            _data_1[0].%X3                  :=      CompletionClearControl.TuneCompleteClear;
            _data_1[0].%X7                  :=      CompletionClearControl.EXT_RequestCompleteClear;

            _retVal := Siemens.Simatic.S71500.DistributedIO.WriteData(_hwIdCompletionClearControl,_data_1);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1233, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1233;
                RETURN;
            END_IF;

            _data_2[1]                      :=      TO_WORD(ParameterBankNumber.BankNumberRegister).%B0;
            _data_2[0]                      :=      TO_WORD(ParameterBankNumber.BankNumberRegister).%B1;

            _retVal := Siemens.Simatic.S71500.DistributedIO.WriteData(_hwIdParameterBankNumber,_data_2);
            IF _retVal > WORD#0 THEN
                Messenger.Activate(UINT#1234, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1234;
                RETURN;
            END_IF;
            

            _invalidDataSize := NOT (_UserDataSize = eAxo_SR_1000_UserDataSize#USER_DATA_32B OR
                                     _UserDataSize = eAxo_SR_1000_UserDataSize#USER_DATA_64B OR
                                     _UserDataSize = eAxo_SR_1000_UserDataSize#USER_DATA_128B OR
                                     _UserDataSize = eAxo_SR_1000_UserDataSize#USER_DATA_252B);

            IF _invalidDataSize THEN
                Messenger.Activate(UINT#1235, eAxoMessageCategory#ProgrammingError);
                Status.Error.Id := UINT#1235;
                RETURN;
            END_IF;

            Config.UserDataSize := _UserDataSize;

            IF (UserData.DataChanged <> _UserDataChanged) THEN
                IF Config.UserDataSize = eAxo_SR_1000_UserDataSize#USER_DATA_32B THEN
                    _data_34[1] := TO_WORD(User.UserDataSize).%B0;
                    _data_34[0] := TO_WORD(User.UserDataSize).%B1;
                    FOR _index := 2 TO 33 DO
                        _data_34[_index] := UserData.Data[_index];
                    END_FOR;
                    _retVal := Siemens.Simatic.S71500.DistributedIO.WriteData(_hwIdUserData ,_data_34);
                    IF _retVal > WORD#0 THEN
                        Messenger.Activate(UINT#1236, eAxoMessageCategory#ProgrammingError);
                        Status.Error.Id := UINT#1236;
                        RETURN;
                    END_IF;
                ELSIF Config.UserDataSize = eAxo_SR_1000_UserDataSize#USER_DATA_64B THEN
                    _data_66[1] := TO_WORD(User.UserDataSize).%B0;
                    _data_66[0] := TO_WORD(User.UserDataSize).%B1;
                    FOR _index := 2 TO 65 DO
                        _data_66[_index] := UserData.Data[_index];
                    END_FOR;
                    _retVal := Siemens.Simatic.S71500.DistributedIO.WriteData(_hwIdUserData ,_data_66);
                    IF _retVal > WORD#0 THEN
                        Messenger.Activate(UINT#1237, eAxoMessageCategory#ProgrammingError);
                        Status.Error.Id := UINT#1237;
                        RETURN;
                    END_IF;
                ELSIF Config.UserDataSize = eAxo_SR_1000_UserDataSize#USER_DATA_128B THEN
                    _data_130[1] := TO_WORD(User.UserDataSize).%B0;
                    _data_130[0] := TO_WORD(User.UserDataSize).%B1;
                    FOR _index := 2 TO 129 DO
                        _data_130[_index] := UserData.Data[_index];
                    END_FOR;
                    _retVal := Siemens.Simatic.S71500.DistributedIO.WriteData(_hwIdUserData ,_data_130);
                    IF _retVal > WORD#0 THEN
                        Messenger.Activate(UINT#1238, eAxoMessageCategory#ProgrammingError);
                        Status.Error.Id := UINT#1238;
                        RETURN;
                    END_IF;
                ELSIF Config.UserDataSize = eAxo_SR_1000_UserDataSize#USER_DATA_252B THEN
                    _data_254[1] := TO_WORD(User.UserDataSize).%B0;
                    _data_254[0] := TO_WORD(User.UserDataSize).%B1;
                    FOR _index := 2 TO 253 DO
                        _data_254[_index] := UserData.Data[_index];
                    END_FOR;
                    _retVal := Siemens.Simatic.S71500.DistributedIO.WriteData(_hwIdUserData ,_data_254);
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
            VAR_INPUT 
                inBank : UINT;
            END_VAR
            VAR_OUTPUT
                result : ARRAY [0..245] OF BYTE;
            END_VAR
            _Bank := inBank;
            result := ResultData.Data;
            Read := ReadTask.Invoke(THIS);
        END_METHOD
        
        ///<summary>
		/// Triggers the reading sequence and waits for results. 	
        ///</summary>       
        METHOD PUBLIC Tune : IAxoTaskState
            VAR_INPUT 
                inBank : UINT;
            END_VAR
            _Bank := inBank;
            Tune := TuneTask.Invoke(THIS);
        END_METHOD

        ///<summary>
		/// Triggers the reading sequence and waits for results. 	
        ///</summary>       
        METHOD PUBLIC Read : IAxoTaskState
            VAR_OUTPUT
                result : ARRAY [0..245] OF BYTE;
            END_VAR
            _Bank := UINT#0;
            result := ResultData.Data;
            Read := ReadTask.Invoke(THIS);
        END_METHOD

        METHOD PRIVATE CallTimers
            VAR_INPUT
                signal : BOOL;
            END_VAR
            
            _infoTimer.OnDelay(THIS, signal AND Config.InfoTime > LT#0S ,Config.InfoTime);
            _errorTimer.OnDelay(THIS, signal AND Config.ErrorTime > LT#0S , Config.ErrorTime);
        END_METHOD
  
        METHOD PRIVATE ContinuousReading //TODO 
            VAR 
                _index : INT;
            END_VAR
            // IF ResultsStatus.ResultsAvailable AND NOT ResultsControl.ResultsAcknowledge AND Results.Code > UINT#0 AND Results.Length > UINT#0 THEN
            //     Messenger.ActivateOnCondition(ULINT#820, Results.Length > TO_UINT(Config.ResultDataSize), eAxoMessageCategory#Error);
            //     TaskMessenger.ActivateOnCondition(ULINT#713, Results.Length > TO_UINT(Config.ResultDataSize), eAxoMessageCategory#Error);
            //     IF Results.Length > TO_UINT(Config.ResultDataSize) THEN
            //         Status.Action.Id := UINT#820;
            //         Status.Error.Id := UINT#713;
            //     ELSE
            //         FOR _index := 0 TO (TO_INT(Results.Length) - INT#1) DO
            //             ResultData.Data[_index] := _data_in[_index + 8];
            //         END_FOR;
            //         FOR _index := TO_INT(Results.Length) TO 245 DO
            //             ResultData.Data[_index] := BYTE#0;
            //         END_FOR;
            //         ResultData.DataChanged := NOT ResultData.DataChanged ;
            //         Status.Action.Id := UINT#120;
            //     END_IF;
            // END_IF;

            // ResultsControl.ResultsAcknowledge := ResultsStatus.ResultsAvailable;
            ;
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
            TuneTask.Restore();

            LatchAndErrorClearControl.ResultDataLatch               :=  FALSE;
            LatchAndErrorClearControl.ErrorClear                    :=  FALSE;
            OperationInstructionControl.ReadRequest                 :=  FALSE;
            OperationInstructionControl.PresetRequest               :=  FALSE;
            OperationInstructionControl.RegisterPresetDataRequest	:=  FALSE;
            OperationInstructionControl.TuneRequest	                :=  FALSE;
            CompletionClearControl.ReadCompleteClear	            :=  FALSE;
            CompletionClearControl.PresetCompleteClear	            :=  FALSE;
            CompletionClearControl.RegisterPresetDataCompleteClear	:=  FALSE;
            CompletionClearControl.TuneCompleteClear	            :=  FALSE;
            CompletionClearControl.EXT_RequestCompleteClear	        :=  FALSE;
            ParameterBankNumber.BankNumberRegister	                :=  UINT#0;
            User.UserDataSize                                       :=  UINT#0;

            _prevResultDataReadyCount                               :=  UINT#0;
            _prevResultDataUpdateCount                              :=  UINT#0;
            _resultString                                           :=  '';
            ReadData.ResultDataSize                                 :=  UINT#0;	

            FOR _index := 0 TO 245 DO
                ResultData.Data[_index] := BYTE#0;
            END_FOR;

            IF NOT HandshakeAndGeneralErrorStatus.GeneralError THEN
                Status.Action.Id := UINT#50;
                RestoreTask.DoneWhen(TRUE);
            END_IF;
        END_METHOD
    END_CLASS    
END_NAMESPACE
