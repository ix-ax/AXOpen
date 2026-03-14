NAMESPACE AXOpen.Components.Rexroth.Drives
    TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
        Inputs : STRUCT
	        // Module rexroth_ctrlx_drive/Inputs
	        rexroth_ctrlx_drive_Inputs_P_0_0106_0_0__STO_function__Operating_status_Input AT %B20 : rexroth_ctrlx_drive_Inputs_P_0_0106_0_0__STO_function__Operating_status_Input_Layout;

	        rexroth_ctrlx_drive_Inputs_S_0_0084_0_0__Torque_force_feedback_value_Input AT %B18 : rexroth_ctrlx_drive_Inputs_S_0_0084_0_0__Torque_force_feedback_value_Input_Layout;

	        rexroth_ctrlx_drive_Inputs_S_0_0135_0_0__Drive_status_word__Value_Input AT %B12 : rexroth_ctrlx_drive_Inputs_S_0_0135_0_0__Drive_status_word__Value_Input_Layout;

	        rexroth_ctrlx_drive_Inputs_S_0_0144_0_0__Signal_status_word__Value_Input AT %B14 : rexroth_ctrlx_drive_Inputs_S_0_0144_0_0__Signal_status_word__Value_Input_Layout;

	        rexroth_ctrlx_drive_Inputs_S_0_0386_0_0__Position_controller__Position_actual_value_Input AT %B0 : rexroth_ctrlx_drive_Inputs_S_0_0386_0_0__Position_controller__Position_actual_value_Input_Layout;

	        rexroth_ctrlx_drive_Inputs_S_0_0390_0_0__Diagnostic_message__Manufacturer_status_register_Input AT %B8 : rexroth_ctrlx_drive_Inputs_S_0_0390_0_0__Diagnostic_message__Manufacturer_status_register_Input_Layout;

	        rexroth_ctrlx_drive_Inputs_S_0_0535_0_0__Velocity_controller__Velocity_actual_value_Input AT %B4 : rexroth_ctrlx_drive_Inputs_S_0_0535_0_0__Velocity_controller__Velocity_actual_value_Input_Layout;

	        rexroth_ctrlx_drive_Inputs_S_0_1720_0_2__Power_supply_control__Status_word_Input AT %B16 : rexroth_ctrlx_drive_Inputs_S_0_1720_0_2__Power_supply_control__Status_word_Input_Layout;

	        // Module rexroth_indradrive/Input_9_Words
	        rexroth_indradrive_Input_9_Words_Input AT %B22 : rexroth_indradrive_Input_9_Words_Input_Layout;

	        // Module rexroth_indradrive/ParamCh_5Words
	        rexroth_indradrive_ParamCh_5Words_Input AT %B40 : rexroth_indradrive_ParamCh_5Words_Input_Layout;

        END_STRUCT;
    END_TYPE
END_NAMESPACE

