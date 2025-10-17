CONFIGURATION IoAddresses
    VAR_GLOBAL

        // Module Axo_CS351/Input_2_word_1
        Axo_CS351_Input_2_word_1_Input AT %IB0 : Axo_CS351_Input_2_word_1_Input_Layout;

        // Module Axo_CS351/Input_4_word_1
        Axo_CS351_Input_4_word_1_Input AT %IB124 : Axo_CS351_Input_4_word_1_Input_Layout;

        // Module Axo_CS351/Input_4_word_10
        Axo_CS351_Input_4_word_10_Input AT %IB52 : Axo_CS351_Input_4_word_10_Input_Layout;

        // Module Axo_CS351/Input_4_word_11
        Axo_CS351_Input_4_word_11_Input AT %IB44 : Axo_CS351_Input_4_word_11_Input_Layout;

        // Module Axo_CS351/Input_4_word_12
        Axo_CS351_Input_4_word_12_Input AT %IB36 : Axo_CS351_Input_4_word_12_Input_Layout;

        // Module Axo_CS351/Input_4_word_13
        Axo_CS351_Input_4_word_13_Input AT %IB28 : Axo_CS351_Input_4_word_13_Input_Layout;

        // Module Axo_CS351/Input_4_word_14
        Axo_CS351_Input_4_word_14_Input AT %IB20 : Axo_CS351_Input_4_word_14_Input_Layout;

        // Module Axo_CS351/Input_4_word_15
        Axo_CS351_Input_4_word_15_Input AT %IB12 : Axo_CS351_Input_4_word_15_Input_Layout;

        // Module Axo_CS351/Input_4_word_16
        Axo_CS351_Input_4_word_16_Input AT %IB4 : Axo_CS351_Input_4_word_16_Input_Layout;

        // Module Axo_CS351/Input_4_word_2
        Axo_CS351_Input_4_word_2_Input AT %IB116 : Axo_CS351_Input_4_word_2_Input_Layout;

        // Module Axo_CS351/Input_4_word_3
        Axo_CS351_Input_4_word_3_Input AT %IB108 : Axo_CS351_Input_4_word_3_Input_Layout;

        // Module Axo_CS351/Input_4_word_4
        Axo_CS351_Input_4_word_4_Input AT %IB100 : Axo_CS351_Input_4_word_4_Input_Layout;

        // Module Axo_CS351/Input_4_word_5
        Axo_CS351_Input_4_word_5_Input AT %IB92 : Axo_CS351_Input_4_word_5_Input_Layout;

        // Module Axo_CS351/Input_4_word_6
        Axo_CS351_Input_4_word_6_Input AT %IB84 : Axo_CS351_Input_4_word_6_Input_Layout;

        // Module Axo_CS351/Input_4_word_7
        Axo_CS351_Input_4_word_7_Input AT %IB76 : Axo_CS351_Input_4_word_7_Input_Layout;

        // Module Axo_CS351/Input_4_word_8
        Axo_CS351_Input_4_word_8_Input AT %IB68 : Axo_CS351_Input_4_word_8_Input_Layout;

        // Module Axo_CS351/Input_4_word_9
        Axo_CS351_Input_4_word_9_Input AT %IB60 : Axo_CS351_Input_4_word_9_Input_Layout;

        // Module Axo_CS351/Output_2_word_1
        Axo_CS351_Output_2_word_1_Output AT %QB0 : Axo_CS351_Output_2_word_1_Output_Layout;

        // Module Axo_CS351/Output_4_word_1
        Axo_CS351_Output_4_word_1_Output AT %QB60 : Axo_CS351_Output_4_word_1_Output_Layout;

        // Module Axo_CS351/Output_4_word_2
        Axo_CS351_Output_4_word_2_Output AT %QB52 : Axo_CS351_Output_4_word_2_Output_Layout;

        // Module Axo_CS351/Output_4_word_3
        Axo_CS351_Output_4_word_3_Output AT %QB44 : Axo_CS351_Output_4_word_3_Output_Layout;

        // Module Axo_CS351/Output_4_word_4
        Axo_CS351_Output_4_word_4_Output AT %QB36 : Axo_CS351_Output_4_word_4_Output_Layout;

        // Module Axo_CS351/Output_4_word_5
        Axo_CS351_Output_4_word_5_Output AT %QB28 : Axo_CS351_Output_4_word_5_Output_Layout;

        // Module Axo_CS351/Output_4_word_6
        Axo_CS351_Output_4_word_6_Output AT %QB20 : Axo_CS351_Output_4_word_6_Output_Layout;

        // Module Axo_CS351/Output_4_word_7
        Axo_CS351_Output_4_word_7_Output AT %QB12 : Axo_CS351_Output_4_word_7_Output_Layout;

        // Module Axo_CS351/Output_4_word_8
        Axo_CS351_Output_4_word_8_Output AT %QB4 : Axo_CS351_Output_4_word_8_Output_Layout;
    END_VAR
END_CONFIGURATION

TYPE
    Axo_CS351_Input_2_word_1_Input_Layout : STRUCT
        Signals_0 AT %B0 : DWORD;
    END_STRUCT;
END_TYPE

TYPE
    Axo_CS351_Input_4_word_1_Input_Layout : STRUCT
        Signals_0 AT %B0 : DWORD;
        Signals_1 AT %B4 : DWORD;
    END_STRUCT;
END_TYPE

