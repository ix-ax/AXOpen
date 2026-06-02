CONFIGURATION IoAddresses
    VAR_GLOBAL

        // Module rexroth_ctrlx_drive/Inputs
        rexroth_ctrlx_drive_Inputs_P_0_0106_0_0__STO_function__Operating_status_Input AT %IB20 : rexroth_ctrlx_drive_Inputs_P_0_0106_0_0__STO_function__Operating_status_Input_Layout;
        rexroth_ctrlx_drive_Inputs_S_0_0084_0_0__Torque_force_feedback_value_Input AT %IB18 : rexroth_ctrlx_drive_Inputs_S_0_0084_0_0__Torque_force_feedback_value_Input_Layout;
        rexroth_ctrlx_drive_Inputs_S_0_0135_0_0__Drive_status_word__Value_Input AT %IB12 : rexroth_ctrlx_drive_Inputs_S_0_0135_0_0__Drive_status_word__Value_Input_Layout;
        rexroth_ctrlx_drive_Inputs_S_0_0144_0_0__Signal_status_word__Value_Input AT %IB14 : rexroth_ctrlx_drive_Inputs_S_0_0144_0_0__Signal_status_word__Value_Input_Layout;
        rexroth_ctrlx_drive_Inputs_S_0_0386_0_0__Position_controller__Position_actual_value_Input AT %IB0 : rexroth_ctrlx_drive_Inputs_S_0_0386_0_0__Position_controller__Position_actual_value_Input_Layout;
        rexroth_ctrlx_drive_Inputs_S_0_0390_0_0__Diagnostic_message__Manufacturer_status_register_Input AT %IB8 : rexroth_ctrlx_drive_Inputs_S_0_0390_0_0__Diagnostic_message__Manufacturer_status_register_Input_Layout;
        rexroth_ctrlx_drive_Inputs_S_0_0535_0_0__Velocity_controller__Velocity_actual_value_Input AT %IB4 : rexroth_ctrlx_drive_Inputs_S_0_0535_0_0__Velocity_controller__Velocity_actual_value_Input_Layout;
        rexroth_ctrlx_drive_Inputs_S_0_1720_0_2__Power_supply_control__Status_word_Input AT %IB16 : rexroth_ctrlx_drive_Inputs_S_0_1720_0_2__Power_supply_control__Status_word_Input_Layout;

        // Module rexroth_ctrlx_drive/Outputs
        rexroth_ctrlx_drive_Outputs_S_0_0080_0_0__Torque_force_command_value_Output AT %QB24 : rexroth_ctrlx_drive_Outputs_S_0_0080_0_0__Torque_force_command_value_Output_Layout;
        rexroth_ctrlx_drive_Outputs_S_0_0092_0_0__Torque_force_limitation__Limit_value_bipolar_Output AT %QB22 : rexroth_ctrlx_drive_Outputs_S_0_0092_0_0__Torque_force_limitation__Limit_value_bipolar_Output_Layout;
        rexroth_ctrlx_drive_Outputs_S_0_0134_0_0__Master_control_word__Value_Output AT %QB0 : rexroth_ctrlx_drive_Outputs_S_0_0134_0_0__Master_control_word__Value_Output_Layout;
        rexroth_ctrlx_drive_Outputs_S_0_0145_0_0__Signal_control_word__Value_Output AT %QB18 : rexroth_ctrlx_drive_Outputs_S_0_0145_0_0__Signal_control_word__Value_Output_Layout;
        rexroth_ctrlx_drive_Outputs_S_0_0193_0_0__Positioning_jerk_Output AT %QB26 : rexroth_ctrlx_drive_Outputs_S_0_0193_0_0__Positioning_jerk_Output_Layout;
        rexroth_ctrlx_drive_Outputs_S_0_0259_0_0__Positioning_profile__Profile_velocity_Output AT %QB14 : rexroth_ctrlx_drive_Outputs_S_0_0259_0_0__Positioning_profile__Profile_velocity_Output_Layout;
        rexroth_ctrlx_drive_Outputs_S_0_0260_0_0__Positioning_profile__Acceleration_Output AT %QB2 : rexroth_ctrlx_drive_Outputs_S_0_0260_0_0__Positioning_profile__Acceleration_Output_Layout;
        rexroth_ctrlx_drive_Outputs_S_0_0282_0_0__Drive_controlled_positioning__Command_value_Output AT %QB6 : rexroth_ctrlx_drive_Outputs_S_0_0282_0_0__Drive_controlled_positioning__Command_value_Output_Layout;
        rexroth_ctrlx_drive_Outputs_S_0_0359_0_0__Positioning_profile__Deceleration_Output AT %QB10 : rexroth_ctrlx_drive_Outputs_S_0_0359_0_0__Positioning_profile__Deceleration_Output_Layout;
        rexroth_ctrlx_drive_Outputs_S_0_1720_0_1__Power_supply_control__Control_word_Output AT %QB20 : rexroth_ctrlx_drive_Outputs_S_0_1720_0_1__Power_supply_control__Control_word_Output_Layout;
    END_VAR
