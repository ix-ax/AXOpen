TYPE
    HwIdentifiers : WORD
    (
        PROFINET_IO_System_HwID :=	WORD#256,
        plc_line_HwID :=	WORD#32,
        plc_line_Rail_0_HwID :=	WORD#257,
        plc_line_plc_line_HwID :=	WORD#48,
        plc_line_plc_line__plc_line_HwID :=	WORD#49,
        plc_line_plc_line_CPU_display_1_HwID :=	WORD#54,
        plc_line_plc_line_CPU_exec_unit_1_HwID :=	WORD#52,
        plc_line_plc_line_Card_reader_writer_1_HwID :=	WORD#51,
        plc_line_plc_line_DP_interface_1_HwID :=	WORD#60,
        plc_line_plc_line_LicenseManager_1_HwID :=	WORD#42,
        plc_line_plc_line_OPC_UA_1_HwID :=	WORD#117,
        plc_line_plc_line_PROFINET_interface_2_HwID :=	WORD#72,
        plc_line_plc_line_PROFINET_interface_2_Port_1_HwID :=	WORD#73,
        plc_line_plc_line_Virtual_communication_interface_HwID :=	WORD#135,
        plc_line_plc_line_plc_line_HwID :=	WORD#50,
        plc_line_plc_line_profinet_x1_HwID :=	WORD#64,
        plc_line_plc_line_profinet_x1_Port1_HwID :=	WORD#65,
        plc_line_plc_line_profinet_x1_Port2_HwID :=	WORD#66,

        NONE := WORD#0
    );
END_TYPE
