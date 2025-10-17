CONFIGURATION IoAddresses
    VAR_GLOBAL

        // Module cmmtas/DoServo
        cmmtas_DoServo_SiemensTelegram111_PZD_12_12_Input AT %IB0 : cmmtas_DoServo_SiemensTelegram111_PZD_12_12_Input_Layout;
        cmmtas_DoServo_SiemensTelegram111_PZD_12_12_Output AT %QB0 : cmmtas_DoServo_SiemensTelegram111_PZD_12_12_Output_Layout;
        cmmtas_DoServo_SiemensTelegram750_PZD_4_1_Input AT %IB24 : cmmtas_DoServo_SiemensTelegram750_PZD_4_1_Input_Layout;
        cmmtas_DoServo_SiemensTelegram750_PZD_4_1_Output AT %QB24 : cmmtas_DoServo_SiemensTelegram750_PZD_4_1_Output_Layout;
    END_VAR
END_CONFIGURATION

TYPE
    cmmtas_DoServo_SiemensTelegram111_PZD_12_12_Input_Layout : STRUCT
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
        Signals_16 AT %X2.0 : BOOL;
        Signals_17 AT %X2.1 : BOOL;
        Signals_18 AT %X2.2 : BOOL;
        Signals_19 AT %X2.3 : BOOL;
        Signals_20 AT %X2.4 : BOOL;
        Signals_21 AT %X2.5 : BOOL;
        Signals_22 AT %X2.6 : BOOL;
        Signals_23 AT %X2.7 : BOOL;
        Signals_24 AT %X3.0 : BOOL;
        Signals_25 AT %X3.1 : BOOL;
        Signals_26 AT %X3.2 : BOOL;
        Signals_27 AT %X3.3 : BOOL;
        Signals_28 AT %X3.4 : BOOL;
        Signals_29 AT %X3.5 : BOOL;
        Signals_30 AT %X3.6 : BOOL;
        Signals_31 AT %X3.7 : BOOL;
        Signals_32 AT %X4.0 : BOOL;
        Signals_33 AT %X4.1 : BOOL;
        Signals_34 AT %X4.2 : BOOL;
        Signals_35 AT %X4.3 : BOOL;
        Signals_36 AT %X4.4 : BOOL;
        Signals_37 AT %X4.5 : BOOL;
        Signals_38 AT %X4.6 : BOOL;
        Signals_39 AT %X4.7 : BOOL;
        Signals_40 AT %X5.0 : BOOL;
        Signals_41 AT %X5.1 : BOOL;
        Signals_42 AT %X5.2 : BOOL;
        Signals_43 AT %X5.3 : BOOL;
        Signals_44 AT %X5.4 : BOOL;
        Signals_45 AT %X5.5 : BOOL;
        Signals_46 AT %X5.6 : BOOL;
        Signals_47 AT %X5.7 : BOOL;
        Signals_48 AT %X6.0 : BOOL;
        Signals_49 AT %X6.1 : BOOL;
        Signals_50 AT %X6.2 : BOOL;
        Signals_51 AT %X6.3 : BOOL;
        Signals_52 AT %X6.4 : BOOL;
        Signals_53 AT %X6.5 : BOOL;
        Signals_54 AT %X6.6 : BOOL;
        Signals_55 AT %X6.7 : BOOL;
        Signals_56 AT %X7.0 : BOOL;
        Signals_57 AT %X7.1 : BOOL;
        Signals_58 AT %X7.2 : BOOL;
        Signals_59 AT %X7.3 : BOOL;
        Signals_60 AT %X7.4 : BOOL;
        Signals_61 AT %X7.5 : BOOL;
        Signals_62 AT %X7.6 : BOOL;
        Signals_63 AT %X7.7 : BOOL;
        Signals_64 AT %X8.0 : BOOL;
        Signals_65 AT %X8.1 : BOOL;
        Signals_66 AT %X8.2 : BOOL;
        Signals_67 AT %X8.3 : BOOL;
        Signals_68 AT %X8.4 : BOOL;
        Signals_69 AT %X8.5 : BOOL;
        Signals_70 AT %X8.6 : BOOL;
        Signals_71 AT %X8.7 : BOOL;
        Signals_72 AT %X9.0 : BOOL;
        Signals_73 AT %X9.1 : BOOL;
        Signals_74 AT %X9.2 : BOOL;
        Signals_75 AT %X9.3 : BOOL;
        Signals_76 AT %X9.4 : BOOL;
        Signals_77 AT %X9.5 : BOOL;
        Signals_78 AT %X9.6 : BOOL;
        Signals_79 AT %X9.7 : BOOL;
        Signals_80 AT %B10 : DWORD;
        Signals_81 AT %B14 : DWORD;
        Signals_82 AT %B18 : WORD;
        Signals_83 AT %B20 : WORD;
        Signals_84 AT %B22 : WORD;
    END_STRUCT;
