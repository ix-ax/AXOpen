USING AXOpen.Io;

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
        {S7.extern=ReadWrite}
        _rtm : AXOpen.S71500.Rtm;
        {S7.extern=ReadWrite}
        Inputs  AT %IB0 : Inputs;
        {S7.extern=ReadWrite}
		Outputs  AT %QB0 : Outputs;
        {S7.extern=ReadWrite}
        HwIdentifierList : HwIdentifierList;
    END_VAR   
    
END_CONFIGURATION



