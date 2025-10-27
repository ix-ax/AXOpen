NAMESPACE AXOpen.Components.Dukane.Welders
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    dukaneiqauto_iQ_to_PLC_Inputs_Input_Layout : STRUCT
	        Signals_0 AT %B0 : DWORD;
	        Signals_1 AT %B4 : DWORD;
	        Signals_2 AT %B8 : DWORD;
	        Signals_3 AT %B12 : DWORD;
	        Signals_4 AT %B16 : DWORD;
	        Signals_5 AT %B20 : DWORD;
	        Signals_6 AT %B24 : DWORD;
	        Signals_7 AT %B28 : DWORD;
	        Signals_8 AT %B32 : DWORD;
	        Signals_9 AT %B36 : DWORD;
	        Signals_10 AT %B40 : DWORD;
	        Signals_11 AT %B44 : DWORD;
	        Signals_12 AT %B48 : DWORD;
	        Signals_13 AT %B52 : DWORD;
	        Signals_14 AT %B56 : DWORD;
	        Signals_15 AT %B60 : DWORD;
	        Signals_16 AT %B64 : DWORD;
	        Signals_17 AT %B68 : DWORD;
	        Signals_18 AT %B72 : DWORD;
	        Signals_19 AT %B76 : DWORD;
	        Signals_20 AT %B80 : DWORD;
	        Signals_21 AT %B84 : DWORD;
	        Signals_22 AT %B88 : DWORD;
	        Signals_23 AT %B92 : DWORD;
	        Signals_24 AT %B96 : DWORD;
	        Signals_25 AT %B100 : DWORD;
	        Signals_26 AT %B104 : DWORD;
	        Signals_27 AT %B108 : DWORD;
	        Signals_28 AT %B112 : DWORD;
	        Signals_29 AT %B116 : DWORD;
	        Signals_30 AT %B120 : DWORD;
	        Signals_31 AT %B124 : DWORD;
	        Signals_32 AT %B128 : DWORD;
	        Signals_33 AT %B132 : DWORD;
	        Signals_34 AT %B136 : DWORD;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    dukaneiqauto_PLC_to_iQ_Outputs_Output_Layout : STRUCT
	        Signals_0 AT %B0 : DWORD;
	        Signals_1 AT %B4 : DWORD;
	        Signals_2 AT %B8 : DWORD;
	        Signals_3 AT %B12 : DWORD;
	        Signals_4 AT %B16 : DWORD;
	    END_STRUCT;
	END_TYPE
END_NAMESPACE

