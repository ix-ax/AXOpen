NAMESPACE AXOpen.Components.SIEM.Identification
    {S7.extern=ReadWrite}
    CLASS AxoIOLink_RF200_typeReaderStatus
        VAR PUBLIC
            timeSinceStartup        :	DWORD   :=  DWORD#16#0; //  Operating time in seconds
            tagsInTheField          :	BYTE    :=  BYTE#16#0;  //  current number of transponders in the field
            antennaStatus           :	BYTE    :=  BYTE#16#0;  //  antenna turned on/off
            tagChanges              :	DWORD   :=  DWORD#16#0; //  number of transponder changes
            lineDriverRev           :	BYTE    :=  BYTE#16#0;  //  version of the IO-Link line driver
            errorCounterPassive     :	BYTE    :=  BYTE#16#0;  //  Air interface: Counter for errors in idle state
            abortCounter            :	BYTE    :=  BYTE#16#0;  //  Air interface: Communication aborted
            codeErrorCounter        :	BYTE    :=  BYTE#16#0;  //  Air interface: Communication disruption
            signatureErrorCounter   :	BYTE    :=  BYTE#16#0;  //  Air interface: Protocol error, signature error counter, is reset when read out
            crcErrorCounter         :	BYTE    :=  BYTE#16#0;  //  Air interface: Communication disruption
            currentCommandStatus    :	BYTE    :=  BYTE#16#0;  //  Command status of the last command, is reset when read out
            errorCount              :	BYTE    :=  BYTE#16#0;  //  HOST interface: Communication disruption
        END_VAR
    END_CLASS
END_NAMESPACE