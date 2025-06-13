NAMESPACE AXOpen.Components.Rexroth.Drives
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Wrap)]}
    {#ix-attr:[Group(GroupLayout.GroupBox)]}
    {#ix-set:AttributeName = "<#SupplyUnitStatusWord#>"}
    CLASS AxoCtrlxDriveXscSupplyUnitStatusWord_S_0_1720_0_2
        VAR PUBLIC
            {#ix-set:AttributeName = "<#_bit0_Reserve#>"}
            _bit0_Reserve 				:	BOOL;		
            {#ix-set:AttributeName = "<#_bit1_Reserve#>"}
            _bit1_Reserve 				:	BOOL;		
            {#ix-set:AttributeName = "<#_bit2_Reserve#>"}
            _bit2_Reserve 				:	BOOL;		
            {#ix-set:AttributeName = "<#_bit3_Reserve#>"}
            _bit3_Reserve 				:	BOOL;		
            {#ix-set:AttributeName = "<#Mains status#>"}
            MainsStatus				:	BOOL;		
            {#ix-set:AttributeName = "<#Hardware enable#>"}
            HardwareEnable				:	BOOL;
            {#ix-set:AttributeName = "<#Controlling the mains connection#>"}
            ControllingTheMainsConnection				:	BOOL;
            {#ix-set:AttributeName = "<#Bb contact#>"}
            BbContact				:	BOOL;
            {#ix-set:AttributeName = "<#Feedback of the preselected operation modes bit 0#>"}   //  00: Primary operation mode
            PreselectedOPmodesFB_bit0    :	BOOL;                                               //  10: Secondary operation mode 2                                     
            {#ix-set:AttributeName = "<#Feedback of the preselected operation modes bit 1#>"}   //  11: Secondary operation mode 3
            PreselectedOPmodesFB_bit01      :	BOOL;
            {#ix-set:AttributeName = "<#DC bus discharge#>"}
            DCbusDischarge  :	BOOL; 
            {#ix-set:AttributeName = "<#Braking resistor#>"}
            BrakingResistor  :	BOOL; 
            {#ix-set:AttributeName = "<#Warning#>"}
            Warning  :	BOOL; 
            {#ix-set:AttributeName = "<#Error#>"}
            Error  :	BOOL; 
            {#ix-set:AttributeName = "<#Ready for enabling#>"}
            ReadyForEnabling:	BOOL; 
            {#ix-set:AttributeName = "<#Enabling#>"}
            Enabling:	BOOL; 
        END_VAR    
    END_CLASS
END_NAMESPACE
