NAMESPACE AXOpen.Components.SIEM.Identification
    {S7.extern=ReadWrite}
    CLASS AxoIOLink_Header
        VAR PUBLIC
            call        :   AxoIOLink_HeaderCall;       //  header for read/write data record
            iolHeader   :   AxoIOLink_HeaderIolHeader;  //  header for IO-Link
        END_VAR
    END_CLASS
END_NAMESPACE