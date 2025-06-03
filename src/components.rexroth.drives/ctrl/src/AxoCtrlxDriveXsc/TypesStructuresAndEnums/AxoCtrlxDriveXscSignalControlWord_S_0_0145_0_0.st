NAMESPACE AXOpen.Components.Rexroth.Drives
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Wrap)]}
    {#ix-attr:[Group(GroupLayout.GroupBox)]}
    {#ix-set:AttributeName = "<#SignalControlWord#>"}
    CLASS AxoCtrlxDriveXscSignalControlWord_S_0_0145_0_0
        VAR PUBLIC
            {#ix-set:AttributeName = "<#Acceptance of positioning command value#>"}
            AcceptanceOfPositioningCommandValue:	BOOL;		                                    //  Bit 0 of the Drive-controlled positioning: Control word (S-0-0346) !!! must be set in drive !!!		
            {#ix-set:AttributeName = "<#Command value reference when operation mode activated#>"}
            CommandValueReferenceWhenOperationModeActivated 				:	BOOL;		        //  Bit 2 of the Positioning profile: Command value mode (S-0-0393) !!! must be set in drive !!!		
            {#ix-set:AttributeName = "<#Homing control#>"}
            HomingControl 				:	BOOL;		                                            //  Bit 0 of the Homing control: C0600 Command drive-controlled procedure (S-0-0148) !!! must be set in drive !!!		
            {#ix-set:AttributeName = "<#Absolute/Relative type of positioning command value#>"}
            AbsoluteRelative 				:	BOOL;				                                //  Bit 3 of the Drive-controlled positioning: Control word (S-0-0346) !!! must be set in drive !!!		
            {#ix-set:AttributeName = "<#Immediate block change#>"}
            ImmediateChange 				:	BOOL;                                               //  Bit 5 of the Drive-controlled positioning: Control word (S-0-0346) !!! must be set in drive !!!				
            {#ix-set:AttributeName = "<#Clear error#>"}
            ClearError  :	BOOL;                                                                   //  Bit 0 of the Class 1 diagnostics: C0500 Reset command (S-0-0099) !!! must be set in drive !!!				
            {#ix-set:AttributeName = "<#Infinite travel in positive direction (jog+)#>"}
            JogPositive :	BOOL;                                                                   //  Bit 1 of the Drive-controlled positioning: Control word (S-0-0346) !!! must be set in drive !!!				
            {#ix-set:AttributeName = "<#Infinite travel in negative direction (jog-)#>"}
            JogNegative :	BOOL;                                                                   //  Bit 2 of the Drive-controlled positioning: Control word (S-0-0346) !!! must be set in drive !!!				
            {#ix-set:AttributeName = "<#Activate configuration mode#>"}
            SwitchToCM  :	BOOL;                                                                   //  Bit 0 of the Subdevice STM: C0400 Activate configuration mode (S-0-0420) !!! must be set in drive !!!				
            {#ix-set:AttributeName = "<#Activate operation mode#>"}
            SwitchTo0M  :	BOOL;                                                                   //  Bit 0 of the Subdevice STM: C0200 Activate operation mode (S-0-0422) !!! must be set in drive !!!				
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
            {#ix-set:AttributeName = "<#Set absolute position function#>"}
            SetAbsPositionFunction  :	BOOL;                                                       //  Bit 0 of the Set absolute position function: C0300 Command procedure (S-0-0447) !!! must be set in drive !!!				
        END_VAR    
    END_CLASS
END_NAMESPACE
