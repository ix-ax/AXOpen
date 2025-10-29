CONFIGURATION IoAddresses
    VAR_GLOBAL

        // Module zebra/Data88Bin6Bout
        zebra_Data88Bin6Bout_Input AT %IB0 : zebra_Data88Bin6Bout_Input_Layout;
        zebra_Data88Bin6Bout_Output AT %QB0 : zebra_Data88Bin6Bout_Output_Layout;
    END_VAR
END_CONFIGURATION

TYPE
    zebra_Data88Bin6Bout_Input_Layout : STRUCT
        Signals_0 AT %B0 : ARRAY[0..703] OF BOOL;
    END_STRUCT;
END_TYPE

TYPE
    zebra_Data88Bin6Bout_Output_Layout : STRUCT
        Signals_1_0 AT %X0.0 : BOOL;
        Signals_1_1 AT %X0.1 : BOOL;
        Signals_1_2 AT %X0.2 : BOOL;
        Signals_1_3 AT %X0.3 : BOOL;
        Signals_1_4 AT %X0.4 : BOOL;
        Signals_1_5 AT %X0.5 : BOOL;
        Signals_1_6 AT %X0.6 : BOOL;
        Signals_1_7 AT %X0.7 : BOOL;
        Signals_1_8 AT %X1.0 : BOOL;
        Signals_1_9 AT %X1.1 : BOOL;
        Signals_1_10 AT %X1.2 : BOOL;
        Signals_1_11 AT %X1.3 : BOOL;
        Signals_1_12 AT %X1.4 : BOOL;
        Signals_1_13 AT %X1.5 : BOOL;
        Signals_1_14 AT %X1.6 : BOOL;
        Signals_1_15 AT %X1.7 : BOOL;
        Signals_1_16 AT %X2.0 : BOOL;
        Signals_1_17 AT %X2.1 : BOOL;
        Signals_1_18 AT %X2.2 : BOOL;
        Signals_1_19 AT %X2.3 : BOOL;
        Signals_1_20 AT %X2.4 : BOOL;
        Signals_1_21 AT %X2.5 : BOOL;
        Signals_1_22 AT %X2.6 : BOOL;
        Signals_1_23 AT %X2.7 : BOOL;
        Signals_1_24 AT %X3.0 : BOOL;
        Signals_1_25 AT %X3.1 : BOOL;
        Signals_1_26 AT %X3.2 : BOOL;
        Signals_1_27 AT %X3.3 : BOOL;
        Signals_1_28 AT %X3.4 : BOOL;
        Signals_1_29 AT %X3.5 : BOOL;
        Signals_1_30 AT %X3.6 : BOOL;
        Signals_1_31 AT %X3.7 : BOOL;
        Signals_1_32 AT %X4.0 : BOOL;
        Signals_1_33 AT %X4.1 : BOOL;
        Signals_1_34 AT %X4.2 : BOOL;
        Signals_1_35 AT %X4.3 : BOOL;
        Signals_1_36 AT %X4.4 : BOOL;
        Signals_1_37 AT %X4.5 : BOOL;
        Signals_1_38 AT %X4.6 : BOOL;
        Signals_1_39 AT %X4.7 : BOOL;
        Signals_1_40 AT %X5.0 : BOOL;
        Signals_1_41 AT %X5.1 : BOOL;
        Signals_1_42 AT %X5.2 : BOOL;
        Signals_1_43 AT %X5.3 : BOOL;
        Signals_1_44 AT %X5.4 : BOOL;
        Signals_1_45 AT %X5.5 : BOOL;
        Signals_1_46 AT %X5.6 : BOOL;
        Signals_1_47 AT %X5.7 : BOOL;
    END_STRUCT;
END_TYPE
