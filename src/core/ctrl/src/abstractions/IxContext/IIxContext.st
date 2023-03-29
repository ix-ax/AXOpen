USING ix.framework.rtc;
NAMESPACE ix.framework.core
    INTERFACE IIxContext       
        METHOD CreateIdentity : ULINT END_METHOD
        METHOD OpenCycleCount : ULINT END_METHOD          
        METHOD GetRtc : IRtc END_METHOD
        METHOD InjectRtc VAR_INPUT Rtc : IRtc; END_VAR END_METHOD
    END_INTERFACE    
END_NAMESPACE

