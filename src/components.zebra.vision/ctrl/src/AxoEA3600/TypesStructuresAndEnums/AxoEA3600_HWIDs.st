NAMESPACE AXOpen.Components.Zebra.Vision
   {S7.extern=ReadWrite}
	CLASS AxoEA3600_HWIDs 
      VAR PUBLIC
         {#ix-set:AttributeName = "<#Hardware ID  of the device#>"}
         HW_Device              :  UINT;
         {#ix-set:AttributeName = "<#Hardware ID of the 'BarcodeData_v2' submodule#>"}
         HwID_BarcodeData_v2            :   UINT;
      END_VAR
   END_CLASS
END_NAMESPACE
