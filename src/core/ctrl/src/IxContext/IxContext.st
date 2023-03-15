NAMESPACE ix.framework.core
    ///<summary>
    /// Provides base for contextualized entry of `ix.framework` application.
    /// This class is abstract and must be inherited.
    ///</summary>
    CLASS PUBLIC ABSTRACT IxContext IMPLEMENTS IIxContext        
        VAR PRIVATE                        
            _openCounter : ULINT;
            _closeCounter : ULINT;
            _identityCounter : ULINT;
            _environment : IxContextEnvironment;	            
            _rtc : IxRtc;	            
        END_VAR       

        ///<summary>
        /// The entry point for the context. The call tree of the context start here and all the logic of given context 
        /// must be placed here.  
        /// This method must be overridden in derived class.
        ///</summary>
        METHOD PROTECTED ABSTRACT Main END_METHOD
        
            
        METHOD PRIVATE Open : ULINT
            _openCounter := _openCounter + ULINT#1;
        END_METHOD    

        METHOD PRIVATE Close : ULINT
            _closeCounter := _closeCounter + ULINT#1;
        END_METHOD

        METHOD PUBLIC Environment : IIxContextEnvironment
            Environment := _environment;
        END_METHOD   

        METHOD PUBLIC RealTimeClock : IIxRtc 
            RealTimeClock := _rtc;
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
            _rtc.UpdateInternal();
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

    END_CLASS    
END_NAMESPACE
