NAMESPACE AXOpen.Components.Rexroth.Press
    TYPE PUBLIC
        eAxoSmartFunctionKitStatusInformation_v_4_x_x : UINT
        (		
            ActiveProgramNumber         := UINT#301, //  The PROGRAM number active in the drive is read out.
            RemainingStorageSpaceOnIPC  := UINT#302, // (PR21) The remaining storage space OF the IPC is transferred in MB.
            CurrentPosition             := UINT#401, //The cyclically transmitted position is read out.
            CurrentTravelSpeed          := UINT#402, // The cyclically transmitted travel speed is read out.
            CurrentForce                := UINT#403  // The cyclically transmitted force is read out
            );
    END_TYPE
END_NAMESPACE
