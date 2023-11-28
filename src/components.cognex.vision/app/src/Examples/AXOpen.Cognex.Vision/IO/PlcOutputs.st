TYPE
	{S7.extern=ReadWrite}
	PlcOutputs : STRUCT
		_10a1_Acquisition_Control_1 : BYTE;
		_10a1_Results_Control_1 : BYTE;
		_10a1_Soft_Event_Control_1 : BYTE;
		_10a1_User_Data_128_bytes_1 : ARRAY[0..131] OF BYTE;
		reader_st2_Acquisition_Control_1 : BYTE;
		reader_st2_Results_Control_1 : BYTE;
		reader_st2_Soft_Event_Control_1 : BYTE;
		reader_st2_User_Data_64_bytes_1 : ARRAY[0..67] OF BYTE;
		_7600_Acquisition_Control_1 : BYTE;
		_7600_Inspection_Control_1 : BYTE;
		_7600_Command_Control_1 : WORD;
		_7600_SoftEvent_Control_1 : BYTE;
		_7600_User_Data_64_bytes_1 : ARRAY[0..63] OF BYTE;
	END_STRUCT;
END_TYPE
