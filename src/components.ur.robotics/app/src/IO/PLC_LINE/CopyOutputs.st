FUNCTION CopyOutputs
	VAR_EXTERNAL
		HwOutputs : HwOutputs; 
		PlcOutputs : PlcOutputs; 
	END_VAR
	HwOutputs._moveHomeSignal_1 := PlcOutputs._moveHomeSignal_1;
	HwOutputs._moveWorkSignal_1 := PlcOutputs._moveWorkSignal_1;
	HwOutputs._moveHomeSignal_2 := PlcOutputs._moveHomeSignal_2;
	HwOutputs._moveWorkSignal_2 := PlcOutputs._moveWorkSignal_2;
END_FUNCTION
