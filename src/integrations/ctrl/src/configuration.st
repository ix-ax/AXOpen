CONFIGURATION MyConfiguration
    TASK Main(Interval := T#10ms, Priority := 1);
    PROGRAM P1 WITH Main: MyProgram;
    PROGRAM P2 WITH Main: ProgramExample;

    VAR_GLOBAL
        {#ix-attr:[Container(Layout.Wrap)]}
        MainContext : MyContext;
        Recipe : Recipe;
        {#ix-set:AttributeName = "If counting PLC is alive"}
        I_am_alive : ULINT;
        AxoSequencers : AxoSequencerExamples.SequencerExample;
        AxoSequencerContainer : AxoSequencerContainerExamples.SequencerContainerExample;
        AxoTasks : AxoTaskExamples.Tasks;
        AxoTaskDocu : AxoTaskExamples.AxoTaskDocuExample;
        myComponentExample : AxoComponentExamples.ComponentExampleContext;
        myComponentHeaderOnlyExample : AxoComponentExamples.ComponentHeaderOnlyExampleContext;
        AxoRemoteTasks : AxoRemoteTaskExamples.RemoteTasks;
        AxoToggleTasks : AxoToggleTaskExamples.Tasks;
        AxoToggleTaskDocu : AxoToggleTaskExamples.AxoToggleTaskDocuExample;
        AxoMomentaryTasks : AxoMomentaryTaskExamples.Tasks;
        AxoMomentaryTaskDocu : AxoMomentaryTaskExamples.AxoMomentaryTaskDocuExample;
        AxoDataExamplesDocu : AxoDataExamplesDocu.Context;
        AxoMessengers : AxoStaticMessengerExample.Messengers;
        AxoMessengersDocu : AxoStaticMessengerDocuExample.Messengers;
        AxoRtc : AxoRtc.AxoS71500Rtc;

        process_data_manager: AxoDataExamples.AxoProcessDataManager;
        test_data_manager: AxoDataExamples.AxoTestDataManager;
       
        // Issues
        gh_ptku_8 : Layouts.Tabbed.weather;

        // Integration tests
        Integrations : IntegrationTests.Integrations;
    END_VAR
END_CONFIGURATION
