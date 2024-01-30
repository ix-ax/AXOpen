TYPE
	HwInputs : STRUCT
		RobotBasicIO_DI_64_bytes_1 AT %B0 : ARRAY[0..63] OF BYTE;
		OmniCore_DI_64_bytes_1 AT %B64 : ARRAY[0..63] OF BYTE;
	END_STRUCT;
END_TYPE
