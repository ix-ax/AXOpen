NAMESPACE AXOpen.Components.Cognex.Vision
    TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
        Outputs : STRUCT
	        // Module cognex_dataman_280/Acquisition_Control
	        cognex_dataman_280_Acquisition_Control_Output AT %B2320 : cognex_dataman_280_Acquisition_Control_Output_Layout;

	        // Module cognex_dataman_280/Results_Control
	        cognex_dataman_280_Results_Control_Output AT %B2319 : cognex_dataman_280_Results_Control_Output_Layout;

	        cognex_dataman_280_Soft_Event_Control_Output AT %B2318 : cognex_dataman_280_Soft_Event_Control_Output_Layout;

	        // Module cognex_dataman_280/UserData_128
	        cognex_dataman_280_UserData_128_Output AT %B2186 : cognex_dataman_280_UserData_128_Output_Layout;

	        // Module cognex_dataman_380/Acquisition_Control
	        cognex_dataman_380_Acquisition_Control_Output AT %B2185 : cognex_dataman_380_Acquisition_Control_Output_Layout;

	        // Module cognex_dataman_380/Results_Control
	        cognex_dataman_380_Results_Control_Output AT %B2184 : cognex_dataman_380_Results_Control_Output_Layout;

	        cognex_dataman_380_Soft_Event_Control_Output AT %B2183 : cognex_dataman_380_Soft_Event_Control_Output_Layout;

	        // Module cognex_dataman_380/UserData_128
	        cognex_dataman_380_UserData_128_Output AT %B2051 : cognex_dataman_380_UserData_128_Output_Layout;

	        // Module cognex_insight_2800/Slot_1
	        cognex_insight_2800_Slot_1_Output AT %B2050 : cognex_insight_2800_Slot_1_Output_Layout;

	        // Module cognex_insight_2800/Slot_3
	        cognex_insight_2800_Slot_3_Output AT %B2049 : cognex_insight_2800_Slot_3_Output_Layout;

	        cognex_insight_2800_Slot_5_Output AT %B2046 : cognex_insight_2800_Slot_5_Output_Layout;

	        cognex_insight_2800_Slot_6_Output AT %B2048 : cognex_insight_2800_Slot_6_Output_Layout;

	        // Module cognex_insight_2800/Slot_7
	        cognex_insight_2800_Slot_7_Output AT %B1792 : cognex_insight_2800_Slot_7_Output_Layout;

	        // Module cognex_insight_2800/Slot_8
	        cognex_insight_2800_Slot_8_Output AT %B1538 : cognex_insight_2800_Slot_8_Output_Layout;

	        // Module cognex_insight_2800/Slot_9
	        cognex_insight_2800_Slot_9_Output AT %B1284 : cognex_insight_2800_Slot_9_Output_Layout;

	        // Module cognex_insight_7600/Acquisition_Control
	        cognex_insight_7600_Acquisition_Control_Output AT %B2453 : cognex_insight_7600_Acquisition_Control_Output_Layout;

	        cognex_insight_7600_Command_Control_Output AT %B2449 : cognex_insight_7600_Command_Control_Output_Layout;

	        // Module cognex_insight_7600/Inspection_Control
	        cognex_insight_7600_Inspection_Control_Output AT %B2452 : cognex_insight_7600_Inspection_Control_Output_Layout;

	        cognex_insight_7600_SoftEvent_Control_Output AT %B2451 : cognex_insight_7600_SoftEvent_Control_Output_Layout;

	        // Module cognex_insight_7600/UserData_128
	        cognex_insight_7600_UserData_128_Output AT %B2321 : cognex_insight_7600_UserData_128_Output_Layout;

	        vision_pro_Engine_Control_1_Output AT %B1267 : vision_pro_Engine_Control_1_Output_Layout;

	        vision_pro_Engine_Control_2_Output AT %B1266 : vision_pro_Engine_Control_2_Output_Layout;

	        vision_pro_Engine_Control_3_Output AT %B1265 : vision_pro_Engine_Control_3_Output_Layout;

	        vision_pro_Engine_Control_4_Output AT %B1264 : vision_pro_Engine_Control_4_Output_Layout;

	        vision_pro_System_Control_Output AT %B1268 : vision_pro_System_Control_Output_Layout;

	        // Module vision_pro/User_Data_240_bytes_1
	        vision_pro_User_Data_240_bytes_1_Output AT %B1024 : vision_pro_User_Data_240_bytes_1_Output_Layout;

	        // Module vision_pro/User_Data_240_bytes_2
	        vision_pro_User_Data_240_bytes_2_Output AT %B784 : vision_pro_User_Data_240_bytes_2_Output_Layout;

	        // Module vision_pro/User_Data_240_bytes_3
	        vision_pro_User_Data_240_bytes_3_Output AT %B544 : vision_pro_User_Data_240_bytes_3_Output_Layout;

	        // Module vision_pro/User_Data_240_bytes_4
	        vision_pro_User_Data_240_bytes_4_Output AT %B304 : vision_pro_User_Data_240_bytes_4_Output_Layout;

	        // Module vision_pro/User_Data_240_bytes_5
	        vision_pro_User_Data_240_bytes_5_Output AT %B64 : vision_pro_User_Data_240_bytes_5_Output_Layout;

	        // Module vision_pro/User_Data_64_bytes_1
	        vision_pro_User_Data_64_bytes_1_Output AT %B0 : vision_pro_User_Data_64_bytes_1_Output_Layout;

        END_STRUCT;
    END_TYPE
END_NAMESPACE

