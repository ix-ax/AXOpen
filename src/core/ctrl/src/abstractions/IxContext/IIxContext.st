NAMESPACE ix.framework.core
    INTERFACE IIxContext       
        METHOD CreateIdentity : ULINT END_METHOD
        METHOD OpenCycleCount : ULINT END_METHOD   
        METHOD Environment : IIxContextEnvironment END_METHOD
        METHOD RealTimeClock : IIxRtc END_METHOD
    END_INTERFACE    
END_NAMESPACE

