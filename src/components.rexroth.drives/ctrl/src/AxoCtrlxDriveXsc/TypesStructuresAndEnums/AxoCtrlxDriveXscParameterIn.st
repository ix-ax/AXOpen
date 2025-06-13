NAMESPACE AXOpen.Components.Rexroth.Drives
    {S7.extern=ReadWrite}
    CLASS AxoCtrlxDriveXscParameterIn
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
            Datalength	:	BYTE;	//Length of  transfer data*)
            FL_0		:	BOOL;	//Length userdata bit 0  
            FL_1		:	BOOL;	//Length userdata bit 1 
            FL_2		:	BOOL;	//Length userdata bit 2
            FL_3		:	BOOL;	//Length userdata bit 3
            ToggleBit	:	BOOL;	//Toggle bit
            LastBit		:	BOOL;	//Last bit
            Failure		:	BOOL;	//Failure while communication
            Reserve		:	BOOL;	//Reserve
            DataWord_0	:	WORD;	//Data WORD 0
            DataWord_1	:	WORD;	//Data word 1
            DataWord_2	:	WORD;	//Data word 2
            DataWord_3	:	WORD;	//Data word 3
        END_VAR    
    END_CLASS
 END_NAMESPACE
