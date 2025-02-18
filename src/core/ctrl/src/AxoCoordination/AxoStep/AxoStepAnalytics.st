NAMESPACE AXOpen.Core
    TYPE
        {S7.extern=ReadWrite}
        AxoStepAnalytics : STRUCT
            Order : ULINT;
            Duration : LTIME;            
            Description : STRING[120];
        END_STRUCT;
    END_TYPE
END_NAMESPACE