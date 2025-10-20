CONFIGURATION IoAddresses
    VAR_GLOBAL

        // Module SFK/Input_24_Words
        SFK_Input_24_Words_Input AT %IB0 : SFK_Input_24_Words_Input_Layout;

        // Module SFK/Output_21_Words
        SFK_Output_21_Words_Output AT %QB0 : SFK_Output_21_Words_Output_Layout;

        // Module SFK/ParamCh_5Words
        SFK_ParamCh_5Words_Input AT %IB48 : SFK_ParamCh_5Words_Input_Layout;
        SFK_ParamCh_5Words_Output AT %QB42 : SFK_ParamCh_5Words_Output_Layout;
    END_VAR
END_CONFIGURATION

TYPE
    SFK_Input_24_Words_Input_Layout : STRUCT
        Signals_0 AT %B0 : WORD;
        Signals_1 AT %B2 : WORD;
        Signals_2 AT %B4 : WORD;
        Signals_3 AT %B6 : WORD;
        Signals_4 AT %B8 : WORD;
        Signals_5 AT %B10 : WORD;
        Signals_6 AT %B12 : WORD;
        Signals_7 AT %B14 : WORD;
        Signals_8 AT %B16 : WORD;
        Signals_9 AT %B18 : WORD;
        Signals_10 AT %B20 : WORD;
        Signals_11 AT %B22 : WORD;
        Signals_12 AT %B24 : WORD;
        Signals_13 AT %B26 : WORD;
        Signals_14 AT %B28 : WORD;
        Signals_15 AT %B30 : WORD;
        Signals_16 AT %B32 : WORD;
        Signals_17 AT %B34 : WORD;
        Signals_18 AT %B36 : WORD;
        Signals_19 AT %B38 : WORD;
        Signals_20 AT %B40 : WORD;
        Signals_21 AT %B42 : WORD;
        Signals_22 AT %B44 : WORD;
        Signals_23 AT %B46 : WORD;
    END_STRUCT;
END_TYPE

TYPE
    SFK_Output_21_Words_Output_Layout : STRUCT
        Signals_0 AT %B0 : WORD;
        Signals_1 AT %B2 : WORD;
        Signals_2 AT %B4 : WORD;
        Signals_3 AT %B6 : WORD;
        Signals_4 AT %B8 : WORD;
        Signals_5 AT %B10 : WORD;
        Signals_6 AT %B12 : WORD;
        Signals_7 AT %B14 : WORD;
        Signals_8 AT %B16 : WORD;
        Signals_9 AT %B18 : WORD;
        Signals_10 AT %B20 : WORD;
        Signals_11 AT %B22 : WORD;
        Signals_12 AT %B24 : WORD;
        Signals_13 AT %B26 : WORD;
        Signals_14 AT %B28 : WORD;
        Signals_15 AT %B30 : WORD;
        Signals_16 AT %B32 : WORD;
        Signals_17 AT %B34 : WORD;
        Signals_18 AT %B36 : WORD;
        Signals_19 AT %B38 : WORD;
        Signals_20 AT %B40 : WORD;
    END_STRUCT;
END_TYPE

TYPE
    SFK_ParamCh_5Words_Input_Layout : STRUCT
        Signals_0 AT %B0 : WORD;
        Signals_1 AT %B2 : WORD;
        Signals_2 AT %B4 : WORD;
        Signals_3 AT %B6 : WORD;
        Signals_4 AT %B8 : WORD;
    END_STRUCT;
END_TYPE

TYPE
    SFK_ParamCh_5Words_Output_Layout : STRUCT
        Signals_5 AT %B0 : WORD;
        Signals_6 AT %B2 : WORD;
        Signals_7 AT %B4 : WORD;
        Signals_8 AT %B6 : WORD;
        Signals_9 AT %B8 : WORD;
    END_STRUCT;
END_TYPE
