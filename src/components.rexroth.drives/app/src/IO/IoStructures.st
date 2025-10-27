NAMESPACE AXOpen.Components.Rexroth.Drives
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    rexroth_ctrlx_drive_Inputs_P_0_0106_0_0__STO_function__Operating_status_Input_Layout : STRUCT
	        Signals_0 AT %B0 : WORD;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    rexroth_ctrlx_drive_Inputs_S_0_0084_0_0__Torque_force_feedback_value_Input_Layout : STRUCT
	        Signals_0 AT %B0 : INT;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
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
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    rexroth_ctrlx_drive_Inputs_S_0_0144_0_0__Signal_status_word__Value_Input_Layout : STRUCT
	        Signals_0 AT %B0 : WORD;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    rexroth_ctrlx_drive_Inputs_S_0_0386_0_0__Position_controller__Position_actual_value_Input_Layout : STRUCT
	        Signals_0 AT %B0 : DINT;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    rexroth_ctrlx_drive_Inputs_S_0_0390_0_0__Diagnostic_message__Manufacturer_status_register_Input_Layout : STRUCT
	        Signals_0 AT %B0 : DWORD;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    rexroth_ctrlx_drive_Inputs_S_0_0535_0_0__Velocity_controller__Velocity_actual_value_Input_Layout : STRUCT
	        Signals_0 AT %B0 : DINT;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    rexroth_ctrlx_drive_Inputs_S_0_1720_0_2__Power_supply_control__Status_word_Input_Layout : STRUCT
	        Signals_0 AT %B0 : WORD;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    rexroth_ctrlx_drive_Outputs_S_0_0080_0_0__Torque_force_command_value_Output_Layout : STRUCT
	        Signals_0 AT %B0 : INT;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    rexroth_ctrlx_drive_Outputs_S_0_0092_0_0__Torque_force_limitation__Limit_value_bipolar_Output_Layout : STRUCT
	        Signals_0 AT %B0 : WORD;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
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
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    rexroth_ctrlx_drive_Outputs_S_0_0145_0_0__Signal_control_word__Value_Output_Layout : STRUCT
	        Signals_0 AT %B0 : WORD;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    rexroth_ctrlx_drive_Outputs_S_0_0193_0_0__Positioning_jerk_Output_Layout : STRUCT
	        Signals_0 AT %B0 : DINT;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    rexroth_ctrlx_drive_Outputs_S_0_0259_0_0__Positioning_profile__Profile_velocity_Output_Layout : STRUCT
	        Signals_0 AT %B0 : DWORD;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    rexroth_ctrlx_drive_Outputs_S_0_0260_0_0__Positioning_profile__Acceleration_Output_Layout : STRUCT
	        Signals_0 AT %B0 : DINT;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    rexroth_ctrlx_drive_Outputs_S_0_0282_0_0__Drive_controlled_positioning__Command_value_Output_Layout : STRUCT
	        Signals_0 AT %B0 : DINT;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    rexroth_ctrlx_drive_Outputs_S_0_0359_0_0__Positioning_profile__Deceleration_Output_Layout : STRUCT
	        Signals_0 AT %B0 : DINT;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    rexroth_ctrlx_drive_Outputs_S_0_1720_0_1__Power_supply_control__Control_word_Output_Layout : STRUCT
	        Signals_0 AT %B0 : WORD;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    rexroth_indradrive_Input_9_Words_Input_Layout : STRUCT
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
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    rexroth_indradrive_Output_13_Words_Output_Layout : STRUCT
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
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    rexroth_indradrive_ParamCh_5Words_Input_Layout : STRUCT
	        Signals_0 AT %B0 : WORD;
	        Signals_1 AT %B2 : WORD;
	        Signals_2 AT %B4 : WORD;
	        Signals_3 AT %B6 : WORD;
	        Signals_4 AT %B8 : WORD;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    rexroth_indradrive_ParamCh_5Words_Output_Layout : STRUCT
	        Signals_5 AT %B0 : WORD;
	        Signals_6 AT %B2 : WORD;
	        Signals_7 AT %B4 : WORD;
	        Signals_8 AT %B6 : WORD;
	        Signals_9 AT %B8 : WORD;
	    END_STRUCT;
	END_TYPE
END_NAMESPACE

