NAMESPACE AXOpen.Components.Desoutter.Tightening
    TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
        Inputs : STRUCT
            wp462_t1_rh_deso_Input_1_byte_1 AT %B13:  BYTE;
            wp462_t1_rh_deso_Input_1_byte_2 AT %B12:  BYTE;
            wp462_t1_rh_deso_Input_1_word_1 AT %B6:  WORD;
            wp462_t1_rh_deso_Input_1_word_2 AT %B0:  WORD;
            wp462_t1_rh_deso_Input_2_word_1 AT %B8:  DWORD;
            wp462_t1_rh_deso_Input_2_word_2 AT %B2:  DWORD;
        END_STRUCT;
    END_TYPE
END_NAMESPACE
