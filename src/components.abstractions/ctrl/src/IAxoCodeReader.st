USING AXOpen.Core;
NAMESPACE AXOpen.Components.Abstractions
    INTERFACE PUBLIC IAxoCodeReader
        METHOD ClearResultData : IAxoTaskState END_METHOD                            
        METHOD Read : IAxoTaskState END_METHOD
    END_INTERFACE    
END_NAMESPACE
