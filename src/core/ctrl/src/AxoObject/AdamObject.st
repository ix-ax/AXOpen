 NAMESPACE AXOpen.Core 
    ///<summary>
    /// A root object implementation of IAxoObject to serve as an object with context but without inParent.
    /// An instance of this class is used as a inParent for all top-level objects in the context. 
    /// It must be initialized with InitInitializeRootObject method of IAxoContext before use.
    ///</summary>
    {S7.extern=ReadWrite}
    CLASS AdamAxoObject EXTENDS AXOpen.Core.AxoObject        
        VAR
            NULL_OBJECT : _NULL_OBJECT;
        END_VAR 
        METHOD PUBLIC OVERRIDE GetParent : IAxoObject                        
            GetParent := NULL_OBJECT;
        END_METHOD    
    END_CLASS
END_NAMESPACE