USING AXOpen.Data;
CONFIGURATION MyConfiguration
    TASK Main(Interval := T#10ms, Priority := 1);
    PROGRAM P1 WITH Main: MyProgram;

    VAR_GLOBAL

        {S7.extern=ReadWrite}
        DataExchange : Tests_L1.DataExchange.DataExchangeContext;

        {S7.extern=ReadWrite}
        Fragments : Tests_L1.FragmentData.FragmentDataContext;

        {S7.extern=ReadWrite}
        Distributed : Tests_L1.Distributed.DistributedDataContext;

        {S7.extern=ReadWrite}
        Persistent : Tests_L1.PersistentData.PersistentDataContext;

    END_VAR
END_CONFIGURATION
