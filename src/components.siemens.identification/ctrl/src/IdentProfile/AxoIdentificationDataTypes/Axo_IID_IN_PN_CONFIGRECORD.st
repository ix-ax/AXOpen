NAMESPACE AXOpen.Components.SIEM.Identification
    {S7.extern=ReadWrite}
    CLASS Axo_IID_IN_PN_CONFIGRECORD
        VAR PUBLIC
            nRW         :   WORD; 
            nNrAr       :   WORD;
            nApi        :   DWORD; 
            nSlot       :   WORD; 
            nSubslot    :   WORD; 
            record      :   Axo_IID_IN_PN_RECORDDATA ;
        END_VAR
    END_CLASS
END_NAMESPACE