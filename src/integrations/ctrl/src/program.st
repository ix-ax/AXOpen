USING AXOpen.Core;

PROGRAM MyProgram
    VAR_EXTERNAL
        MainContext : MyContext;
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

        AxoDataFragmentExchangeContext : AxoDataFramentsExchangeDocuExample.AxoDataFragmentExchangeContext;
        AxoTextListExampleContext : AxoTextListExample.AxoTextListExampleContext;
        AxoCognexVisionDatamanExampleContext : AxoCognexVisionDatamanExamples.AxoCognexVisionDatamanExampleContext;
        AxoCognexVisionInsightExampleContext : AxoCognexVisionInsightExamples.AxoCognexVisionInsightExampleContext;
        AxoByteArrayExampleContext : AxoByteArrayExample.AxoByteArrayExampleContext;
        AxoBoolArrayExampleContext : AxoBoolArrayExample.AxoBoolArrayExampleContext;

        AxoLoggers : AxoLoggerExamples.Loggers;

        // Integration test
        Integrations : IntegrationTests.Integrations;
        AxoRtc : AxoRtc.AxoS71500Rtc;

    END_VAR    

    //Copy this VAR_EXTERNAL section into the declaration part of your main program file inside your project.
	//Do not change any names, addresses or any another content.
	VAR_EXTERNAL
		PlcInputs : PlcInputs;
		PlcOutputs : PlcOutputs;
	END_VAR


    //Copy this function call at the very beginning of your program.
	//Do not change any names, addresses or any another content.
    CopyInputs();

    I_am_alive := I_am_alive + ULINT#1;

    MainContext.Run();
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
    AxoDataExamplesDocu.Run();
    AxoMessengers.Run();
    AxoMessengers.InjectRtc(AxoRtc);
    AxoMessengersDocu.Run();
    AxoMessengersDocu.InjectRtc(AxoRtc);
    AxoDataFragmentExchangeContext.Run();
    
    AxoTextListExampleContext.Run();
    
    AxoCognexVisionDatamanExampleContext.PlcInputs := REF(PlcInputs);
    AxoCognexVisionDatamanExampleContext.PlcOutputs := REF(PlcOutputs);
    AxoCognexVisionDatamanExampleContext.Run();

    AxoCognexVisionInsightExampleContext.PlcInputs := REF(PlcInputs);
    AxoCognexVisionInsightExampleContext.PlcOutputs := REF(PlcOutputs);
    AxoCognexVisionInsightExampleContext.Run();
    AxoByteArrayExampleContext.Run();
    AxoBoolArrayExampleContext.Run();

    AxoLoggers.InjectRtc(AxoRtc);
    AxoLoggers.Run();
    // Integration tests
    Integrations.Run();      

 	//Copy this function call at the very end of your program.
	//Do not change any names, addresses or any another content.
	CopyOutputs();  
END_PROGRAM


CLASS MyContext EXTENDS AxoContext    
    VAR PUBLIC         
        process_data_manager: AxoDataExamples.AxoProcessDataManager;
        test_data_manager: AxoDataExamples.AxoTestDataManager;
    END_VAR

    METHOD PROTECTED OVERRIDE Main        
        THIS.DataExchangeTests();
    END_METHOD

    METHOD DataExchangeTests : Int               
        process_data_manager.Run(THIS);   
        
        IF(process_data_manager._create) THEN
            IF(process_data_manager.Create(process_data_manager._identifier).IsDone()) THEN
                process_data_manager._create := FALSE;
            END_IF;    
        END_IF;   
        
        IF(process_data_manager._read) THEN
            IF(process_data_manager.Read(process_data_manager._identifier).IsDone()) THEN
                process_data_manager._read := FALSE;
            END_IF;    
        END_IF;  

        IF(process_data_manager._update) THEN
            IF(process_data_manager.Update(process_data_manager._identifier).IsDone()) THEN
                process_data_manager._update := FALSE;
            END_IF;    
        END_IF;  

        IF(process_data_manager._delete) THEN
            IF(process_data_manager.Delete(process_data_manager._identifier).IsDone()) THEN
                process_data_manager._delete := FALSE;
            END_IF;    
        END_IF; 
    END_METHOD
END_CLASS    

