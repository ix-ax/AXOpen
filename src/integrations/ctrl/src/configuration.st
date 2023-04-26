CONFIGURATION MyConfiguration
    TASK Main(Interval := T#10ms, Priority := 1);
    PROGRAM P1 WITH Main: MyProgram;
    PROGRAM P2 WITH Main: ProgramExample;

    VAR_GLOBAL
        AxoTasks : AxoTaskExamples.Tasks;
        AxoSequencers : AxoSequencerExamples.SequencerExample;
        {#ix-attr:[Container(Layout.Wrap)]}
        MainContext : MyContext;
        Recipe : Recipe;
        myComponentExample : AxoComponentExamples.ComponentExampleContext;
        myComponentHeaderOnlyExample : AxoComponentExamples.ComponentHeaderOnlyExampleContext;
        {#ix-set:AttributeName = "If counting PLC is alive"}
        I_am_alive : ULINT;
        
        AxoRemoteTasks : AxoRemoteTaskExamples.RemoteTasks;
        AxoToggleTasks : AxoToggleTaskExamples.Tasks;
        AxoMomentaryTasks : AxoMomentaryTaskExamples.Tasks;

        process_data_manager: AxoDataExamples.AxoProcessDataManager;
        test_data_manager: AxoDataExamples.AxoTestDataManager;
       
        // Issues
        gh_ptku_8 : Layouts.Tabbed.weather;

        // Integration tests
        Integrations : IntegrationTests.Integrations;
    END_VAR
END_CONFIGURATION
