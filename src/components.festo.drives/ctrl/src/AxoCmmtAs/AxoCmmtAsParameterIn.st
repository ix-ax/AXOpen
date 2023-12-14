NAMESPACE AXOpen.Components.Festo.Drives
    {S7.extern=ReadWrite}
    CLASS AxoCmmtAsParameterIn
        (******************* IndraDrive configuration  ***********************
        Master communication; Fieldbus settings:
        Parameter chanel 10Bytes / 5 Words I/O
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
