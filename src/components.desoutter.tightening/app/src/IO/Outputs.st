NAMESPACE AXOpen.Components.Desoutter.Tightening
    TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
        Outputs : STRUCT
	        // Module desoutter_cvic_ii/Output_1_byte_1
	        desoutter_cvic_ii_Output_1_byte_1_Output AT %B1 : desoutter_cvic_ii_Output_1_byte_1_Output_Layout;

	        // Module desoutter_cvic_ii/Output_1_byte_2
	        desoutter_cvic_ii_Output_1_byte_2_Output AT %B0 : desoutter_cvic_ii_Output_1_byte_2_Output_Layout;

        END_STRUCT;
    END_TYPE
END_NAMESPACE

