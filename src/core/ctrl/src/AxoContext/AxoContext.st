USING AXOpen.Messaging.Static;
USING AXOpen.Messaging.Static;
USING AXOpen.Messaging.Static;
USING AXOpen.Messaging;
USING AXOpen.Rtc;
USING AXOpen.Logging;
USING AXOpen.Rtm;

NAMESPACE AXOpen.Core
    ///<summary>
    /// Provides base for contextualized entry of `AXOpen` application.
    /// This class is abstract and must be inherited.
    ///</summary>
    {S7.extern=ReadWrite}
    CLASS PUBLIC ABSTRACT AxoContext IMPLEMENTS IAxoContext        
        VAR PRIVATE                        
            _openCounter : ULINT;
            _closeCounter : ULINT;
            _identityCounter : ULINT; 
            {#ix-set:AttributeName = "<#Messenger 1 - activate using 'Activate' method called inside the if statement#>"}
            {#ix-set:PlcTextList = "[1]:'<#Invalid Rtm.#>':'<#This is most likely programming error. Make sure the context is injected with valid Rtm instance.#>';
                                    [2]:'<#Invalid Logger.#>':'<#This is most likely programming error. Make sure the context is injected with valid Logger instance.#>';
                                    [3]:'<#Invalid Rtc.#>':'<#This is most likely programming error. Make sure the context is injected with valid Logger instance.#>';"}                                   
            _messenger : AxoMessenger;
         END_VAR       

        ///<summary>
        /// The entry point for the context. The call tree of the context start here and all the logic of given context 
        /// must be placed here.  
        /// This method must be overridden in derived class.
        ///</summary>
        METHOD PROTECTED ABSTRACT Main END_METHOD
        
            
        METHOD PROTECTED Open : ULINT
            _openCounter := _openCounter + ULINT#1;
        END_METHOD    

        METHOD PROTECTED Close : ULINT
            _closeCounter := _closeCounter + ULINT#1;
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
        /// Gets whether this context is valid.
        ///</summary>
        METHOD PUBLIC IsValid : BOOL
            IsValid := TRUE;            
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
                _messenger.Activate(ULINT#3, AXOpen.Messaging.eAxoMessageCategory#ProgrammingError);
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
            IF(_rtc <> NULL) THEN
                GetRtm := _rtm;
            ELSE
                _messenger.Activate(ULINT#1, AXOpen.Messaging.eAxoMessageCategory#ProgrammingError);
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
                _messenger.Activate(ULINT#2, AXOpen.Messaging.eAxoMessageCategory#ProgrammingError);
                GetLogger := NULL_LOGGER;    
            END_IF;    
        END_METHOD
        
        METHOD PUBLIC InjectLogger
            VAR_INPUT
                _logger : IAxoLogger;
            END_VAR
            _contextLogger := _logger;
        END_METHOD            

        VAR PROTECTED
            // NULL_MESSENGER_SERVICE : _NULL_MESSENGER_SERVICE;
            NULL_MESSENGER_SERVICE : IAxoMessagingServices;
            _messengerService : IAxoMessagingServices;
        END_VAR    
        METHOD PUBLIC InjectMessengerService
            VAR_INPUT
                inMessengerService : IAxoMessagingServices;
            END_VAR
            IF(inMessengerService <> NULL) THEN
                _messengerService := inMessengerService;
            END_IF;                        
        END_METHOD  

        METHOD PUBLIC GetMessengerService : IAxoMessagingServices
            IF(_messengerService = NULL) THEN                
                GetMessengerService := NULL_MESSENGER_SERVICE;    
                RETURN; 
            END_IF;    
            GetMessengerService := _messengerService;
        END_METHOD
    END_CLASS          
END_NAMESPACE
