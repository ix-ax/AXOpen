NAMESPACE AXOpen.Components.Ur.Robotics
    TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
        Inputs : STRUCT
	        // Module ureol2l/1_T2O_State
	        ureol2l_1_T2O_State_Input AT %B448 : ureol2l_1_T2O_State_Input_Layout;

	        // Module ureol2l/2_T2O_IO
	        ureol2l_2_T2O_IO_Input AT %B380 : ureol2l_2_T2O_IO_Input_Layout;

	        // Module ureol2l/3_T2O_Joints
	        ureol2l_3_T2O_Joints_Input AT %B276 : ureol2l_3_T2O_Joints_Input_Layout;

	        // Module ureol2l/4_T2O_TCP
	        ureol2l_4_T2O_TCP_Input AT %B200 : ureol2l_4_T2O_TCP_Input_Layout;

	        // Module ureol2l/5_T2O_General_Purpose_Bit_Registers
	        ureol2l_5_T2O_General_Purpose_Bit_Registers_Input AT %B192 : ureol2l_5_T2O_General_Purpose_Bit_Registers_Input_Layout;

	        // Module ureol2l/6_T2O_General_Purpose_Int_Registers
	        ureol2l_6_T2O_General_Purpose_Int_Registers_Input AT %B96 : ureol2l_6_T2O_General_Purpose_Int_Registers_Input_Layout;

	        // Module ureol2l/7_T2O_General_Purpose_Float_Registers
	        ureol2l_7_T2O_General_Purpose_Float_Registers_Input AT %B0 : ureol2l_7_T2O_General_Purpose_Float_Registers_Input_Layout;

        END_STRUCT;
    END_TYPE
END_NAMESPACE

