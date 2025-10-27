NAMESPACE AXOpen.Components.Keyence.Vision
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    keyence_iv3_CommandControl_Output_Layout : STRUCT
	        Signals_0 AT %X0.0 : BOOL;
	        Signals_1 AT %X0.1 : BOOL;
	        Signals_2 AT %X0.2 : BOOL;
	        Signals_3 AT %X0.3 : BOOL;
	        Signals_4 AT %X0.4 : BOOL;
	        Signals_5 AT %X0.5 : BOOL;
	        Signals_6 AT %X0.6 : BOOL;
	        Signals_7 AT %X0.7 : BOOL;
	        Signals_8 AT %B1 : BYTE;
	        Signals_9 AT %X2.0 : BOOL;
	        Signals_10 AT %B3 : BYTE;
	        Signals_11 AT %B4 : WORD;
	        Signals_12 AT %B6 : WORD;
	        Signals_13 AT %B8 : DWORD;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    keyence_iv3_CommandStatusBits_Input_Layout : STRUCT
	        Signals_0 AT %X0.0 : BOOL;
	        Signals_1 AT %X0.1 : BOOL;
	        Signals_2 AT %X0.2 : BOOL;
	        Signals_3 AT %X0.3 : BOOL;
	        Signals_4 AT %X0.4 : BOOL;
	        Signals_5 AT %X0.5 : BOOL;
	        Signals_6 AT %X0.6 : BOOL;
	        Signals_7 AT %X0.7 : BOOL;
	        Signals_8 AT %X1.0 : BOOL;
	        Signals_9 AT %X1.1 : BOOL;
	        Signals_10 AT %X1.2 : BOOL;
	        Signals_11 AT %X1.6 : BOOL;
	        Signals_12 AT %X1.7 : BOOL;
	        Signals_13 AT %X2.0 : BOOL;
	        Signals_14 AT %X2.1 : BOOL;
	        Signals_15 AT %X2.2 : BOOL;
	        Signals_16 AT %X2.3 : BOOL;
	        Signals_17 AT %X2.4 : BOOL;
	        Signals_18 AT %X2.5 : BOOL;
	        Signals_19 AT %X2.7 : BOOL;
	        Signals_20 AT %X3.0 : BOOL;
	        Signals_21 AT %X3.4 : BOOL;
	        Signals_22 AT %X3.5 : BOOL;
	        Signals_23 AT %X3.6 : BOOL;
	        Signals_24 AT %X3.7 : BOOL;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    keyence_iv3_DeviceResultBits_1_Input_Layout : STRUCT
	        Signals_0 AT %X0.0 : BOOL;
	        Signals_1 AT %X0.1 : BOOL;
	        Signals_2 AT %X0.2 : BOOL;
	        Signals_3 AT %X0.3 : BOOL;
	        Signals_4 AT %X0.4 : BOOL;
	        Signals_5 AT %X0.5 : BOOL;
	        Signals_6 AT %X0.6 : BOOL;
	        Signals_7 AT %B1 : BYTE;
	        Signals_8 AT %X2.0 : BOOL;
	        Signals_9 AT %X2.1 : BOOL;
	        Signals_10 AT %X2.2 : BOOL;
	        Signals_11 AT %X2.3 : BOOL;
	        Signals_12 AT %X2.4 : BOOL;
	        Signals_13 AT %X2.5 : BOOL;
	        Signals_14 AT %X2.6 : BOOL;
	        Signals_15 AT %X2.7 : BOOL;
	        Signals_16 AT %X3.0 : BOOL;
	        Signals_17 AT %X3.1 : BOOL;
	        Signals_18 AT %X3.2 : BOOL;
	        Signals_19 AT %X3.3 : BOOL;
	        Signals_20 AT %X3.4 : BOOL;
	        Signals_21 AT %X3.5 : BOOL;
	        Signals_22 AT %X3.6 : BOOL;
	        Signals_23 AT %X3.7 : BOOL;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    keyence_iv3_DeviceResultBits_2_Input_Layout : STRUCT
	        Signals_0 AT %B0 : WORD;
	        Signals_1 AT %X2.0 : BOOL;
	        Signals_2 AT %X2.1 : BOOL;
	        Signals_3 AT %X2.2 : BOOL;
	        Signals_4 AT %X2.3 : BOOL;
	        Signals_5 AT %X2.4 : BOOL;
	        Signals_6 AT %X2.5 : BOOL;
	        Signals_7 AT %X2.6 : BOOL;
	        Signals_8 AT %X2.7 : BOOL;
	        Signals_9 AT %X3.0 : BOOL;
	        Signals_10 AT %X3.1 : BOOL;
	        Signals_11 AT %X3.2 : BOOL;
	        Signals_12 AT %X3.3 : BOOL;
	        Signals_13 AT %X3.4 : BOOL;
	        Signals_14 AT %X3.5 : BOOL;
	        Signals_15 AT %X3.6 : BOOL;
	        Signals_16 AT %X3.7 : BOOL;
	        Signals_17 AT %X4.0 : BOOL;
	        Signals_18 AT %X4.1 : BOOL;
	        Signals_19 AT %X4.2 : BOOL;
	        Signals_20 AT %X4.3 : BOOL;
	        Signals_21 AT %X4.4 : BOOL;
	        Signals_22 AT %X4.5 : BOOL;
	        Signals_23 AT %X4.6 : BOOL;
	        Signals_24 AT %X4.7 : BOOL;
	        Signals_25 AT %X5.0 : BOOL;
	        Signals_26 AT %X5.1 : BOOL;
	        Signals_27 AT %X5.2 : BOOL;
	        Signals_28 AT %X5.3 : BOOL;
	        Signals_29 AT %X5.4 : BOOL;
	        Signals_30 AT %X5.5 : BOOL;
	        Signals_31 AT %X5.6 : BOOL;
	        Signals_32 AT %X5.7 : BOOL;
	        Signals_33 AT %X6.0 : BOOL;
	        Signals_34 AT %X6.1 : BOOL;
	        Signals_35 AT %X6.2 : BOOL;
	        Signals_36 AT %X6.3 : BOOL;
	        Signals_37 AT %X6.4 : BOOL;
	        Signals_38 AT %X6.5 : BOOL;
	        Signals_39 AT %X6.6 : BOOL;
	        Signals_40 AT %X6.7 : BOOL;
	        Signals_41 AT %X7.0 : BOOL;
	        Signals_42 AT %X7.1 : BOOL;
	        Signals_43 AT %X7.2 : BOOL;
	        Signals_44 AT %X7.3 : BOOL;
	        Signals_45 AT %X7.4 : BOOL;
	        Signals_46 AT %X7.5 : BOOL;
	        Signals_47 AT %X7.6 : BOOL;
	        Signals_48 AT %X7.7 : BOOL;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    keyence_iv3_DeviceStatistics_Input_Layout : STRUCT
	        Signals_0 AT %B0 : WORD;
	        Signals_1 AT %B2 : WORD;
	        Signals_2 AT %B4 : WORD;
	        Signals_3 AT %B6 : WORD;
	        Signals_4 AT %B8 : DWORD;
	        Signals_5 AT %B12 : DWORD;
	        Signals_6 AT %B16 : DWORD;
	        Signals_7 AT %B20 : DWORD;
	        Signals_8 AT %B24 : DWORD;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    keyence_iv3_DeviceStatusWords_Input_Layout : STRUCT
	        Signals_0 AT %B0 : WORD;
	        Signals_1 AT %B2 : WORD;
	        Signals_2 AT %B4 : WORD;
	        Signals_3 AT %B6 : WORD;
	        Signals_4 AT %B8 : WORD;
	        Signals_5 AT %B10 : WORD;
	        Signals_6 AT %B12 : WORD;
	        Signals_7 AT %B14 : WORD;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    keyence_iv3_PositionAdjustResult_Input_Layout : STRUCT
	        Signals_0 AT %B0 : WORD;
	        Signals_1 AT %B2 : WORD;
	        Signals_2 AT %B4 : WORD;
	        Signals_3 AT %B6 : WORD;
	        Signals_4 AT %B8 : WORD;
	        Signals_5 AT %B10 : WORD;
	        Signals_6 AT %B12 : WORD;
	        Signals_7 AT %B14 : WORD;
	        Signals_8 AT %B16 : WORD;
	        Signals_9 AT %B18 : WORD;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    keyence_iv3_ToolResult_1_Input_Layout : STRUCT
	        Signals_0 AT %B0 : WORD;
	        Signals_1 AT %B2 : WORD;
	        Signals_2 AT %B4 : WORD;
	        Signals_3 AT %B6 : WORD;
	        Signals_4 AT %B8 : WORD;
	        Signals_5 AT %B10 : WORD;
	        Signals_6 AT %B12 : WORD;
	        Signals_7 AT %B14 : WORD;
	        Signals_8 AT %B16 : WORD;
	        Signals_9 AT %B18 : WORD;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    keyence_iv3_ToolResult_10_Input_Layout : STRUCT
	        Signals_0 AT %B0 : WORD;
	        Signals_1 AT %B2 : WORD;
	        Signals_2 AT %B4 : WORD;
	        Signals_3 AT %B6 : WORD;
	        Signals_4 AT %B8 : WORD;
	        Signals_5 AT %B10 : WORD;
	        Signals_6 AT %B12 : WORD;
	        Signals_7 AT %B14 : WORD;
	        Signals_8 AT %B16 : WORD;
	        Signals_9 AT %B18 : WORD;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    keyence_iv3_ToolResult_11_Input_Layout : STRUCT
	        Signals_0 AT %B0 : WORD;
	        Signals_1 AT %B2 : WORD;
	        Signals_2 AT %B4 : WORD;
	        Signals_3 AT %B6 : WORD;
	        Signals_4 AT %B8 : WORD;
	        Signals_5 AT %B10 : WORD;
	        Signals_6 AT %B12 : WORD;
	        Signals_7 AT %B14 : WORD;
	        Signals_8 AT %B16 : WORD;
	        Signals_9 AT %B18 : WORD;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    keyence_iv3_ToolResult_12_Input_Layout : STRUCT
	        Signals_0 AT %B0 : WORD;
	        Signals_1 AT %B2 : WORD;
	        Signals_2 AT %B4 : WORD;
	        Signals_3 AT %B6 : WORD;
	        Signals_4 AT %B8 : WORD;
	        Signals_5 AT %B10 : WORD;
	        Signals_6 AT %B12 : WORD;
	        Signals_7 AT %B14 : WORD;
	        Signals_8 AT %B16 : WORD;
	        Signals_9 AT %B18 : WORD;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    keyence_iv3_ToolResult_13_Input_Layout : STRUCT
	        Signals_0 AT %B0 : WORD;
	        Signals_1 AT %B2 : WORD;
	        Signals_2 AT %B4 : WORD;
	        Signals_3 AT %B6 : WORD;
	        Signals_4 AT %B8 : WORD;
	        Signals_5 AT %B10 : WORD;
	        Signals_6 AT %B12 : WORD;
	        Signals_7 AT %B14 : WORD;
	        Signals_8 AT %B16 : WORD;
	        Signals_9 AT %B18 : WORD;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    keyence_iv3_ToolResult_14_Input_Layout : STRUCT
	        Signals_0 AT %B0 : WORD;
	        Signals_1 AT %B2 : WORD;
	        Signals_2 AT %B4 : WORD;
	        Signals_3 AT %B6 : WORD;
	        Signals_4 AT %B8 : WORD;
	        Signals_5 AT %B10 : WORD;
	        Signals_6 AT %B12 : WORD;
	        Signals_7 AT %B14 : WORD;
	        Signals_8 AT %B16 : WORD;
	        Signals_9 AT %B18 : WORD;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    keyence_iv3_ToolResult_15_Input_Layout : STRUCT
	        Signals_0 AT %B0 : WORD;
	        Signals_1 AT %B2 : WORD;
	        Signals_2 AT %B4 : WORD;
	        Signals_3 AT %B6 : WORD;
	        Signals_4 AT %B8 : WORD;
	        Signals_5 AT %B10 : WORD;
	        Signals_6 AT %B12 : WORD;
	        Signals_7 AT %B14 : WORD;
	        Signals_8 AT %B16 : WORD;
	        Signals_9 AT %B18 : WORD;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    keyence_iv3_ToolResult_16_Input_Layout : STRUCT
	        Signals_0 AT %B0 : WORD;
	        Signals_1 AT %B2 : WORD;
	        Signals_2 AT %B4 : WORD;
	        Signals_3 AT %B6 : WORD;
	        Signals_4 AT %B8 : WORD;
	        Signals_5 AT %B10 : WORD;
	        Signals_6 AT %B12 : WORD;
	        Signals_7 AT %B14 : WORD;
	        Signals_8 AT %B16 : WORD;
	        Signals_9 AT %B18 : WORD;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    keyence_iv3_ToolResult_17_Input_Layout : STRUCT
	        Signals_0 AT %B0 : WORD;
	        Signals_1 AT %B2 : WORD;
	        Signals_2 AT %B4 : WORD;
	        Signals_3 AT %B6 : WORD;
	        Signals_4 AT %B8 : WORD;
	        Signals_5 AT %B10 : WORD;
	        Signals_6 AT %B12 : WORD;
	        Signals_7 AT %B14 : WORD;
	        Signals_8 AT %B16 : WORD;
	        Signals_9 AT %B18 : WORD;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    keyence_iv3_ToolResult_18_Input_Layout : STRUCT
	        Signals_0 AT %B0 : WORD;
	        Signals_1 AT %B2 : WORD;
	        Signals_2 AT %B4 : WORD;
	        Signals_3 AT %B6 : WORD;
	        Signals_4 AT %B8 : WORD;
	        Signals_5 AT %B10 : WORD;
	        Signals_6 AT %B12 : WORD;
	        Signals_7 AT %B14 : WORD;
	        Signals_8 AT %B16 : WORD;
	        Signals_9 AT %B18 : WORD;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    keyence_iv3_ToolResult_19_Input_Layout : STRUCT
	        Signals_0 AT %B0 : WORD;
	        Signals_1 AT %B2 : WORD;
	        Signals_2 AT %B4 : WORD;
	        Signals_3 AT %B6 : WORD;
	        Signals_4 AT %B8 : WORD;
	        Signals_5 AT %B10 : WORD;
	        Signals_6 AT %B12 : WORD;
	        Signals_7 AT %B14 : WORD;
	        Signals_8 AT %B16 : WORD;
	        Signals_9 AT %B18 : WORD;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    keyence_iv3_ToolResult_2_Input_Layout : STRUCT
	        Signals_0 AT %B0 : WORD;
	        Signals_1 AT %B2 : WORD;
	        Signals_2 AT %B4 : WORD;
	        Signals_3 AT %B6 : WORD;
	        Signals_4 AT %B8 : WORD;
	        Signals_5 AT %B10 : WORD;
	        Signals_6 AT %B12 : WORD;
	        Signals_7 AT %B14 : WORD;
	        Signals_8 AT %B16 : WORD;
	        Signals_9 AT %B18 : WORD;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    keyence_iv3_ToolResult_20_Input_Layout : STRUCT
	        Signals_0 AT %B0 : WORD;
	        Signals_1 AT %B2 : WORD;
	        Signals_2 AT %B4 : WORD;
	        Signals_3 AT %B6 : WORD;
	        Signals_4 AT %B8 : WORD;
	        Signals_5 AT %B10 : WORD;
	        Signals_6 AT %B12 : WORD;
	        Signals_7 AT %B14 : WORD;
	        Signals_8 AT %B16 : WORD;
	        Signals_9 AT %B18 : WORD;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    keyence_iv3_ToolResult_21_Input_Layout : STRUCT
	        Signals_0 AT %B0 : WORD;
	        Signals_1 AT %B2 : WORD;
	        Signals_2 AT %B4 : WORD;
	        Signals_3 AT %B6 : WORD;
	        Signals_4 AT %B8 : WORD;
	        Signals_5 AT %B10 : WORD;
	        Signals_6 AT %B12 : WORD;
	        Signals_7 AT %B14 : WORD;
	        Signals_8 AT %B16 : WORD;
	        Signals_9 AT %B18 : WORD;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    keyence_iv3_ToolResult_22_Input_Layout : STRUCT
	        Signals_0 AT %B0 : WORD;
	        Signals_1 AT %B2 : WORD;
	        Signals_2 AT %B4 : WORD;
	        Signals_3 AT %B6 : WORD;
	        Signals_4 AT %B8 : WORD;
	        Signals_5 AT %B10 : WORD;
	        Signals_6 AT %B12 : WORD;
	        Signals_7 AT %B14 : WORD;
	        Signals_8 AT %B16 : WORD;
	        Signals_9 AT %B18 : WORD;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    keyence_iv3_ToolResult_23_Input_Layout : STRUCT
	        Signals_0 AT %B0 : WORD;
	        Signals_1 AT %B2 : WORD;
	        Signals_2 AT %B4 : WORD;
	        Signals_3 AT %B6 : WORD;
	        Signals_4 AT %B8 : WORD;
	        Signals_5 AT %B10 : WORD;
	        Signals_6 AT %B12 : WORD;
	        Signals_7 AT %B14 : WORD;
	        Signals_8 AT %B16 : WORD;
	        Signals_9 AT %B18 : WORD;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    keyence_iv3_ToolResult_24_Input_Layout : STRUCT
	        Signals_0 AT %B0 : WORD;
	        Signals_1 AT %B2 : WORD;
	        Signals_2 AT %B4 : WORD;
	        Signals_3 AT %B6 : WORD;
	        Signals_4 AT %B8 : WORD;
	        Signals_5 AT %B10 : WORD;
	        Signals_6 AT %B12 : WORD;
	        Signals_7 AT %B14 : WORD;
	        Signals_8 AT %B16 : WORD;
	        Signals_9 AT %B18 : WORD;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    keyence_iv3_ToolResult_25_Input_Layout : STRUCT
	        Signals_0 AT %B0 : WORD;
	        Signals_1 AT %B2 : WORD;
	        Signals_2 AT %B4 : WORD;
	        Signals_3 AT %B6 : WORD;
	        Signals_4 AT %B8 : WORD;
	        Signals_5 AT %B10 : WORD;
	        Signals_6 AT %B12 : WORD;
	        Signals_7 AT %B14 : WORD;
	        Signals_8 AT %B16 : WORD;
	        Signals_9 AT %B18 : WORD;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    keyence_iv3_ToolResult_26_Input_Layout : STRUCT
	        Signals_0 AT %B0 : WORD;
	        Signals_1 AT %B2 : WORD;
	        Signals_2 AT %B4 : WORD;
	        Signals_3 AT %B6 : WORD;
	        Signals_4 AT %B8 : WORD;
	        Signals_5 AT %B10 : WORD;
	        Signals_6 AT %B12 : WORD;
	        Signals_7 AT %B14 : WORD;
	        Signals_8 AT %B16 : WORD;
	        Signals_9 AT %B18 : WORD;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    keyence_iv3_ToolResult_27_Input_Layout : STRUCT
	        Signals_0 AT %B0 : WORD;
	        Signals_1 AT %B2 : WORD;
	        Signals_2 AT %B4 : WORD;
	        Signals_3 AT %B6 : WORD;
	        Signals_4 AT %B8 : WORD;
	        Signals_5 AT %B10 : WORD;
	        Signals_6 AT %B12 : WORD;
	        Signals_7 AT %B14 : WORD;
	        Signals_8 AT %B16 : WORD;
	        Signals_9 AT %B18 : WORD;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    keyence_iv3_ToolResult_28_Input_Layout : STRUCT
	        Signals_0 AT %B0 : WORD;
	        Signals_1 AT %B2 : WORD;
	        Signals_2 AT %B4 : WORD;
	        Signals_3 AT %B6 : WORD;
	        Signals_4 AT %B8 : WORD;
	        Signals_5 AT %B10 : WORD;
	        Signals_6 AT %B12 : WORD;
	        Signals_7 AT %B14 : WORD;
	        Signals_8 AT %B16 : WORD;
	        Signals_9 AT %B18 : WORD;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    keyence_iv3_ToolResult_29_Input_Layout : STRUCT
	        Signals_0 AT %B0 : WORD;
	        Signals_1 AT %B2 : WORD;
	        Signals_2 AT %B4 : WORD;
	        Signals_3 AT %B6 : WORD;
	        Signals_4 AT %B8 : WORD;
	        Signals_5 AT %B10 : WORD;
	        Signals_6 AT %B12 : WORD;
	        Signals_7 AT %B14 : WORD;
	        Signals_8 AT %B16 : WORD;
	        Signals_9 AT %B18 : WORD;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    keyence_iv3_ToolResult_3_Input_Layout : STRUCT
	        Signals_0 AT %B0 : WORD;
	        Signals_1 AT %B2 : WORD;
	        Signals_2 AT %B4 : WORD;
	        Signals_3 AT %B6 : WORD;
	        Signals_4 AT %B8 : WORD;
	        Signals_5 AT %B10 : WORD;
	        Signals_6 AT %B12 : WORD;
	        Signals_7 AT %B14 : WORD;
	        Signals_8 AT %B16 : WORD;
	        Signals_9 AT %B18 : WORD;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    keyence_iv3_ToolResult_30_Input_Layout : STRUCT
	        Signals_0 AT %B0 : WORD;
	        Signals_1 AT %B2 : WORD;
	        Signals_2 AT %B4 : WORD;
	        Signals_3 AT %B6 : WORD;
	        Signals_4 AT %B8 : WORD;
	        Signals_5 AT %B10 : WORD;
	        Signals_6 AT %B12 : WORD;
	        Signals_7 AT %B14 : WORD;
	        Signals_8 AT %B16 : WORD;
	        Signals_9 AT %B18 : WORD;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    keyence_iv3_ToolResult_31_Input_Layout : STRUCT
	        Signals_0 AT %B0 : WORD;
	        Signals_1 AT %B2 : WORD;
	        Signals_2 AT %B4 : WORD;
	        Signals_3 AT %B6 : WORD;
	        Signals_4 AT %B8 : WORD;
	        Signals_5 AT %B10 : WORD;
	        Signals_6 AT %B12 : WORD;
	        Signals_7 AT %B14 : WORD;
	        Signals_8 AT %B16 : WORD;
	        Signals_9 AT %B18 : WORD;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    keyence_iv3_ToolResult_32_Input_Layout : STRUCT
	        Signals_0 AT %B0 : WORD;
	        Signals_1 AT %B2 : WORD;
	        Signals_2 AT %B4 : WORD;
	        Signals_3 AT %B6 : WORD;
	        Signals_4 AT %B8 : WORD;
	        Signals_5 AT %B10 : WORD;
	        Signals_6 AT %B12 : WORD;
	        Signals_7 AT %B14 : WORD;
	        Signals_8 AT %B16 : WORD;
	        Signals_9 AT %B18 : WORD;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    keyence_iv3_ToolResult_33_Input_Layout : STRUCT
	        Signals_0 AT %B0 : WORD;
	        Signals_1 AT %B2 : WORD;
	        Signals_2 AT %B4 : WORD;
	        Signals_3 AT %B6 : WORD;
	        Signals_4 AT %B8 : WORD;
	        Signals_5 AT %B10 : WORD;
	        Signals_6 AT %B12 : WORD;
	        Signals_7 AT %B14 : WORD;
	        Signals_8 AT %B16 : WORD;
	        Signals_9 AT %B18 : WORD;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    keyence_iv3_ToolResult_34_Input_Layout : STRUCT
	        Signals_0 AT %B0 : WORD;
	        Signals_1 AT %B2 : WORD;
	        Signals_2 AT %B4 : WORD;
	        Signals_3 AT %B6 : WORD;
	        Signals_4 AT %B8 : WORD;
	        Signals_5 AT %B10 : WORD;
	        Signals_6 AT %B12 : WORD;
	        Signals_7 AT %B14 : WORD;
	        Signals_8 AT %B16 : WORD;
	        Signals_9 AT %B18 : WORD;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    keyence_iv3_ToolResult_35_Input_Layout : STRUCT
	        Signals_0 AT %B0 : WORD;
	        Signals_1 AT %B2 : WORD;
	        Signals_2 AT %B4 : WORD;
	        Signals_3 AT %B6 : WORD;
	        Signals_4 AT %B8 : WORD;
	        Signals_5 AT %B10 : WORD;
	        Signals_6 AT %B12 : WORD;
	        Signals_7 AT %B14 : WORD;
	        Signals_8 AT %B16 : WORD;
	        Signals_9 AT %B18 : WORD;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    keyence_iv3_ToolResult_36_Input_Layout : STRUCT
	        Signals_0 AT %B0 : WORD;
	        Signals_1 AT %B2 : WORD;
	        Signals_2 AT %B4 : WORD;
	        Signals_3 AT %B6 : WORD;
	        Signals_4 AT %B8 : WORD;
	        Signals_5 AT %B10 : WORD;
	        Signals_6 AT %B12 : WORD;
	        Signals_7 AT %B14 : WORD;
	        Signals_8 AT %B16 : WORD;
	        Signals_9 AT %B18 : WORD;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    keyence_iv3_ToolResult_37_Input_Layout : STRUCT
	        Signals_0 AT %B0 : WORD;
	        Signals_1 AT %B2 : WORD;
	        Signals_2 AT %B4 : WORD;
	        Signals_3 AT %B6 : WORD;
	        Signals_4 AT %B8 : WORD;
	        Signals_5 AT %B10 : WORD;
	        Signals_6 AT %B12 : WORD;
	        Signals_7 AT %B14 : WORD;
	        Signals_8 AT %B16 : WORD;
	        Signals_9 AT %B18 : WORD;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    keyence_iv3_ToolResult_38_Input_Layout : STRUCT
	        Signals_0 AT %B0 : WORD;
	        Signals_1 AT %B2 : WORD;
	        Signals_2 AT %B4 : WORD;
	        Signals_3 AT %B6 : WORD;
	        Signals_4 AT %B8 : WORD;
	        Signals_5 AT %B10 : WORD;
	        Signals_6 AT %B12 : WORD;
	        Signals_7 AT %B14 : WORD;
	        Signals_8 AT %B16 : WORD;
	        Signals_9 AT %B18 : WORD;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    keyence_iv3_ToolResult_39_Input_Layout : STRUCT
	        Signals_0 AT %B0 : WORD;
	        Signals_1 AT %B2 : WORD;
	        Signals_2 AT %B4 : WORD;
	        Signals_3 AT %B6 : WORD;
	        Signals_4 AT %B8 : WORD;
	        Signals_5 AT %B10 : WORD;
	        Signals_6 AT %B12 : WORD;
	        Signals_7 AT %B14 : WORD;
	        Signals_8 AT %B16 : WORD;
	        Signals_9 AT %B18 : WORD;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    keyence_iv3_ToolResult_4_Input_Layout : STRUCT
	        Signals_0 AT %B0 : WORD;
	        Signals_1 AT %B2 : WORD;
	        Signals_2 AT %B4 : WORD;
	        Signals_3 AT %B6 : WORD;
	        Signals_4 AT %B8 : WORD;
	        Signals_5 AT %B10 : WORD;
	        Signals_6 AT %B12 : WORD;
	        Signals_7 AT %B14 : WORD;
	        Signals_8 AT %B16 : WORD;
	        Signals_9 AT %B18 : WORD;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    keyence_iv3_ToolResult_40_Input_Layout : STRUCT
	        Signals_0 AT %B0 : WORD;
	        Signals_1 AT %B2 : WORD;
	        Signals_2 AT %B4 : WORD;
	        Signals_3 AT %B6 : WORD;
	        Signals_4 AT %B8 : WORD;
	        Signals_5 AT %B10 : WORD;
	        Signals_6 AT %B12 : WORD;
	        Signals_7 AT %B14 : WORD;
	        Signals_8 AT %B16 : WORD;
	        Signals_9 AT %B18 : WORD;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    keyence_iv3_ToolResult_41_Input_Layout : STRUCT
	        Signals_0 AT %B0 : WORD;
	        Signals_1 AT %B2 : WORD;
	        Signals_2 AT %B4 : WORD;
	        Signals_3 AT %B6 : WORD;
	        Signals_4 AT %B8 : WORD;
	        Signals_5 AT %B10 : WORD;
	        Signals_6 AT %B12 : WORD;
	        Signals_7 AT %B14 : WORD;
	        Signals_8 AT %B16 : WORD;
	        Signals_9 AT %B18 : WORD;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    keyence_iv3_ToolResult_42_Input_Layout : STRUCT
	        Signals_0 AT %B0 : WORD;
	        Signals_1 AT %B2 : WORD;
	        Signals_2 AT %B4 : WORD;
	        Signals_3 AT %B6 : WORD;
	        Signals_4 AT %B8 : WORD;
	        Signals_5 AT %B10 : WORD;
	        Signals_6 AT %B12 : WORD;
	        Signals_7 AT %B14 : WORD;
	        Signals_8 AT %B16 : WORD;
	        Signals_9 AT %B18 : WORD;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    keyence_iv3_ToolResult_43_Input_Layout : STRUCT
	        Signals_0 AT %B0 : WORD;
	        Signals_1 AT %B2 : WORD;
	        Signals_2 AT %B4 : WORD;
	        Signals_3 AT %B6 : WORD;
	        Signals_4 AT %B8 : WORD;
	        Signals_5 AT %B10 : WORD;
	        Signals_6 AT %B12 : WORD;
	        Signals_7 AT %B14 : WORD;
	        Signals_8 AT %B16 : WORD;
	        Signals_9 AT %B18 : WORD;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    keyence_iv3_ToolResult_44_Input_Layout : STRUCT
	        Signals_0 AT %B0 : WORD;
	        Signals_1 AT %B2 : WORD;
	        Signals_2 AT %B4 : WORD;
	        Signals_3 AT %B6 : WORD;
	        Signals_4 AT %B8 : WORD;
	        Signals_5 AT %B10 : WORD;
	        Signals_6 AT %B12 : WORD;
	        Signals_7 AT %B14 : WORD;
	        Signals_8 AT %B16 : WORD;
	        Signals_9 AT %B18 : WORD;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    keyence_iv3_ToolResult_45_Input_Layout : STRUCT
	        Signals_0 AT %B0 : WORD;
	        Signals_1 AT %B2 : WORD;
	        Signals_2 AT %B4 : WORD;
	        Signals_3 AT %B6 : WORD;
	        Signals_4 AT %B8 : WORD;
	        Signals_5 AT %B10 : WORD;
	        Signals_6 AT %B12 : WORD;
	        Signals_7 AT %B14 : WORD;
	        Signals_8 AT %B16 : WORD;
	        Signals_9 AT %B18 : WORD;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    keyence_iv3_ToolResult_46_Input_Layout : STRUCT
	        Signals_0 AT %B0 : WORD;
	        Signals_1 AT %B2 : WORD;
	        Signals_2 AT %B4 : WORD;
	        Signals_3 AT %B6 : WORD;
	        Signals_4 AT %B8 : WORD;
	        Signals_5 AT %B10 : WORD;
	        Signals_6 AT %B12 : WORD;
	        Signals_7 AT %B14 : WORD;
	        Signals_8 AT %B16 : WORD;
	        Signals_9 AT %B18 : WORD;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    keyence_iv3_ToolResult_47_Input_Layout : STRUCT
	        Signals_0 AT %B0 : WORD;
	        Signals_1 AT %B2 : WORD;
	        Signals_2 AT %B4 : WORD;
	        Signals_3 AT %B6 : WORD;
	        Signals_4 AT %B8 : WORD;
	        Signals_5 AT %B10 : WORD;
	        Signals_6 AT %B12 : WORD;
	        Signals_7 AT %B14 : WORD;
	        Signals_8 AT %B16 : WORD;
	        Signals_9 AT %B18 : WORD;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    keyence_iv3_ToolResult_48_Input_Layout : STRUCT
	        Signals_0 AT %B0 : WORD;
	        Signals_1 AT %B2 : WORD;
	        Signals_2 AT %B4 : WORD;
	        Signals_3 AT %B6 : WORD;
	        Signals_4 AT %B8 : WORD;
	        Signals_5 AT %B10 : WORD;
	        Signals_6 AT %B12 : WORD;
	        Signals_7 AT %B14 : WORD;
	        Signals_8 AT %B16 : WORD;
	        Signals_9 AT %B18 : WORD;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    keyence_iv3_ToolResult_49_Input_Layout : STRUCT
	        Signals_0 AT %B0 : WORD;
	        Signals_1 AT %B2 : WORD;
	        Signals_2 AT %B4 : WORD;
	        Signals_3 AT %B6 : WORD;
	        Signals_4 AT %B8 : WORD;
	        Signals_5 AT %B10 : WORD;
	        Signals_6 AT %B12 : WORD;
	        Signals_7 AT %B14 : WORD;
	        Signals_8 AT %B16 : WORD;
	        Signals_9 AT %B18 : WORD;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    keyence_iv3_ToolResult_5_Input_Layout : STRUCT
	        Signals_0 AT %B0 : WORD;
	        Signals_1 AT %B2 : WORD;
	        Signals_2 AT %B4 : WORD;
	        Signals_3 AT %B6 : WORD;
	        Signals_4 AT %B8 : WORD;
	        Signals_5 AT %B10 : WORD;
	        Signals_6 AT %B12 : WORD;
	        Signals_7 AT %B14 : WORD;
	        Signals_8 AT %B16 : WORD;
	        Signals_9 AT %B18 : WORD;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    keyence_iv3_ToolResult_50_Input_Layout : STRUCT
	        Signals_0 AT %B0 : WORD;
	        Signals_1 AT %B2 : WORD;
	        Signals_2 AT %B4 : WORD;
	        Signals_3 AT %B6 : WORD;
	        Signals_4 AT %B8 : WORD;
	        Signals_5 AT %B10 : WORD;
	        Signals_6 AT %B12 : WORD;
	        Signals_7 AT %B14 : WORD;
	        Signals_8 AT %B16 : WORD;
	        Signals_9 AT %B18 : WORD;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    keyence_iv3_ToolResult_51_Input_Layout : STRUCT
	        Signals_0 AT %B0 : WORD;
	        Signals_1 AT %B2 : WORD;
	        Signals_2 AT %B4 : WORD;
	        Signals_3 AT %B6 : WORD;
	        Signals_4 AT %B8 : WORD;
	        Signals_5 AT %B10 : WORD;
	        Signals_6 AT %B12 : WORD;
	        Signals_7 AT %B14 : WORD;
	        Signals_8 AT %B16 : WORD;
	        Signals_9 AT %B18 : WORD;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    keyence_iv3_ToolResult_52_Input_Layout : STRUCT
	        Signals_0 AT %B0 : WORD;
	        Signals_1 AT %B2 : WORD;
	        Signals_2 AT %B4 : WORD;
	        Signals_3 AT %B6 : WORD;
	        Signals_4 AT %B8 : WORD;
	        Signals_5 AT %B10 : WORD;
	        Signals_6 AT %B12 : WORD;
	        Signals_7 AT %B14 : WORD;
	        Signals_8 AT %B16 : WORD;
	        Signals_9 AT %B18 : WORD;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    keyence_iv3_ToolResult_53_Input_Layout : STRUCT
	        Signals_0 AT %B0 : WORD;
	        Signals_1 AT %B2 : WORD;
	        Signals_2 AT %B4 : WORD;
	        Signals_3 AT %B6 : WORD;
	        Signals_4 AT %B8 : WORD;
	        Signals_5 AT %B10 : WORD;
	        Signals_6 AT %B12 : WORD;
	        Signals_7 AT %B14 : WORD;
	        Signals_8 AT %B16 : WORD;
	        Signals_9 AT %B18 : WORD;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    keyence_iv3_ToolResult_54_Input_Layout : STRUCT
	        Signals_0 AT %B0 : WORD;
	        Signals_1 AT %B2 : WORD;
	        Signals_2 AT %B4 : WORD;
	        Signals_3 AT %B6 : WORD;
	        Signals_4 AT %B8 : WORD;
	        Signals_5 AT %B10 : WORD;
	        Signals_6 AT %B12 : WORD;
	        Signals_7 AT %B14 : WORD;
	        Signals_8 AT %B16 : WORD;
	        Signals_9 AT %B18 : WORD;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    keyence_iv3_ToolResult_55_Input_Layout : STRUCT
	        Signals_0 AT %B0 : WORD;
	        Signals_1 AT %B2 : WORD;
	        Signals_2 AT %B4 : WORD;
	        Signals_3 AT %B6 : WORD;
	        Signals_4 AT %B8 : WORD;
	        Signals_5 AT %B10 : WORD;
	        Signals_6 AT %B12 : WORD;
	        Signals_7 AT %B14 : WORD;
	        Signals_8 AT %B16 : WORD;
	        Signals_9 AT %B18 : WORD;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    keyence_iv3_ToolResult_56_Input_Layout : STRUCT
	        Signals_0 AT %B0 : WORD;
	        Signals_1 AT %B2 : WORD;
	        Signals_2 AT %B4 : WORD;
	        Signals_3 AT %B6 : WORD;
	        Signals_4 AT %B8 : WORD;
	        Signals_5 AT %B10 : WORD;
	        Signals_6 AT %B12 : WORD;
	        Signals_7 AT %B14 : WORD;
	        Signals_8 AT %B16 : WORD;
	        Signals_9 AT %B18 : WORD;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    keyence_iv3_ToolResult_57_Input_Layout : STRUCT
	        Signals_0 AT %B0 : WORD;
	        Signals_1 AT %B2 : WORD;
	        Signals_2 AT %B4 : WORD;
	        Signals_3 AT %B6 : WORD;
	        Signals_4 AT %B8 : WORD;
	        Signals_5 AT %B10 : WORD;
	        Signals_6 AT %B12 : WORD;
	        Signals_7 AT %B14 : WORD;
	        Signals_8 AT %B16 : WORD;
	        Signals_9 AT %B18 : WORD;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    keyence_iv3_ToolResult_58_Input_Layout : STRUCT
	        Signals_0 AT %B0 : WORD;
	        Signals_1 AT %B2 : WORD;
	        Signals_2 AT %B4 : WORD;
	        Signals_3 AT %B6 : WORD;
	        Signals_4 AT %B8 : WORD;
	        Signals_5 AT %B10 : WORD;
	        Signals_6 AT %B12 : WORD;
	        Signals_7 AT %B14 : WORD;
	        Signals_8 AT %B16 : WORD;
	        Signals_9 AT %B18 : WORD;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    keyence_iv3_ToolResult_59_Input_Layout : STRUCT
	        Signals_0 AT %B0 : WORD;
	        Signals_1 AT %B2 : WORD;
	        Signals_2 AT %B4 : WORD;
	        Signals_3 AT %B6 : WORD;
	        Signals_4 AT %B8 : WORD;
	        Signals_5 AT %B10 : WORD;
	        Signals_6 AT %B12 : WORD;
	        Signals_7 AT %B14 : WORD;
	        Signals_8 AT %B16 : WORD;
	        Signals_9 AT %B18 : WORD;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    keyence_iv3_ToolResult_6_Input_Layout : STRUCT
	        Signals_0 AT %B0 : WORD;
	        Signals_1 AT %B2 : WORD;
	        Signals_2 AT %B4 : WORD;
	        Signals_3 AT %B6 : WORD;
	        Signals_4 AT %B8 : WORD;
	        Signals_5 AT %B10 : WORD;
	        Signals_6 AT %B12 : WORD;
	        Signals_7 AT %B14 : WORD;
	        Signals_8 AT %B16 : WORD;
	        Signals_9 AT %B18 : WORD;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    keyence_iv3_ToolResult_60_Input_Layout : STRUCT
	        Signals_0 AT %B0 : WORD;
	        Signals_1 AT %B2 : WORD;
	        Signals_2 AT %B4 : WORD;
	        Signals_3 AT %B6 : WORD;
	        Signals_4 AT %B8 : WORD;
	        Signals_5 AT %B10 : WORD;
	        Signals_6 AT %B12 : WORD;
	        Signals_7 AT %B14 : WORD;
	        Signals_8 AT %B16 : WORD;
	        Signals_9 AT %B18 : WORD;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    keyence_iv3_ToolResult_61_Input_Layout : STRUCT
	        Signals_0 AT %B0 : WORD;
	        Signals_1 AT %B2 : WORD;
	        Signals_2 AT %B4 : WORD;
	        Signals_3 AT %B6 : WORD;
	        Signals_4 AT %B8 : WORD;
	        Signals_5 AT %B10 : WORD;
	        Signals_6 AT %B12 : WORD;
	        Signals_7 AT %B14 : WORD;
	        Signals_8 AT %B16 : WORD;
	        Signals_9 AT %B18 : WORD;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    keyence_iv3_ToolResult_62_Input_Layout : STRUCT
	        Signals_0 AT %B0 : WORD;
	        Signals_1 AT %B2 : WORD;
	        Signals_2 AT %B4 : WORD;
	        Signals_3 AT %B6 : WORD;
	        Signals_4 AT %B8 : WORD;
	        Signals_5 AT %B10 : WORD;
	        Signals_6 AT %B12 : WORD;
	        Signals_7 AT %B14 : WORD;
	        Signals_8 AT %B16 : WORD;
	        Signals_9 AT %B18 : WORD;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    keyence_iv3_ToolResult_63_Input_Layout : STRUCT
	        Signals_0 AT %B0 : WORD;
	        Signals_1 AT %B2 : WORD;
	        Signals_2 AT %B4 : WORD;
	        Signals_3 AT %B6 : WORD;
	        Signals_4 AT %B8 : WORD;
	        Signals_5 AT %B10 : WORD;
	        Signals_6 AT %B12 : WORD;
	        Signals_7 AT %B14 : WORD;
	        Signals_8 AT %B16 : WORD;
	        Signals_9 AT %B18 : WORD;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    keyence_iv3_ToolResult_64_Input_Layout : STRUCT
	        Signals_0 AT %B0 : WORD;
	        Signals_1 AT %B2 : WORD;
	        Signals_2 AT %B4 : WORD;
	        Signals_3 AT %B6 : WORD;
	        Signals_4 AT %B8 : WORD;
	        Signals_5 AT %B10 : WORD;
	        Signals_6 AT %B12 : WORD;
	        Signals_7 AT %B14 : WORD;
	        Signals_8 AT %B16 : WORD;
	        Signals_9 AT %B18 : WORD;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    keyence_iv3_ToolResult_7_Input_Layout : STRUCT
	        Signals_0 AT %B0 : WORD;
	        Signals_1 AT %B2 : WORD;
	        Signals_2 AT %B4 : WORD;
	        Signals_3 AT %B6 : WORD;
	        Signals_4 AT %B8 : WORD;
	        Signals_5 AT %B10 : WORD;
	        Signals_6 AT %B12 : WORD;
	        Signals_7 AT %B14 : WORD;
	        Signals_8 AT %B16 : WORD;
	        Signals_9 AT %B18 : WORD;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    keyence_iv3_ToolResult_8_Input_Layout : STRUCT
	        Signals_0 AT %B0 : WORD;
	        Signals_1 AT %B2 : WORD;
	        Signals_2 AT %B4 : WORD;
	        Signals_3 AT %B6 : WORD;
	        Signals_4 AT %B8 : WORD;
	        Signals_5 AT %B10 : WORD;
	        Signals_6 AT %B12 : WORD;
	        Signals_7 AT %B14 : WORD;
	        Signals_8 AT %B16 : WORD;
	        Signals_9 AT %B18 : WORD;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    keyence_iv3_ToolResult_9_Input_Layout : STRUCT
	        Signals_0 AT %B0 : WORD;
	        Signals_1 AT %B2 : WORD;
	        Signals_2 AT %B4 : WORD;
	        Signals_3 AT %B6 : WORD;
	        Signals_4 AT %B8 : WORD;
	        Signals_5 AT %B10 : WORD;
	        Signals_6 AT %B12 : WORD;
	        Signals_7 AT %B14 : WORD;
	        Signals_8 AT %B16 : WORD;
	        Signals_9 AT %B18 : WORD;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    keyence_sr_1000_BusyStatus_Input_Layout : STRUCT
	        Signals_0 AT %X0.0 : BOOL;
	        Signals_1 AT %X0.1 : BOOL;
	        Signals_2 AT %X0.2 : BOOL;
	        Signals_3 AT %X0.3 : BOOL;
	        Signals_4 AT %X0.4 : BOOL;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    keyence_sr_1000_CompletionClearControl_Output_Layout : STRUCT
	        Signals_0 AT %X0.0 : BOOL;
	        Signals_1 AT %X0.1 : BOOL;
	        Signals_2 AT %X0.2 : BOOL;
	        Signals_3 AT %X0.3 : BOOL;
	        Signals_4 AT %X0.7 : BOOL;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    keyence_sr_1000_CompletionStatus_Input_Layout : STRUCT
	        Signals_0 AT %X0.0 : BOOL;
	        Signals_1 AT %X0.1 : BOOL;
	        Signals_2 AT %X0.2 : BOOL;
	        Signals_3 AT %X0.3 : BOOL;
	        Signals_4 AT %X0.7 : BOOL;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    keyence_sr_1000_ErrorStatus_Input_Layout : STRUCT
	        Signals_0 AT %X0.0 : BOOL;
	        Signals_1 AT %X0.1 : BOOL;
	        Signals_2 AT %X0.2 : BOOL;
	        Signals_3 AT %X0.3 : BOOL;
	        Signals_4 AT %X0.7 : BOOL;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    keyence_sr_1000_HandshakeAndGeneralErrorStatus_Input_Layout : STRUCT
	        Signals_0 AT %X0.0 : BOOL;
	        Signals_1 AT %X0.1 : BOOL;
	        Signals_2 AT %X0.2 : BOOL;
	        Signals_3 AT %X0.6 : BOOL;
	        Signals_4 AT %X0.7 : BOOL;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    keyence_sr_1000_LatchAndErrorClearControl_Output_Layout : STRUCT
	        Signals_0 AT %X0.1 : BOOL;
	        Signals_1 AT %X0.7 : BOOL;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    keyence_sr_1000_MatchingLevelAndTotalEvaluationGradeStatus_Input_Layout : STRUCT
	        Signals_0 AT %B0 : WORD;
	        Signals_1 AT %B2 : WORD;
	        Signals_2 AT %B4 : WORD;
	        Signals_3 AT %B6 : WORD;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    keyence_sr_1000_OperationInstructionControl_Output_Layout : STRUCT
	        Signals_0 AT %X0.0 : BOOL;
	        Signals_1 AT %X0.1 : BOOL;
	        Signals_2 AT %X0.2 : BOOL;
	        Signals_3 AT %X0.3 : BOOL;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    keyence_sr_1000_OperationResultStatus_Input_Layout : STRUCT
	        Signals_0 AT %B0 : WORD;
	        Signals_1 AT %B2 : WORD;
	        Signals_2 AT %B4 : WORD;
	        Signals_3 AT %B6 : WORD;
	        Signals_4 AT %B8 : WORD;
	        Signals_5 AT %B10 : WORD;
	        Signals_6 AT %B12 : WORD;
	        Signals_7 AT %B14 : WORD;
	        Signals_8 AT %B16 : WORD;
	        Signals_9 AT %B18 : WORD;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    keyence_sr_1000_ParameterBank_Output_Layout : STRUCT
	        Signals_0 AT %B0 : WORD;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    keyence_sr_1000_ResultData_128_Input_Layout : STRUCT
	        Signals_0 AT %B0 : WORD;
	        Signals_1 AT %B2 : WORD;
	        Signals_2 AT %B4 : WORD;
	        Signals_3 AT %B6 : WORD;
	        Signals_4 AT %B8 : ARRAY[0..127] OF BYTE;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    keyence_sr_1000_TerminalStatus_Input_Layout : STRUCT
	        Signals_0 AT %X0.0 : BOOL;
	        Signals_1 AT %X0.1 : BOOL;
	        Signals_2 AT %X0.4 : BOOL;
	        Signals_3 AT %X0.5 : BOOL;
	        Signals_4 AT %X0.6 : BOOL;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    keyence_sr_1000_UnstableReadStatus_Input_Layout : STRUCT
	        Signals_0 AT %X0.0 : BOOL;
	        Signals_1 AT %X0.1 : BOOL;
	        Signals_2 AT %X0.2 : BOOL;
	        Signals_3 AT %X0.3 : BOOL;
	        Signals_4 AT %X0.4 : BOOL;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    keyence_sr_1000_UserData_128_Output_Layout : STRUCT
	        Signals_0 AT %B0 : WORD;
	        Signals_1 AT %B2 : ARRAY[0..127] OF BYTE;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    keyence_sr_750_BusyStatus_Input_Layout : STRUCT
	        Signals_0 AT %X0.0 : BOOL;
	        Signals_1 AT %X0.1 : BOOL;
	        Signals_2 AT %X0.2 : BOOL;
	        Signals_3 AT %X0.3 : BOOL;
	        Signals_4 AT %X0.4 : BOOL;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    keyence_sr_750_CompletionClearControl_Output_Layout : STRUCT
	        Signals_0 AT %X0.0 : BOOL;
	        Signals_1 AT %X0.1 : BOOL;
	        Signals_2 AT %X0.2 : BOOL;
	        Signals_3 AT %X0.3 : BOOL;
	        Signals_4 AT %X0.7 : BOOL;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    keyence_sr_750_CompletionStatus_Input_Layout : STRUCT
	        Signals_0 AT %X0.0 : BOOL;
	        Signals_1 AT %X0.1 : BOOL;
	        Signals_2 AT %X0.2 : BOOL;
	        Signals_3 AT %X0.3 : BOOL;
	        Signals_4 AT %X0.7 : BOOL;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    keyence_sr_750_ErrorStatus_Input_Layout : STRUCT
	        Signals_0 AT %X0.0 : BOOL;
	        Signals_1 AT %X0.1 : BOOL;
	        Signals_2 AT %X0.2 : BOOL;
	        Signals_3 AT %X0.3 : BOOL;
	        Signals_4 AT %X0.7 : BOOL;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    keyence_sr_750_HandshakeAndGeneralErrorStatus_Input_Layout : STRUCT
	        Signals_0 AT %X0.0 : BOOL;
	        Signals_1 AT %X0.1 : BOOL;
	        Signals_2 AT %X0.2 : BOOL;
	        Signals_3 AT %X0.6 : BOOL;
	        Signals_4 AT %X0.7 : BOOL;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    keyence_sr_750_LatchAndErrorClearControl_Output_Layout : STRUCT
	        Signals_0 AT %X0.1 : BOOL;
	        Signals_1 AT %X0.7 : BOOL;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    keyence_sr_750_MatchingLevelAndTotalEvaluationGradeStatus_Input_Layout : STRUCT
	        Signals_0 AT %B0 : WORD;
	        Signals_1 AT %B2 : WORD;
	        Signals_2 AT %B4 : WORD;
	        Signals_3 AT %B6 : WORD;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    keyence_sr_750_OperationInstructionControl_Output_Layout : STRUCT
	        Signals_0 AT %X0.0 : BOOL;
	        Signals_1 AT %X0.1 : BOOL;
	        Signals_2 AT %X0.2 : BOOL;
	        Signals_3 AT %X0.3 : BOOL;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    keyence_sr_750_OperationResultStatus_Input_Layout : STRUCT
	        Signals_0 AT %B0 : WORD;
	        Signals_1 AT %B2 : WORD;
	        Signals_2 AT %B4 : WORD;
	        Signals_3 AT %B6 : WORD;
	        Signals_4 AT %B8 : WORD;
	        Signals_5 AT %B10 : WORD;
	        Signals_6 AT %B12 : WORD;
	        Signals_7 AT %B14 : WORD;
	        Signals_8 AT %B16 : WORD;
	        Signals_9 AT %B18 : WORD;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    keyence_sr_750_ParameterBank_Output_Layout : STRUCT
	        Signals_0 AT %B0 : WORD;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    keyence_sr_750_ResultData_128_Input_Layout : STRUCT
	        Signals_0 AT %B0 : WORD;
	        Signals_1 AT %B2 : WORD;
	        Signals_2 AT %B4 : WORD;
	        Signals_3 AT %B6 : WORD;
	        Signals_4 AT %B8 : ARRAY[0..127] OF BYTE;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    keyence_sr_750_TerminalStatus_Input_Layout : STRUCT
	        Signals_0 AT %X0.0 : BOOL;
	        Signals_1 AT %X0.1 : BOOL;
	        Signals_2 AT %X0.4 : BOOL;
	        Signals_3 AT %X0.5 : BOOL;
	        Signals_4 AT %X0.6 : BOOL;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    keyence_sr_750_UnstableReadStatus_Input_Layout : STRUCT
	        Signals_0 AT %X0.0 : BOOL;
	        Signals_1 AT %X0.1 : BOOL;
	        Signals_2 AT %X0.2 : BOOL;
	        Signals_3 AT %X0.3 : BOOL;
	        Signals_4 AT %X0.4 : BOOL;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    keyence_sr_750_UserData_128_Output_Layout : STRUCT
	        Signals_0 AT %B0 : WORD;
	        Signals_1 AT %B2 : ARRAY[0..127] OF BYTE;
	    END_STRUCT;
	END_TYPE
END_NAMESPACE

