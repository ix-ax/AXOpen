TYPE
	HwOutputs : STRUCT
		URIODev1_8_O2T_Robot_IO_1 AT %B0 : ARRAY[0..23] OF BYTE;
		URIODev1_9_O2T_General_Purpose_Registers_1_1 AT %B24 : ARRAY[0..99] OF BYTE;
		URIODev1_10_O2T_General_Purpose_Registers_2_1 AT %B124 : ARRAY[0..99] OF BYTE;
		URIODev1_1_8_O2T_Robot_IO_1 AT %B224 : ARRAY[0..23] OF BYTE;
		URIODev1_1_9_O2T_General_Purpose_Registers_1_1 AT %B248 : ARRAY[0..99] OF BYTE;
		URIODev1_1_10_O2T_General_Purpose_Registers_2_1 AT %B348 : ARRAY[0..99] OF BYTE;
	END_STRUCT;
END_TYPE
