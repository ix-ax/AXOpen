CONFIGURATION IoAddresses
    VAR_GLOBAL

        // Module TZ535-PN/In_Out_64_byte
        TZ535_PN_In_Out_64_byte_Input AT %IB0 : TZ535_PN_In_Out_64_byte_Input_Layout;
        TZ535_PN_In_Out_64_byte_Output AT %QB0 : TZ535_PN_In_Out_64_byte_Output_Layout;
    END_VAR
END_CONFIGURATION

TYPE
    TZ535_PN_In_Out_64_byte_Input_Layout : STRUCT
        Signals_0 AT %B0 : ARRAY[0..63] OF BYTE;
    END_STRUCT;
END_TYPE

TYPE
    TZ535_PN_In_Out_64_byte_Output_Layout : STRUCT
        Signals_1 AT %B0 : ARRAY[0..63] OF BYTE;
    END_STRUCT;
END_TYPE
