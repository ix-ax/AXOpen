USING AXOpen.Data;
CONFIGURATION MyConfiguration
    TASK Main(Interval := T#1000ms, Priority := 1);
    PROGRAM P1 WITH Main: MyProgram;

    VAR_GLOBAL
        AxoDataExchangeManager : AxoDataExchangeExample.AxoProcessDataManager;
        AxoDataFramentsExchangeManager : AxoDataFramentsExchangeExample.AxoProcessDataManager;
    END_VAR
END_CONFIGURATION
