NAMESPACE AXOpen.Components.Rexroth.Press
    TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
        Inputs : STRUCT
            SFK_Input_24_Words_0 AT %B0:  LWORD;
            SFK_Input_24_Words_1 AT %B8:  LWORD;
            SFK_Input_24_Words_2 AT %B16:  LWORD;
            SFK_Input_24_Words_3 AT %B24:  LWORD;
            SFK_Input_24_Words_4 AT %B32:  LWORD;
            SFK_Input_24_Words_5 AT %B40:  LWORD;
            SFK_ParamCh_5Words_0 AT %B48:  WORD;
            SFK_ParamCh_5Words_1 AT %B50:  WORD;
            SFK_ParamCh_5Words_2 AT %B52:  WORD;
            SFK_ParamCh_5Words_3 AT %B54:  WORD;
            SFK_ParamCh_5Words_4 AT %B56:  WORD;
        END_STRUCT;
    END_TYPE
END_NAMESPACE
