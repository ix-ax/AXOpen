CONFIGURATION IoAddresses
    VAR_GLOBAL

        // Module AxoCtrlxDriveXsc/Inputs
        AxoCtrlxDriveXsc_Inputs_P_0_0106_0_0__STO_function__Operating_status_Input AT %IB20 : AxoCtrlxDriveXsc_Inputs_P_0_0106_0_0__STO_function__Operating_status_Input_Layout;
        AxoCtrlxDriveXsc_Inputs_S_0_0084_0_0__Torque_force_feedback_value_Input AT %IB18 : AxoCtrlxDriveXsc_Inputs_S_0_0084_0_0__Torque_force_feedback_value_Input_Layout;
        AxoCtrlxDriveXsc_Inputs_S_0_0135_0_0__Drive_status_word__Value_Input AT %IB12 : AxoCtrlxDriveXsc_Inputs_S_0_0135_0_0__Drive_status_word__Value_Input_Layout;
        AxoCtrlxDriveXsc_Inputs_S_0_0144_0_0__Signal_status_word__Value_Input AT %IB14 : AxoCtrlxDriveXsc_Inputs_S_0_0144_0_0__Signal_status_word__Value_Input_Layout;
        AxoCtrlxDriveXsc_Inputs_S_0_0386_0_0__Position_controller__Position_actual_value_Input AT %IB0 : AxoCtrlxDriveXsc_Inputs_S_0_0386_0_0__Position_controller__Position_actual_value_Input_Layout;
        AxoCtrlxDriveXsc_Inputs_S_0_0390_0_0__Diagnostic_message__Manufacturer_status_register_Input AT %IB8 : AxoCtrlxDriveXsc_Inputs_S_0_0390_0_0__Diagnostic_message__Manufacturer_status_register_Input_Layout;
        AxoCtrlxDriveXsc_Inputs_S_0_0535_0_0__Velocity_controller__Velocity_actual_value_Input AT %IB4 : AxoCtrlxDriveXsc_Inputs_S_0_0535_0_0__Velocity_controller__Velocity_actual_value_Input_Layout;
        AxoCtrlxDriveXsc_Inputs_S_0_1720_0_2__Power_supply_control__Status_word_Input AT %IB16 : AxoCtrlxDriveXsc_Inputs_S_0_1720_0_2__Power_supply_control__Status_word_Input_Layout;

        // Module AxoCtrlxDriveXsc/Outputs
        AxoCtrlxDriveXsc_Outputs_S_0_0080_0_0__Torque_force_command_value_Output AT %QB24 : AxoCtrlxDriveXsc_Outputs_S_0_0080_0_0__Torque_force_command_value_Output_Layout;
        AxoCtrlxDriveXsc_Outputs_S_0_0092_0_0__Torque_force_limitation__Limit_value_bipolar_Output AT %QB22 : AxoCtrlxDriveXsc_Outputs_S_0_0092_0_0__Torque_force_limitation__Limit_value_bipolar_Output_Layout;
        AxoCtrlxDriveXsc_Outputs_S_0_0134_0_0__Master_control_word__Value_Output AT %QB0 : AxoCtrlxDriveXsc_Outputs_S_0_0134_0_0__Master_control_word__Value_Output_Layout;
        AxoCtrlxDriveXsc_Outputs_S_0_0145_0_0__Signal_control_word__Value_Output AT %QB18 : AxoCtrlxDriveXsc_Outputs_S_0_0145_0_0__Signal_control_word__Value_Output_Layout;
        AxoCtrlxDriveXsc_Outputs_S_0_0193_0_0__Positioning_jerk_Output AT %QB26 : AxoCtrlxDriveXsc_Outputs_S_0_0193_0_0__Positioning_jerk_Output_Layout;
        AxoCtrlxDriveXsc_Outputs_S_0_0259_0_0__Positioning_profile__Profile_velocity_Output AT %QB14 : AxoCtrlxDriveXsc_Outputs_S_0_0259_0_0__Positioning_profile__Profile_velocity_Output_Layout;
        AxoCtrlxDriveXsc_Outputs_S_0_0260_0_0__Positioning_profile__Acceleration_Output AT %QB2 : AxoCtrlxDriveXsc_Outputs_S_0_0260_0_0__Positioning_profile__Acceleration_Output_Layout;
        AxoCtrlxDriveXsc_Outputs_S_0_0282_0_0__Drive_controlled_positioning__Command_value_Output AT %QB6 : AxoCtrlxDriveXsc_Outputs_S_0_0282_0_0__Drive_controlled_positioning__Command_value_Output_Layout;
        AxoCtrlxDriveXsc_Outputs_S_0_0359_0_0__Positioning_profile__Deceleration_Output AT %QB10 : AxoCtrlxDriveXsc_Outputs_S_0_0359_0_0__Positioning_profile__Deceleration_Output_Layout;
        AxoCtrlxDriveXsc_Outputs_S_0_1720_0_1__Power_supply_control__Control_word_Output AT %QB20 : AxoCtrlxDriveXsc_Outputs_S_0_1720_0_1__Power_supply_control__Control_word_Output_Layout;

        // Module ST3_indradrive/Input_9_Words
        ST3_indradrive_Input_9_Words_Input AT %IB22 : ST3_indradrive_Input_9_Words_Input_Layout;

        // Module ST3_indradrive/Output_13_Words
        ST3_indradrive_Output_13_Words_Output AT %QB30 : ST3_indradrive_Output_13_Words_Output_Layout;

        // Module ST3_indradrive/ParamCh_5Words
        ST3_indradrive_ParamCh_5Words_Input AT %IB40 : ST3_indradrive_ParamCh_5Words_Input_Layout;
        ST3_indradrive_ParamCh_5Words_Output AT %QB56 : ST3_indradrive_ParamCh_5Words_Output_Layout;
    END_VAR
