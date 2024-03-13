NAMESPACE AXOpen.Components.SIEM.Identification
    {S7.extern=ReadWrite}
    CLASS AxoIOLink_typeParameterPage0
        VAR PUBLIC
            masterCommand       :	BYTE    :=  BYTE#16#00; // Switch the IO-Link operation mode (Fallback, Operate, Preoperate)
            masterCycleTime     :	BYTE    :=  BYTE#16#00; // Master Cycle Time
            minCycleTime        :	BYTE    :=  BYTE#16#00; // Minimum Device Cycle Time
            frameCapability     :	BYTE    :=  BYTE#16#00; // Supported frame types for communication
            ioLinkRevisionID    :	BYTE    :=  BYTE#16#00; // IO-Link protocol version implemented on the device
            processDataIn       :	BYTE    :=  BYTE#16#00; // Number and structure of the data process image of the inputs to the master
            processDataOut      :	BYTE    :=  BYTE#16#00; // Number and structure of the data process image of the outputs to the master
            vendorID1           :	BYTE    :=  BYTE#16#00; // Unique vendor identification number
            vendorID2           :	BYTE    :=  BYTE#16#00; // Siemens:0x002A
            deviceID1           :	BYTE    :=  BYTE#16#00; // Unique device identification number
            deviceID2           :	BYTE    :=  BYTE#16#00; // Unique device identification number
            deviceID3           :	BYTE    :=  BYTE#16#00; // Unique device identification number
            functionID1         :	BYTE    :=  BYTE#16#00; // Unique function identification number
            functionID2         :	BYTE    :=  BYTE#16#00; // Unique function identification number
            reserved1           :	BYTE    :=  BYTE#16#00; // Reserved
            reserved2           :	BYTE    :=  BYTE#16#00; // Reserved
        END_VAR
    END_CLASS
END_NAMESPACE