NAMESPACE AXOpen.Components.Rexroth.Drives
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Wrap)]}
    {#ix-attr:[Group(GroupLayout.GroupBox)]}
    {#ix-set:AttributeName = "<#DriveStatusWord#>"}
    CLASS AxoCtrlxDriveXscDriveStatusWord_S_0_0135_0_0
        VAR PUBLIC
            {#ix-set:AttributeName = "<#_bit00_Reserve#>"}
            // {#ix-attr:[ReadOnly()]}
            _bit00_Reserve 				:	BOOL;		
            {#ix-set:AttributeName = "<#_bit01_Reserve#>"}
            // {#ix-attr:[ReadOnly()]}
            _bit01_Reserve 				:	BOOL;		
            {#ix-set:AttributeName = "<#_bit02_Reserve#>"}
            // {#ix-attr:[ReadOnly()]}
            _bit02_Reserve 				:	BOOL;		
            {#ix-set:AttributeName = "<#CommandProcessingStatus#>"}
            // {#ix-attr:[ReadOnly()]}
            CommandProcessingStatus		:	BOOL;		//  0 - Drive ignores command value input           |   1 -Drive follows command value input
            {#ix-set:AttributeName = "<#InStandstill#>"}
            // {#ix-attr:[ReadOnly()]}
            InStandstill 				:	BOOL;		//  Drive "Halt" status                             |   1- Act vel < standstill window
            {#ix-set:AttributeName = "<#InReference#>"}
            // {#ix-attr:[ReadOnly()]}
            InReference 				:	BOOL;		//  Drive hommed
            {#ix-set:AttributeName = "<#_bit06_Reserve#>"}
            // {#ix-attr:[ReadOnly()]}
            _bit06_Reserve 				:	BOOL;		
            {#ix-set:AttributeName = "<#HardwareLock#>"}
            // {#ix-attr:[ReadOnly()]}
            HardwareLock                :	BOOL;       //  Hardware lock (E-stop)
            {#ix-set:AttributeName = "<#ActualOperatingModeBit0#>"}
            // {#ix-attr:[ReadOnly()]}
            ActualOperatingModeBit0 	:	BOOL;		//  Actual_operating mode bit 0                     |   000:  Primary operation mode
                                                        //                                                  |   001:  Secondary operation mode 1
            {#ix-set:AttributeName = "<#ActualOperatingModeBit1#>"}
            // {#ix-attr:[ReadOnly()]}
            ActualOperatingModeBit1 	:	BOOL;		//  Actual_operating mode bit 1                     |   010:  Secondary operation mode 2
                                                        //                                                  |   011:  Secondary operation mode 3
                                                        //                                                  |   100:  Secondary operation mode 4
            {#ix-set:AttributeName = "<#ActualOperatingModeBit2#>"}
            // {#ix-attr:[ReadOnly()]}
            ActualOperatingModeBit2 	:	BOOL;		//  Actual_operating mode bit 2                     |   101:  Secondary operation mode 5
                                                        //                                                  |   110:  Secondary operation mode 6
                                                        //                                                  |   111:  Secondary operation mode 7
            {#ix-set:AttributeName = "<#_bit11_Reserve#>"}
            // {#ix-attr:[ReadOnly()]}
            _bit11_Reserve 				:	BOOL;		
            {#ix-set:AttributeName = "<#WarningZKL2#>"}
            // {#ix-attr:[ReadOnly()]}
            WarningZKL2 				:	BOOL;		//  Warning ZKL2
            {#ix-set:AttributeName = "<#DriveErrorZKL1#>"}
            // {#ix-attr:[ReadOnly()]}
            DriveErrorZKL1 				:	BOOL;		//  Drive Error ZKL1
            {#ix-set:AttributeName = "<#ReadyForOperation Bit 0#>"}
            // {#ix-attr:[ReadOnly()]}
            ReadyForOperationBit0       :	BOOL;		//  Ready to operate bit 0 lower significant bit    |   10: Control section and power section ready for op. (Ab)
                                                        //                                                  |   11: In operation, with torque (e.g. AF)   
            {#ix-set:AttributeName = "<#ReadyForOperation Bit 1#>"}
            // {#ix-attr:[ReadOnly()]}
            ReadyForOperationBit1       :	BOOL;		//  Ready to operate bit 1 higher significant bit   |   00: Not ready for power on (e.g., P2)
                                                        //                                                  |   01: Ready for power on (bb)   
        END_VAR    
    END_CLASS
END_NAMESPACE
