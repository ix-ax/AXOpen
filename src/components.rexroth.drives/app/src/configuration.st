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
    END_VAR   
    
    //Copy this VAR_GLOBAL section into your configuration file inside your project.
	//Do not change any names, addresses or any another content.
	VAR_GLOBAL
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



