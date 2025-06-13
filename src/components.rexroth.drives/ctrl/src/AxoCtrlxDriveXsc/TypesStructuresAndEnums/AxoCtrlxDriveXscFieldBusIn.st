NAMESPACE AXOpen.Components.Rexroth.Drives
    {S7.extern=ReadWrite}
    CLASS AxoCtrlxDriveXscFieldBusIn
        (******************* Drive configuration  ***********************
        Master communication; Fieldbus settings:
                Parameter channel 10Bytes / 5 Words I/O
                Parameter channel: F-Modul not used
                Realtime Input channel 18Bytes / 9 Words I/O
                Realtime Output channel 26Bytes / 13 Words I/O
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
            //  “FSP-Drive” (S-0-0135)
            // ReadyForOperationBit1       :	BOOL;		//  Ready to operate bit 1 higher significant bit   |   00: Not ready for power on (e.g., P2)
            //                                             //                                                  |   01: Ready for power on (bb)   
            // ReadyForOperationBit0       :	BOOL;		//  Ready to operate bit 0 lower significant bit    |   10: Control section and power section ready for op. (Ab)
            //                                             //                                                  |   11: In operation, with torque (e.g. AF)   

            // DriveErrorZKL1 				:	BOOL;		//  Drive Error ZKL1
            // WarningZKL2 				:	BOOL;		//  Warning ZKL2
            // _bit11_Reserve 				:	BOOL;		
            // ActualOperatingModeBit2 	:	BOOL;		//  Actual_operating mode bit 2                     |   111:  Secondary operation mode 7
            //                                             //                                                  |   110:  Secondary operation mode 6
            //                                             //                                                  |   101:  Secondary operation mode 5
            // ActualOperatingModeBit1 	:	BOOL;		//  Actual_operating mode bit 1                     |   100:  Secondary operation mode 4
            //                                             //                                                  |   011:  Secondary operation mode 3
            //                                             //                                                  |   010:  Secondary operation mode 2
            // ActualOperatingModeBit0 	:	BOOL;		//  Actual_operating mode bit 0                     |   001:  Secondary operation mode 1
            //                                             //                                                  |   000:  Primary operation mode
            // HardwareLock                :	BOOL;       //  Hardware lock (E-stop)
            // _bit06_Reserve 				:	BOOL;		
            // InReference 				:	BOOL;		//  Drive hommed
            // InStandstill 				:	BOOL;		//  Drive "Halt" status                             |   1- Act vel < standstill window
            // CommandProcessingStatus		:	BOOL;		//  0 - Drive ignores command value input           |   1 -Drive follows command value input
            // _bit02_Reserve 				:	BOOL;		
            // _bit01_Reserve 				:	BOOL;		
            // _bit00_Reserve 				:	BOOL;		

            PhaseAcknowledgeBit0		:	BOOL;		//Operating mode acknowledge bit 0
            PhaseAcknowledgeBit1 		:	BOOL;		//Operating mode acknowledge bit 1
            InReference 				:	BOOL;		//In reference
            InStandstill 				:	BOOL;		//In standstill
            SetpointReached				:	BOOL;		//Setpoint reached
            CommandChangeBit 			:	BOOL;		//Command change bit
            OperatingModeError 			:	BOOL;		//Operating mode_error
            StatusSetpointProcess 		:	BOOL;		//Status setpoint processing
            ActualOperatingModeBit0 	:	BOOL;		//Actual_operating mode bit 0
            ActualOperatingModeBit1 	:	BOOL;		//Actual_operating mode bit 1
            SetpointAcknowledge 		:	BOOL;		//Setpoint acknowledge
            MessageZKL3 				:	BOOL;		//Message ZKL3
            WarningZKL2 				:	BOOL;		//Warning ZKL2
            DriveErrorZKL1 				:	BOOL;		//Drive Error ZKL1
            ReadyToOperateBit0 			:	BOOL;		//Ready to operate bit 0 lower significant bit
            ReadyToOperateBit1 			:	BOOL;		//Ready to operate bit 1 higher significant bit

            S_0_0051_ActualPosition		:	DWORD;		//Actual position
            S_0_0040_ActualVelocity		:	DWORD;		//Actual velocity
            S_0_0390_Diagnosis			:	DWORD;		//Diagnosis
            S_0_0144_SignalStatusWord	:	WORD;		//Signal status word
            S_0_0084_ActualTorque 		:	WORD;		//Actual torque
        END_VAR    
    END_CLASS

END_NAMESPACE
