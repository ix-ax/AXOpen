TYPE
	HwOutputs : STRUCT
		_10a1_Acquisition_Control_1 AT %B72 : BYTE;
		_10a1_Results_Control_1 AT %B73 : BYTE;
		_10a1_Soft_Event_Control_1 AT %B74 : BYTE;
		_10a1_User_Data_128_bytes_1 AT %B75 : ARRAY[0..131] OF BYTE;
	END_STRUCT;
END_TYPE
