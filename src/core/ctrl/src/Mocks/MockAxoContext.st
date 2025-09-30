
USING AXOpen.Messaging;
USING AXOpen.Logging;
USING AXOpen.Core;
USING AXOpen.Rtm;
USING AXOpen.Rtc;

NAMESPACE AXOpen.Core.Dummies
    ///<summary>
    /// Provides base for contextualized entry of `AXOpen` application.    
    ///</summary>
    {S7.extern=ReadWrite}
    CLASS PUBLIC MockAxoContext IMPLEMENTS IAxoContext        
        VAR PRIVATE                        
            _openCounter : ULINT;
            _closeCounter : ULINT;
            _identityCounter : ULINT;   
            _messagingLevel : eAxoMessageCategory;           
         END_VAR       

        ///<summary>
        /// The entry point for the context. The call tree of the context start here and all the logic of given context 
        /// must be placed here.  
        /// This method must be overridden in derived class.
        ///</summary>
        METHOD PROTECTED Main ; END_METHOD
            
        METHOD PUBLIC Open : ULINT
            _openCounter := _openCounter + ULINT#1;
        END_METHOD    

        METHOD PUBLIC Close : ULINT
            _closeCounter := _closeCounter + ULINT#1;
        END_METHOD
           
        ///<summary>
        /// Gets whether this context is valid.
        ///</summary>
        METHOD PUBLIC IsValid : BOOL
            IsValid := TRUE;            
        END_METHOD
    

        ///<summary>
        /// Runs the cycle of this context. This method must be called cyclically in a PLC task.
        ///</summary>
        METHOD PUBLIC Run
            THIS.Open(); 
            THIS.Main();
            THIS.Close();
        END_METHOD   
        
        ///<summary>
        /// Gets the value of current context cycle counter.
        ///</summary>
        METHOD PUBLIC OpenCycleCount : ULINT
            OpenCycleCount := _openCounter;         
        END_METHOD
                
        METHOD PUBLIC ClosedCycleCount : ULINT
            ClosedCycleCount := _closeCounter;
        END_METHOD

        METHOD PUBLIC CreateIdentity : ULINT            
            _identityCounter := _identityCounter + ULINT#1;
            CreateIdentity := _identityCounter;
        END_METHOD 
        
        METHOD PUBLIC PeekIdentity : ULINT
            PeekIdentity := _identityCounter;
        END_METHOD

        VAR PRIVATE            
            NULL_RTC : _NULL_RTC;
            _rtc : IAxoRtc;
        END_VAR
    
        METHOD PUBLIC GetRtc : IAxoRtc
            IF(_rtc <> NULL) THEN
                GetRtc := _rtc;
            ELSE
                // TODO provide some message 
                GetRtc := NULL_RTC;    
            END_IF;    
        END_METHOD

        METHOD PUBLIC InjectRtc
            VAR_INPUT
                Rtc : IAxoRtc;
            END_VAR
            _rtc := Rtc;
        END_METHOD      


        VAR PRIVATE            
            NULL_RTM : _NULL_RTM;
            _rtm : IAxoRtm;
        END_VAR

        METHOD PUBLIC InjectRtm
            VAR_INPUT
                inRtm : IAxoRtm;
            END_VAR
            _rtm := inRtm;
        END_METHOD

        METHOD PUBLIC GetRtm : IAxoRtm
            IF(_rtm <> NULL) THEN
                GetRtm := _rtm;
            ELSE
                // TODO provide some message 
                GetRtm := NULL_RTM;    
            END_IF;    
        END_METHOD

        VAR PRIVATE            
            NULL_LOGGER : _NULL_LOGGER;
            _contextLogger : IAxoLogger;          
        END_VAR

        METHOD PUBLIC InitializeRootObject
            VAR_IN_OUT
                inoRootObject : AxoObject;
            END_VAR
            inoRootObject.InitializeWithContext(THIS);
        END_METHOD

        METHOD PUBLIC GetLogger : IAxoLogger
            IF(_contextLogger <> NULL) THEN
                GetLogger := _contextLogger;
            ELSE
                // TODO provide some message 
                GetLogger := NULL_LOGGER;    
            END_IF;    
        END_METHOD
        
        METHOD PUBLIC InjectLogger
            VAR_INPUT
                _logger : IAxoLogger;
            END_VAR
            _contextLogger := _logger;
        END_METHOD            
    

        VAR PRIVATE            
            NULL_MESSENGER_SERVICE : _NULL_MESSENGER_SERVICE;
            _messengerService : IAxoMessagingServices;
        END_VAR

        METHOD PUBLIC InjectMessengerService
            VAR_INPUT
                inMessengerService : IAxoMessagingServices;
            END_VAR
            _messengerService := inMessengerService;
        END_METHOD

        METHOD PUBLIC GetMessengerService : IAxoMessagingServices
            IF(_messengerService <> NULL) THEN
                GetMessengerService := _messengerService;
            ELSE
               
                GetMessengerService := NULL_MESSENGER_SERVICE;    
            END_IF;    
        END_METHOD   
    END_CLASS          
END_NAMESPACE
