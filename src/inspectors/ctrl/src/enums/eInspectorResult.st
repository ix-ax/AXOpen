NAMESPACE AXOpen.Inspectors
    TYPE
        eInspectorResult : INT (
            NoAction     := 0,
            Running      := 10,
            Passed       := 20,
            Failed       := 30,
            Inconclusive := 35,
            Excluded     := 40,
            Bypassed     := 50
        );
    END_TYPE
END_NAMESPACE