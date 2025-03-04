USING AXOpen.Rtc;

NAMESPACE AXOpen.Core.Dummies
    ///<summary>
    /// Provides base class for all classes of `AXOpen`.
    ///</summary>
    {S7.extern=ReadWrite}
    CLASS PUBLIC MockAxoObject EXTENDS AxoObject IMPLEMENTS IAxoObject
        METHOD PUBLIC InitializeWithContext_Test
            VAR_INPUT
                inContext : IAxoContext;
            END_VAR   
            SUPER.InitializeWithContext(inContext);
        END_METHOD   
    END_CLASS    
END_NAMESPACE    
