USING AXOpen.Messaging.Static;
USING AXOpen.Rtc;

NAMESPACE AXOpen.Core      
    ///<summary>
    /// Provides base class for all classes of `AXOpen`.
    ///</summary>
    {S7.extern=ReadWrite}
    CLASS PUBLIC AxoObject IMPLEMENTS IAxoObject
        VAR PUBLIC
            {#ix-attr:[CompilerOmits("POCO")]}     
            {#ix-attr:[IgnoreOnPocoOperation()]}  
            {#ix-attr:[RenderIgnore()]}
            Identity   : ULINT := ULINT#0;    
            
            {#ix-attr:[CompilerOmits("POCO")]}     
            {#ix-attr:[IgnoreOnPocoOperation()]}  
            {#ix-attr:[RenderIgnore()]}
            MsgCnt   : LINT := LINT#0;    
        END_VAR    

        VAR PRIVATE           
            _parent         : IAxoObject;
            _context        : IAxoContext;
            _isInitialized  : BOOL;
            _errorState     : UINT;  
        END_VAR  
        
        VAR PRIVATE  
            {#ix-attr:[CompilerOmits()]}  
            {S7.extern=Hidden}         
            NULL_CONTEXT : _NULL_CONTEXT;
            {#ix-attr:[CompilerOmits()]}  
            {S7.extern=Hidden}
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
                // TODO provide some message 
                GetContext := NULL_CONTEXT;                    
            END_IF;    
        END_METHOD

        ///<summary>
        /// Gets context in which this object was initialized.
        ///</summary>
        METHOD PUBLIC GetContextUnsafe : IAxoContext
            GetContextUnsafe := _context;
        END_METHOD

        ///<summary>
        /// Gets parent in which this object was initialized.
        ///</summary>
        METHOD PUBLIC GetParent : IAxoObject
            IF(_context <> NULL) THEN
                GetParent := _parent;
            ELSE
                // TODO provide some message 
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
                inParent : IAxoObject;
            END_VAR                           
                     
            VAR
                NULL_CONTEXT_OBJ    : IAxoObject;
            END_VAR

            IF _isInitialized THEN
                RETURN;
            END_IF;

            IF(inParent = NULL) THEN
                // TODO provide some message 
                _errorState := UINT#20;
                RETURN;
            END_IF;

            NULL_CONTEXT_OBJ ?= NULL_CONTEXT;
            IF(inParent.GetContext() = NULL_CONTEXT_OBJ) THEN
                // TODO provide some message 
                _errorState := UINT#30;
                RETURN;
            END_IF;

            IF(inParent = _parent) THEN
                // TODO provide some message 
                _errorState := UINT#40;
                RETURN;
            END_IF;

            _context        := inParent.GetContext();                 
            _parent         := inParent;
            _isInitialized  := TRUE;
            
        END_METHOD  
        
        ///<summary>
        /// Initializes this object associating it given context. 
        /// This method should be called only once upon the program start.
        /// Any subsequent call are ignored.
        ///</summary>
        METHOD PUBLIC InitializeWithContext
            VAR_INPUT
                inContext : IAxoContext;
            END_VAR   
         
            IF _isInitialized THEN
                RETURN;
            END_IF;

            IF(inContext = NULL) THEN
                // TODO provide some message 
                _errorState := UINT#10;
                RETURN;
            END_IF;
            
            _context        := inContext;                 
            _isInitialized  := TRUE;

        END_METHOD   
        
        VAR
            _lastMessageAggregationCycle : ULINT;
        END_VAR    
        
        ///<summary>
        /// Aggregates message count for this object and all parent objects in the generation of this object.
        ///</summary>
        METHOD PUBLIC AggregateMessage
            VAR_INPUT
                inCount : LINT;
            END_VAR         

            IF(_context = NULL) THEN          
                _context := THIS.GetContext();       
                // RETURN; 
            END_IF;

            IF(_lastMessageAggregationCycle <> _context.OpenCycleCount()) THEN
                THIS.MsgCnt := LINT#0;
            END_IF;    

            IF(inCount = 0) THEN
                IF(_parent <> NULL) THEN
                    THIS._parent.AggregateMessage(inCount);
                END_IF;    
                RETURN;
            END_IF;    
            
            THIS.MsgCnt := inCount + THIS.MsgCnt;    
                      
            IF(_parent <> NULL) THEN
                THIS._parent.AggregateMessage(inCount);
            END_IF;    

            _lastMessageAggregationCycle := _context.OpenCycleCount();  
        END_METHOD    
    END_CLASS    
END_NAMESPACE    
