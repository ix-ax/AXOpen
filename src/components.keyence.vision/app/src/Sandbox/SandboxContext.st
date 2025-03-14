USING AXOpen.Core;
NAMESPACE AXOpen.Components.Keyence.Vision
    {S7.extern=ReadWrite}
    CLASS SandboxContext EXTENDS AXOpen.Core.AxoContext
        VAR PUBLIC
            _manualControl : BOOL;
            _sr_750 : AXOpen.Components.Keyence.Vision.Axo_SR_750;
            _sr_1000 : AXOpen.Components.Keyence.Vision.Axo_SR_1000;
            _rootObject : AxoObject;
        END_VAR

        METHOD PROTECTED OVERRIDE Main
            THIS.InitializeRootObject(_rootObject);

            RETURN;
            
            _sr_750.Run(
                                parent                                          :=   _rootObject,
                                ResultDataSize                                  :=   AXOpen.Components.Keyence.Vision.eAxo_SR_750_ResultDataSize#RESULT_DATA_128B,
                                UserDataSize                                    :=   AXOpen.Components.Keyence.Vision.eAxo_SR_750_UserDataSize#USER_DATA_128B,
                                hwID                                            :=   HwIdentifiers#sr_750_1_HwID,
                                hwIdHandshakeAndGeneralErrorStatus              :=   HwIdentifiers#sr_750_1_HandshakeAndGeneralErrorStatus_Handshake_and_General_Error_Status_Bits_HwID,
                                hwIdBUSY_Status                                 :=   HwIdentifiers#sr_750_1_BusyStatus_BUSY_Status_Bits_HwID,
                                hwIdCompletionStatus                            :=   HwIdentifiers#sr_750_1_CompletionStatus_Completion_Status_Bits_HwID,
                                hwIdErrorStatus                                 :=   HwIdentifiers#sr_750_1_ErrorStatus_Error_Status_Bits_HwID,
                                hwIdTerminalStatus                              :=   HwIdentifiers#sr_750_1_TerminalStatus_Terminal_Status_Bits_HwID,
                                hwIdUnstableReadStatus                          :=   HwIdentifiers#sr_750_1_UnstableReadStatus_Unstable_Read_Status_Bits_HwID,
                                hwIdMatchingLevelAndTotalEvaluationGradeStatus  :=   HwIdentifiers#sr_750_1_MatchingLevelAndTotalEvaluationGradeStatus_Matching_Level_and_Total_Evaluation_Grade_Status_HwID,
                                hwIdOperationalResultStatus                     :=   HwIdentifiers#sr_750_1_OperationResultStatus_Operation_Result_Status_HwID,
                                hwIdReadData                                    :=   HwIdentifiers#sr_750_1_ReadData_128_bytes_Read_Data_128Byte_HwID,
                                hwIdLatchAndErrorClearControl                   :=   HwIdentifiers#sr_750_1_LatchAndErrorClearControl_Latch_and_Error_Clear_Control_Bits_HwID,
                                hwIdOperationInstructionControl                 :=   HwIdentifiers#sr_750_1_OperationInstructionControl_Operation_instruction_Control_Bits_HwID,
                                hwIdCompletionClearControl                      :=   HwIdentifiers#sr_750_1_CompletionClearControl_Completion_Clear_Control_Bits_HwID,
                                hwIdParameterBankNumber                         :=   HwIdentifiers#sr_750_1_ParameterBank_Parameter_Bank_Number_HwID,
                                hwIdUserData                                    :=   HwIdentifiers#sr_750_1_UserData_128_bytes_User_Data_128Byte_HwID
            );

            _sr_1000.Run(
                                parent                                          :=   _rootObject,
                                ResultDataSize                                  :=   AXOpen.Components.Keyence.Vision.eAxo_SR_1000_ResultDataSize#RESULT_DATA_128B,
                                UserDataSize                                    :=   AXOpen.Components.Keyence.Vision.eAxo_SR_1000_UserDataSize#USER_DATA_128B,
                                hwID                                            :=   HwIdentifiers#sr_1000_1_HwID,
                                hwIdHandshakeAndGeneralErrorStatus              :=   HwIdentifiers#sr_1000_1_HandshakeAndGeneralErrorStatus_Handshake_and_General_Error_Status_Bits_HwID,
                                hwIdBUSY_Status                                 :=   HwIdentifiers#sr_1000_1_BusyStatus_BUSY_Status_Bits_HwID,
                                hwIdCompletionStatus                            :=   HwIdentifiers#sr_1000_1_CompletionStatus_Completion_Status_Bits_HwID,
                                hwIdErrorStatus                                 :=   HwIdentifiers#sr_1000_1_ErrorStatus_Error_Status_Bits_HwID,
                                hwIdTerminalStatus                              :=   HwIdentifiers#sr_1000_1_TerminalStatus_Terminal_Status_Bits_HwID,
                                hwIdUnstableReadStatus                          :=   HwIdentifiers#sr_1000_1_UnstableReadStatus_Unstable_Read_Status_Bits_HwID,
                                hwIdMatchingLevelAndTotalEvaluationGradeStatus  :=   HwIdentifiers#sr_1000_1_MatchingLevelAndTotalEvaluationGradeStatus_Matching_Level_and_Total_Evaluation_Grade_Status_HwID,
                                hwIdOperationalResultStatus                     :=   HwIdentifiers#sr_1000_1_OperationResultStatus_Operation_Result_Status_HwID,
                                hwIdReadData                                    :=   HwIdentifiers#sr_1000_1_ReadData_128_bytes_Read_Data_128Byte_HwID,
                                hwIdLatchAndErrorClearControl                   :=   HwIdentifiers#sr_1000_1_LatchAndErrorClearControl_Latch_and_Error_Clear_Control_Bits_HwID,
                                hwIdOperationInstructionControl                 :=   HwIdentifiers#sr_1000_1_OperationInstructionControl_Operation_instruction_Control_Bits_HwID,
                                hwIdCompletionClearControl                      :=   HwIdentifiers#sr_1000_1_CompletionClearControl_Completion_Clear_Control_Bits_HwID,
                                hwIdParameterBankNumber                         :=   HwIdentifiers#sr_1000_1_ParameterBank_Parameter_Bank_Number_HwID,
                                hwIdUserData                                    :=   HwIdentifiers#sr_1000_1_UserData_128_bytes_User_Data_128Byte_HwID
            );


            IF(_manualControl) THEN
                _sr_750.ActivateManualControl();
                _sr_1000.ActivateManualControl();
            END_IF;    
        END_METHOD
    END_CLASS
END_NAMESPACE