NAMESPACE AXOpen.Components.Siemens.Identification
    TYPE PUBLIC
        eAxo_IID_COMMANDS   :   WORD
        (		
            eNoCommand		:=  WORD#16#00,
            eRead 			:=  WORD#16#70,
            eWrite			:=  WORD#16#71,
            eReaderStatus 	:=  WORD#16#74, 
            eTagStatus 		:=  WORD#16#73,
            eInventory 		:=  WORD#16#69,
            eFormat 		:=  WORD#16#66, 
            ePut 			:=  WORD#16#65,
            eWriteID 		:=  WORD#16#67,
            eKillTag 		:=  WORD#16#6A,
            eLockTagBank 	:=  WORD#16#79,
            eEditBlacklist 	:=  WORD#16#7A,
            eGetBlacklist	:=  WORD#16#6C,
            eReadConfig 	:=  WORD#16#61,
            eWriteConfig 	:=  WORD#16#78
        );
    END_TYPE
END_NAMESPACE