NAMESPACE AXOpen.Core
    TYPE PUBLIC
        eAxoTaskState : INT 
        (          
            Disabled :=0,
            Ready := 1, 
            Kicking := 2, 
            Busy := 3,
            Done := 4,
            Aborted := 5,
            Error := 10
        ) := Ready;
    END_TYPE
END_NAMESPACE    
