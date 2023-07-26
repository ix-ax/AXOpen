TYPE
	HwOutputs : STRUCT
		_11a1_DQ_8x24VDC_0_5A_ST_1 AT %B0 : BYTE;
		_12a1_Acquisition_Control_1 AT %B1 : BYTE;
		_12a1_Inspection_Control_1 AT %B2 : BYTE;
		_12a1_Command_Control_1 AT %B3 : WORD;
		_12a1_SoftEvent_Control_1 AT %B5 : BYTE;
		_12a1_User_Data_64_bytes_1 AT %B6 : ARRAY[0..63] OF BYTE;
		_10a1_Acquisition_Control_1 AT %B70 : BYTE;
		_10a1_Results_Control_1 AT %B71 : BYTE;
		_10a1_Soft_Event_Control_1 AT %B72 : BYTE;
		_10a1_User_Data_128_bytes_1 AT %B73 : ARRAY[0..131] OF BYTE;
	END_STRUCT;
END_TYPE
