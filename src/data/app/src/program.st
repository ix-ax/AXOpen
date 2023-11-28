PROGRAM MyProgram
    VAR_EXTERNAL
        AxoDataExchangeContext : AxoDataExchangeExample.Context;
        AxoDataFragmentsExchangeContext : AxoDataFramentsExchangeExample.Context;
        AxoDataPersistentContext : AxoDataPersistentExchangeExample.Context;
    END_VAR
    
    AxoDataPersistentContext.Run();   
    AxoDataFragmentsExchangeContext.Run();   
    AxoDataExchangeContext.Run();   

END_PROGRAM
