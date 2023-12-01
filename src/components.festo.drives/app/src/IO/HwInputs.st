TYPE
	HwInputs : STRUCT
		ST3_indradrive_ID_PaCh_5Words AT %B10 : ARRAY[0..9] OF BYTE;
		ST3_indradrive_ID_InMod_9Words AT %B20 : ARRAY[0..17] OF BYTE;
		cmmtas_DO_SERVO_1_Siemens_telegram_111_PZD_12_12 AT %B100 : ARRAY[0..23] OF BYTE;
		cmmtas_DO_SERVO_1_Siemens_telegram_750_PZD_4_1 AT %B124 : WORD;
	END_STRUCT;
END_TYPE
