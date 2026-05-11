NAMESPACE AXOpen.Components.Abb.Robotics.v_1_x_x
{S7.extern=ReadWrite}
CLASS AxoIrc5_HWIDs 
  VAR PUBLIC
     {#ix-set:AttributeName = "<#Hardware ID of the device#>"}
     HW_Device              :  UINT;
     {#ix-set:AttributeName = "<#Hardware ID of the 'DI_64_bytes' submodule#>"}
     HwID_DI_64_bytes       :   UINT;
     {#ix-set:AttributeName = "<#Hardware ID of the 'DO_64_bytes' submodule#>"}
     HwID_DO_64_bytes          :   UINT;
  END_VAR
END_CLASS
END_NAMESPACE
