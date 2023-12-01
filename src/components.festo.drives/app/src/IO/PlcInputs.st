TYPE
	PlcInputs : STRUCT
		ST3_indradrive_ID_PaCh_5Words : ARRAY[0..9] OF BYTE;
		ST3_indradrive_ID_InMod_9Words : ARRAY[0..17] OF BYTE;
		cmmtas_DO_SERVO_1_Siemens_telegram_111_PZD_12_12 : ARRAY[0..23] OF BYTE;
		cmmtas_DO_SERVO_1_Siemens_telegram_750_PZD_4_1 : WORD;
	END_STRUCT;
END_TYPE
