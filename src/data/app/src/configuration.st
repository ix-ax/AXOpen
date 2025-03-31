USING AXOpen.Data;
CONFIGURATION MyConfiguration
    TASK Main(Interval := T#10ms, Priority := 1);
    PROGRAM P1 WITH Main: MyProgram;

    VAR_GLOBAL
        {S7.extern=ReadWrite}
        _rtc : AXOpen.S71500.Rtc;
        {S7.extern=ReadWrite}
        _rtm : AXOpen.S71500.Rtm;
        
        {S7.extern=ReadWrite}
        AxoDataExchangeContext : AxoDataExchangeExample.Context;
        {S7.extern=ReadWrite}
        AxoDataFragmentsExchangeContext : AxoDataFramentsExchangeExample.Context;
        {S7.extern=ReadWrite}
        AxoDataPersistentContext : AxoDataPersistentExchangeExample.Context;
        {S7.extern=ReadWrite}
        AxoDataDistributedContext : AxoDataDistributedExample.Context;
    
    END_VAR
END_CONFIGURATION
