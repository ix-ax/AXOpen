USING AXOpen.Rtc;

NAMESPACE AXOpen.Core      
    ///<summary>
    /// Provides base class for all classes of `AXOpen`.
    ///</summary>
    CLASS PUBLIC AxoObject IMPLEMENTS IAxoObject
        VAR PUBLIC
            {#ix-attr:[CompilerOmits("POCO")]}     
            {#ix-attr:[IgnoreOnPocoOperation()]}  
            {#ix-attr:[RenderIgnore()]}
            Identity   : ULINT := ULINT#0;                                            
        END_VAR    

        VAR PROTECTED           
            _parent     : IAxoObject;
            _context_    : IAxoContext;
        END_VAR  
        
        VAR PRIVATE  
            {#ix-attr:[CompilerOmits()]}           
            NULL_CONTEXT : _NULL_CONTEXT;
            {#ix-attr:[CompilerOmits()]}  
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
            IF(_context_ <> NULL) THEN
                GetContext := _context_;
            ELSE
                GetContext := NULL_CONTEXT;                    
            END_IF;    
        END_METHOD

        ///<summary>
        /// Gets context in which this object was initialized.
        ///</summary>
        METHOD PUBLIC GetContextUnsafe : IAxoContext
            GetContextUnsafe := _context_;
        END_METHOD

        ///<summary>
        /// Gets parent in which this object was initialized.
        ///</summary>
        METHOD PUBLIC GetParent : IAxoObject
            IF(_context_ <> NULL) THEN
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
            // CHANGE: Identity is now provided by the higher level application.
            IF(parent <> NULL) THEN
                _context_    := parent.GetContext();                 
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
            // CHANGE: Identity is now provided by the higher level application.
            IF(context <> NULL) THEN
                _context_    := context;                 
            END_IF;
        END_METHOD       
    END_CLASS    
END_NAMESPACE    