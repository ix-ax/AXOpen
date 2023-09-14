USING AXOpen.Core;
NAMESPACE AXOpen.Components.Abstractions
    INTERFACE PUBLIC IAxoCodeReader
        METHOD ClearResultData : IAxoTaskState END_METHOD                            
        METHOD Read : IAxoTaskState 
            VAR_OUTPUT
                result : ARRAY [0..245] OF BYTE;
            END_VAR
        END_METHOD
    END_INTERFACE    
END_NAMESPACE
