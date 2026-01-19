NAMESPACE AXOpen.Components.Cognex.Vision
    TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
        Inputs : STRUCT
	        // Module cognex_dataman_280/Acquisition_Status
	        cognex_dataman_280_Acquisition_Status_Input AT %B2607 : cognex_dataman_280_Acquisition_Status_Input_Layout;

	        // Module cognex_dataman_280/ResultData_128
	        cognex_dataman_280_ResultData_128_Input AT %B2470 : cognex_dataman_280_ResultData_128_Input_Layout;

	        // Module cognex_dataman_280/Results_Status
	        cognex_dataman_280_Results_Status_Input AT %B2606 : cognex_dataman_280_Results_Status_Input_Layout;

	        // Module cognex_dataman_280/Soft_Event_Control
	        cognex_dataman_280_Soft_Event_Control_Input AT %B2610 : cognex_dataman_280_Soft_Event_Control_Input_Layout;

	        // Module cognex_dataman_380/Acquisition_Status
	        cognex_dataman_380_Acquisition_Status_Input AT %B2466 : cognex_dataman_380_Acquisition_Status_Input_Layout;

	        // Module cognex_dataman_380/ResultData_128
	        cognex_dataman_380_ResultData_128_Input AT %B2329 : cognex_dataman_380_ResultData_128_Input_Layout;

	        // Module cognex_dataman_380/Results_Status
	        cognex_dataman_380_Results_Status_Input AT %B2465 : cognex_dataman_380_Results_Status_Input_Layout;

	        // Module cognex_dataman_380/Soft_Event_Control
	        cognex_dataman_380_Soft_Event_Control_Input AT %B2469 : cognex_dataman_380_Soft_Event_Control_Input_Layout;

	        // Module cognex_insight_2800/Slot_11_ResultData_250
	        cognex_insight_2800_Slot_11_ResultData_250_Input AT %B2062 : cognex_insight_2800_Slot_11_ResultData_250_Input_Layout;

	        // Module cognex_insight_2800/Slot_12
	        cognex_insight_2800_Slot_12_Input AT %B1812 : cognex_insight_2800_Slot_12_Input_Layout;

	        // Module cognex_insight_2800/Slot_13
	        cognex_insight_2800_Slot_13_Input AT %B1562 : cognex_insight_2800_Slot_13_Input_Layout;

	        // Module cognex_insight_2800/Slot_14
	        cognex_insight_2800_Slot_14_Input AT %B1312 : cognex_insight_2800_Slot_14_Input_Layout;

	        // Module cognex_insight_2800/Slot_2
	        cognex_insight_2800_Slot_2_Input AT %B2316 : cognex_insight_2800_Slot_2_Input_Layout;

	        // Module cognex_insight_2800/Slot_4
	        cognex_insight_2800_Slot_4_Input AT %B2320 : cognex_insight_2800_Slot_4_Input_Layout;

	        // Module cognex_insight_2800/Slot_5
	        cognex_insight_2800_Slot_5_Input AT %B2324 : cognex_insight_2800_Slot_5_Input_Layout;

	        // Module cognex_insight_2800/Slot_6
	        cognex_insight_2800_Slot_6_Input AT %B2328 : cognex_insight_2800_Slot_6_Input_Layout;

	        // Module cognex_insight_7600/Acquisition_Status
	        cognex_insight_7600_Acquisition_Status_Input AT %B2747 : cognex_insight_7600_Acquisition_Status_Input_Layout;

	        // Module cognex_insight_7600/Command_Control
	        cognex_insight_7600_Command_Control_Input AT %B2750 : cognex_insight_7600_Command_Control_Input_Layout;

	        // Module cognex_insight_7600/Inspection_Status
	        cognex_insight_7600_Inspection_Status_Input AT %B2743 : cognex_insight_7600_Inspection_Status_Input_Layout;

	        // Module cognex_insight_7600/ResultData_128
	        cognex_insight_7600_ResultData_128_Input AT %B2611 : cognex_insight_7600_ResultData_128_Input_Layout;

	        // Module cognex_insight_7600/SoftEvent_Control
	        cognex_insight_7600_SoftEvent_Control_Input AT %B2752 : cognex_insight_7600_SoftEvent_Control_Input_Layout;

	        // Module vision_pro/Engine_Control_1
	        vision_pro_Engine_Control_1_Input AT %B1288 : vision_pro_Engine_Control_1_Input_Layout;

	        // Module vision_pro/Engine_Control_2
	        vision_pro_Engine_Control_2_Input AT %B1280 : vision_pro_Engine_Control_2_Input_Layout;

	        // Module vision_pro/Engine_Control_3
	        vision_pro_Engine_Control_3_Input AT %B1272 : vision_pro_Engine_Control_3_Input_Layout;

	        // Module vision_pro/Engine_Control_4
	        vision_pro_Engine_Control_4_Input AT %B1264 : vision_pro_Engine_Control_4_Input_Layout;

	        // Module vision_pro/Result_Data_240_bytes_1
	        vision_pro_Result_Data_240_bytes_1_Input AT %B1024 : vision_pro_Result_Data_240_bytes_1_Input_Layout;

	        // Module vision_pro/Result_Data_240_bytes_2
	        vision_pro_Result_Data_240_bytes_2_Input AT %B784 : vision_pro_Result_Data_240_bytes_2_Input_Layout;

	        // Module vision_pro/Result_Data_240_bytes_3
	        vision_pro_Result_Data_240_bytes_3_Input AT %B544 : vision_pro_Result_Data_240_bytes_3_Input_Layout;

	        // Module vision_pro/Result_Data_240_bytes_4
	        vision_pro_Result_Data_240_bytes_4_Input AT %B304 : vision_pro_Result_Data_240_bytes_4_Input_Layout;

	        // Module vision_pro/Result_Data_240_bytes_5
	        vision_pro_Result_Data_240_bytes_5_Input AT %B64 : vision_pro_Result_Data_240_bytes_5_Input_Layout;

	        // Module vision_pro/Result_Data_64_bytes_1
	        vision_pro_Result_Data_64_bytes_1_Input AT %B0 : vision_pro_Result_Data_64_bytes_1_Input_Layout;

	        // Module vision_pro/System_Control
	        vision_pro_System_Control_Input AT %B1296 : vision_pro_System_Control_Input_Layout;

        END_STRUCT;
    END_TYPE
END_NAMESPACE

