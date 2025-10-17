NAMESPACE AXOpen.Components.Cognex.Vision
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    dm_280_Acquisition_Control_Output_Layout : STRUCT
	        Signals_0 AT %X0.0 : BOOL;
	        Signals_1 AT %X0.1 : BOOL;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    dm_280_Acquisition_Status_Input_Layout : STRUCT
	        Signals_0 AT %X0.0 : BOOL;
	        Signals_1 AT %X0.1 : BOOL;
	        Signals_2 AT %X0.2 : BOOL;
	        Signals_3 AT %X0.3 : BOOL;
	        Signals_4 AT %B1 : WORD;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    dm_280_Result_Data_128_bytes_Input_Layout : STRUCT
	        Signals_0 AT %B0 : WORD;
	        Signals_1 AT %B2 : WORD;
	        Signals_2 AT %B4 : WORD;
	        Signals_3 AT %B6 : WORD;
	        Signals_4 AT %B8 : ARRAY[0..127] OF BYTE;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    dm_280_Results_Control_Output_Layout : STRUCT
	        Signals_0 AT %X0.0 : BOOL;
	        Signals_1 AT %X0.1 : BOOL;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    dm_280_Results_Status_Input_Layout : STRUCT
	        Signals_0 AT %X0.0 : BOOL;
	        Signals_1 AT %X0.1 : BOOL;
	        Signals_2 AT %X0.2 : BOOL;
	        Signals_3 AT %X0.3 : BOOL;
	        Signals_4 AT %X0.7 : BOOL;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    dm_280_Soft_Event_Control_Input_Layout : STRUCT
	        Signals_0 AT %X0.0 : BOOL;
	        Signals_1 AT %X0.1 : BOOL;
	        Signals_2 AT %X0.2 : BOOL;
	        Signals_3 AT %X0.3 : BOOL;
	        Signals_4 AT %X0.4 : BOOL;
	        Signals_5 AT %X0.5 : BOOL;
	        Signals_6 AT %X0.6 : BOOL;
	        Signals_7 AT %X0.7 : BOOL;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    dm_280_Soft_Event_Control_Output_Layout : STRUCT
	        Signals_8 AT %X0.0 : BOOL;
	        Signals_9 AT %X0.1 : BOOL;
	        Signals_10 AT %X0.2 : BOOL;
	        Signals_11 AT %X0.3 : BOOL;
	        Signals_12 AT %X0.4 : BOOL;
	        Signals_13 AT %X0.5 : BOOL;
	        Signals_14 AT %X0.6 : BOOL;
	        Signals_15 AT %X0.7 : BOOL;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    dm_280_User_Data_128_bytes_Output_Layout : STRUCT
	        Signals_0 AT %B0 : WORD;
	        Signals_1 AT %B2 : WORD;
	        Signals_2 AT %B4 : ARRAY[0..127] OF BYTE;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    dm_300_Acquisition_Control_Output_Layout : STRUCT
	        Signals_0 AT %X0.0 : BOOL;
	        Signals_1 AT %X0.1 : BOOL;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    dm_300_Acquisition_Status_Input_Layout : STRUCT
	        Signals_0 AT %X0.0 : BOOL;
	        Signals_1 AT %X0.1 : BOOL;
	        Signals_2 AT %X0.2 : BOOL;
	        Signals_3 AT %X0.3 : BOOL;
	        Signals_4 AT %B1 : WORD;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    dm_300_Result_Data_64_bytes_Input_Layout : STRUCT
	        Signals_0 AT %B0 : WORD;
	        Signals_1 AT %B2 : WORD;
	        Signals_2 AT %B4 : WORD;
	        Signals_3 AT %B6 : WORD;
	        Signals_4 AT %B8 : ARRAY[0..63] OF BYTE;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    dm_300_Results_Control_Output_Layout : STRUCT
	        Signals_0 AT %X0.0 : BOOL;
	        Signals_1 AT %X0.1 : BOOL;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    dm_300_Results_Status_Input_Layout : STRUCT
	        Signals_0 AT %X0.0 : BOOL;
	        Signals_1 AT %X0.1 : BOOL;
	        Signals_2 AT %X0.2 : BOOL;
	        Signals_3 AT %X0.3 : BOOL;
	        Signals_4 AT %X0.7 : BOOL;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    dm_300_Soft_Event_Control_Input_Layout : STRUCT
	        Signals_0 AT %X0.0 : BOOL;
	        Signals_1 AT %X0.1 : BOOL;
	        Signals_2 AT %X0.2 : BOOL;
	        Signals_3 AT %X0.3 : BOOL;
	        Signals_4 AT %X0.4 : BOOL;
	        Signals_5 AT %X0.5 : BOOL;
	        Signals_6 AT %X0.6 : BOOL;
	        Signals_7 AT %X0.7 : BOOL;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    dm_300_Soft_Event_Control_Output_Layout : STRUCT
	        Signals_8 AT %X0.0 : BOOL;
	        Signals_9 AT %X0.1 : BOOL;
	        Signals_10 AT %X0.2 : BOOL;
	        Signals_11 AT %X0.3 : BOOL;
	        Signals_12 AT %X0.4 : BOOL;
	        Signals_13 AT %X0.5 : BOOL;
	        Signals_14 AT %X0.6 : BOOL;
	        Signals_15 AT %X0.7 : BOOL;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    dm_300_User_Data_64_bytes_Output_Layout : STRUCT
	        Signals_0 AT %B0 : WORD;
	        Signals_1 AT %B2 : WORD;
	        Signals_2 AT %B4 : ARRAY[0..63] OF BYTE;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    is2800_Acquisition_Control_Output_Layout : STRUCT
	        Signals_0 AT %X0.0 : BOOL;
	        Signals_1 AT %X0.1 : BOOL;
	        Signals_2 AT %X0.2 : BOOL;
	        Signals_3 AT %X0.7 : BOOL;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    is2800_Acquisition_Status_Input_Layout : STRUCT
	        Signals_0 AT %X0.0 : BOOL;
	        Signals_1 AT %X0.1 : BOOL;
	        Signals_2 AT %X0.2 : BOOL;
	        Signals_3 AT %X0.3 : BOOL;
	        Signals_4 AT %X0.4 : BOOL;
	        Signals_5 AT %X0.5 : BOOL;
	        Signals_6 AT %X0.6 : BOOL;
	        Signals_7 AT %X0.7 : BOOL;
	        Signals_8 AT %B2 : WORD;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    is2800_Command_Control_Input_Layout : STRUCT
	        Signals_0 AT %B0 : WORD;
	        Signals_1 AT %B2 : WORD;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    is2800_Command_Control_Output_Layout : STRUCT
	        Signals_2 AT %B0 : WORD;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    is2800_Inspection_Control_Output_Layout : STRUCT
	        Signals_0 AT %X0.0 : BOOL;
	        Signals_1 AT %X0.1 : BOOL;
	        Signals_2 AT %X0.2 : BOOL;
	        Signals_3 AT %X0.3 : BOOL;
	        Signals_4 AT %X0.7 : BOOL;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    is2800_Inspection_Status_Input_Layout : STRUCT
	        Signals_0 AT %X0.1 : BOOL;
	        Signals_1 AT %X0.2 : BOOL;
	        Signals_2 AT %X0.3 : BOOL;
	        Signals_3 AT %X0.4 : BOOL;
	        Signals_4 AT %X0.5 : BOOL;
	        Signals_5 AT %X0.6 : BOOL;
	        Signals_6 AT %X0.7 : BOOL;
	        Signals_7 AT %X1.0 : BOOL;
	        Signals_8 AT %X1.7 : BOOL;
	        Signals_9 AT %B2 : WORD;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    is2800_Result_Data_64_bytes_Input_Layout : STRUCT
	        Signals_0 AT %B0 : WORD;
	        Signals_1 AT %B2 : WORD;
	        Signals_2 AT %B4 : ARRAY[0..63] OF BYTE;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    is2800_SoftEvent_Control_Input_Layout : STRUCT
	        Signals_0 AT %X0.0 : BOOL;
	        Signals_1 AT %X0.1 : BOOL;
	        Signals_2 AT %X0.2 : BOOL;
	        Signals_3 AT %X0.3 : BOOL;
	        Signals_4 AT %X0.4 : BOOL;
	        Signals_5 AT %X0.5 : BOOL;
	        Signals_6 AT %X0.6 : BOOL;
	        Signals_7 AT %X0.7 : BOOL;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    is2800_SoftEvent_Control_Output_Layout : STRUCT
	        Signals_8 AT %X0.0 : BOOL;
	        Signals_9 AT %X0.1 : BOOL;
	        Signals_10 AT %X0.2 : BOOL;
	        Signals_11 AT %X0.3 : BOOL;
	        Signals_12 AT %X0.4 : BOOL;
	        Signals_13 AT %X0.5 : BOOL;
	        Signals_14 AT %X0.6 : BOOL;
	        Signals_15 AT %X0.7 : BOOL;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    is2800_User_Data_64_bytes_Output_Layout : STRUCT
	        Signals_0 AT %B0 : ARRAY[0..63] OF BYTE;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    is7600_Acquisition_Control_Output_Layout : STRUCT
	        Signals_0 AT %X0.0 : BOOL;
	        Signals_1 AT %X0.1 : BOOL;
	        Signals_2 AT %X0.2 : BOOL;
	        Signals_3 AT %X0.7 : BOOL;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    is7600_Acquisition_Status_Input_Layout : STRUCT
	        Signals_0 AT %X0.0 : BOOL;
	        Signals_1 AT %X0.1 : BOOL;
	        Signals_2 AT %X0.2 : BOOL;
	        Signals_3 AT %X0.3 : BOOL;
	        Signals_4 AT %X0.4 : BOOL;
	        Signals_5 AT %X0.5 : BOOL;
	        Signals_6 AT %X0.6 : BOOL;
	        Signals_7 AT %X0.7 : BOOL;
	        Signals_8 AT %B1 : WORD;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    is7600_Command_Control_Input_Layout : STRUCT
	        Signals_0 AT %B0 : WORD;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    is7600_Command_Control_Output_Layout : STRUCT
	        Signals_1 AT %B0 : WORD;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    is7600_Inspection_Control_Output_Layout : STRUCT
	        Signals_0 AT %X0.0 : BOOL;
	        Signals_1 AT %X0.1 : BOOL;
	        Signals_2 AT %X0.2 : BOOL;
	        Signals_3 AT %X0.3 : BOOL;
	        Signals_4 AT %X0.7 : BOOL;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    is7600_Inspection_Status_Input_Layout : STRUCT
	        Signals_0 AT %X0.0 : BOOL;
	        Signals_1 AT %X0.1 : BOOL;
	        Signals_2 AT %X0.2 : BOOL;
	        Signals_3 AT %X0.3 : BOOL;
	        Signals_4 AT %X0.4 : BOOL;
	        Signals_5 AT %X0.5 : BOOL;
	        Signals_6 AT %X0.6 : BOOL;
	        Signals_7 AT %X0.7 : BOOL;
	        Signals_8 AT %X1.0 : BOOL;
	        Signals_9 AT %X1.1 : BOOL;
	        Signals_10 AT %X1.7 : BOOL;
	        Signals_11 AT %B2 : WORD;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    is7600_Result_Data_64_bytes_Input_Layout : STRUCT
	        Signals_0 AT %B0 : WORD;
	        Signals_1 AT %B2 : WORD;
	        Signals_2 AT %B4 : ARRAY[0..63] OF BYTE;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    is7600_SoftEvent_Control_Input_Layout : STRUCT
	        Signals_0 AT %X0.0 : BOOL;
	        Signals_1 AT %X0.1 : BOOL;
	        Signals_2 AT %X0.2 : BOOL;
	        Signals_3 AT %X0.3 : BOOL;
	        Signals_4 AT %X0.4 : BOOL;
	        Signals_5 AT %X0.5 : BOOL;
	        Signals_6 AT %X0.6 : BOOL;
	        Signals_7 AT %X0.7 : BOOL;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    is7600_SoftEvent_Control_Output_Layout : STRUCT
	        Signals_8 AT %X0.0 : BOOL;
	        Signals_9 AT %X0.1 : BOOL;
	        Signals_10 AT %X0.2 : BOOL;
	        Signals_11 AT %X0.3 : BOOL;
	        Signals_12 AT %X0.4 : BOOL;
	        Signals_13 AT %X0.5 : BOOL;
	        Signals_14 AT %X0.6 : BOOL;
	        Signals_15 AT %X0.7 : BOOL;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    is7600_User_Data_64_bytes_Output_Layout : STRUCT
	        Signals_0 AT %B0 : ARRAY[0..63] OF BYTE;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    vision_pro_Engine_Control_1_Input_Layout : STRUCT
	        Signals_0 AT %X0.0 : BOOL;
	        Signals_1 AT %X0.1 : BOOL;
	        Signals_2 AT %X0.2 : BOOL;
	        Signals_3 AT %X0.3 : BOOL;
	        Signals_4 AT %X0.4 : BOOL;
	        Signals_5 AT %X0.5 : BOOL;
	        Signals_6 AT %X0.6 : BOOL;
	        Signals_7 AT %X0.7 : BOOL;
	        Signals_8 AT %X1.0 : BOOL;
	        Signals_9 AT %B2 : WORD;
	        Signals_10 AT %B4 : WORD;
	        Signals_11 AT %B6 : WORD;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    vision_pro_Engine_Control_1_Output_Layout : STRUCT
	        Signals_12 AT %X0.0 : BOOL;
	        Signals_13 AT %X0.1 : BOOL;
	        Signals_14 AT %X0.2 : BOOL;
	        Signals_15 AT %X0.3 : BOOL;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    vision_pro_Engine_Control_2_Input_Layout : STRUCT
	        Signals_0 AT %X0.0 : BOOL;
	        Signals_1 AT %X0.1 : BOOL;
	        Signals_2 AT %X0.2 : BOOL;
	        Signals_3 AT %X0.3 : BOOL;
	        Signals_4 AT %X0.4 : BOOL;
	        Signals_5 AT %X0.5 : BOOL;
	        Signals_6 AT %X0.6 : BOOL;
	        Signals_7 AT %X0.7 : BOOL;
	        Signals_8 AT %X1.0 : BOOL;
	        Signals_9 AT %B2 : WORD;
	        Signals_10 AT %B4 : WORD;
	        Signals_11 AT %B6 : WORD;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    vision_pro_Engine_Control_2_Output_Layout : STRUCT
	        Signals_12 AT %X0.0 : BOOL;
	        Signals_13 AT %X0.1 : BOOL;
	        Signals_14 AT %X0.2 : BOOL;
	        Signals_15 AT %X0.3 : BOOL;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    vision_pro_Engine_Control_3_Input_Layout : STRUCT
	        Signals_0 AT %X0.0 : BOOL;
	        Signals_1 AT %X0.1 : BOOL;
	        Signals_2 AT %X0.2 : BOOL;
	        Signals_3 AT %X0.3 : BOOL;
	        Signals_4 AT %X0.4 : BOOL;
	        Signals_5 AT %X0.5 : BOOL;
	        Signals_6 AT %X0.6 : BOOL;
	        Signals_7 AT %X0.7 : BOOL;
	        Signals_8 AT %X1.0 : BOOL;
	        Signals_9 AT %B2 : WORD;
	        Signals_10 AT %B4 : WORD;
	        Signals_11 AT %B6 : WORD;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    vision_pro_Engine_Control_3_Output_Layout : STRUCT
	        Signals_12 AT %X0.0 : BOOL;
	        Signals_13 AT %X0.1 : BOOL;
	        Signals_14 AT %X0.2 : BOOL;
	        Signals_15 AT %X0.3 : BOOL;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    vision_pro_Engine_Control_4_Input_Layout : STRUCT
	        Signals_0 AT %X0.0 : BOOL;
	        Signals_1 AT %X0.1 : BOOL;
	        Signals_2 AT %X0.2 : BOOL;
	        Signals_3 AT %X0.3 : BOOL;
	        Signals_4 AT %X0.4 : BOOL;
	        Signals_5 AT %X0.5 : BOOL;
	        Signals_6 AT %X0.6 : BOOL;
	        Signals_7 AT %X0.7 : BOOL;
	        Signals_8 AT %X1.0 : BOOL;
	        Signals_9 AT %B2 : WORD;
	        Signals_10 AT %B4 : WORD;
	        Signals_11 AT %B6 : WORD;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    vision_pro_Engine_Control_4_Output_Layout : STRUCT
	        Signals_12 AT %X0.0 : BOOL;
	        Signals_13 AT %X0.1 : BOOL;
	        Signals_14 AT %X0.2 : BOOL;
	        Signals_15 AT %X0.3 : BOOL;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    vision_pro_Result_Data_240_bytes_1_Input_Layout : STRUCT
	        Signals_0 AT %B0 : ARRAY[0..239] OF BYTE;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    vision_pro_Result_Data_240_bytes_2_Input_Layout : STRUCT
	        Signals_0 AT %B0 : ARRAY[0..239] OF BYTE;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    vision_pro_Result_Data_240_bytes_3_Input_Layout : STRUCT
	        Signals_0 AT %B0 : ARRAY[0..239] OF BYTE;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    vision_pro_Result_Data_240_bytes_4_Input_Layout : STRUCT
	        Signals_0 AT %B0 : ARRAY[0..239] OF BYTE;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    vision_pro_Result_Data_240_bytes_5_Input_Layout : STRUCT
	        Signals_0 AT %B0 : ARRAY[0..239] OF BYTE;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    vision_pro_Result_Data_64_bytes_1_Input_Layout : STRUCT
	        Signals_0 AT %B0 : ARRAY[0..63] OF BYTE;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    vision_pro_System_Control_Input_Layout : STRUCT
	        Signals_0 AT %X0.0 : BOOL;
	        Signals_1 AT %X0.1 : BOOL;
	        Signals_2 AT %X0.4 : BOOL;
	        Signals_3 AT %X0.5 : BOOL;
	        Signals_4 AT %X0.6 : BOOL;
	        Signals_5 AT %X0.7 : BOOL;
	        Signals_6 AT %X1.4 : BOOL;
	        Signals_7 AT %X1.5 : BOOL;
	        Signals_8 AT %X1.6 : BOOL;
	        Signals_9 AT %X1.7 : BOOL;
	        Signals_10 AT %B2 : WORD;
	        Signals_11 AT %B4 : WORD;
	        Signals_12 AT %B6 : WORD;
	        Signals_13 AT %X8.0 : BOOL;
	        Signals_14 AT %X8.1 : BOOL;
	        Signals_15 AT %X8.2 : BOOL;
	        Signals_16 AT %X8.3 : BOOL;
	        Signals_17 AT %X8.4 : BOOL;
	        Signals_18 AT %X8.5 : BOOL;
	        Signals_19 AT %X8.6 : BOOL;
	        Signals_20 AT %X8.7 : BOOL;
	        Signals_21 AT %X9.0 : BOOL;
	        Signals_22 AT %X9.1 : BOOL;
	        Signals_23 AT %X9.2 : BOOL;
	        Signals_24 AT %X9.3 : BOOL;
	        Signals_25 AT %X9.4 : BOOL;
	        Signals_26 AT %X9.5 : BOOL;
	        Signals_27 AT %X9.6 : BOOL;
	        Signals_28 AT %X9.7 : BOOL;
	        Signals_29 AT %X10.0 : BOOL;
	        Signals_30 AT %X10.1 : BOOL;
	        Signals_31 AT %X10.2 : BOOL;
	        Signals_32 AT %X10.3 : BOOL;
	        Signals_33 AT %X10.4 : BOOL;
	        Signals_34 AT %X10.5 : BOOL;
	        Signals_35 AT %X10.6 : BOOL;
	        Signals_36 AT %X10.7 : BOOL;
	        Signals_37 AT %X11.0 : BOOL;
	        Signals_38 AT %X11.1 : BOOL;
	        Signals_39 AT %X11.2 : BOOL;
	        Signals_40 AT %X11.3 : BOOL;
	        Signals_41 AT %X11.4 : BOOL;
	        Signals_42 AT %X11.5 : BOOL;
	        Signals_43 AT %X11.6 : BOOL;
	        Signals_44 AT %X11.7 : BOOL;
	        Signals_45 AT %B12 : WORD;
	        Signals_46 AT %B14 : WORD;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    vision_pro_System_Control_Output_Layout : STRUCT
	        Signals_47 AT %X0.0 : BOOL;
	        Signals_48 AT %X0.1 : BOOL;
	        Signals_49 AT %X0.4 : BOOL;
	        Signals_50 AT %X0.6 : BOOL;
	        Signals_51 AT %X0.7 : BOOL;
	        Signals_52 AT %B1 : BYTE;
	        Signals_53 AT %B2 : WORD;
	        Signals_54 AT %X4.0 : BOOL;
	        Signals_55 AT %X4.1 : BOOL;
	        Signals_56 AT %X4.2 : BOOL;
	        Signals_57 AT %X4.3 : BOOL;
	        Signals_58 AT %X4.4 : BOOL;
	        Signals_59 AT %X4.5 : BOOL;
	        Signals_60 AT %X4.6 : BOOL;
	        Signals_61 AT %X4.7 : BOOL;
	        Signals_62 AT %X5.0 : BOOL;
	        Signals_63 AT %X5.1 : BOOL;
	        Signals_64 AT %X5.2 : BOOL;
	        Signals_65 AT %X5.3 : BOOL;
	        Signals_66 AT %X5.4 : BOOL;
	        Signals_67 AT %X5.5 : BOOL;
	        Signals_68 AT %X5.6 : BOOL;
	        Signals_69 AT %X5.7 : BOOL;
	        Signals_70 AT %X6.0 : BOOL;
	        Signals_71 AT %X6.1 : BOOL;
	        Signals_72 AT %X6.2 : BOOL;
	        Signals_73 AT %X6.3 : BOOL;
	        Signals_74 AT %X6.4 : BOOL;
	        Signals_75 AT %X6.5 : BOOL;
	        Signals_76 AT %X6.6 : BOOL;
	        Signals_77 AT %X6.7 : BOOL;
	        Signals_78 AT %X7.0 : BOOL;
	        Signals_79 AT %X7.1 : BOOL;
	        Signals_80 AT %X7.2 : BOOL;
	        Signals_81 AT %X7.3 : BOOL;
	        Signals_82 AT %X7.4 : BOOL;
	        Signals_83 AT %X7.5 : BOOL;
	        Signals_84 AT %X7.6 : BOOL;
	        Signals_85 AT %X7.7 : BOOL;
	        Signals_86 AT %B8 : WORD;
	        Signals_87 AT %B10 : WORD;
	        Signals_88 AT %B12 : WORD;
	        Signals_89 AT %B14 : WORD;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    vision_pro_User_Data_240_bytes_1_Output_Layout : STRUCT
	        Signals_0 AT %B0 : ARRAY[0..239] OF BYTE;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    vision_pro_User_Data_240_bytes_2_Output_Layout : STRUCT
	        Signals_0 AT %B0 : ARRAY[0..239] OF BYTE;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    vision_pro_User_Data_240_bytes_3_Output_Layout : STRUCT
	        Signals_0 AT %B0 : ARRAY[0..239] OF BYTE;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    vision_pro_User_Data_240_bytes_4_Output_Layout : STRUCT
	        Signals_0 AT %B0 : ARRAY[0..239] OF BYTE;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    vision_pro_User_Data_240_bytes_5_Output_Layout : STRUCT
	        Signals_0 AT %B0 : ARRAY[0..239] OF BYTE;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    vision_pro_User_Data_64_bytes_1_Output_Layout : STRUCT
	        Signals_0 AT %B0 : ARRAY[0..63] OF BYTE;
	    END_STRUCT;
	END_TYPE
END_NAMESPACE

