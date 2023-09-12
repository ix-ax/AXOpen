NAMESPACE AXOpen.Components.Abstractions
    TYPE PUBLIC
        eAxoExecutionMode :
        (		
            Immediately,    //the functionality is immediately valid and may influence the on-going motion but not the state (note: is the default behaviour)
            Queued          //Same functionality as buffer mode ‘Buffered’
        );
    END_TYPE
END_NAMESPACE