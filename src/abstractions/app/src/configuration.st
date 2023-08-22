CONFIGURATION MyConfiguration
    TASK Main(Interval := T#1000ms, Priority := 1);
    PROGRAM P1 WITH Main: MyProgram;

    VAR_GLOBAL
        sandbox : SandboContext;
        documentation : DocumentationContext;
    END_VAR            
END_CONFIGURATION



