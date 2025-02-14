USING AXOpen.Data;
CONFIGURATION MyConfiguration
    TASK Main(Interval := T#10ms, Priority := 1);
    PROGRAM P1 WITH Main: MyProgram;

    VAR_GLOBAL
        {S7.extern=ReadWrite}
        ExchangeContext_Test_L4 : Exchange_Test_L4.Context;
        {S7.extern=ReadWrite}
        FragmentsExchangeContext_Test_L4 : FragmentExchange_Test_L4.Context;
    END_VAR
END_CONFIGURATION
