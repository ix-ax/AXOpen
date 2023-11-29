
CONFIGURATION MyConfiguration
    TASK Main(Interval := T#10ms, Priority := 1);
    PROGRAM P1 WITH Main: MyProgram;

    VAR_GLOBAL
        {#ix-attr:[Container(Layout.Wrap)]}
        {#ix-set:AttributeName = "If counting PLC is alive"}
        {S7.extern=ReadWrite}
        I_am_alive : ULINT;
        {S7.extern=ReadWrite}
        AxoCognexVisionExampleContext : AxoCognexVisionExample.AxoCognexVisionExampleContext;
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
