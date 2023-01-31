NAMESPACE ix.framework.core

    FUNCTION IsNullContext : BOOL
        VAR_INPUT
            Context : IContext;
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
    CLASS PUBLIC _NULL_CONTEXT IMPLEMENTS IContext
        METHOD PUBLIC CreateIdentity : ULINT CreateIdentity := ULINT#0; END_METHOD
        METHOD PUBLIC OpenCycleCount : ULINT OpenCycleCount := ULINT#0; END_METHOD                             
    END_CLASS    

    ///<summary>
    /// Provides base class for all classes of `ix.framework`.
    ///</summary>
    CLASS PUBLIC Object IMPLEMENTS IObject
        VAR PRIVATE
            _identity   : ULINT := ULINT#0;
            _parent     : IObject;
            _context    : IContext;
        END_VAR  
        
        VAR PRIVATE
            NULL_CONTEXT : _NULL_CONTEXT;
        END_VAR

        ///<summary>
        /// Gets unique identity of this object in given context.
        ///</summary>
        METHOD PUBLIC GetIdentity : ULINT 
            GetIdentity := _identity;
        END_METHOD
            
        ///<summary>
        /// Gets context in which this object was initialized.
        ///</summary>
        METHOD PUBLIC GetContext : IContext
            IF(_context <> NULL) THEN
                GetContext := _context;
            ELSE
                GetContext := NULL_CONTEXT;    
            END_IF;    
        END_METHOD

        ///<summary>
        /// Initializes this object associating it given parent. 
        /// This method should be called only once upon the program start.
        /// Any subsequent call are ignored.
        ///</summary>
        METHOD PUBLIC Initialize
            VAR_INPUT
                parent : IObject;
            END_VAR   

            IF(_identity = ULINT#0 AND parent <> NULL) THEN
                _context    := parent.GetContext();  
                _identity   := _context.CreateIdentity(); 
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
                context : IContext;
            END_VAR   

            IF(_identity = ULINT#0 AND context <> NULL) THEN
                _context    := context;  
                _identity   := _context.CreateIdentity();                 
            END_IF;

        END_METHOD 
    END_CLASS
END_NAMESPACE    