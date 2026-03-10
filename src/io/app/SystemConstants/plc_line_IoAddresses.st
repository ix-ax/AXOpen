CONFIGURATION IoAddresses
    VAR_GLOBAL

        // Module bni00l3/BALLUFF_Link_module
        bni00l3_BALLUFF_Link_module_BALLUFF_8_Port_IO_Link_Master_Input AT %IB0 : bni00l3_BALLUFF_Link_module_BALLUFF_8_Port_IO_Link_Master_Input_Layout;
        bni00l3_BALLUFF_Link_module_BALLUFF_8_Port_IO_Link_Master_Output AT %QB0 : bni00l3_BALLUFF_Link_module_BALLUFF_8_Port_IO_Link_Master_Output_Layout;
        bni00l3_BALLUFF_Link_module_X01_Input AT %IB1 : bni00l3_BALLUFF_Link_module_X01_Input_Layout;
        bni00l3_BALLUFF_Link_module_X02_Input AT %IB6 : bni00l3_BALLUFF_Link_module_X02_Input_Layout;
        bni00l3_BALLUFF_Link_module_X03_Input AT %IB43 : bni00l3_BALLUFF_Link_module_X03_Input_Layout;
        bni00l3_BALLUFF_Link_module_X04_Input AT %IB46 : bni00l3_BALLUFF_Link_module_X04_Input_Layout;

        // Module et200sp/A10
        et200sp_A10_Input AT %IB41 : et200sp_A10_Input_Layout;

        // Module et200sp/A20
        et200sp_A20_Output AT %QB33 : et200sp_A20_Output_Layout;

        // Module et200sp/A30
        et200sp_A30_Input AT %IB9 : et200sp_A30_Input_Layout;
        et200sp_A30_Output AT %QB1 : et200sp_A30_Output_Layout;
    END_VAR
END_CONFIGURATION

TYPE
    bni00l3_BALLUFF_Link_module_BALLUFF_8_Port_IO_Link_Master_Input_Layout : STRUCT
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
    bni00l3_BALLUFF_Link_module_BALLUFF_8_Port_IO_Link_Master_Output_Layout : STRUCT
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
    bni00l3_BALLUFF_Link_module_X01_Input_Layout : STRUCT
        Signals_0 AT %B0 : ARRAY[0..3] OF BYTE;
        Signals_1 AT %X4.2 : BOOL;
        Signals_2 AT %X4.3 : BOOL;
        Signals_3 AT %X4.4 : BOOL;
        Signals_4 AT %X4.5 : BOOL;
        Signals_5 AT %X4.6 : BOOL;
        Signals_6 AT %X4.7 : BOOL;
    END_STRUCT;
END_TYPE

TYPE
    bni00l3_BALLUFF_Link_module_X02_Input_Layout : STRUCT
        Signals_0 AT %B0 : ARRAY[0..1] OF BYTE;
        Signals_1 AT %X2.2 : BOOL;
        Signals_2 AT %X2.3 : BOOL;
        Signals_3 AT %X2.4 : BOOL;
        Signals_4 AT %X2.5 : BOOL;
        Signals_5 AT %X2.6 : BOOL;
        Signals_6 AT %X2.7 : BOOL;
    END_STRUCT;
END_TYPE

TYPE
    bni00l3_BALLUFF_Link_module_X03_Input_Layout : STRUCT
        Signals_0 AT %B0 : ARRAY[0..1] OF BYTE;
        Signals_1 AT %X2.2 : BOOL;
        Signals_2 AT %X2.3 : BOOL;
        Signals_3 AT %X2.4 : BOOL;
        Signals_4 AT %X2.5 : BOOL;
        Signals_5 AT %X2.6 : BOOL;
        Signals_6 AT %X2.7 : BOOL;
    END_STRUCT;
END_TYPE

TYPE
    bni00l3_BALLUFF_Link_module_X04_Input_Layout : STRUCT
        Signals_0 AT %B0 : ARRAY[0..0] OF BYTE;
        Signals_1 AT %X1.2 : BOOL;
        Signals_2 AT %X1.3 : BOOL;
        Signals_3 AT %X1.4 : BOOL;
        Signals_4 AT %X1.5 : BOOL;
        Signals_5 AT %X1.6 : BOOL;
        Signals_6 AT %X1.7 : BOOL;
    END_STRUCT;
END_TYPE

TYPE
    et200sp_A10_Input_Layout : STRUCT
        Signals_0 AT %X0.0 : BOOL;
        Signals_1 AT %X0.1 : BOOL;
        Signals_2 AT %X0.2 : BOOL;
        Signals_3 AT %X0.3 : BOOL;
        Signals_4 AT %X0.4 : BOOL;
        Signals_5 AT %X0.5 : BOOL;
        Signals_6 AT %X0.6 : BOOL;
        Signals_7 AT %X0.7 : BOOL;
        Signals_8 AT %X1.0 : BOOL;
        Signals_9 AT %X1.1 : BOOL;
        Signals_10 AT %X1.2 : BOOL;
        Signals_11 AT %X1.3 : BOOL;
        Signals_12 AT %X1.4 : BOOL;
        Signals_13 AT %X1.5 : BOOL;
        Signals_14 AT %X1.6 : BOOL;
        Signals_15 AT %X1.7 : BOOL;
    END_STRUCT;
