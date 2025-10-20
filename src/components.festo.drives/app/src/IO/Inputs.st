NAMESPACE AXOpen.Components.Festo.Drives
    TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
        Inputs : STRUCT
	        // Module cmmtas/DoServo
	        cmmtas_DoServo_SiemensTelegram111_PZD_12_12_Input AT %B0 : cmmtas_DoServo_SiemensTelegram111_PZD_12_12_Input_Layout;

	        cmmtas_DoServo_SiemensTelegram750_PZD_4_1_Input AT %B24 : cmmtas_DoServo_SiemensTelegram750_PZD_4_1_Input_Layout;

        END_STRUCT;
    END_TYPE
END_NAMESPACE

