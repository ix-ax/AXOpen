NAMESPACE AXOpen.Components.Keyence.Vision
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Stack)]}
    CLASS PUBLIC Axo_SR_100_HWIDs  
        VAR PUBLIC
            {#ix-set:AttributeName = "<#Hardware ID of the device#>"}
            HwID_Device            :   UINT;
            {#ix-set:AttributeName = "<#Hardware ID of the 'HandshakeAndGeneralErrorStatus' submodule#>"}
            HwID_HandshakeAndGeneralErrorStatus                 :   UINT;
            {#ix-set:AttributeName = "<#Hardware ID of the 'BUSY_Status' submodule#>"}
            HwID_BUSY_Status                                    :   UINT;
            {#ix-set:AttributeName = "<#Hardware ID of the 'CompletionStatus' submodule#>"}
            HwID_CompletionStatus                               :   UINT;
            {#ix-set:AttributeName = "<#Hardware ID of the 'ErrorStatus' submodule#>"}
            HwID_ErrorStatus                                    :   UINT;
            {#ix-set:AttributeName = "<#Hardware ID of the 'TerminalStatus' submodule#>"}
            HwID_TerminalStatus                                 :   UINT;
            {#ix-set:AttributeName = "<#Hardware ID of the 'UnstableReadStatus' submodule#>"}
            HwID_UnstableReadStatus                             :   UINT;
            {#ix-set:AttributeName = "<#Hardware ID of the 'MatchingLevelAndTotalEvaluationGradeStatus' submodule#>"}
            HwID_MatchingLevelAndTotalEvaluationGradeStatus     :   UINT;
            {#ix-set:AttributeName = "<#Hardware ID of the 'OperationalResultStatus' submodule#>"}
            HwID_OperationalResultStatus                        :   UINT;
            {#ix-set:AttributeName = "<#Hardware ID of the 'ReadData' submodule#>"}
            HwID_ReadData                                       :   UINT;
            {#ix-set:AttributeName = "<#Hardware ID of the 'LatchAndErrorClearControl' submodule#>"}
            HwID_LatchAndErrorClearControl                      :   UINT;
            {#ix-set:AttributeName = "<#Hardware ID of the 'OperationInstructionControl' submodule#>"}
            HwID_OperationInstructionControl                    :   UINT;
            {#ix-set:AttributeName = "<#Hardware ID of the 'CompletionClearControl' submodule#>"}
            HwID_CompletionClearControl                         :   UINT;
            {#ix-set:AttributeName = "<#Hardware ID of the 'ParameterBankNumber' submodule#>"}
            HwID_ParameterBankNumber                            :   UINT;
            {#ix-set:AttributeName = "<#Hardware ID of the 'UserData' submodule#>"}
            HwID_UserData                                       :   UINT;
        END_VAR 
    END_CLASS    
END_NAMESPACE