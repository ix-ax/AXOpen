NAMESPACE AXOpen.Components.Rexroth.Drives
    TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
        Outputs : STRUCT
	        // Module AxoCtrlxDriveXsc/Outputs
	        AxoCtrlxDriveXsc_Outputs_S_0_0080_0_0__Torque_force_command_value_Output AT %B24 : AxoCtrlxDriveXsc_Outputs_S_0_0080_0_0__Torque_force_command_value_Output_Layout;

	        AxoCtrlxDriveXsc_Outputs_S_0_0092_0_0__Torque_force_limitation__Limit_value_bipolar_Output AT %B22 : AxoCtrlxDriveXsc_Outputs_S_0_0092_0_0__Torque_force_limitation__Limit_value_bipolar_Output_Layout;

	        AxoCtrlxDriveXsc_Outputs_S_0_0134_0_0__Master_control_word__Value_Output AT %B0 : AxoCtrlxDriveXsc_Outputs_S_0_0134_0_0__Master_control_word__Value_Output_Layout;

	        AxoCtrlxDriveXsc_Outputs_S_0_0145_0_0__Signal_control_word__Value_Output AT %B18 : AxoCtrlxDriveXsc_Outputs_S_0_0145_0_0__Signal_control_word__Value_Output_Layout;

	        AxoCtrlxDriveXsc_Outputs_S_0_0193_0_0__Positioning_jerk_Output AT %B26 : AxoCtrlxDriveXsc_Outputs_S_0_0193_0_0__Positioning_jerk_Output_Layout;

	        AxoCtrlxDriveXsc_Outputs_S_0_0259_0_0__Positioning_profile__Profile_velocity_Output AT %B14 : AxoCtrlxDriveXsc_Outputs_S_0_0259_0_0__Positioning_profile__Profile_velocity_Output_Layout;

	        AxoCtrlxDriveXsc_Outputs_S_0_0260_0_0__Positioning_profile__Acceleration_Output AT %B2 : AxoCtrlxDriveXsc_Outputs_S_0_0260_0_0__Positioning_profile__Acceleration_Output_Layout;

	        AxoCtrlxDriveXsc_Outputs_S_0_0282_0_0__Drive_controlled_positioning__Command_value_Output AT %B6 : AxoCtrlxDriveXsc_Outputs_S_0_0282_0_0__Drive_controlled_positioning__Command_value_Output_Layout;

	        AxoCtrlxDriveXsc_Outputs_S_0_0359_0_0__Positioning_profile__Deceleration_Output AT %B10 : AxoCtrlxDriveXsc_Outputs_S_0_0359_0_0__Positioning_profile__Deceleration_Output_Layout;

	        AxoCtrlxDriveXsc_Outputs_S_0_1720_0_1__Power_supply_control__Control_word_Output AT %B20 : AxoCtrlxDriveXsc_Outputs_S_0_1720_0_1__Power_supply_control__Control_word_Output_Layout;

	        // Module ST3_indradrive/Output_13_Words
	        ST3_indradrive_Output_13_Words_Output AT %B30 : ST3_indradrive_Output_13_Words_Output_Layout;

	        ST3_indradrive_ParamCh_5Words_Output AT %B56 : ST3_indradrive_ParamCh_5Words_Output_Layout;

        END_STRUCT;
    END_TYPE
END_NAMESPACE

