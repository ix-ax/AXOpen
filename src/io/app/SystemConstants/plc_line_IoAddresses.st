CONFIGURATION IoAddresses
    VAR_GLOBAL

        // Module balluff_bni00l3/BALLUFF_Link_module
        balluff_bni00l3_BALLUFF_Link_module_Input AT %IB0 : balluff_bni00l3_BALLUFF_Link_module_Input_Layout;
        balluff_bni00l3_BALLUFF_Link_module_Output AT %QB0 : balluff_bni00l3_BALLUFF_Link_module_Output_Layout;
    END_VAR
END_CONFIGURATION

TYPE
    balluff_bni00l3_BALLUFF_Link_module_Input_Layout : STRUCT
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
    balluff_bni00l3_BALLUFF_Link_module_Output_Layout : STRUCT
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
