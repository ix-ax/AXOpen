CONFIGURATION IoAddresses
    VAR_GLOBAL

        // Module wp462-t1-rh-deso/Input_1_byte_1
        wp462_t1_rh_deso_Input_1_byte_1_Input AT %IB13 : wp462_t1_rh_deso_Input_1_byte_1_Input_Layout;

        // Module wp462-t1-rh-deso/Input_1_byte_2
        wp462_t1_rh_deso_Input_1_byte_2_Input AT %IB12 : wp462_t1_rh_deso_Input_1_byte_2_Input_Layout;

        // Module wp462-t1-rh-deso/Input_1_word_1
        wp462_t1_rh_deso_Input_1_word_1_Input AT %IB6 : wp462_t1_rh_deso_Input_1_word_1_Input_Layout;

        // Module wp462-t1-rh-deso/Input_1_word_2
        wp462_t1_rh_deso_Input_1_word_2_Input AT %IB0 : wp462_t1_rh_deso_Input_1_word_2_Input_Layout;

        // Module wp462-t1-rh-deso/Input_2_word_1
        wp462_t1_rh_deso_Input_2_word_1_Input AT %IB8 : wp462_t1_rh_deso_Input_2_word_1_Input_Layout;

        // Module wp462-t1-rh-deso/Input_2_word_2
        wp462_t1_rh_deso_Input_2_word_2_Input AT %IB2 : wp462_t1_rh_deso_Input_2_word_2_Input_Layout;

        // Module wp462-t1-rh-deso/Output_1_byte_1
        wp462_t1_rh_deso_Output_1_byte_1_Output AT %QB1 : wp462_t1_rh_deso_Output_1_byte_1_Output_Layout;

        // Module wp462-t1-rh-deso/Output_1_byte_2
        wp462_t1_rh_deso_Output_1_byte_2_Output AT %QB0 : wp462_t1_rh_deso_Output_1_byte_2_Output_Layout;
    END_VAR
END_CONFIGURATION

TYPE
    wp462_t1_rh_deso_Input_1_byte_1_Input_Layout : STRUCT
        Signals_0 AT %B0 : BYTE;
    END_STRUCT;
END_TYPE

TYPE
    wp462_t1_rh_deso_Input_1_byte_2_Input_Layout : STRUCT
        Signals_0 AT %B0 : BYTE;
    END_STRUCT;
END_TYPE

TYPE
    wp462_t1_rh_deso_Input_1_word_1_Input_Layout : STRUCT
        Signals_0 AT %B0 : WORD;
    END_STRUCT;
END_TYPE

TYPE
    wp462_t1_rh_deso_Input_1_word_2_Input_Layout : STRUCT
        Signals_0 AT %B0 : WORD;
    END_STRUCT;
END_TYPE

TYPE
    wp462_t1_rh_deso_Input_2_word_1_Input_Layout : STRUCT
        Signals_0 AT %B0 : DWORD;
    END_STRUCT;
END_TYPE

TYPE
    wp462_t1_rh_deso_Input_2_word_2_Input_Layout : STRUCT
        Signals_0 AT %B0 : DWORD;
    END_STRUCT;
END_TYPE

TYPE
    wp462_t1_rh_deso_Output_1_byte_1_Output_Layout : STRUCT
        Signals_0 AT %B0 : BYTE;
    END_STRUCT;
END_TYPE

TYPE
    wp462_t1_rh_deso_Output_1_byte_2_Output_Layout : STRUCT
        Signals_0 AT %B0 : BYTE;
    END_STRUCT;
END_TYPE
