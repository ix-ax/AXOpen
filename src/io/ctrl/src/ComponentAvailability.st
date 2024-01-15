NAMESPACE AXOpen.Io
    TYPE ComponentAvailability : UINT (
        Unknown 	            :=  UINT#255,
        Available	            :=  UINT#0,	// Hardware component is available.
        ApplicationReadyPending	:=  UINT#1,	// Application Ready Pending; no I/O access.
        LockedBySuperordinated	:=  UINT#2,	// Locked by Superordinated; no access to hardware component.
        LockedByIOController	:=  UINT#3,	// Locked by IO controller; no access to hardware component.
        LockedByIOSupervisor	:=  UINT#4	// Locked by IO supervisor; no access to hardware component.
    ) := Unknown;
    END_TYPE
END_NAMESPACE

