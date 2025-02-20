
USING AXOpen.Messaging;
USING AXOpen.Logging;
USING AXOpen.Core;
USING AXOpen.Rtm;
USING AXOpen.Rtc;

NAMESPACE AXOpen.Core.Dummies
    ///<summary>
    /// Provides base for contextualized entry of `AXOpen` application.
    /// This class is abstract and must be inherited.
    ///</summary>
    {S7.extern=ReadWrite}
    CLASS PUBLIC ABSTRACT MockAxoContext IMPLEMENTS IAxoContext        
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
        METHOD PROTECTED ABSTRACT Main END_METHOD
        
            
        METHOD PUBLIC Open : ULINT
            _openCounter := _openCounter + ULINT#1;
        END_METHOD    

        METHOD PUBLIC Close : ULINT
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
            NULL_LOGGER : _NULL_LOGGER;
        END_VAR    
        METHOD PUBLIC GetLogger : IAxoLogger GetLogger := NULL_LOGGER; END_METHOD
        METHOD PUBLIC InjectLogger VAR_INPUT _logger : IAxoLogger; END_VAR ; END_METHOD    
            
        VAR PRIVATE
            NULL_RTM : _NULL_RTM;
            _rtm : IAxoRtm;
        END_VAR    
        METHOD PUBLIC GetRtm : AXOpen.Rtm.IAxoRtm 
            IF(_rtm = NULL) THEN 
                GetRtm := NULL_RTM; 
            ELSE 
                GetRtm := _rtm; 
            END_IF; 
        END_METHOD
        METHOD PUBLIC InjectRtm 
            VAR_INPUT 
                inRtm : AXOpen.Rtm.IAxoRtm;
            END_VAR 
            _rtm := inRtm; 
        END_METHOD            
    END_CLASS          
END_NAMESPACE
