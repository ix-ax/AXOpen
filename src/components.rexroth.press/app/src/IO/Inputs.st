NAMESPACE AXOpen.Components.Rexroth.Press
    TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
        Inputs : STRUCT
	        // Module rexroth_press/Input_24_Words
	        rexroth_press_Input_24_Words_Input AT %B0 : rexroth_press_Input_24_Words_Input_Layout;

	        // Module rexroth_press/ParamCh_5Words
	        rexroth_press_ParamCh_5Words_Input AT %B48 : rexroth_press_ParamCh_5Words_Input_Layout;

        END_STRUCT;
    END_TYPE
END_NAMESPACE

