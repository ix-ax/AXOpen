NAMESPACE AXOpen.Components.SIEM.Identification
    {S7.extern=ReadWrite}
    CLASS AxoIOLink_RF200_typeTagStatus
        VAR PUBLIC
            uid             :	ARRAY[0..7] OF BYTE;	//  Unique identifier of the transponder
            tagName         :	BYTE    :=  BYTE#16#0;  //  Transponder Name
            chipVersion     :	BYTE    :=  BYTE#16#0;  //  Version of the Chip
            memSize         :	WORD    :=  WORD#16#0;  //  Memory size in Bytes
            lockStatus      :	BYTE    :=  BYTE#16#0;  //  Disable blocks on the chip
            memBlockSize    :	BYTE    :=  BYTE#16#0;  //  Size of memory blocks of the chip
            numBlocks       :	BYTE    :=  BYTE#16#0;  //  Number of memory blocks of the chip
        END_VAR
    END_CLASS
END_NAMESPACE