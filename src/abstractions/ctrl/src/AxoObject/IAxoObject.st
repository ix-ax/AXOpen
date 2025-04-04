NAMESPACE AXOpen.Core
  INTERFACE PUBLIC IAxoObject
    METHOD GetIdentity : ULINT  END_METHOD   
    METHOD GetContext : IAxoContext END_METHOD
    METHOD GetContextUnsafe : IAxoContext END_METHOD    
    METHOD AggregateMessage VAR_INPUT inCount : LINT; END_VAR END_METHOD  
    METHOD GetParent : IAxoObject END_METHOD
    ///<summary>
    /// Gets whether this object is valid.
    ///</summary>
    METHOD IsValid : BOOL END_METHOD  
  END_INTERFACE  
END_NAMESPACE