END_TYPE

TYPE
    et200sp_A20_Output_Layout : STRUCT
        Signals_0 AT %X0.0 : BOOL;
        Signals_1 AT %X0.1 : BOOL;
        Signals_2 AT %X0.2 : BOOL;
        Signals_3 AT %X0.3 : BOOL;
        Signals_4 AT %X0.4 : BOOL;
        Signals_5 AT %X0.5 : BOOL;
        Signals_6 AT %X0.6 : BOOL;
        Signals_7 AT %X0.7 : BOOL;
        Signals_8 AT %X1.0 : BOOL;
        Signals_9 AT %X1.1 : BOOL;
        Signals_10 AT %X1.2 : BOOL;
        Signals_11 AT %X1.3 : BOOL;
        Signals_12 AT %X1.4 : BOOL;
        Signals_13 AT %X1.5 : BOOL;
        Signals_14 AT %X1.6 : BOOL;
        Signals_15 AT %X1.7 : BOOL;
    END_STRUCT;
END_TYPE

TYPE
    et200sp_A30_Input_Layout : STRUCT
        Signals_0 AT %B0 : BYTE;
        Signals_1 AT %B1 : BYTE;
        Signals_2 AT %B2 : BYTE;
        Signals_3 AT %B3 : BYTE;
        Signals_4 AT %B4 : BYTE;
        Signals_5 AT %B5 : BYTE;
        Signals_6 AT %B6 : BYTE;
        Signals_7 AT %B7 : BYTE;
        Signals_8 AT %B8 : BYTE;
        Signals_9 AT %B9 : BYTE;
        Signals_10 AT %B10 : BYTE;
        Signals_11 AT %B11 : BYTE;
        Signals_12 AT %B12 : BYTE;
        Signals_13 AT %B13 : BYTE;
        Signals_14 AT %B14 : BYTE;
        Signals_15 AT %B15 : BYTE;
        Signals_16 AT %B16 : BYTE;
        Signals_17 AT %B17 : BYTE;
        Signals_18 AT %B18 : BYTE;
        Signals_19 AT %B19 : BYTE;
        Signals_20 AT %B20 : BYTE;
        Signals_21 AT %B21 : BYTE;
        Signals_22 AT %B22 : BYTE;
        Signals_23 AT %B23 : BYTE;
        Signals_24 AT %B24 : BYTE;
        Signals_25 AT %B25 : BYTE;
        Signals_26 AT %B26 : BYTE;
        Signals_27 AT %B27 : BYTE;
        Signals_28 AT %B28 : BYTE;
        Signals_29 AT %B29 : BYTE;
        Signals_30 AT %B30 : BYTE;
        Signals_31 AT %B31 : BYTE;
    END_STRUCT;
END_TYPE

TYPE
    et200sp_A30_Output_Layout : STRUCT
        Signals_32 AT %B0 : BYTE;
        Signals_33 AT %B1 : BYTE;
        Signals_34 AT %B2 : BYTE;
        Signals_35 AT %B3 : BYTE;
        Signals_36 AT %B4 : BYTE;
        Signals_37 AT %B5 : BYTE;
        Signals_38 AT %B6 : BYTE;
        Signals_39 AT %B7 : BYTE;
        Signals_40 AT %B8 : BYTE;
        Signals_41 AT %B9 : BYTE;
        Signals_42 AT %B10 : BYTE;
        Signals_43 AT %B11 : BYTE;
        Signals_44 AT %B12 : BYTE;
        Signals_45 AT %B13 : BYTE;
        Signals_46 AT %B14 : BYTE;
        Signals_47 AT %B15 : BYTE;
        Signals_48 AT %B16 : BYTE;
        Signals_49 AT %B17 : BYTE;
        Signals_50 AT %B18 : BYTE;
        Signals_51 AT %B19 : BYTE;
        Signals_52 AT %B20 : BYTE;
        Signals_53 AT %B21 : BYTE;
        Signals_54 AT %B22 : BYTE;
        Signals_55 AT %B23 : BYTE;
        Signals_56 AT %B24 : BYTE;
        Signals_57 AT %B25 : BYTE;
        Signals_58 AT %B26 : BYTE;
        Signals_59 AT %B27 : BYTE;
        Signals_60 AT %B28 : BYTE;
        Signals_61 AT %B29 : BYTE;
        Signals_62 AT %B30 : BYTE;
        Signals_63 AT %B31 : BYTE;
    END_STRUCT;
END_TYPE
