PROGRAM MyProgram
    VAR_EXTERNAL
        AxoDataExchangeContext : AxoDataExchangeExample.Context;
        AxoDataFragmentsExchangeContext : AxoDataFramentsExchangeExample.Context;
        AxoDataPersistentContext : AxoDataPersistentExchangeExample.Context;
        AxoDataDistributedContext : AxoDataDistributedExample.Context;
    END_VAR
    
    AxoDataPersistentContext.Run();   
    AxoDataFragmentsExchangeContext.Run();   
    AxoDataExchangeContext.Run();   
    AxoDataDistributedContext.Run();  
END_PROGRAM
