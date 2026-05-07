NAMESPACE AXOpen.Showcase
    TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
        Outputs : STRUCT
	        // Module abb_irc5_robot/DO_64_bytes
	        abb_irc5_robot_DO_64_bytes_Output AT %B3773 : abb_irc5_robot_DO_64_bytes_Output_Layout;

	        // Module abb_omnicore_robot/DO_64_bytes
	        abb_omnicore_robot_DO_64_bytes_Output AT %B3709 : abb_omnicore_robot_DO_64_bytes_Output_Layout;

	        // Module aes_pnio/Slot_1
	        aes_pnio_Slot_1_Output AT %B6 : aes_pnio_Slot_1_Output_Layout;

	        BNIPNT507005Z040_BIS_M_4XX_045_1_Output AT %B301 : BNIPNT507005Z040_BIS_M_4XX_045_1_Output_Layout;

	        // Module cognex_dataman_280/Acquisition_Control
	        cognex_dataman_280_Acquisition_Control_Output AT %B3061 : cognex_dataman_280_Acquisition_Control_Output_Layout;

	        // Module cognex_dataman_280/Results_Control
	        cognex_dataman_280_Results_Control_Output AT %B3060 : cognex_dataman_280_Results_Control_Output_Layout;

	        cognex_dataman_280_Soft_Event_Control_Output AT %B3059 : cognex_dataman_280_Soft_Event_Control_Output_Layout;

	        // Module cognex_dataman_280/UserData_128
	        cognex_dataman_280_UserData_128_Output AT %B2927 : cognex_dataman_280_UserData_128_Output_Layout;

	        // Module cognex_dataman_380/Acquisition_Control
	        cognex_dataman_380_Acquisition_Control_Output AT %B2926 : cognex_dataman_380_Acquisition_Control_Output_Layout;

	        // Module cognex_dataman_380/Results_Control
	        cognex_dataman_380_Results_Control_Output AT %B2925 : cognex_dataman_380_Results_Control_Output_Layout;

	        cognex_dataman_380_Soft_Event_Control_Output AT %B2924 : cognex_dataman_380_Soft_Event_Control_Output_Layout;

	        // Module cognex_dataman_380/UserData_128
	        cognex_dataman_380_UserData_128_Output AT %B2792 : cognex_dataman_380_UserData_128_Output_Layout;

	        // Module cognex_insight_2800/Slot_1
	        cognex_insight_2800_Slot_1_Output AT %B2791 : cognex_insight_2800_Slot_1_Output_Layout;

	        // Module cognex_insight_2800/Slot_3
	        cognex_insight_2800_Slot_3_Output AT %B2790 : cognex_insight_2800_Slot_3_Output_Layout;

	        cognex_insight_2800_Slot_5_Output AT %B2787 : cognex_insight_2800_Slot_5_Output_Layout;

	        cognex_insight_2800_Slot_6_Output AT %B2789 : cognex_insight_2800_Slot_6_Output_Layout;

	        // Module cognex_insight_2800/Slot_7
	        cognex_insight_2800_Slot_7_Output AT %B2533 : cognex_insight_2800_Slot_7_Output_Layout;

	        // Module cognex_insight_2800/Slot_8
	        cognex_insight_2800_Slot_8_Output AT %B2279 : cognex_insight_2800_Slot_8_Output_Layout;

	        // Module cognex_insight_2800/Slot_9
	        cognex_insight_2800_Slot_9_Output AT %B2025 : cognex_insight_2800_Slot_9_Output_Layout;

	        // Module cognex_insight_7600/Acquisition_Control
	        cognex_insight_7600_Acquisition_Control_Output AT %B3194 : cognex_insight_7600_Acquisition_Control_Output_Layout;

	        cognex_insight_7600_Command_Control_Output AT %B3190 : cognex_insight_7600_Command_Control_Output_Layout;

	        // Module cognex_insight_7600/Inspection_Control
	        cognex_insight_7600_Inspection_Control_Output AT %B3193 : cognex_insight_7600_Inspection_Control_Output_Layout;

	        cognex_insight_7600_SoftEvent_Control_Output AT %B3192 : cognex_insight_7600_SoftEvent_Control_Output_Layout;

	        // Module cognex_insight_7600/UserData_128
	        cognex_insight_7600_UserData_128_Output AT %B3062 : cognex_insight_7600_UserData_128_Output_Layout;

	        // Module desoutter_cvic_ii/Output_1_byte_1
	        desoutter_cvic_ii_Output_1_byte_1_Output AT %B452 : desoutter_cvic_ii_Output_1_byte_1_Output_Layout;

	        // Module desoutter_cvic_ii/Output_1_byte_2
	        desoutter_cvic_ii_Output_1_byte_2_Output AT %B451 : desoutter_cvic_ii_Output_1_byte_2_Output_Layout;

	        // Module dukaneiqauto/PLC_to_iQ_Outputs
	        dukaneiqauto_PLC_to_iQ_Outputs_Output AT %B431 : dukaneiqauto_PLC_to_iQ_Outputs_Output_Layout;

	        et200sp_CM_4xIO_Link_RF200_CM_4xIO_Link_V2_2_144I_128O_1_Output AT %B169 : et200sp_CM_4xIO_Link_RF200_CM_4xIO_Link_V2_2_144I_128O_1_Output_Layout;

	        festo_cmmtas_DoServo_SiemensTelegram111_PZD_12_12_Output AT %B3261 : festo_cmmtas_DoServo_SiemensTelegram111_PZD_12_12_Output_Layout;

	        festo_cmmtas_DoServo_SiemensTelegram750_PZD_4_1_Output AT %B3285 : festo_cmmtas_DoServo_SiemensTelegram750_PZD_4_1_Output_Layout;

	        // Module keyence_iv3/CommandControl
	        keyence_iv3_CommandControl_Output AT %B459 : keyence_iv3_CommandControl_Output_Layout;

	        // Module keyence_sr_1000/CompletionClearControl
	        keyence_sr_1000_CompletionClearControl_Output AT %B603 : keyence_sr_1000_CompletionClearControl_Output_Layout;

	        // Module keyence_sr_1000/LatchAndErrorClearControl
	        keyence_sr_1000_LatchAndErrorClearControl_Output AT %B605 : keyence_sr_1000_LatchAndErrorClearControl_Output_Layout;

	        // Module keyence_sr_1000/OperationInstructionControl
	        keyence_sr_1000_OperationInstructionControl_Output AT %B604 : keyence_sr_1000_OperationInstructionControl_Output_Layout;

	        // Module keyence_sr_1000/ParameterBank
	        keyence_sr_1000_ParameterBank_Output AT %B601 : keyence_sr_1000_ParameterBank_Output_Layout;

	        // Module keyence_sr_1000/UserData_128
	        keyence_sr_1000_UserData_128_Output AT %B471 : keyence_sr_1000_UserData_128_Output_Layout;

	        // Module keyence_sr_750/CompletionClearControl
	        keyence_sr_750_CompletionClearControl_Output AT %B738 : keyence_sr_750_CompletionClearControl_Output_Layout;

	        // Module keyence_sr_750/LatchAndErrorClearControl
	        keyence_sr_750_LatchAndErrorClearControl_Output AT %B740 : keyence_sr_750_LatchAndErrorClearControl_Output_Layout;

	        // Module keyence_sr_750/OperationInstructionControl
	        keyence_sr_750_OperationInstructionControl_Output AT %B739 : keyence_sr_750_OperationInstructionControl_Output_Layout;

	        // Module keyence_sr_750/ParameterBank
	        keyence_sr_750_ParameterBank_Output AT %B736 : keyence_sr_750_ParameterBank_Output_Layout;

	        // Module keyence_sr_750/UserData_128
	        keyence_sr_750_UserData_128_Output AT %B606 : keyence_sr_750_UserData_128_Output_Layout;

	        kuka_rb1_DIO512_Output AT %B3645 : kuka_rb1_DIO512_Output_Layout;

	        kuka_rb2_DIO512_Output AT %B3581 : kuka_rb2_DIO512_Output_Layout;

	        mitsubishi_tz535_robot_In_Out_64_byte_Output AT %B3517 : mitsubishi_tz535_robot_In_Out_64_byte_Output_Layout;

	        // Module rexroth_cs351/Output_2_word_1
	        rexroth_cs351_Output_2_word_1_Output AT %B311 : rexroth_cs351_Output_2_word_1_Output_Layout;

	        // Module rexroth_cs351/Output_4_word_1
	        rexroth_cs351_Output_4_word_1_Output AT %B371 : rexroth_cs351_Output_4_word_1_Output_Layout;

	        // Module rexroth_cs351/Output_4_word_2
	        rexroth_cs351_Output_4_word_2_Output AT %B363 : rexroth_cs351_Output_4_word_2_Output_Layout;

	        // Module rexroth_cs351/Output_4_word_3
	        rexroth_cs351_Output_4_word_3_Output AT %B355 : rexroth_cs351_Output_4_word_3_Output_Layout;

	        // Module rexroth_cs351/Output_4_word_4
	        rexroth_cs351_Output_4_word_4_Output AT %B347 : rexroth_cs351_Output_4_word_4_Output_Layout;

	        // Module rexroth_cs351/Output_4_word_5
	        rexroth_cs351_Output_4_word_5_Output AT %B339 : rexroth_cs351_Output_4_word_5_Output_Layout;

	        // Module rexroth_cs351/Output_4_word_6
	        rexroth_cs351_Output_4_word_6_Output AT %B331 : rexroth_cs351_Output_4_word_6_Output_Layout;

	        // Module rexroth_cs351/Output_4_word_7
	        rexroth_cs351_Output_4_word_7_Output AT %B323 : rexroth_cs351_Output_4_word_7_Output_Layout;

	        // Module rexroth_cs351/Output_4_word_8
	        rexroth_cs351_Output_4_word_8_Output AT %B315 : rexroth_cs351_Output_4_word_8_Output_Layout;

	        // Module rexroth_ctrlx_drive/Outputs
	        rexroth_ctrlx_drive_Outputs_S_0_0080_0_0__Torque_force_command_value_Output AT %B3219 : rexroth_ctrlx_drive_Outputs_S_0_0080_0_0__Torque_force_command_value_Output_Layout;

	        rexroth_ctrlx_drive_Outputs_S_0_0092_0_0__Torque_force_limitation__Limit_value_bipolar_Output AT %B3217 : rexroth_ctrlx_drive_Outputs_S_0_0092_0_0__Torque_force_limitation__Limit_value_bipolar_Output_Layout;

	        rexroth_ctrlx_drive_Outputs_S_0_0134_0_0__Master_control_word__Value_Output AT %B3195 : rexroth_ctrlx_drive_Outputs_S_0_0134_0_0__Master_control_word__Value_Output_Layout;

	        rexroth_ctrlx_drive_Outputs_S_0_0145_0_0__Signal_control_word__Value_Output AT %B3213 : rexroth_ctrlx_drive_Outputs_S_0_0145_0_0__Signal_control_word__Value_Output_Layout;

	        rexroth_ctrlx_drive_Outputs_S_0_0193_0_0__Positioning_jerk_Output AT %B3221 : rexroth_ctrlx_drive_Outputs_S_0_0193_0_0__Positioning_jerk_Output_Layout;

	        rexroth_ctrlx_drive_Outputs_S_0_0259_0_0__Positioning_profile__Profile_velocity_Output AT %B3209 : rexroth_ctrlx_drive_Outputs_S_0_0259_0_0__Positioning_profile__Profile_velocity_Output_Layout;

	        rexroth_ctrlx_drive_Outputs_S_0_0260_0_0__Positioning_profile__Acceleration_Output AT %B3197 : rexroth_ctrlx_drive_Outputs_S_0_0260_0_0__Positioning_profile__Acceleration_Output_Layout;

	        rexroth_ctrlx_drive_Outputs_S_0_0282_0_0__Drive_controlled_positioning__Command_value_Output AT %B3201 : rexroth_ctrlx_drive_Outputs_S_0_0282_0_0__Drive_controlled_positioning__Command_value_Output_Layout;

	        rexroth_ctrlx_drive_Outputs_S_0_0359_0_0__Positioning_profile__Deceleration_Output AT %B3205 : rexroth_ctrlx_drive_Outputs_S_0_0359_0_0__Positioning_profile__Deceleration_Output_Layout;

	        rexroth_ctrlx_drive_Outputs_S_0_1720_0_1__Power_supply_control__Control_word_Output AT %B3215 : rexroth_ctrlx_drive_Outputs_S_0_1720_0_1__Power_supply_control__Control_word_Output_Layout;

	        // Module rexroth_indradrive/Output_13_Words
	        rexroth_indradrive_Output_13_Words_Output AT %B3225 : rexroth_indradrive_Output_13_Words_Output_Layout;

	        rexroth_indradrive_ParamCh_5Words_Output AT %B3251 : rexroth_indradrive_ParamCh_5Words_Output_Layout;

	        // Module rexroth_press/Output_21_Words
	        rexroth_press_Output_21_Words_Output AT %B379 : rexroth_press_Output_21_Words_Output_Layout;

	        rexroth_press_ParamCh_5Words_Output AT %B421 : rexroth_press_ParamCh_5Words_Output_Layout;

	        rf186c_CM_1_Output AT %B299 : rf186c_CM_1_Output_Layout;

	        rf186c_cyc_CM_Output AT %B167 : rf186c_cyc_CM_Output_Layout;

	        rf186c_cyc_RF260R_1_Output AT %B135 : rf186c_cyc_RF260R_1_Output_Layout;

	        rf186c_cyc_RF340R_1_Output AT %B7 : rf186c_cyc_RF340R_1_Output_Layout;

	        rf186c_Reader_1_Output AT %B297 : rf186c_Reader_1_Output_Layout;

	        // Module ureol2l/10_O2T_General_Purpose_Registers_2
	        ureol2l_10_O2T_General_Purpose_Registers_2_Output AT %B3293 : ureol2l_10_O2T_General_Purpose_Registers_2_Output_Layout;

	        // Module ureol2l/8_O2T_Robot_IO
	        ureol2l_8_O2T_Robot_IO_Output AT %B3493 : ureol2l_8_O2T_Robot_IO_Output_Layout;

	        // Module ureol2l/9_O2T_General_Purpose_Registers_1
	        ureol2l_9_O2T_General_Purpose_Registers_1_Output AT %B3393 : ureol2l_9_O2T_General_Purpose_Registers_1_Output_Layout;

	        vision_pro_Engine_Control_1_Output AT %B2008 : vision_pro_Engine_Control_1_Output_Layout;

	        vision_pro_Engine_Control_2_Output AT %B2007 : vision_pro_Engine_Control_2_Output_Layout;

	        vision_pro_Engine_Control_3_Output AT %B2006 : vision_pro_Engine_Control_3_Output_Layout;

	        vision_pro_Engine_Control_4_Output AT %B2005 : vision_pro_Engine_Control_4_Output_Layout;

	        vision_pro_System_Control_Output AT %B2009 : vision_pro_System_Control_Output_Layout;

	        // Module vision_pro/User_Data_240_bytes_1
	        vision_pro_User_Data_240_bytes_1_Output AT %B1765 : vision_pro_User_Data_240_bytes_1_Output_Layout;

	        // Module vision_pro/User_Data_240_bytes_2
	        vision_pro_User_Data_240_bytes_2_Output AT %B1525 : vision_pro_User_Data_240_bytes_2_Output_Layout;

	        // Module vision_pro/User_Data_240_bytes_3
	        vision_pro_User_Data_240_bytes_3_Output AT %B1285 : vision_pro_User_Data_240_bytes_3_Output_Layout;

	        // Module vision_pro/User_Data_240_bytes_4
	        vision_pro_User_Data_240_bytes_4_Output AT %B1045 : vision_pro_User_Data_240_bytes_4_Output_Layout;

	        // Module vision_pro/User_Data_240_bytes_5
	        vision_pro_User_Data_240_bytes_5_Output AT %B805 : vision_pro_User_Data_240_bytes_5_Output_Layout;

	        // Module vision_pro/User_Data_64_bytes_1
	        vision_pro_User_Data_64_bytes_1_Output AT %B741 : vision_pro_User_Data_64_bytes_1_Output_Layout;

	        zebra_Data88Bin6Bout_Output AT %B453 : zebra_Data88Bin6Bout_Output_Layout;

        END_STRUCT;
    END_TYPE
END_NAMESPACE

