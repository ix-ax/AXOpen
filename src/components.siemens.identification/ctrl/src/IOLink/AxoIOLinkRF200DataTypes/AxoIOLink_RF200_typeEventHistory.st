NAMESPACE AXOpen.Components.SIEM.Identification
    {S7.extern=ReadWrite}
    CLASS AxoIOLink_RF200_typeEventHistory
        VAR PUBLIC
            lastEvent       :	DWORD   :=  DWORD#16#0; //  Last event
            secondLastEvent :	DWORD   :=  DWORD#16#0; //  Second last event
            thirdLastEvent  :	DWORD   :=  DWORD#16#0; //  Third last event
            fourthLastEvent :	DWORD   :=  DWORD#16#0; //  Fourth last event
            fifthLastEvent  :	DWORD   :=  DWORD#16#0; //  Fifth last event
        END_VAR
    END_CLASS
END_NAMESPACE