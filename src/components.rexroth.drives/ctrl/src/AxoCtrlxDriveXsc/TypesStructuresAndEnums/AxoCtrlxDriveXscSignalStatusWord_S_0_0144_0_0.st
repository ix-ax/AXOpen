NAMESPACE AXOpen.Components.Rexroth.Drives
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Wrap)]}
    {#ix-attr:[Group(GroupLayout.GroupBox)]}
    {#ix-set:AttributeName = "<#SignalStatusWord#>"}
    CLASS AxoCtrlxDriveXscSignalStatusWord_S_0_0144_0_0
        VAR PUBLIC
            {#ix-set:AttributeName = "<#Configuration/Parametrization/Operation bit 0#>"}
            CmPmOmBit0 				:	BOOL;		//  Bit 0 of the Subdevice STM: Status, parameterization mode (S-0-0424)  !!! must be set in drive !!!		
            {#ix-set:AttributeName = "<#Configuration/Parametrization/Operation bit 1#>"}
            CmPmOmBit1 				:	BOOL;		//  Bit 1 of the Subdevice STM: Status, parameterization mode (S-0-0424)  !!! must be set in drive !!!		
            {#ix-set:AttributeName = "<#In target position#>"}
            InTargetPosition 				:	BOOL;		//  Bit 2 of the Positioning status: Word (S-0-0437)  !!! must be set in drive !!!		
            {#ix-set:AttributeName = "<#Position command acknowledgment#>"}
            PositionCommandAck 				:	BOOL;		//  Bit 0 of the Drive-controlled positioning: Command acknowledgment (S-0-0419)  !!! must be set in drive !!!		
            {#ix-set:AttributeName = "<#Drive standstill#>"}
            DriveStandstill 				:	BOOL;		//  Bit 0 of the Velocity status: Actual value = 0 (S-0-0331)  !!! must be set in drive !!!		
            {#ix-set:AttributeName = "<#Command change bit#>"}
            CommandChangeBit 				:	BOOL;		//  Bit 5 of the Axis state machine: Status word, axis (P-0-0115 )  !!! must be set in drive !!!		
            {#ix-set:AttributeName = "<#_bit6_Reserve#>"}
            _bit6_Reserve 				:	BOOL;		
            {#ix-set:AttributeName = "<#_bit7_Reserve#>"}
            _bit7_Reserve 				:	BOOL;		
            {#ix-set:AttributeName = "<#Locked by hardware#>"}
            LockedByHardware            :	BOOL;		    //  Bit 7 of the Axis state machine: Status word 2, axis (P-0-0110 )  !!! must be set in drive !!!
            {#ix-set:AttributeName = "<#_bit9_Reserve#>"}
            _bit9_Reserve 				:	BOOL;		
            {#ix-set:AttributeName = "<#_bit10_Reserve#>"}
            _bit10_Reserve 				:	BOOL;		
            {#ix-set:AttributeName = "<#_bit11_Reserve#>"}
            _bit11_Reserve 				:	BOOL;		
            {#ix-set:AttributeName = "<#_bit12_Reserve#>"}
            _bit12_Reserve 				:	BOOL;		
            {#ix-set:AttributeName = "<#_bit13_Reserve#>"}
            _bit13_Reserve 				:	BOOL;		
            {#ix-set:AttributeName = "<#_bit14_Reserve#>"}
            _bit14_Reserve 				:	BOOL;		
            {#ix-set:AttributeName = "<#_bit15_Reserve#>"}
            _bit15_Reserve 				:	BOOL;		
        END_VAR    
    END_CLASS
END_NAMESPACE