END_CONFIGURATION

TYPE
    rexroth_ctrlx_drive_Inputs_P_0_0106_0_0__STO_function__Operating_status_Input_Layout : STRUCT
        Signals_0 AT %B0 : WORD;
    END_STRUCT;
END_TYPE

TYPE
    rexroth_ctrlx_drive_Inputs_S_0_0084_0_0__Torque_force_feedback_value_Input_Layout : STRUCT
        Signals_0 AT %B0 : INT;
    END_STRUCT;
END_TYPE

TYPE
    rexroth_ctrlx_drive_Inputs_S_0_0135_0_0__Drive_status_word__Value_Input_Layout : STRUCT
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
    rexroth_ctrlx_drive_Inputs_S_0_0144_0_0__Signal_status_word__Value_Input_Layout : STRUCT
        Signals_0 AT %B0 : WORD;
    END_STRUCT;
END_TYPE

TYPE
    rexroth_ctrlx_drive_Inputs_S_0_0386_0_0__Position_controller__Position_actual_value_Input_Layout : STRUCT
        Signals_0 AT %B0 : DINT;
    END_STRUCT;
END_TYPE

TYPE
    rexroth_ctrlx_drive_Inputs_S_0_0390_0_0__Diagnostic_message__Manufacturer_status_register_Input_Layout : STRUCT
        Signals_0 AT %B0 : DWORD;
    END_STRUCT;
END_TYPE

TYPE
    rexroth_ctrlx_drive_Inputs_S_0_0535_0_0__Velocity_controller__Velocity_actual_value_Input_Layout : STRUCT
        Signals_0 AT %B0 : DINT;
    END_STRUCT;
END_TYPE

TYPE
    rexroth_ctrlx_drive_Inputs_S_0_1720_0_2__Power_supply_control__Status_word_Input_Layout : STRUCT
        Signals_0 AT %B0 : WORD;
    END_STRUCT;
END_TYPE

TYPE
    rexroth_ctrlx_drive_Outputs_S_0_0080_0_0__Torque_force_command_value_Output_Layout : STRUCT
        Signals_0 AT %B0 : INT;
    END_STRUCT;
END_TYPE

TYPE
    rexroth_ctrlx_drive_Outputs_S_0_0092_0_0__Torque_force_limitation__Limit_value_bipolar_Output_Layout : STRUCT
        Signals_0 AT %B0 : WORD;
    END_STRUCT;
END_TYPE

TYPE
    rexroth_ctrlx_drive_Outputs_S_0_0134_0_0__Master_control_word__Value_Output_Layout : STRUCT
        Signals_0 AT %X1.0 : BOOL;
        Signals_1 AT %X1.1 : BOOL;
        Signals_2 AT %X1.2 : BOOL;
        Signals_3 AT %X1.5 : BOOL;
        Signals_4 AT %X1.6 : BOOL;
        Signals_5 AT %X1.7 : BOOL;
    END_STRUCT;
END_TYPE

TYPE
    rexroth_ctrlx_drive_Outputs_S_0_0145_0_0__Signal_control_word__Value_Output_Layout : STRUCT
        Signals_0 AT %B0 : WORD;
    END_STRUCT;
END_TYPE

TYPE
    rexroth_ctrlx_drive_Outputs_S_0_0193_0_0__Positioning_jerk_Output_Layout : STRUCT
        Signals_0 AT %B0 : DINT;
    END_STRUCT;
END_TYPE

TYPE
    rexroth_ctrlx_drive_Outputs_S_0_0259_0_0__Positioning_profile__Profile_velocity_Output_Layout : STRUCT
        Signals_0 AT %B0 : DWORD;
    END_STRUCT;
END_TYPE

TYPE
    rexroth_ctrlx_drive_Outputs_S_0_0260_0_0__Positioning_profile__Acceleration_Output_Layout : STRUCT
        Signals_0 AT %B0 : DINT;
    END_STRUCT;
END_TYPE

TYPE
    rexroth_ctrlx_drive_Outputs_S_0_0282_0_0__Drive_controlled_positioning__Command_value_Output_Layout : STRUCT
        Signals_0 AT %B0 : DINT;
    END_STRUCT;
END_TYPE

TYPE
    rexroth_ctrlx_drive_Outputs_S_0_0359_0_0__Positioning_profile__Deceleration_Output_Layout : STRUCT
        Signals_0 AT %B0 : DINT;
    END_STRUCT;
END_TYPE

TYPE
    rexroth_ctrlx_drive_Outputs_S_0_1720_0_1__Power_supply_control__Control_word_Output_Layout : STRUCT
        Signals_0 AT %B0 : WORD;
    END_STRUCT;
END_TYPE
