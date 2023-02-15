CONFIGURATION MyConfiguration
    TASK Main(Interval := T#10ms, Priority := 1);
    PROGRAM P1 WITH Main: MyProgram;

    VAR_GLOBAL
        ixcoreTasks : core.Tasks;
        ixcoreSequencers : core.SequencerExample;
        {#ix-attr:[Container(Layout.Wrap)]}
        MainContext : MyContext;
        Recipe : Recipe;
        myPlcComponent : MyPlcComponent;
        {#ix-set:AttributeName = "If counting PLC is alive"}
        I_am_alive : ULINT;
        
        // Issues
        gh_ptku_8 : Layouts.Tabbed.weather;
    END_VAR
END_CONFIGURATION
