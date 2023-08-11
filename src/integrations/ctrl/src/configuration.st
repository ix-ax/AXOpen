USING VmT;
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
        AxoDataFragmentExchangeContext : AxoDataFramentsExchangeDocuExample.AxoDataFragmentExchangeContext;
        AxoTextListExampleContext : AxoTextListExample.AxoTextListExampleContext;
        AxoCognexVisionDatamanExampleContext : AxoCognexVisionDatamanExamples.AxoCognexVisionDatamanExampleContext;
        AxoCognexVisionInsightExampleContext : AxoCognexVisionInsightExamples.AxoCognexVisionInsightExampleContext;

        process_data_manager: AxoDataExamples.AxoProcessDataManager;
        test_data_manager: AxoDataExamples.AxoTestDataManager;
        AxoLoggers : AxoLoggerExamples.Loggers;
        // Issues
        gh_ptku_8 : Layouts.Tabbed.weather;

        // Integration tests
        Integrations : IntegrationTests.Integrations;
    END_VAR

    //Copy this VAR_GLOBAL section into your configuration file inside your project.
	//Do not change any names, addresses or any another content.
	VAR_GLOBAL
		HwInputs AT %IB0 : HwInputs;
		HwOutputs AT %QB0 : HwOutputs;
		PlcInputs : PlcInputs;
		PlcOutputs : PlcOutputs;
	END_VAR

END_CONFIGURATION
