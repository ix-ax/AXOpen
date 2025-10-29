NAMESPACE AXOpen.Components.Rexroth.Drives
    TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
        Outputs : STRUCT
	        // Module rexroth_ctrlx_drive/Outputs
	        rexroth_ctrlx_drive_Outputs_S_0_0080_0_0__Torque_force_command_value_Output AT %B24 : rexroth_ctrlx_drive_Outputs_S_0_0080_0_0__Torque_force_command_value_Output_Layout;

	        rexroth_ctrlx_drive_Outputs_S_0_0092_0_0__Torque_force_limitation__Limit_value_bipolar_Output AT %B22 : rexroth_ctrlx_drive_Outputs_S_0_0092_0_0__Torque_force_limitation__Limit_value_bipolar_Output_Layout;

	        rexroth_ctrlx_drive_Outputs_S_0_0134_0_0__Master_control_word__Value_Output AT %B0 : rexroth_ctrlx_drive_Outputs_S_0_0134_0_0__Master_control_word__Value_Output_Layout;

	        rexroth_ctrlx_drive_Outputs_S_0_0145_0_0__Signal_control_word__Value_Output AT %B18 : rexroth_ctrlx_drive_Outputs_S_0_0145_0_0__Signal_control_word__Value_Output_Layout;

	        rexroth_ctrlx_drive_Outputs_S_0_0193_0_0__Positioning_jerk_Output AT %B26 : rexroth_ctrlx_drive_Outputs_S_0_0193_0_0__Positioning_jerk_Output_Layout;

	        rexroth_ctrlx_drive_Outputs_S_0_0259_0_0__Positioning_profile__Profile_velocity_Output AT %B14 : rexroth_ctrlx_drive_Outputs_S_0_0259_0_0__Positioning_profile__Profile_velocity_Output_Layout;

	        rexroth_ctrlx_drive_Outputs_S_0_0260_0_0__Positioning_profile__Acceleration_Output AT %B2 : rexroth_ctrlx_drive_Outputs_S_0_0260_0_0__Positioning_profile__Acceleration_Output_Layout;

	        rexroth_ctrlx_drive_Outputs_S_0_0282_0_0__Drive_controlled_positioning__Command_value_Output AT %B6 : rexroth_ctrlx_drive_Outputs_S_0_0282_0_0__Drive_controlled_positioning__Command_value_Output_Layout;

	        rexroth_ctrlx_drive_Outputs_S_0_0359_0_0__Positioning_profile__Deceleration_Output AT %B10 : rexroth_ctrlx_drive_Outputs_S_0_0359_0_0__Positioning_profile__Deceleration_Output_Layout;

	        rexroth_ctrlx_drive_Outputs_S_0_1720_0_1__Power_supply_control__Control_word_Output AT %B20 : rexroth_ctrlx_drive_Outputs_S_0_1720_0_1__Power_supply_control__Control_word_Output_Layout;

	        // Module rexroth_indradrive/Output_13_Words
	        rexroth_indradrive_Output_13_Words_Output AT %B30 : rexroth_indradrive_Output_13_Words_Output_Layout;

	        rexroth_indradrive_ParamCh_5Words_Output AT %B56 : rexroth_indradrive_ParamCh_5Words_Output_Layout;

        END_STRUCT;
    END_TYPE
END_NAMESPACE

