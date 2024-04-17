NAMESPACE AXOpen.Components.SIEM.Identification
    {S7.extern=ReadWrite}
    CLASS AxoIOLink_RF200_typeParameters
        VAR PUBLIC
            eventMessage    :	BYTE    :=  BYTE#16#0;  //  16#02: Event indication enabled (default), 16#04: No Message
            operatingMode   :	BYTE    :=  BYTE#16#0;  //  16#04: Scan UID (default), 16#08 Scan user data
            readyDelay      :	BYTE    :=  BYTE#16#0;  //  16#02 Turn off (default), 16#04: Turn on additional backup mechanism for
            dataHoldingTime :	BYTE    :=  BYTE#16#0;  //  Minimum time during which the process input data is not changed by the device
            rfParameters    :	BYTE    :=  BYTE#16#0;  //  Setting the RF parameters, 16#02 ISO default, 16#04: special settings
            modulation      :	BYTE    :=  BYTE#16#0;  //  Setting for the modulation strength 16#00 (0%) ... 16#64 (100%) - default 16#16 (22%)
            subcarrier      :	BYTE    :=  BYTE#16#0;  //  Subcarrier, 16#02: Single (default), 16#04: double
            dataTransfer    :	BYTE    :=  BYTE#16#0;  //  Data transmission speed, 16#02: low, 16#04: high (default)
        END_VAR
    END_CLASS
END_NAMESPACE