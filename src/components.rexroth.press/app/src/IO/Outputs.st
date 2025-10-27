NAMESPACE AXOpen.Components.Rexroth.Press
    TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
        Outputs : STRUCT
	        // Module SFK/Output_21_Words
	        SFK_Output_21_Words_Output AT %B0 : SFK_Output_21_Words_Output_Layout;

	        SFK_ParamCh_5Words_Output AT %B42 : SFK_ParamCh_5Words_Output_Layout;

        END_STRUCT;
    END_TYPE
END_NAMESPACE

