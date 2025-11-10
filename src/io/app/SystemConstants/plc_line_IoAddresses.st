CONFIGURATION IoAddresses
    VAR_GLOBAL

        // Module bnixg35080b5r067/IDM_LinkModule
        bnixg35080b5r067_IDM_LinkModule_BALLUFF_8_Port_IO_Link_Master_Input AT %IB0 : bnixg35080b5r067_IDM_LinkModule_BALLUFF_8_Port_IO_Link_Master_Input_Layout;
        bnixg35080b5r067_IDM_LinkModule_BALLUFF_8_Port_IO_Link_Master_Output AT %QB0 : bnixg35080b5r067_IDM_LinkModule_BALLUFF_8_Port_IO_Link_Master_Output_Layout;
        bnixg35080b5r067_IDM_LinkModule_X01_Input AT %IB1 : bnixg35080b5r067_IDM_LinkModule_X01_Input_Layout;
    END_VAR
END_CONFIGURATION

TYPE
    bnixg35080b5r067_IDM_LinkModule_BALLUFF_8_Port_IO_Link_Master_Input_Layout : STRUCT
        Signals_0 AT %X0.0 : BOOL;
        Signals_1 AT %X0.1 : BOOL;
        Signals_2 AT %X0.2 : BOOL;
        Signals_3 AT %X0.3 : BOOL;
        Signals_4 AT %X0.4 : BOOL;
        Signals_5 AT %X0.5 : BOOL;
        Signals_6 AT %X0.6 : BOOL;
        Signals_7 AT %X0.7 : BOOL;
    END_STRUCT;
END_TYPE

TYPE
    bnixg35080b5r067_IDM_LinkModule_BALLUFF_8_Port_IO_Link_Master_Output_Layout : STRUCT
        Signals_8 AT %X0.0 : BOOL;
        Signals_9 AT %X0.1 : BOOL;
        Signals_10 AT %X0.2 : BOOL;
        Signals_11 AT %X0.3 : BOOL;
        Signals_12 AT %X0.4 : BOOL;
        Signals_13 AT %X0.5 : BOOL;
        Signals_14 AT %X0.6 : BOOL;
        Signals_15 AT %X0.7 : BOOL;
    END_STRUCT;
END_TYPE

TYPE
    bnixg35080b5r067_IDM_LinkModule_X01_Input_Layout : STRUCT
        Signals_0 AT %B0 : ARRAY[0..1] OF BYTE;
        Signals_1 AT %X2.2 : BOOL;
        Signals_2 AT %X2.3 : BOOL;
        Signals_3 AT %X2.4 : BOOL;
        Signals_4 AT %X2.5 : BOOL;
        Signals_5 AT %X2.6 : BOOL;
        Signals_6 AT %X2.7 : BOOL;
    END_STRUCT;
END_TYPE
