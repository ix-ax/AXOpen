NAMESPACE AXOpen.Components.Drives
    TYPE PUBLIC
        eAxoDriveState :
        (		
            Disabled,
            Errorstop, 
            Standstill,
            Homing,
            Stopping,
            DiscreteMotion,
            SynchronizedMotion,
            ContinousMotion
        );
    END_TYPE
END_NAMESPACE
