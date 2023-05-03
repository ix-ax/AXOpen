USING AXOpen.Core;

PROGRAM MyProgram
    VAR_EXTERNAL
        MainContext : MyContext;
        I_am_alive : ULINT;
        AxoSequencers : AxoSequencerExamples.SequencerExample;
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

        // Integration test
        Integrations : IntegrationTests.Integrations;
    END_VAR    
    I_am_alive := I_am_alive + ULINT#1;
    MainContext.Run();
    AxoTasks.Run();
    AxoTaskDocu.Run();
    AxoToggleTasks.Run();
    AxoToggleTaskDocu.Run();
    AxoSequencers.Run();
    myComponentExample.Run();
    myComponentHeaderOnlyExample.Run();
    AxoRemoteTasks.Run();   
    AxoMomentaryTasks.Run();
    AxoMomentaryTaskDocu.Run();
    AxoDataExamplesDocu.Run();
    
    // Integration tests
    Integrations.Run();      
    
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

