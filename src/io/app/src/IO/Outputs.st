NAMESPACE AXOpen.Io
    TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
        Outputs : STRUCT
	        // Module et200sp/A20
	        et200sp_A20_Output AT %B33 : et200sp_A20_Output_Layout;

	        et200sp_A30_Output AT %B0 : et200sp_A30_Output_Layout;

        END_STRUCT;
    END_TYPE
END_NAMESPACE

