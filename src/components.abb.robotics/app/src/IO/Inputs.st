NAMESPACE AXOpen.Components.Abb.Robotics
    TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
        Inputs : STRUCT
	        // Module abb_irc5_robot/DI_64_bytes
	        abb_irc5_robot_DI_64_bytes_Input AT %B64 : abb_irc5_robot_DI_64_bytes_Input_Layout;

	        // Module abb_omnicore_robot/DI_64_bytes
	        abb_omnicore_robot_DI_64_bytes_Input AT %B0 : abb_omnicore_robot_DI_64_bytes_Input_Layout;

        END_STRUCT;
    END_TYPE
END_NAMESPACE

