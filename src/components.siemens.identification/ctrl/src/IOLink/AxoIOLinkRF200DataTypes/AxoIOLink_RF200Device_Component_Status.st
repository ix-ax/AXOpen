NAMESPACE AXOpen.Components.SIEM.Identification
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Stack)]}
    CLASS PUBLIC AxoIOLink_RF200Device_Component_Status  EXTENDS AXOpen.Components.Abstractions.AxoComponent_Status
        VAR PUBLIC 
            Antenna_status      :   DWORD   :=  DWORD#16#0;
            ReadTag_status      :   DWORD   :=  DWORD#16#0;
            WriteTag_status     :   DWORD   :=  DWORD#16#0;
        END_VAR 
    END_CLASS    
END_NAMESPACE





