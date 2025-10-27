NAMESPACE AXOpen.Components.Abb.Robotics
    TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
        Inputs : STRUCT
	        // Module OmniCore/DI_64_bytes
	        OmniCore_DI_64_bytes_Input AT %B0 : OmniCore_DI_64_bytes_Input_Layout;

	        // Module RobotBasicIO/DI_64_bytes
	        RobotBasicIO_DI_64_bytes_Input AT %B64 : RobotBasicIO_DI_64_bytes_Input_Layout;

        END_STRUCT;
    END_TYPE
END_NAMESPACE

