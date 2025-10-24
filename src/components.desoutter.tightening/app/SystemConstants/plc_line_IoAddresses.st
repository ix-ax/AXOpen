CONFIGURATION IoAddresses
    VAR_GLOBAL

        // Module desoutter_cvic_ii/Input_1_byte_1
        desoutter_cvic_ii_Input_1_byte_1_Input AT %IB13 : desoutter_cvic_ii_Input_1_byte_1_Input_Layout;

        // Module desoutter_cvic_ii/Input_1_byte_2
        desoutter_cvic_ii_Input_1_byte_2_Input AT %IB12 : desoutter_cvic_ii_Input_1_byte_2_Input_Layout;

        // Module desoutter_cvic_ii/Input_1_word_1
        desoutter_cvic_ii_Input_1_word_1_Input AT %IB6 : desoutter_cvic_ii_Input_1_word_1_Input_Layout;

        // Module desoutter_cvic_ii/Input_1_word_2
        desoutter_cvic_ii_Input_1_word_2_Input AT %IB0 : desoutter_cvic_ii_Input_1_word_2_Input_Layout;

        // Module desoutter_cvic_ii/Input_2_word_1
        desoutter_cvic_ii_Input_2_word_1_Input AT %IB8 : desoutter_cvic_ii_Input_2_word_1_Input_Layout;

        // Module desoutter_cvic_ii/Input_2_word_2
        desoutter_cvic_ii_Input_2_word_2_Input AT %IB2 : desoutter_cvic_ii_Input_2_word_2_Input_Layout;

        // Module desoutter_cvic_ii/Output_1_byte_1
        desoutter_cvic_ii_Output_1_byte_1_Output AT %QB1 : desoutter_cvic_ii_Output_1_byte_1_Output_Layout;

        // Module desoutter_cvic_ii/Output_1_byte_2
        desoutter_cvic_ii_Output_1_byte_2_Output AT %QB0 : desoutter_cvic_ii_Output_1_byte_2_Output_Layout;
    END_VAR
END_CONFIGURATION

TYPE
    desoutter_cvic_ii_Input_1_byte_1_Input_Layout : STRUCT
        Signals_0 AT %B0 : BYTE;
    END_STRUCT;
END_TYPE

TYPE
    desoutter_cvic_ii_Input_1_byte_2_Input_Layout : STRUCT
        Signals_0 AT %B0 : BYTE;
    END_STRUCT;
END_TYPE

TYPE
    desoutter_cvic_ii_Input_1_word_1_Input_Layout : STRUCT
        Signals_0 AT %B0 : WORD;
    END_STRUCT;
END_TYPE

TYPE
    desoutter_cvic_ii_Input_1_word_2_Input_Layout : STRUCT
        Signals_0 AT %B0 : WORD;
    END_STRUCT;
END_TYPE

TYPE
    desoutter_cvic_ii_Input_2_word_1_Input_Layout : STRUCT
        Signals_0 AT %B0 : DWORD;
    END_STRUCT;
END_TYPE

TYPE
    desoutter_cvic_ii_Input_2_word_2_Input_Layout : STRUCT
        Signals_0 AT %B0 : DWORD;
    END_STRUCT;
END_TYPE

TYPE
    desoutter_cvic_ii_Output_1_byte_1_Output_Layout : STRUCT
        Signals_0 AT %B0 : BYTE;
    END_STRUCT;
END_TYPE

TYPE
    desoutter_cvic_ii_Output_1_byte_2_Output_Layout : STRUCT
        Signals_0 AT %B0 : BYTE;
    END_STRUCT;
END_TYPE
