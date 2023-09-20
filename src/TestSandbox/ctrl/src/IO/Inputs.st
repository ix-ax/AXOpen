NAMESPACE sandboxtest
    TYPE
        {#ix-attr:[Container(Layout.Wrap)]}
        Inputs : STRUCT
            B0 : ARRAY[0..7] OF BOOL;
            B1 : ARRAY[0..7] OF BOOL;
            B2 : ARRAY[0..7] OF BOOL;
            B3 : ARRAY[0..7] OF BOOL;
            B4 : ARRAY[0..7] OF BOOL;
            B5 : ARRAY[0..7] OF BOOL;
            B7 : ARRAY[0..7] OF BOOL;
            B8 : ARRAY[0..7] OF BOOL;
       
        _Reader_0_Acquisition_Status_1 : ARRAY[0..2] OF BYTE;
		_Reader_0_Results_Status_1 : BYTE;
		_Reader_0_Soft_Event_Control_1 : BYTE;
		_Reader_0_Result_Data_128_bytes_1 : ARRAY[0..135] OF BYTE;
       
        _Reader_1_Acquisition_Status_1 : ARRAY[0..2] OF BYTE;
		_Reader_1_Results_Status_1 : BYTE;
		_Reader_1_Soft_Event_Control_1 : BYTE;
		_Reader_1_Result_Data_128_bytes_1 : ARRAY[0..135] OF BYTE;
       
       
        _Camera_0_Acquisition_Status_1 : ARRAY[0..2] OF BYTE;
		_Camera_0_Inspection_Status_1 : DWORD;
		_Camera_0_Command_Control_1 : WORD;
		_Camera_0_SoftEvent_Control_1 : BYTE;
		_Camera_0_Results_64_bytes_1 : ARRAY[0..67] OF BYTE;

        _Camera_1_Acquisition_Status_1 : ARRAY[0..2] OF BYTE;
		_Camera_1_Inspection_Status_1 : DWORD;
		_Camera_1_Command_Control_1 : WORD;
		_Camera_1_SoftEvent_Control_1 : BYTE;
		_Camera_1_Results_64_bytes_1 : ARRAY[0..67] OF BYTE;

        END_STRUCT;
    END_TYPE 
END_NAMESPACE