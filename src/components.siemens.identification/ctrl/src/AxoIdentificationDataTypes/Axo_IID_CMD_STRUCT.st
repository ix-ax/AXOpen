NAMESPACE AXOpen.Components.SIEM.Identification
    {S7.extern=ReadWrite}
    CLASS Axo_IID_CMD_STRUCT
        VAR PUBLIC
            CMD			    :   eAxo_IID_COMMANDS;	                    //Command ID
            ATTRIBUTES	    :   BYTE                    :=  BYTE#16#0;	//Subcommands
            OFFSETBUFFER    :   UINT                    :=  UINT#0;     //Offset for receive buffer
            EPCID_UID	    :   ARRAY[1..62] OF BYTE;
            LEN_DATA	    :   WORD                    :=WORD#16#0;	//Length of data
            ADDR_TAG	    :   DWORD                   :=DWORD#16#0;	//physical address on tag
            CONFIG		    :   BYTE                    :=BYTE#16#0;	//Config Mode for Init
            CHAINED		    :   BOOL                    :=FALSE;		//Chained Bit: 1= chained; 0=unchained
            EXT_UHF		    :   Axo_IID_IN_EXT_UHF;	                    //further Atrributes for extended UHF commands
        END_VAR
    END_CLASS
END_NAMESPACE