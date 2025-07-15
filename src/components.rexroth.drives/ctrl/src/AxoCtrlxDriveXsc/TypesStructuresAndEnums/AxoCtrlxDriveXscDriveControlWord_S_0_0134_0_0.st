NAMESPACE AXOpen.Components.Rexroth.Drives
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Wrap)]}
    {#ix-attr:[Group(GroupLayout.GroupBox)]}
    {#ix-set:AttributeName = "<#DriveControlWord#>"}
    CLASS AxoCtrlxDriveXscDriveControlWord_S_0_0134_0_0
        VAR PUBLIC
            {#ix-set:AttributeName = "<#_bit00_Reserve#>"}
            _bit00_Reserve 				:	BOOL;		
            {#ix-set:AttributeName = "<#_bit01_Reserve#>"}
            _bit01_Reserve 				:	BOOL;		
            {#ix-set:AttributeName = "<#_bit02_Reserve#>"}
            _bit02_Reserve 				:	BOOL;		
            {#ix-set:AttributeName = "<#_bit03_Reserve#>"}
            _bit03_Reserve 				:	BOOL;		
            {#ix-set:AttributeName = "<#_bit04_Reserve#>"}
            _bit04_Reserve 				:	BOOL;		
            {#ix-set:AttributeName = "<#_bit05_Reserve#>"}
            _bit05_Reserve 				:	BOOL;		
            {#ix-set:AttributeName = "<#_bit06_Reserve#>"}
            _bit06_Reserve 				:	BOOL;		
            {#ix-set:AttributeName = "<#_bit07_Reserve#>"}
            _bit07_Reserve 				:	BOOL;		

            {#ix-set:AttributeName = "<#Command operation mode Bit 0#>"}
            CommandOperationModeBit0 	:	BOOL;		//  Command operation mode bit 0                        |   000:  Primary operation mode
                                                        //                                                      |   001:  Secondary operation mode 1
            {#ix-set:AttributeName = "<#Command operation mode Bit 1#>"}
            CommandOperationModeBit1 	:	BOOL;		//  Command operation mode bit 1                        |   010:  Secondary operation mode 2
                                                        //                                                      |   011:  Secondary operation mode 3
                                                        //                                                      |   100:  Secondary operation mode 4
            {#ix-set:AttributeName = "<#Command operation mode Bit 2#>"}
            CommandOperationModeBit2 	:	BOOL;		//  Command operation mode bit 2                        |   101:  Secondary operation mode 5
                                                        //                                                      |   110:  Secondary operation mode 6
                                                        //                                                      |   111:  Secondary operation mode 7
            {#ix-set:AttributeName = "<#_bit11_Reserve#>"}
            _bit11_Reserve 				:	BOOL;		
            {#ix-set:AttributeName = "<#_bit12_Reserve#>"}
            _bit12_Reserve 				:	BOOL;		
            {#ix-set:AttributeName = "<#Drive Halt#>"}
            DriveHalt 				:	BOOL;		        //  1-0 change: Deceleration of drive while maintaining maximum acceleration (S‑0‑0138 - only possible if bits 14 and 15 = 1)
            {#ix-set:AttributeName = "<#Drive enable#>"}
            DriveEnable 				:	BOOL;		    //  Negative edge: Torque disable without delay (independent of bit 15 or 13)
            {#ix-set:AttributeName = "<#Drive On#>"}
            DriveOn 				:	BOOL;		        //  Negative edge: Best possible deceleration (only possible if bit 14 = 1)
        END_VAR    
    END_CLASS
END_NAMESPACE
