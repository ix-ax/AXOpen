PROGRAM MyProgram
    VAR_EXTERNAL
        MainContext : MyContext;
        ixcoreSequencers : IxSequencerExamples.SequencerExample;
        I_am_alive : ULINT;
        ixcoreTasks : IxTaskExamples.Tasks;
        myComponentExample : IxComponentExamples.ComponentExampleContext;
        myComponentHeaderOnlyExample : IxComponentExamples.ComponentHeaderOnlyExampleContext;
        ixcore_remote_tasks : IxRemoteTaskExamples.RemoteTasks;
        
    END_VAR    
    I_am_alive := I_am_alive + ULINT#1;
    MainContext.Run();
    ixcoreTasks.Run();
    ixcoreSequencers.Run();
    myComponentExample.Run();
    myComponentHeaderOnlyExample.Run();
    ixcore_remote_tasks.Run();   
END_PROGRAM


CLASS MyContext EXTENDS ix.framework.core.IxContext    
    VAR PUBLIC 
        process_data_manager_remote_exec: ixDataExamples.IxProcessDataManager;
    END_VAR

    METHOD PROTECTED OVERRIDE Main        
        process_data_manager_remote_exec.Initialize(THIS);
        process_data_manager_remote_exec.Run();       
    END_METHOD
END_CLASS    

