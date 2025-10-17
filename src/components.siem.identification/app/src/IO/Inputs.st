NAMESPACE AXOpen.Components.Siem.Identification
    TYPE
        {S7.extern=ReadWrite}
        {#ix-attr:[Container(Layout.Wrap)]}
        Inputs : STRUCT
	        // Module et200sp_CM_4xIO_Link_RF200/CM_4xIO-Link_V2_2_144I_128O_1
	        et200sp_CM_4xIO_Link_RF200_CM_4xIO_Link_V2_2_144I_128O_1_Input AT %B162 : et200sp_CM_4xIO_Link_RF200_CM_4xIO_Link_V2_2_144I_128O_1_Input_Layout;

	        // Module rf186c/CM_1
	        rf186c_CM_1_Input AT %B308 : rf186c_CM_1_Input_Layout;

	        // Module rf186c_cyc/CM
	        rf186c_cyc_CM_Input AT %B160 : rf186c_cyc_CM_Input_Layout;

	        // Module rf186c_cyc/RF260R_1
	        rf186c_cyc_RF260R_1_Input AT %B128 : rf186c_cyc_RF260R_1_Input_Layout;

	        // Module rf186c_cyc/RF340R_1
	        rf186c_cyc_RF340R_1_Input AT %B0 : rf186c_cyc_RF340R_1_Input_Layout;

	        // Module rf186c/Reader_1
	        rf186c_Reader_1_Input AT %B306 : rf186c_Reader_1_Input_Layout;

        END_STRUCT;
    END_TYPE
END_NAMESPACE

