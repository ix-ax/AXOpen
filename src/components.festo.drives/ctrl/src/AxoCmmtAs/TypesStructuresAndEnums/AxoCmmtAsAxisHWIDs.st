NAMESPACE AXOpen.Components.Festo.Drives
   {S7.extern=ReadWrite}
	CLASS AxoCmmtAsAxisHWIDs 
      VAR PUBLIC
         {#ix-set:AttributeName = "<#Hardware ID Device#>"}
         HW_Device            : UINT;
         {#ix-set:AttributeName = "<#Hardware ID 'DoServo' module#>"}
         HW_DoServo           : UINT;
         {#ix-set:AttributeName = "<#Hardware ID 'DoServo' submodule#>"}
         HW_DoServoSub           : UINT;
         {#ix-set:AttributeName = "<#Hardware ID 'ModuleAccessPoint' module#>"}
         HW_ModuleAccessPoint : UINT;
         {#ix-set:AttributeName = "<#Hardware ID 'EmptyModule_1' submodule#>"}
         HW_EmptyModule_1     : UINT;
         {#ix-set:AttributeName = "<#Hardware ID 'Telegram111' submodule#>"}
         HW_Telegram111       : UINT;
         {#ix-set:AttributeName = "<#Hardware ID 'EmptyModule_2' submodule#>"}
         HW_EmptyModule_2     : UINT;
         {#ix-set:AttributeName = "<#Hardware ID 'Telegram750' submodule#>"}
         HW_Telegram750       : UINT;
      END_VAR
   END_CLASS
END_NAMESPACE
