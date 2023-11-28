NAMESPACE AXOpen.Components.Festo.Drives
    {S7.extern=ReadWrite}
    CLASS AxoCmmtAsDrive_Parameter_Header
        VAR PUBLIC
            ReqRef      :   BYTE;
            ReqId       :   BYTE;
            AxisNo      :   BYTE;
            NoParam     :   BYTE;
        END_VAR    
    END_CLASS
    {S7.extern=ReadWrite}
    CLASS AxoCmmtAsDrive_Parameter_Address
        VAR PUBLIC
            Attribute   :   BYTE;
            ElemNo      :   BYTE;
            ParaNo      :   INT;
            Index       :   INT;
        END_VAR    
    END_CLASS    
    {S7.extern=ReadWrite}
    CLASS AxoCmmtAsDrive_Parameter_WR_Data
        VAR PUBLIC
            Attribute   :   BYTE;
            NoElements  :   BYTE;
            PNU         :   INT;
            Subindex    :   INT;
            Value       :   ARRAY[0..9] OF BYTE;
        END_VAR    
    END_CLASS
    {S7.extern=ReadWrite}
    CLASS AxoCmmtAsDrive_Parameter_RD_Data
        VAR PUBLIC
            Format      :   BYTE;
            NoValues    :   BYTE;
            Values      :   ARRAY[0..7] OF BYTE;
        END_VAR    
    END_CLASS
    {S7.extern=ReadWrite}
    CLASS AxoCmmtAsDrive_RW_Param
        VAR PUBLIC
            ReqHeader   :   AxoCmmtAsDrive_Parameter_Header;
            ParaAdress  :   AxoCmmtAsDrive_Parameter_Address;
        END_VAR    
    END_CLASS
    {S7.extern=ReadWrite}
    CLASS AxoCmmtAsDrive_WR_Param
        VAR PUBLIC
            ReqHeader   :   AxoCmmtAsDrive_Parameter_Header;
            Data        :   AxoCmmtAsDrive_Parameter_WR_Data;
        END_VAR    
    END_CLASS
    {S7.extern=ReadWrite}
    CLASS AxoCmmtAsDrive_RD_Param
        VAR PUBLIC
            RespHeader  :   AxoCmmtAsDrive_Parameter_Header;
            Data        :   AxoCmmtAsDrive_Parameter_RD_Data;
        END_VAR    
    END_CLASS


END_NAMESPACE
