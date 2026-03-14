USING AXOpen.Core;
USING AXOpen.Data;

NAMESPACE Tests_L1  

    {S7.extern=ReadWrite}
    CLASS PUBLIC StationData EXTENDS AXOpen.Data.AxoDataEntity
        VAR PUBLIC
            //StationPass : BOOL;
            CounterDelay : ULINT;
        END_VAR
    END_CLASS

END_NAMESPACE
