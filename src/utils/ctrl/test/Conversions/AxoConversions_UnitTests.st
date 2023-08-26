USING AxUnit;
USING AXOpen.Utils;
USING System.SerDe;

NAMESPACE AXOpen.Utils.Unit_Tests
    {TestFixture}
    CLASS AxoConversions_UnitTests 
        {Test}
        METHOD PUBLIC should_be_305419896_decimal
            Assert.Equal(DINT#305419896, AxoBytesToDint(Endianness#Big,Byte#16#12,Byte#16#34,Byte#16#56,Byte#16#78));
            Assert.Equal(DINT#305419896, AxoBytesToDint(Endianness#Little,Byte#16#78,Byte#16#56,Byte#16#34,Byte#16#12));
        END_METHOD

        {Test}
        METHOD PUBLIC should_be_2018915346_decimal
            Assert.Equal(DINT#2018915346, AxoBytesToDint(Endianness#Little,Byte#16#12,Byte#16#34,Byte#16#56,Byte#16#78));
            Assert.Equal(DINT#2018915346, AxoBytesToDint(Endianness#Big,Byte#16#78,Byte#16#56,Byte#16#34,Byte#16#12));
        END_METHOD

        {Test}
        METHOD PUBLIC should_be_4660_decimal
            Assert.Equal(INT#4660, AxoBytesToInt(Endianness#Big,Byte#16#12,Byte#16#34));
            Assert.Equal(INT#4660, AxoBytesToInt(Endianness#Little,Byte#16#34,Byte#16#12));
        END_METHOD

        
        {Test}
        METHOD PUBLIC should_be_13330_decimal
            Assert.Equal(INT#13330, AxoBytesToInt(Endianness#Little,Byte#16#12,Byte#16#34));
            Assert.Equal(INT#13330, AxoBytesToInt(Endianness#Big,Byte#16#34,Byte#16#12));
        END_METHOD
    END_CLASS
END_NAMESPACE
