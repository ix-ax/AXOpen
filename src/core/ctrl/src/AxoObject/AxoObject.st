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

        VAR PROTECTED           
            _parent         : IAxoObject;
            _context_       : IAxoContext;
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
                inParent : IAxoObject;
            END_VAR                           
                       
            IF(inParent <> NULL) THEN
                _context_    := inParent.GetContext();                 
                _parent     := inParent;
                RETURN;                 
            END_IF;            
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
         
            
            IF(inContext <> NULL) THEN
                _context_    := inContext;                 
            END_IF;
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

            IF(_context_ = NULL) THEN                 
                RETURN; 
            END_IF;

            IF(_lastMessageAggregationCycle <> _context_.OpenCycleCount()) THEN
                THIS.MsgCnt := LINT#0;
            END_IF;    

            IF(inCount = 0) THEN
                IF(_parent <> NULL && THIS._parent <> THIS._parent.GetParent()) THEN                    
                    THIS._parent.AggregateMessage(inCount);
                END_IF;    
                RETURN;
            END_IF;    
            
            THIS.MsgCnt := inCount + THIS.MsgCnt;    
                      
            IF(_parent <> NULL && THIS._parent <> THIS._parent.GetParent()) THEN
                THIS._parent.AggregateMessage(inCount);
            END_IF;    

            _lastMessageAggregationCycle := _context_.OpenCycleCount();  
        END_METHOD    
    END_CLASS    
END_NAMESPACE    
