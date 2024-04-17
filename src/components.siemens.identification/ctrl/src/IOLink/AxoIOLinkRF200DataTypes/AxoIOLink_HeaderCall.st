NAMESPACE AXOpen.Components.SIEM.Identification
    {S7.extern=ReadWrite}
    CLASS AxoIOLink_HeaderCall
        VAR PUBLIC
            extFunctionNum  :	BYTE    :=  BYTE#16#08;     //  extended function number (fix coded 08h)
            port            :	BYTE    :=  BYTE#16#0;      //  variable port (user interface) 0...255
            fiIndex         :	WORD    :=  WORD#16#FE4A;   //	FI index (fix coded 65098)
        END_VAR
    END_CLASS
END_NAMESPACE