PROGRAM MyProgram
    VAR_EXTERNAL
        DataExchange : Tests_L1.DataExchange.DataExchangeContext;
        Fragments : Tests_L1.FragmentData.FragmentDataContext;
        Distributed : Tests_L1.Distributed.DistributedDataContext;
        Persistent : Tests_L1.PersistentData.PersistentDataContext;

    END_VAR
    
    DataExchange.Run();  
    Fragments.Run();  
    Distributed.Run();
    Persistent.Run();   

END_PROGRAM
