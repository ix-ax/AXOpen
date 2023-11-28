USING AXOpen.Core;

PROGRAM MyProgram
    VAR_EXTERNAL        
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
        AxoTextListExampleContext : AxoTextListExample.AxoTextListExampleContext;                
        AxoByteArrayExampleContext : AxoByteArrayExample.AxoByteArrayExampleContext;
        AxoBoolArrayExampleContext : AxoBoolArrayExample.AxoBoolArrayExampleContext;
        AxoLoggers : AxoLoggerExamples.Loggers;                
        AxoRtc : AxoRtc.AxoS71500Rtc;

    END_VAR    
    
    I_am_alive := I_am_alive + ULINT#1;
  
    AxoTasks.Run();
    AxoTaskDocu.Run();
    AxoToggleTasks.Run();
    AxoToggleTaskDocu.Run();
    AxoSequencers.Run();
    AxoSequencerContainer.Run();
    myComponentExample.Run();
    myComponentHeaderOnlyExample.Run();
    AxoRemoteTasks.Run();   
    AxoMomentaryTasks.Run();
    AxoMomentaryTaskDocu.Run();
    
    AxoMessengers.Run();
    AxoMessengers.InjectRtc(AxoRtc);
    AxoMessengersDocu.Run();
    AxoMessengersDocu.InjectRtc(AxoRtc);        
    AxoTextListExampleContext.Run();
            
    AxoByteArrayExampleContext.Run();
    AxoBoolArrayExampleContext.Run();

    AxoLoggers.InjectRtc(AxoRtc);
    AxoLoggers.Run();     	
END_PROGRAM
