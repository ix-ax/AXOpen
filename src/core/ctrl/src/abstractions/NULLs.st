USING AXOpen.Messaging;
USING AXOpen.Logging;
USING AXOpen.Rtc;
NAMESPACE AXOpen.Core
    ///<summary>
    /// Provides an empty context for uninitialized objects.
    ///</summary>
    CLASS PUBLIC _NULL_CONTEXT IMPLEMENTS IAxoContext
        VAR PRIVATE            
            NULL_RTC : _NULL_RTC;
            NULL_LOGGER : _NULL_LOGGER;
        END_VAR

        METHOD PUBLIC CreateIdentity : ULINT CreateIdentity := ULINT#0; END_METHOD
        METHOD PUBLIC OpenCycleCount : ULINT OpenCycleCount := ULINT#0; END_METHOD                                         
        METHOD PUBLIC GetRtc : IAxoRtc GetRtc := NULL_RTC; END_METHOD
        METHOD PUBLIC InjectRtc VAR_INPUT Rtc : IAxoRtc; END_VAR ; END_METHOD  
        METHOD PUBLIC GetLogger : IAxoLogger GetLogger :=  NULL_LOGGER; END_METHOD
        METHOD PUBLIC InjectLogger VAR_INPUT _logger : IAxoLogger; END_VAR ; END_METHOD           
    END_CLASS    

    ///<summary>
    /// Provides an empty object for uninitialized objects.
    ///</summary>
    CLASS PUBLIC _NULL_OBJECT IMPLEMENTS IAxoObject
        VAR PRIVATE
            NULL_CONTEXT : _NULL_CONTEXT;
        END_VAR    
        METHOD PUBLIC GetIdentity : ULINT 
            GetIdentity := ULINT#0; 
        END_METHOD   
        METHOD PUBLIC GetContext : IAxoContext 
            GetContext := NULL_CONTEXT; 
        END_METHOD
    END_CLASS    

    ///<summary>
    /// Provides an empty RTC object for uninitialized RTC.
    ///</summary>
    CLASS PUBLIC _NULL_RTC IMPLEMENTS IAxoRtc
        VAR PRIVATE
            _null_time : LDATE_AND_TIME := LDATE_AND_TIME#1970-01-01-00:00:00.000;
        END_VAR
        METHOD PUBLIC NowUTC : LDATE_AND_TIME
            NowUTC := _null_time;
        END_METHOD
    END_CLASS    

    ///<summary>
    /// Provides an empty logger object for uninitialized context logger.
    ///</summary>
    CLASS PUBLIC _NULL_LOGGER IMPLEMENTS IAxoLogger                   
        METHOD PUBLIC Log 
            VAR_INPUT
                _message : STRING[80];
                _level : eLogLevel;
                _sender : IAxoObject;
            END_VAR
            ;                         
        END_METHOD   
        
        METHOD PUBLIC Log 
            VAR_INPUT
                _message : STRING[80];
                _level : eLogLevel;             
            END_VAR
            ;                         
        END_METHOD   
    END_CLASS    
END_NAMESPACE
    