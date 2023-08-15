USING System.SerDe;

NAMESPACE AXOpen.Utils
    FUNCTION AxoBytesToInt : DINT
        VAR_INPUT
            inFormat : Endianness;
            inByte0: BYTE;
            inByte1: BYTE;
        END_VAR

        IF inFormat=Endianness#Little THEN
            AxoBytesToInt := TO_INT(SHL(TO_WORD(inByte1),UINT#8) OR inByte0);
        ELSIF inFormat=Endianness#Big THEN
            AxoBytesToInt := TO_INT(SHL(TO_WORD(inByte0),UINT#8) OR inByte1);
        END_IF;
    END_FUNCTION

END_NAMESPACE