NAMESPACE AXOpen.Components.Rexroth.Drives
    CLASS AxoIndraDriveParameterOut
        (******************* IndraDrive configuration  ***********************
        Master communication; Fieldbus settings:
        Parameter chanel 10Bytes / 5 Words I/O
        *)
        VAR PUBLIC
            Datalength		:	BYTE := BYTE#04;//Length of transfer data
            FL_0			:	BOOL;			//Length userdata bit 0 
            FL_1			:	BOOL;			//Length userdata bit 1
            FL_2			:	BOOL;			//Length userdata bit 2 
            FL_3			:	BOOL;			//Length userdata bit 3
            ToggleBit		:	BOOL;			//Toggle bit
            LastBit			:	BOOL;			//Last bit
            Initalisation	:	BOOL := TRUE;	//Initialisation
            Reserve			:	BOOL;			//Reserve
            Index			:	WORD;			//Index number
            Subindex		:	BYTE;			//Subindex number
            Axis			:	BYTE;			//Axis number
            DataWord_0		:	WORD;			//Data word 0
            DataWord_1		:	WORD;			//Data word 1
        END_VAR    
    END_CLASS    
END_NAMESPACE