TYPE
    Axo_CS351_Input_4_word_10_Input_Layout : STRUCT
        Signals_0 AT %B0 : DWORD;
        Signals_1 AT %B4 : DWORD;
    END_STRUCT;
END_TYPE

TYPE
    Axo_CS351_Input_4_word_11_Input_Layout : STRUCT
        Signals_0 AT %B0 : DWORD;
        Signals_1 AT %B4 : DWORD;
    END_STRUCT;
END_TYPE

TYPE
    Axo_CS351_Input_4_word_12_Input_Layout : STRUCT
        Signals_0 AT %B0 : DWORD;
        Signals_1 AT %B4 : DWORD;
    END_STRUCT;
END_TYPE

TYPE
    Axo_CS351_Input_4_word_13_Input_Layout : STRUCT
        Signals_0 AT %B0 : DWORD;
        Signals_1 AT %B4 : DWORD;
    END_STRUCT;
END_TYPE

TYPE
    Axo_CS351_Input_4_word_14_Input_Layout : STRUCT
        Signals_0 AT %B0 : DWORD;
        Signals_1 AT %B4 : DWORD;
    END_STRUCT;
END_TYPE

TYPE
    Axo_CS351_Input_4_word_15_Input_Layout : STRUCT
        Signals_0 AT %B0 : DWORD;
        Signals_1 AT %B4 : DWORD;
    END_STRUCT;
END_TYPE

TYPE
    Axo_CS351_Input_4_word_16_Input_Layout : STRUCT
        Signals_0 AT %B0 : DWORD;
        Signals_1 AT %B4 : DWORD;
    END_STRUCT;
END_TYPE

TYPE
    Axo_CS351_Input_4_word_2_Input_Layout : STRUCT
        Signals_0 AT %B0 : DWORD;
        Signals_1 AT %B4 : DWORD;
    END_STRUCT;
END_TYPE

TYPE
    Axo_CS351_Input_4_word_3_Input_Layout : STRUCT
        Signals_0 AT %B0 : DWORD;
        Signals_1 AT %B4 : DWORD;
    END_STRUCT;
END_TYPE

TYPE
    Axo_CS351_Input_4_word_4_Input_Layout : STRUCT
        Signals_0 AT %B0 : DWORD;
        Signals_1 AT %B4 : DWORD;
    END_STRUCT;
END_TYPE

TYPE
    Axo_CS351_Input_4_word_5_Input_Layout : STRUCT
        Signals_0 AT %B0 : DWORD;
        Signals_1 AT %B4 : DWORD;
    END_STRUCT;
END_TYPE

TYPE
    Axo_CS351_Input_4_word_6_Input_Layout : STRUCT
        Signals_0 AT %B0 : DWORD;
        Signals_1 AT %B4 : DWORD;
    END_STRUCT;
END_TYPE

TYPE
    Axo_CS351_Input_4_word_7_Input_Layout : STRUCT
        Signals_0 AT %B0 : DWORD;
        Signals_1 AT %B4 : DWORD;
    END_STRUCT;
END_TYPE

TYPE
    Axo_CS351_Input_4_word_8_Input_Layout : STRUCT
        Signals_0 AT %B0 : DWORD;
        Signals_1 AT %B4 : DWORD;
    END_STRUCT;
END_TYPE

TYPE
    Axo_CS351_Input_4_word_9_Input_Layout : STRUCT
        Signals_0 AT %B0 : DWORD;
        Signals_1 AT %B4 : DWORD;
    END_STRUCT;
END_TYPE

TYPE
    Axo_CS351_Output_2_word_1_Output_Layout : STRUCT
        Signals_0 AT %B0 : DWORD;
    END_STRUCT;
END_TYPE

TYPE
    Axo_CS351_Output_4_word_1_Output_Layout : STRUCT
        Signals_0 AT %B0 : DWORD;
        Signals_1 AT %B4 : DWORD;
    END_STRUCT;
END_TYPE

TYPE
    Axo_CS351_Output_4_word_2_Output_Layout : STRUCT
        Signals_0 AT %B0 : DWORD;
        Signals_1 AT %B4 : DWORD;
    END_STRUCT;
END_TYPE

TYPE
    Axo_CS351_Output_4_word_3_Output_Layout : STRUCT
        Signals_0 AT %B0 : DWORD;
        Signals_1 AT %B4 : DWORD;
    END_STRUCT;
END_TYPE

TYPE
    Axo_CS351_Output_4_word_4_Output_Layout : STRUCT
        Signals_0 AT %B0 : DWORD;
        Signals_1 AT %B4 : DWORD;
    END_STRUCT;
END_TYPE

TYPE
    Axo_CS351_Output_4_word_5_Output_Layout : STRUCT
        Signals_0 AT %B0 : DWORD;
        Signals_1 AT %B4 : DWORD;
    END_STRUCT;
END_TYPE

TYPE
    Axo_CS351_Output_4_word_6_Output_Layout : STRUCT
        Signals_0 AT %B0 : DWORD;
        Signals_1 AT %B4 : DWORD;
    END_STRUCT;
END_TYPE

TYPE
    Axo_CS351_Output_4_word_7_Output_Layout : STRUCT
        Signals_0 AT %B0 : DWORD;
        Signals_1 AT %B4 : DWORD;
    END_STRUCT;
END_TYPE

TYPE
    Axo_CS351_Output_4_word_8_Output_Layout : STRUCT
        Signals_0 AT %B0 : DWORD;
        Signals_1 AT %B4 : DWORD;
    END_STRUCT;
END_TYPE
