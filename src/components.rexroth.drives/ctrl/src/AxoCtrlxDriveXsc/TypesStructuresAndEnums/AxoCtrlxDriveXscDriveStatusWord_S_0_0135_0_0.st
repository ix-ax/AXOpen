NAMESPACE AXOpen.Components.Rexroth.Drives
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Wrap)]}
    {#ix-attr:[Group(GroupLayout.GroupBox)]}
    {#ix-set:AttributeName = "<#DriveStatusWord#>"}
    CLASS AxoCtrlxDriveXscDriveStatusWord_S_0_0135_0_0
        VAR PUBLIC
            {#ix-set:AttributeName = "<#_bit00_Reserve#>"}
            _bit00_Reserve 				:	BOOL;		
            {#ix-set:AttributeName = "<#_bit01_Reserve#>"}
            _bit01_Reserve 				:	BOOL;		
            {#ix-set:AttributeName = "<#_bit02_Reserve#>"}
            _bit02_Reserve 				:	BOOL;		
            {#ix-set:AttributeName = "<#CommandProcessingStatus#>"}
            CommandProcessingStatus		:	BOOL;		//  0 - Drive ignores command value input           |   1 -Drive follows command value input
            {#ix-set:AttributeName = "<#InStandstill#>"}
            InStandstill 				:	BOOL;		//  Drive "Halt" status                             |   1- Act vel < standstill window
            {#ix-set:AttributeName = "<#InReference#>"}
            InReference 				:	BOOL;		//  Drive hommed
            {#ix-set:AttributeName = "<#_bit06_Reserve#>"}
            _bit06_Reserve 				:	BOOL;		
            {#ix-set:AttributeName = "<#HardwareLock#>"}
            HardwareLock                :	BOOL;       //  Hardware lock (E-stop)
            {#ix-set:AttributeName = "<#ActualOperatingModeBit0#>"}
            ActualOperatingModeBit0 	:	BOOL;		//  Actual_operating mode bit 0                     |   000:  Primary operation mode
                                                        //                                                  |   001:  Secondary operation mode 1
            {#ix-set:AttributeName = "<#ActualOperatingModeBit1#>"}
            ActualOperatingModeBit1 	:	BOOL;		//  Actual_operating mode bit 1                     |   010:  Secondary operation mode 2
                                                        //                                                  |   011:  Secondary operation mode 3
                                                        //                                                  |   100:  Secondary operation mode 4
            {#ix-set:AttributeName = "<#ActualOperatingModeBit2#>"}
            ActualOperatingModeBit2 	:	BOOL;		//  Actual_operating mode bit 2                     |   101:  Secondary operation mode 5
                                                        //                                                  |   110:  Secondary operation mode 6
                                                        //                                                  |   111:  Secondary operation mode 7
            {#ix-set:AttributeName = "<#_bit11_Reserve#>"}
            _bit11_Reserve 				:	BOOL;		
            {#ix-set:AttributeName = "<#WarningZKL2#>"}
            WarningZKL2 				:	BOOL;		//  Warning ZKL2
            {#ix-set:AttributeName = "<#DriveErrorZKL1#>"}
            DriveErrorZKL1 				:	BOOL;		//  Drive Error ZKL1
            {#ix-set:AttributeName = "<#ReadyForOperation Bit 0#>"}
            ReadyForOperationBit0       :	BOOL;		//  Ready to operate bit 0 lower significant bit    |   10: Control section and power section ready for op. (Ab)
                                                        //                                                  |   11: In operation, with torque (e.g. AF)   
            {#ix-set:AttributeName = "<#ReadyForOperation Bit 1#>"}
            ReadyForOperationBit1       :	BOOL;		//  Ready to operate bit 1 higher significant bit   |   00: Not ready for power on (e.g., P2)
                                                        //                                                  |   01: Ready for power on (bb)   
        END_VAR    
    END_CLASS
END_NAMESPACE
