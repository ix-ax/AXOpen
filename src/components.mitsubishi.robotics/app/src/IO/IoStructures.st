NAMESPACE AXOpen.Components.Mitsubishi.Robotics
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    mitsubishi_tz535_robot_In_Out_64_byte_Input_Layout : STRUCT
	        Signals_0 AT %B0 : ARRAY[0..63] OF BYTE;
	    END_STRUCT;
	END_TYPE
	
	TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
	    mitsubishi_tz535_robot_In_Out_64_byte_Output_Layout : STRUCT
	        Signals_1 AT %B0 : ARRAY[0..63] OF BYTE;
	    END_STRUCT;
	END_TYPE
END_NAMESPACE

