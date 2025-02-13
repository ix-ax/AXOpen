USING AXOpen.Data;
CONFIGURATION MyConfiguration
    TASK Main(Interval := T#10ms, Priority := 1);
    PROGRAM P1 WITH Main: MyProgram;

    VAR_GLOBAL
        {S7.extern=ReadWrite}
        AxoDataExchangeContext_Test_L4 : DataExchange_Test_L4.Context;
        {S7.extern=ReadWrite}
        AxoDataFragmentsExchangeContext_Test_L4 : DataFramentsExchange_Test_L4.Context;
    END_VAR
END_CONFIGURATION
