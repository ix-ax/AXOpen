TYPE
	HwInputs : STRUCT
		ST3_indradrive_ParamCh_IDN_1 AT %B10 : ARRAY[0..9] OF BYTE;
		ST3_indradrive_Input_9_Words_1 AT %B20 : ARRAY[0..17] OF BYTE;
		cmmtas_test_DO_SERVO_1_Siemens_telegram_111_PZD_12_12 AT %B100 : ARRAY[0..23] OF BYTE;
		cmmtas_test_DO_SERVO_1_Siemens_telegram_750_PZD_4_1 AT %B124 : WORD;
	END_STRUCT;
END_TYPE
