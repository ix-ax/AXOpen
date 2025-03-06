USING AxUnit;

NAMESPACE MyTest

    {TestFixture}
    {S7.extern=ReadWrite}
    CLASS MyTestFixture
        {TestSetup}
        METHOD PUBLIC TestSetup
            ;
        END_METHOD

        {TestTearDown}
        METHOD PUBLIC TestTearDown
            ;
        END_METHOD

        {FixtureSetup}
        METHOD PUBLIC FixtureSetup
            ;
        END_METHOD

        {FixtureTearDown}
        METHOD PUBLIC FixtureTearDown
            ;
        END_METHOD        
        
        {Test}
        METHOD PUBLIC MyTestMethod
            Assert.Equal(actual := TRUE, expected := TRUE);
        END_METHOD
    END_CLASS

END_NAMESPACE


