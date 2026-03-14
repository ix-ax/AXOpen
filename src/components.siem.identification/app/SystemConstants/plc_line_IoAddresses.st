CONFIGURATION IoAddresses
    VAR_GLOBAL

        // Module et200sp_CM_4xIO_Link_RF200/CM_4xIO-Link_V2_2_144I_128O_1
        et200sp_CM_4xIO_Link_RF200_CM_4xIO_Link_V2_2_144I_128O_1_Input AT %IB162 : et200sp_CM_4xIO_Link_RF200_CM_4xIO_Link_V2_2_144I_128O_1_Input_Layout;
        et200sp_CM_4xIO_Link_RF200_CM_4xIO_Link_V2_2_144I_128O_1_Output AT %QB162 : et200sp_CM_4xIO_Link_RF200_CM_4xIO_Link_V2_2_144I_128O_1_Output_Layout;

        // Module rf186c/CM_1
        rf186c_CM_1_Input AT %IB308 : rf186c_CM_1_Input_Layout;
        rf186c_CM_1_Output AT %QB292 : rf186c_CM_1_Output_Layout;

        // Module rf186c_cyc/CM
        rf186c_cyc_CM_Input AT %IB160 : rf186c_cyc_CM_Input_Layout;
        rf186c_cyc_CM_Output AT %QB160 : rf186c_cyc_CM_Output_Layout;

        // Module rf186c_cyc/RF260R_1
        rf186c_cyc_RF260R_1_Input AT %IB128 : rf186c_cyc_RF260R_1_Input_Layout;
        rf186c_cyc_RF260R_1_Output AT %QB128 : rf186c_cyc_RF260R_1_Output_Layout;

        // Module rf186c_cyc/RF340R_1
        rf186c_cyc_RF340R_1_Input AT %IB0 : rf186c_cyc_RF340R_1_Input_Layout;
        rf186c_cyc_RF340R_1_Output AT %QB0 : rf186c_cyc_RF340R_1_Output_Layout;

        // Module rf186c/Reader_1
        rf186c_Reader_1_Input AT %IB306 : rf186c_Reader_1_Input_Layout;
        rf186c_Reader_1_Output AT %QB290 : rf186c_Reader_1_Output_Layout;
    END_VAR
END_CONFIGURATION

