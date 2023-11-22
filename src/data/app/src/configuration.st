USING AXOpen.Data;
CONFIGURATION MyConfiguration
    TASK Main(Interval := T#10ms, Priority := 1);
    PROGRAM P1 WITH Main: MyProgram;

    VAR_GLOBAL
        AxoDataExchangeContext : AxoDataExchangeExample.Context;
        AxoDataFragmentsExchangeContext : AxoDataFramentsExchangeExample.Context;
        AxoDataPersistentContext : AxoDataPersistentExchangeExample.Context;
    END_VAR
END_CONFIGURATION
