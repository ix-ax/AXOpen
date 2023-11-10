USING AxUnit;

NAMESPACE MyTest

    {TestFixture}
    CLASS MyTestFixture
        VAR 
            sandbox : SandboxContext;
            documentation : DocumentationContext;
            _rtc : AXOpen.S71500.Rtc;
            PlcInputs : PlcInputs;
            PlcOutputs : PlcOutputs;
        END_VAR
        {Test}
        METHOD PUBLIC MyTestMethod
                Assert.Equal(actual := TRUE, expected := TRUE);
        END_METHOD
    END_CLASS

END_NAMESPACE
