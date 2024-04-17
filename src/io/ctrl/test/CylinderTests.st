USING AXOpen.Core;
USING AXOpen.Rtc;
USING AXOpen.Logging;

NAMESPACE MyTestFixturenmspc
    {TestFixture}
        CLASS MyTestFixture
            {Test}
            METHOD PUBLIC MyTestMethod
                AxUnit.Assert.Equal(TRUE, TRUE);
            END_METHOD
        END_CLASS
END_NAMESPACE
