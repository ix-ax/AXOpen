USING AXOpen.Rtc;
NAMESPACE AXOpen.Core
    INTERFACE IAxoContext       
        METHOD CreateIdentity : ULINT END_METHOD
        METHOD OpenCycleCount : ULINT END_METHOD          
        METHOD GetRtc : IAxoRtc END_METHOD
        METHOD InjectRtc VAR_INPUT Rtc : IAxoRtc; END_VAR END_METHOD
        METHOD Environment : IAxoContextEnvironment END_METHOD
        // METHOD SetContextEnvironment VAR_INPUT inContextEnvironnment : IAxoContextEnvironment; END_VAR END_METHOD
    END_INTERFACE    
END_NAMESPACE

