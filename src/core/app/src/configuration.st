USING VmT;
CONFIGURATION MyConfiguration
    TASK Main(Interval := T#10ms, Priority := 1);
    PROGRAM P1 WITH Main: MyProgram;
    PROGRAM P2 WITH Main: ProgramExample;

    VAR_GLOBAL
        {S7.extern=ReadWrite}      
        Recipe : Recipe;
        {#ix-set:AttributeName = "If counting PLC is alive"}
        {S7.extern=ReadWrite}  
        I_am_alive : ULINT;
        {S7.extern=ReadWrite}
        AxoSequencers : AxoSequencerExamples.SequencerExample;
        {S7.extern=ReadWrite}
        AxoSequencerContainer : AxoSequencerContainerExamples.SequencerContainerExample;
        {S7.extern=ReadWrite}
        AxoTasks : AxoTaskExamples.Tasks;
        {S7.extern=ReadWrite}
        AxoTaskDocu : AxoTaskExamples.AxoTaskDocuExample;
        {S7.extern=ReadWrite}
        myComponentExample : AxoComponentExamples.ComponentExampleContext;
        {S7.extern=ReadWrite}
        myComponentHeaderOnlyExample : AxoComponentExamples.ComponentHeaderOnlyExampleContext;
        {S7.extern=ReadWrite}
        AxoRemoteTasks : AxoRemoteTaskExamples.RemoteTasks;
        {S7.extern=ReadWrite}
        AxoToggleTasks : AxoToggleTaskExamples.Tasks;
        {S7.extern=ReadWrite}
        AxoToggleTaskDocu : AxoToggleTaskExamples.AxoToggleTaskDocuExample;
        {S7.extern=ReadWrite}
        AxoMomentaryTasks : AxoMomentaryTaskExamples.Tasks;
        {S7.extern=ReadWrite}
        AxoMomentaryTaskDocu : AxoMomentaryTaskExamples.AxoMomentaryTaskDocuExample;       
        {S7.extern=ReadWrite}
        AxoMessengers : AxoStaticMessengerExample.Messengers;
        {S7.extern=ReadWrite}
        AxoMessengersDocu : AxoStaticMessengerDocuExample.Messengers;
        {S7.extern=ReadWrite}
        AxoRtc : AxoRtc.AxoS71500Rtc;       
        {S7.extern=ReadWrite}
        AxoTextListExampleContext : AxoTextListExample.AxoTextListExampleContext;              
        {S7.extern=ReadWrite}
        AxoByteArrayExampleContext : AxoByteArrayExample.AxoByteArrayExampleContext;
        {S7.extern=ReadWrite}
        AxoBoolArrayExampleContext : AxoBoolArrayExample.AxoBoolArrayExampleContext;       
        {S7.extern=ReadWrite}
        AxoLoggers : AxoLoggerExamples.Loggers;
        {S7.extern=ReadWrite}
        Dialogs_1 : AxoDialogExamples.Dialogs;              
        {S7.extern=ReadWrite}
        Dialogs_2 : AxoDialogExamples.Dialogs;   
        // Issues
        {S7.extern=ReadWrite}
        gh_ptku_8 : Layouts.Tabbed.weather;        
    END_VAR   
END_CONFIGURATION
