CONFIGURATION MyConfiguration
    TASK Main(Interval := T#1000ms, Priority := 1);
    PROGRAM P1 WITH Main: MyProgram;

    VAR_GLOBAL
        {S7.extern=ReadWrite}
        sandbox : SandboContext;
        {S7.extern=ReadWrite}
        documentation : DocumentationContext;
        {S7.extern=ReadWrite}
        AxoRtc : AxoRtc.AxoS71500Rtc;
        {S7.extern=ReadWrite}
		HwInputs AT %IB0 : HwInputs;
        {S7.extern=ReadWrite}
		HwOutputs AT %QB0 : HwOutputs;
        {S7.extern=ReadWrite}
		PlcInputs : PlcInputs;
        {S7.extern=ReadWrite}
		PlcOutputs : PlcOutputs;
	END_VAR
END_CONFIGURATION



