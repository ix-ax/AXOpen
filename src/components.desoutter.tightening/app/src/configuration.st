CONFIGURATION MyConfiguration
    TASK Main(Interval := T#10ms, Priority := 1);
    PROGRAM P1 WITH Main: MyProgram;

    VAR_GLOBAL
        {S7.extern=ReadWrite}
        sandbox : SandboxContext;
        {S7.extern=ReadWrite}
        documentation : DocumentationContext;
        {S7.extern=ReadWrite}
        _rtc : AXOpen.S71500.Rtc;

        HwInputs AT %IB0 : HwInputs;
        HwOutputs AT %QB0 : HwOutputs;
        PlcInputs : PlcInputs;
        PlcOutputs : PlcOutputs;
    
    END_VAR            
END_CONFIGURATION



