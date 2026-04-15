CONFIGURATION IoAddresses
    VAR_GLOBAL

        // Module mitsubishi_tz535_robot/In_Out_64_byte
        mitsubishi_tz535_robot_In_Out_64_byte_Input AT %IB0 : mitsubishi_tz535_robot_In_Out_64_byte_Input_Layout;
        mitsubishi_tz535_robot_In_Out_64_byte_Output AT %QB0 : mitsubishi_tz535_robot_In_Out_64_byte_Output_Layout;
    END_VAR
END_CONFIGURATION

TYPE
    mitsubishi_tz535_robot_In_Out_64_byte_Input_Layout : STRUCT
        Signals_0 AT %B0 : ARRAY[0..63] OF BYTE;
    END_STRUCT;
END_TYPE

TYPE
    mitsubishi_tz535_robot_In_Out_64_byte_Output_Layout : STRUCT
        Signals_1 AT %B0 : ARRAY[0..63] OF BYTE;
    END_STRUCT;
END_TYPE
