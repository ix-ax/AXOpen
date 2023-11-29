CONFIGURATION MyConfiguration
    TASK Main(Interval := T#10ms, Priority := 1);
    PROGRAM P1 WITH Main: MyProgram;

    VAR_GLOBAL
        {S7.extern=ReadWrite}
        S71500Rtc :  AXOpen.S71500.Rtc;  
        {S7.extern=ReadWrite}
        sandbox : SandboxContext;
        {S7.extern=ReadWrite}
        documentation : DocumentationContext;
    END_VAR            
END_CONFIGURATION



