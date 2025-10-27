CONFIGURATION IoAddresses
    VAR_GLOBAL

        // Module ureol2l/1_T2O_State
        ureol2l_1_T2O_State_Input AT %IB448 : ureol2l_1_T2O_State_Input_Layout;

        // Module ureol2l/10_O2T_General_Purpose_Registers_2
        ureol2l_10_O2T_General_Purpose_Registers_2_Output AT %QB0 : ureol2l_10_O2T_General_Purpose_Registers_2_Output_Layout;

        // Module ureol2l/2_T2O_IO
        ureol2l_2_T2O_IO_Input AT %IB380 : ureol2l_2_T2O_IO_Input_Layout;

        // Module ureol2l/3_T2O_Joints
        ureol2l_3_T2O_Joints_Input AT %IB276 : ureol2l_3_T2O_Joints_Input_Layout;

        // Module ureol2l/4_T2O_TCP
        ureol2l_4_T2O_TCP_Input AT %IB200 : ureol2l_4_T2O_TCP_Input_Layout;

        // Module ureol2l/5_T2O_General_Purpose_Bit_Registers
        ureol2l_5_T2O_General_Purpose_Bit_Registers_Input AT %IB192 : ureol2l_5_T2O_General_Purpose_Bit_Registers_Input_Layout;

        // Module ureol2l/6_T2O_General_Purpose_Int_Registers
        ureol2l_6_T2O_General_Purpose_Int_Registers_Input AT %IB96 : ureol2l_6_T2O_General_Purpose_Int_Registers_Input_Layout;

        // Module ureol2l/7_T2O_General_Purpose_Float_Registers
        ureol2l_7_T2O_General_Purpose_Float_Registers_Input AT %IB0 : ureol2l_7_T2O_General_Purpose_Float_Registers_Input_Layout;

        // Module ureol2l/8_O2T_Robot_IO
        ureol2l_8_O2T_Robot_IO_Output AT %QB200 : ureol2l_8_O2T_Robot_IO_Output_Layout;

        // Module ureol2l/9_O2T_General_Purpose_Registers_1
        ureol2l_9_O2T_General_Purpose_Registers_1_Output AT %QB100 : ureol2l_9_O2T_General_Purpose_Registers_1_Output_Layout;
    END_VAR
END_CONFIGURATION