TYPE
    et200sp_CM_4xIO_Link_RF200_CM_4xIO_Link_V2_2_144I_128O_1_Input_Layout : STRUCT
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
        Signals_32 AT %B32 : BYTE;
        Signals_33 AT %B33 : BYTE;
        Signals_34 AT %B34 : BYTE;
        Signals_35 AT %B35 : BYTE;
        Signals_36 AT %B36 : BYTE;
        Signals_37 AT %B37 : BYTE;
        Signals_38 AT %B38 : BYTE;
        Signals_39 AT %B39 : BYTE;
        Signals_40 AT %B40 : BYTE;
        Signals_41 AT %B41 : BYTE;
        Signals_42 AT %B42 : BYTE;
        Signals_43 AT %B43 : BYTE;
        Signals_44 AT %B44 : BYTE;
        Signals_45 AT %B45 : BYTE;
        Signals_46 AT %B46 : BYTE;
        Signals_47 AT %B47 : BYTE;
        Signals_48 AT %B48 : BYTE;
        Signals_49 AT %B49 : BYTE;
        Signals_50 AT %B50 : BYTE;
        Signals_51 AT %B51 : BYTE;
        Signals_52 AT %B52 : BYTE;
        Signals_53 AT %B53 : BYTE;
        Signals_54 AT %B54 : BYTE;
        Signals_55 AT %B55 : BYTE;
        Signals_56 AT %B56 : BYTE;
        Signals_57 AT %B57 : BYTE;
        Signals_58 AT %B58 : BYTE;
        Signals_59 AT %B59 : BYTE;
        Signals_60 AT %B60 : BYTE;
        Signals_61 AT %B61 : BYTE;
        Signals_62 AT %B62 : BYTE;
        Signals_63 AT %B63 : BYTE;
        Signals_64 AT %B64 : BYTE;
        Signals_65 AT %B65 : BYTE;
        Signals_66 AT %B66 : BYTE;
        Signals_67 AT %B67 : BYTE;
        Signals_68 AT %B68 : BYTE;
        Signals_69 AT %B69 : BYTE;
        Signals_70 AT %B70 : BYTE;
        Signals_71 AT %B71 : BYTE;
        Signals_72 AT %B72 : BYTE;
        Signals_73 AT %B73 : BYTE;
        Signals_74 AT %B74 : BYTE;
        Signals_75 AT %B75 : BYTE;
        Signals_76 AT %B76 : BYTE;
        Signals_77 AT %B77 : BYTE;
        Signals_78 AT %B78 : BYTE;
        Signals_79 AT %B79 : BYTE;
        Signals_80 AT %B80 : BYTE;
        Signals_81 AT %B81 : BYTE;
        Signals_82 AT %B82 : BYTE;
        Signals_83 AT %B83 : BYTE;
        Signals_84 AT %B84 : BYTE;
        Signals_85 AT %B85 : BYTE;
        Signals_86 AT %B86 : BYTE;
        Signals_87 AT %B87 : BYTE;
        Signals_88 AT %B88 : BYTE;
        Signals_89 AT %B89 : BYTE;
        Signals_90 AT %B90 : BYTE;
        Signals_91 AT %B91 : BYTE;
        Signals_92 AT %B92 : BYTE;
        Signals_93 AT %B93 : BYTE;
        Signals_94 AT %B94 : BYTE;
        Signals_95 AT %B95 : BYTE;
        Signals_96 AT %B96 : BYTE;
        Signals_97 AT %B97 : BYTE;
        Signals_98 AT %B98 : BYTE;
        Signals_99 AT %B99 : BYTE;
        Signals_100 AT %B100 : BYTE;
        Signals_101 AT %B101 : BYTE;
        Signals_102 AT %B102 : BYTE;
        Signals_103 AT %B103 : BYTE;
        Signals_104 AT %B104 : BYTE;
        Signals_105 AT %B105 : BYTE;
        Signals_106 AT %B106 : BYTE;
        Signals_107 AT %B107 : BYTE;
        Signals_108 AT %B108 : BYTE;
        Signals_109 AT %B109 : BYTE;
        Signals_110 AT %B110 : BYTE;
        Signals_111 AT %B111 : BYTE;
        Signals_112 AT %B112 : BYTE;
        Signals_113 AT %B113 : BYTE;
        Signals_114 AT %B114 : BYTE;
        Signals_115 AT %B115 : BYTE;
        Signals_116 AT %B116 : BYTE;
        Signals_117 AT %B117 : BYTE;
        Signals_118 AT %B118 : BYTE;
        Signals_119 AT %B119 : BYTE;
        Signals_120 AT %B120 : BYTE;
        Signals_121 AT %B121 : BYTE;
        Signals_122 AT %B122 : BYTE;
        Signals_123 AT %B123 : BYTE;
        Signals_124 AT %B124 : BYTE;
        Signals_125 AT %B125 : BYTE;
        Signals_126 AT %B126 : BYTE;
        Signals_127 AT %B127 : BYTE;
        Signals_128 AT %B128 : BYTE;
        Signals_129 AT %B129 : BYTE;
        Signals_130 AT %B130 : BYTE;
        Signals_131 AT %B131 : BYTE;
        Signals_132 AT %B132 : BYTE;
        Signals_133 AT %B133 : BYTE;
        Signals_134 AT %B134 : BYTE;
        Signals_135 AT %B135 : BYTE;
        Signals_136 AT %B136 : BYTE;
        Signals_137 AT %B137 : BYTE;
        Signals_138 AT %B138 : BYTE;
        Signals_139 AT %B139 : BYTE;
        Signals_140 AT %B140 : BYTE;
        Signals_141 AT %B141 : BYTE;
        Signals_142 AT %B142 : BYTE;
        Signals_143 AT %B143 : BYTE;
    END_STRUCT;
END_TYPE

