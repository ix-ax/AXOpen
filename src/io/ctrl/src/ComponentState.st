NAMESPACE AXOpen.Io
    TYPE ComponentState  : UINT (
        Good                    :=	UINT#0, //	No problems detected.
        Disabled                :=	UINT#1, //	The hardware component is disabled.
        MaintenanceRequired     :=	UINT#2, //	Maintenance required.
        MaintenanceDemanded     :=	UINT#3, //	Maintenance demanded.
        Error                   :=	UINT#4, //	Error.
        NotAccessible           :=	UINT#5, //	Status unknown or error in higher-level hardware component.
        Unknown                 :=	UINT#6, //	Default value for components that do not return diagnostic events.
        IONotAvailable          :=	UINT#7  //	Inputs/outputs are not available.
                    );
    END_TYPE
END_NAMESPACE

