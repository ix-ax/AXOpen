NAMESPACE AXOpen.Io
    TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
        Inputs : STRUCT
	        // Module et200sp/A10
	        et200sp_A10_Input AT %B36 : et200sp_A10_Input_Layout;

	        // Module et200sp/A30
	        et200sp_A30_Input AT %B0 : et200sp_A30_Input_Layout;

        END_STRUCT;
    END_TYPE
END_NAMESPACE

