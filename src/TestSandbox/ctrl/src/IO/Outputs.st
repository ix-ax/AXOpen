NAMESPACE sandboxtest    
    TYPE
      {#ix-attr:[Container(Layout.Wrap)]}
      Outputs : STRUCT
        B0 : ARRAY[0..7] OF BOOL;
        B1 : ARRAY[0..7] OF BOOL;
        B2 : ARRAY[0..7] OF BOOL;
        B3 : ARRAY[0..7] OF BOOL;
        B4 : ARRAY[0..7] OF BOOL;
        B5 : ARRAY[0..7] OF BOOL;
        B7 : ARRAY[0..7] OF BOOL;
        B8 : ARRAY[0..7] OF BOOL;


        _Reader_0_Acquisition_Control_1 : BYTE;
        _Reader_0_Results_Control_1 : BYTE;
        _Reader_0_Soft_Event_Control_1 : BYTE;
        _Reader_0_User_Data_128_bytes_1 : ARRAY[0..131] OF BYTE;

        _Reader_1_Acquisition_Control_1 : BYTE;
        _Reader_1_Results_Control_1 : BYTE;
        _Reader_1_Soft_Event_Control_1 : BYTE;
        _Reader_1_User_Data_128_bytes_1 : ARRAY[0..131] OF BYTE;

        
        _Camera_0_Acquisition_Control_1 : BYTE;
        _Camera_0_Inspection_Control_1 : BYTE;
        _Camera_0_Command_Control_1 : WORD;
        _Camera_0_SoftEvent_Control_1 : BYTE;
        _Camera_0_User_Data_64_bytes_1 : ARRAY[0..63] OF BYTE;


        _Camera_1_Acquisition_Control_1 : BYTE;
        _Camera_1_Inspection_Control_1 : BYTE;
        _Camera_1_Command_Control_1 : WORD;
        _Camera_1_SoftEvent_Control_1 : BYTE;
        _Camera_1_User_Data_64_bytes_1 : ARRAY[0..63] OF BYTE;


      END_STRUCT;
    END_TYPE
END_NAMESPACE