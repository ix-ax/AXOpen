TYPE
	HwOutputs : STRUCT
		RobotBasicIO_DO_64_bytes_1 AT %B0 : ARRAY[0..63] OF BYTE;
		OmniCore_DO_64_bytes_1 AT %B64 : ARRAY[0..63] OF BYTE;
	END_STRUCT;
END_TYPE
