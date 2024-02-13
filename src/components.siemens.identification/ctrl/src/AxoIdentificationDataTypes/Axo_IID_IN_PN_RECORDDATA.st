NAMESPACE AXOpen.Components.Siemens.Identification

// TYPE ST_IID_IN_PN_RECORDDATA :
//     STRUCT
    CLASS Axo_IID_IN_PN_RECORDDATA
        VAR PUBLIC
            nIndex      :   WORD;
            nLen        :   WORD;  
            nTrans      :   WORD; 
            nReserve    :   WORD; 
            buf         :   ARRAY[0..1034] OF BYTE;
//     END_STRUCT
// END_TYPE
    END_VAR
    END_CLASS
END_NAMESPACE