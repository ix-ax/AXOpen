USING AxUnit;
USING AXOpen.Utils;

NAMESPACE AXOpen.Utils.Unit_Tests


    {TestFixture}
    CLASS AxoCRCs_UnitTests 
        {Test}
        METHOD PUBLIC should_be_40_decimal
            Assert.Equal(BYTE#40, AxoCRC_8('abcdefgh'));
        END_METHOD

        {Test}
        METHOD PUBLIC should_be_39617_decimal
            Assert.Equal(WORD#39617, AxoCRC_16('abcdefgh'));
        END_METHOD

        {Test}
        METHOD PUBLIC should_be_2950370206_decimal
            Assert.Equal(DWORD#2950370206, AxoCRC_32('abcdefgh'));
        END_METHOD
    END_CLASS
END_NAMESPACE
