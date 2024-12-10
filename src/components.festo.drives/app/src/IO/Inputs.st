NAMESPACE AXOpen.Components.Festo.Drives
    TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
        Inputs : STRUCT
            cmmtas_DoServo_Submodule_1_0 AT %B0:  LWORD;
            cmmtas_DoServo_Submodule_1_1 AT %B8:  LWORD;
            cmmtas_DoServo_Submodule_1_2 AT %B16:  LWORD;
            cmmtas_DoServo_Submodule_2 AT %B24:  WORD;
        END_STRUCT;
    END_TYPE
END_NAMESPACE
