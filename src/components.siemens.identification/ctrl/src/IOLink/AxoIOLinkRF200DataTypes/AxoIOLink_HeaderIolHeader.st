NAMESPACE AXOpen.Components.SIEM.Identification
    {S7.extern=ReadWrite}
    CLASS AxoIOLink_HeaderIolHeader
        VAR PUBLIC
            control         :	BYTE    :=  BYTE#16#0;  //  RD_WR = 0 = read = Control:=0x03 / / RD_WR = 1 = write = Control:=0x02
            indexHighByte   :	BYTE    :=  BYTE#16#0;  //  index of data record 0…32767 (high byte)
            indexLowByte    :	BYTE    :=  BYTE#16#0;  //  index of data record 0…32767 (low byte)
            subindex        :	BYTE    :=  BYTE#16#0;  //  subindex for data record 0...255
        END_VAR
    END_CLASS
END_NAMESPACE