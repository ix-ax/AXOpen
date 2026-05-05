NAMESPACE AXOpen.Showcase
    TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
        Inputs : STRUCT
	        // Module abb_irc5_robot/DI_64_bytes
	        abb_irc5_robot_DI_64_bytes_Input AT %B5961 : abb_irc5_robot_DI_64_bytes_Input_Layout;

	        // Module abb_omnicore_robot/DI_64_bytes
	        abb_omnicore_robot_DI_64_bytes_Input AT %B5897 : abb_omnicore_robot_DI_64_bytes_Input_Layout;

	        // Module BNIPNT507005Z040/BIS_M-4XX-045_1
	        BNIPNT507005Z040_BIS_M_4XX_045_1_Input AT %B318 : BNIPNT507005Z040_BIS_M_4XX_045_1_Input_Layout;

	        // Module cognex_dataman_280/Acquisition_Status
	        cognex_dataman_280_Acquisition_Status_Input AT %B5067 : cognex_dataman_280_Acquisition_Status_Input_Layout;

	        // Module cognex_dataman_280/ResultData_128
	        cognex_dataman_280_ResultData_128_Input AT %B4930 : cognex_dataman_280_ResultData_128_Input_Layout;

	        // Module cognex_dataman_280/Results_Status
	        cognex_dataman_280_Results_Status_Input AT %B5066 : cognex_dataman_280_Results_Status_Input_Layout;

	        // Module cognex_dataman_280/Soft_Event_Control
	        cognex_dataman_280_Soft_Event_Control_Input AT %B5070 : cognex_dataman_280_Soft_Event_Control_Input_Layout;

	        // Module cognex_dataman_380/Acquisition_Status
	        cognex_dataman_380_Acquisition_Status_Input AT %B4926 : cognex_dataman_380_Acquisition_Status_Input_Layout;

	        // Module cognex_dataman_380/ResultData_128
	        cognex_dataman_380_ResultData_128_Input AT %B4789 : cognex_dataman_380_ResultData_128_Input_Layout;

	        // Module cognex_dataman_380/Results_Status
	        cognex_dataman_380_Results_Status_Input AT %B4925 : cognex_dataman_380_Results_Status_Input_Layout;

	        // Module cognex_dataman_380/Soft_Event_Control
	        cognex_dataman_380_Soft_Event_Control_Input AT %B4929 : cognex_dataman_380_Soft_Event_Control_Input_Layout;

	        // Module cognex_insight_2800/Slot_11_ResultData_250
	        cognex_insight_2800_Slot_11_ResultData_250_Input AT %B4522 : cognex_insight_2800_Slot_11_ResultData_250_Input_Layout;

	        // Module cognex_insight_2800/Slot_12
	        cognex_insight_2800_Slot_12_Input AT %B4272 : cognex_insight_2800_Slot_12_Input_Layout;

	        // Module cognex_insight_2800/Slot_13
	        cognex_insight_2800_Slot_13_Input AT %B4022 : cognex_insight_2800_Slot_13_Input_Layout;

	        // Module cognex_insight_2800/Slot_14
	        cognex_insight_2800_Slot_14_Input AT %B3772 : cognex_insight_2800_Slot_14_Input_Layout;

	        // Module cognex_insight_2800/Slot_2
	        cognex_insight_2800_Slot_2_Input AT %B4776 : cognex_insight_2800_Slot_2_Input_Layout;

	        // Module cognex_insight_2800/Slot_4
	        cognex_insight_2800_Slot_4_Input AT %B4780 : cognex_insight_2800_Slot_4_Input_Layout;

	        // Module cognex_insight_2800/Slot_5
	        cognex_insight_2800_Slot_5_Input AT %B4784 : cognex_insight_2800_Slot_5_Input_Layout;

	        // Module cognex_insight_2800/Slot_6
	        cognex_insight_2800_Slot_6_Input AT %B4788 : cognex_insight_2800_Slot_6_Input_Layout;

	        // Module cognex_insight_7600/Acquisition_Status
	        cognex_insight_7600_Acquisition_Status_Input AT %B5207 : cognex_insight_7600_Acquisition_Status_Input_Layout;

	        // Module cognex_insight_7600/Command_Control
	        cognex_insight_7600_Command_Control_Input AT %B5210 : cognex_insight_7600_Command_Control_Input_Layout;

	        // Module cognex_insight_7600/Inspection_Status
	        cognex_insight_7600_Inspection_Status_Input AT %B5203 : cognex_insight_7600_Inspection_Status_Input_Layout;

	        // Module cognex_insight_7600/ResultData_128
	        cognex_insight_7600_ResultData_128_Input AT %B5071 : cognex_insight_7600_ResultData_128_Input_Layout;

	        // Module cognex_insight_7600/SoftEvent_Control
	        cognex_insight_7600_SoftEvent_Control_Input AT %B5212 : cognex_insight_7600_SoftEvent_Control_Input_Layout;

	        // Module desoutter_cvic_ii/Input_1_byte_1
	        desoutter_cvic_ii_Input_1_byte_1_Input AT %B671 : desoutter_cvic_ii_Input_1_byte_1_Input_Layout;

	        // Module desoutter_cvic_ii/Input_1_byte_2
	        desoutter_cvic_ii_Input_1_byte_2_Input AT %B670 : desoutter_cvic_ii_Input_1_byte_2_Input_Layout;

	        // Module desoutter_cvic_ii/Input_1_word_1
	        desoutter_cvic_ii_Input_1_word_1_Input AT %B664 : desoutter_cvic_ii_Input_1_word_1_Input_Layout;

	        // Module desoutter_cvic_ii/Input_1_word_2
	        desoutter_cvic_ii_Input_1_word_2_Input AT %B658 : desoutter_cvic_ii_Input_1_word_2_Input_Layout;

	        // Module desoutter_cvic_ii/Input_2_word_1
	        desoutter_cvic_ii_Input_2_word_1_Input AT %B666 : desoutter_cvic_ii_Input_2_word_1_Input_Layout;

	        // Module desoutter_cvic_ii/Input_2_word_2
	        desoutter_cvic_ii_Input_2_word_2_Input AT %B660 : desoutter_cvic_ii_Input_2_word_2_Input_Layout;

	        // Module dukaneiqauto/iQ_to_PLC_Inputs
	        dukaneiqauto_iQ_to_PLC_Inputs_Input AT %B518 : dukaneiqauto_iQ_to_PLC_Inputs_Input_Layout;

	        // Module et200sp_CM_4xIO_Link_RF200/CM_4xIO-Link_V2_2_144I_128O_1
	        et200sp_CM_4xIO_Link_RF200_CM_4xIO_Link_V2_2_144I_128O_1_Input AT %B162 : et200sp_CM_4xIO_Link_RF200_CM_4xIO_Link_V2_2_144I_128O_1_Input_Layout;

	        // Module et200sp/CpPtp
	        et200sp_CpPtp_Input AT %B310 : et200sp_CpPtp_Input_Layout;

	        // Module festo_cmmtas/DoServo
	        festo_cmmtas_DoServo_SiemensTelegram111_PZD_12_12_Input AT %B5263 : festo_cmmtas_DoServo_SiemensTelegram111_PZD_12_12_Input_Layout;

	        festo_cmmtas_DoServo_SiemensTelegram750_PZD_4_1_Input AT %B5287 : festo_cmmtas_DoServo_SiemensTelegram750_PZD_4_1_Input_Layout;

	        // Module keyence_iv3/CommandStatusBits
	        keyence_iv3_CommandStatusBits_Input AT %B2116 : keyence_iv3_CommandStatusBits_Input_Layout;

	        // Module keyence_iv3/DeviceResultBits_1
	        keyence_iv3_DeviceResultBits_1_Input AT %B2112 : keyence_iv3_DeviceResultBits_1_Input_Layout;

	        // Module keyence_iv3/DeviceResultBits_2
	        keyence_iv3_DeviceResultBits_2_Input AT %B760 : keyence_iv3_DeviceResultBits_2_Input_Layout;

	        // Module keyence_iv3/DeviceStatistics
	        keyence_iv3_DeviceStatistics_Input AT %B2068 : keyence_iv3_DeviceStatistics_Input_Layout;

	        // Module keyence_iv3/DeviceStatusWords
	        keyence_iv3_DeviceStatusWords_Input AT %B2096 : keyence_iv3_DeviceStatusWords_Input_Layout;

	        // Module keyence_iv3/PositionAdjustResult
	        keyence_iv3_PositionAdjustResult_Input AT %B2048 : keyence_iv3_PositionAdjustResult_Input_Layout;

	        // Module keyence_iv3/ToolResult_1
	        keyence_iv3_ToolResult_1_Input AT %B2028 : keyence_iv3_ToolResult_1_Input_Layout;

	        // Module keyence_iv3/ToolResult_10
	        keyence_iv3_ToolResult_10_Input AT %B1848 : keyence_iv3_ToolResult_10_Input_Layout;

	        // Module keyence_iv3/ToolResult_11
	        keyence_iv3_ToolResult_11_Input AT %B1828 : keyence_iv3_ToolResult_11_Input_Layout;

	        // Module keyence_iv3/ToolResult_12
	        keyence_iv3_ToolResult_12_Input AT %B1808 : keyence_iv3_ToolResult_12_Input_Layout;

	        // Module keyence_iv3/ToolResult_13
	        keyence_iv3_ToolResult_13_Input AT %B1788 : keyence_iv3_ToolResult_13_Input_Layout;

	        // Module keyence_iv3/ToolResult_14
	        keyence_iv3_ToolResult_14_Input AT %B1768 : keyence_iv3_ToolResult_14_Input_Layout;

	        // Module keyence_iv3/ToolResult_15
	        keyence_iv3_ToolResult_15_Input AT %B1748 : keyence_iv3_ToolResult_15_Input_Layout;

	        // Module keyence_iv3/ToolResult_16
	        keyence_iv3_ToolResult_16_Input AT %B1728 : keyence_iv3_ToolResult_16_Input_Layout;

	        // Module keyence_iv3/ToolResult_17
	        keyence_iv3_ToolResult_17_Input AT %B1708 : keyence_iv3_ToolResult_17_Input_Layout;

	        // Module keyence_iv3/ToolResult_18
	        keyence_iv3_ToolResult_18_Input AT %B1688 : keyence_iv3_ToolResult_18_Input_Layout;

	        // Module keyence_iv3/ToolResult_19
	        keyence_iv3_ToolResult_19_Input AT %B1668 : keyence_iv3_ToolResult_19_Input_Layout;

	        // Module keyence_iv3/ToolResult_2
	        keyence_iv3_ToolResult_2_Input AT %B2008 : keyence_iv3_ToolResult_2_Input_Layout;

	        // Module keyence_iv3/ToolResult_20
	        keyence_iv3_ToolResult_20_Input AT %B1648 : keyence_iv3_ToolResult_20_Input_Layout;

	        // Module keyence_iv3/ToolResult_21
	        keyence_iv3_ToolResult_21_Input AT %B1628 : keyence_iv3_ToolResult_21_Input_Layout;

	        // Module keyence_iv3/ToolResult_22
	        keyence_iv3_ToolResult_22_Input AT %B1608 : keyence_iv3_ToolResult_22_Input_Layout;

	        // Module keyence_iv3/ToolResult_23
	        keyence_iv3_ToolResult_23_Input AT %B1588 : keyence_iv3_ToolResult_23_Input_Layout;

	        // Module keyence_iv3/ToolResult_24
	        keyence_iv3_ToolResult_24_Input AT %B1568 : keyence_iv3_ToolResult_24_Input_Layout;

	        // Module keyence_iv3/ToolResult_25
	        keyence_iv3_ToolResult_25_Input AT %B1548 : keyence_iv3_ToolResult_25_Input_Layout;

	        // Module keyence_iv3/ToolResult_26
	        keyence_iv3_ToolResult_26_Input AT %B1528 : keyence_iv3_ToolResult_26_Input_Layout;

	        // Module keyence_iv3/ToolResult_27
	        keyence_iv3_ToolResult_27_Input AT %B1508 : keyence_iv3_ToolResult_27_Input_Layout;

	        // Module keyence_iv3/ToolResult_28
	        keyence_iv3_ToolResult_28_Input AT %B1488 : keyence_iv3_ToolResult_28_Input_Layout;

	        // Module keyence_iv3/ToolResult_29
	        keyence_iv3_ToolResult_29_Input AT %B1468 : keyence_iv3_ToolResult_29_Input_Layout;

	        // Module keyence_iv3/ToolResult_3
	        keyence_iv3_ToolResult_3_Input AT %B1988 : keyence_iv3_ToolResult_3_Input_Layout;

	        // Module keyence_iv3/ToolResult_30
	        keyence_iv3_ToolResult_30_Input AT %B1448 : keyence_iv3_ToolResult_30_Input_Layout;

	        // Module keyence_iv3/ToolResult_31
	        keyence_iv3_ToolResult_31_Input AT %B1428 : keyence_iv3_ToolResult_31_Input_Layout;

	        // Module keyence_iv3/ToolResult_32
	        keyence_iv3_ToolResult_32_Input AT %B1408 : keyence_iv3_ToolResult_32_Input_Layout;

	        // Module keyence_iv3/ToolResult_33
	        keyence_iv3_ToolResult_33_Input AT %B1388 : keyence_iv3_ToolResult_33_Input_Layout;

	        // Module keyence_iv3/ToolResult_34
	        keyence_iv3_ToolResult_34_Input AT %B1368 : keyence_iv3_ToolResult_34_Input_Layout;

	        // Module keyence_iv3/ToolResult_35
	        keyence_iv3_ToolResult_35_Input AT %B1348 : keyence_iv3_ToolResult_35_Input_Layout;

	        // Module keyence_iv3/ToolResult_36
	        keyence_iv3_ToolResult_36_Input AT %B1328 : keyence_iv3_ToolResult_36_Input_Layout;

	        // Module keyence_iv3/ToolResult_37
	        keyence_iv3_ToolResult_37_Input AT %B1308 : keyence_iv3_ToolResult_37_Input_Layout;

	        // Module keyence_iv3/ToolResult_38
	        keyence_iv3_ToolResult_38_Input AT %B1288 : keyence_iv3_ToolResult_38_Input_Layout;

	        // Module keyence_iv3/ToolResult_39
	        keyence_iv3_ToolResult_39_Input AT %B1268 : keyence_iv3_ToolResult_39_Input_Layout;

	        // Module keyence_iv3/ToolResult_4
	        keyence_iv3_ToolResult_4_Input AT %B1968 : keyence_iv3_ToolResult_4_Input_Layout;

	        // Module keyence_iv3/ToolResult_40
	        keyence_iv3_ToolResult_40_Input AT %B1248 : keyence_iv3_ToolResult_40_Input_Layout;

	        // Module keyence_iv3/ToolResult_41
	        keyence_iv3_ToolResult_41_Input AT %B1228 : keyence_iv3_ToolResult_41_Input_Layout;

	        // Module keyence_iv3/ToolResult_42
	        keyence_iv3_ToolResult_42_Input AT %B1208 : keyence_iv3_ToolResult_42_Input_Layout;

	        // Module keyence_iv3/ToolResult_43
	        keyence_iv3_ToolResult_43_Input AT %B1188 : keyence_iv3_ToolResult_43_Input_Layout;

	        // Module keyence_iv3/ToolResult_44
	        keyence_iv3_ToolResult_44_Input AT %B1168 : keyence_iv3_ToolResult_44_Input_Layout;

	        // Module keyence_iv3/ToolResult_45
	        keyence_iv3_ToolResult_45_Input AT %B1148 : keyence_iv3_ToolResult_45_Input_Layout;

	        // Module keyence_iv3/ToolResult_46
	        keyence_iv3_ToolResult_46_Input AT %B1128 : keyence_iv3_ToolResult_46_Input_Layout;

	        // Module keyence_iv3/ToolResult_47
	        keyence_iv3_ToolResult_47_Input AT %B1108 : keyence_iv3_ToolResult_47_Input_Layout;

	        // Module keyence_iv3/ToolResult_48
	        keyence_iv3_ToolResult_48_Input AT %B1088 : keyence_iv3_ToolResult_48_Input_Layout;

	        // Module keyence_iv3/ToolResult_49
	        keyence_iv3_ToolResult_49_Input AT %B1068 : keyence_iv3_ToolResult_49_Input_Layout;

	        // Module keyence_iv3/ToolResult_5
	        keyence_iv3_ToolResult_5_Input AT %B1948 : keyence_iv3_ToolResult_5_Input_Layout;

	        // Module keyence_iv3/ToolResult_50
	        keyence_iv3_ToolResult_50_Input AT %B1048 : keyence_iv3_ToolResult_50_Input_Layout;

	        // Module keyence_iv3/ToolResult_51
	        keyence_iv3_ToolResult_51_Input AT %B1028 : keyence_iv3_ToolResult_51_Input_Layout;

	        // Module keyence_iv3/ToolResult_52
	        keyence_iv3_ToolResult_52_Input AT %B1008 : keyence_iv3_ToolResult_52_Input_Layout;

	        // Module keyence_iv3/ToolResult_53
	        keyence_iv3_ToolResult_53_Input AT %B988 : keyence_iv3_ToolResult_53_Input_Layout;

	        // Module keyence_iv3/ToolResult_54
	        keyence_iv3_ToolResult_54_Input AT %B968 : keyence_iv3_ToolResult_54_Input_Layout;

	        // Module keyence_iv3/ToolResult_55
	        keyence_iv3_ToolResult_55_Input AT %B948 : keyence_iv3_ToolResult_55_Input_Layout;

	        // Module keyence_iv3/ToolResult_56
	        keyence_iv3_ToolResult_56_Input AT %B928 : keyence_iv3_ToolResult_56_Input_Layout;

	        // Module keyence_iv3/ToolResult_57
	        keyence_iv3_ToolResult_57_Input AT %B908 : keyence_iv3_ToolResult_57_Input_Layout;

	        // Module keyence_iv3/ToolResult_58
	        keyence_iv3_ToolResult_58_Input AT %B888 : keyence_iv3_ToolResult_58_Input_Layout;

	        // Module keyence_iv3/ToolResult_59
	        keyence_iv3_ToolResult_59_Input AT %B868 : keyence_iv3_ToolResult_59_Input_Layout;

	        // Module keyence_iv3/ToolResult_6
	        keyence_iv3_ToolResult_6_Input AT %B1928 : keyence_iv3_ToolResult_6_Input_Layout;

	        // Module keyence_iv3/ToolResult_60
	        keyence_iv3_ToolResult_60_Input AT %B848 : keyence_iv3_ToolResult_60_Input_Layout;

	        // Module keyence_iv3/ToolResult_61
	        keyence_iv3_ToolResult_61_Input AT %B828 : keyence_iv3_ToolResult_61_Input_Layout;

	        // Module keyence_iv3/ToolResult_62
	        keyence_iv3_ToolResult_62_Input AT %B808 : keyence_iv3_ToolResult_62_Input_Layout;

	        // Module keyence_iv3/ToolResult_63
	        keyence_iv3_ToolResult_63_Input AT %B788 : keyence_iv3_ToolResult_63_Input_Layout;

	        // Module keyence_iv3/ToolResult_64
	        keyence_iv3_ToolResult_64_Input AT %B768 : keyence_iv3_ToolResult_64_Input_Layout;

	        // Module keyence_iv3/ToolResult_7
	        keyence_iv3_ToolResult_7_Input AT %B1908 : keyence_iv3_ToolResult_7_Input_Layout;

	        // Module keyence_iv3/ToolResult_8
	        keyence_iv3_ToolResult_8_Input AT %B1888 : keyence_iv3_ToolResult_8_Input_Layout;

	        // Module keyence_iv3/ToolResult_9
	        keyence_iv3_ToolResult_9_Input AT %B1868 : keyence_iv3_ToolResult_9_Input_Layout;

	        // Module keyence_sr_1000/BusyStatus
	        keyence_sr_1000_BusyStatus_Input AT %B2288 : keyence_sr_1000_BusyStatus_Input_Layout;

	        // Module keyence_sr_1000/CompletionStatus
	        keyence_sr_1000_CompletionStatus_Input AT %B2287 : keyence_sr_1000_CompletionStatus_Input_Layout;

	        // Module keyence_sr_1000/ErrorStatus
	        keyence_sr_1000_ErrorStatus_Input AT %B2286 : keyence_sr_1000_ErrorStatus_Input_Layout;

	        // Module keyence_sr_1000/HandshakeAndGeneralErrorStatus
	        keyence_sr_1000_HandshakeAndGeneralErrorStatus_Input AT %B2289 : keyence_sr_1000_HandshakeAndGeneralErrorStatus_Input_Layout;

	        // Module keyence_sr_1000/MatchingLevelAndTotalEvaluationGradeStatus
	        keyence_sr_1000_MatchingLevelAndTotalEvaluationGradeStatus_Input AT %B2276 : keyence_sr_1000_MatchingLevelAndTotalEvaluationGradeStatus_Input_Layout;

	        // Module keyence_sr_1000/OperationResultStatus
	        keyence_sr_1000_OperationResultStatus_Input AT %B2256 : keyence_sr_1000_OperationResultStatus_Input_Layout;

	        // Module keyence_sr_1000/ResultData_128
	        keyence_sr_1000_ResultData_128_Input AT %B2120 : keyence_sr_1000_ResultData_128_Input_Layout;

	        // Module keyence_sr_1000/TerminalStatus
	        keyence_sr_1000_TerminalStatus_Input AT %B2285 : keyence_sr_1000_TerminalStatus_Input_Layout;

	        // Module keyence_sr_1000/UnstableReadStatus
	        keyence_sr_1000_UnstableReadStatus_Input AT %B2284 : keyence_sr_1000_UnstableReadStatus_Input_Layout;

	        // Module keyence_sr_750/BusyStatus
	        keyence_sr_750_BusyStatus_Input AT %B2458 : keyence_sr_750_BusyStatus_Input_Layout;

	        // Module keyence_sr_750/CompletionStatus
	        keyence_sr_750_CompletionStatus_Input AT %B2457 : keyence_sr_750_CompletionStatus_Input_Layout;

	        // Module keyence_sr_750/ErrorStatus
	        keyence_sr_750_ErrorStatus_Input AT %B2456 : keyence_sr_750_ErrorStatus_Input_Layout;

	        // Module keyence_sr_750/HandshakeAndGeneralErrorStatus
	        keyence_sr_750_HandshakeAndGeneralErrorStatus_Input AT %B2459 : keyence_sr_750_HandshakeAndGeneralErrorStatus_Input_Layout;

	        // Module keyence_sr_750/MatchingLevelAndTotalEvaluationGradeStatus
	        keyence_sr_750_MatchingLevelAndTotalEvaluationGradeStatus_Input AT %B2446 : keyence_sr_750_MatchingLevelAndTotalEvaluationGradeStatus_Input_Layout;

	        // Module keyence_sr_750/OperationResultStatus
	        keyence_sr_750_OperationResultStatus_Input AT %B2426 : keyence_sr_750_OperationResultStatus_Input_Layout;

	        // Module keyence_sr_750/ResultData_128
	        keyence_sr_750_ResultData_128_Input AT %B2290 : keyence_sr_750_ResultData_128_Input_Layout;

	        // Module keyence_sr_750/TerminalStatus
	        keyence_sr_750_TerminalStatus_Input AT %B2455 : keyence_sr_750_TerminalStatus_Input_Layout;

	        // Module keyence_sr_750/UnstableReadStatus
	        keyence_sr_750_UnstableReadStatus_Input AT %B2454 : keyence_sr_750_UnstableReadStatus_Input_Layout;

	        // Module kuka_rb1/DIO512
	        kuka_rb1_DIO512_Input AT %B5833 : kuka_rb1_DIO512_Input_Layout;

	        // Module kuka_rb2/DIO512
	        kuka_rb2_DIO512_Input AT %B6029 : kuka_rb2_DIO512_Input_Layout;

	        // Module mitsubishi_tz535_robot/In_Out_64_byte
	        mitsubishi_tz535_robot_In_Out_64_byte_Input AT %B5769 : mitsubishi_tz535_robot_In_Out_64_byte_Input_Layout;

	        // Module plc_line/A1
	        plc_line_A1_Input AT %B6025 : plc_line_A1_Input_Layout;

	        // Module rexroth_cs351/Input_2_word_1
	        rexroth_cs351_Input_2_word_1_Input AT %B328 : rexroth_cs351_Input_2_word_1_Input_Layout;

	        // Module rexroth_cs351/Input_4_word_1
	        rexroth_cs351_Input_4_word_1_Input AT %B452 : rexroth_cs351_Input_4_word_1_Input_Layout;

	        // Module rexroth_cs351/Input_4_word_10
	        rexroth_cs351_Input_4_word_10_Input AT %B380 : rexroth_cs351_Input_4_word_10_Input_Layout;

	        // Module rexroth_cs351/Input_4_word_11
	        rexroth_cs351_Input_4_word_11_Input AT %B372 : rexroth_cs351_Input_4_word_11_Input_Layout;

	        // Module rexroth_cs351/Input_4_word_12
	        rexroth_cs351_Input_4_word_12_Input AT %B364 : rexroth_cs351_Input_4_word_12_Input_Layout;

	        // Module rexroth_cs351/Input_4_word_13
	        rexroth_cs351_Input_4_word_13_Input AT %B356 : rexroth_cs351_Input_4_word_13_Input_Layout;

	        // Module rexroth_cs351/Input_4_word_14
	        rexroth_cs351_Input_4_word_14_Input AT %B348 : rexroth_cs351_Input_4_word_14_Input_Layout;

	        // Module rexroth_cs351/Input_4_word_15
	        rexroth_cs351_Input_4_word_15_Input AT %B340 : rexroth_cs351_Input_4_word_15_Input_Layout;

	        // Module rexroth_cs351/Input_4_word_16
	        rexroth_cs351_Input_4_word_16_Input AT %B332 : rexroth_cs351_Input_4_word_16_Input_Layout;

	        // Module rexroth_cs351/Input_4_word_2
	        rexroth_cs351_Input_4_word_2_Input AT %B444 : rexroth_cs351_Input_4_word_2_Input_Layout;

	        // Module rexroth_cs351/Input_4_word_3
	        rexroth_cs351_Input_4_word_3_Input AT %B436 : rexroth_cs351_Input_4_word_3_Input_Layout;

	        // Module rexroth_cs351/Input_4_word_4
	        rexroth_cs351_Input_4_word_4_Input AT %B428 : rexroth_cs351_Input_4_word_4_Input_Layout;

	        // Module rexroth_cs351/Input_4_word_5
	        rexroth_cs351_Input_4_word_5_Input AT %B420 : rexroth_cs351_Input_4_word_5_Input_Layout;

	        // Module rexroth_cs351/Input_4_word_6
	        rexroth_cs351_Input_4_word_6_Input AT %B412 : rexroth_cs351_Input_4_word_6_Input_Layout;

	        // Module rexroth_cs351/Input_4_word_7
	        rexroth_cs351_Input_4_word_7_Input AT %B404 : rexroth_cs351_Input_4_word_7_Input_Layout;

	        // Module rexroth_cs351/Input_4_word_8
	        rexroth_cs351_Input_4_word_8_Input AT %B396 : rexroth_cs351_Input_4_word_8_Input_Layout;

	        // Module rexroth_cs351/Input_4_word_9
	        rexroth_cs351_Input_4_word_9_Input AT %B388 : rexroth_cs351_Input_4_word_9_Input_Layout;

	        // Module rexroth_ctrlx_drive/Inputs
	        rexroth_ctrlx_drive_Inputs_P_0_0106_0_0__STO_function__Operating_status_Input AT %B5233 : rexroth_ctrlx_drive_Inputs_P_0_0106_0_0__STO_function__Operating_status_Input_Layout;

	        rexroth_ctrlx_drive_Inputs_S_0_0084_0_0__Torque_force_feedback_value_Input AT %B5231 : rexroth_ctrlx_drive_Inputs_S_0_0084_0_0__Torque_force_feedback_value_Input_Layout;

	        rexroth_ctrlx_drive_Inputs_S_0_0135_0_0__Drive_status_word__Value_Input AT %B5225 : rexroth_ctrlx_drive_Inputs_S_0_0135_0_0__Drive_status_word__Value_Input_Layout;

	        rexroth_ctrlx_drive_Inputs_S_0_0144_0_0__Signal_status_word__Value_Input AT %B5227 : rexroth_ctrlx_drive_Inputs_S_0_0144_0_0__Signal_status_word__Value_Input_Layout;

	        rexroth_ctrlx_drive_Inputs_S_0_0386_0_0__Position_controller__Position_actual_value_Input AT %B5213 : rexroth_ctrlx_drive_Inputs_S_0_0386_0_0__Position_controller__Position_actual_value_Input_Layout;

	        rexroth_ctrlx_drive_Inputs_S_0_0390_0_0__Diagnostic_message__Manufacturer_status_register_Input AT %B5221 : rexroth_ctrlx_drive_Inputs_S_0_0390_0_0__Diagnostic_message__Manufacturer_status_register_Input_Layout;

	        rexroth_ctrlx_drive_Inputs_S_0_0535_0_0__Velocity_controller__Velocity_actual_value_Input AT %B5217 : rexroth_ctrlx_drive_Inputs_S_0_0535_0_0__Velocity_controller__Velocity_actual_value_Input_Layout;

	        rexroth_ctrlx_drive_Inputs_S_0_1720_0_2__Power_supply_control__Status_word_Input AT %B5229 : rexroth_ctrlx_drive_Inputs_S_0_1720_0_2__Power_supply_control__Status_word_Input_Layout;

	        // Module rexroth_indradrive/Input_9_Words
	        rexroth_indradrive_Input_9_Words_Input AT %B5235 : rexroth_indradrive_Input_9_Words_Input_Layout;

	        // Module rexroth_indradrive/ParamCh_5Words
	        rexroth_indradrive_ParamCh_5Words_Input AT %B5253 : rexroth_indradrive_ParamCh_5Words_Input_Layout;

	        // Module rexroth_press/Input_24_Words
	        rexroth_press_Input_24_Words_Input AT %B460 : rexroth_press_Input_24_Words_Input_Layout;

	        // Module rexroth_press/ParamCh_5Words
	        rexroth_press_ParamCh_5Words_Input AT %B508 : rexroth_press_ParamCh_5Words_Input_Layout;

	        // Module rf186c/CM_1
	        rf186c_CM_1_Input AT %B308 : rf186c_CM_1_Input_Layout;

	        // Module rf186c_cyc/CM
	        rf186c_cyc_CM_Input AT %B160 : rf186c_cyc_CM_Input_Layout;

	        // Module rf186c_cyc/RF260R_1
	        rf186c_cyc_RF260R_1_Input AT %B128 : rf186c_cyc_RF260R_1_Input_Layout;

	        // Module rf186c_cyc/RF340R_1
	        rf186c_cyc_RF340R_1_Input AT %B0 : rf186c_cyc_RF340R_1_Input_Layout;

	        // Module rf186c/Reader_1
	        rf186c_Reader_1_Input AT %B306 : rf186c_Reader_1_Input_Layout;

	        // Module ureol2l/1_T2O_State
	        ureol2l_1_T2O_State_Input AT %B5737 : ureol2l_1_T2O_State_Input_Layout;

	        // Module ureol2l/2_T2O_IO
	        ureol2l_2_T2O_IO_Input AT %B5669 : ureol2l_2_T2O_IO_Input_Layout;

	        // Module ureol2l/3_T2O_Joints
	        ureol2l_3_T2O_Joints_Input AT %B5565 : ureol2l_3_T2O_Joints_Input_Layout;

	        // Module ureol2l/4_T2O_TCP
	        ureol2l_4_T2O_TCP_Input AT %B5489 : ureol2l_4_T2O_TCP_Input_Layout;

	        // Module ureol2l/5_T2O_General_Purpose_Bit_Registers
	        ureol2l_5_T2O_General_Purpose_Bit_Registers_Input AT %B5481 : ureol2l_5_T2O_General_Purpose_Bit_Registers_Input_Layout;

	        // Module ureol2l/6_T2O_General_Purpose_Int_Registers
	        ureol2l_6_T2O_General_Purpose_Int_Registers_Input AT %B5385 : ureol2l_6_T2O_General_Purpose_Int_Registers_Input_Layout;

	        // Module ureol2l/7_T2O_General_Purpose_Float_Registers
	        ureol2l_7_T2O_General_Purpose_Float_Registers_Input AT %B5289 : ureol2l_7_T2O_General_Purpose_Float_Registers_Input_Layout;

	        // Module vision_pro/Engine_Control_1
	        vision_pro_Engine_Control_1_Input AT %B3748 : vision_pro_Engine_Control_1_Input_Layout;

	        // Module vision_pro/Engine_Control_2
	        vision_pro_Engine_Control_2_Input AT %B3740 : vision_pro_Engine_Control_2_Input_Layout;

	        // Module vision_pro/Engine_Control_3
	        vision_pro_Engine_Control_3_Input AT %B3732 : vision_pro_Engine_Control_3_Input_Layout;

	        // Module vision_pro/Engine_Control_4
	        vision_pro_Engine_Control_4_Input AT %B3724 : vision_pro_Engine_Control_4_Input_Layout;

	        // Module vision_pro/Result_Data_240_bytes_1
	        vision_pro_Result_Data_240_bytes_1_Input AT %B3484 : vision_pro_Result_Data_240_bytes_1_Input_Layout;

	        // Module vision_pro/Result_Data_240_bytes_2
	        vision_pro_Result_Data_240_bytes_2_Input AT %B3244 : vision_pro_Result_Data_240_bytes_2_Input_Layout;

	        // Module vision_pro/Result_Data_240_bytes_3
	        vision_pro_Result_Data_240_bytes_3_Input AT %B3004 : vision_pro_Result_Data_240_bytes_3_Input_Layout;

	        // Module vision_pro/Result_Data_240_bytes_4
	        vision_pro_Result_Data_240_bytes_4_Input AT %B2764 : vision_pro_Result_Data_240_bytes_4_Input_Layout;

	        // Module vision_pro/Result_Data_240_bytes_5
	        vision_pro_Result_Data_240_bytes_5_Input AT %B2524 : vision_pro_Result_Data_240_bytes_5_Input_Layout;

	        // Module vision_pro/Result_Data_64_bytes_1
	        vision_pro_Result_Data_64_bytes_1_Input AT %B2460 : vision_pro_Result_Data_64_bytes_1_Input_Layout;

	        // Module vision_pro/System_Control
	        vision_pro_System_Control_Input AT %B3756 : vision_pro_System_Control_Input_Layout;

	        // Module zebra/Data88Bin6Bout
	        zebra_Data88Bin6Bout_Input AT %B672 : zebra_Data88Bin6Bout_Input_Layout;

        END_STRUCT;
    END_TYPE
END_NAMESPACE

