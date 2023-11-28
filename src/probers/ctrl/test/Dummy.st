USING AxUnit;

NAMESPACE nmspcDummy


    {TestFixture}
    {S7.extern=ReadWrite}
    CLASS clssDummy
        {Test}
        METHOD PUBLIC Dummy
            Assert.Equal(true, true);
        END_METHOD        
    END_CLASS
END_NAMESPACE
