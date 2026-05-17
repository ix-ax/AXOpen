NAMESPACE AXOpen.Components.Dukane.Welders
   {S7.extern=ReadWrite}
	CLASS Axo_IQ_SeriesWelder_HWIDs 
      VAR PUBLIC
         {#ix-set:AttributeName = "<#Hardware ID  of the device#>"}
         HW_Device              :  UINT;
         {#ix-set:AttributeName = "<#Hardware ID of the 'iQ_to_PLC_Inputs' submodule#>"}
         HwID_iQ_to_PLC_Inputs  :   UINT;
         {#ix-set:AttributeName = "<#Hardware ID of the 'out_1' submodule#>"}
         HwID_PLC_to_iQ_Outputs           :   UINT;
      END_VAR
   END_CLASS
END_NAMESPACE
