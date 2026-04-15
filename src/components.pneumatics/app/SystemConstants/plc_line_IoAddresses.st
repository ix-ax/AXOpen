CONFIGURATION IoAddresses
    VAR_GLOBAL

        // Module aes-d-bc-pnio/Slot_1
        aes_d_bc_pnio_Slot_1_Output AT %QB0 : aes_d_bc_pnio_Slot_1_Output_Layout;

        // Module plc_line/A1
        plc_line_A1_Input AT %IB0 : plc_line_A1_Input_Layout;
    END_VAR
END_CONFIGURATION

TYPE
    aes_d_bc_pnio_Slot_1_Output_Layout : STRUCT
        Signals_0_0 AT %X0.0 : BOOL;
        Signals_0_1 AT %X0.1 : BOOL;
        Signals_0_2 AT %X0.2 : BOOL;
        Signals_0_3 AT %X0.3 : BOOL;
        Signals_0_4 AT %X0.4 : BOOL;
        Signals_0_5 AT %X0.5 : BOOL;
        Signals_0_6 AT %X0.6 : BOOL;
        Signals_0_7 AT %X0.7 : BOOL;
    END_STRUCT;
END_TYPE

TYPE
    plc_line_A1_Input_Layout : STRUCT
        Channel_00DI AT %X0.0 : BOOL;
        Channel_01DI AT %X0.1 : BOOL;
        Channel_02DI AT %X0.2 : BOOL;
        Channel_03DI AT %X0.3 : BOOL;
        Channel_04DI AT %X0.4 : BOOL;
        Channel_05DI AT %X0.5 : BOOL;
        Channel_06DI AT %X0.6 : BOOL;
        Channel_07DI AT %X0.7 : BOOL;
        Channel_08DI AT %X1.0 : BOOL;
        Channel_09DI AT %X1.1 : BOOL;
        Channel_10DI AT %X1.2 : BOOL;
        Channel_11DI AT %X1.3 : BOOL;
        Channel_12DI AT %X1.4 : BOOL;
        Channel_13DI AT %X1.5 : BOOL;
        Channel_14DI AT %X1.6 : BOOL;
        Channel_15DI AT %X1.7 : BOOL;
        Channel_16DI AT %X2.0 : BOOL;
        Channel_17DI AT %X2.1 : BOOL;
        Channel_18DI AT %X2.2 : BOOL;
        Channel_19DI AT %X2.3 : BOOL;
        Channel_20DI AT %X2.4 : BOOL;
        Channel_21DI AT %X2.5 : BOOL;
        Channel_22DI AT %X2.6 : BOOL;
        Channel_23DI AT %X2.7 : BOOL;
        Channel_24DI AT %X3.0 : BOOL;
        Channel_25DI AT %X3.1 : BOOL;
        Channel_26DI AT %X3.2 : BOOL;
        Channel_27DI AT %X3.3 : BOOL;
        Channel_28DI AT %X3.4 : BOOL;
        Channel_29DI AT %X3.5 : BOOL;
        Channel_30DI AT %X3.6 : BOOL;
        Channel_31DI AT %X3.7 : BOOL;
    END_STRUCT;
END_TYPE
