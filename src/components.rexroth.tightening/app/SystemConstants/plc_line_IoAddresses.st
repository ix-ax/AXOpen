CONFIGURATION IoAddresses
    VAR_GLOBAL

        // Module rexroth_cs351/Input_2_word_1
        rexroth_cs351_Input_2_word_1_Input AT %IB0 : rexroth_cs351_Input_2_word_1_Input_Layout;

        // Module rexroth_cs351/Input_4_word_1
        rexroth_cs351_Input_4_word_1_Input AT %IB124 : rexroth_cs351_Input_4_word_1_Input_Layout;

        // Module rexroth_cs351/Input_4_word_10
        rexroth_cs351_Input_4_word_10_Input AT %IB52 : rexroth_cs351_Input_4_word_10_Input_Layout;

        // Module rexroth_cs351/Input_4_word_11
        rexroth_cs351_Input_4_word_11_Input AT %IB44 : rexroth_cs351_Input_4_word_11_Input_Layout;

        // Module rexroth_cs351/Input_4_word_12
        rexroth_cs351_Input_4_word_12_Input AT %IB36 : rexroth_cs351_Input_4_word_12_Input_Layout;

        // Module rexroth_cs351/Input_4_word_13
        rexroth_cs351_Input_4_word_13_Input AT %IB28 : rexroth_cs351_Input_4_word_13_Input_Layout;

        // Module rexroth_cs351/Input_4_word_14
        rexroth_cs351_Input_4_word_14_Input AT %IB20 : rexroth_cs351_Input_4_word_14_Input_Layout;

        // Module rexroth_cs351/Input_4_word_15
        rexroth_cs351_Input_4_word_15_Input AT %IB12 : rexroth_cs351_Input_4_word_15_Input_Layout;

        // Module rexroth_cs351/Input_4_word_16
        rexroth_cs351_Input_4_word_16_Input AT %IB4 : rexroth_cs351_Input_4_word_16_Input_Layout;

        // Module rexroth_cs351/Input_4_word_2
        rexroth_cs351_Input_4_word_2_Input AT %IB116 : rexroth_cs351_Input_4_word_2_Input_Layout;

        // Module rexroth_cs351/Input_4_word_3
        rexroth_cs351_Input_4_word_3_Input AT %IB108 : rexroth_cs351_Input_4_word_3_Input_Layout;

        // Module rexroth_cs351/Input_4_word_4
        rexroth_cs351_Input_4_word_4_Input AT %IB100 : rexroth_cs351_Input_4_word_4_Input_Layout;

        // Module rexroth_cs351/Input_4_word_5
        rexroth_cs351_Input_4_word_5_Input AT %IB92 : rexroth_cs351_Input_4_word_5_Input_Layout;

        // Module rexroth_cs351/Input_4_word_6
        rexroth_cs351_Input_4_word_6_Input AT %IB84 : rexroth_cs351_Input_4_word_6_Input_Layout;

        // Module rexroth_cs351/Input_4_word_7
        rexroth_cs351_Input_4_word_7_Input AT %IB76 : rexroth_cs351_Input_4_word_7_Input_Layout;

        // Module rexroth_cs351/Input_4_word_8
        rexroth_cs351_Input_4_word_8_Input AT %IB68 : rexroth_cs351_Input_4_word_8_Input_Layout;

        // Module rexroth_cs351/Input_4_word_9
        rexroth_cs351_Input_4_word_9_Input AT %IB60 : rexroth_cs351_Input_4_word_9_Input_Layout;

        // Module rexroth_cs351/Output_2_word_1
        rexroth_cs351_Output_2_word_1_Output AT %QB0 : rexroth_cs351_Output_2_word_1_Output_Layout;

        // Module rexroth_cs351/Output_4_word_1
        rexroth_cs351_Output_4_word_1_Output AT %QB60 : rexroth_cs351_Output_4_word_1_Output_Layout;

        // Module rexroth_cs351/Output_4_word_2
        rexroth_cs351_Output_4_word_2_Output AT %QB52 : rexroth_cs351_Output_4_word_2_Output_Layout;

        // Module rexroth_cs351/Output_4_word_3
        rexroth_cs351_Output_4_word_3_Output AT %QB44 : rexroth_cs351_Output_4_word_3_Output_Layout;

        // Module rexroth_cs351/Output_4_word_4
        rexroth_cs351_Output_4_word_4_Output AT %QB36 : rexroth_cs351_Output_4_word_4_Output_Layout;

        // Module rexroth_cs351/Output_4_word_5
        rexroth_cs351_Output_4_word_5_Output AT %QB28 : rexroth_cs351_Output_4_word_5_Output_Layout;

        // Module rexroth_cs351/Output_4_word_6
        rexroth_cs351_Output_4_word_6_Output AT %QB20 : rexroth_cs351_Output_4_word_6_Output_Layout;

        // Module rexroth_cs351/Output_4_word_7
        rexroth_cs351_Output_4_word_7_Output AT %QB12 : rexroth_cs351_Output_4_word_7_Output_Layout;

        // Module rexroth_cs351/Output_4_word_8
        rexroth_cs351_Output_4_word_8_Output AT %QB4 : rexroth_cs351_Output_4_word_8_Output_Layout;
    END_VAR
END_CONFIGURATION

TYPE
    rexroth_cs351_Input_2_word_1_Input_Layout : STRUCT
        Signals_0 AT %B0 : DWORD;
    END_STRUCT;
END_TYPE

TYPE
    rexroth_cs351_Input_4_word_1_Input_Layout : STRUCT
        Signals_0 AT %B0 : DWORD;
        Signals_1 AT %B4 : DWORD;
    END_STRUCT;
