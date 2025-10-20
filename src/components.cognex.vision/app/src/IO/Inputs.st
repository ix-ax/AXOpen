NAMESPACE AXOpen.Components.Cognex.Vision
    TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
        Inputs : STRUCT
	        // Module dm_280/Acquisition_Status
	        dm_280_Acquisition_Status_Input AT %B1685 : dm_280_Acquisition_Status_Input_Layout;

	        // Module dm_280/Result_Data-128_bytes
	        dm_280_Result_Data_128_bytes_Input AT %B1548 : dm_280_Result_Data_128_bytes_Input_Layout;

	        // Module dm_280/Results_Status
	        dm_280_Results_Status_Input AT %B1684 : dm_280_Results_Status_Input_Layout;

	        // Module dm_280/Soft_Event_Control
	        dm_280_Soft_Event_Control_Input AT %B1688 : dm_280_Soft_Event_Control_Input_Layout;

	        // Module dm_300/Acquisition_Status
	        dm_300_Acquisition_Status_Input AT %B1544 : dm_300_Acquisition_Status_Input_Layout;

	        // Module dm_300/Result_Data-64_bytes
	        dm_300_Result_Data_64_bytes_Input AT %B1471 : dm_300_Result_Data_64_bytes_Input_Layout;

	        // Module dm_300/Results_Status
	        dm_300_Results_Status_Input AT %B1543 : dm_300_Results_Status_Input_Layout;

	        // Module dm_300/Soft_Event_Control
	        dm_300_Soft_Event_Control_Input AT %B1547 : dm_300_Soft_Event_Control_Input_Layout;

	        // Module is2800/Acquisition_Status
	        is2800_Acquisition_Status_Input AT %B1380 : is2800_Acquisition_Status_Input_Layout;

	        // Module is2800/Command_Control
	        is2800_Command_Control_Input AT %B1388 : is2800_Command_Control_Input_Layout;

	        // Module is2800/Inspection_Status
	        is2800_Inspection_Status_Input AT %B1384 : is2800_Inspection_Status_Input_Layout;

	        // Module is2800/Result_Data-64_bytes
	        is2800_Result_Data_64_bytes_Input AT %B1312 : is2800_Result_Data_64_bytes_Input_Layout;

	        // Module is2800/SoftEvent_Control
	        is2800_SoftEvent_Control_Input AT %B1392 : is2800_SoftEvent_Control_Input_Layout;

	        // Module is7600/Acquisition_Status
	        is7600_Acquisition_Status_Input AT %B1465 : is7600_Acquisition_Status_Input_Layout;

	        // Module is7600/Command_Control
	        is7600_Command_Control_Input AT %B1468 : is7600_Command_Control_Input_Layout;

	        // Module is7600/Inspection_Status
	        is7600_Inspection_Status_Input AT %B1461 : is7600_Inspection_Status_Input_Layout;

	        // Module is7600/Result_Data-64_bytes
	        is7600_Result_Data_64_bytes_Input AT %B1393 : is7600_Result_Data_64_bytes_Input_Layout;

	        // Module is7600/SoftEvent_Control
	        is7600_SoftEvent_Control_Input AT %B1470 : is7600_SoftEvent_Control_Input_Layout;

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

