NAMESPACE AXOpen.Components.Kuka.Robotics
    TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
        Outputs : STRUCT
            KRC4_DIO512_0 AT %B0:  LWORD;
            KRC4_DIO512_1 AT %B8:  LWORD;
            KRC4_DIO512_2 AT %B16:  LWORD;
            KRC4_DIO512_3 AT %B24:  LWORD;
            KRC4_DIO512_4 AT %B32:  LWORD;
            KRC4_DIO512_5 AT %B40:  LWORD;
            KRC4_DIO512_6 AT %B48:  LWORD;
            KRC4_DIO512_7 AT %B56:  LWORD;
        END_STRUCT;
    END_TYPE
END_NAMESPACE
