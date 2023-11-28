CONFIGURATION MyConfiguration
    TASK Main(Interval := T#1000ms, Priority := 1);
    PROGRAM P1 WITH Main: MyProgram;

    VAR_GLOBAL
        {S7.extern=ReadWrite}
        sandbox : SandboContext;
        {S7.extern=ReadWrite}
        documentation : DocumentationContext;
    END_VAR            
END_CONFIGURATION



