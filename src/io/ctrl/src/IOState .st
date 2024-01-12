NAMESPACE AXOpen.Io
    {S7.extern=ReadWrite}
    CLASS IOState 
        VAR PUBLIC
            Good                    :	BOOL;   //	No problems detected.
            Disabled                :	BOOL;   //	The hardware component is disabled.
            MaintenanceRequired     :	BOOL;   //	Maintenance required.
            MaintenanceDemanded     :	BOOL;   //	Maintenance demanded.
            Error                   :	BOOL;   //	Error.
            NotAccessible           :	BOOL;   //	Hardware component not reachable; hardware component cannot be accessed.
            DiagnosticsAvailable    :	BOOL;   //	At least one qualified diagnostics is available.
            IODataNotAvailable      :	BOOL;   //	I/O data not available.
            NetworkError            :	BOOL;   //	Network error.
            HardwareError           :	BOOL;   //	Hardware error.
        END_VAR
    END_CLASS
END_NAMESPACE
