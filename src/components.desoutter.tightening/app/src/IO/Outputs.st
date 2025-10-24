NAMESPACE AXOpen.Components.Desoutter.Tightening
    TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
        Outputs : STRUCT
	        // Module desoutter/Output_1_byte_1
	        desoutter_Output_1_byte_1_Output AT %B1 : desoutter_Output_1_byte_1_Output_Layout;

	        // Module desoutter/Output_1_byte_2
	        desoutter_Output_1_byte_2_Output AT %B0 : desoutter_Output_1_byte_2_Output_Layout;

        END_STRUCT;
    END_TYPE
END_NAMESPACE