TYPE
    et200sp_CM_4xIO_Link_RF200_CM_4xIO_Link_V2_2_144I_128O_1_Output_Layout : STRUCT
        Signals_144 AT %B0 : BYTE;
        Signals_145 AT %B1 : BYTE;
        Signals_146 AT %B2 : BYTE;
        Signals_147 AT %B3 : BYTE;
        Signals_148 AT %B4 : BYTE;
        Signals_149 AT %B5 : BYTE;
        Signals_150 AT %B6 : BYTE;
        Signals_151 AT %B7 : BYTE;
        Signals_152 AT %B8 : BYTE;
        Signals_153 AT %B9 : BYTE;
        Signals_154 AT %B10 : BYTE;
        Signals_155 AT %B11 : BYTE;
        Signals_156 AT %B12 : BYTE;
        Signals_157 AT %B13 : BYTE;
        Signals_158 AT %B14 : BYTE;
        Signals_159 AT %B15 : BYTE;
        Signals_160 AT %B16 : BYTE;
        Signals_161 AT %B17 : BYTE;
        Signals_162 AT %B18 : BYTE;
        Signals_163 AT %B19 : BYTE;
        Signals_164 AT %B20 : BYTE;
        Signals_165 AT %B21 : BYTE;
        Signals_166 AT %B22 : BYTE;
        Signals_167 AT %B23 : BYTE;
        Signals_168 AT %B24 : BYTE;
        Signals_169 AT %B25 : BYTE;
        Signals_170 AT %B26 : BYTE;
        Signals_171 AT %B27 : BYTE;
        Signals_172 AT %B28 : BYTE;
        Signals_173 AT %B29 : BYTE;
        Signals_174 AT %B30 : BYTE;
        Signals_175 AT %B31 : BYTE;
        Signals_176 AT %B32 : BYTE;
        Signals_177 AT %B33 : BYTE;
        Signals_178 AT %B34 : BYTE;
        Signals_179 AT %B35 : BYTE;
        Signals_180 AT %B36 : BYTE;
        Signals_181 AT %B37 : BYTE;
        Signals_182 AT %B38 : BYTE;
        Signals_183 AT %B39 : BYTE;
        Signals_184 AT %B40 : BYTE;
        Signals_185 AT %B41 : BYTE;
        Signals_186 AT %B42 : BYTE;
        Signals_187 AT %B43 : BYTE;
        Signals_188 AT %B44 : BYTE;
        Signals_189 AT %B45 : BYTE;
        Signals_190 AT %B46 : BYTE;
        Signals_191 AT %B47 : BYTE;
        Signals_192 AT %B48 : BYTE;
        Signals_193 AT %B49 : BYTE;
        Signals_194 AT %B50 : BYTE;
        Signals_195 AT %B51 : BYTE;
        Signals_196 AT %B52 : BYTE;
        Signals_197 AT %B53 : BYTE;
        Signals_198 AT %B54 : BYTE;
        Signals_199 AT %B55 : BYTE;
        Signals_200 AT %B56 : BYTE;
        Signals_201 AT %B57 : BYTE;
        Signals_202 AT %B58 : BYTE;
        Signals_203 AT %B59 : BYTE;
        Signals_204 AT %B60 : BYTE;
        Signals_205 AT %B61 : BYTE;
        Signals_206 AT %B62 : BYTE;
        Signals_207 AT %B63 : BYTE;
        Signals_208 AT %B64 : BYTE;
        Signals_209 AT %B65 : BYTE;
        Signals_210 AT %B66 : BYTE;
        Signals_211 AT %B67 : BYTE;
        Signals_212 AT %B68 : BYTE;
        Signals_213 AT %B69 : BYTE;
        Signals_214 AT %B70 : BYTE;
        Signals_215 AT %B71 : BYTE;
        Signals_216 AT %B72 : BYTE;
        Signals_217 AT %B73 : BYTE;
        Signals_218 AT %B74 : BYTE;
        Signals_219 AT %B75 : BYTE;
        Signals_220 AT %B76 : BYTE;
        Signals_221 AT %B77 : BYTE;
        Signals_222 AT %B78 : BYTE;
        Signals_223 AT %B79 : BYTE;
        Signals_224 AT %B80 : BYTE;
        Signals_225 AT %B81 : BYTE;
        Signals_226 AT %B82 : BYTE;
        Signals_227 AT %B83 : BYTE;
        Signals_228 AT %B84 : BYTE;
        Signals_229 AT %B85 : BYTE;
        Signals_230 AT %B86 : BYTE;
        Signals_231 AT %B87 : BYTE;
        Signals_232 AT %B88 : BYTE;
        Signals_233 AT %B89 : BYTE;
        Signals_234 AT %B90 : BYTE;
        Signals_235 AT %B91 : BYTE;
        Signals_236 AT %B92 : BYTE;
        Signals_237 AT %B93 : BYTE;
        Signals_238 AT %B94 : BYTE;
        Signals_239 AT %B95 : BYTE;
        Signals_240 AT %B96 : BYTE;
        Signals_241 AT %B97 : BYTE;
        Signals_242 AT %B98 : BYTE;
        Signals_243 AT %B99 : BYTE;
        Signals_244 AT %B100 : BYTE;
        Signals_245 AT %B101 : BYTE;
        Signals_246 AT %B102 : BYTE;
        Signals_247 AT %B103 : BYTE;
        Signals_248 AT %B104 : BYTE;
        Signals_249 AT %B105 : BYTE;
        Signals_250 AT %B106 : BYTE;
        Signals_251 AT %B107 : BYTE;
        Signals_252 AT %B108 : BYTE;
        Signals_253 AT %B109 : BYTE;
        Signals_254 AT %B110 : BYTE;
        Signals_255 AT %B111 : BYTE;
        Signals_256 AT %B112 : BYTE;
        Signals_257 AT %B113 : BYTE;
        Signals_258 AT %B114 : BYTE;
        Signals_259 AT %B115 : BYTE;
        Signals_260 AT %B116 : BYTE;
        Signals_261 AT %B117 : BYTE;
        Signals_262 AT %B118 : BYTE;
        Signals_263 AT %B119 : BYTE;
        Signals_264 AT %B120 : BYTE;
        Signals_265 AT %B121 : BYTE;
        Signals_266 AT %B122 : BYTE;
        Signals_267 AT %B123 : BYTE;
        Signals_268 AT %B124 : BYTE;
        Signals_269 AT %B125 : BYTE;
        Signals_270 AT %B126 : BYTE;
        Signals_271 AT %B127 : BYTE;
    END_STRUCT;