END_CONFIGURATION

TYPE
    AxoCtrlxDriveXsc_Inputs_P_0_0106_0_0__STO_function__Operating_status_Input_Layout : STRUCT
        Signals_0 AT %B0 : WORD;
    END_STRUCT;
END_TYPE

TYPE
    AxoCtrlxDriveXsc_Inputs_S_0_0084_0_0__Torque_force_feedback_value_Input_Layout : STRUCT
        Signals_0 AT %B0 : INT;
    END_STRUCT;
END_TYPE

TYPE
    AxoCtrlxDriveXsc_Inputs_S_0_0135_0_0__Drive_status_word__Value_Input_Layout : STRUCT
        Signals_0 AT %X0.3 : BOOL;
        Signals_1 AT %X0.4 : BOOL;
        Signals_2 AT %X0.5 : BOOL;
        Signals_3 AT %X0.7 : BOOL;
        Signals_4 AT %X1.0 : BOOL;
        Signals_5 AT %X1.1 : BOOL;
        Signals_6 AT %X1.2 : BOOL;
        Signals_7 AT %X1.4 : BOOL;
        Signals_8 AT %X1.5 : BOOL;
        Signals_9 AT %X1.6 : BOOL;
        Signals_10 AT %X1.7 : BOOL;
    END_STRUCT;
END_TYPE

TYPE
    AxoCtrlxDriveXsc_Inputs_S_0_0144_0_0__Signal_status_word__Value_Input_Layout : STRUCT
        Signals_0 AT %B0 : WORD;
    END_STRUCT;
END_TYPE

TYPE
    AxoCtrlxDriveXsc_Inputs_S_0_0386_0_0__Position_controller__Position_actual_value_Input_Layout : STRUCT
        Signals_0 AT %B0 : DINT;
    END_STRUCT;
END_TYPE

TYPE
    AxoCtrlxDriveXsc_Inputs_S_0_0390_0_0__Diagnostic_message__Manufacturer_status_register_Input_Layout : STRUCT
        Signals_0 AT %B0 : DWORD;
    END_STRUCT;
END_TYPE

TYPE
    AxoCtrlxDriveXsc_Inputs_S_0_0535_0_0__Velocity_controller__Velocity_actual_value_Input_Layout : STRUCT
        Signals_0 AT %B0 : DINT;
    END_STRUCT;
END_TYPE

TYPE
    AxoCtrlxDriveXsc_Inputs_S_0_1720_0_2__Power_supply_control__Status_word_Input_Layout : STRUCT
        Signals_0 AT %B0 : WORD;
    END_STRUCT;
END_TYPE

