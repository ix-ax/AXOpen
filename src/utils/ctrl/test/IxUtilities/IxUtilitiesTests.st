USING AxUnit;
USING AxUnit;
USING ix.core;
USING AxUnit;
USING ix.framework.utils;

NAMESPACE ix.core.IxUtilities_Tests


    {TestFixture}
    CLASS IxCRCs_UnitTests 
        {Test}
        METHOD PUBLIC should_be_40_decimal
            Assert.Equal(BYTE#40, IxCRC_8('abcdefgh') );
        END_METHOD

        {Test}
        METHOD PUBLIC should_be_39617_decimal
            Assert.Equal(WORD#39617, IxCRC_16('abcdefgh') );
        END_METHOD

        {Test}
        METHOD PUBLIC should_be_2950370206_decimal
            Assert.Equal(DWORD#2950370206, IxCRC_32('abcdefgh') );
        END_METHOD

    END_CLASS
END_NAMESPACE
