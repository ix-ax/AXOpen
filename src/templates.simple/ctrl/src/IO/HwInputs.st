TYPE
	HwInputs : STRUCT
		_10a1_Acquisition_Status_1 AT %B82 : ARRAY[0..2] OF BYTE;
		_10a1_Results_Status_1 AT %B85 : BYTE;
		_10a1_Soft_Event_Control_1 AT %B86 : BYTE;
		_10a1_Result_Data_128_bytes_1 AT %B87 : ARRAY[0..135] OF BYTE;
	END_STRUCT;
END_TYPE