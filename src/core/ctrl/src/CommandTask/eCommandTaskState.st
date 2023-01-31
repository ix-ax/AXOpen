NAMESPACE ix.framework.core
    TYPE PUBLIC
        eCommandTaskState : INT 
        (          
            Disabled :=0,
            Ready := 1, 
            Kicking := 2, 
            Busy := 3,
            Done := 4,
            Error := 10
        ) := Ready;
    END_TYPE
END_NAMESPACE    