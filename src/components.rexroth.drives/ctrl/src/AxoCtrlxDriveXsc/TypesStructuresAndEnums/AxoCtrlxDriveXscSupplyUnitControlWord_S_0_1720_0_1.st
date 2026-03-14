NAMESPACE AXOpen.Components.Rexroth.Drives
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Wrap)]}
    {#ix-attr:[Group(GroupLayout.GroupBox)]}
    {#ix-set:AttributeName = "<#SupplyUnitControlWord#>"}
    CLASS AxoCtrlxDriveXscSupplyUnitControlWord_S_0_1720_0_1
        VAR PUBLIC
            {#ix-set:AttributeName = "<#_bit0_Reserve#>"}
            _bit0_Reserve 				:	BOOL;		
            {#ix-set:AttributeName = "<#_bit1_Reserve#>"}
            _bit1_Reserve 				:	BOOL;		
            {#ix-set:AttributeName = "<#_bit2_Reserve#>"}
            _bit2_Reserve 				:	BOOL;		
            {#ix-set:AttributeName = "<#_bit3_Reserve#>"}
            _bit3_Reserve 				:	BOOL;	
            {#ix-set:AttributeName = "<#_bit4_Reserve#>"}
            _bit4_Reserve 				:	BOOL;		
            {#ix-set:AttributeName = "<#_bit4_Reserve#>"}
            _bit5_Reserve 				:	BOOL;		
            {#ix-set:AttributeName = "<#_bit6_Reserve#>"}
            _bit6_Reserve 				:	BOOL;		
            {#ix-set:AttributeName = "<#_bit7_Reserve#>"}
            _bit7_Reserve 				:	BOOL;	
            {#ix-set:AttributeName = "<#Mode selection bit 0#>"}
            ModeSelectionBit0 	:	BOOL;		                    //  Mode selection bit 0                                |   00:  Primary operation mode
                                                                    //                                                      |   01:  1 secondary operation mode
            {#ix-set:AttributeName = "<#Mode selection bit 1#>"}
            ModeSelectionBit1 	:	BOOL;		                    //  Command operation mode bit 1                        |   10:  2 secondary operation mode
                                                                    //                                                      |   11:  3 secondary operation mode
            {#ix-set:AttributeName = "<#DC bus discharge#>"}
            DCbusDischarge  :   BOOL;                               //  0: DC bus discharge not active
                                                                    //  1: Start DC bus discharge function
            {#ix-set:AttributeName = "<#_bit11_Reserve#>"}
            _bit11_Reserve 				:	BOOL;	
            {#ix-set:AttributeName = "<#Controlling the ready for operation relay#>"}
            ControllingTheReadyForOperationRelay    :	BOOL;       //  0: Open contact
                                                                    //  1: Close contact, release
            {#ix-set:AttributeName = "<#_bit13_Reserve#>"}
            _bit13_Reserve 				:	BOOL;	
            {#ix-set:AttributeName = "<#Controlling DC bus charging and mains contactor#>"}
            ControllingDCbusChargingAndMainsContactor   :	BOOL;   //  0: Mains disconnection e.g. by opening the mains contactor or by locking the mains thyristors
                                                                    //  1: Charge DC bus by closing the mains contactor or by activating the mains thyristors - device goes into rectifier mode            
            {#ix-set:AttributeName = "<#Enabling#>"}
            Enabling:	BOOL;                                       //  0: Disabled, command operation mode not active
                                                                    //  1: Enabled, command operation mode active
        END_VAR    
    END_CLASS
END_NAMESPACE
