FUNCTION CopyInputs
	VAR_EXTERNAL
		HwInputs : HwInputs; 
		PlcInputs : PlcInputs; 
	END_VAR
	PlcInputs.wp462_t1_rh_deso_Input_1_byte_1 := HwInputs.wp462_t1_rh_deso_Input_1_byte_1;
	PlcInputs.wp462_t1_rh_deso_Input_1_byte_2 := HwInputs.wp462_t1_rh_deso_Input_1_byte_2;
	PlcInputs.wp462_t1_rh_deso_Input_2_word_1 := HwInputs.wp462_t1_rh_deso_Input_2_word_1;
	PlcInputs.wp462_t1_rh_deso_Input_1_word_1 := HwInputs.wp462_t1_rh_deso_Input_1_word_1;
	PlcInputs.wp462_t1_rh_deso_Input_2_word_2 := HwInputs.wp462_t1_rh_deso_Input_2_word_2;
	PlcInputs.wp462_t1_rh_deso_Input_1_word_2 := HwInputs.wp462_t1_rh_deso_Input_1_word_2;
END_FUNCTION
