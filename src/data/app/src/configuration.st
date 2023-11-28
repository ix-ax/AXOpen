USING AXOpen.Data;
CONFIGURATION MyConfiguration
    TASK Main(Interval := T#10ms, Priority := 1);
    PROGRAM P1 WITH Main: MyProgram;

    VAR_GLOBAL
        {S7.extern=ReadWrite}
        AxoDataExchangeContext : AxoDataExchangeExample.Context;
        {S7.extern=ReadWrite}
        AxoDataFragmentsExchangeContext : AxoDataFramentsExchangeExample.Context;
        {S7.extern=ReadWrite}
        AxoDataPersistentContext : AxoDataPersistentExchangeExample.Context;
    END_VAR
END_CONFIGURATION
