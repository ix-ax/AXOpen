NAMESPACE AXOpen.Components.Rexroth.Press.v_4_x_x
   {S7.extern=ReadWrite}
	CLASS AxoSmartFunctionKit_HWIDs
      VAR PUBLIC
         {#ix-set:AttributeName = "<#Hardware ID Device#>"}
         HW_Device            : UINT;
         {#ix-set:AttributeName = "<#Hardware ID 'ParamCh_IDN' module#>"}
         HW_ParamCh_IDN           : UINT;
         {#ix-set:AttributeName = "<#Hardware ID 'F_ModulNotUsed' module#>"}
         HW_F_ModulNotUsed            : UINT;
         {#ix-set:AttributeName = "<#Hardware ID 'Input_24_Words' submodule#>"}
         HW_Input_24_Words      : UINT;
         {#ix-set:AttributeName = "<#Hardware ID 'Output_21_Words' submodule#>"}
         HW_Output_21_Words      : UINT;
      END_VAR
   END_CLASS
END_NAMESPACE
