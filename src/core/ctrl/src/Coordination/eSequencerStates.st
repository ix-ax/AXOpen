NAMESPACE ix.framework.core
    TYPE PUBLIC
        eSequencerStates : INT 
        (          
            Idle :=0,
            RunningStepMode := 1, 
            RunningCycleMode := 2, 
            Error := 10
        ) := Idle;
    END_TYPE
END_NAMESPACE    