END_TYPE

TYPE
    rf186c_CM_1_Input_Layout : STRUCT
        Signals_0 AT %B0 : WORD;
    END_STRUCT;
END_TYPE

TYPE
    rf186c_CM_1_Output_Layout : STRUCT
        Signals_1 AT %B0 : WORD;
    END_STRUCT;
END_TYPE

TYPE
    rf186c_cyc_CM_Input_Layout : STRUCT
        Signals_0 AT %B0 : WORD;
    END_STRUCT;
END_TYPE

TYPE
    rf186c_cyc_CM_Output_Layout : STRUCT
        Signals_1 AT %B0 : WORD;
    END_STRUCT;
END_TYPE

TYPE
    rf186c_cyc_RF260R_1_Input_Layout : STRUCT
        Signals_0 AT %B0 : ARRAY[0..31] OF BYTE;
    END_STRUCT;
END_TYPE

TYPE
    rf186c_cyc_RF260R_1_Output_Layout : STRUCT
        Signals_1 AT %B0 : ARRAY[0..31] OF BYTE;
    END_STRUCT;
END_TYPE

TYPE
    rf186c_cyc_RF340R_1_Input_Layout : STRUCT
        Signals_0 AT %B0 : ARRAY[0..127] OF BYTE;
    END_STRUCT;
END_TYPE

TYPE
    rf186c_cyc_RF340R_1_Output_Layout : STRUCT
        Signals_1 AT %B0 : ARRAY[0..127] OF BYTE;
    END_STRUCT;
END_TYPE

TYPE
    rf186c_Reader_1_Input_Layout : STRUCT
        Signals_0 AT %B0 : WORD;
    END_STRUCT;
END_TYPE

TYPE
    rf186c_Reader_1_Output_Layout : STRUCT
        Signals_1 AT %B0 : WORD;
    END_STRUCT;
END_TYPE
