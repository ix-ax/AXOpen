NAMESPACE AXOpen.Components.SIEM.Identification
    {S7.extern=ReadWrite}
    CLASS AxoIOLink_RWdata
        VAR PUBLIC
            header  :   AxoIOLink_Header;       //  Header
            data    :   Array[0..231] OF BYTE;  //  Data
        END_VAR
    END_CLASS
END_NAMESPACE