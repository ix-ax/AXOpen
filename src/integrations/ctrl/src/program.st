PROGRAM MyProgram
    VAR_EXTERNAL
        MainContext : MyContext;
        ixcoreSequencers : IxSequencerExamples.SequencerExample;
        I_am_alive : ULINT;
        ixcoreTasks : IxTaskExamples.Tasks;
        myComponentExample : IxComponentExamples.ComponentExampleContext;
        myComponentHeaderOnlyExample : IxComponentExamples.ComponentHeaderOnlyExampleContext;
        ixcore_remote_tasks : IxRemoteTaskExamples.RemoteTasks;
        


        // Integration test
        Integrations : IntegrationTests.Integrations;
    END_VAR    
    I_am_alive := I_am_alive + ULINT#1;
    MainContext.Run();
    ixcoreTasks.Run();
    ixcoreSequencers.Run();
    myComponentExample.Run();
    myComponentHeaderOnlyExample.Run();
    ixcore_remote_tasks.Run();   
    
    // Integration tests
    Integrations.Run();      
    
END_PROGRAM


CLASS MyContext EXTENDS ix.framework.core.IxContext    
    VAR PUBLIC         
        process_data_manager: ixDataExamples.IxProcessDataManager;
        test_data_manager: ixDataExamples.IxTestDataManager;
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

