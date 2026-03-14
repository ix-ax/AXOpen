NAMESPACE AXOpen.Components.Balluff.Identification
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    BNIPNT507005Z040_BIS_M_4XX_045_1_Input_Layout : STRUCT
	        Signals_0 AT %B0 : ARRAY[0..9] OF BYTE;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    BNIPNT507005Z040_BIS_M_4XX_045_1_Output_Layout : STRUCT
	        Signals_1 AT %B0 : ARRAY[0..9] OF BYTE;
	    END_STRUCT;
	END_TYPE
END_NAMESPACE

