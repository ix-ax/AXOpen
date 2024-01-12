NAMESPACE AXOpen.Io
    TYPE GetDiagnosticsReturnCode : INT (
        NoError             :=	INT#0,      //	No error.
        HardwareIDInvalid   :=	INT#-32642, //	The address is unknown.
        OutOfResources      :=	INT#-32575  //	All diagnostic resources are currently in use    
        );
    END_TYPE
END_NAMESPACE

