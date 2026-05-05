NAMESPACE AXOpen.Showcase
    TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
        Outputs : STRUCT
	        // Module abb_irc5_robot/DO_64_bytes
	        abb_irc5_robot_DO_64_bytes_Output AT %B3703 : abb_irc5_robot_DO_64_bytes_Output_Layout;

	        // Module abb_omnicore_robot/DO_64_bytes
	        abb_omnicore_robot_DO_64_bytes_Output AT %B3639 : abb_omnicore_robot_DO_64_bytes_Output_Layout;

	        // Module aes_pnio/Slot_1
	        aes_pnio_Slot_1_Output AT %B0 : aes_pnio_Slot_1_Output_Layout;

	        BNIPNT507005Z040_BIS_M_4XX_045_1_Output AT %B295 : BNIPNT507005Z040_BIS_M_4XX_045_1_Output_Layout;

	        // Module cognex_dataman_280/Acquisition_Control
	        cognex_dataman_280_Acquisition_Control_Output AT %B3055 : cognex_dataman_280_Acquisition_Control_Output_Layout;

	        // Module cognex_dataman_280/Results_Control
	        cognex_dataman_280_Results_Control_Output AT %B3054 : cognex_dataman_280_Results_Control_Output_Layout;

	        cognex_dataman_280_Soft_Event_Control_Output AT %B3053 : cognex_dataman_280_Soft_Event_Control_Output_Layout;

	        // Module cognex_dataman_280/UserData_128
	        cognex_dataman_280_UserData_128_Output AT %B2921 : cognex_dataman_280_UserData_128_Output_Layout;

	        // Module cognex_dataman_380/Acquisition_Control
	        cognex_dataman_380_Acquisition_Control_Output AT %B2920 : cognex_dataman_380_Acquisition_Control_Output_Layout;

	        // Module cognex_dataman_380/Results_Control
	        cognex_dataman_380_Results_Control_Output AT %B2919 : cognex_dataman_380_Results_Control_Output_Layout;

	        cognex_dataman_380_Soft_Event_Control_Output AT %B2918 : cognex_dataman_380_Soft_Event_Control_Output_Layout;

	        // Module cognex_dataman_380/UserData_128
	        cognex_dataman_380_UserData_128_Output AT %B2786 : cognex_dataman_380_UserData_128_Output_Layout;

	        // Module cognex_insight_2800/Slot_1
	        cognex_insight_2800_Slot_1_Output AT %B2785 : cognex_insight_2800_Slot_1_Output_Layout;

	        // Module cognex_insight_2800/Slot_3
	        cognex_insight_2800_Slot_3_Output AT %B2784 : cognex_insight_2800_Slot_3_Output_Layout;

	        cognex_insight_2800_Slot_5_Output AT %B2781 : cognex_insight_2800_Slot_5_Output_Layout;

	        cognex_insight_2800_Slot_6_Output AT %B2783 : cognex_insight_2800_Slot_6_Output_Layout;

	        // Module cognex_insight_2800/Slot_7
	        cognex_insight_2800_Slot_7_Output AT %B2527 : cognex_insight_2800_Slot_7_Output_Layout;

	        // Module cognex_insight_2800/Slot_8
	        cognex_insight_2800_Slot_8_Output AT %B2273 : cognex_insight_2800_Slot_8_Output_Layout;

	        // Module cognex_insight_2800/Slot_9
	        cognex_insight_2800_Slot_9_Output AT %B2019 : cognex_insight_2800_Slot_9_Output_Layout;

	        // Module cognex_insight_7600/Acquisition_Control
	        cognex_insight_7600_Acquisition_Control_Output AT %B3188 : cognex_insight_7600_Acquisition_Control_Output_Layout;

	        cognex_insight_7600_Command_Control_Output AT %B3184 : cognex_insight_7600_Command_Control_Output_Layout;

	        // Module cognex_insight_7600/Inspection_Control
	        cognex_insight_7600_Inspection_Control_Output AT %B3187 : cognex_insight_7600_Inspection_Control_Output_Layout;

	        cognex_insight_7600_SoftEvent_Control_Output AT %B3186 : cognex_insight_7600_SoftEvent_Control_Output_Layout;

	        // Module cognex_insight_7600/UserData_128
	        cognex_insight_7600_UserData_128_Output AT %B3056 : cognex_insight_7600_UserData_128_Output_Layout;

	        // Module desoutter_cvic_ii/Output_1_byte_1
	        desoutter_cvic_ii_Output_1_byte_1_Output AT %B446 : desoutter_cvic_ii_Output_1_byte_1_Output_Layout;

	        // Module desoutter_cvic_ii/Output_1_byte_2
	        desoutter_cvic_ii_Output_1_byte_2_Output AT %B445 : desoutter_cvic_ii_Output_1_byte_2_Output_Layout;

	        // Module dukaneiqauto/PLC_to_iQ_Outputs
	        dukaneiqauto_PLC_to_iQ_Outputs_Output AT %B425 : dukaneiqauto_PLC_to_iQ_Outputs_Output_Layout;

	        et200sp_CM_4xIO_Link_RF200_CM_4xIO_Link_V2_2_144I_128O_1_Output AT %B163 : et200sp_CM_4xIO_Link_RF200_CM_4xIO_Link_V2_2_144I_128O_1_Output_Layout;

	        festo_cmmtas_DoServo_SiemensTelegram111_PZD_12_12_Output AT %B3255 : festo_cmmtas_DoServo_SiemensTelegram111_PZD_12_12_Output_Layout;

	        festo_cmmtas_DoServo_SiemensTelegram750_PZD_4_1_Output AT %B3279 : festo_cmmtas_DoServo_SiemensTelegram750_PZD_4_1_Output_Layout;

	        // Module keyence_iv3/CommandControl
	        keyence_iv3_CommandControl_Output AT %B453 : keyence_iv3_CommandControl_Output_Layout;

	        // Module keyence_sr_1000/CompletionClearControl
	        keyence_sr_1000_CompletionClearControl_Output AT %B597 : keyence_sr_1000_CompletionClearControl_Output_Layout;

	        // Module keyence_sr_1000/LatchAndErrorClearControl
	        keyence_sr_1000_LatchAndErrorClearControl_Output AT %B599 : keyence_sr_1000_LatchAndErrorClearControl_Output_Layout;

	        // Module keyence_sr_1000/OperationInstructionControl
	        keyence_sr_1000_OperationInstructionControl_Output AT %B598 : keyence_sr_1000_OperationInstructionControl_Output_Layout;

	        // Module keyence_sr_1000/ParameterBank
	        keyence_sr_1000_ParameterBank_Output AT %B595 : keyence_sr_1000_ParameterBank_Output_Layout;

	        // Module keyence_sr_1000/UserData_128
	        keyence_sr_1000_UserData_128_Output AT %B465 : keyence_sr_1000_UserData_128_Output_Layout;

	        // Module keyence_sr_750/CompletionClearControl
	        keyence_sr_750_CompletionClearControl_Output AT %B732 : keyence_sr_750_CompletionClearControl_Output_Layout;

	        // Module keyence_sr_750/LatchAndErrorClearControl
	        keyence_sr_750_LatchAndErrorClearControl_Output AT %B734 : keyence_sr_750_LatchAndErrorClearControl_Output_Layout;

	        // Module keyence_sr_750/OperationInstructionControl
	        keyence_sr_750_OperationInstructionControl_Output AT %B733 : keyence_sr_750_OperationInstructionControl_Output_Layout;

	        // Module keyence_sr_750/ParameterBank
	        keyence_sr_750_ParameterBank_Output AT %B730 : keyence_sr_750_ParameterBank_Output_Layout;

	        // Module keyence_sr_750/UserData_128
	        keyence_sr_750_UserData_128_Output AT %B600 : keyence_sr_750_UserData_128_Output_Layout;

	        kuka_rb1_DIO512_Output AT %B3575 : kuka_rb1_DIO512_Output_Layout;

	        kuka_rb2_DIO512_Output AT %B3767 : kuka_rb2_DIO512_Output_Layout;

	        mitsubishi_tz535_robot_In_Out_64_byte_Output AT %B3511 : mitsubishi_tz535_robot_In_Out_64_byte_Output_Layout;

	        // Module rexroth_cs351/Output_2_word_1
	        rexroth_cs351_Output_2_word_1_Output AT %B305 : rexroth_cs351_Output_2_word_1_Output_Layout;

	        // Module rexroth_cs351/Output_4_word_1
	        rexroth_cs351_Output_4_word_1_Output AT %B365 : rexroth_cs351_Output_4_word_1_Output_Layout;

	        // Module rexroth_cs351/Output_4_word_2
	        rexroth_cs351_Output_4_word_2_Output AT %B357 : rexroth_cs351_Output_4_word_2_Output_Layout;

	        // Module rexroth_cs351/Output_4_word_3
	        rexroth_cs351_Output_4_word_3_Output AT %B349 : rexroth_cs351_Output_4_word_3_Output_Layout;

	        // Module rexroth_cs351/Output_4_word_4
	        rexroth_cs351_Output_4_word_4_Output AT %B341 : rexroth_cs351_Output_4_word_4_Output_Layout;

	        // Module rexroth_cs351/Output_4_word_5
	        rexroth_cs351_Output_4_word_5_Output AT %B333 : rexroth_cs351_Output_4_word_5_Output_Layout;

	        // Module rexroth_cs351/Output_4_word_6
	        rexroth_cs351_Output_4_word_6_Output AT %B325 : rexroth_cs351_Output_4_word_6_Output_Layout;

	        // Module rexroth_cs351/Output_4_word_7
	        rexroth_cs351_Output_4_word_7_Output AT %B317 : rexroth_cs351_Output_4_word_7_Output_Layout;

	        // Module rexroth_cs351/Output_4_word_8
	        rexroth_cs351_Output_4_word_8_Output AT %B309 : rexroth_cs351_Output_4_word_8_Output_Layout;

	        // Module rexroth_ctrlx_drive/Outputs
	        rexroth_ctrlx_drive_Outputs_S_0_0080_0_0__Torque_force_command_value_Output AT %B3213 : rexroth_ctrlx_drive_Outputs_S_0_0080_0_0__Torque_force_command_value_Output_Layout;

	        rexroth_ctrlx_drive_Outputs_S_0_0092_0_0__Torque_force_limitation__Limit_value_bipolar_Output AT %B3211 : rexroth_ctrlx_drive_Outputs_S_0_0092_0_0__Torque_force_limitation__Limit_value_bipolar_Output_Layout;

	        rexroth_ctrlx_drive_Outputs_S_0_0134_0_0__Master_control_word__Value_Output AT %B3189 : rexroth_ctrlx_drive_Outputs_S_0_0134_0_0__Master_control_word__Value_Output_Layout;

	        rexroth_ctrlx_drive_Outputs_S_0_0145_0_0__Signal_control_word__Value_Output AT %B3207 : rexroth_ctrlx_drive_Outputs_S_0_0145_0_0__Signal_control_word__Value_Output_Layout;

	        rexroth_ctrlx_drive_Outputs_S_0_0193_0_0__Positioning_jerk_Output AT %B3215 : rexroth_ctrlx_drive_Outputs_S_0_0193_0_0__Positioning_jerk_Output_Layout;

	        rexroth_ctrlx_drive_Outputs_S_0_0259_0_0__Positioning_profile__Profile_velocity_Output AT %B3203 : rexroth_ctrlx_drive_Outputs_S_0_0259_0_0__Positioning_profile__Profile_velocity_Output_Layout;

	        rexroth_ctrlx_drive_Outputs_S_0_0260_0_0__Positioning_profile__Acceleration_Output AT %B3191 : rexroth_ctrlx_drive_Outputs_S_0_0260_0_0__Positioning_profile__Acceleration_Output_Layout;

	        rexroth_ctrlx_drive_Outputs_S_0_0282_0_0__Drive_controlled_positioning__Command_value_Output AT %B3195 : rexroth_ctrlx_drive_Outputs_S_0_0282_0_0__Drive_controlled_positioning__Command_value_Output_Layout;

	        rexroth_ctrlx_drive_Outputs_S_0_0359_0_0__Positioning_profile__Deceleration_Output AT %B3199 : rexroth_ctrlx_drive_Outputs_S_0_0359_0_0__Positioning_profile__Deceleration_Output_Layout;

	        rexroth_ctrlx_drive_Outputs_S_0_1720_0_1__Power_supply_control__Control_word_Output AT %B3209 : rexroth_ctrlx_drive_Outputs_S_0_1720_0_1__Power_supply_control__Control_word_Output_Layout;

	        // Module rexroth_indradrive/Output_13_Words
	        rexroth_indradrive_Output_13_Words_Output AT %B3219 : rexroth_indradrive_Output_13_Words_Output_Layout;

	        rexroth_indradrive_ParamCh_5Words_Output AT %B3245 : rexroth_indradrive_ParamCh_5Words_Output_Layout;

	        // Module rexroth_press/Output_21_Words
	        rexroth_press_Output_21_Words_Output AT %B373 : rexroth_press_Output_21_Words_Output_Layout;

	        rexroth_press_ParamCh_5Words_Output AT %B415 : rexroth_press_ParamCh_5Words_Output_Layout;

	        rf186c_CM_1_Output AT %B293 : rf186c_CM_1_Output_Layout;

	        rf186c_cyc_CM_Output AT %B161 : rf186c_cyc_CM_Output_Layout;

	        rf186c_cyc_RF260R_1_Output AT %B129 : rf186c_cyc_RF260R_1_Output_Layout;

	        rf186c_cyc_RF340R_1_Output AT %B1 : rf186c_cyc_RF340R_1_Output_Layout;

	        rf186c_Reader_1_Output AT %B291 : rf186c_Reader_1_Output_Layout;

	        // Module ureol2l/10_O2T_General_Purpose_Registers_2
	        ureol2l_10_O2T_General_Purpose_Registers_2_Output AT %B3287 : ureol2l_10_O2T_General_Purpose_Registers_2_Output_Layout;

	        // Module ureol2l/8_O2T_Robot_IO
	        ureol2l_8_O2T_Robot_IO_Output AT %B3487 : ureol2l_8_O2T_Robot_IO_Output_Layout;

	        // Module ureol2l/9_O2T_General_Purpose_Registers_1
	        ureol2l_9_O2T_General_Purpose_Registers_1_Output AT %B3387 : ureol2l_9_O2T_General_Purpose_Registers_1_Output_Layout;

	        vision_pro_Engine_Control_1_Output AT %B2002 : vision_pro_Engine_Control_1_Output_Layout;

	        vision_pro_Engine_Control_2_Output AT %B2001 : vision_pro_Engine_Control_2_Output_Layout;

	        vision_pro_Engine_Control_3_Output AT %B2000 : vision_pro_Engine_Control_3_Output_Layout;

	        vision_pro_Engine_Control_4_Output AT %B1999 : vision_pro_Engine_Control_4_Output_Layout;

	        vision_pro_System_Control_Output AT %B2003 : vision_pro_System_Control_Output_Layout;

	        // Module vision_pro/User_Data_240_bytes_1
	        vision_pro_User_Data_240_bytes_1_Output AT %B1759 : vision_pro_User_Data_240_bytes_1_Output_Layout;

	        // Module vision_pro/User_Data_240_bytes_2
	        vision_pro_User_Data_240_bytes_2_Output AT %B1519 : vision_pro_User_Data_240_bytes_2_Output_Layout;

	        // Module vision_pro/User_Data_240_bytes_3
	        vision_pro_User_Data_240_bytes_3_Output AT %B1279 : vision_pro_User_Data_240_bytes_3_Output_Layout;

	        // Module vision_pro/User_Data_240_bytes_4
	        vision_pro_User_Data_240_bytes_4_Output AT %B1039 : vision_pro_User_Data_240_bytes_4_Output_Layout;

	        // Module vision_pro/User_Data_240_bytes_5
	        vision_pro_User_Data_240_bytes_5_Output AT %B799 : vision_pro_User_Data_240_bytes_5_Output_Layout;

	        // Module vision_pro/User_Data_64_bytes_1
	        vision_pro_User_Data_64_bytes_1_Output AT %B735 : vision_pro_User_Data_64_bytes_1_Output_Layout;

	        zebra_Data88Bin6Bout_Output AT %B447 : zebra_Data88Bin6Bout_Output_Layout;

        END_STRUCT;
    END_TYPE
END_NAMESPACE

