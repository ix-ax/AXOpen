FUNCTION CopyInputs
	VAR_EXTERNAL
		HwInputs : HwInputs; 
		PlcInputs : PlcInputs; 
	END_VAR
	PlcInputs.ET200SP_DI_8x24VDC_ST_V1_1_1 := HwInputs.ET200SP_DI_8x24VDC_ST_V1_1_1;
END_FUNCTION
