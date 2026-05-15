NAMESPACE AXOpen.Components.Cognex.Vision
   {S7.extern=ReadWrite}
	CLASS AxoVisionProHWIDs 
      VAR PUBLIC
         {#ix-set:AttributeName = "<#Hardware ID of the device#>"}
         HW_Device              : UINT;
         {#ix-set:AttributeName = "<#Hardware ID 'SystemControl' submodule#>"}
         HW_SystemControl     : UINT;
         {#ix-set:AttributeName = "<#'SystemControl' submodule's input area start address#>"}
         SystemControl_InAddress : UDINT;
         {#ix-set:AttributeName = "<#'SystemControl' submodule's input area length#>"}
         SystemControl_InLength : UINT;
         {#ix-set:AttributeName = "<#'SystemControl' submodule's output area start address#>"}
         SystemControl_OutAddress : UDINT;
         {#ix-set:AttributeName = "<#'SystemControl' submodule's output area length#>"}
         SystemControl_OutLength : UINT;
         {#ix-set:AttributeName = "<#Hardware ID 'EngineControl_1' submodule#>"}
         HW_EngineControl_1   : UINT;
         {#ix-set:AttributeName = "<#'EngineControl_1' submodule's input area start address#>"}
         EngineControl_1_InAddress : UDINT;
         {#ix-set:AttributeName = "<#'EngineControl_1' submodule's input area length#>"}
         EngineControl_1_InLength : UINT;
         {#ix-set:AttributeName = "<#'EngineControl_1' submodule's output area start address#>"}
         EngineControl_1_OutAddress : UDINT;
         {#ix-set:AttributeName = "<#'EngineControl_1' submodule's output area length#>"}
         EngineControl_1_OutLength : UINT;
         {#ix-set:AttributeName = "<#Hardware ID 'EngineControl_2' submodule#>"}
         HW_EngineControl_2   : UINT;
         {#ix-set:AttributeName = "<#'EngineControl_2' submodule's input area start address#>"}
         EngineControl_2_InAddress : UDINT;
         {#ix-set:AttributeName = "<#'EngineControl_2' submodule's input area length#>"}
         EngineControl_2_InLength : UINT;
         {#ix-set:AttributeName = "<#'EngineControl_2' submodule's output area start address#>"}
         EngineControl_2_OutAddress : UDINT;
         {#ix-set:AttributeName = "<#'EngineControl_2' submodule's output area length#>"}
         EngineControl_2_OutLength : UINT;
         {#ix-set:AttributeName = "<#Hardware ID 'EngineControl_3' submodule#>"}
         HW_EngineControl_3   : UINT;
         {#ix-set:AttributeName = "<#'EngineControl_3' submodule's input area start address#>"}
         EngineControl_3_InAddress : UDINT;
         {#ix-set:AttributeName = "<#'EngineControl_3' submodule's input area length#>"}
         EngineControl_3_InLength : UINT;
         {#ix-set:AttributeName = "<#'EngineControl_3' submodule's output area start address#>"}
         EngineControl_3_OutAddress : UDINT;
         {#ix-set:AttributeName = "<#'EngineControl_3' submodule's output area length#>"}
         EngineControl_3_OutLength : UINT;
         {#ix-set:AttributeName = "<#Hardware ID 'EngineControl_4' submodule#>"}
         HW_EngineControl_4   : UINT;
         {#ix-set:AttributeName = "<#'EngineControl_4' submodule's input area start address#>"}
         EngineControl_4_InAddress : UDINT;
         {#ix-set:AttributeName = "<#'EngineControl_4' submodule's input area length#>"}
         EngineControl_4_InLength : UINT;
         {#ix-set:AttributeName = "<#'EngineControl_4' submodule's output area start address#>"}
         EngineControl_4_OutAddress : UDINT;
         {#ix-set:AttributeName = "<#'EngineControl_4' submodule's output area length#>"}
         EngineControl_4_OutLength : UINT;
         {#ix-set:AttributeName = "<#Hardware ID 'UserData_240B_1' submodule#>"}
         HW_UserData_240B_1   : UINT;
         {#ix-set:AttributeName = "<#'UserData_240B_1' submodule's output area start address#>"}
         UserData_240B_1_OutAddress : UDINT;
         {#ix-set:AttributeName = "<#'UserData_240B_1' submodule's output area length#>"}
         UserData_240B_1_OutLength : UINT;
         {#ix-set:AttributeName = "<#Hardware ID 'UserData_240B_2' submodule#>"}
         HW_UserData_240B_2   : UINT;
         {#ix-set:AttributeName = "<#'UserData_240B_2' submodule's output area start address#>"}
         UserData_240B_2_OutAddress : UDINT;
         {#ix-set:AttributeName = "<#'UserData_240B_2' submodule's output area length#>"}
         UserData_240B_2_OutLength : UINT;
         {#ix-set:AttributeName = "<#Hardware ID 'UserData_240B_3' submodule#>"}
         HW_UserData_240B_3   : UINT;
         {#ix-set:AttributeName = "<#'UserData_240B_3' submodule's output area start address#>"}
         UserData_240B_3_OutAddress : UDINT;
         {#ix-set:AttributeName = "<#'UserData_240B_3' submodule's output area length#>"}
         UserData_240B_3_OutLength : UINT;
         {#ix-set:AttributeName = "<#Hardware ID 'UserData_240B_4' submodule#>"}
         HW_UserData_240B_4   : UINT;
         {#ix-set:AttributeName = "<#'UserData_240B_4' submodule's output area start address#>"}
         UserData_240B_4_OutAddress : UDINT;
         {#ix-set:AttributeName = "<#'UserData_240B_4' submodule's output area length#>"}
         UserData_240B_4_OutLength : UINT;
         {#ix-set:AttributeName = "<#Hardware ID 'UserData_240B_5' submodule#>"}
         HW_UserData_240B_5   : UINT;
         {#ix-set:AttributeName = "<#'UserData_240B_5' submodule's output area start address#>"}
         UserData_240B_5_OutAddress : UDINT;
         {#ix-set:AttributeName = "<#'UserData_240B_5' submodule's output area length#>"}
         UserData_240B_5_OutLength : UINT;
         {#ix-set:AttributeName = "<#Hardware ID 'UserData_64B_1' submodule#>"}
         HW_UserData_64B_1    : UINT;
         {#ix-set:AttributeName = "<#'UserData_64B_1' submodule's output area start address#>"}
         UserData_64B_1_OutAddress : UDINT;
         {#ix-set:AttributeName = "<#'UserData_64B_1' submodule's output area length#>"}
         UserData_64B_1_OutLength : UINT;
         {#ix-set:AttributeName = "<#Hardware ID 'Results_240B_1' submodule#>"}
         HW_Results_240B_1    : UINT;
         {#ix-set:AttributeName = "<#'Results_240B_1' submodule's input area start address#>"}
         Results_240B_1_InAddress : UDINT;
         {#ix-set:AttributeName = "<#'Results_240B_1' submodule's input area length#>"}
         Results_240B_1_InLength : UINT;
         {#ix-set:AttributeName = "<#Hardware ID 'Results_240B_2' submodule#>"}
         HW_Results_240B_2    : UINT;
         {#ix-set:AttributeName = "<#'Results_240B_2' submodule's input area start address#>"}
         Results_240B_2_InAddress : UDINT;
         {#ix-set:AttributeName = "<#'Results_240B_2' submodule's input area length#>"}
         Results_240B_2_InLength : UINT;
         {#ix-set:AttributeName = "<#Hardware ID 'Results_240B_3' submodule#>"}
         HW_Results_240B_3    : UINT;
         {#ix-set:AttributeName = "<#'Results_240B_3' submodule's input area start address#>"}
         Results_240B_3_InAddress : UDINT;
         {#ix-set:AttributeName = "<#'Results_240B_3' submodule's input area length#>"}
         Results_240B_3_InLength : UINT;
         {#ix-set:AttributeName = "<#Hardware ID 'Results_240B_4' submodule#>"}
         HW_Results_240B_4    : UINT;
         {#ix-set:AttributeName = "<#'Results_240B_4' submodule's input area start address#>"}
         Results_240B_4_InAddress : UDINT;
         {#ix-set:AttributeName = "<#'Results_240B_4' submodule's input area length#>"}
         Results_240B_4_InLength : UINT;
         {#ix-set:AttributeName = "<#Hardware ID 'Results_240B_5' submodule#>"}
         HW_Results_240B_5    : UINT;
         {#ix-set:AttributeName = "<#'Results_240B_5' submodule's input area start address#>"}
         Results_240B_5_InAddress : UDINT;
         {#ix-set:AttributeName = "<#'Results_240B_5' submodule's input area length#>"}
         Results_240B_5_InLength : UINT;
         {#ix-set:AttributeName = "<#Hardware ID 'Results_64B_1' submodule#>"}
         HW_Results_64B_1    : UINT;
         {#ix-set:AttributeName = "<#'Results_64B_1' submodule's input area start address#>"}
         Results_64B_1_InAddress : UDINT;
         {#ix-set:AttributeName = "<#'Results_64B_1' submodule's input area length#>"}
         Results_64B_1_InLength : UINT;
      END_VAR
   END_CLASS
END_NAMESPACE
