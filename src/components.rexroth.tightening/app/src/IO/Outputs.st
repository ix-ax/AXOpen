NAMESPACE AXOpen.Components.Rexroth.Tightening
    TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
        Outputs : STRUCT
            Axo_CS351_Output_2_word_1 AT %B0:  DWORD;
            Axo_CS351_Output_4_word_1 AT %B60:  LWORD;
            Axo_CS351_Output_4_word_2 AT %B52:  LWORD;
            Axo_CS351_Output_4_word_3 AT %B44:  LWORD;
            Axo_CS351_Output_4_word_4 AT %B36:  LWORD;
            Axo_CS351_Output_4_word_5 AT %B28:  LWORD;
            Axo_CS351_Output_4_word_6 AT %B20:  LWORD;
            Axo_CS351_Output_4_word_7 AT %B12:  LWORD;
            Axo_CS351_Output_4_word_8 AT %B4:  LWORD;
        END_STRUCT;
    END_TYPE
END_NAMESPACE
