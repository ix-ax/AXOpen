USING AXOpen.Messaging;
USING AXOpen.Messaging.Static;
USING AXOpen.Logging;
USING AXOpen.Rtc;
USING AXOpen.Rtm;

NAMESPACE AXOpen.Core
    ///<summary>
    /// Provides an empty context for uninitialized objects.
    ///</summary>    
    CLASS PUBLIC _NULL_CONTEXT IMPLEMENTS IAxoContext
        VAR PRIVATE
            {S7.extern=Hidden}            
            NULL_RTC : _NULL_RTC;
            {S7.extern=Hidden}
            NULL_LOGGER : _NULL_LOGGER;
            {S7.extern=Hidden}
            NULL_RTM : _NULL_RTM;
            {S7.extern=ReadWrite}
            _SYSTEM_LOGGER_ : AxoLogger;
        END_VAR

        ///<summary>
        /// Gets whether this context is valid.
        ///</summary>
        METHOD PUBLIC IsValid : BOOL
            IsValid := FALSE;            
        END_METHOD
    
        METHOD PUBLIC CreateIdentity : ULINT CreateIdentity := ULINT#0; END_METHOD
        METHOD PUBLIC OpenCycleCount : ULINT OpenCycleCount := ULINT#0; END_METHOD                                         
        METHOD PUBLIC GetRtc : IAxoRtc GetRtc := NULL_RTC; END_METHOD
        METHOD PUBLIC InjectRtc VAR_INPUT Rtc : IAxoRtc; END_VAR ; END_METHOD  
        METHOD PUBLIC GetLogger : IAxoLogger GetLogger :=  NULL_LOGGER; END_METHOD
        METHOD PUBLIC InjectLogger VAR_INPUT _logger : IAxoLogger; END_VAR ; END_METHOD           
        METHOD PUBLIC GetRtm : IAxoRtm GetRtm :=  NULL_RTM; END_METHOD
        METHOD PUBLIC InjectRtm VAR_INPUT rtm : IAxoRtm; END_VAR ; END_METHOD           
        METHOD PUBLIC InitializeRootObject VAR_IN_OUT inoRootObject : AxoObject; END_VAR ; END_METHOD

        METHOD PUBLIC Detector 
            VAR_INPUT
                object : IAxoObject;
            END_VAR                
            _SYSTEM_LOGGER_.Log('Attemt to acccess context', AXOpen.Logging.eLogLevel#Fatal, object);
        END_METHOD    

    END_CLASS    


    
    ///<summary>
    /// Provides an empty object for uninitialized objects.
    ///</summary>    
    CLASS PUBLIC _NULL_OBJECT IMPLEMENTS IAxoObject
        VAR PRIVATE
            {S7.extern=Hidden}
            NULL_CONTEXT : _NULL_CONTEXT;
        END_VAR    
        METHOD PUBLIC GetIdentity : ULINT 
            GetIdentity := ULINT#0; 
        END_METHOD   
        METHOD PUBLIC GetContext : IAxoContext 
            GetContext := NULL_CONTEXT; 
        END_METHOD
        METHOD PUBLIC GetContextUnsafe : IAxoContext            
            GetContextUnsafe := NULL_CONTEXT;            
        END_METHOD
        METHOD PUBLIC AggregateMessage
            VAR_INPUT
                Message : AXOpen.Core.IAxoMessenger;
            END_VAR    
            ;
        END_METHOD

        METHOD PUBLIC AggregateMessage
            VAR_INPUT
                inCount : ULINT;
            END_VAR                
            ;
        END_METHOD    
    
        METHOD PUBLIC AggregateMessage
            VAR_INPUT
                inCount : LINT;
            END_VAR
            ;
        END_METHOD
    
        METHOD PUBLIC GetParent : IAxoObject
            GetParent := THIS;
        END_METHOD
    
        ///<summary>
        /// Gets whether this object is valid.
        ///</summary>
        METHOD PUBLIC IsValid : BOOL
            IsValid := FALSE;
        END_METHOD
    END_CLASS    

    ///<summary>
    /// Provides an empty RTC object for uninitialized RTC.
    ///</summary>
    {S7.extern=ReadWrite}
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
    {S7.extern=ReadWrite}
    CLASS PUBLIC _NULL_LOGGER IMPLEMENTS IAxoLogger                   
        METHOD PUBLIC Log 
            VAR_INPUT
                _message : STRING[254];
                _level : eLogLevel;
                _sender : IAxoObject;
            END_VAR   
            ;         
        END_METHOD   
               
        METHOD PUBLIC Log 
            VAR_INPUT
                _message : STRING[254];
                _level : eLogLevel;             
            END_VAR
            ;                         
        END_METHOD 
        
        METHOD PUBLIC SetMinimumLevel : IAxoLoggerConfig
            VAR_INPUT
                _level : eLogLevel;  
            END_VAR 
            ;           
        END_METHOD
    END_CLASS    


    ///<summary>
    /// Provides an empty RTC object for uninitialized RTC.
    ///</summary>
    {S7.extern=ReadWrite}
    CLASS PUBLIC _NULL_RTM IMPLEMENTS IAxoRtm
        VAR PRIVATE
            _null_time : LTIME;
        END_VAR
           
        METHOD PUBLIC Elapsed : LTIME
            Elapsed := _null_time;
        END_METHOD
    END_CLASS 
    
    
END_NAMESPACE
    