TYPE
    ureol2l_1_T2O_State_Input_Layout : STRUCT
        Signals_0_0 AT %X0.0 : BOOL;
        Signals_0_1 AT %X0.1 : BOOL;
        Signals_0_2 AT %X0.2 : BOOL;
        Signals_0_3 AT %X0.3 : BOOL;
        Signals_0_4 AT %X0.4 : BOOL;
        Signals_0_5 AT %X0.5 : BOOL;
        Signals_0_6 AT %X0.6 : BOOL;
        Signals_0_7 AT %X0.7 : BOOL;
        Signals_0_8 AT %X1.0 : BOOL;
        Signals_0_9 AT %X1.1 : BOOL;
        Signals_0_10 AT %X1.2 : BOOL;
        Signals_0_11 AT %X1.3 : BOOL;
        Signals_0_12 AT %X1.4 : BOOL;
        Signals_0_13 AT %X1.5 : BOOL;
        Signals_0_14 AT %X1.6 : BOOL;
        Signals_0_15 AT %X1.7 : BOOL;
        Signals_0_16 AT %X2.0 : BOOL;
        Signals_0_17 AT %X2.1 : BOOL;
        Signals_0_18 AT %X2.2 : BOOL;
        Signals_0_19 AT %X2.3 : BOOL;
        Signals_0_20 AT %X2.4 : BOOL;
        Signals_0_21 AT %X2.5 : BOOL;
        Signals_0_22 AT %X2.6 : BOOL;
        Signals_0_23 AT %X2.7 : BOOL;
        Signals_0_24 AT %X3.0 : BOOL;
        Signals_0_25 AT %X3.1 : BOOL;
        Signals_0_26 AT %X3.2 : BOOL;
        Signals_0_27 AT %X3.3 : BOOL;
        Signals_0_28 AT %X3.4 : BOOL;
        Signals_0_29 AT %X3.5 : BOOL;
        Signals_0_30 AT %X3.6 : BOOL;
        Signals_0_31 AT %X3.7 : BOOL;
        Signals_0_32 AT %X4.0 : BOOL;
        Signals_0_33 AT %X4.1 : BOOL;
        Signals_0_34 AT %X4.2 : BOOL;
        Signals_0_35 AT %X4.3 : BOOL;
        Signals_0_36 AT %X4.4 : BOOL;
        Signals_0_37 AT %X4.5 : BOOL;
        Signals_0_38 AT %X4.6 : BOOL;
        Signals_0_39 AT %X4.7 : BOOL;
        Signals_0_40 AT %X5.0 : BOOL;
        Signals_0_41 AT %X5.1 : BOOL;
        Signals_0_42 AT %X5.2 : BOOL;
        Signals_0_43 AT %X5.3 : BOOL;
        Signals_0_44 AT %X5.4 : BOOL;
        Signals_0_45 AT %X5.5 : BOOL;
        Signals_0_46 AT %X5.6 : BOOL;
        Signals_0_47 AT %X5.7 : BOOL;
        Signals_0_48 AT %X6.0 : BOOL;
        Signals_0_49 AT %X6.1 : BOOL;
        Signals_0_50 AT %X6.2 : BOOL;
        Signals_0_51 AT %X6.3 : BOOL;
        Signals_0_52 AT %X6.4 : BOOL;
        Signals_0_53 AT %X6.5 : BOOL;
        Signals_0_54 AT %X6.6 : BOOL;
        Signals_0_55 AT %X6.7 : BOOL;
        Signals_0_56 AT %X7.0 : BOOL;
        Signals_0_57 AT %X7.1 : BOOL;
        Signals_0_58 AT %X7.2 : BOOL;
        Signals_0_59 AT %X7.3 : BOOL;
        Signals_0_60 AT %X7.4 : BOOL;
        Signals_0_61 AT %X7.5 : BOOL;
        Signals_0_62 AT %X7.6 : BOOL;
        Signals_0_63 AT %X7.7 : BOOL;
        Signals_0_64 AT %X8.0 : BOOL;
        Signals_0_65 AT %X8.1 : BOOL;
        Signals_0_66 AT %X8.2 : BOOL;
        Signals_0_67 AT %X8.3 : BOOL;
        Signals_0_68 AT %X8.4 : BOOL;
        Signals_0_69 AT %X8.5 : BOOL;
        Signals_0_70 AT %X8.6 : BOOL;
        Signals_0_71 AT %X8.7 : BOOL;
        Signals_0_72 AT %X9.0 : BOOL;
        Signals_0_73 AT %X9.1 : BOOL;
        Signals_0_74 AT %X9.2 : BOOL;
        Signals_0_75 AT %X9.3 : BOOL;
        Signals_0_76 AT %X9.4 : BOOL;
        Signals_0_77 AT %X9.5 : BOOL;
        Signals_0_78 AT %X9.6 : BOOL;
        Signals_0_79 AT %X9.7 : BOOL;
        Signals_0_80 AT %X10.0 : BOOL;
        Signals_0_81 AT %X10.1 : BOOL;
        Signals_0_82 AT %X10.2 : BOOL;
        Signals_0_83 AT %X10.3 : BOOL;
        Signals_0_84 AT %X10.4 : BOOL;
        Signals_0_85 AT %X10.5 : BOOL;
        Signals_0_86 AT %X10.6 : BOOL;
        Signals_0_87 AT %X10.7 : BOOL;
        Signals_0_88 AT %X11.0 : BOOL;
        Signals_0_89 AT %X11.1 : BOOL;
        Signals_0_90 AT %X11.2 : BOOL;
        Signals_0_91 AT %X11.3 : BOOL;
        Signals_0_92 AT %X11.4 : BOOL;
        Signals_0_93 AT %X11.5 : BOOL;
        Signals_0_94 AT %X11.6 : BOOL;
        Signals_0_95 AT %X11.7 : BOOL;
        Signals_0_96 AT %X12.0 : BOOL;
        Signals_0_97 AT %X12.1 : BOOL;
        Signals_0_98 AT %X12.2 : BOOL;
        Signals_0_99 AT %X12.3 : BOOL;
        Signals_0_100 AT %X12.4 : BOOL;
        Signals_0_101 AT %X12.5 : BOOL;
        Signals_0_102 AT %X12.6 : BOOL;
        Signals_0_103 AT %X12.7 : BOOL;
        Signals_0_104 AT %X13.0 : BOOL;
        Signals_0_105 AT %X13.1 : BOOL;
        Signals_0_106 AT %X13.2 : BOOL;
        Signals_0_107 AT %X13.3 : BOOL;
        Signals_0_108 AT %X13.4 : BOOL;
        Signals_0_109 AT %X13.5 : BOOL;
        Signals_0_110 AT %X13.6 : BOOL;
        Signals_0_111 AT %X13.7 : BOOL;
        Signals_0_112 AT %X14.0 : BOOL;
        Signals_0_113 AT %X14.1 : BOOL;
        Signals_0_114 AT %X14.2 : BOOL;
        Signals_0_115 AT %X14.3 : BOOL;
        Signals_0_116 AT %X14.4 : BOOL;
        Signals_0_117 AT %X14.5 : BOOL;
        Signals_0_118 AT %X14.6 : BOOL;
        Signals_0_119 AT %X14.7 : BOOL;
        Signals_0_120 AT %X15.0 : BOOL;
        Signals_0_121 AT %X15.1 : BOOL;
        Signals_0_122 AT %X15.2 : BOOL;
        Signals_0_123 AT %X15.3 : BOOL;
        Signals_0_124 AT %X15.4 : BOOL;
        Signals_0_125 AT %X15.5 : BOOL;
        Signals_0_126 AT %X15.6 : BOOL;
        Signals_0_127 AT %X15.7 : BOOL;
        Signals_0_128 AT %X16.0 : BOOL;
        Signals_0_129 AT %X16.1 : BOOL;
        Signals_0_130 AT %X16.2 : BOOL;
        Signals_0_131 AT %X16.3 : BOOL;
        Signals_0_132 AT %X16.4 : BOOL;
        Signals_0_133 AT %X16.5 : BOOL;
        Signals_0_134 AT %X16.6 : BOOL;
        Signals_0_135 AT %X16.7 : BOOL;
        Signals_0_136 AT %X17.0 : BOOL;
        Signals_0_137 AT %X17.1 : BOOL;
        Signals_0_138 AT %X17.2 : BOOL;
        Signals_0_139 AT %X17.3 : BOOL;
        Signals_0_140 AT %X17.4 : BOOL;
        Signals_0_141 AT %X17.5 : BOOL;
        Signals_0_142 AT %X17.6 : BOOL;
        Signals_0_143 AT %X17.7 : BOOL;
        Signals_0_144 AT %X18.0 : BOOL;
        Signals_0_145 AT %X18.1 : BOOL;
        Signals_0_146 AT %X18.2 : BOOL;
        Signals_0_147 AT %X18.3 : BOOL;
        Signals_0_148 AT %X18.4 : BOOL;
        Signals_0_149 AT %X18.5 : BOOL;
        Signals_0_150 AT %X18.6 : BOOL;
        Signals_0_151 AT %X18.7 : BOOL;
        Signals_0_152 AT %X19.0 : BOOL;
        Signals_0_153 AT %X19.1 : BOOL;
        Signals_0_154 AT %X19.2 : BOOL;
        Signals_0_155 AT %X19.3 : BOOL;
        Signals_0_156 AT %X19.4 : BOOL;
        Signals_0_157 AT %X19.5 : BOOL;
        Signals_0_158 AT %X19.6 : BOOL;
        Signals_0_159 AT %X19.7 : BOOL;
        Signals_0_160 AT %X20.0 : BOOL;
        Signals_0_161 AT %X20.1 : BOOL;
        Signals_0_162 AT %X20.2 : BOOL;
        Signals_0_163 AT %X20.3 : BOOL;
        Signals_0_164 AT %X20.4 : BOOL;
        Signals_0_165 AT %X20.5 : BOOL;
        Signals_0_166 AT %X20.6 : BOOL;
        Signals_0_167 AT %X20.7 : BOOL;
        Signals_0_168 AT %X21.0 : BOOL;
        Signals_0_169 AT %X21.1 : BOOL;
        Signals_0_170 AT %X21.2 : BOOL;
        Signals_0_171 AT %X21.3 : BOOL;
        Signals_0_172 AT %X21.4 : BOOL;
        Signals_0_173 AT %X21.5 : BOOL;
        Signals_0_174 AT %X21.6 : BOOL;
        Signals_0_175 AT %X21.7 : BOOL;
        Signals_0_176 AT %X22.0 : BOOL;
        Signals_0_177 AT %X22.1 : BOOL;
        Signals_0_178 AT %X22.2 : BOOL;
        Signals_0_179 AT %X22.3 : BOOL;
        Signals_0_180 AT %X22.4 : BOOL;
        Signals_0_181 AT %X22.5 : BOOL;
        Signals_0_182 AT %X22.6 : BOOL;
        Signals_0_183 AT %X22.7 : BOOL;
        Signals_0_184 AT %X23.0 : BOOL;
        Signals_0_185 AT %X23.1 : BOOL;
        Signals_0_186 AT %X23.2 : BOOL;
        Signals_0_187 AT %X23.3 : BOOL;
        Signals_0_188 AT %X23.4 : BOOL;
        Signals_0_189 AT %X23.5 : BOOL;
        Signals_0_190 AT %X23.6 : BOOL;
        Signals_0_191 AT %X23.7 : BOOL;
        Signals_0_192 AT %X24.0 : BOOL;
        Signals_0_193 AT %X24.1 : BOOL;
        Signals_0_194 AT %X24.2 : BOOL;
        Signals_0_195 AT %X24.3 : BOOL;
        Signals_0_196 AT %X24.4 : BOOL;
        Signals_0_197 AT %X24.5 : BOOL;
        Signals_0_198 AT %X24.6 : BOOL;
        Signals_0_199 AT %X24.7 : BOOL;
        Signals_0_200 AT %X25.0 : BOOL;
        Signals_0_201 AT %X25.1 : BOOL;
        Signals_0_202 AT %X25.2 : BOOL;
        Signals_0_203 AT %X25.3 : BOOL;
        Signals_0_204 AT %X25.4 : BOOL;
        Signals_0_205 AT %X25.5 : BOOL;
        Signals_0_206 AT %X25.6 : BOOL;
        Signals_0_207 AT %X25.7 : BOOL;
        Signals_0_208 AT %X26.0 : BOOL;
        Signals_0_209 AT %X26.1 : BOOL;
        Signals_0_210 AT %X26.2 : BOOL;
        Signals_0_211 AT %X26.3 : BOOL;
        Signals_0_212 AT %X26.4 : BOOL;
        Signals_0_213 AT %X26.5 : BOOL;
        Signals_0_214 AT %X26.6 : BOOL;
        Signals_0_215 AT %X26.7 : BOOL;
        Signals_0_216 AT %X27.0 : BOOL;
        Signals_0_217 AT %X27.1 : BOOL;
        Signals_0_218 AT %X27.2 : BOOL;
        Signals_0_219 AT %X27.3 : BOOL;
        Signals_0_220 AT %X27.4 : BOOL;
        Signals_0_221 AT %X27.5 : BOOL;
        Signals_0_222 AT %X27.6 : BOOL;
        Signals_0_223 AT %X27.7 : BOOL;
        Signals_0_224 AT %X28.0 : BOOL;
        Signals_0_225 AT %X28.1 : BOOL;
        Signals_0_226 AT %X28.2 : BOOL;
        Signals_0_227 AT %X28.3 : BOOL;
        Signals_0_228 AT %X28.4 : BOOL;
        Signals_0_229 AT %X28.5 : BOOL;
        Signals_0_230 AT %X28.6 : BOOL;
        Signals_0_231 AT %X28.7 : BOOL;
        Signals_0_232 AT %X29.0 : BOOL;
        Signals_0_233 AT %X29.1 : BOOL;
        Signals_0_234 AT %X29.2 : BOOL;
        Signals_0_235 AT %X29.3 : BOOL;
        Signals_0_236 AT %X29.4 : BOOL;
        Signals_0_237 AT %X29.5 : BOOL;
        Signals_0_238 AT %X29.6 : BOOL;
        Signals_0_239 AT %X29.7 : BOOL;
        Signals_0_240 AT %X30.0 : BOOL;
        Signals_0_241 AT %X30.1 : BOOL;
        Signals_0_242 AT %X30.2 : BOOL;
        Signals_0_243 AT %X30.3 : BOOL;
        Signals_0_244 AT %X30.4 : BOOL;
        Signals_0_245 AT %X30.5 : BOOL;
        Signals_0_246 AT %X30.6 : BOOL;
        Signals_0_247 AT %X30.7 : BOOL;
        Signals_0_248 AT %X31.0 : BOOL;
        Signals_0_249 AT %X31.1 : BOOL;
        Signals_0_250 AT %X31.2 : BOOL;
        Signals_0_251 AT %X31.3 : BOOL;
        Signals_0_252 AT %X31.4 : BOOL;
        Signals_0_253 AT %X31.5 : BOOL;
        Signals_0_254 AT %X31.6 : BOOL;
        Signals_0_255 AT %X31.7 : BOOL;
    END_STRUCT;
