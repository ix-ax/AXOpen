FUNCTION CopyInputs
	VAR_EXTERNAL
		HwInputs : HwInputs; 
		PlcInputs : PlcInputs; 
	END_VAR
	PlcInputs._homeSensor_1	:= HwInputs._homeSensor_1;
	PlcInputs._workSensor_1	:= HwInputs._workSensor_1;
	PlcInputs._homeSensor_2	:= HwInputs._homeSensor_2;
	PlcInputs._workSensor_2	:= HwInputs._workSensor_2;
END_FUNCTION
