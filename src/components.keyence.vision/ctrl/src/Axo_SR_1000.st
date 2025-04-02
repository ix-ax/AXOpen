USING AXOpen.Messaging.Static;
USING AXOpen.Messaging;
USING AXOpen.Core;
USING AXOpen.Components.Abstractions;

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
            _returnValue                                        :   WORD;
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
                ResultDataSize                                  :   eAxo_SR_1000_ResultDataSize;
                UserDataSize                                    :   eAxo_SR_1000_UserDataSize;
                hwID                                            :   WORD;
                hwIdHandshakeAndGeneralErrorStatus              :   WORD;
                hwIdBUSY_Status                                 :   WORD;
                hwIdCompletionStatus                            :   WORD;
                hwIdErrorStatus                                 :   WORD;
                hwIdTerminalStatus                              :   WORD;
                hwIdUnstableReadStatus                          :   WORD;
                hwIdMatchingLevelAndTotalEvaluationGradeStatus  :   WORD;
                hwIdOperationalResultStatus                     :   WORD;
                hwIdReadData                                    :   WORD;
                hwIdLatchAndErrorClearControl                   :   WORD;
                hwIdOperationInstructionControl                 :   WORD;
                hwIdCompletionClearControl                      :   WORD;
                hwIdParameterBankNumber                         :   WORD;
                hwIdUserData                                    :   WORD;
            END_VAR
        
            VAR
                _index                   :   INT;
            END_VAR

            SUPER.Run(parent);

            Messenger.Serve(THIS);

            Messenger.ActivateOnCondition(ULINT#700,parent = NULL, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#701,hwID = WORD#0, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#702,hwIdHandshakeAndGeneralErrorStatus = WORD#0, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#703,hwIdBUSY_Status = WORD#0, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#704,hwIdCompletionStatus = WORD#0, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#705,hwIdErrorStatus = WORD#0, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#706,hwIdTerminalStatus = WORD#0, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#707,hwIdUnstableReadStatus = WORD#0, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#708,hwIdMatchingLevelAndTotalEvaluationGradeStatus = WORD#0, eAxoMessageCategory#ProgrammingError);            
            Messenger.ActivateOnCondition(ULINT#709,hwIdOperationalResultStatus = WORD#0, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#710,hwIdReadData = WORD#0, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#711,hwIdLatchAndErrorClearControl = WORD#0, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#712,hwIdCompletionClearControl = WORD#0, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#713,hwIdCompletionClearControl = WORD#0, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#714,hwIdParameterBankNumber = WORD#0, eAxoMessageCategory#ProgrammingError);
            Messenger.ActivateOnCondition(ULINT#715,hwIdUserData = WORD#0, eAxoMessageCategory#ProgrammingError);            

            IF parent = NULL THEN
                Status.Error.Id := UINT#700;
                RETURN;
            ELSIF hwID = WORD#0 THEN
                Status.Error.Id := UINT#701;
                RETURN;
            ELSIF hwIdHandshakeAndGeneralErrorStatus = WORD#0 THEN
                Status.Error.Id := UINT#702;
                RETURN;
            ELSIF hwIdBUSY_Status = WORD#0 THEN
                Status.Error.Id := UINT#703;
                RETURN;
            ELSIF hwIdCompletionStatus = WORD#0 THEN
                Status.Error.Id := UINT#704;
                RETURN;
            ELSIF hwIdErrorStatus = WORD#0 THEN
                Status.Error.Id := UINT#705;
                RETURN;
            ELSIF hwIdTerminalStatus = WORD#0 THEN
                Status.Error.Id := UINT#706;
                RETURN;
            ELSIF hwIdUnstableReadStatus = WORD#0 THEN
                Status.Error.Id := UINT#707;
                RETURN;
            ELSIF hwIdMatchingLevelAndTotalEvaluationGradeStatus = WORD#0 THEN
                Status.Error.Id := UINT#708;
                RETURN;
            ELSIF hwIdOperationalResultStatus = WORD#0 THEN
                Status.Error.Id := UINT#709;
                RETURN;
            ELSIF hwIdReadData = WORD#0 THEN
                Status.Error.Id := UINT#710;
                RETURN;
            ELSIF hwIdLatchAndErrorClearControl = WORD#0 THEN
                Status.Error.Id := UINT#711;
                RETURN;
            ELSIF hwIdCompletionClearControl = WORD#0 THEN
                Status.Error.Id := UINT#712;
                RETURN;
            ELSIF hwIdCompletionClearControl = WORD#0 THEN
                Status.Error.Id := UINT#713;
                RETURN;
            ELSIF hwIdParameterBankNumber = WORD#0 THEN
                Status.Error.Id := UINT#714;
                RETURN;                
            ELSIF hwIdUserData = WORD#0 THEN
                Status.Error.Id := UINT#715;
                RETURN;                          
            END_IF;

            _hwID                                               :=  hwID;
            _ResultDataSize                                     :=  ResultDataSize;  
            _UserDataSize                                       :=  UserDataSize;    
            _hwIdHandshakeAndGeneralErrorStatus                 :=  hwIdHandshakeAndGeneralErrorStatus;
            _hwIdBUSY_Status                                    :=  hwIdBUSY_Status;
            _hwIdCompletionStatus                               :=  hwIdCompletionStatus;
            _hwIdErrorStatus                                    :=  hwIdErrorStatus;
            _hwIdTerminalStatus                                 :=  hwIdTerminalStatus;
            _hwIdUnstableReadStatus                             :=  hwIdUnstableReadStatus;
            _hwIdMatchingLevelAndTotalEvaluationGradeStatus     :=  hwIdMatchingLevelAndTotalEvaluationGradeStatus;
            _hwIdOperationalResultStatus                        :=  hwIdOperationalResultStatus;
            _hwIdReadData                                       :=  hwIdReadData;
            _hwIdLatchAndErrorClearControl                      :=  hwIdLatchAndErrorClearControl;
            _hwIdOperationInstructionControl                    :=  hwIdOperationInstructionControl;
            _hwIdCompletionClearControl                         :=  hwIdCompletionClearControl;
            _hwIdParameterBankNumber                            :=  hwIdParameterBankNumber;
            _hwIdUserData                                       :=  hwIdUserData;  

            //****************************************
            //***********Update inputs ***************
            _returnValue := Siemens.Simatic.S71500.DistributedIO.ReadData(_hwIdHandshakeAndGeneralErrorStatus ,_data_in);
            Messenger.ActivateOnCondition(ULINT#716,_returnValue > WORD#0, eAxoMessageCategory#ProgrammingError);
            IF _returnValue > WORD#0 THEN
                Status.Error.Id := UINT#716;
                RETURN;
            END_IF;

            HandshakeAndGeneralErrorStatus.Error                :=      _data_in[0].%X0;
            HandshakeAndGeneralErrorStatus.ResultDataAvailable  :=      _data_in[0].%X1;
            HandshakeAndGeneralErrorStatus.ResultDataStrobe     :=      _data_in[0].%X2;
            HandshakeAndGeneralErrorStatus.BufferOverflowError  :=      _data_in[0].%X6; 
            HandshakeAndGeneralErrorStatus.GeneralError         :=      _data_in[0].%X7; 

            _returnValue := Siemens.Simatic.S71500.DistributedIO.ReadData(_hwIdBUSY_Status ,_data_in);
            Messenger.ActivateOnCondition(ULINT#717,_returnValue > WORD#0, eAxoMessageCategory#ProgrammingError);
            IF _returnValue > WORD#0 THEN
                Status.Error.Id := UINT#717;
                RETURN;
            END_IF;

            BUSY_Status.BUSY                                    :=      _data_in[0].%X0;
            BUSY_Status.TRG_BUSY                                :=      _data_in[0].%X1;
            BUSY_Status.LOCK_BUSY                               :=      _data_in[0].%X2;
            BUSY_Status.MODE_BUSY                               :=      _data_in[0].%X3;
            BUSY_Status.ERR_BUSY                                :=      _data_in[0].%X4;

            _returnValue := Siemens.Simatic.S71500.DistributedIO.ReadData(_hwIdCompletionStatus ,_data_in);
            Messenger.ActivateOnCondition(ULINT#718,_returnValue > WORD#0, eAxoMessageCategory#ProgrammingError);
            IF _returnValue > WORD#0 THEN
                Status.Error.Id := UINT#718;
                RETURN;
            END_IF;

            CompletionStatus.ReadComplete                       :=      _data_in[0].%X0;
            CompletionStatus.PresetComplete                     :=      _data_in[0].%X1;
            CompletionStatus.RegisterPresetDataComplete         :=      _data_in[0].%X2;
            CompletionStatus.TuneComplete                       :=      _data_in[0].%X3;
            CompletionStatus.EXT_RequestComplete                :=      _data_in[0].%X7;

            _returnValue := Siemens.Simatic.S71500.DistributedIO.ReadData(_hwIdErrorStatus ,_data_in);
            Messenger.ActivateOnCondition(ULINT#719,_returnValue > WORD#0, eAxoMessageCategory#ProgrammingError);
            IF _returnValue > WORD#0 THEN
                Status.Error.Id := UINT#719;
                RETURN;
            END_IF;

            ErrorStatus.ReadFailure                             :=      _data_in[0].%X0;
            ErrorStatus.PresetFailure                           :=      _data_in[0].%X1;
            ErrorStatus.RegisterPresetDataFailure               :=      _data_in[0].%X2;
            ErrorStatus.TuneFailure                             :=      _data_in[0].%X3;
            ErrorStatus.EXT_RequestFailure                      :=      _data_in[0].%X7;

            _returnValue := Siemens.Simatic.S71500.DistributedIO.ReadData( _hwIdTerminalStatus,_data_in);
            Messenger.ActivateOnCondition(ULINT#720,_returnValue > WORD#0, eAxoMessageCategory#ProgrammingError);
            IF _returnValue > WORD#0 THEN
                Status.Error.Id := UINT#720;
                RETURN;
            END_IF;

            TerminalStatus.IN1_Status                           :=      _data_in[0].%X0;
            TerminalStatus.IN2_Status                           :=      _data_in[0].%X1;
            TerminalStatus.OUT1_Status                          :=      _data_in[0].%X4;
            TerminalStatus.OUT2_Status                          :=      _data_in[0].%X5;
            TerminalStatus.OUT3_Status                          :=      _data_in[0].%X6;

            _returnValue := Siemens.Simatic.S71500.DistributedIO.ReadData( _hwIdUnstableReadStatus,_data_in);
            Messenger.ActivateOnCondition(ULINT#721,_returnValue > WORD#0, eAxoMessageCategory#ProgrammingError);
            IF _returnValue > WORD#0 THEN
                Status.Error.Id := UINT#721;
                RETURN;
            END_IF;
            
            UnstableReadStatus.Unstable                         :=      _data_in[0].%X0;
            UnstableReadStatus.MatchingLevelUnstable            :=      _data_in[0].%X1;
            UnstableReadStatus.ISO_IEC_15415_Unstable           :=      _data_in[0].%X2;
            UnstableReadStatus.ISO_IEC_TR_29158_Unstable        :=      _data_in[0].%X3;
            UnstableReadStatus.SAE_AS9132_Unstable              :=      _data_in[0].%X4;

            _returnValue := Siemens.Simatic.S71500.DistributedIO.ReadData(_hwIdMatchingLevelAndTotalEvaluationGradeStatus ,_data_in);
            Messenger.ActivateOnCondition(ULINT#722,_returnValue > WORD#0, eAxoMessageCategory#ProgrammingError);
            IF _returnValue > WORD#0 THEN
                Status.Error.Id := UINT#722;
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

            _returnValue := Siemens.Simatic.S71500.DistributedIO.ReadData( _hwIdOperationalResultStatus,_data_in);
            Messenger.ActivateOnCondition(ULINT#723,_returnValue > WORD#0, eAxoMessageCategory#ProgrammingError);
            IF _returnValue > WORD#0 THEN
                Status.Error.Id := UINT#723;
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

            _returnValue := Siemens.Simatic.S71500.DistributedIO.ReadData( _hwIdReadData,_data_in);
            Messenger.ActivateOnCondition(ULINT#724,_returnValue > WORD#0, eAxoMessageCategory#ProgrammingError);
            IF _returnValue > WORD#0 THEN
                Status.Error.Id := UINT#724;
                RETURN;
            END_IF;

            _invalidDataSize := NOT (   _ResultDataSize = eAxo_SR_1000_ResultDataSize#RESULT_DATA_32B OR
                                        _ResultDataSize = eAxo_SR_1000_ResultDataSize#RESULT_DATA_64B OR
                                        _ResultDataSize = eAxo_SR_1000_ResultDataSize#RESULT_DATA_128B OR
                                        _ResultDataSize = eAxo_SR_1000_ResultDataSize#RESULT_DATA_246B);

            Messenger.ActivateOnCondition(ULINT#725,_invalidDataSize, eAxoMessageCategory#ProgrammingError);

            IF _invalidDataSize THEN
                Status.Error.Id := UINT#725;
                RETURN;
            END_IF;

            Config.ResultDataSize := _ResultDataSize;

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
                    TaskMessenger.ActivateOnCondition(ULINT#530, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#530;
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
                    TaskMessenger.ActivateOnCondition(ULINT#531, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#531;
                    END_IF;
    
                    LatchAndErrorClearControl.ErrorClear := HandshakeAndGeneralErrorStatus.Error;
                    IF NOT HandshakeAndGeneralErrorStatus.Error THEN
                        LatchAndErrorClearControl.ErrorClear := FALSE;
                        THIS.CallTimers(FALSE);
                        _progress := 332;
                    END_IF;
                END_IF;
                
                IF _progress = 332 THEN                 // ClearResultDataTask running, clear read complete flag
                    TaskMessenger.ActivateOnCondition(ULINT#532, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#532;
                    END_IF;
    
                    CompletionClearControl.ReadCompleteClear := CompletionStatus.ReadComplete;
                    IF NOT CompletionStatus.ReadComplete THEN
                        CompletionClearControl.ReadCompleteClear := FALSE;
                        THIS.CallTimers(FALSE);
                        _progress := 333;
                    END_IF;
                END_IF;

                IF _progress = 333 THEN                 //ClearResultDataTask running, clear preset complete flag
                    TaskMessenger.ActivateOnCondition(ULINT#533, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#533;
                    END_IF;
    
                    CompletionClearControl.PresetCompleteClear := CompletionStatus.PresetComplete;
                    IF NOT CompletionStatus.PresetComplete THEN
                        CompletionClearControl.PresetCompleteClear := FALSE;
                        THIS.CallTimers(FALSE);
                        _progress := 334;
                    END_IF;
                END_IF;
                
                IF _progress = 334 THEN                 // ClearResultDataTask running, clear register preset data complete flag
                    TaskMessenger.ActivateOnCondition(ULINT#534, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#534;
                    END_IF;
    
                    CompletionClearControl.RegisterPresetDataCompleteClear := CompletionStatus.RegisterPresetDataComplete;
                    IF NOT CompletionStatus.RegisterPresetDataComplete THEN
                        CompletionClearControl.RegisterPresetDataCompleteClear := FALSE;
                        THIS.CallTimers(FALSE);
                        _progress := 335;
                    END_IF;
                END_IF;
                
                IF _progress = 335 THEN                 // ClearResultDataTask running, clear tune complete flag
                    TaskMessenger.ActivateOnCondition(ULINT#535, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#535;
                    END_IF;
    
                    CompletionClearControl.TuneCompleteClear := CompletionStatus.TuneComplete;
                    IF NOT CompletionStatus.TuneComplete THEN
                        CompletionClearControl.TuneCompleteClear := FALSE;
                        THIS.CallTimers(FALSE);
                        _progress := 336;
                    END_IF;
                END_IF;
                
                IF _progress = 336 THEN                 // ClearResultDataTask running, clear external request complete flag
                    TaskMessenger.ActivateOnCondition(ULINT#536, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#536;
                    END_IF;
    
                    CompletionClearControl.EXT_RequestCompleteClear := CompletionStatus.EXT_RequestComplete;
                    IF NOT CompletionStatus.EXT_RequestComplete THEN
                        CompletionClearControl.EXT_RequestCompleteClear := FALSE;
                        THIS.CallTimers(FALSE);
                        _progress := 337;
                    END_IF;
                END_IF;
                
                IF _progress = 337 THEN                 // ClearResultDataTask running, waiting for general error flag is reseted
                    TaskMessenger.ActivateOnCondition(ULINT#537, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#537;
                    END_IF;
    
                    IF NOT HandshakeAndGeneralErrorStatus.GeneralError THEN
                        THIS.CallTimers(FALSE);
                        _progress := 338;
                    END_IF;
                END_IF;
                
                IF _progress = 338 THEN                 // ClearResultDataTask running, 
                    TaskMessenger.ActivateOnCondition(ULINT#538, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#538;
                    END_IF;
    
                    IF TRUE THEN
                        THIS.CallTimers(FALSE);
                        _progress := 339;
                    END_IF;
                END_IF;
                
                IF _progress = 339 THEN                  // ClearResultDataTask finished
                    ClearResultDataTask.DoneWhen(TRUE);
                END_IF;
    
                THIS.CallTimers(TRUE);
                
                ClearResultDataTask.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);  
            END_IF;
            IF ClearResultDataTask.DoneReached() THEN
                Status.Action.Id :=  UINT#131;
                Status.Error.Id :=  UINT#0;
            ELSIF ClearResultDataTask.ErrorOccured() THEN
                Status.Action.Id :=  UINT#830;
                Status.Error.Id  :=  UINT#830;
            ELSIF ClearResultDataTask.AbortTriggered()THEN
                Status.Action.Id :=  UINT#831;
                Status.Error.Id  :=  UINT#831;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#830,ClearResultDataTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#831,ClearResultDataTask.IsAborted(), eAxoMessageCategory#Error);
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
                    TaskMessenger.ActivateOnCondition(ULINT#580, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#580;
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
                    TaskMessenger.ActivateOnCondition(ULINT#581, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#581;
                    END_IF;
    
                    LatchAndErrorClearControl.ErrorClear := HandshakeAndGeneralErrorStatus.Error;
                    IF NOT HandshakeAndGeneralErrorStatus.Error THEN
                        LatchAndErrorClearControl.ErrorClear := FALSE;
                        THIS.CallTimers(FALSE);
                        _progress := 382;
                    END_IF;
                END_IF;
                
                IF _progress = 382 THEN             // ReadTask running, clear read complete flag
                    TaskMessenger.ActivateOnCondition(ULINT#582, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#582;
                    END_IF;
    
                    CompletionClearControl.ReadCompleteClear := CompletionStatus.ReadComplete;
                    IF NOT CompletionStatus.ReadComplete THEN
                        CompletionClearControl.ReadCompleteClear := FALSE;
                        THIS.CallTimers(FALSE);
                        _progress := 383;
                    END_IF;
                END_IF;
                
                IF _progress = 383 THEN             // ReadTask running, clear preset complete flag
                    TaskMessenger.ActivateOnCondition(ULINT#583, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#583;
                    END_IF;
    
                    CompletionClearControl.PresetCompleteClear := CompletionStatus.PresetComplete;
                    IF NOT CompletionStatus.PresetComplete THEN
                        CompletionClearControl.PresetCompleteClear := FALSE;
                        THIS.CallTimers(FALSE);
                        _progress := 384;
                    END_IF;
                END_IF;                

                IF _progress = 384 THEN             // ReadTask running, clear register preset data complete flag
                    TaskMessenger.ActivateOnCondition(ULINT#584, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#584;
                    END_IF;
    
                    CompletionClearControl.RegisterPresetDataCompleteClear := CompletionStatus.RegisterPresetDataComplete;
                    IF NOT CompletionStatus.RegisterPresetDataComplete THEN
                        CompletionClearControl.RegisterPresetDataCompleteClear := FALSE;
                        THIS.CallTimers(FALSE);
                        _progress := 385;
                    END_IF;
                END_IF;
                
                IF _progress = 385 THEN             // ReadTask running, clear tune complete flag
                    TaskMessenger.ActivateOnCondition(ULINT#585, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#585;
                    END_IF;
    
                    CompletionClearControl.TuneCompleteClear := CompletionStatus.TuneComplete;
                    IF NOT CompletionStatus.TuneComplete THEN
                        CompletionClearControl.TuneCompleteClear := FALSE;
                        THIS.CallTimers(FALSE);
                        _progress := 386;
                    END_IF;
                END_IF;

                IF _progress = 386 THEN             // ReadTask running, clear external request complete flag
                    TaskMessenger.ActivateOnCondition(ULINT#586, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#586;
                    END_IF;
    
                    CompletionClearControl.EXT_RequestCompleteClear := CompletionStatus.EXT_RequestComplete;
                    IF NOT CompletionStatus.EXT_RequestComplete THEN
                        CompletionClearControl.EXT_RequestCompleteClear := FALSE;
                        THIS.CallTimers(FALSE);
                        _progress := 387;
                    END_IF;
                END_IF;
                
                IF _progress = 387 THEN             // ReadTask running, waiting for general error flag is reseted
                    TaskMessenger.ActivateOnCondition(ULINT#587, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#587;
                    END_IF;
    
                    IF NOT HandshakeAndGeneralErrorStatus.GeneralError THEN
                        THIS.CallTimers(FALSE);
                        _progress := 388;
                    END_IF;
                END_IF;
                               
                IF _progress = 388 THEN             // ReadTask running, setting bank number
                    TaskMessenger.ActivateOnCondition(ULINT#735, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#735;
                    END_IF;
    
                    IF _Bank>=UINT#0 AND _Bank <=UINT#10 THEN
                        ParameterBankNumber.BankNumberRegister := _Bank;
                        THIS.CallTimers(FALSE);
                        _progress := 389;
                    END_IF;
                END_IF;
             
                IF _progress = 389 THEN             // ReadTask running, starting trigger
                    TaskMessenger.ActivateOnCondition(ULINT#589, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#589;
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
                    TaskMessenger.ActivateOnCondition(ULINT#590, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#590;
                    END_IF;
    
                    IF  ReadData.ResultDataReadyCount >_prevResultDataReadyCount THEN
                        THIS.CallTimers(FALSE);
                        _progress := 391;
                    END_IF;
                END_IF;
    
                IF _progress = 391 THEN             // ReadTask running, acknowledging results
                    TaskMessenger.ActivateOnCondition(ULINT#591, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#591;
                    END_IF;
    
                    CompletionClearControl.ReadCompleteClear := TRUE;
                    IF NOT CompletionStatus.ReadComplete THEN
                        CompletionClearControl.ReadCompleteClear := FALSE;
                        _progress := 392;
                    END_IF;
                END_IF;
                
                IF _progress = 392 THEN             // ReadTask running, 
                    TaskMessenger.ActivateOnCondition(ULINT#592, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#592;
                    END_IF;
    
                    IF TRUE THEN
                        _progress := 393;
                    END_IF;
                END_IF;
                
                IF _progress = 393 THEN             // ReadTask running, 
                    TaskMessenger.ActivateOnCondition(ULINT#593, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#593;
                    END_IF;
    
                    IF TRUE THEN
                        _progress := 394;
                    END_IF;
                END_IF;
                
                IF _progress = 394 THEN             // ReadTask running, 
                    TaskMessenger.ActivateOnCondition(ULINT#594, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#594;
                    END_IF;
    
                    IF TRUE THEN
                        _progress := 395;
                    END_IF;
                END_IF;
                
                IF _progress = 395 THEN             // ReadTask running, 
                    TaskMessenger.ActivateOnCondition(ULINT#595, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#595;
                    END_IF;
    
                    IF TRUE THEN
                        _progress := 396;
                    END_IF;
                END_IF;
                
                IF _progress = 396 THEN             // ReadTask running, 
                    TaskMessenger.ActivateOnCondition(ULINT#596, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#596;
                    END_IF;
    
                    IF TRUE THEN
                        _progress := 397;
                    END_IF;
                END_IF;
                
                IF _progress = 397 THEN             // ReadTask running, 
                    TaskMessenger.ActivateOnCondition(ULINT#597, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#597;
                    END_IF;
    
                    IF TRUE THEN
                        _progress := 398;
                    END_IF;
                END_IF;
                
                IF _progress = 398 THEN             // ReadTask running, 
                    TaskMessenger.ActivateOnCondition(ULINT#598, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#598;
                    END_IF;
    
                    IF TRUE THEN
                        _progress := 399;
                    END_IF;
                END_IF;
                
                IF _progress = 399 THEN             // ReadTask finished 
                    ReadTask.DoneWhen(TRUE);
                END_IF;
    
                THIS.CallTimers(TRUE);
                
                ReadTask.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);  
            END_IF;
            IF ReadTask.DoneReached() THEN
                Status.Action.Id :=  UINT#181;
                Status.Error.Id :=  UINT#0;
            ELSIF ReadTask.ErrorOccured() THEN
                Status.Action.Id :=  UINT#880;
                Status.Error.Id  :=  UINT#880;
            ELSIF ReadTask.AbortTriggered()THEN
                Status.Action.Id :=  UINT#881;
                Status.Error.Id  :=  UINT#881;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#880,ReadTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#881,ReadTask.IsAborted(), eAxoMessageCategory#Error);
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
                    TaskMessenger.ActivateOnCondition(ULINT#600, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#600;
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
                    TaskMessenger.ActivateOnCondition(ULINT#601, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#601;
                    END_IF;
    
                    LatchAndErrorClearControl.ErrorClear := HandshakeAndGeneralErrorStatus.Error;
                    IF NOT HandshakeAndGeneralErrorStatus.Error THEN
                        LatchAndErrorClearControl.ErrorClear := FALSE;
                        THIS.CallTimers(FALSE);
                        _progress := 402;
                    END_IF;
                END_IF;
                
                IF _progress = 402 THEN             // TuneTask running, clear read complete flag
                    TaskMessenger.ActivateOnCondition(ULINT#602, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#602;
                    END_IF;
    
                    CompletionClearControl.ReadCompleteClear := CompletionStatus.ReadComplete;
                    IF NOT CompletionStatus.ReadComplete THEN
                        CompletionClearControl.ReadCompleteClear := FALSE;
                        THIS.CallTimers(FALSE);
                        _progress := 403;
                    END_IF;
                END_IF;
                
                IF _progress = 403 THEN             // TuneTask running, clear preset complete flag
                    TaskMessenger.ActivateOnCondition(ULINT#603, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#603;
                    END_IF;

                    CompletionClearControl.PresetCompleteClear := CompletionStatus.PresetComplete;
                    IF NOT CompletionStatus.PresetComplete THEN
                        CompletionClearControl.PresetCompleteClear := FALSE;
                        THIS.CallTimers(FALSE);
                        _progress := 404;
                    END_IF;
                END_IF;
                
                IF _progress = 404 THEN             // TuneTask running, clear register preset data complete flag
                    TaskMessenger.ActivateOnCondition(ULINT#604, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#604;
                    END_IF;
    
                    CompletionClearControl.RegisterPresetDataCompleteClear := CompletionStatus.RegisterPresetDataComplete;
                    IF NOT CompletionStatus.RegisterPresetDataComplete THEN
                        CompletionClearControl.RegisterPresetDataCompleteClear := FALSE;
                        THIS.CallTimers(FALSE);
                        _progress := 405;
                    END_IF;
                END_IF;
                
                IF _progress = 405 THEN             // TuneTask running, clear tune complete flag
                    TaskMessenger.ActivateOnCondition(ULINT#605, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#605;
                    END_IF;
    
                    CompletionClearControl.TuneCompleteClear := CompletionStatus.TuneComplete;
                    IF NOT CompletionStatus.TuneComplete THEN
                        CompletionClearControl.TuneCompleteClear := FALSE;
                        THIS.CallTimers(FALSE);
                        _progress := 406;
                    END_IF;
                END_IF;
                
                IF _progress = 406 THEN             // TuneTask running, clear external request complete flag
                    TaskMessenger.ActivateOnCondition(ULINT#606, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#606;
                    END_IF;
    
                    CompletionClearControl.EXT_RequestCompleteClear := CompletionStatus.EXT_RequestComplete;
                    IF NOT CompletionStatus.EXT_RequestComplete THEN
                        CompletionClearControl.EXT_RequestCompleteClear := FALSE;
                        THIS.CallTimers(FALSE);
                        _progress := 407;
                    END_IF;
                END_IF;
                
                IF _progress = 407 THEN             // TuneTask running, waiting for general error flag is reseted
                    TaskMessenger.ActivateOnCondition(ULINT#607, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#607;
                    END_IF;
    
                    IF NOT HandshakeAndGeneralErrorStatus.GeneralError THEN
                        THIS.CallTimers(FALSE);
                        _progress := 408;
                    END_IF;
                END_IF;
                
                IF _progress = 408 THEN             // TuneTask running, setting bank number
                    TaskMessenger.ActivateOnCondition(ULINT#735, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#735;
                    END_IF;
    
                    IF _Bank>=UINT#0 AND _Bank <=UINT#10 THEN
                        ParameterBankNumber.BankNumberRegister := _Bank;
                        THIS.CallTimers(FALSE);
                        _progress := 409;
                    END_IF;
                END_IF;
                
                IF _progress = 409 THEN             // TuneTask running, starting tune process
                    TaskMessenger.ActivateOnCondition(ULINT#609, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#609;
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
                    TaskMessenger.ActivateOnCondition(ULINT#610, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#610;
                    END_IF;
    
                    CompletionClearControl.TuneCompleteClear := TRUE;
                    IF NOT CompletionStatus.TuneComplete THEN
                        CompletionClearControl.TuneCompleteClear := FALSE;
                        _progress := 411;
                    END_IF;
                END_IF;
    
                IF _progress = 411 THEN             // TuneTask running, 
                    TaskMessenger.ActivateOnCondition(ULINT#611, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#611;
                    END_IF;
    
                    IF TRUE THEN
                        _progress := 412;
                    END_IF;
                END_IF;
                
                IF _progress = 412 THEN             // TuneTask running, 
                    TaskMessenger.ActivateOnCondition(ULINT#612, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#612;
                    END_IF;
    
                    IF TRUE THEN
                        _progress := 413;
                    END_IF;
                END_IF;
                
                IF _progress = 413 THEN             // TuneTask running, 
                    TaskMessenger.ActivateOnCondition(ULINT#613, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#613;
                    END_IF;
    
                    IF TRUE THEN
                        _progress := 414;
                    END_IF;
                END_IF;
                
                IF _progress = 414 THEN             // TuneTask running, 
                    TaskMessenger.ActivateOnCondition(ULINT#614, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#614;
                    END_IF;
    
                    IF TRUE THEN
                        _progress := 415;
                    END_IF;
                END_IF;
                
                IF _progress = 415 THEN             // TuneTask running, 
                    TaskMessenger.ActivateOnCondition(ULINT#615, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#615;
                    END_IF;
    
                    IF TRUE THEN
                        _progress := 416;
                    END_IF;
                END_IF;
                
                IF _progress = 416 THEN             // TuneTask running, 
                    TaskMessenger.ActivateOnCondition(ULINT#616, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#616;
                    END_IF;
    
                    IF TRUE THEN
                        _progress := 417;
                    END_IF;
                END_IF;
                
                IF _progress = 417 THEN             // TuneTask running, 
                    TaskMessenger.ActivateOnCondition(ULINT#617, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#617;
                    END_IF;
    
                    IF TRUE THEN
                        _progress := 418;
                    END_IF;
                END_IF;
                
                IF _progress = 418 THEN             // TuneTask running, 
                    TaskMessenger.ActivateOnCondition(ULINT#618, _infoTimer.output, eAxoMessageCategory#Warning);
                    IF _infoTimer.output THEN
                        Status.Error.Id := UINT#618;
                    END_IF;
    
                    IF TRUE THEN
                        _progress := 419;
                    END_IF;
                END_IF;
                
                IF _progress = 419 THEN             // TuneTask finished
                    TuneTask.DoneWhen(TRUE);
                END_IF;
    
                THIS.CallTimers(TRUE);
                
                TuneTask.ThrowWhen(_errorTimer.output);
                Status.Action.Id := TO_UINT(_progress);  
            END_IF;
            IF TuneTask.DoneReached() THEN
                Status.Action.Id :=  UINT#201;
                Status.Error.Id :=  UINT#0;
            ELSIF TuneTask.ErrorOccured() THEN
                Status.Action.Id :=  UINT#900;
                Status.Error.Id  :=  UINT#900;
            ELSIF TuneTask.AbortTriggered()THEN
                Status.Action.Id :=  UINT#901;
                Status.Error.Id  :=  UINT#901;
            END_IF;            
            Messenger.ActivateOnCondition(ULINT#900,TuneTask.HasError(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#901,TuneTask.IsAborted(), eAxoMessageCategory#Error);
            Messenger.ActivateOnCondition(ULINT#202,TuneTask.RestoreTriggered() , eAxoMessageCategory#Error);
            IF TuneTask.RestoreTriggered() AND _progress >= 400 AND _progress <= 419  THEN
                Status.Action.Id :=  UINT#202;
                _progress := 0;
            END_IF;
            //******************************************

            //****************Update outputs*****************
            _data_1[0].%X1                  :=      LatchAndErrorClearControl.ResultDataLatch;
            _data_1[0].%X7                  :=      LatchAndErrorClearControl.ErrorClear;

            _returnValue := Siemens.Simatic.S71500.DistributedIO.WriteData(_hwIdLatchAndErrorClearControl,_data_1);
            Messenger.ActivateOnCondition(ULINT#726,_returnValue > WORD#0, eAxoMessageCategory#ProgrammingError);
            IF _returnValue > WORD#0 THEN
                Status.Error.Id := UINT#726;
                RETURN;
            END_IF;

            _data_1[0].%X0                  :=      OperationInstructionControl.ReadRequest;
            _data_1[0].%X1                  :=      OperationInstructionControl.PresetRequest;
            _data_1[0].%X2                  :=      OperationInstructionControl.RegisterPresetDataRequest;
            _data_1[0].%X3                  :=      OperationInstructionControl.TuneRequest;

            _returnValue := Siemens.Simatic.S71500.DistributedIO.WriteData(_hwIdOperationInstructionControl,_data_1);
            Messenger.ActivateOnCondition(ULINT#727,_returnValue > WORD#0, eAxoMessageCategory#ProgrammingError);
            IF _returnValue > WORD#0 THEN
                Status.Error.Id := UINT#727;
                RETURN;
            END_IF;

            _data_1[0].%X0                  :=      CompletionClearControl.ReadCompleteClear;
            _data_1[0].%X1                  :=      CompletionClearControl.PresetCompleteClear;
            _data_1[0].%X2                  :=      CompletionClearControl.RegisterPresetDataCompleteClear;
            _data_1[0].%X3                  :=      CompletionClearControl.TuneCompleteClear;
            _data_1[0].%X7                  :=      CompletionClearControl.EXT_RequestCompleteClear;

            _returnValue := Siemens.Simatic.S71500.DistributedIO.WriteData(_hwIdCompletionClearControl,_data_1);
            Messenger.ActivateOnCondition(ULINT#728,_returnValue > WORD#0, eAxoMessageCategory#ProgrammingError);
            IF _returnValue > WORD#0 THEN
                Status.Error.Id := UINT#728;
                RETURN;
            END_IF;

            _data_2[1]                      :=      TO_WORD(ParameterBankNumber.BankNumberRegister).%B0;
            _data_2[0]                      :=      TO_WORD(ParameterBankNumber.BankNumberRegister).%B1;

            _returnValue := Siemens.Simatic.S71500.DistributedIO.WriteData(_hwIdParameterBankNumber,_data_2);
            Messenger.ActivateOnCondition(ULINT#729,_returnValue > WORD#0, eAxoMessageCategory#ProgrammingError);
            IF _returnValue > WORD#0 THEN
                Status.Error.Id := UINT#729;
                RETURN;
            END_IF;
            

            _invalidDataSize := NOT (_UserDataSize = eAxo_SR_1000_UserDataSize#USER_DATA_32B OR
                                     _UserDataSize = eAxo_SR_1000_UserDataSize#USER_DATA_64B OR
                                     _UserDataSize = eAxo_SR_1000_UserDataSize#USER_DATA_128B OR
                                     _UserDataSize = eAxo_SR_1000_UserDataSize#USER_DATA_252B);

            Messenger.ActivateOnCondition(ULINT#730,_invalidDataSize, eAxoMessageCategory#ProgrammingError);

            IF _invalidDataSize THEN
                Status.Error.Id := UINT#730;
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
                    _returnValue := Siemens.Simatic.S71500.DistributedIO.WriteData(_hwIdUserData ,_data_34);
                    Messenger.ActivateOnCondition(ULINT#731,_returnValue > WORD#0, eAxoMessageCategory#ProgrammingError);
                    IF _returnValue > WORD#0 THEN
                        Status.Error.Id := UINT#731;
                        RETURN;
                    END_IF;
                ELSIF Config.UserDataSize = eAxo_SR_1000_UserDataSize#USER_DATA_64B THEN
                    _data_66[1] := TO_WORD(User.UserDataSize).%B0;
                    _data_66[0] := TO_WORD(User.UserDataSize).%B1;
                    FOR _index := 2 TO 65 DO
                        _data_66[_index] := UserData.Data[_index];
                    END_FOR;
                    _returnValue := Siemens.Simatic.S71500.DistributedIO.WriteData(_hwIdUserData ,_data_66);
                    Messenger.ActivateOnCondition(ULINT#732,_returnValue > WORD#0, eAxoMessageCategory#ProgrammingError);
                    IF _returnValue > WORD#0 THEN
                        Status.Error.Id := UINT#732;
                        RETURN;
                    END_IF;
                ELSIF Config.UserDataSize = eAxo_SR_1000_UserDataSize#USER_DATA_128B THEN
                    _data_130[1] := TO_WORD(User.UserDataSize).%B0;
                    _data_130[0] := TO_WORD(User.UserDataSize).%B1;
                    FOR _index := 2 TO 129 DO
                        _data_130[_index] := UserData.Data[_index];
                    END_FOR;
                    _returnValue := Siemens.Simatic.S71500.DistributedIO.WriteData(_hwIdUserData ,_data_130);
                    Messenger.ActivateOnCondition(ULINT#733,_returnValue > WORD#0, eAxoMessageCategory#ProgrammingError);
                    IF _returnValue > WORD#0 THEN
                        Status.Error.Id := UINT#733;
                        RETURN;
                    END_IF;
                ELSIF Config.UserDataSize = eAxo_SR_1000_UserDataSize#USER_DATA_252B THEN
                    _data_254[1] := TO_WORD(User.UserDataSize).%B0;
                    _data_254[0] := TO_WORD(User.UserDataSize).%B1;
                    FOR _index := 2 TO 253 DO
                        _data_254[_index] := UserData.Data[_index];
                    END_FOR;
                    _returnValue := Siemens.Simatic.S71500.DistributedIO.WriteData(_hwIdUserData ,_data_254);
                    Messenger.ActivateOnCondition(ULINT#734,_returnValue > WORD#0, eAxoMessageCategory#ProgrammingError);
                    IF _returnValue > WORD#0 THEN
                        Status.Error.Id := UINT#734;
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
            
            _infoTimer.OnDelay(THIS, signal , Config.InfoTime);
            _errorTimer.OnDelay(THIS, signal , Config.ErrorTime );
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
