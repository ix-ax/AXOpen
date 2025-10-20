NAMESPACE AXOpen.Components.Abb.Robotics
    TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
        Outputs : STRUCT
	        // Module OmniCore/DO_64_bytes
	        OmniCore_DO_64_bytes_Output AT %B0 : OmniCore_DO_64_bytes_Output_Layout;

	        // Module RobotBasicIO/DO_64_bytes
	        RobotBasicIO_DO_64_bytes_Output AT %B64 : RobotBasicIO_DO_64_bytes_Output_Layout;

        END_STRUCT;
    END_TYPE
END_NAMESPACE

