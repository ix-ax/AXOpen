NAMESPACE AXOpen.Components.Abb.Robotics
    TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
        Outputs : STRUCT
	        // Module abb_irc5_robot/DO_64_bytes
	        abb_irc5_robot_DO_64_bytes_Output AT %B64 : abb_irc5_robot_DO_64_bytes_Output_Layout;

	        // Module abb_omnicore_robot/DO_64_bytes
	        abb_omnicore_robot_DO_64_bytes_Output AT %B0 : abb_omnicore_robot_DO_64_bytes_Output_Layout;

        END_STRUCT;
    END_TYPE
END_NAMESPACE

