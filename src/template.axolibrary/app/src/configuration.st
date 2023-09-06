CONFIGURATION MyConfiguration
    TASK Main(Interval := T#10ms, Priority := 1);
    PROGRAM P1 WITH Main: MyProgram;

    VAR_GLOBAL
        sandbox : SandboxContext;
        documentation : DocumentationContext;
    END_VAR            
END_CONFIGURATION



