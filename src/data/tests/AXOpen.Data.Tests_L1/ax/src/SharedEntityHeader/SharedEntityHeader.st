USING AXOpen.Core;
USING AXOpen.Data;

NAMESPACE Tests_L1  

    {S7.extern=ReadWrite}
    CLASS PUBLIC SharedEntityHeader EXTENDS AXOpen.Data.AxoDataEntity
        VAR PUBLIC
            ComesFrom   : INT;
            GoesTo      : INT;
            Name      : String;
        END_VAR
    END_CLASS

END_NAMESPACE
