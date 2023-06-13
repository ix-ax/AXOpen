USING AXOpen.Rtc;

NAMESPACE AXOpen.Core      
    ///<summary>
    /// Provides base class for all classes of `AXOpen`.
    ///</summary>
    CLASS PUBLIC AxoObject IMPLEMENTS IAxoObject
        VAR PUBLIC
            {#ix-attr:[CompilerOmits("POCO")]}
            // {#ix-attr:[ReadOnly()]}
            {#ix-attr:[RenderIgnore()]}
            Identity   : ULINT := ULINT#0;                  
        END_VAR    

        VAR PRIVATE           
            _parent     : IAxoObject;
            _context    : IAxoContext;
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
        METHOD PUBLIC GetContext : IAxoContext
            IF(_context <> NULL) THEN
                GetContext := _context;
            ELSE
                GetContext := NULL_CONTEXT;                    
            END_IF;    
        END_METHOD

        ///<summary>
        /// Gets parent in which this object was initialized.
        ///</summary>
        METHOD PUBLIC GetParent : IAxoObject
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
                parent : IAxoObject;
            END_VAR   

            // IF(Identity = ULINT#0 AND parent <> NULL) THEN
            //     _context    := parent.GetContext();  
            //     Identity   := _context.CreateIdentity(); 
            //     _parent     := parent;
            //     RETURN;                 
            // END_IF;            
            IF(parent <> NULL) THEN
                _context    := parent.GetContext();                 
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
                context : IAxoContext;
            END_VAR   

            // IF(Identity = ULINT#0 AND context <> NULL) THEN
            //     _context    := context;  
            //     Identity   := _context.CreateIdentity();                 
            // END_IF;

            IF(context <> NULL) THEN
                _context    := context;                 
            END_IF;

        END_METHOD       
    END_CLASS    
END_NAMESPACE    