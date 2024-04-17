NAMESPACE AXOpen.Components.SIEM.Identification
    {S7.extern=ReadWrite}
    CLASS AxoIOLink_RF200_typeUIDHistory
        VAR PUBLIC
            lastUID1        :  	DWORD   :=	DWORD#16#0; //  Last UID
            lastUID2        :  	DWORD   :=	DWORD#16#0; //  Last UID
            secondLastUID1  :	DWORD   :=	DWORD#16#0; //  Second last UID
            secondLastUID2  :	DWORD   :=	DWORD#16#0; //  Second last UID
            thirdLastUID1   :	DWORD   :=	DWORD#16#0; //  Third last UID
            thirdLastUID2   :	DWORD   :=	DWORD#16#0; //  Third last UID
            fourthLastUID1  :	DWORD   :=	DWORD#16#0; //  Fourth last UID
            fourthLastUID2  :	DWORD   :=	DWORD#16#0; //  Fourth last UID
            fifthLastUID1   :	DWORD   :=	DWORD#16#0; //  Fifth last UID
            fifthLastUID2   :	DWORD   :=	DWORD#16#0; //  Fifth last UID
        END_VAR
    END_CLASS
END_NAMESPACE