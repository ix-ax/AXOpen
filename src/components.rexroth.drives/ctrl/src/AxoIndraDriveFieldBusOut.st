NAMESPACE AXOpen.Components.Rexroth.Drives
    CLASS AxoIndraDriveFieldBusOut
        (******************* Drive configuration  ***********************
        Master communication; Fieldbus settings:

                Profile type: * free configurable mode*
                    Configuration of realtime channel:
                        realtime input (configured feedback values):	    (9words)										
                                P-0-4078 Fieldbus status WORD               (2bytes)
                                S-0-0051 Position feedback 1 value          (4bytes)
                                S-0-0040 Veloccity feedback value           (4bytes)
                                S-0-0390 Diagnostig message number          (4bytes)
                                S-0-0144 Signal status  word			    (2bytes)
                                S-0-0084 Actual torque/force value          (2bytes)
                        realtime output (configured command values):		(13words)									
                                P-0-4077 Fieldbus control WORD              (2bytes)
                                S-0-0282 Positioning command value          (4bytes)
                                S-0-0259 Positioning velocity value         (4bytes)
                                S-0-0260 Positioning Accelelration          (4bytes)
                                S-0-0359 Positioning Deceleration           (4bytes)
                                S-0-0145 Signal control word                (2bytes)		
                                S-0-0080 Torque/force command value		    (2bytes)
                                S-0-0193 Positioning jerk                   (4bytes)
                General settings:
                        S-0-0027, Configuration list signal control word -> Number 0; Content S-0-0393
                        S-0-0329, Assign list signal control word -> Number 0; Content 2
                        Primary operation mode: Drive controlled positioning, encoder 1 (without axis control word)
                        Secondary operation mode: Torque/force control	
        *)
        VAR PUBLIC
            SetpointAcceptance 				:	BOOL;			//Setpoint acceptance
            OperatingModeSet 				:	BOOL;			//Operating mode set
            DriveToZeroPoint 				:	BOOL;			//Drive to zero point
            AbsoluteRelative 				:	BOOL;			//Position absolute = 0 or relative = 1
            ImmediateBlockChange 			:	BOOL;			//Immediate change
            ErrorDelete 					:	BOOL;			//Clear error
            JogForward 						:	BOOL;			//Jog forward
            JogBackward 					:	BOOL;			//Jog backward
            SetOperatingModeBit0 			:	BOOL;			//Setpoint operating mode_bit0
            SetOperatingModeBit1 			:	BOOL;			//Setpoint operating mode_bit1
            Iposync 						:	BOOL;			//Only in cycl. pos. control
            DriveHalt 						:	BOOL;			//Drive halt
            DriveEnable 					:	BOOL;			//Drive enable
            DriveOn 						:	BOOL;			//Drive on
            S_0_0282_CommandPosition		: 	DWORD;			//Command position		      
            S_0_0259_CommandVelocity		: 	DWORD;          //Command velocity		      
            S_0_0260_CommandAcceleration	: 	DWORD;          //Command acceleration	   
            S_0_0359_CommandDecceleration	: 	DWORD;          //Command decceleration	  
            S_0_0145_SignalControlWord		: 	WORD;           //Signal control word		    
            S_0_0080_TorqueForceCommand     :   WORD;           //Torque/force command value    
            S_0_0193_CommandJerk            :   DWORD;          //Command jerk            
        END_VAR    
    END_CLASS
END_NAMESPACE