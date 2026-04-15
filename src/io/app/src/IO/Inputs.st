NAMESPACE AXOpen.Io
    TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
        Inputs : STRUCT
	        // Module bni00l3/BALLUFF_Link_module
	        bni00l3_BALLUFF_Link_module_BALLUFF_8_Port_IO_Link_Master_Input AT %B0 : bni00l3_BALLUFF_Link_module_BALLUFF_8_Port_IO_Link_Master_Input_Layout;

	        bni00l3_BALLUFF_Link_module_X01_Input AT %B1 : bni00l3_BALLUFF_Link_module_X01_Input_Layout;

	        bni00l3_BALLUFF_Link_module_X02_Input AT %B6 : bni00l3_BALLUFF_Link_module_X02_Input_Layout;

	        bni00l3_BALLUFF_Link_module_X03_Input AT %B43 : bni00l3_BALLUFF_Link_module_X03_Input_Layout;

	        bni00l3_BALLUFF_Link_module_X04_Input AT %B46 : bni00l3_BALLUFF_Link_module_X04_Input_Layout;

	        // Module et200sp/A10
	        et200sp_A10_Input AT %B41 : et200sp_A10_Input_Layout;

	        // Module et200sp/A30
	        et200sp_A30_Input AT %B9 : et200sp_A30_Input_Layout;

        END_STRUCT;
    END_TYPE
END_NAMESPACE

