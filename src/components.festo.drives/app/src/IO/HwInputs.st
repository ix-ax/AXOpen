TYPE
	{S7.extern=ReadWrite}
	HwInputs : STRUCT
		ST3_indradrive_ParamCh_IDN_1 AT %B10 : ARRAY[0..9] OF BYTE;
		ST3_indradrive_Input_9_Words_1 AT %B20 : ARRAY[0..17] OF BYTE;
	END_STRUCT;
END_TYPE
