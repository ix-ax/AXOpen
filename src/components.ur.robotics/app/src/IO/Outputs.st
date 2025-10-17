NAMESPACE AXOpen.Components.Ur.Robotics
    TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
        Outputs : STRUCT
	        // Module ureol2l/10_O2T_General_Purpose_Registers_2
	        ureol2l_10_O2T_General_Purpose_Registers_2_Output AT %B0 : ureol2l_10_O2T_General_Purpose_Registers_2_Output_Layout;

	        // Module ureol2l/8_O2T_Robot_IO
	        ureol2l_8_O2T_Robot_IO_Output AT %B200 : ureol2l_8_O2T_Robot_IO_Output_Layout;

	        // Module ureol2l/9_O2T_General_Purpose_Registers_1
	        ureol2l_9_O2T_General_Purpose_Registers_1_Output AT %B100 : ureol2l_9_O2T_General_Purpose_Registers_1_Output_Layout;

        END_STRUCT;
    END_TYPE
END_NAMESPACE

