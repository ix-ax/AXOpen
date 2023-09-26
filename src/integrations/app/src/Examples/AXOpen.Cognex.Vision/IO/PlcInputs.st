TYPE
	PlcInputs : STRUCT
		_10a1_Acquisition_Status_1 : ARRAY[0..2] OF BYTE;
		_10a1_Results_Status_1 : BYTE;
		_10a1_Soft_Event_Control_1 : BYTE;
		_10a1_Result_Data_128_bytes_1 : ARRAY[0..135] OF BYTE;
		reader_st2_Acquisition_Status_1 : ARRAY[0..2] OF BYTE;
		reader_st2_Results_Status_1 : BYTE;
		reader_st2_Soft_Event_Control_1 : BYTE;
		reader_st2_Result_Data_64_bytes_1 : ARRAY[0..71] OF BYTE;
		_7600_Acquisition_Status_1 : ARRAY[0..2] OF BYTE;
		_7600_Inspection_Status_1 : DWORD;
		_7600_Command_Control_1 : WORD;
		_7600_SoftEvent_Control_1 : BYTE;
		_7600_Results_64_bytes_1 : ARRAY[0..67] OF BYTE;
	END_STRUCT;
END_TYPE
