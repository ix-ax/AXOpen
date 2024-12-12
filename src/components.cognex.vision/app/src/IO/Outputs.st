NAMESPACE AXOpen.Components.Cognex.Vision
    TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
        Outputs : STRUCT
            is7600_Acquisition_Control AT %B68:  BYTE;
            is7600_Command_Control AT %B64:  WORD;
            is7600_Inspection_Control AT %B67:  BYTE;
            is7600_SoftEvent_Control AT %B66:  BYTE;
            is7600_User_Data_64_bytes_0 AT %B0:  LWORD;
            is7600_User_Data_64_bytes_1 AT %B8:  LWORD;
            is7600_User_Data_64_bytes_2 AT %B16:  LWORD;
            is7600_User_Data_64_bytes_3 AT %B24:  LWORD;
            is7600_User_Data_64_bytes_4 AT %B32:  LWORD;
            is7600_User_Data_64_bytes_5 AT %B40:  LWORD;
            is7600_User_Data_64_bytes_6 AT %B48:  LWORD;
            is7600_User_Data_64_bytes_7 AT %B56:  LWORD;
            reader_st1_Acquisition_Control AT %B274:  BYTE;
            reader_st1_Results_Control AT %B273:  BYTE;
            reader_st1_Soft_Event_Control AT %B272:  BYTE;
            reader_st1_User_Data_128_bytes_0 AT %B140:  DWORD;
            reader_st1_User_Data_128_bytes_1 AT %B144:  DWORD;
            reader_st1_User_Data_128_bytes_2 AT %B148:  DWORD;
            reader_st1_User_Data_128_bytes_3 AT %B152:  DWORD;
            reader_st1_User_Data_128_bytes_4 AT %B156:  DWORD;
            reader_st1_User_Data_128_bytes_5 AT %B160:  DWORD;
            reader_st1_User_Data_128_bytes_6 AT %B164:  DWORD;
            reader_st1_User_Data_128_bytes_7 AT %B168:  DWORD;
            reader_st1_User_Data_128_bytes_8 AT %B172:  DWORD;
            reader_st1_User_Data_128_bytes_9 AT %B176:  DWORD;
            reader_st1_User_Data_128_bytes_10 AT %B180:  DWORD;
            reader_st1_User_Data_128_bytes_11 AT %B184:  DWORD;
            reader_st1_User_Data_128_bytes_12 AT %B188:  DWORD;
            reader_st1_User_Data_128_bytes_13 AT %B192:  DWORD;
            reader_st1_User_Data_128_bytes_14 AT %B196:  DWORD;
            reader_st1_User_Data_128_bytes_15 AT %B200:  DWORD;
            reader_st1_User_Data_128_bytes_16 AT %B204:  DWORD;
            reader_st1_User_Data_128_bytes_17 AT %B208:  DWORD;
            reader_st1_User_Data_128_bytes_18 AT %B212:  DWORD;
            reader_st1_User_Data_128_bytes_19 AT %B216:  DWORD;
            reader_st1_User_Data_128_bytes_20 AT %B220:  DWORD;
            reader_st1_User_Data_128_bytes_21 AT %B224:  DWORD;
            reader_st1_User_Data_128_bytes_22 AT %B228:  DWORD;
            reader_st1_User_Data_128_bytes_23 AT %B232:  DWORD;
            reader_st1_User_Data_128_bytes_24 AT %B236:  DWORD;
            reader_st1_User_Data_128_bytes_25 AT %B240:  DWORD;
            reader_st1_User_Data_128_bytes_26 AT %B244:  DWORD;
            reader_st1_User_Data_128_bytes_27 AT %B248:  DWORD;
            reader_st1_User_Data_128_bytes_28 AT %B252:  DWORD;
            reader_st1_User_Data_128_bytes_29 AT %B256:  DWORD;
            reader_st1_User_Data_128_bytes_30 AT %B260:  DWORD;
            reader_st1_User_Data_128_bytes_31 AT %B264:  DWORD;
            reader_st1_User_Data_128_bytes_32 AT %B268:  DWORD;
            reader_st2_Acquisition_Control AT %B139:  BYTE;
            reader_st2_Results_Control AT %B138:  BYTE;
            reader_st2_Soft_Event_Control AT %B137:  BYTE;
            reader_st2_User_Data_64_bytes_0 AT %B69:  DWORD;
            reader_st2_User_Data_64_bytes_1 AT %B73:  DWORD;
            reader_st2_User_Data_64_bytes_2 AT %B77:  DWORD;
            reader_st2_User_Data_64_bytes_3 AT %B81:  DWORD;
            reader_st2_User_Data_64_bytes_4 AT %B85:  DWORD;
            reader_st2_User_Data_64_bytes_5 AT %B89:  DWORD;
            reader_st2_User_Data_64_bytes_6 AT %B93:  DWORD;
            reader_st2_User_Data_64_bytes_7 AT %B97:  DWORD;
            reader_st2_User_Data_64_bytes_8 AT %B101:  DWORD;
            reader_st2_User_Data_64_bytes_9 AT %B105:  DWORD;
            reader_st2_User_Data_64_bytes_10 AT %B109:  DWORD;
            reader_st2_User_Data_64_bytes_11 AT %B113:  DWORD;
            reader_st2_User_Data_64_bytes_12 AT %B117:  DWORD;
            reader_st2_User_Data_64_bytes_13 AT %B121:  DWORD;
            reader_st2_User_Data_64_bytes_14 AT %B125:  DWORD;
            reader_st2_User_Data_64_bytes_15 AT %B129:  DWORD;
            reader_st2_User_Data_64_bytes_16 AT %B133:  DWORD;
        END_STRUCT;
    END_TYPE
END_NAMESPACE
