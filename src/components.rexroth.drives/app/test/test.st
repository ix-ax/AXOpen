USING AxUnit;
USING AXOpen.Components.Rexroth.Drives;

NAMESPACE AXOpen.Components.Rexroth.Drives.Tests

    {TestFixture}
    {S7.extern=ReadWrite}
    CLASS MyTestFixture
        VAR 
            sandbox : SandboxContext;
            documentation : DocumentationContext;
            _rtc : AXOpen.S71500.Rtc;
        END_VAR
        {Test}
        METHOD PUBLIC MyTestMethod
                Assert.Equal(actual := TRUE, expected := TRUE);
        END_METHOD
    END_CLASS

END_NAMESPACE
