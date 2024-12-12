NAMESPACE AXOpen.Components.Cognex.Vision
    TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
        Inputs : STRUCT
            is7600_Acquisition_Status_0 AT %B72:  BYTE;
            is7600_Acquisition_Status_1 AT %B73:  BYTE;
            is7600_Acquisition_Status_2 AT %B74:  BYTE;
            is7600_Command_Control AT %B75:  WORD;
            is7600_Inspection_Status AT %B68:  DWORD;
            is7600_Result_Data_64_bytes_0 AT %B0:  DWORD;
            is7600_Result_Data_64_bytes_1 AT %B4:  DWORD;
            is7600_Result_Data_64_bytes_2 AT %B8:  DWORD;
            is7600_Result_Data_64_bytes_3 AT %B12:  DWORD;
            is7600_Result_Data_64_bytes_4 AT %B16:  DWORD;
            is7600_Result_Data_64_bytes_5 AT %B20:  DWORD;
            is7600_Result_Data_64_bytes_6 AT %B24:  DWORD;
            is7600_Result_Data_64_bytes_7 AT %B28:  DWORD;
            is7600_Result_Data_64_bytes_8 AT %B32:  DWORD;
            is7600_Result_Data_64_bytes_9 AT %B36:  DWORD;
            is7600_Result_Data_64_bytes_10 AT %B40:  DWORD;
            is7600_Result_Data_64_bytes_11 AT %B44:  DWORD;
            is7600_Result_Data_64_bytes_12 AT %B48:  DWORD;
            is7600_Result_Data_64_bytes_13 AT %B52:  DWORD;
            is7600_Result_Data_64_bytes_14 AT %B56:  DWORD;
            is7600_Result_Data_64_bytes_15 AT %B60:  DWORD;
            is7600_Result_Data_64_bytes_16 AT %B64:  DWORD;
            is7600_SoftEvent_Control AT %B77:  BYTE;
            reader_st1_Acquisition_Status_0 AT %B292:  BYTE;
            reader_st1_Acquisition_Status_1 AT %B293:  BYTE;
            reader_st1_Acquisition_Status_2 AT %B294:  BYTE;
            reader_st1_Result_Data_128_bytes_0 AT %B155:  LWORD;
            reader_st1_Result_Data_128_bytes_1 AT %B163:  LWORD;
            reader_st1_Result_Data_128_bytes_2 AT %B171:  LWORD;
            reader_st1_Result_Data_128_bytes_3 AT %B179:  LWORD;
            reader_st1_Result_Data_128_bytes_4 AT %B187:  LWORD;
            reader_st1_Result_Data_128_bytes_5 AT %B195:  LWORD;
            reader_st1_Result_Data_128_bytes_6 AT %B203:  LWORD;
            reader_st1_Result_Data_128_bytes_7 AT %B211:  LWORD;
            reader_st1_Result_Data_128_bytes_8 AT %B219:  LWORD;
            reader_st1_Result_Data_128_bytes_9 AT %B227:  LWORD;
            reader_st1_Result_Data_128_bytes_10 AT %B235:  LWORD;
            reader_st1_Result_Data_128_bytes_11 AT %B243:  LWORD;
            reader_st1_Result_Data_128_bytes_12 AT %B251:  LWORD;
            reader_st1_Result_Data_128_bytes_13 AT %B259:  LWORD;
            reader_st1_Result_Data_128_bytes_14 AT %B267:  LWORD;
            reader_st1_Result_Data_128_bytes_15 AT %B275:  LWORD;
            reader_st1_Result_Data_128_bytes_16 AT %B283:  LWORD;
            reader_st1_Results_Status AT %B291:  BYTE;
            reader_st1_Soft_Event_Control AT %B295:  BYTE;
            reader_st2_Acquisition_Status_0 AT %B151:  BYTE;
            reader_st2_Acquisition_Status_1 AT %B152:  BYTE;
            reader_st2_Acquisition_Status_2 AT %B153:  BYTE;
            reader_st2_Result_Data_64_bytes_0 AT %B78:  LWORD;
            reader_st2_Result_Data_64_bytes_1 AT %B86:  LWORD;
            reader_st2_Result_Data_64_bytes_2 AT %B94:  LWORD;
            reader_st2_Result_Data_64_bytes_3 AT %B102:  LWORD;
            reader_st2_Result_Data_64_bytes_4 AT %B110:  LWORD;
            reader_st2_Result_Data_64_bytes_5 AT %B118:  LWORD;
            reader_st2_Result_Data_64_bytes_6 AT %B126:  LWORD;
            reader_st2_Result_Data_64_bytes_7 AT %B134:  LWORD;
            reader_st2_Result_Data_64_bytes_8 AT %B142:  LWORD;
            reader_st2_Results_Status AT %B150:  BYTE;
            reader_st2_Soft_Event_Control AT %B154:  BYTE;
        END_STRUCT;
    END_TYPE
END_NAMESPACE
