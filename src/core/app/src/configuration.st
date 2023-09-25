USING VmT;
CONFIGURATION MyConfiguration
    TASK Main(Interval := T#10ms, Priority := 1);
    PROGRAM P1 WITH Main: MyProgram;
    PROGRAM P2 WITH Main: ProgramExample;

    VAR_GLOBAL      
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
        AxoMessengers : AxoStaticMessengerExample.Messengers;
        AxoMessengersDocu : AxoStaticMessengerDocuExample.Messengers;
        AxoRtc : AxoRtc.AxoS71500Rtc;       
        AxoTextListExampleContext : AxoTextListExample.AxoTextListExampleContext;              
        AxoByteArrayExampleContext : AxoByteArrayExample.AxoByteArrayExampleContext;
        AxoBoolArrayExampleContext : AxoBoolArrayExample.AxoBoolArrayExampleContext;       
        AxoLoggers : AxoLoggerExamples.Loggers;
        // Issues
        gh_ptku_8 : Layouts.Tabbed.weather;        
    END_VAR   
END_CONFIGURATION