END_TYPE

TYPE
    cmmtas_DoServo_SiemensTelegram111_PZD_12_12_Output_Layout : STRUCT
        Signals_85 AT %X0.0 : BOOL;
        Signals_86 AT %X0.1 : BOOL;
        Signals_87 AT %X0.2 : BOOL;
        Signals_88 AT %X0.3 : BOOL;
        Signals_89 AT %X0.4 : BOOL;
        Signals_90 AT %X0.5 : BOOL;
        Signals_91 AT %X0.6 : BOOL;
        Signals_92 AT %X0.7 : BOOL;
        Signals_93 AT %X1.0 : BOOL;
        Signals_94 AT %X1.1 : BOOL;
        Signals_95 AT %X1.2 : BOOL;
        Signals_96 AT %X1.3 : BOOL;
        Signals_97 AT %X1.4 : BOOL;
        Signals_98 AT %X1.5 : BOOL;
        Signals_99 AT %X1.6 : BOOL;
        Signals_100 AT %X1.7 : BOOL;
        Signals_101 AT %X2.0 : BOOL;
        Signals_102 AT %X2.1 : BOOL;
        Signals_103 AT %X2.2 : BOOL;
        Signals_104 AT %X2.3 : BOOL;
        Signals_105 AT %X2.4 : BOOL;
        Signals_106 AT %X2.5 : BOOL;
        Signals_107 AT %X2.6 : BOOL;
        Signals_108 AT %X2.7 : BOOL;
        Signals_109 AT %X3.0 : BOOL;
        Signals_110 AT %X3.1 : BOOL;
        Signals_111 AT %X3.2 : BOOL;
        Signals_112 AT %X3.3 : BOOL;
        Signals_113 AT %X3.4 : BOOL;
        Signals_114 AT %X3.5 : BOOL;
        Signals_115 AT %X3.6 : BOOL;
        Signals_116 AT %X3.7 : BOOL;
        Signals_117 AT %X4.0 : BOOL;
        Signals_118 AT %X4.1 : BOOL;
        Signals_119 AT %X4.2 : BOOL;
        Signals_120 AT %X4.3 : BOOL;
        Signals_121 AT %X4.4 : BOOL;
        Signals_122 AT %X4.5 : BOOL;
        Signals_123 AT %X4.6 : BOOL;
        Signals_124 AT %X4.7 : BOOL;
        Signals_125 AT %X5.0 : BOOL;
        Signals_126 AT %X5.1 : BOOL;
        Signals_127 AT %X5.2 : BOOL;
        Signals_128 AT %X5.3 : BOOL;
        Signals_129 AT %X5.4 : BOOL;
        Signals_130 AT %X5.5 : BOOL;
        Signals_131 AT %X5.6 : BOOL;
        Signals_132 AT %X5.7 : BOOL;
        Signals_133 AT %X6.0 : BOOL;
        Signals_134 AT %X6.1 : BOOL;
        Signals_135 AT %X6.2 : BOOL;
        Signals_136 AT %X6.3 : BOOL;
        Signals_137 AT %X6.4 : BOOL;
        Signals_138 AT %X6.5 : BOOL;
        Signals_139 AT %X6.6 : BOOL;
        Signals_140 AT %X6.7 : BOOL;
        Signals_141 AT %X7.0 : BOOL;
        Signals_142 AT %X7.1 : BOOL;
        Signals_143 AT %X7.2 : BOOL;
        Signals_144 AT %X7.3 : BOOL;
        Signals_145 AT %X7.4 : BOOL;
        Signals_146 AT %X7.5 : BOOL;
        Signals_147 AT %X7.6 : BOOL;
        Signals_148 AT %X7.7 : BOOL;
        Signals_149 AT %B8 : WORD;
        Signals_150 AT %B10 : DINT;
        Signals_151 AT %B14 : DWORD;
        Signals_152 AT %B18 : WORD;
        Signals_153 AT %B20 : WORD;
        Signals_154 AT %B22 : WORD;
    END_STRUCT;
END_TYPE

TYPE
    cmmtas_DoServo_SiemensTelegram750_PZD_4_1_Input_Layout : STRUCT
        Signals_0 AT %B0 : WORD;
    END_STRUCT;
END_TYPE

TYPE
    cmmtas_DoServo_SiemensTelegram750_PZD_4_1_Output_Layout : STRUCT
        Signals_1 AT %B0 : WORD;
        Signals_2 AT %B2 : WORD;
        Signals_3 AT %B4 : WORD;
        Signals_4 AT %B6 : WORD;
    END_STRUCT;
END_TYPE
