NAMESPACE AXOpen.Components.Siemens.Identification

// TYPE ST_IID_IN_PN_CONFIGRECORD :
//     STRUCT
    CLASS Axo_IID_IN_PN_CONFIGRECORD
        VAR PUBLIC
            nRW         :   WORD; 
            nNrAr       :   WORD;
            nApi        :   DWORD; 
            nSlot       :   WORD; 
            nSubslot    :   WORD; 
            record      :   Axo_IID_IN_PN_RECORDDATA ;
//     END_STRUCT
// END_TYPE
    END_VAR
    END_CLASS
END_NAMESPACE