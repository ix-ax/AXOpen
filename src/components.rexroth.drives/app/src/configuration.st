CONFIGURATION MyConfiguration
    TASK Main(Interval := T#10ms, Priority := 1);
    PROGRAM P1 WITH Main: MyProgram;

    VAR_GLOBAL
        sandbox : SandboxContext;
        documentation : DocumentationContext;
        _rtc : AXOpen.S71500.Rtc;
    END_VAR   
    
    //Copy this VAR_GLOBAL section into your configuration file inside your project.
	//Do not change any names, addresses or any another content.
	VAR_GLOBAL
		HwInputs AT %IB0 : HwInputs;
		HwOutputs AT %QB0 : HwOutputs;
		PlcInputs : PlcInputs;
		PlcOutputs : PlcOutputs;
	END_VAR    
END_CONFIGURATION



