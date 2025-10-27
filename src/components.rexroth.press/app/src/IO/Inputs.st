NAMESPACE AXOpen.Components.Rexroth.Press
    TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
        Inputs : STRUCT
	        // Module SFK/Input_24_Words
	        SFK_Input_24_Words_Input AT %B0 : SFK_Input_24_Words_Input_Layout;

	        // Module SFK/ParamCh_5Words
	        SFK_ParamCh_5Words_Input AT %B48 : SFK_ParamCh_5Words_Input_Layout;

        END_STRUCT;
    END_TYPE
END_NAMESPACE