END_TYPE

TYPE
    ureol2l_10_O2T_General_Purpose_Registers_2_Output_Layout : STRUCT
        Signals_0 AT %B0 : ARRAY[0..799] OF BOOL;
    END_STRUCT;
END_TYPE

TYPE
    ureol2l_2_T2O_IO_Input_Layout : STRUCT
        Signals_0 AT %B0 : ARRAY[0..543] OF BOOL;
    END_STRUCT;
END_TYPE

TYPE
    ureol2l_3_T2O_Joints_Input_Layout : STRUCT
        Signals_0 AT %B0 : ARRAY[0..831] OF BOOL;
    END_STRUCT;
END_TYPE

TYPE
    ureol2l_4_T2O_TCP_Input_Layout : STRUCT
        Signals_0 AT %B0 : ARRAY[0..607] OF BOOL;
    END_STRUCT;
END_TYPE

TYPE
    ureol2l_5_T2O_General_Purpose_Bit_Registers_Input_Layout : STRUCT
        Signals_0_0 AT %X0.0 : BOOL;
        Signals_0_1 AT %X0.1 : BOOL;
        Signals_0_2 AT %X0.2 : BOOL;
        Signals_0_3 AT %X0.3 : BOOL;
        Signals_0_4 AT %X0.4 : BOOL;
        Signals_0_5 AT %X0.5 : BOOL;
        Signals_0_6 AT %X0.6 : BOOL;
        Signals_0_7 AT %X0.7 : BOOL;
        Signals_0_8 AT %X1.0 : BOOL;
        Signals_0_9 AT %X1.1 : BOOL;
        Signals_0_10 AT %X1.2 : BOOL;
        Signals_0_11 AT %X1.3 : BOOL;
        Signals_0_12 AT %X1.4 : BOOL;
        Signals_0_13 AT %X1.5 : BOOL;
        Signals_0_14 AT %X1.6 : BOOL;
        Signals_0_15 AT %X1.7 : BOOL;
        Signals_0_16 AT %X2.0 : BOOL;
        Signals_0_17 AT %X2.1 : BOOL;
        Signals_0_18 AT %X2.2 : BOOL;
        Signals_0_19 AT %X2.3 : BOOL;
        Signals_0_20 AT %X2.4 : BOOL;
        Signals_0_21 AT %X2.5 : BOOL;
        Signals_0_22 AT %X2.6 : BOOL;
        Signals_0_23 AT %X2.7 : BOOL;
        Signals_0_24 AT %X3.0 : BOOL;
        Signals_0_25 AT %X3.1 : BOOL;
        Signals_0_26 AT %X3.2 : BOOL;
        Signals_0_27 AT %X3.3 : BOOL;
        Signals_0_28 AT %X3.4 : BOOL;
        Signals_0_29 AT %X3.5 : BOOL;
        Signals_0_30 AT %X3.6 : BOOL;
        Signals_0_31 AT %X3.7 : BOOL;
        Signals_0_32 AT %X4.0 : BOOL;
        Signals_0_33 AT %X4.1 : BOOL;
        Signals_0_34 AT %X4.2 : BOOL;
        Signals_0_35 AT %X4.3 : BOOL;
        Signals_0_36 AT %X4.4 : BOOL;
        Signals_0_37 AT %X4.5 : BOOL;
        Signals_0_38 AT %X4.6 : BOOL;
        Signals_0_39 AT %X4.7 : BOOL;
        Signals_0_40 AT %X5.0 : BOOL;
        Signals_0_41 AT %X5.1 : BOOL;
        Signals_0_42 AT %X5.2 : BOOL;
        Signals_0_43 AT %X5.3 : BOOL;
        Signals_0_44 AT %X5.4 : BOOL;
        Signals_0_45 AT %X5.5 : BOOL;
        Signals_0_46 AT %X5.6 : BOOL;
        Signals_0_47 AT %X5.7 : BOOL;
        Signals_0_48 AT %X6.0 : BOOL;
        Signals_0_49 AT %X6.1 : BOOL;
        Signals_0_50 AT %X6.2 : BOOL;
        Signals_0_51 AT %X6.3 : BOOL;
        Signals_0_52 AT %X6.4 : BOOL;
        Signals_0_53 AT %X6.5 : BOOL;
        Signals_0_54 AT %X6.6 : BOOL;
        Signals_0_55 AT %X6.7 : BOOL;
        Signals_0_56 AT %X7.0 : BOOL;
        Signals_0_57 AT %X7.1 : BOOL;
        Signals_0_58 AT %X7.2 : BOOL;
        Signals_0_59 AT %X7.3 : BOOL;
        Signals_0_60 AT %X7.4 : BOOL;
        Signals_0_61 AT %X7.5 : BOOL;
        Signals_0_62 AT %X7.6 : BOOL;
        Signals_0_63 AT %X7.7 : BOOL;
    END_STRUCT;
