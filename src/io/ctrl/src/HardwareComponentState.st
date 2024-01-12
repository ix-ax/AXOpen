NAMESPACE AXOpen.Io
    {S7.extern=ReadWrite}
    CLASS HardwareComponentState
        VAR PUBLIC
            NoAdditionalInformation     :	BOOL;	//  No additional information available.
            TransferNotPermitted        :	BOOL;	//  Transfer not permitted.
            DiagnosticsAvailable        :	BOOL;	//  At least one qualified diagnostics is available.
            MaintenanceRequired         :	BOOL;	//  Maintenance required for at least one channel or the component.
            MaintenanceDemanded         :	BOOL;	//  Maintenance demanded for at least one channel or the component.
            Error                       :	BOOL;	//  Error in at least one channel or the component.
            ComponentAvailability	    :   ComponentAvailability;
            ReplacementState	        :   ReplacementState;  
        END_VAR
    END_CLASS
END_NAMESPACE
