NAMESPACE AXOpen.Components.Desoutter.Tightening
    TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
        Inputs : STRUCT
	        // Module wp462-t1-rh-deso/Input_1_byte_1
	        wp462_t1_rh_deso_Input_1_byte_1_Input AT %B13 : wp462_t1_rh_deso_Input_1_byte_1_Input_Layout;

	        // Module wp462-t1-rh-deso/Input_1_byte_2
	        wp462_t1_rh_deso_Input_1_byte_2_Input AT %B12 : wp462_t1_rh_deso_Input_1_byte_2_Input_Layout;

	        // Module wp462-t1-rh-deso/Input_1_word_1
	        wp462_t1_rh_deso_Input_1_word_1_Input AT %B6 : wp462_t1_rh_deso_Input_1_word_1_Input_Layout;

	        // Module wp462-t1-rh-deso/Input_1_word_2
	        wp462_t1_rh_deso_Input_1_word_2_Input AT %B0 : wp462_t1_rh_deso_Input_1_word_2_Input_Layout;

	        // Module wp462-t1-rh-deso/Input_2_word_1
	        wp462_t1_rh_deso_Input_2_word_1_Input AT %B8 : wp462_t1_rh_deso_Input_2_word_1_Input_Layout;

	        // Module wp462-t1-rh-deso/Input_2_word_2
	        wp462_t1_rh_deso_Input_2_word_2_Input AT %B2 : wp462_t1_rh_deso_Input_2_word_2_Input_Layout;

        END_STRUCT;
    END_TYPE
END_NAMESPACE

