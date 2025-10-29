NAMESPACE AXOpen.Components.Keyence.Vision
    TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
        Inputs : STRUCT
	        // Module keyence_iv3/CommandStatusBits
	        keyence_iv3_CommandStatusBits_Input AT %B1526 : keyence_iv3_CommandStatusBits_Input_Layout;

	        // Module keyence_iv3/DeviceResultBits_1
	        keyence_iv3_DeviceResultBits_1_Input AT %B1522 : keyence_iv3_DeviceResultBits_1_Input_Layout;

	        // Module keyence_iv3/DeviceResultBits_2
	        keyence_iv3_DeviceResultBits_2_Input AT %B170 : keyence_iv3_DeviceResultBits_2_Input_Layout;

	        // Module keyence_iv3/DeviceStatistics
	        keyence_iv3_DeviceStatistics_Input AT %B1478 : keyence_iv3_DeviceStatistics_Input_Layout;

	        // Module keyence_iv3/DeviceStatusWords
	        keyence_iv3_DeviceStatusWords_Input AT %B1506 : keyence_iv3_DeviceStatusWords_Input_Layout;

	        // Module keyence_iv3/PositionAdjustResult
	        keyence_iv3_PositionAdjustResult_Input AT %B1458 : keyence_iv3_PositionAdjustResult_Input_Layout;

	        // Module keyence_iv3/ToolResult_1
	        keyence_iv3_ToolResult_1_Input AT %B1438 : keyence_iv3_ToolResult_1_Input_Layout;

	        // Module keyence_iv3/ToolResult_10
	        keyence_iv3_ToolResult_10_Input AT %B1258 : keyence_iv3_ToolResult_10_Input_Layout;

	        // Module keyence_iv3/ToolResult_11
	        keyence_iv3_ToolResult_11_Input AT %B1238 : keyence_iv3_ToolResult_11_Input_Layout;

	        // Module keyence_iv3/ToolResult_12
	        keyence_iv3_ToolResult_12_Input AT %B1218 : keyence_iv3_ToolResult_12_Input_Layout;

	        // Module keyence_iv3/ToolResult_13
	        keyence_iv3_ToolResult_13_Input AT %B1198 : keyence_iv3_ToolResult_13_Input_Layout;

	        // Module keyence_iv3/ToolResult_14
	        keyence_iv3_ToolResult_14_Input AT %B1178 : keyence_iv3_ToolResult_14_Input_Layout;

	        // Module keyence_iv3/ToolResult_15
	        keyence_iv3_ToolResult_15_Input AT %B1158 : keyence_iv3_ToolResult_15_Input_Layout;

	        // Module keyence_iv3/ToolResult_16
	        keyence_iv3_ToolResult_16_Input AT %B1138 : keyence_iv3_ToolResult_16_Input_Layout;

	        // Module keyence_iv3/ToolResult_17
	        keyence_iv3_ToolResult_17_Input AT %B1118 : keyence_iv3_ToolResult_17_Input_Layout;

	        // Module keyence_iv3/ToolResult_18
	        keyence_iv3_ToolResult_18_Input AT %B1098 : keyence_iv3_ToolResult_18_Input_Layout;

	        // Module keyence_iv3/ToolResult_19
	        keyence_iv3_ToolResult_19_Input AT %B1078 : keyence_iv3_ToolResult_19_Input_Layout;

	        // Module keyence_iv3/ToolResult_2
	        keyence_iv3_ToolResult_2_Input AT %B1418 : keyence_iv3_ToolResult_2_Input_Layout;

	        // Module keyence_iv3/ToolResult_20
	        keyence_iv3_ToolResult_20_Input AT %B1058 : keyence_iv3_ToolResult_20_Input_Layout;

	        // Module keyence_iv3/ToolResult_21
	        keyence_iv3_ToolResult_21_Input AT %B1038 : keyence_iv3_ToolResult_21_Input_Layout;

	        // Module keyence_iv3/ToolResult_22
	        keyence_iv3_ToolResult_22_Input AT %B1018 : keyence_iv3_ToolResult_22_Input_Layout;

	        // Module keyence_iv3/ToolResult_23
	        keyence_iv3_ToolResult_23_Input AT %B998 : keyence_iv3_ToolResult_23_Input_Layout;

	        // Module keyence_iv3/ToolResult_24
	        keyence_iv3_ToolResult_24_Input AT %B978 : keyence_iv3_ToolResult_24_Input_Layout;

	        // Module keyence_iv3/ToolResult_25
	        keyence_iv3_ToolResult_25_Input AT %B958 : keyence_iv3_ToolResult_25_Input_Layout;

	        // Module keyence_iv3/ToolResult_26
	        keyence_iv3_ToolResult_26_Input AT %B938 : keyence_iv3_ToolResult_26_Input_Layout;

	        // Module keyence_iv3/ToolResult_27
	        keyence_iv3_ToolResult_27_Input AT %B918 : keyence_iv3_ToolResult_27_Input_Layout;

	        // Module keyence_iv3/ToolResult_28
	        keyence_iv3_ToolResult_28_Input AT %B898 : keyence_iv3_ToolResult_28_Input_Layout;

	        // Module keyence_iv3/ToolResult_29
	        keyence_iv3_ToolResult_29_Input AT %B878 : keyence_iv3_ToolResult_29_Input_Layout;

	        // Module keyence_iv3/ToolResult_3
	        keyence_iv3_ToolResult_3_Input AT %B1398 : keyence_iv3_ToolResult_3_Input_Layout;

	        // Module keyence_iv3/ToolResult_30
	        keyence_iv3_ToolResult_30_Input AT %B858 : keyence_iv3_ToolResult_30_Input_Layout;

	        // Module keyence_iv3/ToolResult_31
	        keyence_iv3_ToolResult_31_Input AT %B838 : keyence_iv3_ToolResult_31_Input_Layout;

	        // Module keyence_iv3/ToolResult_32
	        keyence_iv3_ToolResult_32_Input AT %B818 : keyence_iv3_ToolResult_32_Input_Layout;

	        // Module keyence_iv3/ToolResult_33
	        keyence_iv3_ToolResult_33_Input AT %B798 : keyence_iv3_ToolResult_33_Input_Layout;

	        // Module keyence_iv3/ToolResult_34
	        keyence_iv3_ToolResult_34_Input AT %B778 : keyence_iv3_ToolResult_34_Input_Layout;

	        // Module keyence_iv3/ToolResult_35
	        keyence_iv3_ToolResult_35_Input AT %B758 : keyence_iv3_ToolResult_35_Input_Layout;

	        // Module keyence_iv3/ToolResult_36
	        keyence_iv3_ToolResult_36_Input AT %B738 : keyence_iv3_ToolResult_36_Input_Layout;

	        // Module keyence_iv3/ToolResult_37
	        keyence_iv3_ToolResult_37_Input AT %B718 : keyence_iv3_ToolResult_37_Input_Layout;

	        // Module keyence_iv3/ToolResult_38
	        keyence_iv3_ToolResult_38_Input AT %B698 : keyence_iv3_ToolResult_38_Input_Layout;

	        // Module keyence_iv3/ToolResult_39
	        keyence_iv3_ToolResult_39_Input AT %B678 : keyence_iv3_ToolResult_39_Input_Layout;

	        // Module keyence_iv3/ToolResult_4
	        keyence_iv3_ToolResult_4_Input AT %B1378 : keyence_iv3_ToolResult_4_Input_Layout;

	        // Module keyence_iv3/ToolResult_40
	        keyence_iv3_ToolResult_40_Input AT %B658 : keyence_iv3_ToolResult_40_Input_Layout;

	        // Module keyence_iv3/ToolResult_41
	        keyence_iv3_ToolResult_41_Input AT %B638 : keyence_iv3_ToolResult_41_Input_Layout;

	        // Module keyence_iv3/ToolResult_42
	        keyence_iv3_ToolResult_42_Input AT %B618 : keyence_iv3_ToolResult_42_Input_Layout;

	        // Module keyence_iv3/ToolResult_43
	        keyence_iv3_ToolResult_43_Input AT %B598 : keyence_iv3_ToolResult_43_Input_Layout;

	        // Module keyence_iv3/ToolResult_44
	        keyence_iv3_ToolResult_44_Input AT %B578 : keyence_iv3_ToolResult_44_Input_Layout;

	        // Module keyence_iv3/ToolResult_45
	        keyence_iv3_ToolResult_45_Input AT %B558 : keyence_iv3_ToolResult_45_Input_Layout;

	        // Module keyence_iv3/ToolResult_46
	        keyence_iv3_ToolResult_46_Input AT %B538 : keyence_iv3_ToolResult_46_Input_Layout;

	        // Module keyence_iv3/ToolResult_47
	        keyence_iv3_ToolResult_47_Input AT %B518 : keyence_iv3_ToolResult_47_Input_Layout;

	        // Module keyence_iv3/ToolResult_48
	        keyence_iv3_ToolResult_48_Input AT %B498 : keyence_iv3_ToolResult_48_Input_Layout;

	        // Module keyence_iv3/ToolResult_49
	        keyence_iv3_ToolResult_49_Input AT %B478 : keyence_iv3_ToolResult_49_Input_Layout;

	        // Module keyence_iv3/ToolResult_5
	        keyence_iv3_ToolResult_5_Input AT %B1358 : keyence_iv3_ToolResult_5_Input_Layout;

	        // Module keyence_iv3/ToolResult_50
	        keyence_iv3_ToolResult_50_Input AT %B458 : keyence_iv3_ToolResult_50_Input_Layout;

	        // Module keyence_iv3/ToolResult_51
	        keyence_iv3_ToolResult_51_Input AT %B438 : keyence_iv3_ToolResult_51_Input_Layout;

	        // Module keyence_iv3/ToolResult_52
	        keyence_iv3_ToolResult_52_Input AT %B418 : keyence_iv3_ToolResult_52_Input_Layout;

	        // Module keyence_iv3/ToolResult_53
	        keyence_iv3_ToolResult_53_Input AT %B398 : keyence_iv3_ToolResult_53_Input_Layout;

	        // Module keyence_iv3/ToolResult_54
	        keyence_iv3_ToolResult_54_Input AT %B378 : keyence_iv3_ToolResult_54_Input_Layout;

	        // Module keyence_iv3/ToolResult_55
	        keyence_iv3_ToolResult_55_Input AT %B358 : keyence_iv3_ToolResult_55_Input_Layout;

	        // Module keyence_iv3/ToolResult_56
	        keyence_iv3_ToolResult_56_Input AT %B338 : keyence_iv3_ToolResult_56_Input_Layout;

	        // Module keyence_iv3/ToolResult_57
	        keyence_iv3_ToolResult_57_Input AT %B318 : keyence_iv3_ToolResult_57_Input_Layout;

	        // Module keyence_iv3/ToolResult_58
	        keyence_iv3_ToolResult_58_Input AT %B298 : keyence_iv3_ToolResult_58_Input_Layout;

	        // Module keyence_iv3/ToolResult_59
	        keyence_iv3_ToolResult_59_Input AT %B278 : keyence_iv3_ToolResult_59_Input_Layout;

	        // Module keyence_iv3/ToolResult_6
	        keyence_iv3_ToolResult_6_Input AT %B1338 : keyence_iv3_ToolResult_6_Input_Layout;

	        // Module keyence_iv3/ToolResult_60
	        keyence_iv3_ToolResult_60_Input AT %B258 : keyence_iv3_ToolResult_60_Input_Layout;

	        // Module keyence_iv3/ToolResult_61
	        keyence_iv3_ToolResult_61_Input AT %B238 : keyence_iv3_ToolResult_61_Input_Layout;

	        // Module keyence_iv3/ToolResult_62
	        keyence_iv3_ToolResult_62_Input AT %B218 : keyence_iv3_ToolResult_62_Input_Layout;

	        // Module keyence_iv3/ToolResult_63
	        keyence_iv3_ToolResult_63_Input AT %B198 : keyence_iv3_ToolResult_63_Input_Layout;

	        // Module keyence_iv3/ToolResult_64
	        keyence_iv3_ToolResult_64_Input AT %B178 : keyence_iv3_ToolResult_64_Input_Layout;

	        // Module keyence_iv3/ToolResult_7
	        keyence_iv3_ToolResult_7_Input AT %B1318 : keyence_iv3_ToolResult_7_Input_Layout;

	        // Module keyence_iv3/ToolResult_8
	        keyence_iv3_ToolResult_8_Input AT %B1298 : keyence_iv3_ToolResult_8_Input_Layout;

	        // Module keyence_iv3/ToolResult_9
	        keyence_iv3_ToolResult_9_Input AT %B1278 : keyence_iv3_ToolResult_9_Input_Layout;

	        // Module keyence_sr_1000/BusyStatus
	        keyence_sr_1000_BusyStatus_Input AT %B1698 : keyence_sr_1000_BusyStatus_Input_Layout;

	        // Module keyence_sr_1000/CompletionStatus
	        keyence_sr_1000_CompletionStatus_Input AT %B1697 : keyence_sr_1000_CompletionStatus_Input_Layout;

	        // Module keyence_sr_1000/ErrorStatus
	        keyence_sr_1000_ErrorStatus_Input AT %B1696 : keyence_sr_1000_ErrorStatus_Input_Layout;

	        // Module keyence_sr_1000/HandshakeAndGeneralErrorStatus
	        keyence_sr_1000_HandshakeAndGeneralErrorStatus_Input AT %B1699 : keyence_sr_1000_HandshakeAndGeneralErrorStatus_Input_Layout;

	        // Module keyence_sr_1000/MatchingLevelAndTotalEvaluationGradeStatus
	        keyence_sr_1000_MatchingLevelAndTotalEvaluationGradeStatus_Input AT %B1686 : keyence_sr_1000_MatchingLevelAndTotalEvaluationGradeStatus_Input_Layout;

	        // Module keyence_sr_1000/OperationResultStatus
	        keyence_sr_1000_OperationResultStatus_Input AT %B1666 : keyence_sr_1000_OperationResultStatus_Input_Layout;

	        // Module keyence_sr_1000/ResultData_128
	        keyence_sr_1000_ResultData_128_Input AT %B1530 : keyence_sr_1000_ResultData_128_Input_Layout;

	        // Module keyence_sr_1000/TerminalStatus
	        keyence_sr_1000_TerminalStatus_Input AT %B1695 : keyence_sr_1000_TerminalStatus_Input_Layout;

	        // Module keyence_sr_1000/UnstableReadStatus
	        keyence_sr_1000_UnstableReadStatus_Input AT %B1694 : keyence_sr_1000_UnstableReadStatus_Input_Layout;

	        // Module keyence_sr_750/BusyStatus
	        keyence_sr_750_BusyStatus_Input AT %B168 : keyence_sr_750_BusyStatus_Input_Layout;

	        // Module keyence_sr_750/CompletionStatus
	        keyence_sr_750_CompletionStatus_Input AT %B167 : keyence_sr_750_CompletionStatus_Input_Layout;

	        // Module keyence_sr_750/ErrorStatus
	        keyence_sr_750_ErrorStatus_Input AT %B166 : keyence_sr_750_ErrorStatus_Input_Layout;

	        // Module keyence_sr_750/HandshakeAndGeneralErrorStatus
	        keyence_sr_750_HandshakeAndGeneralErrorStatus_Input AT %B169 : keyence_sr_750_HandshakeAndGeneralErrorStatus_Input_Layout;

	        // Module keyence_sr_750/MatchingLevelAndTotalEvaluationGradeStatus
	        keyence_sr_750_MatchingLevelAndTotalEvaluationGradeStatus_Input AT %B156 : keyence_sr_750_MatchingLevelAndTotalEvaluationGradeStatus_Input_Layout;

	        // Module keyence_sr_750/OperationResultStatus
	        keyence_sr_750_OperationResultStatus_Input AT %B136 : keyence_sr_750_OperationResultStatus_Input_Layout;

	        // Module keyence_sr_750/ResultData_128
	        keyence_sr_750_ResultData_128_Input AT %B0 : keyence_sr_750_ResultData_128_Input_Layout;

	        // Module keyence_sr_750/TerminalStatus
	        keyence_sr_750_TerminalStatus_Input AT %B165 : keyence_sr_750_TerminalStatus_Input_Layout;

	        // Module keyence_sr_750/UnstableReadStatus
	        keyence_sr_750_UnstableReadStatus_Input AT %B164 : keyence_sr_750_UnstableReadStatus_Input_Layout;

        END_STRUCT;
    END_TYPE
END_NAMESPACE