END_TYPE

TYPE
    ureol2l_6_T2O_General_Purpose_Int_Registers_Input_Layout : STRUCT
        Signals_0 AT %B0 : ARRAY[0..767] OF BOOL;
    END_STRUCT;
END_TYPE

TYPE
    ureol2l_7_T2O_General_Purpose_Float_Registers_Input_Layout : STRUCT
        Signals_0 AT %B0 : ARRAY[0..767] OF BOOL;
    END_STRUCT;
END_TYPE

TYPE
    ureol2l_8_O2T_Robot_IO_Output_Layout : STRUCT
        Signals_0_0 AT %X0.0 : BOOL;
        Signals_0_1 AT %X0.1 : BOOL;
        Signals_0_2 AT %X0.2 : BOOL;
        Signals_0_3 AT %X0.3 : BOOL;
        Signals_0_4 AT %X0.4 : BOOL;
        Signals_0_5 AT %X0.5 : BOOL;
        Signals_0_6 AT %X0.6 : BOOL;
        Signals_0_7 AT %X0.7 : BOOL;
        Signals_0_8 AT %X1.0 : BOOL;
        Signals_0_9 AT %X1.1 : BOOL;
        Signals_0_10 AT %X1.2 : BOOL;
        Signals_0_11 AT %X1.3 : BOOL;
        Signals_0_12 AT %X1.4 : BOOL;
        Signals_0_13 AT %X1.5 : BOOL;
        Signals_0_14 AT %X1.6 : BOOL;
        Signals_0_15 AT %X1.7 : BOOL;
        Signals_0_16 AT %X2.0 : BOOL;
        Signals_0_17 AT %X2.1 : BOOL;
        Signals_0_18 AT %X2.2 : BOOL;
        Signals_0_19 AT %X2.3 : BOOL;
        Signals_0_20 AT %X2.4 : BOOL;
        Signals_0_21 AT %X2.5 : BOOL;
        Signals_0_22 AT %X2.6 : BOOL;
        Signals_0_23 AT %X2.7 : BOOL;
        Signals_0_24 AT %X3.0 : BOOL;
        Signals_0_25 AT %X3.1 : BOOL;
        Signals_0_26 AT %X3.2 : BOOL;
        Signals_0_27 AT %X3.3 : BOOL;
        Signals_0_28 AT %X3.4 : BOOL;
        Signals_0_29 AT %X3.5 : BOOL;
        Signals_0_30 AT %X3.6 : BOOL;
        Signals_0_31 AT %X3.7 : BOOL;
        Signals_0_32 AT %X4.0 : BOOL;
        Signals_0_33 AT %X4.1 : BOOL;
        Signals_0_34 AT %X4.2 : BOOL;
        Signals_0_35 AT %X4.3 : BOOL;
        Signals_0_36 AT %X4.4 : BOOL;
        Signals_0_37 AT %X4.5 : BOOL;
        Signals_0_38 AT %X4.6 : BOOL;
        Signals_0_39 AT %X4.7 : BOOL;
        Signals_0_40 AT %X5.0 : BOOL;
        Signals_0_41 AT %X5.1 : BOOL;
        Signals_0_42 AT %X5.2 : BOOL;
        Signals_0_43 AT %X5.3 : BOOL;
        Signals_0_44 AT %X5.4 : BOOL;
        Signals_0_45 AT %X5.5 : BOOL;
        Signals_0_46 AT %X5.6 : BOOL;
        Signals_0_47 AT %X5.7 : BOOL;
        Signals_0_48 AT %X6.0 : BOOL;
        Signals_0_49 AT %X6.1 : BOOL;
        Signals_0_50 AT %X6.2 : BOOL;
        Signals_0_51 AT %X6.3 : BOOL;
        Signals_0_52 AT %X6.4 : BOOL;
        Signals_0_53 AT %X6.5 : BOOL;
        Signals_0_54 AT %X6.6 : BOOL;
        Signals_0_55 AT %X6.7 : BOOL;
        Signals_0_56 AT %X7.0 : BOOL;
        Signals_0_57 AT %X7.1 : BOOL;
        Signals_0_58 AT %X7.2 : BOOL;
        Signals_0_59 AT %X7.3 : BOOL;
        Signals_0_60 AT %X7.4 : BOOL;
        Signals_0_61 AT %X7.5 : BOOL;
        Signals_0_62 AT %X7.6 : BOOL;
        Signals_0_63 AT %X7.7 : BOOL;
        Signals_0_64 AT %X8.0 : BOOL;
        Signals_0_65 AT %X8.1 : BOOL;
        Signals_0_66 AT %X8.2 : BOOL;
        Signals_0_67 AT %X8.3 : BOOL;
        Signals_0_68 AT %X8.4 : BOOL;
        Signals_0_69 AT %X8.5 : BOOL;
        Signals_0_70 AT %X8.6 : BOOL;
        Signals_0_71 AT %X8.7 : BOOL;
        Signals_0_72 AT %X9.0 : BOOL;
        Signals_0_73 AT %X9.1 : BOOL;
        Signals_0_74 AT %X9.2 : BOOL;
        Signals_0_75 AT %X9.3 : BOOL;
        Signals_0_76 AT %X9.4 : BOOL;
        Signals_0_77 AT %X9.5 : BOOL;
        Signals_0_78 AT %X9.6 : BOOL;
        Signals_0_79 AT %X9.7 : BOOL;
        Signals_0_80 AT %X10.0 : BOOL;
        Signals_0_81 AT %X10.1 : BOOL;
        Signals_0_82 AT %X10.2 : BOOL;
        Signals_0_83 AT %X10.3 : BOOL;
        Signals_0_84 AT %X10.4 : BOOL;
        Signals_0_85 AT %X10.5 : BOOL;
        Signals_0_86 AT %X10.6 : BOOL;
        Signals_0_87 AT %X10.7 : BOOL;
        Signals_0_88 AT %X11.0 : BOOL;
        Signals_0_89 AT %X11.1 : BOOL;
        Signals_0_90 AT %X11.2 : BOOL;
        Signals_0_91 AT %X11.3 : BOOL;
        Signals_0_92 AT %X11.4 : BOOL;
        Signals_0_93 AT %X11.5 : BOOL;
        Signals_0_94 AT %X11.6 : BOOL;
        Signals_0_95 AT %X11.7 : BOOL;
        Signals_0_96 AT %X12.0 : BOOL;
        Signals_0_97 AT %X12.1 : BOOL;
        Signals_0_98 AT %X12.2 : BOOL;
        Signals_0_99 AT %X12.3 : BOOL;
        Signals_0_100 AT %X12.4 : BOOL;
        Signals_0_101 AT %X12.5 : BOOL;
        Signals_0_102 AT %X12.6 : BOOL;
        Signals_0_103 AT %X12.7 : BOOL;
        Signals_0_104 AT %X13.0 : BOOL;
        Signals_0_105 AT %X13.1 : BOOL;
        Signals_0_106 AT %X13.2 : BOOL;
        Signals_0_107 AT %X13.3 : BOOL;
        Signals_0_108 AT %X13.4 : BOOL;
        Signals_0_109 AT %X13.5 : BOOL;
        Signals_0_110 AT %X13.6 : BOOL;
        Signals_0_111 AT %X13.7 : BOOL;
        Signals_0_112 AT %X14.0 : BOOL;
        Signals_0_113 AT %X14.1 : BOOL;
        Signals_0_114 AT %X14.2 : BOOL;
        Signals_0_115 AT %X14.3 : BOOL;
        Signals_0_116 AT %X14.4 : BOOL;
        Signals_0_117 AT %X14.5 : BOOL;
        Signals_0_118 AT %X14.6 : BOOL;
        Signals_0_119 AT %X14.7 : BOOL;
        Signals_0_120 AT %X15.0 : BOOL;
        Signals_0_121 AT %X15.1 : BOOL;
        Signals_0_122 AT %X15.2 : BOOL;
        Signals_0_123 AT %X15.3 : BOOL;
        Signals_0_124 AT %X15.4 : BOOL;
        Signals_0_125 AT %X15.5 : BOOL;
        Signals_0_126 AT %X15.6 : BOOL;
        Signals_0_127 AT %X15.7 : BOOL;
        Signals_0_128 AT %X16.0 : BOOL;
        Signals_0_129 AT %X16.1 : BOOL;
        Signals_0_130 AT %X16.2 : BOOL;
        Signals_0_131 AT %X16.3 : BOOL;
        Signals_0_132 AT %X16.4 : BOOL;
        Signals_0_133 AT %X16.5 : BOOL;
        Signals_0_134 AT %X16.6 : BOOL;
        Signals_0_135 AT %X16.7 : BOOL;
        Signals_0_136 AT %X17.0 : BOOL;
        Signals_0_137 AT %X17.1 : BOOL;
        Signals_0_138 AT %X17.2 : BOOL;
        Signals_0_139 AT %X17.3 : BOOL;
        Signals_0_140 AT %X17.4 : BOOL;
        Signals_0_141 AT %X17.5 : BOOL;
        Signals_0_142 AT %X17.6 : BOOL;
        Signals_0_143 AT %X17.7 : BOOL;
        Signals_0_144 AT %X18.0 : BOOL;
        Signals_0_145 AT %X18.1 : BOOL;
        Signals_0_146 AT %X18.2 : BOOL;
        Signals_0_147 AT %X18.3 : BOOL;
        Signals_0_148 AT %X18.4 : BOOL;
        Signals_0_149 AT %X18.5 : BOOL;
        Signals_0_150 AT %X18.6 : BOOL;
        Signals_0_151 AT %X18.7 : BOOL;
        Signals_0_152 AT %X19.0 : BOOL;
        Signals_0_153 AT %X19.1 : BOOL;
        Signals_0_154 AT %X19.2 : BOOL;
        Signals_0_155 AT %X19.3 : BOOL;
        Signals_0_156 AT %X19.4 : BOOL;
        Signals_0_157 AT %X19.5 : BOOL;
        Signals_0_158 AT %X19.6 : BOOL;
        Signals_0_159 AT %X19.7 : BOOL;
        Signals_0_160 AT %X20.0 : BOOL;
        Signals_0_161 AT %X20.1 : BOOL;
        Signals_0_162 AT %X20.2 : BOOL;
        Signals_0_163 AT %X20.3 : BOOL;
        Signals_0_164 AT %X20.4 : BOOL;
        Signals_0_165 AT %X20.5 : BOOL;
        Signals_0_166 AT %X20.6 : BOOL;
        Signals_0_167 AT %X20.7 : BOOL;
        Signals_0_168 AT %X21.0 : BOOL;
        Signals_0_169 AT %X21.1 : BOOL;
        Signals_0_170 AT %X21.2 : BOOL;
        Signals_0_171 AT %X21.3 : BOOL;
        Signals_0_172 AT %X21.4 : BOOL;
        Signals_0_173 AT %X21.5 : BOOL;
        Signals_0_174 AT %X21.6 : BOOL;
        Signals_0_175 AT %X21.7 : BOOL;
        Signals_0_176 AT %X22.0 : BOOL;
        Signals_0_177 AT %X22.1 : BOOL;
        Signals_0_178 AT %X22.2 : BOOL;
        Signals_0_179 AT %X22.3 : BOOL;
        Signals_0_180 AT %X22.4 : BOOL;
        Signals_0_181 AT %X22.5 : BOOL;
        Signals_0_182 AT %X22.6 : BOOL;
        Signals_0_183 AT %X22.7 : BOOL;
        Signals_0_184 AT %X23.0 : BOOL;
        Signals_0_185 AT %X23.1 : BOOL;
        Signals_0_186 AT %X23.2 : BOOL;
        Signals_0_187 AT %X23.3 : BOOL;
        Signals_0_188 AT %X23.4 : BOOL;
        Signals_0_189 AT %X23.5 : BOOL;
        Signals_0_190 AT %X23.6 : BOOL;
        Signals_0_191 AT %X23.7 : BOOL;
    END_STRUCT;
END_TYPE

TYPE
    ureol2l_9_O2T_General_Purpose_Registers_1_Output_Layout : STRUCT
        Signals_0 AT %B0 : ARRAY[0..799] OF BOOL;
    END_STRUCT;
END_TYPE
