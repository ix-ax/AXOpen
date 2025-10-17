NAMESPACE AXOpen.Components.Cognex.Vision
    TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
        Outputs : STRUCT
	        // Module dm_280/Acquisition_Control
	        dm_280_Acquisition_Control_Output AT %B1627 : dm_280_Acquisition_Control_Output_Layout;

	        // Module dm_280/Results_Control
	        dm_280_Results_Control_Output AT %B1626 : dm_280_Results_Control_Output_Layout;

	        dm_280_Soft_Event_Control_Output AT %B1625 : dm_280_Soft_Event_Control_Output_Layout;

	        // Module dm_280/User_Data-128_bytes
	        dm_280_User_Data_128_bytes_Output AT %B1493 : dm_280_User_Data_128_bytes_Output_Layout;

	        // Module dm_300/Acquisition_Control
	        dm_300_Acquisition_Control_Output AT %B1492 : dm_300_Acquisition_Control_Output_Layout;

	        // Module dm_300/Results_Control
	        dm_300_Results_Control_Output AT %B1491 : dm_300_Results_Control_Output_Layout;

	        dm_300_Soft_Event_Control_Output AT %B1490 : dm_300_Soft_Event_Control_Output_Layout;

	        // Module dm_300/User_Data-64_bytes
	        dm_300_User_Data_64_bytes_Output AT %B1422 : dm_300_User_Data_64_bytes_Output_Layout;

	        // Module is2800/Acquisition_Control
	        is2800_Acquisition_Control_Output AT %B1352 : is2800_Acquisition_Control_Output_Layout;

	        is2800_Command_Control_Output AT %B1348 : is2800_Command_Control_Output_Layout;

	        // Module is2800/Inspection_Control
	        is2800_Inspection_Control_Output AT %B1351 : is2800_Inspection_Control_Output_Layout;

	        is2800_SoftEvent_Control_Output AT %B1350 : is2800_SoftEvent_Control_Output_Layout;

	        // Module is2800/User_Data-64_bytes
	        is2800_User_Data_64_bytes_Output AT %B1284 : is2800_User_Data_64_bytes_Output_Layout;

	        // Module is7600/Acquisition_Control
	        is7600_Acquisition_Control_Output AT %B1421 : is7600_Acquisition_Control_Output_Layout;

	        is7600_Command_Control_Output AT %B1417 : is7600_Command_Control_Output_Layout;

	        // Module is7600/Inspection_Control
	        is7600_Inspection_Control_Output AT %B1420 : is7600_Inspection_Control_Output_Layout;

	        is7600_SoftEvent_Control_Output AT %B1419 : is7600_SoftEvent_Control_Output_Layout;

	        // Module is7600/User_Data-64_bytes
	        is7600_User_Data_64_bytes_Output AT %B1353 : is7600_User_Data_64_bytes_Output_Layout;

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

