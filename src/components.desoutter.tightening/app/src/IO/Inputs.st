NAMESPACE AXOpen.Components.Desoutter.Tightening
    TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
        Inputs : STRUCT
	        // Module desoutter/Input_1_byte_1
	        desoutter_Input_1_byte_1_Input AT %B13 : desoutter_Input_1_byte_1_Input_Layout;

	        // Module desoutter/Input_1_byte_2
	        desoutter_Input_1_byte_2_Input AT %B12 : desoutter_Input_1_byte_2_Input_Layout;

	        // Module desoutter/Input_1_word_1
	        desoutter_Input_1_word_1_Input AT %B6 : desoutter_Input_1_word_1_Input_Layout;

	        // Module desoutter/Input_1_word_2
	        desoutter_Input_1_word_2_Input AT %B0 : desoutter_Input_1_word_2_Input_Layout;

	        // Module desoutter/Input_2_word_1
	        desoutter_Input_2_word_1_Input AT %B8 : desoutter_Input_2_word_1_Input_Layout;

	        // Module desoutter/Input_2_word_2
	        desoutter_Input_2_word_2_Input AT %B2 : desoutter_Input_2_word_2_Input_Layout;

        END_STRUCT;
    END_TYPE
END_NAMESPACE

