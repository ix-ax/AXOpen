NAMESPACE AXOpen.Components.Rexroth.Press
    TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
        Outputs : STRUCT
	        // Module rexroth_press/Output_21_Words
	        rexroth_press_Output_21_Words_Output AT %B0 : rexroth_press_Output_21_Words_Output_Layout;

	        rexroth_press_ParamCh_5Words_Output AT %B42 : rexroth_press_ParamCh_5Words_Output_Layout;

        END_STRUCT;
    END_TYPE
END_NAMESPACE

