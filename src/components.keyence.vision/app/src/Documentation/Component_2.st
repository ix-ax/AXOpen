USING AXOpen.Core;
NAMESPACE AXOpen.Components.Keyence.Vision
    {S7.extern=ReadWrite}
    CLASS Component_2 EXTENDS AXOpen.Core.AxoObject
        //<ComponentDeclaration>
        VAR PUBLIC                
            Component : AXOpen.Components.Keyence.Vision.Axo_SR_1000;             
        END_VAR
        //</ComponentDeclaration>                          

        //<InitializationArgumentsDeclaration>
        VAR PUBLIC              
            {#ix-set:AttributeName = "<#Activate manual control#>"}
            ActivateManualControl : BOOL;         
        END_VAR
        //</InitializationArgumentsDeclaration>            

        METHOD PUBLIC OVERRIDE Run
            VAR_INPUT
                parent : IAxoObject;
            END_VAR    

            SUPER.Run(parent);

            IF ActivateManualControl THEN
                Component.ActivateManualControl();
            END_IF;

            //<Initialization>     
            Component.Run(
                                parent                                          :=   THIS,
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
            //</Initialization>

            THIS.UseInSequencer();
        END_METHOD

        //<Usage>    
        VAR PUBLIC                       
            Sequencer : AxoSequencer;       
            Steps : ARRAY[0..3] OF AXOpen.Core.AxoStep;
        END_VAR

        VAR PRIVATE
            _ResultData  :   AXOpen.Components.Keyence.Vision.Axo_SR_1000_ResultData;
        END_VAR

        METHOD PRIVATE UseInSequencer   

            Sequencer.Run(THIS);
            Sequencer.Open();

            IF(Steps[0].Execute(Sequencer, 'Clear result data')) THEN
                IF(Component.ClearResultData().IsDone()) THEN                
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;

            IF(Steps[1].Execute(Sequencer, 'Tune')) THEN
                IF(Component.Tune(UINT#0).IsDone()) THEN                
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;

            IF(Steps[2].Execute(Sequencer, 'Read data')) THEN
                IF(Component.Read(UINT#0).IsDone()) THEN                       
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;       

            IF(Steps[3].Execute(Sequencer, 'Evaluate data')) THEN
                _ResultData := Component.ResultData;
                Sequencer.CompleteSequence();                               
            END_IF;   

        END_METHOD
        //</Usage>
    END_CLASS
END_NAMESPACE