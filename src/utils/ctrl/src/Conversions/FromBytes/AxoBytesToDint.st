USING System.SerDe;

NAMESPACE AXOpen.Utils
    FUNCTION AxoBytesToDint : DINT
        VAR_INPUT
            inFormat : Endianness;
            inByte0: BYTE;
            inByte1: BYTE;
            inByte2: BYTE;
            inByte3: BYTE;
        END_VAR


        IF inFormat=Endianness#Little THEN
            AxoBytesToDint := TO_DINT(SHL(SHL(SHL(TO_DWORD(inByte3), UINT#8) OR inByte2,UINT#8) OR inByte1,UINT#8) OR inByte0);
        ELSIF inFormat=Endianness#Big THEN
            AxoBytesToDint := TO_DINT(SHL(SHL(SHL(TO_DWORD(inByte0), UINT#8) OR inByte1,UINT#8) OR inByte2,UINT#8) OR inByte3);
        END_IF;
    END_FUNCTION

END_NAMESPACE
