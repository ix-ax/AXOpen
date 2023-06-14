USING AXOpen.Rtc;
USING AXOpen.Logging;
NAMESPACE AXOpen.Core
    INTERFACE PUBLIC IAxoContext       
        METHOD CreateIdentity : ULINT END_METHOD
        METHOD OpenCycleCount : ULINT END_METHOD          
        METHOD GetRtc : IAxoRtc END_METHOD
        METHOD InjectRtc VAR_INPUT Rtc : IAxoRtc; END_VAR END_METHOD        
        METHOD GetLogger : IAxoLogger  END_METHOD
        METHOD InjectLogger VAR_INPUT _logger : IAxoLogger; END_VAR END_METHOD           
    END_INTERFACE    
END_NAMESPACE

