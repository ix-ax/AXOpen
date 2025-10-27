NAMESPACE AXOpen.Components.Siem.Communication
    TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
        Inputs : STRUCT
	        // Module et200sp/CpPtp
	        et200sp_CpPtp_Input AT %B0 : et200sp_CpPtp_Input_Layout;

        END_STRUCT;
    END_TYPE
END_NAMESPACE

