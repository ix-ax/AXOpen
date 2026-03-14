NAMESPACE AXOpen.Components.Siem.Identification
   {S7.extern=ReadWrite}
	CLASS AxoSimaticIdentCyclic_HWIDs 
      VAR PUBLIC
         {#ix-set:AttributeName = "<#Hardware ID 'Head' submodule#>"}
         HW_Head              :  UINT;
         {#ix-set:AttributeName = "<#Hardware ID 'CM' submodule#>"}
         HwID_CM              :   UINT;
         {#ix-set:AttributeName = "<#Hardware ID 'Reader' submodule#>"}
         HwID_Reader          :   UINT;
      END_VAR
   END_CLASS
END_NAMESPACE
