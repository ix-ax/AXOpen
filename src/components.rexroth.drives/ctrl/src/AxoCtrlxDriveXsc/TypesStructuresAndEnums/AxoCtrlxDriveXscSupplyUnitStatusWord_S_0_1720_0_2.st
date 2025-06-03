NAMESPACE AXOpen.Components.Rexroth.Drives
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Wrap)]}
    {#ix-attr:[Group(GroupLayout.GroupBox)]}
    {#ix-set:AttributeName = "<#SupplyUnitStatusWord#>"}
    CLASS AxoCtrlxDriveXscSupplyUnitStatusWord_S_0_1720_0_2
        VAR PUBLIC
            {#ix-set:AttributeName = "<#_bit0_Reserve#>"}
            {#ix-attr:[ReadOnly()]}
            _bit0_Reserve 				:	BOOL;		
            {#ix-set:AttributeName = "<#_bit1_Reserve#>"}
            {#ix-attr:[ReadOnly()]}
            _bit1_Reserve 				:	BOOL;		
            {#ix-set:AttributeName = "<#_bit2_Reserve#>"}
            {#ix-attr:[ReadOnly()]}
            _bit2_Reserve 				:	BOOL;		
            {#ix-set:AttributeName = "<#_bit3_Reserve#>"}
            {#ix-attr:[ReadOnly()]}
            _bit3_Reserve 				:	BOOL;		
            {#ix-set:AttributeName = "<#Mains status#>"}
            {#ix-attr:[ReadOnly()]}
            MainsStatus				:	BOOL;		
            {#ix-set:AttributeName = "<#Hardware enable#>"}
            {#ix-attr:[ReadOnly()]}
            HardwareEnable				:	BOOL;
            {#ix-set:AttributeName = "<#Controlling the mains connection#>"}
            {#ix-attr:[ReadOnly()]}
            ControllingTheMainsConnection				:	BOOL;
            {#ix-set:AttributeName = "<#Bb contact#>"}
            {#ix-attr:[ReadOnly()]}
            BbContact				:	BOOL;
            {#ix-set:AttributeName = "<#Feedback of the preselected operation modes bit 0#>"}   //  00: Primary operation mode
            {#ix-attr:[ReadOnly()]}                                                             //  01: Secondary operation mode 1
            PreselectedOPmodesFB_bit0    :	BOOL;                                               //  10: Secondary operation mode 2                                     
            {#ix-set:AttributeName = "<#Feedback of the preselected operation modes bit 1#>"}   //  11: Secondary operation mode 3
            {#ix-attr:[ReadOnly()]}   
            PreselectedOPmodesFB_bit01      :	BOOL;
            {#ix-set:AttributeName = "<#DC bus discharge#>"}
            {#ix-attr:[ReadOnly()]}
            DCbusDischarge  :	BOOL; 
            {#ix-set:AttributeName = "<#Braking resistor#>"}
            {#ix-attr:[ReadOnly()]}
            BrakingResistor  :	BOOL; 
            {#ix-set:AttributeName = "<#Warning#>"}
            {#ix-attr:[ReadOnly()]}
            Warning  :	BOOL; 
            {#ix-set:AttributeName = "<#Error#>"}
            {#ix-attr:[ReadOnly()]}
            Error  :	BOOL; 
            {#ix-set:AttributeName = "<#Ready for enabling#>"}
            {#ix-attr:[ReadOnly()]}
            ReadyForEnabling:	BOOL; 
            {#ix-set:AttributeName = "<#Enabling#>"}
            {#ix-attr:[ReadOnly()]}
            Enabling:	BOOL; 
        END_VAR    
    END_CLASS
END_NAMESPACE
