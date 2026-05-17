USING AXOpen.Data;
CONFIGURATION MyConfiguration
    TASK Main(Interval := T#10ms, Priority := 1);
    PROGRAM P1 WITH Main: MyProgram;

    VAR_GLOBAL
        {S7.extern=ReadWrite}
        DistributedContext : axopen_data_distributed_tests_l4.Context;
    END_VAR
END_CONFIGURATION
