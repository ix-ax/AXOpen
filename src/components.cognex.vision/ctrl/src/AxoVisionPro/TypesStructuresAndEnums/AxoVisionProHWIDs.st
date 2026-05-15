NAMESPACE AXOpen.Components.Cognex.Vision
   {S7.extern=ReadWrite}
	CLASS AxoVisionProHWIDs 
      VAR PUBLIC
         {#ix-set:AttributeName = "<#Hardware ID of the device#>"}
         HW_Device              : UINT;
         {#ix-set:AttributeName = "<#Hardware ID 'SystemControl' submodule#>"}
         HW_SystemControl     : UINT;
         {#ix-set:AttributeName = "<#'SystemControl' submodule's address#>"}
         SystemControl_Address : UINT;
         {#ix-set:AttributeName = "<#'SystemControl' submodule's length#>"}
         SystemControl_Length : UINT;
         {#ix-set:AttributeName = "<#Hardware ID 'EngineControl_1' submodule#>"}
         HW_EngineControl_1   : UINT;
         {#ix-set:AttributeName = "<#'EngineControl_1' submodule's address#>"}
         EngineControl_1_Address : UINT;
         {#ix-set:AttributeName = "<#'EngineControl_1' submodule's length#>"}
         EngineControl_1_Length : UINT;
         {#ix-set:AttributeName = "<#Hardware ID 'EngineControl_2' submodule#>"}
         HW_EngineControl_2   : UINT;
         {#ix-set:AttributeName = "<#'EngineControl_2' submodule's address#>"}
         EngineControl_2_Address : UINT;
         {#ix-set:AttributeName = "<#'EngineControl_2' submodule's length#>"}
         EngineControl_2_Length : UINT;
         {#ix-set:AttributeName = "<#Hardware ID 'EngineControl_3' submodule#>"}
         HW_EngineControl_3   : UINT;
         {#ix-set:AttributeName = "<#'EngineControl_3' submodule's address#>"}
         EngineControl_3_Address : UINT;
         {#ix-set:AttributeName = "<#'EngineControl_3' submodule's length#>"}
         EngineControl_3_Length : UINT;
         {#ix-set:AttributeName = "<#Hardware ID 'EngineControl_4' submodule#>"}
         HW_EngineControl_4   : UINT;
         {#ix-set:AttributeName = "<#'EngineControl_4' submodule's address#>"}
         EngineControl_4_Address : UINT;
         {#ix-set:AttributeName = "<#'EngineControl_4' submodule's length#>"}
         EngineControl_4_Length : UINT;
         {#ix-set:AttributeName = "<#Hardware ID 'UserData_240B_1' submodule#>"}
         HW_UserData_240B_1   : UINT;
         {#ix-set:AttributeName = "<#'UserData_240B_1' submodule's address#>"}
         UserData_240B_1_Address : UINT;
         {#ix-set:AttributeName = "<#'UserData_240B_1' submodule's length#>"}
         UserData_240B_1_Length : UINT;
         {#ix-set:AttributeName = "<#Hardware ID 'UserData_240B_2' submodule#>"}
         HW_UserData_240B_2   : UINT;
         {#ix-set:AttributeName = "<#'UserData_240B_2' submodule's address#>"}
         UserData_240B_2_Address : UINT;
         {#ix-set:AttributeName = "<#'UserData_240B_2' submodule's length#>"}
         UserData_240B_2_Length : UINT;
         {#ix-set:AttributeName = "<#Hardware ID 'UserData_240B_3' submodule#>"}
         HW_UserData_240B_3   : UINT;
         {#ix-set:AttributeName = "<#'UserData_240B_3' submodule's address#>"}
         UserData_240B_3_Address : UINT;
         {#ix-set:AttributeName = "<#'UserData_240B_3' submodule's length#>"}
         UserData_240B_3_Length : UINT;
         {#ix-set:AttributeName = "<#Hardware ID 'UserData_240B_4' submodule#>"}
         HW_UserData_240B_4   : UINT;
         {#ix-set:AttributeName = "<#'UserData_240B_4' submodule's address#>"}
         UserData_240B_4_Address : UINT;
         {#ix-set:AttributeName = "<#'UserData_240B_4' submodule's length#>"}
         UserData_240B_4_Length : UINT;
         {#ix-set:AttributeName = "<#Hardware ID 'UserData_240B_5' submodule#>"}
         HW_UserData_240B_5   : UINT;
         {#ix-set:AttributeName = "<#'UserData_240B_5' submodule's address#>"}
         UserData_240B_5_Address : UINT;
         {#ix-set:AttributeName = "<#'UserData_240B_5' submodule's length#>"}
         UserData_240B_5_Length : UINT;
         {#ix-set:AttributeName = "<#Hardware ID 'UserData_64B_1' submodule#>"}
         HW_UserData_64B_1    : UINT;
         {#ix-set:AttributeName = "<#'UserData_64B_1' submodule's address#>"}
         UserData_64B_1_Address : UINT;
         {#ix-set:AttributeName = "<#'UserData_64B_1' submodule's length#>"}
         UserData_64B_1_Length : UINT;
         {#ix-set:AttributeName = "<#Hardware ID 'Results_240B_1' submodule#>"}
         HW_Results_240B_1    : UINT;
         {#ix-set:AttributeName = "<#'Results_240B_1' submodule's address#>"}
         Results_240B_1_Address : UINT;
         {#ix-set:AttributeName = "<#'Results_240B_1' submodule's length#>"}
         Results_240B_1_Length : UINT;
         {#ix-set:AttributeName = "<#Hardware ID 'Results_240B_2' submodule#>"}
         HW_Results_240B_2    : UINT;
         {#ix-set:AttributeName = "<#'Results_240B_2' submodule's address#>"}
         Results_240B_2_Address : UINT;
         {#ix-set:AttributeName = "<#'Results_240B_2' submodule's length#>"}
         Results_240B_2_Length : UINT;
         {#ix-set:AttributeName = "<#Hardware ID 'Results_240B_3' submodule#>"}
         HW_Results_240B_3    : UINT;
         {#ix-set:AttributeName = "<#'Results_240B_3' submodule's address#>"}
         Results_240B_3_Address : UINT;
         {#ix-set:AttributeName = "<#'Results_240B_3' submodule's length#>"}
         Results_240B_3_Length : UINT;
         {#ix-set:AttributeName = "<#Hardware ID 'Results_240B_4' submodule#>"}
         HW_Results_240B_4    : UINT;
         {#ix-set:AttributeName = "<#'Results_240B_4' submodule's address#>"}
         Results_240B_4_Address : UINT;
         {#ix-set:AttributeName = "<#'Results_240B_4' submodule's length#>"}
         Results_240B_4_Length : UINT;
         {#ix-set:AttributeName = "<#Hardware ID 'Results_240B_5' submodule#>"}
         HW_Results_240B_5    : UINT;
         {#ix-set:AttributeName = "<#'Results_240B_5' submodule's address#>"}
         Results_240B_5_Address : UINT;
         {#ix-set:AttributeName = "<#'Results_240B_5' submodule's length#>"}
         Results_240B_5_Length : UINT;
         {#ix-set:AttributeName = "<#Hardware ID 'Results_64B_1' submodule#>"}
         HW_Results_64B_1    : UINT;
         {#ix-set:AttributeName = "<#'Results_64B_1' submodule's address#>"}
         Results_64B_1_Address : UINT;
         {#ix-set:AttributeName = "<#'Results_64B_1' submodule's length#>"}
         Results_64B_1_Length : UINT;
      END_VAR
   END_CLASS
END_NAMESPACE