TYPE
    AxoCtrlxDriveXsc_Outputs_S_0_0080_0_0__Torque_force_command_value_Output_Layout : STRUCT
        Signals_0 AT %B0 : INT;
    END_STRUCT;
END_TYPE

TYPE
    AxoCtrlxDriveXsc_Outputs_S_0_0092_0_0__Torque_force_limitation__Limit_value_bipolar_Output_Layout : STRUCT
        Signals_0 AT %B0 : WORD;
    END_STRUCT;
END_TYPE

TYPE
    AxoCtrlxDriveXsc_Outputs_S_0_0134_0_0__Master_control_word__Value_Output_Layout : STRUCT
        Signals_0 AT %X1.0 : BOOL;
        Signals_1 AT %X1.1 : BOOL;
        Signals_2 AT %X1.2 : BOOL;
        Signals_3 AT %X1.5 : BOOL;
        Signals_4 AT %X1.6 : BOOL;
        Signals_5 AT %X1.7 : BOOL;
    END_STRUCT;
END_TYPE

TYPE
    AxoCtrlxDriveXsc_Outputs_S_0_0145_0_0__Signal_control_word__Value_Output_Layout : STRUCT
        Signals_0 AT %B0 : WORD;
    END_STRUCT;
END_TYPE

TYPE
    AxoCtrlxDriveXsc_Outputs_S_0_0193_0_0__Positioning_jerk_Output_Layout : STRUCT
        Signals_0 AT %B0 : DINT;
    END_STRUCT;
END_TYPE

TYPE
    AxoCtrlxDriveXsc_Outputs_S_0_0259_0_0__Positioning_profile__Profile_velocity_Output_Layout : STRUCT
        Signals_0 AT %B0 : DWORD;
    END_STRUCT;
END_TYPE

TYPE
    AxoCtrlxDriveXsc_Outputs_S_0_0260_0_0__Positioning_profile__Acceleration_Output_Layout : STRUCT
        Signals_0 AT %B0 : DINT;
    END_STRUCT;
END_TYPE

TYPE
    AxoCtrlxDriveXsc_Outputs_S_0_0282_0_0__Drive_controlled_positioning__Command_value_Output_Layout : STRUCT
        Signals_0 AT %B0 : DINT;
    END_STRUCT;
END_TYPE

TYPE
    AxoCtrlxDriveXsc_Outputs_S_0_0359_0_0__Positioning_profile__Deceleration_Output_Layout : STRUCT
        Signals_0 AT %B0 : DINT;
    END_STRUCT;
END_TYPE

TYPE
    AxoCtrlxDriveXsc_Outputs_S_0_1720_0_1__Power_supply_control__Control_word_Output_Layout : STRUCT
        Signals_0 AT %B0 : WORD;
    END_STRUCT;
END_TYPE

TYPE
    ST3_indradrive_Input_9_Words_Input_Layout : STRUCT
        Signals_0 AT %B0 : WORD;
        Signals_1 AT %B2 : WORD;
        Signals_2 AT %B4 : WORD;
        Signals_3 AT %B6 : WORD;
        Signals_4 AT %B8 : WORD;
        Signals_5 AT %B10 : WORD;
        Signals_6 AT %B12 : WORD;
        Signals_7 AT %B14 : WORD;
        Signals_8 AT %B16 : WORD;
    END_STRUCT;
END_TYPE

TYPE
    ST3_indradrive_Output_13_Words_Output_Layout : STRUCT
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
    END_STRUCT;
END_TYPE

TYPE
    ST3_indradrive_ParamCh_5Words_Input_Layout : STRUCT
        Signals_0 AT %B0 : WORD;
        Signals_1 AT %B2 : WORD;
        Signals_2 AT %B4 : WORD;
        Signals_3 AT %B6 : WORD;
        Signals_4 AT %B8 : WORD;
    END_STRUCT;
END_TYPE

TYPE
    ST3_indradrive_ParamCh_5Words_Output_Layout : STRUCT
        Signals_5 AT %B0 : WORD;
        Signals_6 AT %B2 : WORD;
        Signals_7 AT %B4 : WORD;
        Signals_8 AT %B6 : WORD;
        Signals_9 AT %B8 : WORD;
    END_STRUCT;
END_TYPE
