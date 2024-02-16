NAMESPACE AXOpen.Components.Siemens.Identification
    {S7.extern=ReadWrite}
    CLASS Axo_IID_IN_PN_RECORDDATA
        VAR PUBLIC
            nIndex      :   WORD;
            nLen        :   WORD;  
            nTrans      :   WORD; 
            nReserve    :   WORD; 
            buf         :   ARRAY[0..1034] OF BYTE;
        END_VAR
    END_CLASS
END_NAMESPACE