TYPE
	HwOutputs : STRUCT
		_10a1_Acquisition_Control_1 AT %B72 : BYTE;
		_10a1_Results_Control_1 AT %B73 : BYTE;
		_10a1_Soft_Event_Control_1 AT %B74 : BYTE;
		_10a1_User_Data_128_bytes_1 AT %B75 : ARRAY[0..131] OF BYTE;
		reader_st2_Acquisition_Control_1 AT %B300 : BYTE;
		reader_st2_Results_Control_1 AT %B301 : BYTE;
		reader_st2_Soft_Event_Control_1 AT %B302 : BYTE;
		reader_st2_User_Data_64_bytes_1 AT %B303 : ARRAY[0..67] OF BYTE;
	END_STRUCT;
END_TYPE
