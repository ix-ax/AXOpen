USING Template.Axolibrary;

CONFIGURATION MyConfiguration
    TASK Main(Interval := T#10ms, Priority := 1);
    PROGRAM P1 WITH Main: MyProgram;

    VAR_GLOBAL
        {S7.extern=ReadWrite}
        sandbox : Template.Axolibrary.SandboxContext;
        {S7.extern=ReadWrite}
        documentation : Template.Axolibrary.DocumentationContext;
        {S7.extern=ReadWrite}
        _rtc : AXOpen.S71500.Rtc;
        {S7.extern=ReadWrite}
        _rtm : AXOpen.S71500.Rtm;
    END_VAR     

END_CONFIGURATION



