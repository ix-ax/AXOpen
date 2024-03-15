NAMESPACE AXOpen.Components.SIEM.Identification
    {S7.extern=ReadWrite}
    CLASS AxoIOLink_typeDiagnostics
        VAR PUBLIC
            status              :	WORD    :=  WORD#16#0;  //  Status of the Block or error identification when error occurred
            subfunctionStatus   :	DWORD   :=  DWORD#16#0; //  Status or return value of called FB's, FCs and system blocks
            stateNumber         :	DINT    :=  DINT#0;     //  State in the state machine of the block where the error occurred
        END_VAR
    END_CLASS
END_NAMESPACE