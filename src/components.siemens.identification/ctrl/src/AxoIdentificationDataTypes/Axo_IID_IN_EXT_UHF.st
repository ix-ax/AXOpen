NAMESPACE AXOpen.Components.Siemens.Identification
    {S7.extern=ReadWrite}
    CLASS Axo_IID_IN_EXT_UHF
        VAR PUBLIC
            LEN_ID                  :   BYTE    :=  BYTE#16#0;     //Length of EPC-ID (0-62)
            MEM_BANK                :   BYTE    :=  BYTE#16#3;     //Memory bank address
            PSWD                    :   DWORD   :=  DWORD#16#0;    //Password
            EDIT_BLACKLIST_MODE     :   BYTE    :=  BYTE#16#0;     //Mode for command "edit blacklist"
            INVENTORY_DURATION      :   WORD    :=  WORD#16#0;     //Duration for command "inventory"
            INVENTORY_DUR_UNIT      :   WORD    :=  WORD#16#0;     //Duration unit for command "inventory"
            LOCK_TAG_BANK_ACTION    :   WORD    :=  WORD#16#0;     //Lock-Action for command "lock-tag-bank"
            LOCK_TAG_BANK_MASK      :   WORD    :=  WORD#16#0;     //Lock Mask for command "lock-tag-bank"
        END_VAR
    END_CLASS
END_NAMESPACE