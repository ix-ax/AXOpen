TYPE
	{S7.extern=ReadWrite}
	HwOutputs : STRUCT
		ST3_indradrive_ParamCh_IDN_1 AT %B10 : ARRAY[0..9] OF BYTE;
		ST3_indradrive_Output_13_Words_1 AT %B20 : ARRAY[0..25] OF BYTE;
	END_STRUCT;
END_TYPE