END_TYPE

TYPE
    rexroth_cs351_Input_4_word_10_Input_Layout : STRUCT
        Signals_0 AT %B0 : DWORD;
        Signals_1 AT %B4 : DWORD;
    END_STRUCT;
END_TYPE

TYPE
    rexroth_cs351_Input_4_word_11_Input_Layout : STRUCT
        Signals_0 AT %B0 : DWORD;
        Signals_1 AT %B4 : DWORD;
    END_STRUCT;
END_TYPE

TYPE
    rexroth_cs351_Input_4_word_12_Input_Layout : STRUCT
        Signals_0 AT %B0 : DWORD;
        Signals_1 AT %B4 : DWORD;
    END_STRUCT;
END_TYPE

TYPE
    rexroth_cs351_Input_4_word_13_Input_Layout : STRUCT
        Signals_0 AT %B0 : DWORD;
        Signals_1 AT %B4 : DWORD;
    END_STRUCT;
END_TYPE

TYPE
    rexroth_cs351_Input_4_word_14_Input_Layout : STRUCT
        Signals_0 AT %B0 : DWORD;
        Signals_1 AT %B4 : DWORD;
    END_STRUCT;
END_TYPE

TYPE
    rexroth_cs351_Input_4_word_15_Input_Layout : STRUCT
        Signals_0 AT %B0 : DWORD;
        Signals_1 AT %B4 : DWORD;
    END_STRUCT;
END_TYPE

TYPE
    rexroth_cs351_Input_4_word_16_Input_Layout : STRUCT
        Signals_0 AT %B0 : DWORD;
        Signals_1 AT %B4 : DWORD;
    END_STRUCT;
END_TYPE

TYPE
    rexroth_cs351_Input_4_word_2_Input_Layout : STRUCT
        Signals_0 AT %B0 : DWORD;
        Signals_1 AT %B4 : DWORD;
    END_STRUCT;
END_TYPE

TYPE
    rexroth_cs351_Input_4_word_3_Input_Layout : STRUCT
        Signals_0 AT %B0 : DWORD;
        Signals_1 AT %B4 : DWORD;
    END_STRUCT;
END_TYPE

TYPE
    rexroth_cs351_Input_4_word_4_Input_Layout : STRUCT
        Signals_0 AT %B0 : DWORD;
        Signals_1 AT %B4 : DWORD;
    END_STRUCT;
END_TYPE

TYPE
    rexroth_cs351_Input_4_word_5_Input_Layout : STRUCT
        Signals_0 AT %B0 : DWORD;
        Signals_1 AT %B4 : DWORD;
    END_STRUCT;
END_TYPE

TYPE
    rexroth_cs351_Input_4_word_6_Input_Layout : STRUCT
        Signals_0 AT %B0 : DWORD;
        Signals_1 AT %B4 : DWORD;
    END_STRUCT;
END_TYPE

TYPE
    rexroth_cs351_Input_4_word_7_Input_Layout : STRUCT
        Signals_0 AT %B0 : DWORD;
        Signals_1 AT %B4 : DWORD;
    END_STRUCT;
END_TYPE

TYPE
    rexroth_cs351_Input_4_word_8_Input_Layout : STRUCT
        Signals_0 AT %B0 : DWORD;
        Signals_1 AT %B4 : DWORD;
    END_STRUCT;
END_TYPE

TYPE
    rexroth_cs351_Input_4_word_9_Input_Layout : STRUCT
        Signals_0 AT %B0 : DWORD;
        Signals_1 AT %B4 : DWORD;
    END_STRUCT;
END_TYPE

TYPE
    rexroth_cs351_Output_2_word_1_Output_Layout : STRUCT
        Signals_0 AT %B0 : DWORD;
    END_STRUCT;
END_TYPE

TYPE
    rexroth_cs351_Output_4_word_1_Output_Layout : STRUCT
        Signals_0 AT %B0 : DWORD;
        Signals_1 AT %B4 : DWORD;
    END_STRUCT;
END_TYPE

TYPE
    rexroth_cs351_Output_4_word_2_Output_Layout : STRUCT
        Signals_0 AT %B0 : DWORD;
        Signals_1 AT %B4 : DWORD;
    END_STRUCT;
END_TYPE

TYPE
    rexroth_cs351_Output_4_word_3_Output_Layout : STRUCT
        Signals_0 AT %B0 : DWORD;
        Signals_1 AT %B4 : DWORD;
    END_STRUCT;
END_TYPE

TYPE
    rexroth_cs351_Output_4_word_4_Output_Layout : STRUCT
        Signals_0 AT %B0 : DWORD;
        Signals_1 AT %B4 : DWORD;
    END_STRUCT;
END_TYPE

TYPE
    rexroth_cs351_Output_4_word_5_Output_Layout : STRUCT
        Signals_0 AT %B0 : DWORD;
        Signals_1 AT %B4 : DWORD;
    END_STRUCT;
END_TYPE

TYPE
    rexroth_cs351_Output_4_word_6_Output_Layout : STRUCT
        Signals_0 AT %B0 : DWORD;
        Signals_1 AT %B4 : DWORD;
    END_STRUCT;
END_TYPE

TYPE
    rexroth_cs351_Output_4_word_7_Output_Layout : STRUCT
        Signals_0 AT %B0 : DWORD;
        Signals_1 AT %B4 : DWORD;
    END_STRUCT;
END_TYPE

TYPE
    rexroth_cs351_Output_4_word_8_Output_Layout : STRUCT
        Signals_0 AT %B0 : DWORD;
        Signals_1 AT %B4 : DWORD;
    END_STRUCT;
END_TYPE
