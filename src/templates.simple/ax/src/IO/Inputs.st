NAMESPACE axosimple    
    TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
        Inputs : STRUCT

            P0 : ARRAY[0..7] OF BOOL;
            P1 : ARRAY[0..7] OF BOOL;

            A0: ARRAY[0..7] OF DINT;
            A1 : ARRAY[0..7] OF DINT;

            D0 : ARRAY[0..7] OF BOOL;
            D1 : ARRAY[0..7] OF BOOL;


            // Reader_1_Acquisition_Status_1 : ARRAY[0..2] OF BYTE;
            // Reader_1_Results_Status_1 : BYTE;
            // Reader_1_Soft_Event_Control_1 : BYTE;
            // Reader_1_Result_Data_128_bytes_1 : ARRAY[0..135] OF BYTE;
            
            // Reader_2_Acquisition_Status_1 : ARRAY[0..2] OF BYTE;
            // Reader_2_Results_Status_1 : BYTE;
            // Reader_2_Soft_Event_Control_1 : BYTE;
            // Reader_2_Result_Data_128_bytes_1 : ARRAY[0..135] OF BYTE;
            
            // Camera_1_Acquisition_Status_1 : ARRAY[0..2] OF BYTE;
            // Camera_1_Inspection_Status_1 : DWORD;
            // Camera_1_Command_Control_1 : WORD;
            // Camera_1_SoftEvent_Control_1 : BYTE;
            // Camera_1_Results_64_bytes_1 : ARRAY[0..67] OF BYTE;

            // Camera_2_Acquisition_Status_1 : ARRAY[0..2] OF BYTE;
            // Camera_2_Inspection_Status_1 : DWORD;
            // Camera_2_Command_Control_1 : WORD;
            // Camera_2_SoftEvent_Control_1 : BYTE;
            // Camera_2_Results_64_bytes_1 : ARRAY[0..67] OF BYTE;


        END_STRUCT;
    END_TYPE 
END_NAMESPACE
