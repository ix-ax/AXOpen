FUNCTION CopyOutputs
	VAR_EXTERNAL
		HwOutputs : HwOutputs; 
		PlcOutputs : PlcOutputs; 
	END_VAR
	HwOutputs.wp462_t1_rh_deso_Output_1_byte_1 := PlcOutputs.wp462_t1_rh_deso_Output_1_byte_1;
	HwOutputs.wp462_t1_rh_deso_Output_1_byte_2 := PlcOutputs.wp462_t1_rh_deso_Output_1_byte_2;
END_FUNCTION
