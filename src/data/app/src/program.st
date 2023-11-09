PROGRAM MyProgram
    VAR_EXTERNAL
        AxoDataExchangeManager : AxoDataExchangeExample.AxoProcessDataManager;
        AxoDataFramentsExchangeManager : AxoDataFramentsExchangeExample.AxoProcessDataManager;
        AxoDataPersistentContext : AxoDataPersistentExchangeExample.Context;
    END_VAR
    AxoDataPersistentContext.Run();   
END_PROGRAM
