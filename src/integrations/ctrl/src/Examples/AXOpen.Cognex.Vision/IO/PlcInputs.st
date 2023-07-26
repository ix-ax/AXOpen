TYPE
	PlcInputs : STRUCT
		_11a1_DI_8x24VDC_ST_1 : BYTE;
		_11a1_DI_8x24VDC_ST_2 : BYTE;
		_12a1_Acquisition_Status_1 : ARRAY[0..2] OF BYTE;
		_12a1_Inspection_Status_1 : DWORD;
		_12a1_Command_Control_1 : WORD;
		_12a1_SoftEvent_Control_1 : BYTE;
		_12a1_Results_64_bytes_1 : ARRAY[0..67] OF BYTE;
		_10a1_Acquisition_Status_1 : ARRAY[0..2] OF BYTE;
		_10a1_Results_Status_1 : BYTE;
		_10a1_Soft_Event_Control_1 : BYTE;
		_10a1_Result_Data_128_bytes_1 : ARRAY[0..135] OF BYTE;
	END_STRUCT;
END_TYPE
