TYPE
	HwInputs : STRUCT
		URIODev1_1_T2O_State_1 AT %B0 : ARRAY[0..31] OF BYTE;
		URIODev1_2_T2O_IO_1 AT %B32 : ARRAY[0..67] OF BYTE;
		URIODev1_3_T2O_Joints_1 AT %B100 : ARRAY[0..103] OF BYTE;
		URIODev1_4_T2O_TCP_1 AT %B204 : ARRAY[0..75] OF BYTE;
		URIODev1_5_T2O_General_Purpose_Bit_Registers_1 AT %B280 : ARRAY[0..7] OF BYTE;
		URIODev1_6_T2O_General_Purpose_Int_Registers_1 AT %B288 : ARRAY[0..95] OF BYTE;
		URIODev1_7_T2O_General_Purpose_Float_Registers_1 AT %B384 : ARRAY[0..95] OF BYTE;
		URIODev1_1_1_T2O_State_1 AT %B480 : ARRAY[0..31] OF BYTE;
		URIODev1_1_2_T2O_IO_1 AT %B512 : ARRAY[0..67] OF BYTE;
		URIODev1_1_3_T2O_Joints_1 AT %B580 : ARRAY[0..103] OF BYTE;
		URIODev1_1_4_T2O_TCP_1 AT %B684 : ARRAY[0..75] OF BYTE;
		URIODev1_1_5_T2O_General_Purpose_Bit_Registers_1 AT %B760 : ARRAY[0..7] OF BYTE;
		URIODev1_1_6_T2O_General_Purpose_Int_Registers_1 AT %B768 : ARRAY[0..95] OF BYTE;
		URIODev1_1_7_T2O_General_Purpose_Float_Registers_1 AT %B864 : ARRAY[0..95] OF BYTE;
	END_STRUCT;
END_TYPE
