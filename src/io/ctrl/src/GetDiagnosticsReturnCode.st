NAMESPACE AXOpen.Io
    TYPE GetDiagnosticsReturnCode : INT (
        Unknown             :=	INT#-1,     //
        NoError             :=	INT#0,      //	No error.
        HardwareIDInvalid   :=	INT#-32642, //	The address is unknown.
        HardwareIDisInvalid   :=	INT#-32624, //	The address is unknown.
        OutOfResources      :=	INT#-32575  //	All diagnostic resources are currently in use    
        ) := Unknown;
    END_TYPE
END_NAMESPACE

