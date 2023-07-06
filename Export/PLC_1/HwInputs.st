TYPE
	HwInputs : STRUCT
		_11a1_DI_8x24VDC_ST_1 AT %B0 : BYTE;
		_11a1_DI_8x24VDC_ST_2 AT %B1 : BYTE;
		_12a1_Acquisition_Status_1 AT %B2 : ARRAY[0..2] OF BYTE;
		_12a1_Inspection_Status_1 AT %B5 : DWORD;
		_12a1_Command_Control_1 AT %B9 : WORD;
		_12a1_SoftEvent_Control_1 AT %B11 : BYTE;
		_12a1_Results_64_bytes_1 AT %B12 : ARRAY[0..67] OF BYTE;
		_10a1_Acquisition_Status_1 AT %B80 : ARRAY[0..2] OF BYTE;
		_10a1_Results_Status_1 AT %B83 : BYTE;
		_10a1_Soft_Event_Control_1 AT %B84 : BYTE;
		_10a1_Result_Data_128_bytes_1 AT %B85 : ARRAY[0..135] OF BYTE;
	END_STRUCT;
END_TYPE
