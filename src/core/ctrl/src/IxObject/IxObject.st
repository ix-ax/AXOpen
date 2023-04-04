USING ix.framework.rtc;

NAMESPACE ix.framework.core

    FUNCTION IsNullContext : BOOL
        VAR_INPUT
            Context : IIxContext;
        END_VAR
        IF Context = NULL THEN
            IsNullContext := TRUE;
        ELSIF Context.CreateIdentity() = ULINT#0 THEN
            IsNullContext := TRUE;
        ELSE
            IsNullContext := FALSE;
        END_IF;
    END_FUNCTION

    ///<summary>
    /// Provides an empty context for uninitialized objects.
    ///</summary>
    CLASS PUBLIC _NULL_CONTEXT IMPLEMENTS IIxContext
        VAR PRIVATE            
            NULL_RTC : _NULL_RTC;
        END_VAR

        METHOD PUBLIC CreateIdentity : ULINT CreateIdentity := ULINT#0; END_METHOD
        METHOD PUBLIC OpenCycleCount : ULINT OpenCycleCount := ULINT#0; END_METHOD                                         
        METHOD PUBLIC GetRtc : IRtc GetRtc := NULL_RTC; END_METHOD
        METHOD PUBLIC InjectRtc VAR_INPUT Rtc : IRtc; END_VAR ; END_METHOD
        
        METHOD PUBLIC Environment : IIxContextEnvironment
            ;
        END_METHOD
    END_CLASS    

    ///<summary>
    /// Provides an empty object for uninitialized objects.
    ///</summary>
    CLASS PUBLIC _NULL_OBJECT IMPLEMENTS IIxObject
        VAR PRIVATE
            NULL_CONTEXT : _NULL_CONTEXT;
        END_VAR    
        METHOD PUBLIC GetIdentity : ULINT 
            GetIdentity := ULINT#0; 
        END_METHOD   
        METHOD PUBLIC GetContext : IIxContext 
            GetContext := NULL_CONTEXT; 
        END_METHOD
    END_CLASS    

    ///<summary>
    /// Provides base class for all classes of `ix.framework`.
    ///</summary>
    CLASS PUBLIC IxObject IMPLEMENTS IIxObject
        VAR PUBLIC
            {#ix-attr:[CompilerOmits("POCO")]}
            {#ix-attr:[ReadOnly()]}
            Identity   : ULINT := ULINT#0;
        END_VAR    

        VAR PRIVATE           
            _parent     : IIxObject;
            _context    : IIxContext;
        END_VAR  
        
        VAR PRIVATE            
            NULL_CONTEXT : _NULL_CONTEXT;
            NULL_OBJECT : _NULL_OBJECT;
        END_VAR

        ///<summary>
        /// Gets unique identity of this object in given context.
        ///</summary>
        METHOD PUBLIC GetIdentity : ULINT 
            GetIdentity := Identity;
        END_METHOD
            
        ///<summary>
        /// Gets context in which this object was initialized.
        ///</summary>
        METHOD PUBLIC GetContext : IIxContext
            IF(_context <> NULL) THEN
                GetContext := _context;
            ELSE
                GetContext := NULL_CONTEXT;    
            END_IF;    
        END_METHOD

        ///<summary>
        /// Gets parent in which this object was initialized.
        ///</summary>
        METHOD PUBLIC GetParent : IIxObject
            IF(_context <> NULL) THEN
                GetParent := _parent;
            ELSE
                GetParent := NULL_OBJECT;    
            END_IF;    
        END_METHOD

        ///<summary>
        /// Initializes this object associating it given parent. 
        /// This method should be called only once upon the program start.
        /// Any subsequent call are ignored.
        ///</summary>
        METHOD PUBLIC Initialize
            VAR_INPUT
                parent : IIxObject;
            END_VAR   

            IF(Identity = ULINT#0 AND parent <> NULL) THEN
                _context    := parent.GetContext();  
                Identity   := _context.CreateIdentity(); 
                _parent     := parent;
                RETURN;                 
            END_IF;

        END_METHOD  
        
        ///<summary>
        /// Initializes this object associating it given context. 
        /// This method should be called only once upon the program start.
        /// Any subsequent call are ignored.
        ///</summary>
        METHOD PUBLIC Initialize
            VAR_INPUT
                context : IIxContext;
            END_VAR   

            IF(Identity = ULINT#0 AND context <> NULL) THEN
                _context    := context;  
                Identity   := _context.CreateIdentity();                 
            END_IF;

        END_METHOD 

        METHOD PUBLIC Environment : IIxContextEnvironment
            Environment := THIS.GetContext().Environment();
        END_METHOD

        // METHOD PUBLIC SetContextEnvironment
        //     VAR_INPUT
        //         inContextEnvironnment : IIxContextEnvironment;
        //     END_VAR
        //     _contextEnvironment := inContextEnvironnment;
        // END_METHOD
    END_CLASS    
END_NAMESPACE    