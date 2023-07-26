TYPE
	PlcOutputs : STRUCT
		_11a1_DQ_8x24VDC_0_5A_ST_1 : BYTE;
		_12a1_Acquisition_Control_1 : BYTE;
		_12a1_Inspection_Control_1 : BYTE;
		_12a1_Command_Control_1 : WORD;
		_12a1_SoftEvent_Control_1 : BYTE;
		_12a1_User_Data_64_bytes_1 : ARRAY[0..63] OF BYTE;
		_10a1_Acquisition_Control_1 : BYTE;
		_10a1_Results_Control_1 : BYTE;
		_10a1_Soft_Event_Control_1 : BYTE;
		_10a1_User_Data_128_bytes_1 : ARRAY[0..131] OF BYTE;
	END_STRUCT;
END_TYPE
