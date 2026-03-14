NAMESPACE AXOpen.Components.Rexroth.Drives
   {S7.extern=ReadWrite}
	CLASS AxoCtrlxDriveXscHWIDs 
      VAR PUBLIC
         {#ix-set:AttributeName = "<#Hardware ID Device#>"}
         HW_Device            : UINT;
         {#ix-set:AttributeName = "<#Hardware ID 'Outputs' module#>"}
         HW_Outputs           : UINT;
         {#ix-set:AttributeName = "<#Hardware ID 'Inputs' module#>"}
         HW_Inputs            : UINT;
         {#ix-set:AttributeName = "<#Hardware ID 'S_0_0134_0_0__Servodrive_profile__Control_word' submodule#>"}
         HW_S_0_0134_0_0      : UINT;
         {#ix-set:AttributeName = "<#Hardware ID 'S_0_0145_0_0__Signal_control_word__Value' submodule#>"}
         HW_S_0_0145_0_0      : UINT;
         {#ix-set:AttributeName = "<#Hardware ID 'S_0_0282_0_0__Drive_controlled_positioning__Command_value' submodule#>"}
         HW_S_0_0282_0_0      : UINT;
         {#ix-set:AttributeName = "<#Hardware ID 'S_0_0259_0_0__Positioning_profile__Profile_velocity' submodule#>"}
         HW_S_0_0259_0_0      : UINT;
         {#ix-set:AttributeName = "<#Hardware ID 'S_0_0260_0_0__Positioning_profile__Acceleration' submodule#>"}
         HW_S_0_0260_0_0      : UINT;
         {#ix-set:AttributeName = "<#Hardware ID 'S_0_0359_0_0__Positioning_profile__Deceleration' submodule#>"}
         HW_S_0_0359_0_0      : UINT;
         {#ix-set:AttributeName = "<#Hardware ID 'S_0_1720_0_1__Power_supply_control__Control_word' submodule#>"}
         HW_S_0_1720_0_1      : UINT;
         {#ix-set:AttributeName = "<#Hardware ID 'S_0_0092_0_0__Torque_force_limitation__Limit_value_bipolar' submodule#>"}
         HW_S_0_0092_0_0      : UINT;
         {#ix-set:AttributeName = "<#Hardware ID 'S_0_0080_0_0__Torque_force_command_value' submodule#>"}
         HW_S_0_0080_0_0      : UINT;
         {#ix-set:AttributeName = "<#Hardware ID 'S_0_0193_0_0__Positioning_jerk' submodule#>"}
         HW_S_0_0193_0_0      : UINT;
         {#ix-set:AttributeName = "<#Hardware ID 'S_0_0135_0_0__Servodrive_profile__Status_word' submodule#>"}
         HW_S_0_0135_0_0      : UINT;
         {#ix-set:AttributeName = "<#Hardware ID 'S_0_0144_0_0__Signal_status_word__Value' submodule#>"}
         HW_S_0_0144_0_0      : UINT;
         {#ix-set:AttributeName = "<#Hardware ID 'S_0_0386_0_0__Position_controller__Position_actual_value' submodule#>"}
         HW_S_0_0386_0_0      : UINT;
         {#ix-set:AttributeName = "<#Hardware ID 'S_0_0535_0_0__Velocity_controller__Velocity_actual_value' submodule#>"}
         HW_S_0_0535_0_0      : UINT;
         {#ix-set:AttributeName = "<#Hardware ID 'S_0_0390_0_0__Diagnostic_message__Manufacturer_status_register' submodule#>"}
         HW_S_0_0390_0_0      : UINT;
         {#ix-set:AttributeName = "<#Hardware ID 'S_0_1720_0_2__Power_supply_control__Status_word' submodule#>"}
         HW_S_0_1720_0_2      : UINT;
         {#ix-set:AttributeName = "<#Hardware ID 'S_0_0084_0_0__Torque_force_feedback_value' submodule#>"}
         HW_S_0_0084_0_0      : UINT;
         {#ix-set:AttributeName = "<#Hardware ID 'P_0_0106_0_0__STO_function__Operating_status' submodule#>"}
         HW_P_0_0106_0_0      : UINT;
      END_VAR
   END_CLASS
END_NAMESPACE
